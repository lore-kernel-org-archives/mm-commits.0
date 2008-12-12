From: akpm@linux-foundation.org
Subject: + loop-flush-possible-running-bios-when-loop-device-is-released.patch added to -mm tree
Date: Thu, 11 Dec 2008 19:23:14 -0800
Message-ID: <200812120323.mBC3NEQS003580@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56971 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757828AbYLLDXf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 11 Dec 2008 22:23:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mbroz@redhat.com, agk@redhat.com, jens.axboe@oracle.com


The patch titled
     loop: flush possible running bios when loop device is released
has been added to the -mm tree.  Its filename is
     loop-flush-possible-running-bios-when-loop-device-is-released.patch

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
Subject: loop: flush possible running bios when loop device is released
From: Milan Broz <mbroz@redhat.com>

When there are still queued bios and reference count drops to zero, loop
device must flush all queued bios.

Otherwise it can lead to situation that caller closes the device, but some
bios are still running and endio() function call later oopses when uses
unallocated mempool.

This happens for example when running dm-crypt over loop, here is typical
oops backtrace:

 Oops: 0000 [#1] PREEMPT SMP
 EIP is at mempool_free+0x12/0x6b
...
 crypt_dec_pending+0x50/0x54 [dm_crypt]
 crypt_endio+0x9f/0xa7 [dm_crypt]
 crypt_endio+0x0/0xa7 [dm_crypt]
 bio_endio+0x2b/0x2e
 loop_thread+0x37a/0x3b1
 do_lo_send_aops+0x0/0x165
 autoremove_wake_function+0x0/0x33
 loop_thread+0x0/0x3b1
 kthread+0x3b/0x61
 kthread+0x0/0x61
 kernel_thread_helper+0x7/0x10

(But crash is reproducible with different dm targets running over loop
device too.)

Patch fixes it by flushing the bios in release call, reusing the flush
mechanism for switching backing store.

Signed-off-by: Milan Broz <mbroz@redhat.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
Cc: Alasdair G Kergon <agk@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/loop.c |   17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

diff -puN drivers/block/loop.c~loop-flush-possible-running-bios-when-loop-device-is-released drivers/block/loop.c
--- a/drivers/block/loop.c~loop-flush-possible-running-bios-when-loop-device-is-released
+++ a/drivers/block/loop.c
@@ -624,20 +624,33 @@ static int loop_switch(struct loop_devic
 }
 
 /*
+ * Helper to flush the IOs in loop, but keeping loop thread running
+ */
+static int loop_flush(struct loop_device *lo)
+{
+	return loop_switch(lo, NULL);
+}
+
+/*
  * Do the actual switch; called from the BIO completion routine
  */
 static void do_loop_switch(struct loop_device *lo, struct switch_request *p)
 {
 	struct file *file = p->file;
 	struct file *old_file = lo->lo_backing_file;
-	struct address_space *mapping = file->f_mapping;
+	struct address_space *mapping;
 
+	if (!file)
+		goto out;
+
+	mapping = file->f_mapping;
 	mapping_set_gfp_mask(old_file->f_mapping, lo->old_gfp_mask);
 	lo->lo_backing_file = file;
 	lo->lo_blocksize = S_ISBLK(mapping->host->i_mode) ?
 		mapping->host->i_bdev->bd_block_size : PAGE_SIZE;
 	lo->old_gfp_mask = mapping_gfp_mask(mapping);
 	mapping_set_gfp_mask(mapping, lo->old_gfp_mask & ~(__GFP_IO|__GFP_FS));
+out:
 	complete(&p->wait);
 }
 
@@ -1349,6 +1362,8 @@ static int lo_release(struct gendisk *di
 
 	if ((lo->lo_flags & LO_FLAGS_AUTOCLEAR) && !lo->lo_refcnt)
 		loop_clr_fd(lo, NULL);
+	else if (!lo->lo_refcnt && lo->lo_thread)
+		loop_flush(lo);
 
 	mutex_unlock(&lo->lo_ctl_mutex);
 
_

Patches currently in -mm which might be from mbroz@redhat.com are

loop-flush-possible-running-bios-when-loop-device-is-released.patch

