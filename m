From: akpm@linux-foundation.org
Subject: [merged]
 mm-thp-use-down_read_trylock-in-khugepaged-to-avoid-long-block.patch
 removed from -mm tree
Date: Thu, 01 Feb 2018 11:32:42 -0800
Message-ID: <20180201193242.l7k47iPPB%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58776 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754563AbeBATcn (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 1 Feb 2018 14:32:43 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aarcange@redhat.com, arnd@arndb.de, hughd@google.com, kirill.shutemov@linux.intel.com, mhocko@suse.com, mm-commits@vger.kernel.org, yang.s@alibaba-inc.com


The patch titled
     Subject: mm: thp: use down_read_trylock() in khugepaged to avoid long block
has been removed from the -mm tree.  Its filename was
     mm-thp-use-down_read_trylock-in-khugepaged-to-avoid-long-block.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Yang Shi" <yang.s@alibaba-inc.com>
Subject: mm: thp: use down_read_trylock() in khugepaged to avoid long block

In the current design, khugepaged needs to acquire mmap_sem before
scanning an mm.  But in some corner cases, khugepaged may scan a process
which is modifying its memory mapping, so khugepaged blocks in
uninterruptible state.  But the process might hold the mmap_sem for a long
time when modifying a huge memory space and it may trigger the below
khugepaged hung issue:

INFO: task khugepaged:270 blocked for more than 120 seconds.
Tainted: G E 4.9.65-006.ali3000.alios7.x86_64 #1
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
khugepaged D 0 270 2 0x00000000 
ffff883f3deae4c0 0000000000000000 ffff883f610596c0 ffff883f7d359440
ffff883f63818000 ffffc90019adfc78 ffffffff817079a5 d67e5aa8c1860a64
0000000000000246 ffff883f7d359440 ffffc90019adfc88 ffff883f610596c0
Call Trace:
[<ffffffff817079a5>] ? __schedule+0x235/0x6e0
[<ffffffff81707e86>] schedule+0x36/0x80
[<ffffffff8170a970>] rwsem_down_read_failed+0xf0/0x150
[<ffffffff81384998>] call_rwsem_down_read_failed+0x18/0x30
[<ffffffff8170a1c0>] down_read+0x20/0x40
[<ffffffff81226836>] khugepaged+0x476/0x11d0
[<ffffffff810c9d0e>] ? idle_balance+0x1ce/0x300
[<ffffffff810d0850>] ? prepare_to_wait_event+0x100/0x100
[<ffffffff812263c0>] ? collapse_shmem+0xbf0/0xbf0
[<ffffffff810a8d46>] kthread+0xe6/0x100
[<ffffffff810a8c60>] ? kthread_park+0x60/0x60
[<ffffffff8170cd15>] ret_from_fork+0x25/0x30

So it sounds pointless to just block khugepaged waiting for the semaphore
so replace down_read() with down_read_trylock() to move to scan the next
mm quickly instead of just blocking on the semaphore so that other
processes can get more chances to install THP.  Then khugepaged can come
back to scan the skipped mm when it has finished the current round
full_scan.

And it appears that the change can improve khugepaged efficiency a little
bit.

Below is the test result when running LTP on a 24 cores 4GB memory 2 nodes
NUMA VM:

				pristine	 w/ trylock
full_scan                         197               187
pages_collapsed                   21                26
thp_fault_alloc                   40818             44466
thp_fault_fallback                18413             16679
thp_collapse_alloc                21                150
thp_collapse_alloc_failed         14                16
thp_file_alloc                    369               369

[akpm@linux-foundation.org: coding-style fixes]
[akpm@linux-foundation.org: tweak comment]
[arnd@arndb.de: avoid uninitialized variable use]
  Link: http://lkml.kernel.org/r/20171215125129.2948634-1-arnd@arndb.de
Link: http://lkml.kernel.org/r/1513281203-54878-1-git-send-email-yang.s@alibaba-inc.com
Signed-off-by: Yang Shi <yang.s@alibaba-inc.com>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/khugepaged.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff -puN mm/khugepaged.c~mm-thp-use-down_read_trylock-in-khugepaged-to-avoid-long-block mm/khugepaged.c
--- a/mm/khugepaged.c~mm-thp-use-down_read_trylock-in-khugepaged-to-avoid-long-block
+++ a/mm/khugepaged.c
@@ -1673,10 +1673,14 @@ static unsigned int khugepaged_scan_mm_s
 	spin_unlock(&khugepaged_mm_lock);
 
 	mm = mm_slot->mm;
-	down_read(&mm->mmap_sem);
-	if (unlikely(khugepaged_test_exit(mm)))
-		vma = NULL;
-	else
+	/*
+	 * Don't wait for semaphore (to avoid long wait times).  Just move to
+	 * the next mm on the list.
+	 */
+	vma = NULL;
+	if (unlikely(!down_read_trylock(&mm->mmap_sem)))
+		goto breakouterloop_mmap_sem;
+	if (likely(!khugepaged_test_exit(mm)))
 		vma = find_vma(mm, khugepaged_scan.address);
 
 	progress++;
_

Patches currently in -mm which might be from yang.s@alibaba-inc.com are


