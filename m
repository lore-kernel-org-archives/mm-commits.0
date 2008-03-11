From: akpm@linux-foundation.org
Subject: + block-fix-blk_register_queue-return-value.patch added to -mm tree
Date: Mon, 10 Mar 2008 22:43:04 -0700
Message-ID: <200803110543.m2B5h4xb024775@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53360 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752730AbYCKFnJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 11 Mar 2008 01:43:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akinobu.mita@gmail.com, axboe@kernel.dk


The patch titled
     block: fix blk_register_queue() return value
has been added to the -mm tree.  Its filename is
     block-fix-blk_register_queue-return-value.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: block: fix blk_register_queue() return value
From: Akinobu Mita <akinobu.mita@gmail.com>

blk_register_queue() returns -ENXIO when queue->request_fn is NULL.  But there
are some block drivers that call blk_register_queue() via add_disk() with
queue->request_fn == NULL.  (For example, brd, loop)

Although no one checks return value of blk_register_queue(), this patch makes
it return 0 instead of -ENXIO when queue->request_fn is NULL,

Also this patch adds warning when blk_register_queue() and
blk_unregister_queue() are called with queue == NULL rather than ignore
invalid usage silently.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 block/blk-sysfs.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff -puN block/blk-sysfs.c~block-fix-blk_register_queue-return-value block/blk-sysfs.c
--- a/block/blk-sysfs.c~block-fix-blk_register_queue-return-value
+++ a/block/blk-sysfs.c
@@ -276,9 +276,12 @@ int blk_register_queue(struct gendisk *d
 
 	struct request_queue *q = disk->queue;
 
-	if (!q || !q->request_fn)
+	if (WARN_ON(!q))
 		return -ENXIO;
 
+	if (!q->request_fn)
+		return 0;
+
 	ret = kobject_add(&q->kobj, kobject_get(&disk->dev.kobj),
 			  "%s", "queue");
 	if (ret < 0)
@@ -300,7 +303,10 @@ void blk_unregister_queue(struct gendisk
 {
 	struct request_queue *q = disk->queue;
 
-	if (q && q->request_fn) {
+	if (WARN_ON(!q))
+		return;
+
+	if (q->request_fn) {
 		elv_unregister_queue(q);
 
 		kobject_uevent(&q->kobj, KOBJ_REMOVE);
_

Patches currently in -mm which might be from akinobu.mita@gmail.com are

block-fix-blk_register_queue-return-value.patch
ext2-improve-ext2_readdir-return-value.patch
ext2-use-ext2_group_first_block_no.patch
ext2-use-ext2_fsblk_t-type.patch
ext3-use-ext3_group_first_block_no.patch
ext3-add-missing-ext3_journal_stop.patch
ext3-use-ext3_get_group_desc.patch
ext3-check-ext3_journal_get_write_access-errors.patch

