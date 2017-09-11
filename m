From: akpm@linux-foundation.org
Subject: [merged]
 fs-proc-unconditional-cond_resched-when-reading-smaps.patch removed from
 -mm tree
Date: Mon, 11 Sep 2017 12:40:43 -0700
Message-ID: <20170911194043.2NlSyGm4E%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49452 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751119AbdIKTko (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 11 Sep 2017 15:40:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hughd@google.com, kirill.shutemov@linux.intel.com, minchan@kernel.org, mm-commits@vger.kernel.org, rientjes@google.com


The patch titled
     Subject: fs, proc: unconditional cond_resched when reading smaps
has been removed from the -mm tree.  Its filename was
     fs-proc-unconditional-cond_resched-when-reading-smaps.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: David Rientjes <rientjes@google.com>
Subject: fs, proc: unconditional cond_resched when reading smaps

If there are large numbers of hugepages to iterate while reading
/proc/pid/smaps, the page walk never does cond_resched().  On archs
without split pmd locks, there can be significant and observable
contention on mm->page_table_lock which cause lengthy delays without
rescheduling.

Always reschedule in smaps_pte_range() if necessary since the pagewalk
iteration can be expensive.

Link: http://lkml.kernel.org/r/alpine.DEB.2.10.1708211405520.131071@chino.kir.corp.google.com
Signed-off-by: David Rientjes <rientjes@google.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/task_mmu.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN fs/proc/task_mmu.c~fs-proc-unconditional-cond_resched-when-reading-smaps fs/proc/task_mmu.c
--- a/fs/proc/task_mmu.c~fs-proc-unconditional-cond_resched-when-reading-smaps
+++ a/fs/proc/task_mmu.c
@@ -611,11 +611,11 @@ static int smaps_pte_range(pmd_t *pmd, u
 		if (pmd_present(*pmd))
 			smaps_pmd_entry(pmd, addr, walk);
 		spin_unlock(ptl);
-		return 0;
+		goto out;
 	}
 
 	if (pmd_trans_unstable(pmd))
-		return 0;
+		goto out;
 	/*
 	 * The mmap_sem held all the way back in m_start() is what
 	 * keeps khugepaged out of here and from collapsing things
@@ -625,6 +625,7 @@ static int smaps_pte_range(pmd_t *pmd, u
 	for (; addr != end; pte++, addr += PAGE_SIZE)
 		smaps_pte_entry(pte, addr, walk);
 	pte_unmap_unlock(pte - 1, ptl);
+out:
 	cond_resched();
 	return 0;
 }
_

Patches currently in -mm which might be from rientjes@google.com are

mm-compaction-kcompactd-should-not-ignore-pageblock-skip.patch
mm-compaction-persistently-skip-hugetlbfs-pageblocks.patch
mm-compaction-persistently-skip-hugetlbfs-pageblocks-fix.patch

