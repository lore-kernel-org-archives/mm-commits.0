From: akpm@linux-foundation.org
Subject: [merged] block-fix-blk_queue_end_tag.patch removed from -mm tree
Date: Tue, 03 Jan 2012 13:35:50 -0800
Message-ID: <20120103213550.C0F891E0058@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gy0-f202.google.com ([209.85.160.202]:45909 "EHLO
	mail-gy0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754125Ab2ACVfw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 3 Jan 2012 16:35:52 -0500
Received: by ghrr15 with SMTP id r15so1687434ghr.1
        for <mm-commits@vger.kernel.org>; Tue, 03 Jan 2012 13:35:51 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dan.j.williams@intel.com, axboe@kernel.dk, boyu.mt@taobao.com, edmund.nadolski@intel.com, matthew@wil.cx, mroos@ut.ee, tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: block: fix blk_queue_end_tag()
has been removed from the -mm tree.  Its filename was
     block-fix-blk_queue_end_tag.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Dan Williams <dan.j.williams@intel.com>
Subject: block: fix blk_queue_end_tag()

Commit 5e081591 "block: warn if tag is greater than real_max_depth"
cleaned up blk_queue_end_tag() to warn when the tag is truly invalid
(greater than real_max_depth).  However, it changed behavior in the tag <
max_depth case to not end the request.  Leading to triggering of
BUG_ON(blk_queued_rq(rq)) in the request completion path:

  http://marc.info/?l=linux-kernel&m=132204370518629&w=2

In order to allow blk_queue_resize_tags() to shrink the tag space
blk_queue_end_tag() must always complete tags with a value less than
real_max_depth regardless of the current max_depth.  The comment about
"handling the shrink case" seems to be what prompted changes in this
space, so remove it and BUG on all invalid tags (made even simpler by
Matthew's suggestion to use an unsigned compare).

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Cc: Tao Ma <boyu.mt@taobao.com>
Cc: Matthew Wilcox <matthew@wil.cx>
Reported-by: Meelis Roos <mroos@ut.ee>
Reported-by: Ed Nadolski <edmund.nadolski@intel.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 block/blk-tag.c |   13 ++-----------
 1 file changed, 2 insertions(+), 11 deletions(-)

diff -puN block/blk-tag.c~block-fix-blk_queue_end_tag block/blk-tag.c
--- a/block/blk-tag.c~block-fix-blk_queue_end_tag
+++ a/block/blk-tag.c
@@ -282,18 +282,9 @@ EXPORT_SYMBOL(blk_queue_resize_tags);
 void blk_queue_end_tag(struct request_queue *q, struct request *rq)
 {
 	struct blk_queue_tag *bqt = q->queue_tags;
-	int tag = rq->tag;
+	unsigned tag = rq->tag; /* negative tags invalid */
 
-	BUG_ON(tag == -1);
