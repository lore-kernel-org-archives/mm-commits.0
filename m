From: akpm@google.com
Subject: + block-avoid-unnecessary-plug-list-flush.patch added to -mm tree
Date: Thu, 06 Oct 2011 14:12:06 -0700
Message-ID: <201110062112.p96LC7io030105@wpaz9.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([74.125.121.67]:6814 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758655Ab1JFVMP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 6 Oct 2011 17:12:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: shaohua.li@intel.com, axboe@kernel.dk, namhyung@gmail.com


The patch titled
     Subject: block: avoid unnecessary plug list flush
has been added to the -mm tree.  Its filename is
     block-avoid-unnecessary-plug-list-flush.patch

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
From: Shaohua Li <shaohua.li@intel.com>
Subject: block: avoid unnecessary plug list flush

get_request_wait() could sleep and flush the plug list.  If the list is
already flushed, don't flush again.

Signed-off-by: Shaohua Li <shaohua.li@intel.com>
Reviewed-by: Namhyung Kim <namhyung@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Andrew Morton <akpm@google.com>
---

 block/blk-core.c |   18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

diff -puN block/blk-core.c~block-avoid-unnecessary-plug-list-flush block/blk-core.c
--- a/block/blk-core.c~block-avoid-unnecessary-plug-list-flush
+++ a/block/blk-core.c
@@ -1296,15 +1296,17 @@ get_rq:
 		 */
 		if (list_empty(&plug->list))
 			trace_block_plug(q);
-		else if (!plug->should_sort) {
-			struct request *__rq;
-
-			__rq = list_entry_rq(plug->list.prev);
-			if (__rq->q != q)
-				plug->should_sort = 1;
+		else {
+			if (!plug->should_sort) {
+				struct request *__rq;
+
+				__rq = list_entry_rq(plug->list.prev);
+				if (__rq->q != q)
+					plug->should_sort = 1;
+			}
+			if (request_count >= BLK_MAX_REQUEST_COUNT)
+				blk_flush_plug_list(plug, false);
 		}
-		if (request_count >= BLK_MAX_REQUEST_COUNT)
-			blk_flush_plug_list(plug, false);
 		list_add_tail(&req->queuelist, &plug->list);
 		drive_stat_acct(req, 1);
 	} else {
_
Subject: Subject: block: avoid unnecessary plug list flush

Patches currently in -mm which might be from shaohua.li@intel.com are

origin.patch
linux-next.patch
x86-tlb-flush-avoid-superflous-leave_mm.patch
block-avoid-unnecessary-plug-list-flush.patch
block-add-missed-trace_block_plug.patch
vmscan-add-block-plug-for-page-reclaim.patch
vmscan-count-pages-into-balanced-for-zone-with-good-watermark.patch
vmscan-promote-shared-file-mapped-pages.patch
vmscan-activate-executable-pages-after-first-usage.patch
intel_idle-fix-api-misuse.patch
intel_idle-disable-auto_demotion-for-hotplugged-cpus.patch

