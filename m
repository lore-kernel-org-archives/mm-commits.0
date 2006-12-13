From: akpm@osdl.org
Subject: - md-enable-bypassing-cache-for-reads.patch removed from -mm tree
Date: Tue, 12 Dec 2006 22:54:56 -0800
Message-ID: <200612130654.kBD6suRs030588@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:57699 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965018AbWLMGzA (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 13 Dec 2006 01:55:00 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: raziebe@gmail.com, neilb@suse.de, mm-commits@vger.kernel.org


The patch titled
     md: enable bypassing cache for reads
has been removed from the -mm tree.  Its filename was
     md-enable-bypassing-cache-for-reads.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: md: enable bypassing cache for reads
From: "Raz Ben-Jehuda(caro)" <raziebe@gmail.com>

Call the chunk_aligned_read where appropriate.

Signed-off-by: Neil Brown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/md/raid5.c |    5 +++++
 1 file changed, 5 insertions(+)

diff -puN drivers/md/raid5.c~md-enable-bypassing-cache-for-reads drivers/md/raid5.c
--- a/drivers/md/raid5.c~md-enable-bypassing-cache-for-reads
+++ a/drivers/md/raid5.c
@@ -2808,6 +2808,11 @@ static int make_request(request_queue_t 
 	disk_stat_inc(mddev->gendisk, ios[rw]);
 	disk_stat_add(mddev->gendisk, sectors[rw], bio_sectors(bi));
 
+	if (bio_data_dir(bi) == READ &&
+	     mddev->reshape_position == MaxSector &&
+	     chunk_aligned_read(q,bi))
+            	return 0;
+
 	logical_sector = bi->bi_sector & ~((sector_t)STRIPE_SECTORS-1);
 	last_sector = bi->bi_sector + (bi->bi_size>>9);
 	bi->bi_next = NULL;
_

Patches currently in -mm which might be from raziebe@gmail.com are

origin.patch
md-dont-assume-that-read==0-and-write==1-use-the-names-explicitly.patch

