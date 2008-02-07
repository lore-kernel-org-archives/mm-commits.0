From: akpm@linux-foundation.org
Subject: - md-change-a-few-int-to-size_t-in-md.patch removed from -mm tree
Date: Wed, 06 Feb 2008 16:30:03 -0800
Message-ID: <200802070029.m170TiMD007310@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37801 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1764575AbYBGAn2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Feb 2008 19:43:28 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: neilb@suse.de, mm-commits@vger.kernel.org


The patch titled
     md: change a few 'int' to 'size_t' in md
has been removed from the -mm tree.  Its filename was
     md-change-a-few-int-to-size_t-in-md.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: md: change a few 'int' to 'size_t' in md
From: NeilBrown <neilb@suse.de>

As suggested by Andrew Morton.

Signed-off-by: Neil Brown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/md/md.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN drivers/md/md.c~md-change-a-few-int-to-size_t-in-md drivers/md/md.c
--- a/drivers/md/md.c~md-change-a-few-int-to-size_t-in-md
+++ a/drivers/md/md.c
@@ -1800,7 +1800,7 @@ static ssize_t
 state_show(mdk_rdev_t *rdev, char *page)
 {
 	char *sep = "";
-	int len=0;
+	size_t len = 0;
 
 	if (test_bit(Faulty, &rdev->flags)) {
 		len+= sprintf(page+len, "%sfaulty",sep);
@@ -2318,7 +2318,7 @@ level_show(mddev_t *mddev, char *page)
 static ssize_t
 level_store(mddev_t *mddev, const char *buf, size_t len)
 {
-	int rv = len;
+	ssize_t rv = len;
 	if (mddev->pers)
 		return -EBUSY;
 	if (len == 0)
@@ -2805,7 +2805,7 @@ metadata_store(mddev_t *mddev, const cha
 		return len;
 	}
 	if (strncmp(buf, "external:", 9) == 0) {
-		int namelen = len-9;
+		size_t namelen = len-9;
 		if (namelen >= sizeof(mddev->metadata_type))
 			namelen = sizeof(mddev->metadata_type)-1;
 		strncpy(mddev->metadata_type, buf+9, namelen);
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
