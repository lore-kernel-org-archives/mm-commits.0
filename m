From: akpm@linux-foundation.org
Subject: + unevictable-lru-infrastructure-remember-pages-active-state.patch added to -mm tree
Date: Wed, 30 Jul 2008 13:18:10 -0700
Message-ID: <200807302018.m6UKIASN014857@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41633 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753814AbYG3USx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Jul 2008 16:18:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: lee.schermerhorn@hp.com, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, riel@redhat.com


The patch titled
     unevictable lru: remember page's active state
has been added to the -mm tree.  Its filename is
     unevictable-lru-infrastructure-remember-pages-active-state.patch

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
Subject: unevictable lru: remember page's active state
From: Lee Schermerhorn <lee.schermerhorn@hp.com>

Fix to unevictable-lru-infrastructure.patch

Not sure this is absolutely required, but:

Preserve page's incoming active flag across retries in
putback_lru_page().

Signed-off-by: Lee Schermerhorn <lee.schermerhorn@hp.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN mm/vmscan.c~unevictable-lru-infrastructure-remember-pages-active-state mm/vmscan.c
--- a/mm/vmscan.c~unevictable-lru-infrastructure-remember-pages-active-state
+++ a/mm/vmscan.c
@@ -483,12 +483,12 @@ int remove_mapping(struct address_space 
 void putback_lru_page(struct page *page)
 {
 	int lru;
+	int active = !!TestClearPageActive(page);
 	int was_unevictable = PageUnevictable(page);
 
 	VM_BUG_ON(PageLRU(page));
 
 redo:
-	lru = !!TestClearPageActive(page);
 	ClearPageUnevictable(page);
 
 	if (page_evictable(page, NULL)) {
@@ -498,7 +498,7 @@ redo:
 		 * unevictable page on [in]active list.
 		 * We know how to handle that.
 		 */
-		lru += page_is_file_cache(page);
+		lru = active + page_is_file_cache(page);
 		lru_cache_add_lru(page, lru);
 	} else {
 		/*
_

Patches currently in -mm which might be from lee.schermerhorn@hp.com are

vmscan-use-an-indexed-array-for-lru-variables.patch
define-page_file_cache-function.patch
vmscan-split-lru-lists-into-anon-file-sets.patch
pageflag-helpers-for-configed-out-flags.patch
unevictable-lru-infrastructure.patch
unevictable-lru-infrastructure-nommu-fix.patch
unevictable-lru-infrastructure-remember-pages-active-state.patch
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

