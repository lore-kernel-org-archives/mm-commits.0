From: akpm@linux-foundation.org
Subject: + loop-zero-fill-bio-instead-of-return-eio-for-partial-read.patch added to -mm tree
Date: Mon, 30 Jan 2012 16:01:00 -0800
Message-ID: <20120131000100.DF1B9A02E6@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yx0-f202.google.com ([209.85.213.202]:57523 "EHLO
	mail-yx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752526Ab2AaABG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 30 Jan 2012 19:01:06 -0500
Received: by yenr8 with SMTP id r8so459654yen.1
        for <mm-commits@vger.kernel.org>; Mon, 30 Jan 2012 16:01:06 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dyoung@redhat.com, axboe@kernel.dk, dmonakhov@sw.ru, jmoyer@redhat.com


The patch titled
     Subject: loop: zero fill bio instead of return -EIO for partial read
has been added to the -mm tree.  Its filename is
     loop-zero-fill-bio-instead-of-return-eio-for-partial-read.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Dave Young <dyoung@redhat.com>
Subject: loop: zero fill bio instead of return -EIO for partial read

commit 8268f5a741 ("deny partial write for loop dev fd") tried to fix the
loop device partial read information leak problem.  But it changed the
semantics of read behavior.  When we read beyond the end of the device we
should get 0 bytes, which is normal behavior, we should not just return
-EIO

Instead of returning -EIO, zero out the bio to avoid information leak in
case of partail read.

Signed-off-by: Dave Young <dyoung@redhat.com>
Reviewed-by: Jeff Moyer <jmoyer@redhat.com>
Cc: Dmitry Monakhov <dmonakhov@sw.ru>
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/loop.c |   24 +++++++++++++-----------
 1 file changed, 13 insertions(+), 11 deletions(-)

diff -puN drivers/block/loop.c~loop-zero-fill-bio-instead-of-return-eio-for-partial-read drivers/block/loop.c
--- a/drivers/block/loop.c~loop-zero-fill-bio-instead-of-return-eio-for-partial-read
+++ a/drivers/block/loop.c
@@ -356,14 +356,14 @@ lo_direct_splice_actor(struct pipe_inode
 	return __splice_from_pipe(pipe, sd, lo_splice_actor);
 }
 
-static int
+static ssize_t
 do_lo_receive(struct loop_device *lo,
 	      struct bio_vec *bvec, int bsize, loff_t pos)
 {
 	struct lo_read_data cookie;
 	struct splice_desc sd;
 	struct file *file;
-	long retval;
+	ssize_t retval;
 
 	cookie.lo = lo;
 	cookie.page = bvec->bv_page;
@@ -379,26 +379,28 @@ do_lo_receive(struct loop_device *lo,
 	file = lo->lo_backing_file;
 	retval = splice_direct_to_actor(file, &sd, lo_direct_splice_actor);
 
-	if (retval < 0)
-		return retval;
-	if (retval != bvec->bv_len)
-		return -EIO;
-	return 0;
+	return retval;
 }
 
 static int
 lo_receive(struct loop_device *lo, struct bio *bio, int bsize, loff_t pos)
 {
 	struct bio_vec *bvec;
-	int i, ret = 0;
+	ssize_t s;
+	int i;
 
 	bio_for_each_segment(bvec, bio, i) {
-		ret = do_lo_receive(lo, bvec, bsize, pos);
-		if (ret < 0)
+		s = do_lo_receive(lo, bvec, bsize, pos);
+		if (s < 0)
+			return s;
+
+		if (s != bvec->bv_len) {
+			zero_fill_bio(bio);
 			break;
+		}
 		pos += bvec->bv_len;
 	}
-	return ret;
+	return 0;
 }
 
 static int do_bio_filebacked(struct loop_device *lo, struct bio *bio)
_
Subject: Subject: loop: zero fill bio instead of return -EIO for partial read

Patches currently in -mm which might be from dyoung@redhat.com are

lkdtm-avoid-calling-lkdtm_do_action-with-spin-lock-held.patch
loop-zero-fill-bio-instead-of-return-eio-for-partial-read.patch

