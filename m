From: akpm@linux-foundation.org
Subject: [merged] loop-zero-fill-bio-instead-of-return-eio-for-partial-read.patch removed from -mm tree
Date: Mon, 13 Feb 2012 13:12:44 -0800
Message-ID: <20120213211244.7783AA02E6@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qw0-f74.google.com ([209.85.216.74]:43432 "EHLO
	mail-qw0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755901Ab2BMVMp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 13 Feb 2012 16:12:45 -0500
Received: by mail-qw0-f74.google.com with SMTP id b12so731294qad.1
        for <mm-commits@vger.kernel.org>; Mon, 13 Feb 2012 13:12:44 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dyoung@redhat.com, axboe@kernel.dk, dmonakhov@sw.ru, jmoyer@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: loop: zero fill bio instead of return -EIO for partial read
has been removed from the -mm tree.  Its filename was
     loop-zero-fill-bio-instead-of-return-eio-for-partial-read.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

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
Tested-by: Jeff Moyer <jmoyer@redhat.com>
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

Patches currently in -mm which might be from dyoung@redhat.com are

origin.patch
linux-next.patch
selftests-launch-individual-selftests-from-the-main-makefile.patch
move-page-typesc-from-documentation-to-tools-vm.patch
move-slabinfoc-to-tools-vm.patch
move-hugepage-test-examples-to-tools-testing-selftests-vm.patch
move-hugepage-test-examples-to-tools-testing-selftests-vm-fix.patch

