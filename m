From: akpm@linux-foundation.org
Subject: [merged] pagemap-set-pagemap-walk-limit-to-pmd-boundary.patch removed from -mm tree
Date: Mon, 29 Nov 2010 11:51:24 -0800
Message-ID: <201011291951.oATJprUX007332@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33818 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753043Ab0K2Tw3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 29 Nov 2010 14:52:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: n-horiguchi@ah.jp.nec.com, j-nomura@ce.jp.nec.com, kamezawa.hiroyu@jp.fujitsu.com, mpm@selenic.com, mm-commits@vger.kernel.org


The patch titled
     pagemap: set pagemap walk limit to PMD boundary
has been removed from the -mm tree.  Its filename was
     pagemap-set-pagemap-walk-limit-to-pmd-boundary.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: pagemap: set pagemap walk limit to PMD boundary
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>

Currently one pagemap_read() call walks in PAGEMAP_WALK_SIZE bytes (== 512
pages.) But there is a corner case where walk_pmd_range() accidentally
runs over a VMA associated with a hugetlbfs file.

For example, when a process has mappings to VMAs as shown below:

  # cat /proc/<pid>/maps
  ...
  3a58f6d000-3a58f72000 rw-p 00000000 00:00 0
  7fbd51853000-7fbd51855000 rw-p 00000000 00:00 0
  7fbd5186c000-7fbd5186e000 rw-p 00000000 00:00 0
  7fbd51a00000-7fbd51c00000 rw-s 00000000 00:12 8614   /hugepages/test

then pagemap_read() goes into walk_pmd_range() path and walks in the range
0x7fbd51853000-0x7fbd51a53000, but the hugetlbfs VMA should be handled by
walk_hugetlb_range().  Otherwise PMD for the hugepage is considered bad
and cleared, which causes undesirable results.

This patch fixes it by separating pagemap walk range into one PMD.

Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Matt Mackall <mpm@selenic.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/task_mmu.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN fs/proc/task_mmu.c~pagemap-set-pagemap-walk-limit-to-pmd-boundary fs/proc/task_mmu.c
--- a/fs/proc/task_mmu.c~pagemap-set-pagemap-walk-limit-to-pmd-boundary
+++ a/fs/proc/task_mmu.c
@@ -706,6 +706,7 @@ static int pagemap_hugetlb_range(pte_t *
  * skip over unmapped regions.
  */
 #define PAGEMAP_WALK_SIZE	(PMD_SIZE)
+#define PAGEMAP_WALK_MASK	(PMD_MASK)
 static ssize_t pagemap_read(struct file *file, char __user *buf,
 			    size_t count, loff_t *ppos)
 {
@@ -776,7 +777,7 @@ static ssize_t pagemap_read(struct file 
 		unsigned long end;
 
 		pm.pos = 0;
-		end = start_vaddr + PAGEMAP_WALK_SIZE;
+		end = (start_vaddr + PAGEMAP_WALK_SIZE) & PAGEMAP_WALK_MASK;
 		/* overflow ? */
 		if (end < start_vaddr || end > end_vaddr)
 			end = end_vaddr;
_

Patches currently in -mm which might be from n-horiguchi@ah.jp.nec.com are

origin.patch

