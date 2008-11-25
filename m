From: akpm@linux-foundation.org
Subject: + mm-wp-lock-page-before-deciding-cow.patch added to -mm tree
Date: Tue, 25 Nov 2008 14:15:42 -0800
Message-ID: <200811252215.mAPMFhAf005740@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58038 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751334AbYKYWPz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 25 Nov 2008 17:15:55 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hugh@veritas.com, holt@sgi.com, kamezawa.hiroyu@jp.fujitsu.com, lee.schermerhorn@hp.com, nickpiggin@yahoo.com.au, riel@redhat.com


The patch titled
     mm: wp lock page before deciding cow
has been added to the -mm tree.  Its filename is
     mm-wp-lock-page-before-deciding-cow.patch

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
Subject: mm: wp lock page before deciding cow
From: Hugh Dickins <hugh@veritas.com>

An application may rely on get_user_pages() to give it pages writable from
userspace and shared with a driver, GUP breaking COW if necessary.  It may
mprotect() the pages' writability, off and on, from time to time.

Normally this works fine (so long as the app does not fork); but just
occasionally, under memory pressure, a readonly pte in a newly writable
area is COWed unnecessarily, breaking the link with the driver: because
do_wp_page() does trylock_page, and falls back to COW whenever that fails.

For reliable behaviour in the unshared case, when the trylock_page fails,
now unlock pagetable, lock page and relock pagetable, before deciding
whether Copy-On-Write is really necessary.

Reported-by: Zhou Yingchao
Signed-off-by: Hugh Dickins <hugh@veritas.com>
Cc: Lee Schermerhorn <lee.schermerhorn@hp.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Robin Holt <holt@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |   17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

diff -puN mm/memory.c~mm-wp-lock-page-before-deciding-cow mm/memory.c
--- a/mm/memory.c~mm-wp-lock-page-before-deciding-cow
+++ a/mm/memory.c
@@ -1819,10 +1819,21 @@ static int do_wp_page(struct mm_struct *
 	 * not dirty accountable.
 	 */
 	if (PageAnon(old_page)) {
-		if (trylock_page(old_page)) {
-			reuse = can_share_swap_page(old_page);
-			unlock_page(old_page);
+		if (!trylock_page(old_page)) {
+			page_cache_get(old_page);
+			pte_unmap_unlock(page_table, ptl);
+			lock_page(old_page);
+			page_table = pte_offset_map_lock(mm, pmd, address,
+							 &ptl);
+			if (!pte_same(*page_table, orig_pte)) {
+				unlock_page(old_page);
+				page_cache_release(old_page);
+				goto unlock;
+			}
+			page_cache_release(old_page);
 		}
+		reuse = can_share_swap_page(old_page);
+		unlock_page(old_page);
 	} else if (unlikely((vma->vm_flags & (VM_WRITE|VM_SHARED)) ==
 					(VM_WRITE|VM_SHARED))) {
 		/*
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

