From: akpm@linux-foundation.org
Subject: [merged] mm-thp-optimize-memcg-charge-in-khugepaged.patch removed from -mm tree
Date: Wed, 25 May 2011 13:29:10 -0700
Message-ID: <201105252027.p4PKRXpr014586@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56385 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932407Ab1EYUtK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 25 May 2011 16:49:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aarcange@redhat.com, hughd@google.com, jweiner@redhat.com, minchan.kim@gmail.com, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     mm: thp: optimize memcg charge in khugepaged
has been removed from the -mm tree.  Its filename was
     mm-thp-optimize-memcg-charge-in-khugepaged.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: thp: optimize memcg charge in khugepaged
From: Andrea Arcangeli <aarcange@redhat.com>

We don't need to hold the mmmap_sem through mem_cgroup_newpage_charge(),
the mmap_sem is only hold for keeping the vma stable and we don't need the
vma stable anymore after we return from alloc_hugepage_vma().

Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Cc: Johannes Weiner <jweiner@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Minchan Kim <minchan.kim@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |   21 +++++++++++----------
 1 file changed, 11 insertions(+), 10 deletions(-)

diff -puN mm/huge_memory.c~mm-thp-optimize-memcg-charge-in-khugepaged mm/huge_memory.c
--- a/mm/huge_memory.c~mm-thp-optimize-memcg-charge-in-khugepaged
+++ a/mm/huge_memory.c
@@ -1771,12 +1771,9 @@ static void collapse_huge_page(struct mm
 
 	VM_BUG_ON(address & ~HPAGE_PMD_MASK);
 #ifndef CONFIG_NUMA
+	up_read(&mm->mmap_sem);
 	VM_BUG_ON(!*hpage);
 	new_page = *hpage;
-	if (unlikely(mem_cgroup_newpage_charge(new_page, mm, GFP_KERNEL))) {
-		up_read(&mm->mmap_sem);
-		return;
-	}
 #else
 	VM_BUG_ON(*hpage);
 	/*
@@ -1791,22 +1788,26 @@ static void collapse_huge_page(struct mm
 	 */
 	new_page = alloc_hugepage_vma(khugepaged_defrag(), vma, address,
 				      node, __GFP_OTHER_NODE);
+
+	/*
+	 * After allocating the hugepage, release the mmap_sem read lock in
+	 * preparation for taking it in write mode.
+	 */
+	up_read(&mm->mmap_sem);
 	if (unlikely(!new_page)) {
-		up_read(&mm->mmap_sem);
 		count_vm_event(THP_COLLAPSE_ALLOC_FAILED);
 		*hpage = ERR_PTR(-ENOMEM);
 		return;
 	}
+#endif
+
 	count_vm_event(THP_COLLAPSE_ALLOC);
 	if (unlikely(mem_cgroup_newpage_charge(new_page, mm, GFP_KERNEL))) {
-		up_read(&mm->mmap_sem);
+#ifdef CONFIG_NUMA
 		put_page(new_page);
+#endif
 		return;
 	}
-#endif
