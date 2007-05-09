From: akpm@linux-foundation.org
Subject: + dm-io-delay-dec_count.patch added to -mm tree
Date: Tue, 08 May 2007 17:54:56 -0700
Message-ID: <200705090054.l490suHa006397@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:57043 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S968399AbXEIAzF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 20:55:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hjm@redhat.com, agk@redhat.com, mbroz@redhat.com


The patch titled
     dm io: delay dec_count
has been added to the -mm tree.  Its filename is
     dm-io-delay-dec_count.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
 1 files changed, 10 insertions(+), 2 deletions(-)

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

dm-io-delay-dec_count.patch
dm-io-prepare-for-new-interface.patch
dm-io-new-interface.patch
dm-kcopyd-update-dm-io-interface.patch
dm-exception-store-update-dm-io-interface.patch
dm-bio-list-helpers.patch
