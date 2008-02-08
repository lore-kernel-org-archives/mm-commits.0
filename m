From: akpm@linux-foundation.org
Subject: - kswapd-should-only-wait-on-io-if-there-is-io.patch removed from -mm tree
Date: Fri, 08 Feb 2008 00:03:44 -0800
Message-ID: <200802080803.m1883PS7014122@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52251 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761794AbYBHIT6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Feb 2008 03:19:58 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     kswapd should only wait on IO if there is IO
has been removed from the -mm tree.  Its filename was
     kswapd-should-only-wait-on-io-if-there-is-io.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: kswapd should only wait on IO if there is IO
From: Rik van Riel <riel@redhat.com>

The current kswapd (and try_to_free_pages) code has an oddity where the
code will wait on IO, even if there is no IO in flight.  This problem is
notable especially when the system scans through many unfreeable pages,
causing unnecessary stalls in the VM.

Additionally, tasks without __GFP_FS or __GFP_IO in the direct reclaim path
will sleep if a significant number of pages are encountered that should be
written out.  This gives kswapd a chance to write out those pages, while
the direct reclaim task sleeps.

Signed-off-by: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   27 ++++++++++++++++++++++-----
 1 file changed, 22 insertions(+), 5 deletions(-)

diff -puN mm/vmscan.c~kswapd-should-only-wait-on-io-if-there-is-io mm/vmscan.c
--- a/mm/vmscan.c~kswapd-should-only-wait-on-io-if-there-is-io
+++ a/mm/vmscan.c
@@ -70,6 +70,13 @@ struct scan_control {
 
 	int order;
 
+	/*
+	 * Pages that have (or should have) IO pending.  If we run into
+	 * a lot of these, we're better off waiting a little for IO to
+	 * finish rather than scanning more pages in the VM.
+	 */
+	int nr_io_pages;
+
 	/* Which cgroup do we reclaim from */
 	struct mem_cgroup *mem_cgroup;
 
@@ -499,8 +506,10 @@ static unsigned long shrink_page_list(st
 			 */
 			if (sync_writeback == PAGEOUT_IO_SYNC && may_enter_fs)
 				wait_on_page_writeback(page);
-			else
+			else {
+				sc->nr_io_pages++;
 				goto keep_locked;
+			}
 		}
 
 		referenced = page_referenced(page, 1, sc->mem_cgroup);
@@ -539,8 +548,10 @@ static unsigned long shrink_page_list(st
 		if (PageDirty(page)) {
 			if (sc->order <= PAGE_ALLOC_COSTLY_ORDER && referenced)
 				goto keep_locked;
-			if (!may_enter_fs)
+			if (!may_enter_fs) {
+				sc->nr_io_pages++;
 				goto keep_locked;
+			}
 			if (!sc->may_writepage)
 				goto keep_locked;
 
@@ -551,8 +562,10 @@ static unsigned long shrink_page_list(st
 			case PAGE_ACTIVATE:
 				goto activate_locked;
 			case PAGE_SUCCESS:
-				if (PageWriteback(page) || PageDirty(page))
+				if (PageWriteback(page) || PageDirty(page)) {
+					sc->nr_io_pages++;
 					goto keep;
+				}
 				/*
 				 * A synchronous write - probably a ramdisk.  Go
 				 * ahead and try to reclaim the page.
@@ -1259,6 +1272,7 @@ static unsigned long do_try_to_free_page
 
 	for (priority = DEF_PRIORITY; priority >= 0; priority--) {
 		sc->nr_scanned = 0;
+		sc->nr_io_pages = 0;
 		if (!priority)
 			disable_swap_token();
 		nr_reclaimed += shrink_zones(priority, zones, sc);
@@ -1292,7 +1306,8 @@ static unsigned long do_try_to_free_page
 		}
 
 		/* Take a nap, wait for some writeback to complete */
-		if (sc->nr_scanned && priority < DEF_PRIORITY - 2)
+		if (sc->nr_scanned && priority < DEF_PRIORITY - 2 &&
+				sc->nr_io_pages > sc->swap_cluster_max)
 			congestion_wait(WRITE, HZ/10);
 	}
 	/* top priority shrink_caches still had more to do? don't OOM, then */
@@ -1424,6 +1439,7 @@ loop_again:
 		if (!priority)
 			disable_swap_token();
 
+		sc.nr_io_pages = 0;
 		all_zones_ok = 1;
 
 		/*
@@ -1516,7 +1532,8 @@ loop_again:
 		 * OK, kswapd is getting into trouble.  Take a nap, then take
 		 * another pass across the zones.
 		 */
-		if (total_scanned && priority < DEF_PRIORITY - 2)
+		if (total_scanned && priority < DEF_PRIORITY - 2 &&
+					sc.nr_io_pages > sc.swap_cluster_max)
 			congestion_wait(WRITE, HZ/10);
 
 		/*
_

Patches currently in -mm which might be from riel@redhat.com are

origin.patch
vmscan-give-referenced-active-and-unmapped-pages-a-second-trip-around-the-lru.patch
