From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-page_alloc-rename-__gfp_wait-to-__gfp_reclaim-fix-99.patch removed from
 -mm tree
Date: Fri, 06 Nov 2015 16:08:37 -0800
Message-ID: <563d4105.gnMx42N0fBSqzv7c%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52616 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757821AbbKGAIi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 6 Nov 2015 19:08:38 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mgorman@techsingularity.net, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-page_alloc-rename-__gfp_wait-to-__gfp_reclaim-fix-99
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-rename-__gfp_wait-to-__gfp_reclaim-fix-99.patch

This patch was dropped because it was folded into mm-page_alloc-rename-__gfp_wait-to-__gfp_reclaim.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-page_alloc-rename-__gfp_wait-to-__gfp_reclaim-fix-99

Cc: Mel Gorman <mgorman@techsingularity.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 block/blk-core.c        |    4 ++--
 drivers/nvme/host/pci.c |    6 ++++--
 2 files changed, 6 insertions(+), 4 deletions(-)

diff -puN block/blk-core.c~mm-page_alloc-rename-__gfp_wait-to-__gfp_reclaim-fix-99 block/blk-core.c
--- a/block/blk-core.c~mm-page_alloc-rename-__gfp_wait-to-__gfp_reclaim-fix-99
+++ a/block/blk-core.c
@@ -638,7 +638,7 @@ int blk_queue_enter(struct request_queue
 		if (percpu_ref_tryget_live(&q->q_usage_counter))
 			return 0;
 
-		if (!(gfp & __GFP_WAIT))
+		if (!gfpflags_allow_blocking(gfp))
 			return -EBUSY;
 
 		ret = wait_event_interruptible(q->mq_freeze_wq,
@@ -2038,7 +2038,7 @@ void generic_make_request(struct bio *bi
 	do {
 		struct request_queue *q = bdev_get_queue(bio->bi_bdev);
 
-		if (likely(blk_queue_enter(q, __GFP_WAIT) == 0)) {
+		if (likely(blk_queue_enter(q, __GFP_DIRECT_RECLAIM) == 0)) {
 
 			q->make_request_fn(q, bio);
 
diff -puN drivers/nvme/host/pci.c~mm-page_alloc-rename-__gfp_wait-to-__gfp_reclaim-fix-99 drivers/nvme/host/pci.c
--- a/drivers/nvme/host/pci.c~mm-page_alloc-rename-__gfp_wait-to-__gfp_reclaim-fix-99
+++ a/drivers/nvme/host/pci.c
@@ -1025,11 +1025,13 @@ int __nvme_submit_sync_cmd(struct reques
 	req->special = (void *)0;
 
 	if (buffer && bufflen) {
-		ret = blk_rq_map_kern(q, req, buffer, bufflen, __GFP_WAIT);
+		ret = blk_rq_map_kern(q, req, buffer, bufflen,
+				      __GFP_DIRECT_RECLAIM);
 		if (ret)
 			goto out;
 	} else if (ubuffer && bufflen) {
-		ret = blk_rq_map_user(q, req, NULL, ubuffer, bufflen, __GFP_WAIT);
+		ret = blk_rq_map_user(q, req, NULL, ubuffer, bufflen,
+				      __GFP_DIRECT_RECLAIM);
 		if (ret)
 			goto out;
 		bio = req->bio;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-page_alloc-rename-__gfp_wait-to-__gfp_reclaim.patch
mm-page_alloc-only-enforce-watermarks-for-order-0-allocations-fix-fix.patch
include-linux-mmzoneh-reflow-comment.patch
mm-fs-introduce-mapping_gfp_constraint-checkpatch-fixes.patch
mm-memcontrolc-uninline-mem_cgroup_usage.patch
zsmalloc-add-comments-for-inuse-to-zspage-v2-fix.patch
include-linux-compiler-gcch-improve-__visible-documentation.patch
fs-jffs2-wbufc-remove-stray-semicolon.patch
lib-documentation-synchronize-%p-formatting-documentation-fix-fix.patch
rbtree-clarify-documentation-of-rbtree_postorder_for_each_entry_safe-fix.patch
dma-mapping-tidy-up-dma_parms-default-handling-fix.patch
panic-release-stale-console-lock-to-always-get-the-logbuf-printed-out-fix.patch

