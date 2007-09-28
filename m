From: akpm@linux-foundation.org
Subject: + kswapd-should-only-wait-on-io-if-there-is-io.patch added to -mm tree
Date: Thu, 27 Sep 2007 17:12:18 -0700
Message-ID: <200709280012.l8S0CITx002334@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44667 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756554AbXI1AM6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 27 Sep 2007 20:12:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: riel@redhat.com


The patch titled
     kswapd should only wait on IO if there is IO
has been added to the -mm tree.  Its filename is
     kswapd-should-only-wait-on-io-if-there-is-io.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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


diff -puN mm/vmscan.c~kswapd-should-only-wait-on-io-if-there-is-io mm/vmscan.c
--- a/mm/vmscan.c~kswapd-should-only-wait-on-io-if-there-is-io
+++ a/mm/vmscan.c
@@ -68,6 +68,13 @@ struct scan_control {
 	int all_unreclaimable;
 
 	int order;
+
+	/*
+	 * Pages that have (or should have) IO pending.  If we run into
+	 * a lot of these, we're better off waiting a little for IO to
+	 * finish rather than scanning more pages in the VM.
+	 */
+	int nr_io_pages;
 };
 
 #define lru_to_page(_head) (list_entry((_head)->prev, struct page, lru))
@@ -489,8 +496,10 @@ static unsigned long shrink_page_list(st
 			 */
 			if (sync_writeback == PAGEOUT_IO_SYNC && may_enter_fs)
 				wait_on_page_writeback(page);
-			else
+			else {
+				sc->nr_io_pages++;
 				goto keep_locked;
+			}
 		}
 
 		referenced = page_referenced(page, 1);
@@ -529,8 +538,10 @@ static unsigned long shrink_page_list(st
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
 
@@ -541,8 +552,10 @@ static unsigned long shrink_page_list(st
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
@@ -1204,6 +1217,7 @@ unsigned long try_to_free_pages(struct z
 
 	for (priority = DEF_PRIORITY; priority >= 0; priority--) {
 		sc.nr_scanned = 0;
+		sc.nr_io_pages = 0;
 		if (!priority)
 			disable_swap_token();
 		nr_reclaimed += shrink_zones(priority, zones, &sc);
@@ -1232,7 +1246,8 @@ unsigned long try_to_free_pages(struct z
 		}
 
 		/* Take a nap, wait for some writeback to complete */
-		if (sc.nr_scanned && priority < DEF_PRIORITY - 2)
+		if (sc.nr_scanned && priority < DEF_PRIORITY - 2 &&
+				sc.nr_io_pages > sc.swap_cluster_max)
 			congestion_wait(WRITE, HZ/10);
 	}
 	/* top priority shrink_caches still had more to do? don't OOM, then */
@@ -1318,6 +1333,7 @@ loop_again:
 		if (!priority)
 			disable_swap_token();
 
+		sc.nr_io_pages = 0;
 		all_zones_ok = 1;
 
 		/*
@@ -1407,7 +1423,8 @@ loop_again:
 		 * OK, kswapd is getting into trouble.  Take a nap, then take
 		 * another pass across the zones.
 		 */
-		if (total_scanned && priority < DEF_PRIORITY - 2)
+		if (total_scanned && priority < DEF_PRIORITY - 2 &&
+					sc.nr_io_pages > sc.swap_cluster_max)
 			congestion_wait(WRITE, HZ/10);
 
 		/*
diff -puN /dev/null /dev/null
_

Patches currently in -mm which might be from riel@redhat.com are

vmscan-give-referenced-active-and-unmapped-pages-a-second-trip-around-the-lru.patch
prevent-kswapd-from-freeing-excessive-amounts-of-lowmem.patch
kswapd-should-only-wait-on-io-if-there-is-io.patch
writeback-remove-unnecessary-wait-in-throttle_vm_writeout.patch
