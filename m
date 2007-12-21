From: akpm@linux-foundation.org
Subject: + md-allow-an-md-array-to-appear-with-0-drives-if-it-has-external-metadata.patch added to -mm tree
Date: Fri, 21 Dec 2007 00:42:59 -0800
Message-ID: <200712210842.lBL8gxiL005290@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60843 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752238AbXLUInD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 21 Dec 2007 03:43:03 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: neilb@suse.de


The patch titled
     md: allow an md array to appear with 0 drives if it has external metadata
has been added to the -mm tree.  Its filename is
     md-allow-an-md-array-to-appear-with-0-drives-if-it-has-external-metadata.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: md: allow an md array to appear with 0 drives if it has external metadata
From: NeilBrown <neilb@suse.de>

Signed-off-by: Neil Brown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/md/md.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff -puN drivers/md/md.c~md-allow-an-md-array-to-appear-with-0-drives-if-it-has-external-metadata drivers/md/md.c
--- a/drivers/md/md.c~md-allow-an-md-array-to-appear-with-0-drives-if-it-has-external-metadata
+++ a/drivers/md/md.c
@@ -4647,9 +4647,10 @@ static int md_ioctl(struct inode *inode,
 	 */
 	/* if we are not initialised yet, only ADD_NEW_DISK, STOP_ARRAY,
 	 * RUN_ARRAY, and GET_ and SET_BITMAP_FILE are allowed */
-	if (!mddev->raid_disks && cmd != ADD_NEW_DISK && cmd != STOP_ARRAY
-			&& cmd != RUN_ARRAY && cmd != SET_BITMAP_FILE
-	    		&& cmd != GET_BITMAP_FILE) {
+	if ((!mddev->raid_disks && !mddev->external)
+	    && cmd != ADD_NEW_DISK && cmd != STOP_ARRAY
+	    && cmd != RUN_ARRAY && cmd != SET_BITMAP_FILE
+	    && cmd != GET_BITMAP_FILE) {
 		err = -ENODEV;
 		goto abort_unlock;
 	}
_

Patches currently in -mm which might be from neilb@suse.de are

origin.patch
git-nfsd.patch
coding-style-cleanups-for-drivers-md-mktablesc.patch
md-raid6-fix-mktablec.patch
md-raid6-clean-up-the-style-of-raid6test-testc.patch
md-update-md-bitmap-during-resync.patch
md-update-md-bitmap-during-resync-fix.patch
md-support-external-metadata-for-md-arrays.patch
md-give-userspace-control-over-removing-failed-devices-when-external-metdata-in-use.patch
md-allow-a-maximum-extent-to-be-set-for-resyncing.patch
md-allow-devices-to-be-shared-between-md-arrays.patch
md-lock-address-when-changing-attributes-of-component-devices.patch
md-allow-an-md-array-to-appear-with-0-drives-if-it-has-external-metadata.patch
md-get-name-for-block-device-in-sysfs.patch
one-less-parameter-to-__d_path.patch
d_path-kerneldoc-cleanup.patch
d_path-use-struct-path-in-struct-avc_audit_data.patch
d_path-make-proc_get_link-use-a-struct-path-argument.patch
d_path-make-get_dcookie-use-a-struct-path-argument.patch
use-struct-path-in-struct-svc_export.patch
use-struct-path-in-struct-svc_export-checkpatch-fixes.patch
use-struct-path-in-struct-svc_expkey.patch
d_path-make-seq_path-use-a-struct-path-argument.patch
d_path-make-d_path-use-a-struct-path.patch
