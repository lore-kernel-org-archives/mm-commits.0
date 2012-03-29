From: akpm@linux-foundation.org
Subject: [merged] mm-thp-fixup-pmd_trans_unstable-locations.patch removed from -mm tree
Date: Thu, 29 Mar 2012 12:13:22 -0700
Message-ID: <20120329191322.85121A01E3@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ey0-f202.google.com ([209.85.215.202]:44703 "EHLO
	mail-ey0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933720Ab2C2TNY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 29 Mar 2012 15:13:24 -0400
Received: by eaaq10 with SMTP id q10so149313eaa.1
        for <mm-commits@vger.kernel.org>; Thu, 29 Mar 2012 12:13:23 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aarcange@redhat.com, hughd@google.com, lwoodman@redhat.com, mgorman@suse.de, msalter@redhat.com, riel@redhat.com, uobergfe@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: thp: fix up pmd_trans_unstable() locations
has been removed from the -mm tree.  Its filename was
     mm-thp-fixup-pmd_trans_unstable-locations.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Andrea Arcangeli <aarcange@redhat.com>
Subject: mm: thp: fix up pmd_trans_unstable() locations

pmd_trans_unstable() should be called before pmd_offset_map() in the
locations where the mmap_sem is held for reading.

Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Hugh Dickins <hughd@google.com>
Cc: Larry Woodman <lwoodman@redhat.com>
Cc: Ulrich Obergfell <uobergfe@redhat.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Mark Salter <msalter@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/task_mmu.c |    5 ++---
 mm/memcontrol.c    |    4 ++++
 2 files changed, 6 insertions(+), 3 deletions(-)

diff -puN fs/proc/task_mmu.c~mm-thp-fixup-pmd_trans_unstable-locations fs/proc/task_mmu.c
--- a/fs/proc/task_mmu.c~mm-thp-fixup-pmd_trans_unstable-locations
+++ a/fs/proc/task_mmu.c
@@ -781,9 +781,6 @@ static int pagemap_pte_range(pmd_t *pmd,
 	int err = 0;
 	pagemap_entry_t pme = make_pme(PM_NOT_PRESENT);
 
-	if (pmd_trans_unstable(pmd))
-		return 0;
-
 	/* find the first VMA at or above 'addr' */
 	vma = find_vma(walk->mm, addr);
 	spin_lock(&walk->mm->page_table_lock);
@@ -802,6 +799,8 @@ static int pagemap_pte_range(pmd_t *pmd,
 		return err;
 	}
 
+	if (pmd_trans_unstable(pmd))
+		return 0;
 	for (; addr != end; addr += PAGE_SIZE) {
 
 		/* check to see if we've left 'vma' behind
diff -puN mm/memcontrol.c~mm-thp-fixup-pmd_trans_unstable-locations mm/memcontrol.c
--- a/mm/memcontrol.c~mm-thp-fixup-pmd_trans_unstable-locations
+++ a/mm/memcontrol.c
@@ -5306,6 +5306,8 @@ static int mem_cgroup_count_precharge_pt
 		return 0;
 	}
 
+	if (pmd_trans_unstable(pmd))
+		return 0;
 	pte = pte_offset_map_lock(vma->vm_mm, pmd, addr, &ptl);
 	for (; addr != end; pte++, addr += PAGE_SIZE)
 		if (get_mctgt_type(vma, addr, *pte, NULL))
@@ -5502,6 +5504,8 @@ static int mem_cgroup_move_charge_pte_ra
 		return 0;
 	}
 
+	if (pmd_trans_unstable(pmd))
+		return 0;
 retry:
 	pte = pte_offset_map_lock(vma->vm_mm, pmd, addr, &ptl);
 	for (; addr != end; addr += PAGE_SIZE) {
_

Patches currently in -mm which might be from aarcange@redhat.com are

origin.patch

