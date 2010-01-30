From: akpm@linux-foundation.org
Subject: + mm-change-anon_vma-linking-to-fix-multi-process-server-scalability-issue-further-cleanups.patch added to -mm tree
Date: Fri, 29 Jan 2010 16:32:41 -0800
Message-ID: <201001300032.o0U0WfvM019034@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60023 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751178Ab0A3AdL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 29 Jan 2010 19:33:11 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: riel@redhat.com, Lee.Schermerhorn@hp.com, aarcange@redhat.com, hugh.dickins@tiscali.co.uk, kosaki.motohiro@jp.fujitsu.com, lwoodman@redhat.com, minchan.kim@gmail.com


The patch titled
     mm-change-anon_vma-linking-to-fix-multi-process-server-scalability-issue-further-cleanups
has been added to the -mm tree.  Its filename is
     mm-change-anon_vma-linking-to-fix-multi-process-server-scalability-issue-further-cleanups.patch

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
Subject: mm-change-anon_vma-linking-to-fix-multi-process-server-scalability-issue-further-cleanups
From: Rik van Riel <riel@redhat.com>

Fix the locking comments, the missed free in the fork error path and clean
up the anon_vma_chain slab creation as suggested by Andrew Morton.

Signed-off-by: Rik van Riel <riel@redhat.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Larry Woodman <lwoodman@redhat.com>
Cc: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
Cc: Minchan Kim <minchan.kim@gmail.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm_types.h |    3 ++-
 include/linux/rmap.h     |    2 +-
 kernel/fork.c            |    1 +
 mm/rmap.c                |    4 +---
 4 files changed, 5 insertions(+), 5 deletions(-)

diff -puN include/linux/mm_types.h~mm-change-anon_vma-linking-to-fix-multi-process-server-scalability-issue-further-cleanups include/linux/mm_types.h
--- a/include/linux/mm_types.h~mm-change-anon_vma-linking-to-fix-multi-process-server-scalability-issue-further-cleanups
+++ a/include/linux/mm_types.h
@@ -163,7 +163,8 @@ struct vm_area_struct {
 	 * can only be in the i_mmap tree.  An anonymous MAP_PRIVATE, stack
 	 * or brk vma (with NULL file) can only be in an anon_vma list.
 	 */
-	struct list_head anon_vma_chain; /* Serialized by mmap_sem & friends */
+	struct list_head anon_vma_chain; /* Serialized by mmap_sem &
+					  * page_table_lock */
 	struct anon_vma *anon_vma;	/* Serialized by page_table_lock */
 
 	/* Function pointers to deal with this struct. */
diff -puN include/linux/rmap.h~mm-change-anon_vma-linking-to-fix-multi-process-server-scalability-issue-further-cleanups include/linux/rmap.h
--- a/include/linux/rmap.h~mm-change-anon_vma-linking-to-fix-multi-process-server-scalability-issue-further-cleanups
+++ a/include/linux/rmap.h
@@ -56,7 +56,7 @@ struct anon_vma {
 struct anon_vma_chain {
 	struct vm_area_struct *vma;
 	struct anon_vma *anon_vma;
-	struct list_head same_vma;	/* locked by mmap_sem & friends */
+	struct list_head same_vma;   /* locked by mmap_sem & page_table_lock */
 	struct list_head same_anon_vma;	/* locked by anon_vma->lock */
 };
 
diff -puN kernel/fork.c~mm-change-anon_vma-linking-to-fix-multi-process-server-scalability-issue-further-cleanups kernel/fork.c
--- a/kernel/fork.c~mm-change-anon_vma-linking-to-fix-multi-process-server-scalability-issue-further-cleanups
+++ a/kernel/fork.c
@@ -394,6 +394,7 @@ out:
 	up_write(&oldmm->mmap_sem);
 	return retval;
 fail_nomem_anon_vma_fork:
+	mpol_put(pol);
 fail_nomem_policy:
 	kmem_cache_free(vm_area_cachep, tmp);
 fail_nomem:
diff -puN mm/rmap.c~mm-change-anon_vma-linking-to-fix-multi-process-server-scalability-issue-further-cleanups mm/rmap.c
--- a/mm/rmap.c~mm-change-anon_vma-linking-to-fix-multi-process-server-scalability-issue-further-cleanups
+++ a/mm/rmap.c
@@ -280,9 +280,7 @@ void __init anon_vma_init(void)
 {
 	anon_vma_cachep = kmem_cache_create("anon_vma", sizeof(struct anon_vma),
 			0, SLAB_DESTROY_BY_RCU|SLAB_PANIC, anon_vma_ctor);
-	anon_vma_chain_cachep = kmem_cache_create("anon_vma_chain",
-			sizeof(struct anon_vma_chain), 0,
-			SLAB_PANIC, NULL);
+	anon_vma_chain_cachep = KMEM_CACHE(anon_vma_chain, SLAB_PANIC);
 }
 
 /*
_

Patches currently in -mm which might be from riel@redhat.com are

mm-introduce-dump_page-and-print-symbolic-flag-names.patch
page-allocator-reduce-fragmentation-in-buddy-allocator-by-adding-buddies-that-are-merging-to-the-tail-of-the-free-lists.patch
mlock_vma_pages_range-never-return-negative-value.patch
mlock_vma_pages_range-only-return-success-or-failure.patch
vmscan-check-high-watermark-after-shrink-zone.patch
vmscan-check-high-watermark-after-shrink-zone-fix.patch
vmscan-get_scan_ratio-cleanup.patch
mm-page_allocc-remove-duplicate-call-to-trace_mm_page_free_direct.patch
mm-page_allocc-adjust-a-call-site-to-trace_mm_page_free_direct.patch
mm-remove-function-free_hot_page.patch
mm-remove-function-free_hot_page-fix.patch
mm-restore-zone-all_unreclaimable-to-independence-word-fix.patch
mm-restore-zone-all_unreclaimable-to-independence-word-fix-2.patch
mm-change-anon_vma-linking-to-fix-multi-process-server-scalability-issue.patch
mm-change-anon_vma-linking-to-fix-multi-process-server-scalability-issue-fix.patch
mm-change-anon_vma-linking-to-fix-multi-process-server-scalability-issue-further-cleanups.patch
rmap-remove-obsolete-check-from-__page_check_anon_rmap.patch
rmap-move-exclusively-owned-pages-to-own-anon_vma-in-do_wp_page.patch

