From: akpm@linux-foundation.org
Subject: + block-blk-corec-make-blk_drain_queue-static.patch added to -mm tree
Date: Thu, 06 Dec 2012 15:32:34 -0800
Message-ID: <20121206233234.A405A100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yh0-f74.google.com ([209.85.213.74]:43674 "EHLO
	mail-yh0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932380Ab2LFXcf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 6 Dec 2012 18:32:35 -0500
Received: by mail-yh0-f74.google.com with SMTP id 10so713145yhl.1
        for <mm-commits@vger.kernel.org>; Thu, 06 Dec 2012 15:32:35 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tushar.behera@linaro.org, axboe@kernel.dk


The patch titled
     Subject: block/blk-core.c: make blk_drain_queue() static
has been added to the -mm tree.  Its filename is
     block-blk-corec-make-blk_drain_queue-static.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
block-blk-corec-make-blk_drain_queue-static.patch
fs-notify-inode_markc-make-fsnotify_find_inode_mark_locked-static.patch
drivers-rtc-rtc-s3cc-remove-unnecessary-err_nores-label.patch
drivers-rtc-rtc-s3cc-convert-to-use-devm_-api.patch

