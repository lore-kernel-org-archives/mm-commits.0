From: akpm@linux-foundation.org
Subject: + md-guard-against-possible-bad-array-geometry-in-v1-metadata.patch added to -mm tree
Date: Mon, 03 Mar 2008 00:23:32 -0800
Message-ID: <200803030823.m238NWW9006513@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36471 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751939AbYCCIYI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 3 Mar 2008 03:24:08 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: neilb@suse.de


The patch titled
     md: guard against possible bad array geometry in v1 metadata
has been added to the -mm tree.  Its filename is
     md-guard-against-possible-bad-array-geometry-in-v1-metadata.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
md-fix-deadlock-in-md-raid1-and-md-raid10-when-handling-a-read-error.patch
md-reduce-cpu-wastage-on-idle-md-array-with-a-write-intent-bitmap.patch
md-guard-against-possible-bad-array-geometry-in-v1-metadata.patch
md-clean-up-irregularity-with-raid-autodetect.patch
md-make-sure-a-reshape-is-started-when-device-switches-to-read-write.patch
md-lock-access-to-rdev-attributes-properly.patch
md-dont-attempt-read-balancing-for-raid10-far-layouts.patch
md-fix-possible-raid1-raid10-deadlock-on-read-error-during-resync.patch
md-the-md-raid10-resync-thread-could-cause-a-md-raid10-array-deadlock.patch
md-fix-integer-as-null-pointer-warnings-in-mdc.patch

