From: akpm@linux-foundation.org
Subject: + shm_locked-pages-are-unevictable-add-event-counts-to-list-scan.patch added to -mm tree
Date: Wed, 30 Jul 2008 13:21:16 -0700
Message-ID: <200807302021.m6UKLGBI015009@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33691 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751320AbYG3UVt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Jul 2008 16:21:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: lee.schermerhorn@hp.com, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, riel@redhat.com


The patch titled
     unevictable lru: add event counts to list scan
has been added to the -mm tree.  Its filename is
     shm_locked-pages-are-unevictable-add-event-counts-to-list-scan.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: unevictable lru: add event counts to list scan
From: Lee Schermerhorn <lee.schermerhorn@hp.com>

Fix to shm_locked-pages-are-unevictable.patch

More breaking up of the single unevictable lru/mlocked pages vm events
patch.

Add the vm events counting to the unevictable lru list scanning for
shm_unlock().

Signed-off-by: Lee Schermerhorn <lee.schermerhorn@hp.com>
Cc: Lee Schermerhorn <lee.schermerhorn@hp.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Kosaki Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    5 +++++
 1 file changed, 5 insertions(+)

diff -puN mm/vmscan.c~shm_locked-pages-are-unevictable-add-event-counts-to-list-scan mm/vmscan.c
--- a/mm/vmscan.c~shm_locked-pages-are-unevictable-add-event-counts-to-list-scan
+++ a/mm/vmscan.c
@@ -2407,6 +2407,7 @@ retry:
 		__dec_zone_state(zone, NR_UNEVICTABLE);
 		list_move(&page->lru, &zone->lru[l].list);
 		__inc_zone_state(zone, NR_INACTIVE_ANON + l);
+		__count_vm_event(UNEVICTABLE_PGRESCUED);
 	} else {
 		/*
 		 * rotate unevictable list
@@ -2440,6 +2441,7 @@ void scan_mapping_unevictable_pages(stru
 	while (next < end &&
 		pagevec_lookup(&pvec, mapping, next, PAGEVEC_SIZE)) {
 		int i;
+		int pg_scanned = 0;
 
 		zone = NULL;
 
@@ -2448,6 +2450,7 @@ void scan_mapping_unevictable_pages(stru
 			pgoff_t page_index = page->index;
 			struct zone *pagezone = page_zone(page);
 
+			pg_scanned++;
 			if (page_index > next)
 				next = page_index;
 			next++;
@@ -2465,6 +2468,8 @@ void scan_mapping_unevictable_pages(stru
 		if (zone)
 			spin_unlock_irq(&zone->lru_lock);
 		pagevec_release(&pvec);
+
+		count_vm_events(UNEVICTABLE_PGSCANNED, pg_scanned);
 	}
 
 }
_

Patches currently in -mm which might be from lee.schermerhorn@hp.com are

vmscan-use-an-indexed-array-for-lru-variables.patch
define-page_file_cache-function.patch
vmscan-split-lru-lists-into-anon-file-sets.patch
pageflag-helpers-for-configed-out-flags.patch
unevictable-lru-infrastructure.patch
unevictable-lru-infrastructure-nommu-fix.patch
unevictable-lru-infrastructure-remember-pages-active-state.patch
unevictable-lru-infrastructure-defer-vm-event-counting.patch
unevictable-infrastructure-lru-add-event-counting-with-statistics.patch
unevictable-lru-page-statistics.patch
ramfs-and-ram-disk-pages-are-unevictable.patch
shm_locked-pages-are-unevictable.patch
shm_locked-pages-are-unevictable-add-event-counts-to-list-scan.patch
mlock-mlocked-pages-are-unevictable.patch
doc-unevictable-lru-and-mlocked-pages-documentation.patch
mlock-downgrade-mmap-sem-while-populating-mlocked-regions.patch
mmap-handle-mlocked-pages-during-map-remap-unmap.patch
vmstat-mlocked-pages-statistics.patch
swap-cull-unevictable-pages-in-fault-path.patch
vmstat-unevictable-and-mlocked-pages-vm-events.patch
vmscan-unevictable-lru-scan-sysctl.patch
mlock-count-attempts-to-free-mlocked-page.patch

