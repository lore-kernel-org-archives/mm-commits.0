From: akpm@linux-foundation.org
Subject: - md-guard-against-possible-bad-array-geometry-in-v1-metadata.patch removed from -mm tree
Date: Tue, 04 Mar 2008 23:46:25 -0800
Message-ID: <200803050746.m257kPMC021769@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56780 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1764769AbYCEHq3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 5 Mar 2008 02:46:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: neilb@suse.de, mm-commits@vger.kernel.org


The patch titled
     md: guard against possible bad array geometry in v1 metadata
has been removed from the -mm tree.  Its filename was
     md-guard-against-possible-bad-array-geometry-in-v1-metadata.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: md: guard against possible bad array geometry in v1 metadata
From: NeilBrown <neilb@suse.de>

Make sure the data doesn't start before the end of the superblock when the
superblock is at the start of the device.

Signed-off-by: Neil Brown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/md/md.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff -puN drivers/md/md.c~md-guard-against-possible-bad-array-geometry-in-v1-metadata drivers/md/md.c
--- a/drivers/md/md.c~md-guard-against-possible-bad-array-geometry-in-v1-metadata
+++ a/drivers/md/md.c
@@ -1105,7 +1105,11 @@ static int super_1_load(mdk_rdev_t *rdev
 	rdev->sb_size = le32_to_cpu(sb->max_dev) * 2 + 256;
 	bmask = queue_hardsect_size(rdev->bdev->bd_disk->queue)-1;
 	if (rdev->sb_size & bmask)
-		rdev-> sb_size = (rdev->sb_size | bmask)+1;
+		rdev->sb_size = (rdev->sb_size | bmask) + 1;
+
+	if (minor_version
+	    && rdev->data_offset < sb_offset + (rdev->sb_size/512))
+		return -EINVAL;
 
 	if (sb->level == cpu_to_le32(LEVEL_MULTIPATH))
 		rdev->desc_nr = -1;
@@ -1137,7 +1141,7 @@ static int super_1_load(mdk_rdev_t *rdev
 		else
 			ret = 0;
 	}
-	if (minor_version) 
+	if (minor_version)
 		rdev->size = ((rdev->bdev->bd_inode->i_size>>9) - le64_to_cpu(sb->data_offset)) / 2;
 	else
 		rdev->size = rdev->sb_offset;
_

Patches currently in -mm which might be from neilb@suse.de are

git-nfsd.patch
md-fix-integer-as-null-pointer-warnings-in-mdc.patch

