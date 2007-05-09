From: akpm@linux-foundation.org
Subject: + dm-crypt-disable-barriers.patch added to -mm tree
Date: Tue, 08 May 2007 17:54:34 -0700
Message-ID: <200705090054.l490sYVX006355@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:36597 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934594AbXEIAyt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 20:54:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mbroz@redhat.com, agk@redhat.com, jens.axboe@oracle.com


The patch titled
     dm crypt: disable barriers
has been added to the -mm tree.  Its filename is
     dm-crypt-disable-barriers.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: dm crypt: disable barriers
From: Milan Broz <mbroz@redhat.com>

Disable barriers in dm-crypt because of current workqueue processing can
reorder requests.

This must be addresed later but for now disabling barriers is needed to
prevent data corruption.

Signed-off-by: Milan Broz <mbroz@redhat.com>
Signed-off-by: Alasdair G Kergon <agk@redhat.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/md/dm-crypt.c |    3 +++
 1 files changed, 3 insertions(+)

diff -puN drivers/md/dm-crypt.c~dm-crypt-disable-barriers drivers/md/dm-crypt.c
--- a/drivers/md/dm-crypt.c~dm-crypt-disable-barriers
+++ a/drivers/md/dm-crypt.c
@@ -954,6 +954,9 @@ static int crypt_map(struct dm_target *t
 	struct crypt_config *cc = ti->private;
 	struct crypt_io *io;
 
+	if (bio_barrier(bio))
+		return -EOPNOTSUPP;
+
 	io = mempool_alloc(cc->io_pool, GFP_NOIO);
 	io->target = ti;
 	io->base_bio = bio;
_

Patches currently in -mm which might be from mbroz@redhat.com are

dm-crypt-disable-barriers.patch
dm-io-delay-dec_count.patch
dm-io-prepare-for-new-interface.patch
dm-io-new-interface.patch
dm-kcopyd-update-dm-io-interface.patch
dm-exception-store-update-dm-io-interface.patch
dm-log-update-dm-io-interface.patch
dm-raid1-update-dm-io-interface.patch
dm-io-remove-old-interface.patch
dm-bio-list-helpers.patch
dm-delay-target.patch
