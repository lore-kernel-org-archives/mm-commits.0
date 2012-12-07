From: akpm@linux-foundation.org
Subject: [obsolete] block-blk-corec-make-blk_drain_queue-static.patch removed from -mm tree
Date: Fri, 07 Dec 2012 12:40:54 -0800
Message-ID: <20121207204055.325A920004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wg0-f74.google.com ([74.125.82.74]:44591 "EHLO
	mail-wg0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1424123Ab2LGUk6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 7 Dec 2012 15:40:58 -0500
Received: by mail-wg0-f74.google.com with SMTP id dt14so57145wgb.1
        for <mm-commits@vger.kernel.org>; Fri, 07 Dec 2012 12:40:56 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tushar.behera@linaro.org, axboe@kernel.dk, mm-commits@vger.kernel.org


The patch titled
     Subject: block/blk-core.c: make blk_drain_queue() static
has been removed from the -mm tree.  Its filename was
     block-blk-corec-make-blk_drain_queue-static.patch

This patch was dropped because it is obsolete

------------------------------------------------------
From: Tushar Behera <tushar.behera@linaro.org>
Subject: block/blk-core.c: make blk_drain_queue() static

blk_drain_queue is only used in this file, so should be marked static.

Fixes following sparse warning.

block/blk-core.c:361:6: warning: symbol 'blk_drain_queue' was not
declared. Should it be static?

Signed-off-by: Tushar Behera <tushar.behera@linaro.org>
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 block/blk-core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN block/blk-core.c~block-blk-corec-make-blk_drain_queue-static block/blk-core.c
--- a/block/blk-core.c~block-blk-corec-make-blk_drain_queue-static
+++ a/block/blk-core.c
@@ -358,7 +358,7 @@ EXPORT_SYMBOL(blk_put_queue);
  * If not, only ELVPRIV requests are drained.  The caller is responsible
  * for ensuring that no new requests which need to be drained are queued.
  */
-void blk_drain_queue(struct request_queue *q, bool drain_all)
+static void blk_drain_queue(struct request_queue *q, bool drain_all)
 {
 	int i;
 
_

Patches currently in -mm which might be from tushar.behera@linaro.org are

linux-next.patch
fs-notify-inode_markc-make-fsnotify_find_inode_mark_locked-static.patch
drivers-rtc-rtc-s3cc-remove-unnecessary-err_nores-label.patch
drivers-rtc-rtc-s3cc-convert-to-use-devm_-api.patch

