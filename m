Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E03CAC3F6B0
	for <mm-commits@archiver.kernel.org>; Mon, 22 Aug 2022 19:21:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237358AbiHVTVY (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 22 Aug 2022 15:21:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238583AbiHVTUp (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 22 Aug 2022 15:20:45 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 399795281D
        for <mm-commits@vger.kernel.org>; Mon, 22 Aug 2022 12:19:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BF1F9B818AB
        for <mm-commits@vger.kernel.org>; Mon, 22 Aug 2022 19:19:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D348C433C1;
        Mon, 22 Aug 2022 19:19:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1661195975;
        bh=D89jD0z2h3b2cZ6GKWnFug/+rjQCxktN2W0pa+OXmVM=;
        h=Date:To:From:Subject:From;
        b=wtJh2UTIzWfx2GzAQ7MmKsob6MrwIufLeXAsLtv8UUGuChpVVFJjJhaYUbpH/gyM3
         QtOSWI5oXpltDgjPusOVrFdmENWEDW86e7y28BO/59gt8BzYDMQJDoj+OwBrp6r4zC
         4ycHNw7sowYwAlRdoCW3GeiWzcQlU3ZsfHf8ijX0=
Date:   Mon, 22 Aug 2022 12:19:34 -0700
To:     mm-commits@vger.kernel.org, yuzhao@google.com, willy@infradead.org,
        will@kernel.org, vbabka@suse.cz, svens@linux.ibm.com,
        sj@kernel.org, dhowells@redhat.com, david@redhat.com,
        catalin.marinas@arm.com, Liam.Howlett@Oracle.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-start-tracking-vmas-with-maple-tree.patch added to mm-unstable branch
Message-Id: <20220822191935.4D348C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: start tracking VMAs with maple tree
has been added to the -mm mm-unstable branch.  Its filename is
     mm-start-tracking-vmas-with-maple-tree.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-start-tracking-vmas-with-maple-tree.patch

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
From: "Liam R. Howlett" <Liam.Howlett@Oracle.com>
Subject: mm: start tracking VMAs with maple tree
Date: Mon, 22 Aug 2022 15:02:47 +0000

Start tracking the VMAs with the new maple tree structure in parallel with
the rb_tree.  Add debug and trace events for maple tree operations and
duplicate the rb_tree that is created on forks into the maple tree.

The maple tree is added to the mm_struct including the mm_init struct,
added support in required mm/mmap functions, added tracking in kernel/fork
for process forking, and used to find the unmapped_area and checked
against what the rbtree finds.

This also moves the mmap_lock() in exit_mmap() since the oom reaper call
does walk the VMAs.  Otherwise lockdep will be unhappy if oom happens.

When splitting a vma fails due to allocations of the maple tree nodes, the
error path in __split_vma() calls new->vm_ops->close(new).  The page
accounting for hugetlb is actually in the close() operation, so it
accounts for the removal of 1/2 of the VMA which was not adjusted.  This
results in a negative exit value.  To avoid the negative charge, set
vm_start = vm_end and vm_pgoff = 0.

There is also a potential accounting issue in special mappings from
insert_vm_struct() failing to allocate, so reverse the charge there in the
failure scenario.

Link: https://lkml.kernel.org/r/20220822150128.1562046-9-Liam.Howlett@oracle.com
Signed-off-by: Liam R. Howlett <Liam.Howlett@Oracle.com>
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: David Howells <dhowells@redhat.com>
Cc: SeongJae Park <sj@kernel.org>
Cc: Sven Schnelle <svens@linux.ibm.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Will Deacon <will@kernel.org>
Cc: Yu Zhao <yuzhao@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/tboot.c     |    1 
 drivers/firmware/efi/efi.c  |    1 
 include/linux/mm.h          |    5 
 include/linux/mm_types.h    |    3 
 include/trace/events/mmap.h |   73 +++++++
 kernel/fork.c               |   20 +
 mm/init-mm.c                |    2 
 mm/mmap.c                   |  353 ++++++++++++++++++++++++++++++----
 mm/nommu.c                  |   13 +
 9 files changed, 435 insertions(+), 36 deletions(-)

--- a/arch/x86/kernel/tboot.c~mm-start-tracking-vmas-with-maple-tree
+++ a/arch/x86/kernel/tboot.c
@@ -96,6 +96,7 @@ void __init tboot_probe(void)
 static pgd_t *tboot_pg_dir;
 static struct mm_struct tboot_mm = {
 	.mm_rb          = RB_ROOT,
+	.mm_mt          = MTREE_INIT_EXT(mm_mt, MM_MT_FLAGS, tboot_mm.mmap_lock),
 	.pgd            = swapper_pg_dir,
 	.mm_users       = ATOMIC_INIT(2),
 	.mm_count       = ATOMIC_INIT(1),
--- a/drivers/firmware/efi/efi.c~mm-start-tracking-vmas-with-maple-tree
+++ a/drivers/firmware/efi/efi.c
@@ -58,6 +58,7 @@ static unsigned long __initdata rt_prop
 
 struct mm_struct efi_mm = {
 	.mm_rb			= RB_ROOT,
+	.mm_mt			= MTREE_INIT_EXT(mm_mt, MM_MT_FLAGS, efi_mm.mmap_lock),
 	.mm_users		= ATOMIC_INIT(2),
 	.mm_count		= ATOMIC_INIT(1),
 	.write_protect_seq      = SEQCNT_ZERO(efi_mm.write_protect_seq),
--- a/include/linux/mm.h~mm-start-tracking-vmas-with-maple-tree
+++ a/include/linux/mm.h
@@ -2571,6 +2571,8 @@ extern bool arch_has_descending_max_zone
 /* nommu.c */
 extern atomic_long_t mmap_pages_allocated;
 extern int nommu_shrink_inode_mappings(struct inode *, size_t, size_t);
+/* mmap.c */
+void vma_mas_store(struct vm_area_struct *vma, struct ma_state *mas);
 
 /* interval_tree.c */
 void vma_interval_tree_insert(struct vm_area_struct *node,
@@ -2634,6 +2636,9 @@ extern struct vm_area_struct *copy_vma(s
 	bool *need_rmap_locks);
 extern void exit_mmap(struct mm_struct *);
 
+void vma_mas_store(struct vm_area_struct *vma, struct ma_state *mas);
+void vma_mas_remove(struct vm_area_struct *vma, struct ma_state *mas);
+
 static inline int check_data_rlimit(unsigned long rlim,
 				    unsigned long new,
 				    unsigned long start,
--- a/include/linux/mm_types.h~mm-start-tracking-vmas-with-maple-tree
+++ a/include/linux/mm_types.h
@@ -10,6 +10,7 @@
 #include <linux/list.h>
 #include <linux/spinlock.h>
 #include <linux/rbtree.h>
+#include <linux/maple_tree.h>
 #include <linux/rwsem.h>
 #include <linux/completion.h>
 #include <linux/cpumask.h>
@@ -488,6 +489,7 @@ struct kioctx_table;
 struct mm_struct {
 	struct {
 		struct vm_area_struct *mmap;		/* list of VMAs */
+		struct maple_tree mm_mt;
 		struct rb_root mm_rb;
 		u64 vmacache_seqnum;                   /* per-thread vmacache */
 #ifdef CONFIG_MMU
@@ -699,6 +701,7 @@ struct mm_struct {
 	unsigned long cpu_bitmap[];
 };
 
+#define MM_MT_FLAGS	(MT_FLAGS_ALLOC_RANGE | MT_FLAGS_LOCK_EXTERN)
 extern struct mm_struct init_mm;
 
 /* Pointer magic because the dynamic array size confuses some compilers. */
--- a/include/trace/events/mmap.h~mm-start-tracking-vmas-with-maple-tree
+++ a/include/trace/events/mmap.h
@@ -42,6 +42,79 @@ TRACE_EVENT(vm_unmapped_area,
 		__entry->low_limit, __entry->high_limit, __entry->align_mask,
 		__entry->align_offset)
 );
+
+TRACE_EVENT(vma_mas_szero,
+	TP_PROTO(struct maple_tree *mt, unsigned long start,
+		 unsigned long end),
+
+	TP_ARGS(mt, start, end),
+
+	TP_STRUCT__entry(
+			__field(struct maple_tree *, mt)
+			__field(unsigned long, start)
+			__field(unsigned long, end)
+	),
+
+	TP_fast_assign(
+			__entry->mt		= mt;
+			__entry->start		= start;
+			__entry->end		= end;
+	),
+
+	TP_printk("mt_mod %p, (NULL), SNULL, %lu, %lu,",
+		  __entry->mt,
+		  (unsigned long) __entry->start,
+		  (unsigned long) __entry->end
+	)
+);
+
+TRACE_EVENT(vma_store,
+	TP_PROTO(struct maple_tree *mt, struct vm_area_struct *vma),
+
+	TP_ARGS(mt, vma),
+
+	TP_STRUCT__entry(
+			__field(struct maple_tree *, mt)
+			__field(struct vm_area_struct *, vma)
+			__field(unsigned long, vm_start)
+			__field(unsigned long, vm_end)
+	),
+
+	TP_fast_assign(
+			__entry->mt		= mt;
+			__entry->vma		= vma;
+			__entry->vm_start	= vma->vm_start;
+			__entry->vm_end		= vma->vm_end - 1;
+	),
+
+	TP_printk("mt_mod %p, (%p), STORE, %lu, %lu,",
+		  __entry->mt, __entry->vma,
+		  (unsigned long) __entry->vm_start,
+		  (unsigned long) __entry->vm_end
+	)
+);
+
+
+TRACE_EVENT(exit_mmap,
+	TP_PROTO(struct mm_struct *mm),
+
+	TP_ARGS(mm),
+
+	TP_STRUCT__entry(
+			__field(struct mm_struct *, mm)
+			__field(struct maple_tree *, mt)
+	),
+
+	TP_fast_assign(
+		       __entry->mm		= mm;
+		       __entry->mt		= &mm->mm_mt;
+	),
+
+	TP_printk("mt_mod %p, DESTROY\n",
+		  __entry->mt
+	)
+);
+
 #endif
 
 /* This part must be outside protection */
--- a/kernel/fork.c~mm-start-tracking-vmas-with-maple-tree
+++ a/kernel/fork.c
@@ -585,6 +585,7 @@ static __latent_entropy int dup_mmap(str
 	int retval;
 	unsigned long charge;
 	LIST_HEAD(uf);
+	MA_STATE(mas, &mm->mm_mt, 0, 0);
 
 	uprobe_start_dup_mmap();
 	if (mmap_write_lock_killable(oldmm)) {
@@ -614,6 +615,10 @@ static __latent_entropy int dup_mmap(str
 		goto out;
 	khugepaged_fork(mm, oldmm);
 
+	retval = mas_expected_entries(&mas, oldmm->map_count);
+	if (retval)
+		goto out;
+
 	prev = NULL;
 	for (mpnt = oldmm->mmap; mpnt; mpnt = mpnt->vm_next) {
 		struct file *file;
@@ -629,7 +634,7 @@ static __latent_entropy int dup_mmap(str
 		 */
 		if (fatal_signal_pending(current)) {
 			retval = -EINTR;
-			goto out;
+			goto loop_out;
 		}
 		if (mpnt->vm_flags & VM_ACCOUNT) {
 			unsigned long len = vma_pages(mpnt);
@@ -694,6 +699,11 @@ static __latent_entropy int dup_mmap(str
 		rb_link = &tmp->vm_rb.rb_right;
 		rb_parent = &tmp->vm_rb;
 
+		/* Link the vma into the MT */
+		mas.index = tmp->vm_start;
+		mas.last = tmp->vm_end - 1;
+		mas_store(&mas, tmp);
+
 		mm->map_count++;
 		if (!(tmp->vm_flags & VM_WIPEONFORK))
 			retval = copy_page_range(tmp, mpnt);
@@ -702,10 +712,12 @@ static __latent_entropy int dup_mmap(str
 			tmp->vm_ops->open(tmp);
 
 		if (retval)
-			goto out;
+			goto loop_out;
 	}
 	/* a new mm has just been created */
 	retval = arch_dup_mmap(oldmm, mm);
+loop_out:
+	mas_destroy(&mas);
 out:
 	mmap_write_unlock(mm);
 	flush_tlb_mm(oldmm);
@@ -721,7 +733,7 @@ fail_nomem_policy:
 fail_nomem:
 	retval = -ENOMEM;
 	vm_unacct_memory(charge);
-	goto out;
+	goto loop_out;
 }
 
 static inline int mm_alloc_pgd(struct mm_struct *mm)
@@ -1111,6 +1123,8 @@ static struct mm_struct *mm_init(struct
 {
 	mm->mmap = NULL;
 	mm->mm_rb = RB_ROOT;
+	mt_init_flags(&mm->mm_mt, MM_MT_FLAGS);
+	mt_set_external_lock(&mm->mm_mt, &mm->mmap_lock);
 	mm->vmacache_seqnum = 0;
 	atomic_set(&mm->mm_users, 1);
 	atomic_set(&mm->mm_count, 1);
--- a/mm/init-mm.c~mm-start-tracking-vmas-with-maple-tree
+++ a/mm/init-mm.c
@@ -1,6 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0
 #include <linux/mm_types.h>
 #include <linux/rbtree.h>
+#include <linux/maple_tree.h>
 #include <linux/rwsem.h>
 #include <linux/spinlock.h>
 #include <linux/list.h>
@@ -29,6 +30,7 @@
  */
 struct mm_struct init_mm = {
 	.mm_rb		= RB_ROOT,
+	.mm_mt		= MTREE_INIT_EXT(mm_mt, MM_MT_FLAGS, init_mm.mmap_lock),
 	.pgd		= swapper_pg_dir,
 	.mm_users	= ATOMIC_INIT(2),
 	.mm_count	= ATOMIC_INIT(1),
--- a/mm/mmap.c~mm-start-tracking-vmas-with-maple-tree
+++ a/mm/mmap.c
@@ -334,7 +334,71 @@ static int browse_rb(struct mm_struct *m
 	}
 	return bug ? -1 : i;
 }
+#if defined(CONFIG_DEBUG_VM_MAPLE_TREE)
+extern void mt_validate(struct maple_tree *mt);
+extern void mt_dump(const struct maple_tree *mt);
 
+/* Validate the maple tree */
+static void validate_mm_mt(struct mm_struct *mm)
+{
+	struct maple_tree *mt = &mm->mm_mt;
+	struct vm_area_struct *vma_mt, *vma = mm->mmap;
+
+	MA_STATE(mas, mt, 0, 0);
+
+	mt_validate(&mm->mm_mt);
+	mas_for_each(&mas, vma_mt, ULONG_MAX) {
+		if (xa_is_zero(vma_mt))
+			continue;
+
+		if (!vma)
+			break;
+
+		if ((vma != vma_mt) ||
+		    (vma->vm_start != vma_mt->vm_start) ||
+		    (vma->vm_end != vma_mt->vm_end) ||
+		    (vma->vm_start != mas.index) ||
+		    (vma->vm_end - 1 != mas.last)) {
+			pr_emerg("issue in %s\n", current->comm);
+			dump_stack();
+#ifdef CONFIG_DEBUG_VM
+			dump_vma(vma_mt);
+			pr_emerg("and next in rb\n");
+			dump_vma(vma->vm_next);
+#endif
+			pr_emerg("mt piv: %p %lu - %lu\n", vma_mt,
+				 mas.index, mas.last);
+			pr_emerg("mt vma: %p %lu - %lu\n", vma_mt,
+				 vma_mt->vm_start, vma_mt->vm_end);
+			pr_emerg("rb vma: %p %lu - %lu\n", vma,
+				 vma->vm_start, vma->vm_end);
+			pr_emerg("rb->next = %p %lu - %lu\n", vma->vm_next,
+					vma->vm_next->vm_start, vma->vm_next->vm_end);
+
+			mt_dump(mas.tree);
+			if (vma_mt->vm_end != mas.last + 1) {
+				pr_err("vma: %p vma_mt %lu-%lu\tmt %lu-%lu\n",
+						mm, vma_mt->vm_start, vma_mt->vm_end,
+						mas.index, mas.last);
+				mt_dump(mas.tree);
+			}
+			VM_BUG_ON_MM(vma_mt->vm_end != mas.last + 1, mm);
+			if (vma_mt->vm_start != mas.index) {
+				pr_err("vma: %p vma_mt %p %lu - %lu doesn't match\n",
+						mm, vma_mt, vma_mt->vm_start, vma_mt->vm_end);
+				mt_dump(mas.tree);
+			}
+			VM_BUG_ON_MM(vma_mt->vm_start != mas.index, mm);
+		}
+		VM_BUG_ON(vma != vma_mt);
+		vma = vma->vm_next;
+
+	}
+	VM_BUG_ON(vma);
+}
+#else
+#define validate_mm_mt(root) do { } while (0)
+#endif
 static void validate_mm_rb(struct rb_root *root, struct vm_area_struct *ignore)
 {
 	struct rb_node *nd;
@@ -389,6 +453,7 @@ static void validate_mm(struct mm_struct
 }
 #else
 #define validate_mm_rb(root, ignore) do { } while (0)
+#define validate_mm_mt(root) do { } while (0)
 #define validate_mm(mm) do { } while (0)
 #endif
 
@@ -633,6 +698,56 @@ static void __vma_link_file(struct vm_ar
 	}
 }
 
+/*
+ * vma_mas_store() - Store a VMA in the maple tree.
+ * @vma: The vm_area_struct
+ * @mas: The maple state
+ *
+ * Efficient way to store a VMA in the maple tree when the @mas has already
+ * walked to the correct location.
+ *
+ * Note: the end address is inclusive in the maple tree.
+ */
+void vma_mas_store(struct vm_area_struct *vma, struct ma_state *mas)
+{
+	trace_vma_store(mas->tree, vma);
+	mas_set_range(mas, vma->vm_start, vma->vm_end - 1);
+	mas_store_prealloc(mas, vma);
+}
+
+/*
+ * vma_mas_remove() - Remove a VMA from the maple tree.
+ * @vma: The vm_area_struct
+ * @mas: The maple state
+ *
+ * Efficient way to remove a VMA from the maple tree when the @mas has already
+ * been established and points to the correct location.
+ * Note: the end address is inclusive in the maple tree.
+ */
+void vma_mas_remove(struct vm_area_struct *vma, struct ma_state *mas)
+{
+	trace_vma_mas_szero(mas->tree, vma->vm_start, vma->vm_end - 1);
+	mas->index = vma->vm_start;
+	mas->last = vma->vm_end - 1;
+	mas_store_prealloc(mas, NULL);
+}
+
+/*
+ * vma_mas_szero() - Set a given range to zero.  Used when modifying a
+ * vm_area_struct start or end.
+ *
+ * @mm: The struct_mm
+ * @start: The start address to zero
+ * @end: The end address to zero.
+ */
+static inline void vma_mas_szero(struct ma_state *mas, unsigned long start,
+				unsigned long end)
+{
+	trace_vma_mas_szero(mas->tree, start, end - 1);
+	mas_set_range(mas, start, end - 1);
+	mas_store_prealloc(mas, NULL);
+}
+
 static void
 __vma_link(struct mm_struct *mm, struct vm_area_struct *vma,
 	struct vm_area_struct *prev, struct rb_node **rb_link,
@@ -642,17 +757,22 @@ __vma_link(struct mm_struct *mm, struct
 	__vma_link_rb(mm, vma, rb_link, rb_parent);
 }
 
-static void vma_link(struct mm_struct *mm, struct vm_area_struct *vma,
+static int vma_link(struct mm_struct *mm, struct vm_area_struct *vma,
 			struct vm_area_struct *prev, struct rb_node **rb_link,
 			struct rb_node *rb_parent)
 {
+	MA_STATE(mas, &mm->mm_mt, 0, 0);
 	struct address_space *mapping = NULL;
 
+	if (mas_preallocate(&mas, vma, GFP_KERNEL))
+		return -ENOMEM;
+
 	if (vma->vm_file) {
 		mapping = vma->vm_file->f_mapping;
 		i_mmap_lock_write(mapping);
 	}
 
+	vma_mas_store(vma, &mas);
 	__vma_link(mm, vma, prev, rb_link, rb_parent);
 	__vma_link_file(vma);
 
@@ -661,13 +781,15 @@ static void vma_link(struct mm_struct *m
 
 	mm->map_count++;
 	validate_mm(mm);
+	return 0;
 }
 
 /*
  * Helper for vma_adjust() in the split_vma insert case: insert a vma into the
  * mm's list and rbtree.  It has already been inserted into the interval tree.
  */
-static void __insert_vm_struct(struct mm_struct *mm, struct vm_area_struct *vma)
+static void __insert_vm_struct(struct mm_struct *mm, struct ma_state *mas,
+			       struct vm_area_struct *vma)
 {
 	struct vm_area_struct *prev;
 	struct rb_node **rb_link, *rb_parent;
@@ -675,7 +797,10 @@ static void __insert_vm_struct(struct mm
 	if (find_vma_links(mm, vma->vm_start, vma->vm_end,
 			   &prev, &rb_link, &rb_parent))
 		BUG();
-	__vma_link(mm, vma, prev, rb_link, rb_parent);
+
+	vma_mas_store(vma, mas);
+	__vma_link_list(mm, vma, prev);
+	__vma_link_rb(mm, vma, rb_link, rb_parent);
 	mm->map_count++;
 }
 
@@ -702,6 +827,7 @@ int __vma_adjust(struct vm_area_struct *
 {
 	struct mm_struct *mm = vma->vm_mm;
 	struct vm_area_struct *next = vma->vm_next, *orig_vma = vma;
+	struct vm_area_struct *next_next;
 	struct address_space *mapping = NULL;
 	struct rb_root_cached *root = NULL;
 	struct anon_vma *anon_vma = NULL;
@@ -709,10 +835,13 @@ int __vma_adjust(struct vm_area_struct *
 	bool start_changed = false, end_changed = false;
 	long adjust_next = 0;
 	int remove_next = 0;
+	MA_STATE(mas, &mm->mm_mt, 0, 0);
+	struct vm_area_struct *exporter = NULL, *importer = NULL;
 
-	if (next && !insert) {
-		struct vm_area_struct *exporter = NULL, *importer = NULL;
+	validate_mm(mm);
+	validate_mm_mt(mm);
 
+	if (next && !insert) {
 		if (end >= next->vm_end) {
 			/*
 			 * vma expands, overlapping all the next, and
@@ -741,10 +870,11 @@ int __vma_adjust(struct vm_area_struct *
 				 * remove_next == 1 is case 1 or 7.
 				 */
 				remove_next = 1 + (end > next->vm_end);
+				if (remove_next == 2)
+					next_next = find_vma(mm, next->vm_end);
+
 				VM_WARN_ON(remove_next == 2 &&
 					   end != next->vm_next->vm_end);
-				/* trim end to next, for case 6 first pass */
-				end = next->vm_end;
 			}
 
 			exporter = next;
@@ -792,9 +922,11 @@ int __vma_adjust(struct vm_area_struct *
 				return error;
 		}
 	}
-again:
-	vma_adjust_trans_huge(orig_vma, start, end, adjust_next);
 
+	if (mas_preallocate(&mas, vma, GFP_KERNEL))
+		return -ENOMEM;
+
+	vma_adjust_trans_huge(orig_vma, start, end, adjust_next);
 	if (file) {
 		mapping = file->f_mapping;
 		root = &mapping->i_mmap;
@@ -835,17 +967,28 @@ again:
 	}
 
 	if (start != vma->vm_start) {
+		unsigned long old_start = vma->vm_start;
 		vma->vm_start = start;
+		if (old_start < start)
+			vma_mas_szero(&mas, old_start, start);
 		start_changed = true;
 	}
 	if (end != vma->vm_end) {
+		unsigned long old_end = vma->vm_end;
 		vma->vm_end = end;
+		if (old_end > end)
+			vma_mas_szero(&mas, end, old_end);
 		end_changed = true;
 	}
+
+	if (end_changed || start_changed)
+		vma_mas_store(vma, &mas);
+
 	vma->vm_pgoff = pgoff;
 	if (adjust_next) {
 		next->vm_start += adjust_next;
 		next->vm_pgoff += adjust_next >> PAGE_SHIFT;
+		vma_mas_store(next, &mas);
 	}
 
 	if (file) {
@@ -859,10 +1002,14 @@ again:
 		/*
 		 * vma_merge has merged next into vma, and needs
 		 * us to remove next before dropping the locks.
+		 * Since we have expanded over this vma, the maple tree will
+		 * have overwritten by storing the value
 		 */
-		if (remove_next != 3)
+		if (remove_next != 3) {
 			__vma_unlink(mm, next, next);
-		else
+			if (remove_next == 2)
+				__vma_unlink(mm, next_next, next_next);
+		} else {
 			/*
 			 * vma is not before next if they've been
 			 * swapped.
@@ -873,15 +1020,19 @@ again:
 			 * "vma").
 			 */
 			__vma_unlink(mm, next, vma);
-		if (file)
+		}
+		if (file) {
 			__remove_shared_vm_struct(next, file, mapping);
+			if (remove_next == 2)
+				__remove_shared_vm_struct(next_next, file, mapping);
+		}
 	} else if (insert) {
 		/*
 		 * split_vma has split insert from vma, and needs
 		 * us to insert it before dropping the locks
 		 * (it may either follow vma or precede it).
 		 */
-		__insert_vm_struct(mm, insert);
+		__insert_vm_struct(mm, &mas, insert);
 	} else {
 		if (start_changed)
 			vma_gap_update(vma);
@@ -909,6 +1060,7 @@ again:
 	}
 
 	if (remove_next) {
+again:
 		if (file) {
 			uprobe_munmap(next, next->vm_start, next->vm_end);
 			fput(file);
@@ -930,7 +1082,7 @@ again:
 			 * "next->vm_prev->vm_end" changed and the
 			 * "vma->vm_next" gap must be updated.
 			 */
-			next = vma->vm_next;
+			next = next_next;
 		} else {
 			/*
 			 * For the scope of the comment "next" and
@@ -946,7 +1098,6 @@ again:
 		}
 		if (remove_next == 2) {
 			remove_next = 1;
-			end = next->vm_end;
 			goto again;
 		}
 		else if (next)
@@ -978,6 +1129,7 @@ again:
 		uprobe_mmap(insert);
 
 	validate_mm(mm);
+	validate_mm_mt(mm);
 
 	return 0;
 }
@@ -1131,6 +1283,7 @@ struct vm_area_struct *vma_merge(struct
 	struct vm_area_struct *area, *next;
 	int err;
 
+	validate_mm_mt(mm);
 	/*
 	 * We later require that vma->vm_flags == vm_flags,
 	 * so this tests vma->vm_flags & VM_SPECIAL, too.
@@ -1206,6 +1359,7 @@ struct vm_area_struct *vma_merge(struct
 		khugepaged_enter_vma(area, vm_flags);
 		return area;
 	}
+	validate_mm_mt(mm);
 
 	return NULL;
 }
@@ -1688,6 +1842,7 @@ unsigned long mmap_region(struct file *f
 	struct rb_node **rb_link, *rb_parent;
 	unsigned long charged = 0;
 
+	validate_mm_mt(mm);
 	/* Check against address space limit. */
 	if (!may_expand_vm(mm, vm_flags, len >> PAGE_SHIFT)) {
 		unsigned long nr_pages;
@@ -1802,7 +1957,13 @@ unsigned long mmap_region(struct file *f
 			goto free_vma;
 	}
 
-	vma_link(mm, vma, prev, rb_link, rb_parent);
+	if (vma_link(mm, vma, prev, rb_link, rb_parent)) {
+		error = -ENOMEM;
+		if (file)
+			goto unmap_and_free_vma;
+		else
+			goto free_vma;
+	}
 
 	/*
 	 * vma_merge() calls khugepaged_enter_vma() either, the below
@@ -1842,6 +2003,7 @@ out:
 
 	vma_set_page_prot(vma);
 
+	validate_mm_mt(mm);
 	return addr;
 
 unmap_and_free_vma:
@@ -1857,6 +2019,7 @@ free_vma:
 unacct_error:
 	if (charged)
 		vm_unacct_memory(charged);
+	validate_mm_mt(mm);
 	return error;
 }
 
@@ -1873,12 +2036,19 @@ static unsigned long unmapped_area(struc
 	struct mm_struct *mm = current->mm;
 	struct vm_area_struct *vma;
 	unsigned long length, low_limit, high_limit, gap_start, gap_end;
+	unsigned long gap;
+	MA_STATE(mas, &mm->mm_mt, 0, 0);
 
 	/* Adjust search length to account for worst case alignment overhead */
 	length = info->length + info->align_mask;
 	if (length < info->length)
 		return -ENOMEM;
 
+	mas_empty_area(&mas, info->low_limit, info->high_limit - 1,
+			   length);
+	gap = mas.index;
+	gap += (info->align_offset - gap) & info->align_mask;
+
 	/* Adjust search limits by the desired length */
 	if (info->high_limit < length)
 		return -ENOMEM;
@@ -1960,20 +2130,31 @@ found:
 
 	VM_BUG_ON(gap_start + info->length > info->high_limit);
 	VM_BUG_ON(gap_start + info->length > gap_end);
+
+	VM_BUG_ON(gap != gap_start);
 	return gap_start;
 }
 
 static unsigned long unmapped_area_topdown(struct vm_unmapped_area_info *info)
 {
 	struct mm_struct *mm = current->mm;
-	struct vm_area_struct *vma;
+	struct vm_area_struct *vma = NULL;
 	unsigned long length, low_limit, high_limit, gap_start, gap_end;
+	unsigned long gap;
+
+	MA_STATE(mas, &mm->mm_mt, 0, 0);
+	validate_mm_mt(mm);
 
 	/* Adjust search length to account for worst case alignment overhead */
 	length = info->length + info->align_mask;
 	if (length < info->length)
 		return -ENOMEM;
 
+	mas_empty_area_rev(&mas, info->low_limit, info->high_limit - 1,
+		   length);
+	gap = mas.last + 1 - info->length;
+	gap -= (gap - info->align_offset) & info->align_mask;
+
 	/*
 	 * Adjust search limits by the desired length.
 	 * See implementation comment at top of unmapped_area().
@@ -2059,6 +2240,32 @@ found_highest:
 
 	VM_BUG_ON(gap_end < info->low_limit);
 	VM_BUG_ON(gap_end < gap_start);
+
+	if (gap != gap_end) {
+		pr_err("%s: %p Gap was found: mt %lu gap_end %lu\n", __func__,
+		       mm, gap, gap_end);
+		pr_err("window was %lu - %lu size %lu\n", info->high_limit,
+		       info->low_limit, length);
+		pr_err("mas.min %lu max %lu mas.last %lu\n", mas.min, mas.max,
+		       mas.last);
+		pr_err("mas.index %lu align mask %lu offset %lu\n", mas.index,
+		       info->align_mask, info->align_offset);
+		pr_err("rb_find_vma find on %lu => %p (%p)\n", mas.index,
+		       find_vma(mm, mas.index), vma);
+#if defined(CONFIG_DEBUG_VM_MAPLE_TREE)
+		mt_dump(&mm->mm_mt);
+#endif
+		{
+			struct vm_area_struct *dv = mm->mmap;
+
+			while (dv) {
+				pr_err("vma %p %lu-%lu\n", dv, dv->vm_start, dv->vm_end);
+				dv = dv->vm_next;
+			}
+		}
+		VM_BUG_ON(gap != gap_end);
+	}
+
 	return gap_end;
 }
 
@@ -2284,7 +2491,6 @@ struct vm_area_struct *find_vma(struct m
 		vmacache_update(addr, vma);
 	return vma;
 }
-
 EXPORT_SYMBOL(find_vma);
 
 /*
@@ -2357,7 +2563,9 @@ int expand_upwards(struct vm_area_struct
 	struct vm_area_struct *next;
 	unsigned long gap_addr;
 	int error = 0;
+	MA_STATE(mas, &mm->mm_mt, 0, 0);
 
+	validate_mm_mt(mm);
 	if (!(vma->vm_flags & VM_GROWSUP))
 		return -EFAULT;
 
@@ -2381,9 +2589,14 @@ int expand_upwards(struct vm_area_struct
 		/* Check that both stack segments have the same anon_vma? */
 	}
 
+	if (mas_preallocate(&mas, vma, GFP_KERNEL))
+		return -ENOMEM;
+
 	/* We must make sure the anon_vma is allocated. */
-	if (unlikely(anon_vma_prepare(vma)))
+	if (unlikely(anon_vma_prepare(vma))) {
+		mas_destroy(&mas);
 		return -ENOMEM;
+	}
 
 	/*
 	 * vma->vm_start/vm_end cannot change under us because the caller
@@ -2420,6 +2633,8 @@ int expand_upwards(struct vm_area_struct
 				vm_stat_account(mm, vma->vm_flags, grow);
 				anon_vma_interval_tree_pre_update_vma(vma);
 				vma->vm_end = address;
+				/* Overwrite old entry in mtree. */
+				vma_mas_store(vma, &mas);
 				anon_vma_interval_tree_post_update_vma(vma);
 				if (vma->vm_next)
 					vma_gap_update(vma->vm_next);
@@ -2434,6 +2649,8 @@ int expand_upwards(struct vm_area_struct
 	anon_vma_unlock_write(vma->anon_vma);
 	khugepaged_enter_vma(vma, vma->vm_flags);
 	validate_mm(mm);
+	validate_mm_mt(mm);
+	mas_destroy(&mas);
 	return error;
 }
 #endif /* CONFIG_STACK_GROWSUP || CONFIG_IA64 */
@@ -2447,7 +2664,9 @@ int expand_downwards(struct vm_area_stru
 	struct mm_struct *mm = vma->vm_mm;
 	struct vm_area_struct *prev;
 	int error = 0;
+	MA_STATE(mas, &mm->mm_mt, 0, 0);
 
+	validate_mm(mm);
 	address &= PAGE_MASK;
 	if (address < mmap_min_addr)
 		return -EPERM;
@@ -2461,9 +2680,14 @@ int expand_downwards(struct vm_area_stru
 			return -ENOMEM;
 	}
 
+	if (mas_preallocate(&mas, vma, GFP_KERNEL))
+		return -ENOMEM;
+
 	/* We must make sure the anon_vma is allocated. */
-	if (unlikely(anon_vma_prepare(vma)))
+	if (unlikely(anon_vma_prepare(vma))) {
+		mas_destroy(&mas);
 		return -ENOMEM;
+	}
 
 	/*
 	 * vma->vm_start/vm_end cannot change under us because the caller
@@ -2501,6 +2725,8 @@ int expand_downwards(struct vm_area_stru
 				anon_vma_interval_tree_pre_update_vma(vma);
 				vma->vm_start = address;
 				vma->vm_pgoff -= grow;
+				/* Overwrite old entry in mtree. */
+				vma_mas_store(vma, &mas);
 				anon_vma_interval_tree_post_update_vma(vma);
 				vma_gap_update(vma);
 				spin_unlock(&mm->page_table_lock);
@@ -2512,6 +2738,7 @@ int expand_downwards(struct vm_area_stru
 	anon_vma_unlock_write(vma->anon_vma);
 	khugepaged_enter_vma(vma, vma->vm_flags);
 	validate_mm(mm);
+	mas_destroy(&mas);
 	return error;
 }
 
@@ -2633,14 +2860,17 @@ static void unmap_region(struct mm_struc
  * vma list as we go..
  */
 static bool
-detach_vmas_to_be_unmapped(struct mm_struct *mm, struct vm_area_struct *vma,
-	struct vm_area_struct *prev, unsigned long end)
+detach_vmas_to_be_unmapped(struct mm_struct *mm, struct ma_state *mas,
+	struct vm_area_struct *vma, struct vm_area_struct *prev,
+	unsigned long end)
 {
 	struct vm_area_struct **insertion_point;
 	struct vm_area_struct *tail_vma = NULL;
 
 	insertion_point = (prev ? &prev->vm_next : &mm->mmap);
 	vma->vm_prev = NULL;
+	mas_set_range(mas, vma->vm_start, end - 1);
+	mas_store_prealloc(mas, NULL);
 	do {
 		vma_rb_erase(vma, &mm->mm_rb);
 		if (vma->vm_flags & VM_LOCKED)
@@ -2681,6 +2911,7 @@ int __split_vma(struct mm_struct *mm, st
 {
 	struct vm_area_struct *new;
 	int err;
+	validate_mm_mt(mm);
 
 	if (vma->vm_ops && vma->vm_ops->may_split) {
 		err = vma->vm_ops->may_split(vma, addr);
@@ -2723,6 +2954,9 @@ int __split_vma(struct mm_struct *mm, st
 	if (!err)
 		return 0;
 
+	/* Avoid vm accounting in close() operation */
+	new->vm_start = new->vm_end;
+	new->vm_pgoff = 0;
 	/* Clean everything up if vma_adjust failed. */
 	if (new->vm_ops && new->vm_ops->close)
 		new->vm_ops->close(new);
@@ -2733,6 +2967,7 @@ int __split_vma(struct mm_struct *mm, st
 	mpol_put(vma_policy(new));
  out_free_vma:
 	vm_area_free(new);
+	validate_mm_mt(mm);
 	return err;
 }
 
@@ -2759,6 +2994,8 @@ int __do_munmap(struct mm_struct *mm, un
 {
 	unsigned long end;
 	struct vm_area_struct *vma, *prev, *last;
+	int error = -ENOMEM;
+	MA_STATE(mas, &mm->mm_mt, 0, 0);
 
 	if ((offset_in_page(start)) || start > TASK_SIZE || len > TASK_SIZE-start)
 		return -EINVAL;
@@ -2779,6 +3016,9 @@ int __do_munmap(struct mm_struct *mm, un
 	vma = find_vma_intersection(mm, start, end);
 	if (!vma)
 		return 0;
+
+	if (mas_preallocate(&mas, vma, GFP_KERNEL))
+		return -ENOMEM;
 	prev = vma->vm_prev;
 
 	/*
@@ -2789,7 +3029,6 @@ int __do_munmap(struct mm_struct *mm, un
 	 * places tmp vma above, and higher split_vma places tmp vma below.
 	 */
 	if (start > vma->vm_start) {
-		int error;
 
 		/*
 		 * Make sure that map_count on return from munmap() will
@@ -2797,20 +3036,20 @@ int __do_munmap(struct mm_struct *mm, un
 		 * its limit temporarily, to help free resources as expected.
 		 */
 		if (end < vma->vm_end && mm->map_count >= sysctl_max_map_count)
-			return -ENOMEM;
+			goto map_count_exceeded;
 
 		error = __split_vma(mm, vma, start, 0);
 		if (error)
-			return error;
+			goto split_failed;
 		prev = vma;
 	}
 
 	/* Does it split the last one? */
 	last = find_vma(mm, end);
 	if (last && end > last->vm_start) {
-		int error = __split_vma(mm, last, end, 1);
+		error = __split_vma(mm, last, end, 1);
 		if (error)
-			return error;
+			goto split_failed;
 	}
 	vma = vma_next(mm, prev);
 
@@ -2824,13 +3063,13 @@ int __do_munmap(struct mm_struct *mm, un
 		 * split, despite we could. This is unlikely enough
 		 * failure that it's not worth optimizing it for.
 		 */
-		int error = userfaultfd_unmap_prep(vma, start, end, uf);
+		error = userfaultfd_unmap_prep(vma, start, end, uf);
 		if (error)
-			return error;
+			goto userfaultfd_error;
 	}
 
 	/* Detach vmas from rbtree */
-	if (!detach_vmas_to_be_unmapped(mm, vma, prev, end))
+	if (!detach_vmas_to_be_unmapped(mm, &mas, vma, prev, end))
 		downgrade = false;
 
 	if (downgrade)
@@ -2842,6 +3081,12 @@ int __do_munmap(struct mm_struct *mm, un
 	remove_vma_list(mm, vma);
 
 	return downgrade ? 1 : 0;
+
+map_count_exceeded:
+split_failed:
+userfaultfd_error:
+	mas_destroy(&mas);
+	return error;
 }
 
 int do_munmap(struct mm_struct *mm, unsigned long start, size_t len,
@@ -2981,6 +3226,7 @@ static int do_brk_flags(unsigned long ad
 	pgoff_t pgoff = addr >> PAGE_SHIFT;
 	int error;
 	unsigned long mapped_addr;
+	validate_mm_mt(mm);
 
 	/* Until we need other flags, refuse anything except VM_EXEC. */
 	if ((flags & (~VM_EXEC)) != 0)
@@ -3030,7 +3276,9 @@ static int do_brk_flags(unsigned long ad
 	vma->vm_pgoff = pgoff;
 	vma->vm_flags = flags;
 	vma->vm_page_prot = vm_get_page_prot(flags);
-	vma_link(mm, vma, prev, rb_link, rb_parent);
+	if (vma_link(mm, vma, prev, rb_link, rb_parent))
+		goto no_vma_link;
+
 out:
 	perf_event_mmap(vma);
 	mm->total_vm += len >> PAGE_SHIFT;
@@ -3038,7 +3286,12 @@ out:
 	if (flags & VM_LOCKED)
 		mm->locked_vm += (len >> PAGE_SHIFT);
 	vma->vm_flags |= VM_SOFTDIRTY;
+	validate_mm_mt(mm);
 	return 0;
+
+no_vma_link:
+	vm_area_free(vma);
+	return -ENOMEM;
 }
 
 int vm_brk_flags(unsigned long addr, unsigned long request, unsigned long flags)
@@ -3127,6 +3380,9 @@ void exit_mmap(struct mm_struct *mm)
 		vma = remove_vma(vma);
 		cond_resched();
 	}
+
+	trace_exit_mmap(mm);
+	__mt_destroy(&mm->mm_mt);
 	mm->mmap = NULL;
 	mmap_write_unlock(mm);
 	vm_unacct_memory(nr_accounted);
@@ -3140,12 +3396,30 @@ int insert_vm_struct(struct mm_struct *m
 {
 	struct vm_area_struct *prev;
 	struct rb_node **rb_link, *rb_parent;
+	unsigned long start = vma->vm_start;
+	struct vm_area_struct *overlap = NULL;
+	unsigned long charged = vma_pages(vma);
 
 	if (find_vma_links(mm, vma->vm_start, vma->vm_end,
 			   &prev, &rb_link, &rb_parent))
+
+	if (find_vma_intersection(mm, vma->vm_start, vma->vm_end))
 		return -ENOMEM;
+
+	overlap = mt_find(&mm->mm_mt, &start, vma->vm_end - 1);
+	if (overlap) {
+
+		pr_err("Found vma ending at %lu\n", start - 1);
+		pr_err("vma : %lu => %lu-%lu\n", (unsigned long)overlap,
+				overlap->vm_start, overlap->vm_end - 1);
+#if defined(CONFIG_DEBUG_VM_MAPLE_TREE)
+		mt_dump(&mm->mm_mt);
+#endif
+		BUG();
+	}
+
 	if ((vma->vm_flags & VM_ACCOUNT) &&
-	     security_vm_enough_memory_mm(mm, vma_pages(vma)))
+	     security_vm_enough_memory_mm(mm, charged))
 		return -ENOMEM;
 
 	/*
@@ -3165,7 +3439,11 @@ int insert_vm_struct(struct mm_struct *m
 		vma->vm_pgoff = vma->vm_start >> PAGE_SHIFT;
 	}
 
-	vma_link(mm, vma, prev, rb_link, rb_parent);
+	if (vma_link(mm, vma, prev, rb_link, rb_parent)) {
+		vm_unacct_memory(charged);
+		return -ENOMEM;
+	}
+
 	return 0;
 }
 
@@ -3183,7 +3461,9 @@ struct vm_area_struct *copy_vma(struct v
 	struct vm_area_struct *new_vma, *prev;
 	struct rb_node **rb_link, *rb_parent;
 	bool faulted_in_anon_vma = true;
+	unsigned long index = addr;
 
+	validate_mm_mt(mm);
 	/*
 	 * If anonymous vma has not yet been faulted, update new pgoff
 	 * to match new location, to increase its chance of merging.
@@ -3195,6 +3475,8 @@ struct vm_area_struct *copy_vma(struct v
 
 	if (find_vma_links(mm, addr, addr + len, &prev, &rb_link, &rb_parent))
 		return NULL;	/* should never get here */
+	if (mt_find(&mm->mm_mt, &index, addr+len - 1))
+		BUG();
 	new_vma = vma_merge(mm, prev, addr, addr + len, vma->vm_flags,
 			    vma->anon_vma, vma->vm_file, pgoff, vma_policy(vma),
 			    vma->vm_userfaultfd_ctx, anon_vma_name(vma));
@@ -3238,6 +3520,7 @@ struct vm_area_struct *copy_vma(struct v
 		vma_link(mm, new_vma, prev, rb_link, rb_parent);
 		*need_rmap_locks = false;
 	}
+	validate_mm_mt(mm);
 	return new_vma;
 
 out_free_mempol:
@@ -3245,6 +3528,7 @@ out_free_mempol:
 out_free_vma:
 	vm_area_free(new_vma);
 out:
+	validate_mm_mt(mm);
 	return NULL;
 }
 
@@ -3381,6 +3665,7 @@ static struct vm_area_struct *__install_
 	int ret;
 	struct vm_area_struct *vma;
 
+	validate_mm_mt(mm);
 	vma = vm_area_alloc(mm);
 	if (unlikely(vma == NULL))
 		return ERR_PTR(-ENOMEM);
@@ -3403,10 +3688,12 @@ static struct vm_area_struct *__install_
 
 	perf_event_mmap(vma);
 
+	validate_mm_mt(mm);
 	return vma;
 
 out:
 	vm_area_free(vma);
+	validate_mm_mt(mm);
 	return ERR_PTR(ret);
 }
 
--- a/mm/nommu.c~mm-start-tracking-vmas-with-maple-tree
+++ a/mm/nommu.c
@@ -545,6 +545,19 @@ static void put_nommu_region(struct vm_r
 	__put_nommu_region(region);
 }
 
+void vma_mas_store(struct vm_area_struct *vma, struct ma_state *mas)
+{
+	mas_set_range(mas, vma->vm_start, vma->vm_end - 1);
+	mas_store_prealloc(mas, vma);
+}
+
+void vma_mas_remove(struct vm_area_struct *vma, struct ma_state *mas)
+{
+	mas->index = vma->vm_start;
+	mas->last = vma->vm_end - 1;
+	mas_store_prealloc(mas, NULL);
+}
+
 /*
  * add a VMA into a process's mm_struct in the appropriate place in the list
  * and tree and add to the address space's page tree also if not an anonymous
_

Patches currently in -mm which might be from Liam.Howlett@Oracle.com are

maple-tree-add-new-data-structure.patch
radix-tree-test-suite-add-pr_err-define.patch
radix-tree-test-suite-add-kmem_cache_set_non_kernel.patch
radix-tree-test-suite-add-allocation-counts-and-size-to-kmem_cache.patch
radix-tree-test-suite-add-support-for-slab-bulk-apis.patch
radix-tree-test-suite-add-lockdep_is_held-to-header.patch
lib-test_maple_tree-add-testing-for-maple-tree.patch
mm-start-tracking-vmas-with-maple-tree.patch
mm-mmap-use-the-maple-tree-in-find_vma-instead-of-the-rbtree.patch
mm-mmap-use-the-maple-tree-for-find_vma_prev-instead-of-the-rbtree.patch
mm-mmap-use-maple-tree-for-unmapped_area_topdown.patch
kernel-fork-use-maple-tree-for-dup_mmap-during-forking.patch
damon-convert-__damon_va_three_regions-to-use-the-vma-iterator.patch
mm-remove-rb-tree.patch
mmap-change-zeroing-of-maple-tree-in-__vma_adjust.patch
xen-use-vma_lookup-in-privcmd_ioctl_mmap.patch
mm-optimize-find_exact_vma-to-use-vma_lookup.patch
mm-khugepaged-optimize-collapse_pte_mapped_thp-by-using-vma_lookup.patch
mm-mmap-change-do_brk_flags-to-expand-existing-vma-and-add-do_brk_munmap.patch
mm-use-maple-tree-operations-for-find_vma_intersection.patch
mm-mmap-use-advanced-maple-tree-api-for-mmap_region.patch
mm-remove-vmacache.patch
mm-convert-vma_lookup-to-use-mtree_load.patch
mm-mmap-move-mmap_region-below-do_munmap.patch
mm-mmap-reorganize-munmap-to-use-maple-states.patch
mm-mmap-change-do_brk_munmap-to-use-do_mas_align_munmap.patch
arm64-change-elfcore-for_each_mte_vma-to-use-vma-iterator.patch
fs-proc-base-use-maple-tree-iterators-in-place-of-linked-list.patch
userfaultfd-use-maple-tree-iterator-to-iterate-vmas.patch
ipc-shm-use-vma-iterator-instead-of-linked-list.patch
bpf-remove-vma-linked-list.patch
mm-gup-use-maple-tree-navigation-instead-of-linked-list.patch
mm-madvise-use-vma_find-instead-of-vma-linked-list.patch
mm-memcontrol-stop-using-mm-highest_vm_end.patch
mm-mempolicy-use-vma-iterator-maple-state-instead-of-vma-linked-list.patch
mm-mprotect-use-maple-tree-navigation-instead-of-vma-linked-list.patch
mm-mremap-use-vma_find_intersection-instead-of-vma-linked-list.patch
mm-msync-use-vma_find-instead-of-vma-linked-list.patch
mm-oom_kill-use-maple-tree-iterators-instead-of-vma-linked-list.patch
mm-swapfile-use-vma-iterator-instead-of-vma-linked-list.patch
riscv-use-vma-iterator-for-vdso.patch
mm-remove-the-vma-linked-list.patch
mm-mmap-drop-range_has_overlap-function.patch
mm-mmapc-pass-in-mapping-to-__vma_link_file.patch

