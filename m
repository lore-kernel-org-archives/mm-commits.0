From: akpm@linux-foundation.org
Subject: + vmscan-comment-too_many_isolated.patch added to -mm tree
Date: Mon, 17 Dec 2012 13:42:33 -0800
Message-ID: <20121217214234.205CB20004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-la0-f74.google.com ([209.85.215.74]:41343 "EHLO
	mail-la0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751777Ab2LQVmh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 17 Dec 2012 16:42:37 -0500
Received: by mail-la0-f74.google.com with SMTP id v3so349834lag.1
        for <mm-commits@vger.kernel.org>; Mon, 17 Dec 2012 13:42:35 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: fengguang.wu@intel.com, kosaki.motohiro@jp.fujitsu.com, mel@csn.ul.ie, minchan.kim@gmail.com, riel@redhat.com


The patch titled
     Subject: vmscan: comment too_many_isolated()
has been added to the -mm tree.  Its filename is
     vmscan-comment-too_many_isolated.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Fengguang Wu <fengguang.wu@intel.com>
Subject: vmscan: comment too_many_isolated()

Comment "Why it's doing so" rather than "What it does" as proposed by
Andrew Morton.

Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>
Reviewed-by: Rik van Riel <riel@redhat.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff -puN mm/vmscan.c~vmscan-comment-too_many_isolated mm/vmscan.c
--- a/mm/vmscan.c~vmscan-comment-too_many_isolated
+++ a/mm/vmscan.c
@@ -1177,7 +1177,11 @@ int isolate_lru_page(struct page *page)
 }
 
 /*
- * Are there way too many processes in the direct reclaim path already?
+ * A direct reclaimer may isolate SWAP_CLUSTER_MAX pages from the LRU list and
+ * then get resheduled. When there are massive number of tasks doing page
+ * allocation, such sleeping direct reclaimers may keep piling up on each CPU,
+ * the LRU list will go small and be scanned faster than necessary, leading to
+ * unnecessary swapping, thrashing and OOM.
  */
 static int too_many_isolated(struct zone *zone, int file,
 		struct scan_control *sc)
_

Patches currently in -mm which might be from fengguang.wu@intel.com are

origin.patch
linux-next.patch
h8300-select-generic-atomic64_t-support.patch
vmscan-comment-too_many_isolated.patch
swap-add-a-simple-detector-for-inappropriate-swapin-readahead.patch
swap-add-a-simple-detector-for-inappropriate-swapin-readahead-fix.patch
hfsplus-rework-functionality-of-getting-setting-and-deleting-of-extended-attributes-fix.patch
fs-notify-add-procfs-fdinfo-helper-v7-fix-fix.patch

