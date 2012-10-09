From: akpm@linux-foundation.org
Subject: [merged] mm-add-config_debug_vm_rb-build-option.patch removed from -mm tree
Date: Tue, 09 Oct 2012 11:10:54 -0700
Message-ID: <20121009181055.351E620004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ea0-f202.google.com ([209.85.215.202]:32854 "EHLO
	mail-ea0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756686Ab2JISK6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Oct 2012 14:10:58 -0400
Received: by mail-ea0-f202.google.com with SMTP id q10so59063eaa.1
        for <mm-commits@vger.kernel.org>; Tue, 09 Oct 2012 11:10:57 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: walken@google.com, a.p.zijlstra@chello.nl, aarcange@redhat.com, daniel.santos@pobox.com, hughd@google.com, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: add CONFIG_DEBUG_VM_RB build option
has been removed from the -mm tree.  Its filename was
     mm-add-config_debug_vm_rb-build-option.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Michel Lespinasse <walken@google.com>
Subject: mm: add CONFIG_DEBUG_VM_RB build option

Add a CONFIG_DEBUG_VM_RB build option for the previously existing
DEBUG_MM_RB code.  Now that Andi Kleen modified it to avoid using
recursive algorithms, we can expose it a bit more.

Also extend this code to validate_mm() after stack expansion, and to check
that the vma's start and last pgoffs have not changed since the nodes were
inserted on the anon vma interval tree (as it is important that the nodes
be reindexed after each such update).

Signed-off-by: Michel Lespinasse <walken@google.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Daniel Santos <daniel.santos@pobox.com>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h   |    3 +++
 include/linux/rmap.h |    3 +++
 lib/Kconfig.debug    |    9 +++++++++
 mm/interval_tree.c   |   41 ++++++++++++++++++++++++++++++++++++++++-
 mm/mmap.c            |   19 +++++++++----------
 5 files changed, 64 insertions(+), 11 deletions(-)

diff -puN include/linux/mm.h~mm-add-config_debug_vm_rb-build-option include/linux/mm.h
--- a/include/linux/mm.h~mm-add-config_debug_vm_rb-build-option
+++ a/include/linux/mm.h
@@ -1386,6 +1386,9 @@ struct anon_vma_chain *anon_vma_interval
 	struct rb_root *root, unsigned long start, unsigned long last);
 struct anon_vma_chain *anon_vma_interval_tree_iter_next(
 	struct anon_vma_chain *node, unsigned long start, unsigned long last);
+#ifdef CONFIG_DEBUG_VM_RB
+void anon_vma_interval_tree_verify(struct anon_vma_chain *node);
+#endif
 
 #define anon_vma_interval_tree_foreach(avc, root, start, last)		 \
 	for (avc = anon_vma_interval_tree_iter_first(root, start, last); \
diff -puN include/linux/rmap.h~mm-add-config_debug_vm_rb-build-option include/linux/rmap.h
--- a/include/linux/rmap.h~mm-add-config_debug_vm_rb-build-option
+++ a/include/linux/rmap.h
@@ -66,6 +66,9 @@ struct anon_vma_chain {
 	struct list_head same_vma;   /* locked by mmap_sem & page_table_lock */
 	struct rb_node rb;			/* locked by anon_vma->mutex */
 	unsigned long rb_subtree_last;
+#ifdef CONFIG_DEBUG_VM_RB
+	unsigned long cached_vma_start, cached_vma_last;
+#endif
 };
 
 #ifdef CONFIG_MMU
diff -puN lib/Kconfig.debug~mm-add-config_debug_vm_rb-build-option lib/Kconfig.debug
--- a/lib/Kconfig.debug~mm-add-config_debug_vm_rb-build-option
+++ a/lib/Kconfig.debug
@@ -798,6 +798,15 @@ config DEBUG_VM
 
 	  If unsure, say N.
 
+config DEBUG_VM_RB
+	bool "Debug VM red-black trees"
+	depends on DEBUG_VM
+	help
+	  Enable this to turn on more extended checks in the virtual-memory
+	  system that may impact performance.
+
+	  If unsure, say N.
+
 config DEBUG_VIRTUAL
 	bool "Debug VM translations"
 	depends on DEBUG_KERNEL && X86
diff -puN mm/interval_tree.c~mm-add-config_debug_vm_rb-build-option mm/interval_tree.c
--- a/mm/interval_tree.c~mm-add-config_debug_vm_rb-build-option
+++ a/mm/interval_tree.c
@@ -70,4 +70,43 @@ static inline unsigned long avc_last_pgo
 }
 
 INTERVAL_TREE_DEFINE(struct anon_vma_chain, rb, unsigned long, rb_subtree_last,
-		     avc_start_pgoff, avc_last_pgoff,, anon_vma_interval_tree)
+		     avc_start_pgoff, avc_last_pgoff,
+		     static inline, __anon_vma_interval_tree)
+
+void anon_vma_interval_tree_insert(struct anon_vma_chain *node,
+				   struct rb_root *root)
+{
+#ifdef CONFIG_DEBUG_VM_RB
+	node->cached_vma_start = avc_start_pgoff(node);
+	node->cached_vma_last = avc_last_pgoff(node);
+#endif
+	__anon_vma_interval_tree_insert(node, root);
+}
+
+void anon_vma_interval_tree_remove(struct anon_vma_chain *node,
+				   struct rb_root *root)
+{
+	__anon_vma_interval_tree_remove(node, root);
+}
+
+struct anon_vma_chain *
+anon_vma_interval_tree_iter_first(struct rb_root *root,
+				  unsigned long first, unsigned long last)
+{
+	return __anon_vma_interval_tree_iter_first(root, first, last);
+}
+
+struct anon_vma_chain *
+anon_vma_interval_tree_iter_next(struct anon_vma_chain *node,
+				 unsigned long first, unsigned long last)
+{
+	return __anon_vma_interval_tree_iter_next(node, first, last);
+}
+
+#ifdef CONFIG_DEBUG_VM_RB
+void anon_vma_interval_tree_verify(struct anon_vma_chain *node)
+{
+	WARN_ON_ONCE(node->cached_vma_start != avc_start_pgoff(node));
+	WARN_ON_ONCE(node->cached_vma_last != avc_last_pgoff(node));
+}
+#endif
diff -puN mm/mmap.c~mm-add-config_debug_vm_rb-build-option mm/mmap.c
--- a/mm/mmap.c~mm-add-config_debug_vm_rb-build-option
+++ a/mm/mmap.c
@@ -51,12 +51,6 @@ static void unmap_region(struct mm_struc
 		struct vm_area_struct *vma, struct vm_area_struct *prev,
 		unsigned long start, unsigned long end);
 
-/*
- * WARNING: the debugging will use recursive algorithms so never enable this
- * unless you know what you are doing.
- */
-#undef DEBUG_MM_RB
-
 /* description of effects of mapping type and prot in current implementation.
  * this is due to the limited x86 page protection hardware.  The expected
  * behavior is in parens:
@@ -303,7 +297,7 @@ out:
 	return retval;
 }
 
-#ifdef DEBUG_MM_RB
+#ifdef CONFIG_DEBUG_VM_RB
 static int browse_rb(struct rb_root *root)
 {
 	int i = 0, j;
@@ -337,9 +331,12 @@ void validate_mm(struct mm_struct *mm)
 {
 	int bug = 0;
 	int i = 0;
-	struct vm_area_struct *tmp = mm->mmap;
-	while (tmp) {
-		tmp = tmp->vm_next;
+	struct vm_area_struct *vma = mm->mmap;
+	while (vma) {
+		struct anon_vma_chain *avc;
+		list_for_each_entry(avc, &vma->anon_vma_chain, same_vma)
+			anon_vma_interval_tree_verify(avc);
+		vma = vma->vm_next;
 		i++;
 	}
 	if (i != mm->map_count)
@@ -1790,6 +1787,7 @@ int expand_upwards(struct vm_area_struct
 	}
 	vma_unlock_anon_vma(vma);
 	khugepaged_enter_vma_merge(vma);
+	validate_mm(vma->vm_mm);
 	return error;
 }
 #endif /* CONFIG_STACK_GROWSUP || CONFIG_IA64 */
@@ -1843,6 +1841,7 @@ int expand_downwards(struct vm_area_stru
 	}
 	vma_unlock_anon_vma(vma);
 	khugepaged_enter_vma_merge(vma);
+	validate_mm(vma->vm_mm);
 	return error;
 }
 
_

Patches currently in -mm which might be from walken@google.com are

origin.patch
prio_tree-remove-fix.patch

