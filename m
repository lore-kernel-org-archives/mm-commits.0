From: akpm@osdl.org
Subject: - dio-call-blk_run_address_space-once-per-op.patch removed from -mm tree
Date: Tue, 12 Dec 2006 22:55:10 -0800
Message-ID: <200612130655.kBD6tAYr030615@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:57842 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965035AbWLMGzu (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 13 Dec 2006 01:55:50 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: zach.brown@oracle.com, jmoyer@redhat.com, pbadari@us.ibm.com, suparna@in.ibm.com, mm-commits@vger.kernel.org


The patch titled
     dio: call blk_run_address_space() once per op
has been removed from the -mm tree.  Its filename was
     dio-call-blk_run_address_space-once-per-op.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: dio: call blk_run_address_space() once per op
From: Zach Brown <zach.brown@oracle.com>

We only need to call blk_run_address_space() once after all the bios for the
direct IO op have been submitted.  This removes the chance of calling
blk_run_address_space() after spurious wake ups as the sync path waits for
bios to drain.  It's also one less difference betwen the sync and async paths.

In the process we remove a redundant dio_bio_submit() that its caller had
already performed.

Signed-off-by: Zach Brown <zach.brown@oracle.com>
Cc: Badari Pulavarty <pbadari@us.ibm.com>
Cc: Suparna Bhattacharya <suparna@in.ibm.com>
Acked-by: Jeff Moyer <jmoyer@redhat.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/direct-io.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff -puN fs/direct-io.c~dio-call-blk_run_address_space-once-per-op fs/direct-io.c
--- a/fs/direct-io.c~dio-call-blk_run_address_space-once-per-op
+++ a/fs/direct-io.c
@@ -404,7 +404,6 @@ static struct bio *dio_await_one(struct 
 		if (dio->bio_list == NULL) {
 			dio->waiter = current;
 			spin_unlock_irqrestore(&dio->bio_lock, flags);
-			blk_run_address_space(dio->inode->i_mapping);
 			io_schedule();
 			spin_lock_irqsave(&dio->bio_lock, flags);
 			dio->waiter = NULL;
@@ -450,9 +449,6 @@ static int dio_bio_complete(struct dio *
  */
 static void dio_await_completion(struct dio *dio)
 {
-	if (dio->bio)
-		dio_bio_submit(dio);
-
 	/*
 	 * The bio_lock is not held for the read of bio_count.
 	 * This is ok since it is the dio_bio_complete() that changes
@@ -1085,6 +1081,9 @@ direct_io_worker(int rw, struct kiocb *i
 	if (dio->bio)
 		dio_bio_submit(dio);
 
+	/* All IO is now issued, send it on its way */
+	blk_run_address_space(inode->i_mapping);
+
 	/*
 	 * It is possible that, we return short IO due to end of file.
 	 * In that case, we need to release all the pages we got hold on.
@@ -1113,7 +1112,6 @@ direct_io_worker(int rw, struct kiocb *i
 		if (ret == 0)
 			ret = dio->result;
 		finished_one_bio(dio);		/* This can free the dio */
-		blk_run_address_space(inode->i_mapping);
 		if (should_wait) {
 			unsigned long flags;
 			/*
_

Patches currently in -mm which might be from zach.brown@oracle.com are

origin.patch
optimize-o_direct-on-block-device-v3.patch
optimize-o_direct-on-block-device-v3-tweak.patch

