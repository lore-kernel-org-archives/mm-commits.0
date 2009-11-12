From: akpm@linux-foundation.org
Subject: + mm-sigbus-instead-of-abusing-oom.patch added to -mm tree
Date: Thu, 12 Nov 2009 12:55:28 -0800
Message-ID: <200911122055.nACKtSGb019307@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59039 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754513AbZKLU4E (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 12 Nov 2009 15:56:04 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hugh.dickins@tiscali.co.uk, Lee.Schermerhorn@hp.com, aarcange@redhat.com, andi@firstfloor.org, fengguang.wu@intel.com, ieidus@redhat.com, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, minchan.kim@gmail.com, npiggin@suse.de, riel@redhat.com


The patch titled
     mm: sigbus instead of abusing oom
has been added to the -mm tree.  Its filename is
     mm-sigbus-instead-of-abusing-oom.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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
mmap-dont-return-enomem-when-mapcount-is-temporarily-exceeded-in-munmap.patch
mmap-dont-return-enomem-when-mapcount-is-temporarily-exceeded-in-munmap-checkpatch-fixes.patch
vmalloc-adjust-gfp-mask-passed-on-nested-vmalloc-invocation.patch
swap_info-private-to-swapfilec.patch
swap_info-change-to-array-of-pointers.patch
swap_info-include-first_swap_extent.patch
swap_info-include-first_swap_extent-fix.patch
swap_info-include-first_swap_extent-fix-fix.patch
swap_info-miscellaneous-minor-cleanups.patch
swap_info-swap_has_cache-cleanups.patch
swap_info-swap_map-of-chars-not-shorts.patch
swap_info-swap-count-continuations.patch
swap_info-note-swap_map_shmem.patch
swap_info-reorder-its-fields.patch
rmap-fix-the-comment-for-try_to_unmap_anon.patch
oom_kill-use-rss-value-instead-of-vm-size-for-badness.patch
mm-define-page_mapping_flags.patch
mm-mlocking-in-try_to_unmap_one.patch
mm-config_mmu-for-pg_mlocked.patch
mm-pass-address-down-to-rmap-ones.patch
mm-stop-ptlock-enlarging-struct-page.patch
mm-sigbus-instead-of-abusing-oom.patch
elf-kill-use_elf_core_dump.patch
prio_tree-debugging-patch.patch

