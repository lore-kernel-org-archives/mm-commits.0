From: akpm@linux-foundation.org
Subject: [merged] bio-dont-overflow-in-bio_get_nr_vecs.patch removed from -mm tree
Date: Mon, 13 Feb 2012 13:12:40 -0800
Message-ID: <20120213211241.9E0E7A02E6@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qw0-f74.google.com ([209.85.216.74]:43432 "EHLO
	mail-qw0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755901Ab2BMVMo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 13 Feb 2012 16:12:44 -0500
Received: by qadb12 with SMTP id b12so731294qad.1
        for <mm-commits@vger.kernel.org>; Mon, 13 Feb 2012 13:12:43 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kent.overstreet@gmail.com, Valdis.Kletnieks@vt.edu, axboe@kernel.dk, koverstreet@google.com, tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: bio: don't overflow in bio_get_nr_vecs()
has been removed from the -mm tree.  Its filename was
     bio-dont-overflow-in-bio_get_nr_vecs.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Kent Overstreet <kent.overstreet@gmail.com>
Subject: bio: don't overflow in bio_get_nr_vecs()

There were two places bio_get_nr_vecs() could overflow:

First, it did a left shift to convert from sectors to bytes immediately
before dividing by PAGE_SIZE.  If PAGE_SIZE ever was less than 512 a great
many things would break, so dividing by PAGE_SIZE >> 9 is safe and will
generate smaller code too.

The nastier overflow was in the DIV_ROUND_UP() (that's what the code was
effectively doing, anyways).  If n + d overflowed, the whole thing would
return 0 which breaks things rather effectively.

bio_get_nr_vecs() doesn't claim to give an exact value anyways, so the
DIV_ROUND_UP() is silly; we could do a straight divide except if a
device's queue_max_sectors was less than PAGE_SIZE we'd return 0.  So we
just add 1; this should always be safe - things will break badly if
bio_get_nr_vecs() returns > BIO_MAX_PAGES (bio_alloc() will suddenly start
failing) but it's queue_max_segments that must guard against this, if
queue_max_sectors is preventing this from happen things are going to
explode on architectures with different PAGE_SIZE.

Signed-off-by: Kent Overstreet <koverstreet@google.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Tejun Heo <tj@kernel.org>
Acked-by: Valdis Kletnieks <Valdis.Kletnieks@vt.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/bio.c |   10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff -puN fs/bio.c~bio-dont-overflow-in-bio_get_nr_vecs fs/bio.c
--- a/fs/bio.c~bio-dont-overflow-in-bio_get_nr_vecs
+++ a/fs/bio.c
@@ -505,13 +505,9 @@ EXPORT_SYMBOL(bio_clone);
 int bio_get_nr_vecs(struct block_device *bdev)
 {
 	struct request_queue *q = bdev_get_queue(bdev);
-	int nr_pages;
-
-	nr_pages = ((queue_max_sectors(q) << 9) + PAGE_SIZE - 1) >> PAGE_SHIFT;
-	if (nr_pages > queue_max_segments(q))
-		nr_pages = queue_max_segments(q);
