From: akpm@linux-foundation.org
Subject: + md-fix-bug-in-error-handling-during-raid1-repair.patch added to -mm tree
Date: Mon, 11 Jun 2007 18:17:23 -0700
Message-ID: <200706120117.l5C1HNN5001117@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36283 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753504AbXFLBRl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 11 Jun 2007 21:17:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: maccetta@laurelnetworks.com, neilb@suse.de, stable@kernel.org


The patch titled
     md: fix bug in error handling during raid1 repair
has been added to the -mm tree.  Its filename is
     md-fix-bug-in-error-handling-during-raid1-repair.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: md: fix bug in error handling during raid1 repair
From: Mike Accetta <maccetta@laurelnetworks.com>

If raid1/repair (which reads all block and fixes any differences it finds)
hits a read error, it doesn't reset the bio for writing before writing
correct data back, so the read error isn't fixed, and the device probably
gets a zero-length write which it might complain about.

Signed-off-by: Neil Brown <neilb@suse.de>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/md/raid1.c |   21 ++++++++++++++-------
 1 file changed, 14 insertions(+), 7 deletions(-)

diff -puN drivers/md/raid1.c~md-fix-bug-in-error-handling-during-raid1-repair drivers/md/raid1.c
--- a/drivers/md/raid1.c~md-fix-bug-in-error-handling-during-raid1-repair
+++ a/drivers/md/raid1.c
@@ -1240,17 +1240,24 @@ static void sync_request_write(mddev_t *
 			}
 		r1_bio->read_disk = primary;
 		for (i=0; i<mddev->raid_disks; i++)
-			if (r1_bio->bios[i]->bi_end_io == end_sync_read &&
-			    test_bit(BIO_UPTODATE, &r1_bio->bios[i]->bi_flags)) {
+			if (r1_bio->bios[i]->bi_end_io == end_sync_read) {
 				int j;
 				int vcnt = r1_bio->sectors >> (PAGE_SHIFT- 9);
 				struct bio *pbio = r1_bio->bios[primary];
 				struct bio *sbio = r1_bio->bios[i];
-				for (j = vcnt; j-- ; )
-					if (memcmp(page_address(pbio->bi_io_vec[j].bv_page),
-						   page_address(sbio->bi_io_vec[j].bv_page),
-						   PAGE_SIZE))
-						break;
+
+				if (test_bit(BIO_UPTODATE, &sbio->bi_flags)) {
+					for (j = vcnt; j-- ; ) {
+						struct page *p, *s;
+						p = pbio->bi_io_vec[j].bv_page;
+						s = sbio->bi_io_vec[j].bv_page;
+						if (memcmp(page_address(p),
+							   page_address(s),
+							   PAGE_SIZE))
+							break;
+					}
+				} else
+					j = 0;
 				if (j >= 0)
 					mddev->resync_mismatches += r1_bio->sectors;
 				if (j < 0 || test_bit(MD_RECOVERY_CHECK, &mddev->recovery)) {
_

Patches currently in -mm which might be from maccetta@laurelnetworks.com are

md-fix-bug-in-error-handling-during-raid1-repair.patch
