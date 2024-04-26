Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B45E27C085
	for <mm-commits@vger.kernel.org>; Fri, 26 Apr 2024 03:59:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714103940; cv=none; b=dkvjIPyG698bzYDV9Iz5CM+qmQXM5RKRxJzcqUAGbwYUDKpnzejHFXmlMwbxIX8sZRKbghais/i8yiKsJrDudwnpg7fmLznOIpjxN8jJb4h3sjPp4NuA+Uog1VprY3eX7aaJH7+tWhiOioY1sjWJzkXJIqbh08+W4maBeJPruU0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714103940; c=relaxed/simple;
	bh=v8ZvL18W6R/UC00/qMfZS8GL4bRIYUAhYvRYR6F2ZBo=;
	h=Date:To:From:Subject:Message-Id; b=SQij+qo8zKreaFk9Ja2gR5hFV5Q4THmtz7PSHoP/2cd1gUh7gdq5mHw0CFo69AbrECRbTSIlvga/no9rj6/WRYm0nGDsrNm0735nr+sEQPOeBaq5G0DJlCkl37wK/KuYnacJEAUJ6Hl3MQjVGQZOVqQHcPnV1c1tI4l084wAwrM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=uCIMJRcQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="uCIMJRcQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B188C113CD;
	Fri, 26 Apr 2024 03:59:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714103940;
	bh=v8ZvL18W6R/UC00/qMfZS8GL4bRIYUAhYvRYR6F2ZBo=;
	h=Date:To:From:Subject:From;
	b=uCIMJRcQC8ZT8NyF7dm2BlnwSTkNEWVyVMg7/30nJhVupFBG/WscZzDTELIdEnYp8
	 fO4uehoaFWd+yL41UmKxDRB0LVB40cbYYyBZfQaJOP50ObbxKhtcv4bL5IQKgJeOez
	 kyCnSosmW0ppTi1YVCNCRfMzqghJ6ghcEqHrsO24=
Date: Thu, 25 Apr 2024 20:59:00 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,osalvador@suse.de,muchun.song@linux.dev,linmiaohe@huawei.com,david@redhat.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-free-up-pg_slab.patch removed from -mm tree
Message-Id: <20240426035900.8B188C113CD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: free up PG_slab
has been removed from the -mm tree.  Its filename was
     mm-free-up-pg_slab.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: free up PG_slab
Date: Thu, 21 Mar 2024 14:24:45 +0000

Reclaim the Slab page flag by using a spare bit in PageType.  We are
perennially short of page flags for various purposes, and now that the
original SLAB allocator has been retired, SLUB does not use the
mapcount/page_type field.  This lets us remove a number of special cases
for ignoring mapcount on Slab pages.

[willy@infradead.org: update vmcoreinfo]
  Link: https://lkml.kernel.org/r/ZgGV-O8WYQ_83kxp@casper.infradead.org
Link: https://lkml.kernel.org/r/20240321142448.1645400-8-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/page-flags.h     |   21 +++++++++++++++++----
 include/trace/events/mmflags.h |    2 +-
 kernel/vmcore_info.c           |    3 ++-
 mm/memory-failure.c            |    9 ---------
 mm/slab.h                      |    2 +-
 5 files changed, 21 insertions(+), 16 deletions(-)

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
--- a/kernel/vmcore_info.c~mm-free-up-pg_slab
+++ a/kernel/vmcore_info.c
@@ -198,7 +198,8 @@ static int __init crash_save_vmcoreinfo_
 	VMCOREINFO_NUMBER(PG_private);
 	VMCOREINFO_NUMBER(PG_swapcache);
 	VMCOREINFO_NUMBER(PG_swapbacked);
-	VMCOREINFO_NUMBER(PG_slab);
+#define PAGE_SLAB_MAPCOUNT_VALUE	(~PG_slab)
+	VMCOREINFO_NUMBER(PAGE_SLAB_MAPCOUNT_VALUE);
 #ifdef CONFIG_MEMORY_FAILURE
 	VMCOREINFO_NUMBER(PG_hwpoison);
 #endif
--- a/mm/memory-failure.c~mm-free-up-pg_slab
+++ a/mm/memory-failure.c
@@ -1251,7 +1251,6 @@ static int me_huge_page(struct page_stat
 #define mlock		(1UL << PG_mlocked)
 #define lru		(1UL << PG_lru)
 #define head		(1UL << PG_head)
-#define slab		(1UL << PG_slab)
 #define reserved	(1UL << PG_reserved)
 
 static struct page_state error_states[] = {
@@ -1261,13 +1260,6 @@ static struct page_state error_states[]
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
@@ -1294,7 +1286,6 @@ static struct page_state error_states[]
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

