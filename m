From: akpm@linux-foundation.org
Subject: - dm-crypt-disable-barriers.patch removed from -mm tree
Date: Wed, 09 May 2007 14:48:29 -0700
Message-ID: <200705092148.l49LmT01002593@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:59922 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759360AbXEIVs6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 May 2007 17:48:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mbroz@redhat.com, agk@redhat.com, jens.axboe@oracle.com, mm-commits@vger.kernel.org


The patch titled
     dm crypt: disable barriers
has been removed from the -mm tree.  Its filename was
     dm-crypt-disable-barriers.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
 1 file changed, 3 insertions(+)

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

origin.patch
