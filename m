From: akpm@linux-foundation.org
Subject: [merged] block-avoid-unnecessary-plug-list-flush.patch removed from -mm tree
Date: Thu, 17 Nov 2011 12:21:40 -0800
Message-ID: <201111172021.pAHKLe0r018478@wpaz9.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ww0-f74.google.com ([74.125.82.74]:38321 "EHLO
	mail-ww0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754203Ab1KQUVo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 17 Nov 2011 15:21:44 -0500
Received: by wwe5 with SMTP id 5so49875wwe.1
        for <mm-commits@vger.kernel.org>; Thu, 17 Nov 2011 12:21:43 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: shaohua.li@intel.com, axboe@kernel.dk, namhyung@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: block: avoid unnecessary plug list flush
has been removed from the -mm tree.  Its filename was
     block-avoid-unnecessary-plug-list-flush.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Shaohua Li <shaohua.li@intel.com>
Subject: block: avoid unnecessary plug list flush

get_request_wait() could sleep and flush the plug list.  If the list is
already flushed, don't flush again.

Signed-off-by: Shaohua Li <shaohua.li@intel.com>
Reviewed-by: Namhyung Kim <namhyung@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 block/blk-core.c |   18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

diff -puN block/blk-core.c~block-avoid-unnecessary-plug-list-flush block/blk-core.c
--- a/block/blk-core.c~block-avoid-unnecessary-plug-list-flush
+++ a/block/blk-core.c
@@ -1379,15 +1379,17 @@ get_rq:
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

Patches currently in -mm which might be from shaohua.li@intel.com are

linux-next.patch
x86-tlb-flush-avoid-superflous-leave_mm.patch
vmscan-promote-shared-file-mapped-pages.patch
vmscan-activate-executable-pages-after-first-usage.patch
intel_idle-fix-api-misuse.patch
intel_idle-disable-auto_demotion-for-hotplugged-cpus.patch

