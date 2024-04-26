Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F2347EEF8
	for <mm-commits@vger.kernel.org>; Fri, 26 Apr 2024 04:00:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714104023; cv=none; b=BDzDChmDzLxQBwvhlqAiTN5jwW32tGoqalYGHh42RzgaHlGTkdKmYEhzD9WnBQDCyfROot+OYjz+djcfGkCgD1JzLry8WiSIrVXKrjjX1LwgW7Tq4q2g4s+jd8zocwZJ11Mek3HwzKb8f6Agj6e4hWS+NirmkdmGdD82/ReXDLk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714104023; c=relaxed/simple;
	bh=N/nnmiO1Jmgce/jNzn4f7+W2kssD23O5nfwggA3aTks=;
	h=Date:To:From:Subject:Message-Id; b=TgQP4mIJPGfgOR19A4gpdYZcHPs50z2AjJXX0Ix4B6OcFdohzE6KVADb8LdZUPYA/4KJDhtc+VjJABguOtTXJhXCORnIZujlwFPLgunMza4NvFZvg+6x8HApawQBAtnjDDAVXXcEADlZFew9ufDqJ3gMoZMaiwm1NosEMQ3rtYM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=fOrLjbPw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="fOrLjbPw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12C3FC113CD;
	Fri, 26 Apr 2024 04:00:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714104023;
	bh=N/nnmiO1Jmgce/jNzn4f7+W2kssD23O5nfwggA3aTks=;
	h=Date:To:From:Subject:From;
	b=fOrLjbPwgwKN5RA5NC7DGAv15fzxGEolGGnBPYd6H10sWxo/WxGb8VLw6RxeipDF9
	 z1QC0KfoOgtag9paieSFZ1oVJT37vRgwMIBLQsz+nTMI+3lQ3r1s96opyfjYHvTHfp
	 O8xl3E6sSXQN+KyeQ4Ul/ZhFdzEuza9OEslruzq8=
Date: Thu, 25 Apr 2024 21:00:22 -0700
To: mm-commits@vger.kernel.org,svetly.todorov@memverge.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] proc-rewrite-stable_page_flags.patch removed from -mm tree
Message-Id: <20240426040023.12C3FC113CD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: proc: rewrite stable_page_flags()
has been removed from the -mm tree.  Its filename was
     proc-rewrite-stable_page_flags.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

[willy@infradead.org: fix up some bits vs masks]
  Link: https://lkml.kernel.org/r/20240403173112.1450721-1-willy@infradead.org
[willy@infradead.org: fix warnings]
  Link: https://lkml.kernel.org/r/ZhBPtCYfSuFuUMEz@casper.infradead.org
Link: https://lkml.kernel.org/r/20240326171045.410737-11-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Svetly Todorov <svetly.todorov@memverge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/page.c                 |   69 ++++++++++++++++---------------
 include/linux/huge_mm.h        |    4 -
 include/linux/page-flags.h     |    2 
 tools/cgroup/memcg_slabinfo.py |    5 --
 4 files changed, 42 insertions(+), 38 deletions(-)

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
+		if ((k & (1 << PG_lru)) || is_anon)
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
@@ -174,16 +175,17 @@ u64 stable_page_flags(struct page *page)
 		u |= 1 << KPF_OFFLINE;
 	if (PageTable(page))
 		u |= 1 << KPF_PGTABLE;
+	if (folio_test_slab(folio))
+		u |= 1 << KPF_SLAB;
 
-	if (page_is_idle(page))
+#if defined(CONFIG_PAGE_IDLE_FLAG) && defined(CONFIG_64BIT)
+	u |= kpf_copy_bit(k, KPF_IDLE,          PG_idle);
+#else
+	if (folio_test_idle(folio))
 		u |= 1 << KPF_IDLE;
+#endif
 
 	u |= kpf_copy_bit(k, KPF_LOCKED,	PG_locked);
-
-	u |= kpf_copy_bit(k, KPF_SLAB,		PG_slab);
-	if (PageTail(page) && PageSlab(page))
-		u |= 1 << KPF_SLAB;
-
 	u |= kpf_copy_bit(k, KPF_ERROR,		PG_error);
 	u |= kpf_copy_bit(k, KPF_DIRTY,		PG_dirty);
 	u |= kpf_copy_bit(k, KPF_UPTODATE,	PG_uptodate);
@@ -194,7 +196,8 @@ u64 stable_page_flags(struct page *page)
 	u |= kpf_copy_bit(k, KPF_ACTIVE,	PG_active);
 	u |= kpf_copy_bit(k, KPF_RECLAIM,	PG_reclaim);
 
-	if (PageSwapCache(page))
+#define SWAPCACHE ((1 << PG_swapbacked) | (1 << PG_swapcache))
+	if ((k & SWAPCACHE) == SWAPCACHE)
 		u |= 1 << KPF_SWAPCACHE;
 	u |= kpf_copy_bit(k, KPF_SWAPBACKED,	PG_swapbacked);
 
@@ -202,7 +205,10 @@ u64 stable_page_flags(struct page *page)
 	u |= kpf_copy_bit(k, KPF_MLOCKED,	PG_mlocked);
 
 #ifdef CONFIG_MEMORY_FAILURE
-	u |= kpf_copy_bit(k, KPF_HWPOISON,	PG_hwpoison);
+	if (u & (1 << KPF_HUGE))
+		u |= kpf_copy_bit(k, KPF_HWPOISON,	PG_hwpoison);
+	else
+		u |= kpf_copy_bit(page->flags, KPF_HWPOISON,	PG_hwpoison);
 #endif
 
 #ifdef CONFIG_ARCH_USES_PG_UNCACHED
@@ -228,7 +234,6 @@ static ssize_t kpageflags_read(struct fi
 {
 	const unsigned long max_dump_pfn = get_max_dump_pfn();
 	u64 __user *out = (u64 __user *)buf;
-	struct page *ppage;
 	unsigned long src = *ppos;
 	unsigned long pfn;
 	ssize_t ret = 0;
@@ -245,9 +250,9 @@ static ssize_t kpageflags_read(struct fi
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
--- a/tools/cgroup/memcg_slabinfo.py~proc-rewrite-stable_page_flags
+++ a/tools/cgroup/memcg_slabinfo.py
@@ -146,12 +146,11 @@ def detect_kernel_config():
 
 
 def for_each_slab(prog):
-    PGSlab = 1 << prog.constant('PG_slab')
-    PGHead = 1 << prog.constant('PG_head')
+    PGSlab = ~prog.constant('PG_slab')
 
     for page in for_each_page(prog):
         try:
-            if page.flags.value_() & PGSlab:
+            if page.page_type.value_() == PGSlab:
                 yield cast('struct slab *', page)
         except FaultError:
             pass
_

Patches currently in -mm which might be from willy@infradead.org are

doc-improve-the-description-of-__folio_mark_dirty.patch
buffer-add-kernel-doc-for-block_dirty_folio.patch
buffer-add-kernel-doc-for-try_to_free_buffers.patch
buffer-fix-__bread-and-__bread_gfp-kernel-doc.patch
buffer-add-kernel-doc-for-brelse-and-__brelse.patch
buffer-add-kernel-doc-for-bforget-and-__bforget.patch
buffer-improve-bdev_getblk-documentation.patch
doc-split-bufferrst-out-of-api-summaryrst.patch
doc-split-bufferrst-out-of-api-summaryrst-fix.patch
mm-memory-failure-remove-fsdax_pgoff-argument-from-__add_to_kill.patch
mm-memory-failure-pass-addr-to-__add_to_kill.patch
mm-return-the-address-from-page_mapped_in_vma.patch
mm-make-page_mapped_in_vma-conditional-on-config_memory_failure.patch
mm-memory-failure-convert-shake_page-to-shake_folio.patch
mm-convert-hugetlb_page_mapping_lock_write-to-folio.patch
mm-memory-failure-convert-memory_failure-to-use-a-folio.patch
mm-memory-failure-convert-hwpoison_user_mappings-to-take-a-folio.patch
mm-memory-failure-add-some-folio-conversions-to-unpoison_memory.patch
mm-memory-failure-use-folio-functions-throughout-collect_procs.patch
mm-memory-failure-pass-the-folio-to-collect_procs_ksm.patch
fscrypt-convert-bh_get_inode_and_lblk_num-to-use-a-folio.patch
f2fs-convert-f2fs_clear_page_cache_dirty_tag-to-use-a-folio.patch
memory-failure-remove-calls-to-page_mapping.patch
migrate-expand-the-use-of-folio-in-__migrate_device_pages.patch
userfault-expand-folio-use-in-mfill_atomic_install_pte.patch
mm-remove-page_mapping.patch
mm-remove-page_cache_alloc.patch
mm-remove-put_devmap_managed_page.patch
mm-convert-put_devmap_managed_page_refs-to-put_devmap_managed_folio_refs.patch
mm-remove-page_ref_sub_return.patch
gup-use-folios-for-gup_devmap.patch
mm-add-kernel-doc-for-folio_mark_accessed.patch
mm-remove-pagereferenced.patch
mm-simplify-thp_vma_allowable_order.patch

