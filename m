From: akpm@linux-foundation.org
Subject: + mm-show_free_areas-display-slab-pages-in-two-separate-fields.patch added to -mm tree
Date: Wed, 01 Jul 2009 15:28:58 -0700
Message-ID: <200907012228.n61MSwh4010776@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56037 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753060AbZGAW3b (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Jul 2009 18:29:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kosaki.motohiro@jp.fujitsu.com, minchan.kim@gmail.com


The patch titled
     mm: show_free_areas(): display slab pages in two separate fields
has been added to the -mm tree.  Its filename is
     mm-show_free_areas-display-slab-pages-in-two-separate-fields.patch

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
Subject: mm: show_free_areas(): display slab pages in two separate fields
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

If an OOM happens, we really want to know the number of remaining
reclaimable pages.  So the reclaimable slab and unreclaimable slab fields
should not be combined for display.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff -puN mm/page_alloc.c~mm-show_free_areas-display-slab-pages-in-two-separate-fields mm/page_alloc.c
--- a/mm/page_alloc.c~mm-show_free_areas-display-slab-pages-in-two-separate-fields
+++ a/mm/page_alloc.c
@@ -2132,7 +2132,8 @@ void show_free_areas(void)
 		" inactive_file:%lu"
 		" unevictable:%lu"
 		" dirty:%lu writeback:%lu unstable:%lu\n"
-		" free:%lu slab:%lu mapped:%lu pagetables:%lu bounce:%lu\n",
+		" free:%lu slab_reclaimable:%lu slab_unreclaimable:%lu\n"
+		" mapped:%lu pagetables:%lu bounce:%lu\n",
 		global_page_state(NR_ACTIVE_ANON),
 		global_page_state(NR_ACTIVE_FILE),
 		global_page_state(NR_INACTIVE_ANON),
@@ -2142,8 +2143,8 @@ void show_free_areas(void)
 		global_page_state(NR_WRITEBACK),
 		global_page_state(NR_UNSTABLE_NFS),
 		global_page_state(NR_FREE_PAGES),
-		global_page_state(NR_SLAB_RECLAIMABLE) +
-			global_page_state(NR_SLAB_UNRECLAIMABLE),
+		global_page_state(NR_SLAB_RECLAIMABLE),
+		global_page_state(NR_SLAB_UNRECLAIMABLE),
 		global_page_state(NR_FILE_MAPPED),
 		global_page_state(NR_PAGETABLE),
 		global_page_state(NR_BOUNCE));
_

Patches currently in -mm which might be from kosaki.motohiro@jp.fujitsu.com are

linux-next.patch
readahead-add-blk_run_backing_dev.patch
readahead-add-blk_run_backing_dev-fix.patch
readahead-add-blk_run_backing_dev-fix-fix-2.patch
vmscan-dont-attempt-to-reclaim-anon-page-in-lumpy-reclaim-when-no-swap-space-is-available.patch
mm-clean-up-page_remove_rmap.patch
mm-show_free_areas-display-slab-pages-in-two-separate-fields.patch
getrusage-fill-ru_maxrss-value.patch
getrusage-fill-ru_maxrss-value-update.patch
fs-symlink-write_begin-allocation-context-fix-reiser4-fix.patch

