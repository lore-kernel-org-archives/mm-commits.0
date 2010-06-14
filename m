From: akpm@linux-foundation.org
Subject: + floppy-use-warning-macros.patch added to -mm tree
Date: Mon, 14 Jun 2010 12:39:30 -0700
Message-ID: <201006141939.o5EJdU3u026933@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36142 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753774Ab0FNTje (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 14 Jun 2010 15:39:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: shemminger@vyatta.com, axboe@kernel.dk


The patch titled
     floppy: use warning macros
has been added to the -mm tree.  Its filename is
     floppy-use-warning-macros.patch

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
Subject: floppy: use warning macros
From: Stephen Hemminger <shemminger@vyatta.com>

Convert assertions to use WARN().  There are several error checks in the
code for things that should never happen.  Convert them to standard
warnings so kerneloops.org will see them.

Signed-off-by: Stephen Hemminger <shemminger@vyatta.com>
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/floppy.c |   27 +++++++++++----------------
 1 file changed, 11 insertions(+), 16 deletions(-)

diff -puN drivers/block/floppy.c~floppy-use-warning-macros drivers/block/floppy.c
--- a/drivers/block/floppy.c~floppy-use-warning-macros
+++ a/drivers/block/floppy.c
@@ -2542,10 +2542,8 @@ static int make_raw_rw_request(void)
 	int tracksize;
 	int ssize;
 
-	if (max_buffer_sectors == 0) {
-		pr_info("VFS: Block I/O scheduled on unopened device\n");
+	if (WARN(max_buffer_sectors == 0, "VFS: Block I/O scheduled on unopened device\n"))
 		return 0;
-	}
 
 	set_fdc((long)current_req->rq_disk->private_data);
 
@@ -2895,19 +2893,16 @@ static void process_fd_request(void)
 
 static void do_fd_request(struct request_queue *q)
 {
-	if (max_buffer_sectors == 0) {
-		pr_info("VFS: %s called on non-open device\n", __func__);
+	if (WARN(max_buffer_sectors == 0,
+		 "VFS: %s called on non-open device\n", __func__))
 		return;
-	}
 
-	if (atomic_read(&usage_count) == 0) {
-		pr_info("warning: usage count=0, current_req=%p exiting\n",
-			current_req);
-		pr_info("sect=%ld type=%x flags=%x\n",
-			(long)blk_rq_pos(current_req), current_req->cmd_type,
-			current_req->cmd_flags);
+	if (WARN(atomic_read(&usage_count) == 0,
+		 "warning: usage count=0, current_req=%p sect=%ld type=%x flags=%x\n",
+		 current_req, (long)blk_rq_pos(current_req), current_req->cmd_type,
+		 current_req->cmd_flags))
 		return;
-	}
+
 	if (test_bit(0, &fdc_busy)) {
 		/* fdc busy, this new request will be treated when the
 		   current one is done */
@@ -3817,10 +3812,10 @@ static int floppy_revalidate(struct gend
 	if (test_bit(FD_DISK_CHANGED_BIT, &UDRS->flags) ||
 	    test_bit(FD_VERIFY_BIT, &UDRS->flags) ||
 	    test_bit(drive, &fake_change) || NO_GEOM) {
-		if (atomic_read(&usage_count) == 0) {
-			pr_info("VFS: revalidate called on non-open device.\n");
+		if (WARN(atomic_read(&usage_count) == 0,
+			 "VFS: revalidate called on non-open device.\n"))
 			return -EFAULT;
-		}
+
 		lock_fdc(drive, false);
 		cf = (test_bit(FD_DISK_CHANGED_BIT, &UDRS->flags) ||
 		      test_bit(FD_VERIFY_BIT, &UDRS->flags));
_

Patches currently in -mm which might be from shemminger@vyatta.com are

linux-next.patch
floppy-initialize-debug-jiffies-offset.patch
floppy-remove-unnecessary-inlines.patch
floppy-silence-warning-during-disk-test.patch
floppy-use-atomic-type-for-usage_count.patch
floppy-cmos-attribute-should-be-static.patch
floppy-fix-signed-unsigned-warnings.patch
floppy-use-wait_event_interruptible.patch
floppy-use-warning-macros.patch
floppy-make-controller-const.patch

