From: akpm@linux-foundation.org
Subject: - md-allow-an-md-array-to-appear-with-0-drives-if-it-has-external-metadata.patch removed from -mm tree
Date: Wed, 06 Feb 2008 16:29:59 -0800
Message-ID: <200802070029.m170Tefr007301@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34902 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934982AbYBGAn1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Feb 2008 19:43:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: neilb@suse.de, mm-commits@vger.kernel.org


The patch titled
     md: allow an md array to appear with 0 drives if it has external metadata
has been removed from the -mm tree.  Its filename was
     md-allow-an-md-array-to-appear-with-0-drives-if-it-has-external-metadata.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

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
d_path-make-d_path-use-a-struct-path-fix.patch
