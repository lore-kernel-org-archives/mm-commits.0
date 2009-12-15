From: akpm@linux-foundation.org
Subject: [merged] mm-sigbus-instead-of-abusing-oom.patch removed from -mm tree
Date: Tue, 15 Dec 2009 13:52:37 -0800
Message-ID: <200912152152.nBFLqbvK015204@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37615 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761231AbZLOVxc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 15 Dec 2009 16:53:32 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hugh.dickins@tiscali.co.uk, Lee.Schermerhorn@hp.com, aarcange@redhat.com, andi@firstfloor.org, fengguang.wu@intel.com, ieidus@redhat.com, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohi


The patch titled
     mm: sigbus instead of abusing oom
has been removed from the -mm tree.  Its filename was
     mm-sigbus-instead-of-abusing-oom.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: sigbus instead of abusing oom
From: Hugh Dickins <hugh.dickins@tiscali.co.uk>

When do_nonlinear_fault() realizes that the page table must have been
corrupted for it to have been called, it does print_bad_pte() and returns
...  VM_FAULT_OOM, which is hard to understand.

It made some sense when I did it for 2.6.15, when do_page_fault() just
killed the current process; but nowadays it lets the OOM killer decide who
to kill - so page table corruption in one process would be liable to kill
another.

Change it to return VM_FAULT_SIGBUS instead: that doesn't guarantee that
the process will be killed, but is good enough for such a rare
abnormality, accompanied as it is by the "BUG: Bad page map" message.

And recent HWPOISON work has copied that code into do_swap_page(), when it
finds an impossible swap entry: fix that to VM_FAULT_SIGBUS too.

Signed-off-by: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Cc: Izik Eidus <ieidus@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Nick Piggin <npiggin@suse.de>
Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
Cc: Andi Kleen <andi@firstfloor.org>
Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Reviewed-by: Wu Fengguang <fengguang.wu@intel.com>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN mm/memory.c~mm-sigbus-instead-of-abusing-oom mm/memory.c
--- a/mm/memory.c~mm-sigbus-instead-of-abusing-oom
+++ a/mm/memory.c
@@ -2527,7 +2527,7 @@ static int do_swap_page(struct mm_struct
 			ret = VM_FAULT_HWPOISON;
 		} else {
 			print_bad_pte(vma, address, orig_pte, NULL);
-			ret = VM_FAULT_OOM;
+			ret = VM_FAULT_SIGBUS;
 		}
 		goto out;
 	}
@@ -2923,7 +2923,7 @@ static int do_nonlinear_fault(struct mm_
 		 * Page table corrupted: show pte and kill process.
 		 */
 		print_bad_pte(vma, address, orig_pte, NULL);
-		return VM_FAULT_OOM;
+		return VM_FAULT_SIGBUS;
 	}
 
 	pgoff = pte_to_pgoff(orig_pte);
_

Patches currently in -mm which might be from hugh.dickins@tiscali.co.uk are

origin.patch
linux-next.patch
vfs-fsstack-handle-32-bit-smp-preempt-large-files-in-fsstack_copy_inode_size.patch
ksm-memory-hotremove-migration-only-fix.patch
elf-kill-use_elf_core_dump.patch
prio_tree-debugging-patch.patch

