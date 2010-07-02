From: akpm@linux-foundation.org
Subject: + mm-set-vm_fault_write-in-do_swap_page.patch added to -mm tree
Date: Fri, 02 Jul 2010 15:08:10 -0700
Message-ID: <201007022208.o62M8A0r029574@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47652 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752766Ab0GBWIy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 2 Jul 2010 18:08:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: aarcange@redhat.com, hughd@google.com, kosaki.motohiro@jp.fujitsu.com, nickpiggin@yahoo.com.au, riel@redhat.com


The patch titled
     mm: set VM_FAULT_WRITE in do_swap_page()
has been added to the -mm tree.  Its filename is
     mm-set-vm_fault_write-in-do_swap_page.patch

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
Subject: mm: set VM_FAULT_WRITE in do_swap_page()
From: Andrea Arcangeli <aarcange@redhat.com>

Set the flag if do_swap_page is decowing the page the same way do_wp_page
would too.

Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN mm/memory.c~mm-set-vm_fault_write-in-do_swap_page mm/memory.c
--- a/mm/memory.c~mm-set-vm_fault_write-in-do_swap_page
+++ a/mm/memory.c
@@ -2713,6 +2713,7 @@ static int do_swap_page(struct mm_struct
 	if ((flags & FAULT_FLAG_WRITE) && reuse_swap_page(page)) {
 		pte = maybe_mkwrite(pte_mkdirty(pte), vma);
 		flags &= ~FAULT_FLAG_WRITE;
+		ret |= VM_FAULT_WRITE;
 		exclusive = 1;
 	}
 	flush_icache_page(vma, page);
_

Patches currently in -mm which might be from aarcange@redhat.com are

linux-next.patch
hugetlb-call-mmu-notifiers-on-hugepage-cow.patch
define-madv_hugepage.patch
mmap-remove-unnecessary-lock-from-__vma_link.patch
rmap-always-add-new-vmas-at-the-end.patch
ksm-fix-ksm-swapin-time-optimization.patch
rmap-always-use-anon_vma-root-pointer.patch
rmap-resurrect-page_address_in_vma-anon_vma-check.patch
add-anon_vma-bug-checks.patch
vmscan-tracing-add-trace-events-for-kswapd-wakeup-sleeping-and-direct-reclaim.patch
vmscan-tracing-add-trace-events-for-lru-page-isolation.patch
vmscan-tracing-add-trace-event-when-a-page-is-written.patch
vmscan-tracing-add-a-postprocessing-script-for-reclaim-related-ftrace-events.patch
vmscan-kill-prev_priority-completely.patch
vmscan-simplify-shrink_inactive_list.patch
vmscan-remove-unnecessary-temporary-vars-in-do_try_to_free_pages.patch
vmscan-set-up-pagevec-as-late-as-possible-in-shrink_inactive_list.patch
vmscan-set-up-pagevec-as-late-as-possible-in-shrink_page_list.patch
vmscan-update-isolated-page-counters-outside-of-main-path-in-shrink_inactive_list.patch
rmap-add-exclusive-page-to-private-anon_vma-on-swapin.patch
mm-set-vm_fault_write-in-do_swap_page.patch

