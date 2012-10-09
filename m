From: akpm@linux-foundation.org
Subject: [merged] mm-remove-unevictable_pgs_mlockfreed.patch removed from -mm tree
Date: Tue, 09 Oct 2012 11:14:23 -0700
Message-ID: <20121009181423.C23A2100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f74.google.com ([209.85.216.74]:43458 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756823Ab2JISOZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Oct 2012 14:14:25 -0400
Received: by mail-qa0-f74.google.com with SMTP id a16so519186qae.1
        for <mm-commits@vger.kernel.org>; Tue, 09 Oct 2012 11:14:24 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hughd@google.com, hannes@cmpxchg.org, mel@csn.ul.ie, riel@redhat.com, walken@google.com, yinghan@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: remove unevictable_pgs_mlockfreed
has been removed from the -mm tree.  Its filename was
     mm-remove-unevictable_pgs_mlockfreed.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: mm: remove unevictable_pgs_mlockfreed

Simply remove UNEVICTABLE_MLOCKFREED and unevictable_pgs_mlockfreed line
from /proc/vmstat: Johannes and Mel point out that it was very unlikely to
have been used by any tool, and of course we can restore it easily enough
if that turns out to be wrong.

Signed-off-by: Hugh Dickins <hughd@google.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Rik van Riel <riel@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michel Lespinasse <walken@google.com>
Cc: Ying Han <yinghan@google.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/vm_event_item.h |    1 -
 mm/vmstat.c                   |    1 -
 2 files changed, 2 deletions(-)

diff -puN include/linux/vm_event_item.h~mm-remove-unevictable_pgs_mlockfreed include/linux/vm_event_item.h
--- a/include/linux/vm_event_item.h~mm-remove-unevictable_pgs_mlockfreed
+++ a/include/linux/vm_event_item.h
@@ -52,7 +52,6 @@ enum vm_event_item { PGPGIN, PGPGOUT, PS
 		UNEVICTABLE_PGMUNLOCKED,
 		UNEVICTABLE_PGCLEARED,	/* on COW, page truncate */
 		UNEVICTABLE_PGSTRANDED,	/* unable to isolate on unlock */
-		UNEVICTABLE_MLOCKFREED,	/* no longer useful: always zero */
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 		THP_FAULT_ALLOC,
 		THP_FAULT_FALLBACK,
diff -puN mm/vmstat.c~mm-remove-unevictable_pgs_mlockfreed mm/vmstat.c
--- a/mm/vmstat.c~mm-remove-unevictable_pgs_mlockfreed
+++ a/mm/vmstat.c
@@ -794,7 +794,6 @@ const char * const vmstat_text[] = {
 	"unevictable_pgs_munlocked",
 	"unevictable_pgs_cleared",
 	"unevictable_pgs_stranded",
-	"unevictable_pgs_mlockfreed",	/* no longer useful: always zero */
 
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 	"thp_fault_alloc",
_

Patches currently in -mm which might be from hughd@google.com are

origin.patch
linux-next.patch
swap-add-a-simple-detector-for-inappropriate-swapin-readahead.patch
swap-add-a-simple-detector-for-inappropriate-swapin-readahead-fix.patch

