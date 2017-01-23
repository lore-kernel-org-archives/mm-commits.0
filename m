From: akpm@linux-foundation.org
Subject: + mm-vmscan-scan-dirty-pages-even-in-laptop-mode.patch added to
 -mm tree
Date: Mon, 23 Jan 2017 14:21:22 -0800
Message-ID: <588681e2.g3XsAvWcSDFDG110%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42936 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751701AbdAWWVY (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 23 Jan 2017 17:21:24 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, mgorman@suse.de, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: vmscan: scan dirty pages even in laptop mode
has been added to the -mm tree.  Its filename is
     mm-vmscan-scan-dirty-pages-even-in-laptop-mode.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-vmscan-scan-dirty-pages-even-in-laptop-mode.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-vmscan-scan-dirty-pages-even-in-laptop-mode.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: vmscan: scan dirty pages even in laptop mode

Patch series "mm: vmscan: fix kswapd writeback regression".

We noticed a regression on multiple hadoop workloads when moving from 3.10
to 4.0 and 4.6, which involves kswapd getting tangled up in page writeout,
causing direct reclaim herds that also don't make progress.

I tracked it down to the thrash avoidance efforts after 3.10 that make the
kernel better at keeping use-once cache and use-many cache sorted on the
inactive and active list, with more aggressive protection of the active
list as long as there is inactive cache.  Unfortunately, our workload's
use-once cache is mostly from streaming writes.  Waiting for writes to
avoid potential reloads in the future is not a good tradeoff.

These patches do the following:

1. Wake the flushers when kswapd sees a lump of dirty pages. It's
   possible to be below the dirty background limit and still have
   cache velocity push them through the LRU. So start a-flushin'.

2. Let kswapd only write pages that have been rotated twice. This
   makes sure we really tried to get all the clean pages on the
   inactive list before resorting to horrible LRU-order writeback.

3. Move rotating dirty pages off the inactive list. Instead of
   churning or waiting on page writeback, we'll go after clean active
   cache. This might lead to thrashing, but in this state memory
   demand outstrips IO speed anyway, and reads are faster than writes.


This patch (of 5):

We have an elaborate dirty/writeback throttling mechanism inside the
reclaim scanner, but for that to work the pages have to go through
shrink_page_list() and get counted for what they are.  Otherwise, we mess
up the LRU order and don't match reclaim speed to writeback.

Especially during deactivation, there is never a reason to skip dirty
pages; nothing is even trying to write them out from there.  Don't mess up
the LRU order for nothing, shuffle these pages along.

Link: http://lkml.kernel.org/r/20170123181641.23938-2-hannes@cmpxchg.org
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h |    2 --
 mm/vmscan.c            |   14 ++------------
 2 files changed, 2 insertions(+), 14 deletions(-)

diff -puN include/linux/mmzone.h~mm-vmscan-scan-dirty-pages-even-in-laptop-mode include/linux/mmzone.h
--- a/include/linux/mmzone.h~mm-vmscan-scan-dirty-pages-even-in-laptop-mode
+++ a/include/linux/mmzone.h
@@ -236,8 +236,6 @@ struct lruvec {
 #define LRU_ALL_ANON (BIT(LRU_INACTIVE_ANON) | BIT(LRU_ACTIVE_ANON))
 #define LRU_ALL	     ((1 << NR_LRU_LISTS) - 1)
 
-/* Isolate clean file */
-#define ISOLATE_CLEAN		((__force isolate_mode_t)0x1)
 /* Isolate unmapped file */
 #define ISOLATE_UNMAPPED	((__force isolate_mode_t)0x2)
 /* Isolate for asynchronous migration */
diff -puN mm/vmscan.c~mm-vmscan-scan-dirty-pages-even-in-laptop-mode mm/vmscan.c
--- a/mm/vmscan.c~mm-vmscan-scan-dirty-pages-even-in-laptop-mode
+++ a/mm/vmscan.c
@@ -87,6 +87,7 @@ struct scan_control {
 	/* The highest zone to isolate pages for reclaim from */
 	enum zone_type reclaim_idx;
 
+	/* Writepage batching in laptop mode; RECLAIM_WRITE */
 	unsigned int may_writepage:1;
 
 	/* Can mapped pages be reclaimed? */
@@ -1373,13 +1374,10 @@ int __isolate_lru_page(struct page *page
 	 * wants to isolate pages it will be able to operate on without
 	 * blocking - clean pages for the most part.
 	 *
-	 * ISOLATE_CLEAN means that only clean pages should be isolated. This
-	 * is used by reclaim when it is cannot write to backing storage
-	 *
 	 * ISOLATE_ASYNC_MIGRATE is used to indicate that it only wants to pages
 	 * that it is possible to migrate without blocking
 	 */
-	if (mode & (ISOLATE_CLEAN|ISOLATE_ASYNC_MIGRATE)) {
+	if (mode & ISOLATE_ASYNC_MIGRATE) {
 		/* All the caller can do on PageWriteback is block */
 		if (PageWriteback(page))
 			return ret;
@@ -1387,10 +1385,6 @@ int __isolate_lru_page(struct page *page
 		if (PageDirty(page)) {
 			struct address_space *mapping;
 
-			/* ISOLATE_CLEAN means only clean pages */
-			if (mode & ISOLATE_CLEAN)
-				return ret;
-
 			/*
 			 * Only pages without mappings or that have a
 			 * ->migratepage callback are possible to migrate
@@ -1731,8 +1725,6 @@ shrink_inactive_list(unsigned long nr_to
 
 	if (!sc->may_unmap)
 		isolate_mode |= ISOLATE_UNMAPPED;
-	if (!sc->may_writepage)
-		isolate_mode |= ISOLATE_CLEAN;
 
 	spin_lock_irq(&pgdat->lru_lock);
 
@@ -1929,8 +1921,6 @@ static void shrink_active_list(unsigned
 
 	if (!sc->may_unmap)
 		isolate_mode |= ISOLATE_UNMAPPED;
-	if (!sc->may_writepage)
-		isolate_mode |= ISOLATE_CLEAN;
 
 	spin_lock_irq(&pgdat->lru_lock);
 
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

mm-vmscan-scan-dirty-pages-even-in-laptop-mode.patch
mm-vmscan-kick-flushers-when-we-encounter-dirty-pages-on-the-lru.patch
mm-vmscan-remove-old-flusher-wakeup-from-direct-reclaim-path.patch
mm-vmscan-only-write-dirty-pages-that-the-scanner-has-seen-twice.patch
mm-vmscan-move-dirty-pages-out-of-the-way-until-theyre-flushed.patch

