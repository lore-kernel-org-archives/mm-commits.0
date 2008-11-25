From: akpm@linux-foundation.org
Subject: + mm-gup-persist-for-write-permission.patch added to -mm tree
Date: Tue, 25 Nov 2008 14:15:40 -0800
Message-ID: <200811252215.mAPMFfYc005737@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42404 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751344AbYKYWQI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 25 Nov 2008 17:16:08 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hugh@veritas.com, holt@sgi.com, kamezawa.hiroyu@jp.fujitsu.com, lee.schermerhorn@hp.com, nickpiggin@yahoo.com.au, riel@redhat.com


The patch titled
     mm: gup persist for write permission
has been added to the -mm tree.  Its filename is
     mm-gup-persist-for-write-permission.patch

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
Subject: mm: gup persist for write permission
From: Hugh Dickins <hugh@veritas.com>

do_wp_page()'s VM_FAULT_WRITE return value tells __get_user_pages() that
COW has been done if necessary, though it may be leaving the pte without
write permission - for the odd case of forced writing to a readonly vma
for ptrace.  At present GUP then retries the follow_page() without asking
for write permission, to escape an endless loop when forced.

But an application may be relying on GUP to guarantee a writable page
which won't be COWed again when written from userspace, whereas a race
here might leave a readonly pte in place?  Change the VM_FAULT_WRITE
handling to ask follow_page() for write permission again, except in that
odd case of forced writing to a readonly vma.

Signed-off-by: Hugh Dickins <hugh@veritas.com>
Cc: Lee Schermerhorn <lee.schermerhorn@hp.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Robin Holt <holt@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff -puN mm/memory.c~mm-gup-persist-for-write-permission mm/memory.c
--- a/mm/memory.c~mm-gup-persist-for-write-permission
+++ a/mm/memory.c
@@ -1251,9 +1251,15 @@ int __get_user_pages(struct task_struct 
 				 * do_wp_page has broken COW when necessary,
 				 * even if maybe_mkwrite decided not to set
 				 * pte_write. We can thus safely do subsequent
-				 * page lookups as if they were reads.
+				 * page lookups as if they were reads. But only
+				 * do so when looping for pte_write is futile:
+				 * in some cases userspace may also be wanting
+				 * to write to the gotten user page, which a
+				 * read fault here might prevent (a readonly
+				 * page might get reCOWed by userspace write).
 				 */
-				if (ret & VM_FAULT_WRITE)
+				if ((ret & VM_FAULT_WRITE) &&
+				    !(vma->vm_flags & VM_WRITE))
 					foll_flags &= ~FOLL_WRITE;
 
 				cond_resched();
_

Patches currently in -mm which might be from hugh@veritas.com are

linux-next.patch
mm-dont-mark_page_accessed-in-shmem_fault.patch
mm-apply_to_range-call-pte-function-with-lazy-updates.patch
mm-remove-cgroup_mm_owner_callbacks.patch
mm-remove-aop_writepage_activate.patch
mm-remove-gfp_highuser_pagecache.patch
mm-add-setclearpageswapcache-stubs.patch
mm-replace-some-bug_ons-by-vm_bug_ons.patch
mm-add_active_or_unevictable-into-rmap.patch
mm-make-page_lock_anon_vma-static.patch
mm-further-cleanup-page_add_new_anon_rmap.patch
mm-gup-persist-for-write-permission.patch
mm-wp-lock-page-before-deciding-cow.patch
mm-reuse_swap_page-replaces-can_share_swap_page.patch
mm-try_to_free_swap-replaces-remove_exclusive_swap_page.patch
mm-try_to_unuse-check-removing-right-swap.patch
mm-remove-try_to_munlock-from-vmscan.patch
mm-remove-gfp_mask-from-add_to_swap.patch
mm-add-add_to_swap-stub.patch
mm-optimize-get_scan_ratio-for-no-swap.patch
memcg-handle-swap-caches.patch
memcg-handle-swap-caches-build-fix.patch
memcg-swap-cgroup-for-remembering-usage.patch
memcg-memswap-controller-core.patch
memcg-memswap-controller-core-make-resize-limit-hold-mutex.patch
memcg-memswap-controller-core-swapcache-fixes.patch
prio_tree-debugging-patch.patch

