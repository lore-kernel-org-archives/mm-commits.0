From: akpm@linux-foundation.org
Subject: + md-change-a-few-int-to-size_t-in-md.patch added to -mm tree
Date: Sun, 13 Jan 2008 17:59:39 -0800
Message-ID: <200801140159.m0E1xJbZ006872@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40279 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753446AbYANB7Y (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 13 Jan 2008 20:59:24 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: neilb@suse.de


The patch titled
     md: change a few 'int' to 'size_t' in md
has been added to the -mm tree.  Its filename is
     md-change-a-few-int-to-size_t-in-md.patch

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
@@ -1802,7 +1802,7 @@ static ssize_t
 state_show(mdk_rdev_t *rdev, char *page)
 {
 	char *sep = "";
-	int len=0;
+	size_t len = 0;
 
 	if (test_bit(Faulty, &rdev->flags)) {
 		len+= sprintf(page+len, "%sfaulty",sep);
@@ -2320,7 +2320,7 @@ level_show(mddev_t *mddev, char *page)
 static ssize_t
 level_store(mddev_t *mddev, const char *buf, size_t len)
 {
-	int rv = len;
+	ssize_t rv = len;
 	if (mddev->pers)
 		return -EBUSY;
 	if (len == 0)
@@ -2807,7 +2807,7 @@ metadata_store(mddev_t *mddev, const cha
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
md-fix-an-occasional-deadlock-in-raid5.patch
md-fix-use-after-free-bug-when-dropping-an-rdev-from-an-md-array.patch
md-change-a-few-int-to-size_t-in-md.patch
md-change-interate_mddev-to-for_each_mddev.patch
md-change-iterate_rdev-to-rdev_for_each.patch
md-change-iterate_rdev_generic-to-rdev_for_each_list-and-remove-iterate_rdev_pending.patch
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
