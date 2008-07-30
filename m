From: akpm@linux-foundation.org
Subject: + unevictable-lru-infrastructure-defer-vm-event-counting.patch added to -mm tree
Date: Wed, 30 Jul 2008 13:19:05 -0700
Message-ID: <200807302019.m6UKJ50N014947@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35301 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753435AbYG3UTe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Jul 2008 16:19:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: lee.schermerhorn@hp.com, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, riel@redhat.com


The patch titled
     unevictable lru:  defer vm event counting
has been added to the -mm tree.  Its filename is
     unevictable-lru-infrastructure-defer-vm-event-counting.patch

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
Subject: unevictable lru:  defer vm event counting
From: Lee Schermerhorn <lee.schermerhorn@hp.com>

Fix to unevictable-lru-infrastructure.patch

NORECL_* events are not defined this early in the series.  Remove the
event counting from this patch and add in with unevictable lru statistics
[subsequent patch].

Signed-off-by: Lee Schermerhorn <lee.schermerhorn@hp.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    6 ------
 1 file changed, 6 deletions(-)

diff -puN mm/vmscan.c~unevictable-lru-infrastructure-defer-vm-event-counting mm/vmscan.c
--- a/mm/vmscan.c~unevictable-lru-infrastructure-defer-vm-event-counting
+++ a/mm/vmscan.c
@@ -484,7 +484,6 @@ void putback_lru_page(struct page *page)
 {
 	int lru;
 	int active = !!TestClearPageActive(page);
-	int was_unevictable = PageUnevictable(page);
 
 	VM_BUG_ON(PageLRU(page));
 
@@ -526,11 +525,6 @@ redo:
 		 */
 	}
 
-	if (was_unevictable && lru != LRU_UNEVICTABLE)
-		count_vm_event(NORECL_PGRESCUED);
-	else if (!was_unevictable && lru == LRU_UNEVICTABLE)
-		count_vm_event(NORECL_PGCULLED);
-
 	put_page(page);		/* drop ref from isolate */
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
unevictable-lru-page-statistics.patch
ramfs-and-ram-disk-pages-are-unevictable.patch
shm_locked-pages-are-unevictable.patch
mlock-mlocked-pages-are-unevictable.patch
doc-unevictable-lru-and-mlocked-pages-documentation.patch
mlock-downgrade-mmap-sem-while-populating-mlocked-regions.patch
mmap-handle-mlocked-pages-during-map-remap-unmap.patch
vmstat-mlocked-pages-statistics.patch
swap-cull-unevictable-pages-in-fault-path.patch
vmstat-unevictable-and-mlocked-pages-vm-events.patch
vmscan-unevictable-lru-scan-sysctl.patch
mlock-count-attempts-to-free-mlocked-page.patch

