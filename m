From: akpm@linux-foundation.org
Subject: + md-lock-address-when-changing-attributes-of-component-devices.patch added to -mm tree
Date: Fri, 21 Dec 2007 00:42:51 -0800
Message-ID: <200712210842.lBL8gpi4005284@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43210 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751651AbXLUIm4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 21 Dec 2007 03:42:56 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: neilb@suse.de


The patch titled
     md: lock address when changing attributes of component devices
has been added to the -mm tree.  Its filename is
     md-lock-address-when-changing-attributes-of-component-devices.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: md: lock address when changing attributes of component devices
From: NeilBrown <neilb@suse.de>

Signed-off-by: Neil Brown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/md/md.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff -puN drivers/md/md.c~md-lock-address-when-changing-attributes-of-component-devices drivers/md/md.c
--- a/drivers/md/md.c~md-lock-address-when-changing-attributes-of-component-devices
+++ a/drivers/md/md.c
@@ -2077,12 +2077,18 @@ rdev_attr_store(struct kobject *kobj, st
 {
 	struct rdev_sysfs_entry *entry = container_of(attr, struct rdev_sysfs_entry, attr);
 	mdk_rdev_t *rdev = container_of(kobj, mdk_rdev_t, kobj);
+	int rv;
 
 	if (!entry->store)
 		return -EIO;
 	if (!capable(CAP_SYS_ADMIN))
 		return -EACCES;
-	return entry->store(rdev, page, length);
+	rv = mddev_lock(rdev->mddev);
+	if (!rv) {
+		rv = entry->store(rdev, page, length);
+		mddev_unlock(rdev->mddev);
+	}
+	return rv;
 }
 
 static void rdev_free(struct kobject *ko)
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
