Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E91CDBE71
	for <mm-commits@vger.kernel.org>; Tue, 26 Mar 2024 18:30:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711477832; cv=none; b=UlKd1rrmzyfKJvxgUFHRDK4wkrNWBVGCIUUnVm2OGOTDdb2xlWWvv2bnHYmnv0ka2wbIXtj1vy5uS3JyiNnXazGwZO+cC3Zno1qM6S8odK+ObHLtx0nS5iRoArDZdTxpMvRxveoaqdHkDl0ba6wKUAuge+BgrMs+p2bepW9E1KA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711477832; c=relaxed/simple;
	bh=URvJUf69VfZdlQyQG048xwWcHLzzA7R2k7SLbuYkkvQ=;
	h=Date:To:From:Subject:Message-Id; b=gQ6bJv3cQHmz40pgJhd+Eh/2+KFPxraJkzRTLT0m16+njMaSbSbf66kCJrno7sJY2pvtsxICNm90kGfCYPIUd6bBrwnJqFu6vLgHNp0gH6s1JR/E4MvjeY9LUQdSvegQ+1e96PvYr6ikIKulGww93KFhkB8rmHVXhG5Dz2sI6W4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Dc5gf643; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Dc5gf643"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C5E6C43390;
	Tue, 26 Mar 2024 18:30:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1711477831;
	bh=URvJUf69VfZdlQyQG048xwWcHLzzA7R2k7SLbuYkkvQ=;
	h=Date:To:From:Subject:From;
	b=Dc5gf6431av0/GqdjwdQO+ma+AvD9CDJGMYSb4fH32ifaMRPdypJQ+EN4fM/T23KS
	 XsQ5ab/5CiQHsPSLSfv18Pj2XBJmPxsRk4SgcikdUTRaDybcry7hS0VzoKsSHdzWgQ
	 Fm44mPo/BRXziBU/5dpINDIKp3NmHcOex1YtNumw=
Date: Tue, 26 Mar 2024 11:30:30 -0700
To: mm-commits@vger.kernel.org,svetly.todorov@memverge.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + proc-rewrite-stable_page_flags.patch added to mm-unstable branch
Message-Id: <20240326183031.5C5E6C43390@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: proc: rewrite stable_page_flags()
has been added to the -mm mm-unstable branch.  Its filename is
     proc-rewrite-stable_page_flags.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/proc-rewrite-stable_page_flags.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: proc: rewrite stable_page_flags()
Date: Tue, 26 Mar 2024 17:10:32 +0000

Reduce the usage of PageFlag tests and reduce the number of
compound_head() calls.

For multi-page folios, we'll now show all pages as having the flags that
apply to them, e.g.  if it's dirty, all pages will have the dirty flag set
instead of just the head page.  The mapped flag is still per page, as is
the hwpoison flag.

Link: https://lkml.kernel.org/r/20240326171045.410737-11-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Svetly Todorov <svetly.todorov@memverge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/page.c             |   66 ++++++++++++++++++-----------------
 include/linux/huge_mm.h    |    4 +-
 include/linux/page-flags.h |    2 -
 3 files changed, 38 insertions(+), 34 deletions(-)

--- a/fs/proc/page.c~proc-rewrite-stable_page_flags
+++ a/fs/proc/page.c
@@ -107,10 +107,13 @@ static inline u64 kpf_copy_bit(u64 kflag
 	return ((kflags >> kbit) & 1) << ubit;
 }
 
-u64 stable_page_flags(struct page *page)
+u64 stable_page_flags(const struct page *page)
 {
-	u64 k;
-	u64 u;
+	const struct folio *folio;
+	unsigned long k;
+	unsigned long mapping;
+	bool is_anon;
+	u64 u = 0;
 
 	/*
 	 * pseudo flag: KPF_NOPAGE
@@ -118,49 +121,47 @@ u64 stable_page_flags(struct page *page)
 	 */
 	if (!page)
 		return 1 << KPF_NOPAGE;
+	folio = page_folio(page);
 
-	k = page->flags;
-	u = 0;
+	k = folio->flags;
+	mapping = (unsigned long)folio->mapping;
+	is_anon = mapping & PAGE_MAPPING_ANON;
 
 	/*
 	 * pseudo flags for the well known (anonymous) memory mapped pages
 	 */
 	if (page_mapped(page))
 		u |= 1 << KPF_MMAP;
-	if (PageAnon(page))
+	if (is_anon) {
 		u |= 1 << KPF_ANON;
-	if (PageKsm(page))
-		u |= 1 << KPF_KSM;
+		if (mapping & PAGE_MAPPING_KSM)
+			u |= 1 << KPF_KSM;
+	}
 
 	/*
 	 * compound pages: export both head/tail info
 	 * they together define a compound page's start/end pos and order
 	 */
-	if (PageHead(page))
-		u |= 1 << KPF_COMPOUND_HEAD;
-	if (PageTail(page))
+	if (page == &folio->page)
+		u |= kpf_copy_bit(k, KPF_COMPOUND_HEAD, PG_head);
+	else
 		u |= 1 << KPF_COMPOUND_TAIL;
-	if (PageHuge(page))
+	if (folio_test_hugetlb(folio))
 		u |= 1 << KPF_HUGE;
 	/*
-	 * PageTransCompound can be true for non-huge compound pages (slab
-	 * pages or pages allocated by drivers with __GFP_COMP) because it
-	 * just checks PG_head/PG_tail, so we need to check PageLRU/PageAnon
+	 * We need to check PageLRU/PageAnon
 	 * to make sure a given page is a thp, not a non-huge compound page.
 	 */
-	else if (PageTransCompound(page)) {
-		struct page *head = compound_head(page);
-
-		if (PageLRU(head) || PageAnon(head))
+	else if (folio_test_large(folio)) {
+		if ((k & PG_lru) || is_anon)
 			u |= 1 << KPF_THP;
-		else if (is_huge_zero_page(head)) {
+		else if (is_huge_zero_page(&folio->page)) {
 			u |= 1 << KPF_ZERO_PAGE;
 			u |= 1 << KPF_THP;
 		}
 	} else if (is_zero_pfn(page_to_pfn(page)))
 		u |= 1 << KPF_ZERO_PAGE;
 
-
 	/*
 	 * Caveats on high order pages: PG_buddy and PG_slab will only be set
 	 * on the head page.
@@ -175,15 +176,15 @@ u64 stable_page_flags(struct page *page)
 	if (PageTable(page))
 		u |= 1 << KPF_PGTABLE;
 
-	if (page_is_idle(page))
+#if defined(CONFIG_PAGE_IDLE_FLAG) && defined(CONFIG_64BIT)
+	u |= kpf_copy_bit(k, KPF_IDLE,          PG_idle);
+#else
+	if (folio_test_idle(folio))
 		u |= 1 << KPF_IDLE;
+#endif
 
 	u |= kpf_copy_bit(k, KPF_LOCKED,	PG_locked);
-
 	u |= kpf_copy_bit(k, KPF_SLAB,		PG_slab);
-	if (PageTail(page) && PageSlab(page))
-		u |= 1 << KPF_SLAB;
-
 	u |= kpf_copy_bit(k, KPF_ERROR,		PG_error);
 	u |= kpf_copy_bit(k, KPF_DIRTY,		PG_dirty);
 	u |= kpf_copy_bit(k, KPF_UPTODATE,	PG_uptodate);
@@ -194,7 +195,8 @@ u64 stable_page_flags(struct page *page)
 	u |= kpf_copy_bit(k, KPF_ACTIVE,	PG_active);
 	u |= kpf_copy_bit(k, KPF_RECLAIM,	PG_reclaim);
 
-	if (PageSwapCache(page))
+#define SWAPCACHE ((1 << PG_swapbacked) | (1 << PG_swapcache))
+	if ((k & SWAPCACHE) == SWAPCACHE)
 		u |= 1 << KPF_SWAPCACHE;
 	u |= kpf_copy_bit(k, KPF_SWAPBACKED,	PG_swapbacked);
 
@@ -202,7 +204,10 @@ u64 stable_page_flags(struct page *page)
 	u |= kpf_copy_bit(k, KPF_MLOCKED,	PG_mlocked);
 
 #ifdef CONFIG_MEMORY_FAILURE
-	u |= kpf_copy_bit(k, KPF_HWPOISON,	PG_hwpoison);
+	if (u & KPF_HUGE)
+		u |= kpf_copy_bit(k, KPF_HWPOISON,	PG_hwpoison);
+	else
+		u |= kpf_copy_bit(page->flags, KPF_HWPOISON,	PG_hwpoison);
 #endif
 
 #ifdef CONFIG_ARCH_USES_PG_UNCACHED
@@ -228,7 +233,6 @@ static ssize_t kpageflags_read(struct fi
 {
 	const unsigned long max_dump_pfn = get_max_dump_pfn();
 	u64 __user *out = (u64 __user *)buf;
-	struct page *ppage;
 	unsigned long src = *ppos;
 	unsigned long pfn;
 	ssize_t ret = 0;
@@ -245,9 +249,9 @@ static ssize_t kpageflags_read(struct fi
 		 * TODO: ZONE_DEVICE support requires to identify
 		 * memmaps that were actually initialized.
 		 */
-		ppage = pfn_to_online_page(pfn);
+		struct page *page = pfn_to_online_page(pfn);
 
-		if (put_user(stable_page_flags(ppage), out)) {
+		if (put_user(stable_page_flags(page), out)) {
 			ret = -EFAULT;
 			break;
 		}
--- a/include/linux/huge_mm.h~proc-rewrite-stable_page_flags
+++ a/include/linux/huge_mm.h
@@ -351,7 +351,7 @@ vm_fault_t do_huge_pmd_numa_page(struct
 extern struct page *huge_zero_page;
 extern unsigned long huge_zero_pfn;
 
-static inline bool is_huge_zero_page(struct page *page)
+static inline bool is_huge_zero_page(const struct page *page)
 {
 	return READ_ONCE(huge_zero_page) == page;
 }
@@ -480,7 +480,7 @@ static inline vm_fault_t do_huge_pmd_num
 	return 0;
 }
 
-static inline bool is_huge_zero_page(struct page *page)
+static inline bool is_huge_zero_page(const struct page *page)
 {
 	return false;
 }
--- a/include/linux/page-flags.h~proc-rewrite-stable_page_flags
+++ a/include/linux/page-flags.h
@@ -734,7 +734,7 @@ static __always_inline bool PageKsm(cons
 TESTPAGEFLAG_FALSE(Ksm, ksm)
 #endif
 
-u64 stable_page_flags(struct page *page);
+u64 stable_page_flags(const struct page *page);
 
 /**
  * folio_xor_flags_has_waiters - Change some folio flags.
_

Patches currently in -mm which might be from willy@infradead.org are

mm-always-initialise-folio-_deferred_list.patch
mm-create-folio_flag_false-and-folio_type_ops-macros.patch
mm-remove-folio_prep_large_rmappable.patch
mm-support-page_mapcount-on-page_has_type-pages.patch
mm-turn-folio_test_hugetlb-into-a-pagetype.patch
mm-turn-folio_test_hugetlb-into-a-pagetype-fix.patch
mm-remove-a-call-to-compound_head-from-is_page_hwpoison.patch
mm-free-up-pg_slab.patch
mm-free-up-pg_slab-fix.patch
mm-improve-dumping-of-mapcount-and-page_type.patch
hugetlb-remove-mention-of-destructors.patch
sh-remove-use-of-pg_arch_1-on-individual-pages.patch
xtensa-remove-uses-of-pg_arch_1-on-individual-pages.patch
mm-make-page_ext_get-take-a-const-argument.patch
mm-make-folio_test_idle-and-folio_test_young-take-a-const-argument.patch
mm-make-is_free_buddy_page-take-a-const-argument.patch
mm-make-page_mapped-take-a-const-argument.patch
mm-convert-arch_clear_hugepage_flags-to-take-a-folio.patch
slub-remove-use-of-page-flags.patch
remove-references-to-page-flags-in-documentation.patch
proc-rewrite-stable_page_flags.patch

