From: akpm@linux-foundation.org
Subject: +
 mm-thp-use-down_read_trylock-in-khugepaged-to-avoid-long-block.patch added
 to -mm tree
Date: Thu, 14 Dec 2017 12:13:57 -0800
Message-ID: <5a32db85.1UB5h2EO6vCe+bJe%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43804 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752045AbdLNUN7 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 14 Dec 2017 15:13:59 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: yang.s@alibaba-inc.com, aarcange@redhat.com, hughd@google.com, kirill.shutemov@linux.intel.com, mhocko@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: thp: use down_read_trylock() in khugepaged to avoid long block
has been added to the -mm tree.  Its filename is
     mm-thp-use-down_read_trylock-in-khugepaged-to-avoid-long-block.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-thp-use-down_read_trylock-in-khugepaged-to-avoid-long-block.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-thp-use-down_read_trylock-in-khugepaged-to-avoid-long-block.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

Link: http://lkml.kernel.org/r/1513281203-54878-1-git-send-email-yang.s@alibaba-inc.com
Signed-off-by: Yang Shi <yang.s@alibaba-inc.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/khugepaged.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff -puN mm/khugepaged.c~mm-thp-use-down_read_trylock-in-khugepaged-to-avoid-long-block mm/khugepaged.c
--- a/mm/khugepaged.c~mm-thp-use-down_read_trylock-in-khugepaged-to-avoid-long-block
+++ a/mm/khugepaged.c
@@ -1673,7 +1673,12 @@ static unsigned int khugepaged_scan_mm_s
 	spin_unlock(&khugepaged_mm_lock);
 
 	mm = mm_slot->mm;
-	down_read(&mm->mmap_sem);
+	/*
+ 	 * Not wait for semaphore to avoid long time waiting, just move
+ 	 * to the next mm on the list.
+ 	 */
+	if (unlikely(!down_read_trylock(&mm->mmap_sem)))
+		goto breakouterloop_mmap_sem;
 	if (unlikely(khugepaged_test_exit(mm)))
 		vma = NULL;
 	else
_

Patches currently in -mm which might be from yang.s@alibaba-inc.com are

mm-kmemleak-remove-unused-hardirqh.patch
mm-filemap-remove-include-of-hardirqh.patch
mm-thp-use-down_read_trylock-in-khugepaged-to-avoid-long-block.patch

