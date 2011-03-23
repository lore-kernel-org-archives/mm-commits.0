From: akpm@linux-foundation.org
Subject: [merged] smaps-teach-smaps_pte_range-about-thp-pmds.patch removed from -mm tree
Date: Wed, 23 Mar 2011 13:36:42 -0700
Message-ID: <201103232040.p2NKeIfD028518@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60611 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933396Ab1CWUli (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Mar 2011 16:41:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dave@linux.vnet.ibm.com, aarcange@redhat.com, emunson@mgebm.net, hannes@cmpxchg.org, jeremy@goop.org, mel@csn.ul.ie, mjwolf@us.ibm.com, mpm@selenic.com, rientjes@google.com, mm-commit


The patch titled
     smaps: teach smaps_pte_range() about THP pmds
has been removed from the -mm tree.  Its filename was
     smaps-teach-smaps_pte_range-about-thp-pmds.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: smaps: teach smaps_pte_range() about THP pmds
From: Dave Hansen <dave@linux.vnet.ibm.com>

This adds code to explicitly detect and handle pmd_trans_huge() pmds.  It
then passes HPAGE_SIZE units in to the smap_pte_entry() function instead
of PAGE_SIZE.

This means that using /proc/$pid/smaps now will no longer cause THPs to be
broken down in to small pages.

Signed-off-by: Dave Hansen <dave@linux.vnet.ibm.com>
Reviewed-by: Eric B Munson <emunson@mgebm.net>
Tested-by: Eric B Munson <emunson@mgebm.net>
Acked-by: Andrea Arcangeli <aarcange@redhat.com>
Acked-by: David Rientjes <rientjes@google.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Michael J Wolf <mjwolf@us.ibm.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Matt Mackall <mpm@selenic.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/task_mmu.c |   23 +++++++++++++++++++++--
 1 file changed, 21 insertions(+), 2 deletions(-)

diff -puN fs/proc/task_mmu.c~smaps-teach-smaps_pte_range-about-thp-pmds fs/proc/task_mmu.c
--- a/fs/proc/task_mmu.c~smaps-teach-smaps_pte_range-about-thp-pmds
+++ a/fs/proc/task_mmu.c
@@ -1,5 +1,6 @@
 #include <linux/mm.h>
 #include <linux/hugetlb.h>
+#include <linux/huge_mm.h>
 #include <linux/mount.h>
 #include <linux/seq_file.h>
 #include <linux/highmem.h>
@@ -7,6 +8,7 @@
 #include <linux/slab.h>
 #include <linux/pagemap.h>
 #include <linux/mempolicy.h>
+#include <linux/rmap.h>
 #include <linux/swap.h>
 #include <linux/swapops.h>
 
@@ -385,8 +387,25 @@ static int smaps_pte_range(pmd_t *pmd, u
 	pte_t *pte;
 	spinlock_t *ptl;
 
-	split_huge_page_pmd(walk->mm, pmd);
-
+	spin_lock(&walk->mm->page_table_lock);
+	if (pmd_trans_huge(*pmd)) {
+		if (pmd_trans_splitting(*pmd)) {
+			spin_unlock(&walk->mm->page_table_lock);
+			wait_split_huge_page(vma->anon_vma, pmd);
+		} else {
+			smaps_pte_entry(*(pte_t *)pmd, addr,
+					HPAGE_PMD_SIZE, walk);
+			spin_unlock(&walk->mm->page_table_lock);
+			return 0;
+		}
+	} else {
+		spin_unlock(&walk->mm->page_table_lock);
+	}
+	/*
+	 * The mmap_sem held all the way back in m_start() is what
+	 * keeps khugepaged out of here and from collapsing things
+	 * in here.
+	 */
 	pte = pte_offset_map_lock(vma->vm_mm, pmd, addr, &ptl);
 	for (; addr != end; pte++, addr += PAGE_SIZE)
 		smaps_pte_entry(*pte, addr, PAGE_SIZE, walk);
_

Patches currently in -mm which might be from dave@linux.vnet.ibm.com are

origin.patch
page_cgroup-reduce-allocation-overhead-for-page_cgroup-array-for-config_sparsemem.patch
page_cgroup-reduce-allocation-overhead-for-page_cgroup-array-for-config_sparsemem-fix.patch

