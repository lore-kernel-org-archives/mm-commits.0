From: akpm@linux-foundation.org
Subject: - dm-io-delay-dec_count.patch removed from -mm tree
Date: Wed, 09 May 2007 14:48:52 -0700
Message-ID: <200705092148.l49LmqfP002637@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:35164 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758133AbXEIVtA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 May 2007 17:49:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hjm@redhat.com, agk@redhat.com, mbroz@redhat.com, mm-commits@vger.kernel.org


The patch titled
     dm io: delay dec_count
has been removed from the -mm tree.  Its filename was
     dm-io-delay-dec_count.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: dm io: delay dec_count
From: Heinz Mauelshagen <hjm@redhat.com>

Delay decrementing the 'struct io' reference count until after the bio has
been freed so that a bio destructor function may reference it.  Required by a
later patch.

Signed-off-by: Heinz Mauelshagen <hjm@redhat.com>
Signed-off-by: Alasdair G Kergon <agk@redhat.com>
Cc: Milan Broz <mbroz@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/md/dm-io.c |   12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff -puN drivers/md/dm-io.c~dm-io-delay-dec_count drivers/md/dm-io.c
--- a/drivers/md/dm-io.c~dm-io-delay-dec_count
+++ a/drivers/md/dm-io.c
@@ -126,7 +126,8 @@ static void dec_count(struct io *io, uns
 
 static int endio(struct bio *bio, unsigned int done, int error)
 {
-	struct io *io = (struct io *) bio->bi_private;
+	struct io *io;
+	unsigned region;
 
 	/* keep going until we've finished */
 	if (bio->bi_size)
@@ -135,10 +136,17 @@ static int endio(struct bio *bio, unsign
 	if (error && bio_data_dir(bio) == READ)
 		zero_fill_bio(bio);
 
-	dec_count(io, bio_get_region(bio), error);
+	/*
+	 * The bio destructor in bio_put() may use the io object.
+	 */
+	io = bio->bi_private;
+	region = bio_get_region(bio);
+
 	bio->bi_max_vecs++;
 	bio_put(bio);
 
+	dec_count(io, region, error);
+
 	return 0;
 }
 
_

Patches currently in -mm which might be from hjm@redhat.com are

origin.patch
