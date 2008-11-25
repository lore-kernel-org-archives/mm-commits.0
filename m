From: akpm@linux-foundation.org
Subject: + mm-add-add_to_swap-stub.patch added to -mm tree
Date: Tue, 25 Nov 2008 14:15:57 -0800
Message-ID: <200811252215.mAPMFw5J005926@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53618 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751379AbYKYWVW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 25 Nov 2008 17:21:22 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hugh@veritas.com, holt@sgi.com, kamezawa.hiroyu@jp.fujitsu.com, lee.schermerhorn@hp.com, nickpiggin@yahoo.com.au, riel@redhat.com


The patch titled
     mm: add add_to_swap stub
has been added to the -mm tree.  Its filename is
     mm-add-add_to_swap-stub.patch

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
Subject: mm: add add_to_swap stub
From: Hugh Dickins <hugh@veritas.com>

If we add a failing stub for add_to_swap(), then we can remove the #ifdef
CONFIG_SWAP from mm/vmscan.c.

This was intended as a source cleanup, but looking more closely, it turns
out that the !CONFIG_SWAP case was going to keep_locked for an anonymous
page, whereas now it goes to the more suitable activate_locked, like the
CONFIG_SWAP nr_swap_pages 0 case.

Signed-off-by: Hugh Dickins <hugh@veritas.com>
Cc: Lee Schermerhorn <lee.schermerhorn@hp.com>
Acked-by: Rik van Riel <riel@redhat.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Robin Holt <holt@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/swap.h |    5 +++++
 mm/vmscan.c          |    2 --
 2 files changed, 5 insertions(+), 2 deletions(-)

diff -puN include/linux/swap.h~mm-add-add_to_swap-stub include/linux/swap.h
--- a/include/linux/swap.h~mm-add-add_to_swap-stub
+++ a/include/linux/swap.h
@@ -374,6 +374,11 @@ static inline struct page *lookup_swap_c
 	return NULL;
 }
 
+static inline int add_to_swap(struct page *page)
+{
+	return 0;
+}
+
 static inline int add_to_swap_cache(struct page *page, swp_entry_t entry,
 							gfp_t gfp_mask)
 {
diff -puN mm/vmscan.c~mm-add-add_to_swap-stub mm/vmscan.c
--- a/mm/vmscan.c~mm-add-add_to_swap-stub
+++ a/mm/vmscan.c
@@ -665,7 +665,6 @@ static unsigned long shrink_page_list(st
 					referenced && page_mapping_inuse(page))
 			goto activate_locked;
 
-#ifdef CONFIG_SWAP
 		/*
 		 * Anonymous process memory has backing store?
 		 * Try to allocate it some swap space here.
@@ -677,7 +676,6 @@ static unsigned long shrink_page_list(st
 				goto activate_locked;
 			may_enter_fs = 1;
 		}
-#endif /* CONFIG_SWAP */
 
 		mapping = page_mapping(page);
 
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

