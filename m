Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA783C77B7D
	for <mm-commits@archiver.kernel.org>; Thu, 18 May 2023 21:32:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231197AbjERVck (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 18 May 2023 17:32:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231124AbjERVby (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 18 May 2023 17:31:54 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 707D0211C
        for <mm-commits@vger.kernel.org>; Thu, 18 May 2023 14:31:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8C4FA6494A
        for <mm-commits@vger.kernel.org>; Thu, 18 May 2023 21:29:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBC1FC433EF;
        Thu, 18 May 2023 21:29:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1684445366;
        bh=IxK12WbffPRfQubUe8vIHjCqBVuBURO34rMygQdAFSo=;
        h=Date:To:From:Subject:From;
        b=kmv9JyPdJP9bUHRZIYys58NUlILGX6mfOZv5ivTDrWxIJVqHftwjSH9sd2z+CvKZ9
         /GBTKi6LaFcOSoSpySUP8YdXR0rz+wbXAJBw44HqDDKatDYt/fqv0gflPUMv8gYQog
         XP5fR8fijDF7kTUFU8OkVS+uaNasoZB0+dwgf1Nw=
Date:   Thu, 18 May 2023 14:29:25 -0700
To:     mm-commits@vger.kernel.org, zhangpeng.00@bytedance.com,
        vernon2gm@gmail.com, senozhatsky@chromium.org,
        richard.weiyang@gmail.com, dcb314@hotmail.com,
        Liam.Howlett@oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-update-validate_mm-to-use-vma-iterator.patch added to mm-unstable branch
Message-Id: <20230518212925.DBC1FC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: update validate_mm() to use vma iterator
has been added to the -mm mm-unstable branch.  Its filename is
     mm-update-validate_mm-to-use-vma-iterator.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-update-validate_mm-to-use-vma-iterator.patch

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
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Subject: mm: update validate_mm() to use vma iterator
Date: Thu, 18 May 2023 10:55:26 -0400

Use the vma iterator in the validation code and combine the code to check
the maple tree into the main validate_mm() function.

Introduce a new function vma_iter_dump_tree() to dump the maple tree in
hex layout.

Replace all calls to validate_mm_mt() with validate_mm().

Link: https://lkml.kernel.org/r/20230518145544.1722059-18-Liam.Howlett@oracle.com
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: David Binderman <dcb314@hotmail.com>
Cc: Peng Zhang <zhangpeng.00@bytedance.com>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Vernon Yang <vernon2gm@gmail.com>
Cc: Wei Yang <richard.weiyang@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmdebug.h |   14 +++++
 mm/debug.c              |    9 +++
 mm/internal.h           |    3 -
 mm/mmap.c               |  101 +++++++++++++++-----------------------
 4 files changed, 66 insertions(+), 61 deletions(-)

--- a/include/linux/mmdebug.h~mm-update-validate_mm-to-use-vma-iterator
+++ a/include/linux/mmdebug.h
@@ -8,10 +8,12 @@
 struct page;
 struct vm_area_struct;
 struct mm_struct;
+struct vma_iterator;
 
 void dump_page(struct page *page, const char *reason);
 void dump_vma(const struct vm_area_struct *vma);
 void dump_mm(const struct mm_struct *mm);
+void vma_iter_dump_tree(const struct vma_iterator *vmi);
 
 #ifdef CONFIG_DEBUG_VM
 #define VM_BUG_ON(cond) BUG_ON(cond)
@@ -74,6 +76,17 @@ void dump_mm(const struct mm_struct *mm)
 	}								\
 	unlikely(__ret_warn_once);					\
 })
+#define VM_WARN_ON_ONCE_MM(cond, mm)		({			\
+	static bool __section(".data.once") __warned;			\
+	int __ret_warn_once = !!(cond);					\
+									\
+	if (unlikely(__ret_warn_once && !__warned)) {			\
+		dump_mm(mm);						\
+		__warned = true;					\
+		WARN_ON(1);						\
+	}								\
+	unlikely(__ret_warn_once);					\
+})
 
 #define VM_WARN_ON(cond) (void)WARN_ON(cond)
 #define VM_WARN_ON_ONCE(cond) (void)WARN_ON_ONCE(cond)
@@ -90,6 +103,7 @@ void dump_mm(const struct mm_struct *mm)
 #define VM_WARN_ON_ONCE_PAGE(cond, page)  BUILD_BUG_ON_INVALID(cond)
 #define VM_WARN_ON_FOLIO(cond, folio)  BUILD_BUG_ON_INVALID(cond)
 #define VM_WARN_ON_ONCE_FOLIO(cond, folio)  BUILD_BUG_ON_INVALID(cond)
+#define VM_WARN_ON_ONCE_MM(cond, mm)  BUILD_BUG_ON_INVALID(cond)
 #define VM_WARN_ONCE(cond, format...) BUILD_BUG_ON_INVALID(cond)
 #define VM_WARN(cond, format...) BUILD_BUG_ON_INVALID(cond)
 #endif
--- a/mm/debug.c~mm-update-validate_mm-to-use-vma-iterator
+++ a/mm/debug.c
@@ -268,4 +268,13 @@ void page_init_poison(struct page *page,
 	if (page_init_poisoning)
 		memset(page, PAGE_POISON_PATTERN, size);
 }
+
+void vma_iter_dump_tree(const struct vma_iterator *vmi)
+{
+#if defined(CONFIG_DEBUG_VM_MAPLE_TREE)
+	mas_dump(&vmi->mas);
+	mt_dump(vmi->mas.tree, mt_dump_hex);
+#endif	/* CONFIG_DEBUG_VM_MAPLE_TREE */
+}
+
 #endif		/* CONFIG_DEBUG_VM */
--- a/mm/internal.h~mm-update-validate_mm-to-use-vma-iterator
+++ a/mm/internal.h
@@ -1064,13 +1064,14 @@ static inline void vma_iter_store(struct
 		printk("%lu > %lu\n", vmi->mas.index, vma->vm_start);
 		printk("store of vma %lu-%lu", vma->vm_start, vma->vm_end);
 		printk("into slot    %lu-%lu", vmi->mas.index, vmi->mas.last);
-		mt_dump(vmi->mas.tree, mt_dump_hex);
+		vma_iter_dump_tree(vmi);
 	}
 	if (WARN_ON(vmi->mas.node != MAS_START && vmi->mas.last <  vma->vm_start)) {
 		printk("%lu < %lu\n", vmi->mas.last, vma->vm_start);
 		printk("store of vma %lu-%lu", vma->vm_start, vma->vm_end);
 		printk("into slot    %lu-%lu", vmi->mas.index, vmi->mas.last);
 		mt_dump(vmi->mas.tree, mt_dump_hex);
+		vma_iter_dump_tree(vmi);
 	}
 #endif
 
--- a/mm/mmap.c~mm-update-validate_mm-to-use-vma-iterator
+++ a/mm/mmap.c
@@ -299,62 +299,44 @@ out:
 	return origbrk;
 }
 
-#if defined(CONFIG_DEBUG_VM_MAPLE_TREE)
-extern void mt_validate(struct maple_tree *mt);
-extern void mt_dump(const struct maple_tree *mt, enum mt_dump_format fmt);
-
-/* Validate the maple tree */
-static void validate_mm_mt(struct mm_struct *mm)
-{
-	struct maple_tree *mt = &mm->mm_mt;
-	struct vm_area_struct *vma_mt;
-
-	MA_STATE(mas, mt, 0, 0);
-
-	mt_validate(&mm->mm_mt);
-	mas_for_each(&mas, vma_mt, ULONG_MAX) {
-		if ((vma_mt->vm_start != mas.index) ||
-		    (vma_mt->vm_end - 1 != mas.last)) {
-			pr_emerg("issue in %s\n", current->comm);
-			dump_stack();
-			dump_vma(vma_mt);
-			pr_emerg("mt piv: %p %lu - %lu\n", vma_mt,
-				 mas.index, mas.last);
-			pr_emerg("mt vma: %p %lu - %lu\n", vma_mt,
-				 vma_mt->vm_start, vma_mt->vm_end);
-
-			mt_dump(mas.tree, mt_dump_hex);
-			if (vma_mt->vm_end != mas.last + 1) {
-				pr_err("vma: %p vma_mt %lu-%lu\tmt %lu-%lu\n",
-						mm, vma_mt->vm_start, vma_mt->vm_end,
-						mas.index, mas.last);
-				mt_dump(mas.tree, mt_dump_hex);
-			}
-			VM_BUG_ON_MM(vma_mt->vm_end != mas.last + 1, mm);
-			if (vma_mt->vm_start != mas.index) {
-				pr_err("vma: %p vma_mt %p %lu - %lu doesn't match\n",
-						mm, vma_mt, vma_mt->vm_start, vma_mt->vm_end);
-				mt_dump(mas.tree, mt_dump_hex);
-			}
-			VM_BUG_ON_MM(vma_mt->vm_start != mas.index, mm);
-		}
-	}
-}
-
+#if defined(CONFIG_DEBUG_VM)
 static void validate_mm(struct mm_struct *mm)
 {
 	int bug = 0;
 	int i = 0;
 	struct vm_area_struct *vma;
-	MA_STATE(mas, &mm->mm_mt, 0, 0);
+	VMA_ITERATOR(vmi, mm, 0);
 
-	validate_mm_mt(mm);
+#if defined(CONFIG_DEBUG_VM_MAPLE_TREE)
+	mt_validate(&mm->mm_mt);
+#endif
 
-	mas_for_each(&mas, vma, ULONG_MAX) {
+	for_each_vma(vmi, vma) {
 #ifdef CONFIG_DEBUG_VM_RB
 		struct anon_vma *anon_vma = vma->anon_vma;
 		struct anon_vma_chain *avc;
+#endif
+		unsigned long vmi_start, vmi_end;
+		bool warn = 0;
+
+		vmi_start = vma_iter_addr(&vmi);
+		vmi_end = vma_iter_end(&vmi);
+		if (VM_WARN_ON_ONCE_MM(vma->vm_end != vmi_end, mm))
+			warn = 1;
+
+		if (VM_WARN_ON_ONCE_MM(vma->vm_start != vmi_start, mm))
+			warn = 1;
+
+		if (warn) {
+			pr_emerg("issue in %s\n", current->comm);
+			dump_stack();
+			dump_vma(vma);
+			pr_emerg("tree range: %px start %lx end %lx\n", vma,
+				 vmi_start, vmi_end - 1);
+			vma_iter_dump_tree(&vmi);
+		}
 
+#ifdef CONFIG_DEBUG_VM_RB
 		if (anon_vma) {
 			anon_vma_lock_read(anon_vma);
 			list_for_each_entry(avc, &vma->anon_vma_chain, same_vma)
@@ -365,16 +347,15 @@ static void validate_mm(struct mm_struct
 		i++;
 	}
 	if (i != mm->map_count) {
-		pr_emerg("map_count %d mas_for_each %d\n", mm->map_count, i);
+		pr_emerg("map_count %d vma iterator %d\n", mm->map_count, i);
 		bug = 1;
 	}
 	VM_BUG_ON_MM(bug, mm);
 }
 
-#else /* !CONFIG_DEBUG_VM_MAPLE_TREE */
-#define validate_mm_mt(root) do { } while (0)
+#else /* !CONFIG_DEBUG_VM */
 #define validate_mm(mm) do { } while (0)
-#endif /* CONFIG_DEBUG_VM_MAPLE_TREE */
+#endif /* CONFIG_DEBUG_VM */
 
 /*
  * vma has some anon_vma assigned, and is already inserted on that
@@ -2268,7 +2249,7 @@ int __split_vma(struct vma_iterator *vmi
 	struct vm_area_struct *new;
 	int err;
 
-	validate_mm_mt(vma->vm_mm);
+	validate_mm(vma->vm_mm);
 
 	WARN_ON(vma->vm_start >= addr);
 	WARN_ON(vma->vm_end <= addr);
@@ -2326,7 +2307,7 @@ int __split_vma(struct vma_iterator *vmi
 	/* Success. */
 	if (new_below)
 		vma_next(vmi);
-	validate_mm_mt(vma->vm_mm);
+	validate_mm(vma->vm_mm);
 	return 0;
 
 out_free_mpol:
@@ -2335,7 +2316,7 @@ out_free_vmi:
 	vma_iter_free(vmi);
 out_free_vma:
 	vm_area_free(new);
-	validate_mm_mt(vma->vm_mm);
+	validate_mm(vma->vm_mm);
 	return err;
 }
 
@@ -2970,7 +2951,7 @@ int do_vma_munmap(struct vma_iterator *v
 
 	arch_unmap(mm, start, end);
 	ret = do_vmi_align_munmap(vmi, vma, mm, start, end, uf, downgrade);
-	validate_mm_mt(mm);
+	validate_mm(mm);
 	return ret;
 }
 
@@ -2992,7 +2973,7 @@ static int do_brk_flags(struct vma_itera
 	struct mm_struct *mm = current->mm;
 	struct vma_prepare vp;
 
-	validate_mm_mt(mm);
+	validate_mm(mm);
 	/*
 	 * Check against address space limits by the changed size
 	 * Note: This happens *after* clearing old mappings in some code paths.
@@ -3233,7 +3214,7 @@ struct vm_area_struct *copy_vma(struct v
 	bool faulted_in_anon_vma = true;
 	VMA_ITERATOR(vmi, mm, addr);
 
-	validate_mm_mt(mm);
+	validate_mm(mm);
 	/*
 	 * If anonymous vma has not yet been faulted, update new pgoff
 	 * to match new location, to increase its chance of merging.
@@ -3292,7 +3273,7 @@ struct vm_area_struct *copy_vma(struct v
 			goto out_vma_link;
 		*need_rmap_locks = false;
 	}
-	validate_mm_mt(mm);
+	validate_mm(mm);
 	return new_vma;
 
 out_vma_link:
@@ -3308,7 +3289,7 @@ out_free_mempol:
 out_free_vma:
 	vm_area_free(new_vma);
 out:
-	validate_mm_mt(mm);
+	validate_mm(mm);
 	return NULL;
 }
 
@@ -3445,7 +3426,7 @@ static struct vm_area_struct *__install_
 	int ret;
 	struct vm_area_struct *vma;
 
-	validate_mm_mt(mm);
+	validate_mm(mm);
 	vma = vm_area_alloc(mm);
 	if (unlikely(vma == NULL))
 		return ERR_PTR(-ENOMEM);
@@ -3468,12 +3449,12 @@ static struct vm_area_struct *__install_
 
 	perf_event_mmap(vma);
 
-	validate_mm_mt(mm);
+	validate_mm(mm);
 	return vma;
 
 out:
 	vm_area_free(vma);
-	validate_mm_mt(mm);
+	validate_mm(mm);
 	return ERR_PTR(ret);
 }
 
_

Patches currently in -mm which might be from Liam.Howlett@oracle.com are

maple_tree-fix-static-analyser-cppcheck-issue.patch
maple_tree-avoid-unnecessary-ascending.patch
maple_tree-clean-up-mas_dfs_postorder.patch
maple_tree-add-debug-bug_on-and-warn_on-variants.patch
maple_tree-use-mas_bug_on-when-setting-a-leaf-node-as-a-parent.patch
maple_tree-use-mas_bug_on-in-mas_set_height.patch
maple_tree-use-mas_bug_on-from-mas_topiary_range.patch
maple_tree-use-mas_wr_bug_on-in-mas_store_prealloc.patch
maple_tree-use-mas_bug_on-prior-to-calling-mas_meta_gap.patch
maple_tree-return-error-on-mte_pivots-out-of-range.patch
maple_tree-make-test-code-work-without-debug-enabled.patch
mm-update-validate_mm-to-use-vma-iterator.patch
mm-update-vma_iter_store-to-use-mas_warn_on.patch
maple_tree-add-__init-and-__exit-to-test-module.patch
maple_tree-remove-unnecessary-check-from-mas_destroy.patch
maple_tree-mas_start-reset-depth-on-dead-node.patch
mm-mmap-change-do_vmi_align_munmap-for-maple-tree-iterator-changes.patch
maple_tree-try-harder-to-keep-active-node-after-mas_next.patch
maple_tree-try-harder-to-keep-active-node-with-mas_prev.patch
maple_tree-revise-limit-checks-in-mas_empty_area_rev.patch
maple_tree-fix-testing-mas_empty_area.patch
maple_tree-introduce-mas_next_slot-interface.patch
maple_tree-add-mas_next_range-and-mas_find_range-interfaces.patch
maple_tree-relocate-mas_rewalk-and-mas_rewalk_if_dead.patch
maple_tree-introduce-mas_prev_slot-interface.patch
maple_tree-add-mas_prev_range-and-mas_find_range_rev-interface.patch
maple_tree-clear-up-index-and-last-setting-in-single-entry-tree.patch
maple_tree-update-testing-code-for-mas_nextprevwalk.patch
mm-add-vma_iter_nextprev_range-to-vma-iterator.patch
mm-avoid-rewalk-in-mmap_region.patch

