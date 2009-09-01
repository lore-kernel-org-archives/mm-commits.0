From: akpm@linux-foundation.org
Subject: + mm-memory-failure-remove-config_unevictable_lru-config-option.patch added to -mm tree
Date: Tue, 01 Sep 2009 15:47:41 -0700
Message-ID: <200909012247.n81MlfuZ020934@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52806 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755309AbZIAWtP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 Sep 2009 18:49:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: macli@brc.ubc.ca, andi@firstfloor.org, fengguang.wu@intel.com, kosaki.motohiro@jp.fujitsu.com, minchan.kim@gmail.com


The patch titled
     mm/memory-failure: remove CONFIG_UNEVICTABLE_LRU config option
has been added to the -mm tree.  Its filename is
     mm-memory-failure-remove-config_unevictable_lru-config-option.patch

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
Subject: mm/memory-failure: remove CONFIG_UNEVICTABLE_LRU config option
From: Vincent Li <macli@brc.ubc.ca>

Commit 683776596 (remove CONFIG_UNEVICTABLE_LRU config option) removed
this config option.  Removed it from mm/memory-failure too.

Signed-off-by: Vincent Li <macli@brc.ubc.ca>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>
Acked-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Acked-by: Wu Fengguang <fengguang.wu@intel.com>
Cc: Andi Kleen <andi@firstfloor.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |    2 --
 1 file changed, 2 deletions(-)

diff -puN mm/memory-failure.c~mm-memory-failure-remove-config_unevictable_lru-config-option mm/memory-failure.c
--- a/mm/memory-failure.c~mm-memory-failure-remove-config_unevictable_lru-config-option
+++ a/mm/memory-failure.c
@@ -587,10 +587,8 @@ static struct page_state {
 	{ sc|dirty,	sc|dirty,	"swapcache",	me_swapcache_dirty },
 	{ sc|dirty,	sc,		"swapcache",	me_swapcache_clean },
 
-#ifdef CONFIG_UNEVICTABLE_LRU
 	{ unevict|dirty, unevict|dirty,	"unevictable LRU", me_pagecache_dirty},
 	{ unevict,	unevict,	"unevictable LRU", me_pagecache_clean},
-#endif
 
 #ifdef CONFIG_HAVE_MLOCKED_PAGE_BIT
 	{ mlock|dirty,	mlock|dirty,	"mlocked LRU",	me_pagecache_dirty },
_

Patches currently in -mm which might be from macli@brc.ubc.ca are

mm-memory-failure-remove-config_unevictable_lru-config-option.patch
mm-count-only-reclaimable-lru-pages-v2.patch
tracing-page-allocator-add-trace-events-for-page-allocation-and-page-freeing.patch
tracing-page-allocator-add-trace-events-for-anti-fragmentation-falling-back-to-other-migratetypes.patch
tracing-page-allocator-add-trace-event-for-page-traffic-related-to-the-buddy-lists.patch
tracing-page-allocator-add-trace-event-for-page-traffic-related-to-the-buddy-lists-fix.patch
tracing-page-allocator-add-a-postprocessing-script-for-page-allocator-related-ftrace-events.patch
tracing-documentation-add-a-document-describing-how-to-do-some-performance-analysis-with-tracepoints.patch
tracing-documentation-add-a-document-on-the-kmem-tracepoints.patch
mm-vmscan-rename-zone_nr_pages-to-zone_lru_nr_pages.patch
mm-vmscan-remove-page_queue_congested-comment.patch
fs-proc-task_mmuc-v1-fix-clear_refs_write-input-sanity-check.patch
fs-proc-basec-fix-proc_fault_inject_write-input-sanity-check.patch

