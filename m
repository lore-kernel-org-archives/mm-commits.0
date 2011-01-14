From: akpm@linux-foundation.org
Subject: [merged] thp-add-pmd_huge_pte-to-mm_struct.patch removed from -mm tree
Date: Fri, 14 Jan 2011 14:47:03 -0800
Message-ID: <201101142249.p0EMnrnf005333@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55432 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753863Ab1ANWuB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 14 Jan 2011 17:50:01 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aarcange@redhat.com, mel@csn.ul.ie, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     thp: add pmd_huge_pte to mm_struct
has been removed from the -mm tree.  Its filename was
     thp-add-pmd_huge_pte-to-mm_struct.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: thp: add pmd_huge_pte to mm_struct
From: Andrea Arcangeli <aarcange@redhat.com>

This increase the size of the mm struct a bit but it is needed to
preallocate one pte for each hugepage so that split_huge_page will not
require a fail path.  Guarantee of success is a fundamental property of
split_huge_page to avoid decrasing swapping reliability and to avoid
adding -ENOMEM fail paths that would otherwise force the hugepage-unaware
VM code to learn rolling back in the middle of its pte mangling operations
(if something we need it to learn handling pmd_trans_huge natively rather
being capable of rollback).  When split_huge_page runs a pte is needed to
succeed the split, to map the newly splitted regular pages with a regular
pte.  This way all existing VM code remains backwards compatible by just
adding a split_huge_page* one liner.  The memory waste of those
preallocated ptes is negligible and so it is worth it.

Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Acked-by: Rik van Riel <riel@redhat.com>
Acked-by: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm_types.h |    3 +++
 kernel/fork.c            |    7 +++++++
 2 files changed, 10 insertions(+)

diff -puN include/linux/mm_types.h~thp-add-pmd_huge_pte-to-mm_struct include/linux/mm_types.h
--- a/include/linux/mm_types.h~thp-add-pmd_huge_pte-to-mm_struct
+++ a/include/linux/mm_types.h
@@ -310,6 +310,9 @@ struct mm_struct {
 #ifdef CONFIG_MMU_NOTIFIER
 	struct mmu_notifier_mm *mmu_notifier_mm;
 #endif
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
+	pgtable_t pmd_huge_pte; /* protected by page_table_lock */
+#endif
 	/* How many tasks sharing this mm are OOM_DISABLE */
 	atomic_t oom_disable_count;
 };
diff -puN kernel/fork.c~thp-add-pmd_huge_pte-to-mm_struct kernel/fork.c
--- a/kernel/fork.c~thp-add-pmd_huge_pte-to-mm_struct
+++ a/kernel/fork.c
@@ -529,6 +529,9 @@ void __mmdrop(struct mm_struct *mm)
 	mm_free_pgd(mm);
 	destroy_context(mm);
 	mmu_notifier_mm_destroy(mm);
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
+	VM_BUG_ON(mm->pmd_huge_pte);
+#endif
 	free_mm(mm);
 }
 EXPORT_SYMBOL_GPL(__mmdrop);
@@ -669,6 +672,10 @@ struct mm_struct *dup_mm(struct task_str
 	mm->token_priority = 0;
 	mm->last_interval = 0;
 
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
+	mm->pmd_huge_pte = NULL;
+#endif
+
 	if (!mm_init(mm, tsk))
 		goto fail_nomem;
 
_

Patches currently in -mm which might be from aarcange@redhat.com are

origin.patch
thp-add-pagetranscompound.patch

