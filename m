From: akpm@linux-foundation.org
Subject: + bio-dont-overflow-in-bio_get_nr_vecs.patch added to -mm tree
Date: Thu, 26 Jan 2012 16:07:02 -0800
Message-ID: <20120127000702.C0780A026F@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yw0-f74.google.com ([209.85.213.74]:61530 "EHLO
	mail-yw0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754350Ab2A0AHD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 26 Jan 2012 19:07:03 -0500
Received: by yhjj52 with SMTP id j52so121874yhj.1
        for <mm-commits@vger.kernel.org>; Thu, 26 Jan 2012 16:07:03 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kent.overstreet@gmail.com, Valdis.Kletnieks@vt.edu, axboe@kernel.dk, koverstreet@google.com, tj@kernel.org


The patch titled
     Subject: bio: don't overflow in bio_get_nr_vecs()
has been added to the -mm tree.  Its filename is
     bio-dont-overflow-in-bio_get_nr_vecs.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Cc: Valdis Kletnieks <Valdis.Kletnieks@vt.edu>
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
