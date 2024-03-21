Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 783BD134420
	for <mm-commits@vger.kernel.org>; Thu, 21 Mar 2024 21:03:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711055015; cv=none; b=VXbWZ8q48zvHmSNfouctsk3s5PYBzOCE+S0PN2tceZGBcF3rgC8V39DeI/XjWiDAgWicUA/sqwz/0f2ImcA3evueRSeyFkbsFBGMFoDlezPXYPcfR1jvQ9nWT9Hw5VikCfxokGQtU5zTdiEPrdbq/4mei2nJFqPFBtZUPTqbuZg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711055015; c=relaxed/simple;
	bh=OXDlM6PRbi08rmiMOW0LMR1CSYaaZg72P9YW71MGEQc=;
	h=Date:To:From:Subject:Message-Id; b=FtcHmH3N/Wrw8A4VMbJzmrokTkQmYC/BoBF4EFNF0ly2OfXIVWcXTtNKkk4F+df2EhoRZ5VWUTbXUaLHfeXGlLhzBp+wNgDTkgiqFYd76rWgYY63zG9F3ovvQbKmWybdKVo3PmxX21GJ+/ZX83uPjvI04UrD5MYfW12/puECr4A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=IXXK4/sc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="IXXK4/sc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7655C43394;
	Thu, 21 Mar 2024 21:03:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1711055014;
	bh=OXDlM6PRbi08rmiMOW0LMR1CSYaaZg72P9YW71MGEQc=;
	h=Date:To:From:Subject:From;
	b=IXXK4/scIHWLh6XflyTmC3uE++WojF6BQ8CCtSiYAnalujlrsK27gdz2NhIDn7oXr
	 jDCpoiNOgdlu3G6Y9ohdeE1Fq9tMPMjbKpynct5Pf1joSgLFwpPbj+pk3+0N6p5G8L
	 J1xJ8RIvEe44h7OluAqCGgx7kaSj5POoea9Pb2eE=
Date: Thu, 21 Mar 2024 14:03:34 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,osalvador@suse.de,muchun.song@linux.dev,linmiaohe@huawei.com,david@redhat.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-free-up-pg_slab.patch added to mm-unstable branch
Message-Id: <20240321210334.D7655C43394@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: free up PG_slab
has been added to the -mm mm-unstable branch.  Its filename is
     mm-free-up-pg_slab.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-free-up-pg_slab.patch

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
Subject: mm: free up PG_slab
Date: Thu, 21 Mar 2024 14:24:45 +0000

Reclaim the Slab page flag by using a spare bit in PageType.  We are
perennially short of page flags for various purposes, and now that the
original SLAB allocator has been retired, SLUB does not use the
mapcount/page_type field.  This lets us remove a number of special cases
for ignoring mapcount on Slab pages.

Link: https://lkml.kernel.org/r/20240321142448.1645400-8-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/page-flags.h     |   21 +++++++++++++++++----
 include/trace/events/mmflags.h |    2 +-
 mm/memory-failure.c            |    9 ---------
 mm/slab.h                      |    2 +-
 4 files changed, 19 insertions(+), 15 deletions(-)

--- a/include/linux/page-flags.h~mm-free-up-pg_slab
+++ a/include/linux/page-flags.h
@@ -109,7 +109,6 @@ enum pageflags {
 	PG_active,
 	PG_workingset,
 	PG_error,
-	PG_slab,
 	PG_owner_priv_1,	/* Owner use. If pagecache, fs may use*/
 	PG_arch_1,
 	PG_reserved,
@@ -524,7 +523,6 @@ PAGEFLAG(Active, active, PF_HEAD) __CLEA
 	TESTCLEARFLAG(Active, active, PF_HEAD)
 PAGEFLAG(Workingset, workingset, PF_HEAD)
 	TESTCLEARFLAG(Workingset, workingset, PF_HEAD)
-__PAGEFLAG(Slab, slab, PF_NO_TAIL)
 PAGEFLAG(Checked, checked, PF_NO_COMPOUND)	   /* Used by some filesystems */
 
 /* Xen */
@@ -931,7 +929,7 @@ PAGEFLAG_FALSE(HasHWPoisoned, has_hwpois
 #endif
 
 /*
- * For pages that are never mapped to userspace (and aren't PageSlab),
+ * For pages that are never mapped to userspace,
  * page_type may be used.  Because it is initialised to -1, we invert the
  * sense of the bit, so __SetPageFoo *clears* the bit used for PageFoo, and
  * __ClearPageFoo *sets* the bit used for PageFoo.  We reserve a few high and
@@ -947,6 +945,7 @@ PAGEFLAG_FALSE(HasHWPoisoned, has_hwpois
 #define PG_table	0x00000200
 #define PG_guard	0x00000400
 #define PG_hugetlb	0x00000800
+#define PG_slab		0x00001000
 
 #define PageType(page, flag)						\
 	((page->page_type & (PAGE_TYPE_BASE | flag)) == PAGE_TYPE_BASE)
@@ -1041,6 +1040,20 @@ PAGE_TYPE_OPS(Table, table, pgtable)
  */
 PAGE_TYPE_OPS(Guard, guard, guard)
 
+FOLIO_TYPE_OPS(slab, slab)
+
+/**
+ * PageSlab - Determine if the page belongs to the slab allocator
+ * @page: The page to test.
+ *
+ * Context: Any context.
+ * Return: True for slab pages, false for any other kind of page.
+ */
+static inline bool PageSlab(const struct page *page)
+{
+	return folio_test_slab(page_folio(page));
+}
+
 #ifdef CONFIG_HUGETLB_PAGE
 FOLIO_TYPE_OPS(hugetlb, hugetlb)
 #else
@@ -1121,7 +1134,7 @@ static __always_inline void __ClearPageA
 	(1UL << PG_lru		| 1UL << PG_locked	|	\
 	 1UL << PG_private	| 1UL << PG_private_2	|	\
 	 1UL << PG_writeback	| 1UL << PG_reserved	|	\
-	 1UL << PG_slab		| 1UL << PG_active 	|	\
+	 1UL << PG_active 	|				\
 	 1UL << PG_unevictable	| __PG_MLOCKED | LRU_GEN_MASK)
 
 /*
--- a/include/trace/events/mmflags.h~mm-free-up-pg_slab
+++ a/include/trace/events/mmflags.h
@@ -107,7 +107,6 @@
 	DEF_PAGEFLAG_NAME(lru),						\
 	DEF_PAGEFLAG_NAME(active),					\
 	DEF_PAGEFLAG_NAME(workingset),					\
-	DEF_PAGEFLAG_NAME(slab),					\
 	DEF_PAGEFLAG_NAME(owner_priv_1),				\
 	DEF_PAGEFLAG_NAME(arch_1),					\
 	DEF_PAGEFLAG_NAME(reserved),					\
@@ -135,6 +134,7 @@ IF_HAVE_PG_ARCH_X(arch_3)
 #define DEF_PAGETYPE_NAME(_name) { PG_##_name, __stringify(_name) }
 
 #define __def_pagetype_names						\
+	DEF_PAGETYPE_NAME(slab),					\
 	DEF_PAGETYPE_NAME(hugetlb),					\
 	DEF_PAGETYPE_NAME(offline),					\
 	DEF_PAGETYPE_NAME(guard),					\
--- a/mm/memory-failure.c~mm-free-up-pg_slab
+++ a/mm/memory-failure.c
@@ -1239,7 +1239,6 @@ static int me_huge_page(struct page_stat
 #define mlock		(1UL << PG_mlocked)
 #define lru		(1UL << PG_lru)
 #define head		(1UL << PG_head)
-#define slab		(1UL << PG_slab)
 #define reserved	(1UL << PG_reserved)
 
 static struct page_state error_states[] = {
@@ -1249,13 +1248,6 @@ static struct page_state error_states[]
 	 * PG_buddy pages only make a small fraction of all free pages.
 	 */
 
-	/*
-	 * Could in theory check if slab page is free or if we can drop
-	 * currently unused objects without touching them. But just
-	 * treat it as standard kernel for now.
-	 */
-	{ slab,		slab,		MF_MSG_SLAB,	me_kernel },
-
 	{ head,		head,		MF_MSG_HUGE,		me_huge_page },
 
 	{ sc|dirty,	sc|dirty,	MF_MSG_DIRTY_SWAPCACHE,	me_swapcache_dirty },
@@ -1282,7 +1274,6 @@ static struct page_state error_states[]
 #undef mlock
 #undef lru
 #undef head
-#undef slab
 #undef reserved
 
 static void update_per_node_mf_stats(unsigned long pfn,
--- a/mm/slab.h~mm-free-up-pg_slab
+++ a/mm/slab.h
@@ -84,8 +84,8 @@ struct slab {
 		};
 		struct rcu_head rcu_head;
 	};
-	unsigned int __unused;
 
+	unsigned int __page_type;
 	atomic_t __page_refcount;
 #ifdef CONFIG_SLAB_OBJ_EXT
 	unsigned long obj_exts;
_

Patches currently in -mm which might be from willy@infradead.org are

mm-increase-folio-batch-size.patch
mm-always-initialise-folio-_deferred_list.patch
mm-create-folio_flag_false-and-folio_type_ops-macros.patch
mm-remove-folio_prep_large_rmappable.patch
mm-support-page_mapcount-on-page_has_type-pages.patch
mm-turn-folio_test_hugetlb-into-a-pagetype.patch
mm-remove-a-call-to-compound_head-from-is_page_hwpoison.patch
mm-free-up-pg_slab.patch
mm-improve-dumping-of-mapcount-and-page_type.patch
hugetlb-remove-mention-of-destructors.patch

