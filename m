From: akpm@linux-foundation.org
Subject: + mm-make-page_lock_anon_vma-static.patch added to -mm tree
Date: Fri, 21 Nov 2008 12:12:02 -0800
Message-ID: <200811212012.mALKC2kc017746@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36628 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752955AbYKUUML (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 21 Nov 2008 15:12:11 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hugh@veritas.com, kosaki.motohiro@jp.fujitsu.com


The patch titled
     mm: make page_lock_anon_vma() static
has been added to the -mm tree.  Its filename is
     mm-make-page_lock_anon_vma-static.patch

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
Subject: mm: make page_lock_anon_vma() static
From: Hugh Dickins <hugh@veritas.com>

page_lock_anon_vma() and page_unlock_anon_vma() were made available to
show_page_path() in vmscan.c; but now that has been removed, make them
static in rmap.c again, they're better kept private if possible.

Signed-off-by: Hugh Dickins <hugh@veritas.com>
Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/rmap.h |    3 ---
 mm/rmap.c            |    4 ++--
 2 files changed, 2 insertions(+), 5 deletions(-)

diff -puN include/linux/rmap.h~mm-make-page_lock_anon_vma-static include/linux/rmap.h
--- a/include/linux/rmap.h~mm-make-page_lock_anon_vma-static
+++ a/include/linux/rmap.h
@@ -63,9 +63,6 @@ void anon_vma_unlink(struct vm_area_stru
 void anon_vma_link(struct vm_area_struct *);
 void __anon_vma_link(struct vm_area_struct *);
 
-extern struct anon_vma *page_lock_anon_vma(struct page *page);
-extern void page_unlock_anon_vma(struct anon_vma *anon_vma);
-
 /*
  * rmap interfaces called when adding or removing pte of page
  */
diff -puN mm/rmap.c~mm-make-page_lock_anon_vma-static mm/rmap.c
--- a/mm/rmap.c~mm-make-page_lock_anon_vma-static
+++ a/mm/rmap.c
@@ -193,7 +193,7 @@ void __init anon_vma_init(void)
  * Getting a lock on a stable anon_vma from a page off the LRU is
  * tricky: page_lock_anon_vma rely on RCU to guard against the races.
  */
-struct anon_vma *page_lock_anon_vma(struct page *page)
+static struct anon_vma *page_lock_anon_vma(struct page *page)
 {
 	struct anon_vma *anon_vma;
 	unsigned long anon_mapping;
@@ -213,7 +213,7 @@ out:
 	return NULL;
 }
 
-void page_unlock_anon_vma(struct anon_vma *anon_vma)
+static void page_unlock_anon_vma(struct anon_vma *anon_vma)
 {
 	spin_unlock(&anon_vma->lock);
 	rcu_read_unlock();
_

Patches currently in -mm which might be from hugh@veritas.com are

origin.patch
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
memcg-handle-swap-caches.patch
memcg-handle-swap-caches-build-fix.patch
memcg-swap-cgroup-for-remembering-usage-fix-2.patch
memcg-swap-cgroup-for-remembering-usage-fix-3.patch
memcg-swap-cgroup-for-remembering-usage-fix-4.patch
memcg-memswap-controller-core.patch
memcg-memswap-controller-core-make-resize-limit-hold-mutex.patch
prio_tree-debugging-patch.patch

