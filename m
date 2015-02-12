From: akpm@linux-foundation.org
Subject: [merged] numa_maps-fix-typo-in-gather_hugetbl_stats.patch removed from -mm tree
Date: Thu, 12 Feb 2015 11:38:25 -0800
Message-ID: <54dd0131.URnO4XUJNNqp+Hc0%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58447 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752174AbbBLTi0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 12 Feb 2015 14:38:26 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: n-horiguchi@ah.jp.nec.com, aarcange@redhat.com, benh@kernel.crashing.org, dave.hansen@intel.com, gorcunov@openvz.org, kirill.shutemov@linux.intel.com, xemul@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: numa_maps: fix typo in gather_hugetbl_stats
has been removed from the -mm tree.  Its filename was
     numa_maps-fix-typo-in-gather_hugetbl_stats.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Subject: numa_maps: fix typo in gather_hugetbl_stats

Just doing s/gather_hugetbl_stats/gather_hugetlb_stats/g, this makes code
grep-friendly.

Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Pavel Emelyanov <xemul@parallels.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/task_mmu.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN fs/proc/task_mmu.c~numa_maps-fix-typo-in-gather_hugetbl_stats fs/proc/task_mmu.c
--- a/fs/proc/task_mmu.c~numa_maps-fix-typo-in-gather_hugetbl_stats
+++ a/fs/proc/task_mmu.c
@@ -1385,7 +1385,7 @@ static int gather_pte_stats(pmd_t *pmd,
 	return 0;
 }
 #ifdef CONFIG_HUGETLB_PAGE
-static int gather_hugetbl_stats(pte_t *pte, unsigned long hmask,
+static int gather_hugetlb_stats(pte_t *pte, unsigned long hmask,
 		unsigned long addr, unsigned long end, struct mm_walk *walk)
 {
 	struct numa_maps *md;
@@ -1404,7 +1404,7 @@ static int gather_hugetbl_stats(pte_t *p
 }
 
 #else
-static int gather_hugetbl_stats(pte_t *pte, unsigned long hmask,
+static int gather_hugetlb_stats(pte_t *pte, unsigned long hmask,
 		unsigned long addr, unsigned long end, struct mm_walk *walk)
 {
 	return 0;
@@ -1435,7 +1435,7 @@ static int show_numa_map(struct seq_file
 
 	md->vma = vma;
 
-	walk.hugetlb_entry = gather_hugetbl_stats;
+	walk.hugetlb_entry = gather_hugetlb_stats;
 	walk.pmd_entry = gather_pte_stats;
 	walk.private = md;
 	walk.mm = mm;
_

Patches currently in -mm which might be from n-horiguchi@ah.jp.nec.com are

origin.patch
mm-hwpoison-drop-lru_add_drain_all-in-__soft_offline_page.patch
do_shared_fault-check-that-mmap_sem-is-held.patch

