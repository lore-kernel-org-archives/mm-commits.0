From: akpm@linux-foundation.org
Subject: - md-lock-address-when-changing-attributes-of-component-devices.patch removed from -mm tree
Date: Wed, 06 Feb 2008 16:29:57 -0800
Message-ID: <200802070029.m170TcHc007296@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46175 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932803AbYBGAnK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Feb 2008 19:43:10 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: neilb@suse.de, mm-commits@vger.kernel.org


The patch titled
     md: lock address when changing attributes of component devices
has been removed from the -mm tree.  Its filename was
     md-lock-address-when-changing-attributes-of-component-devices.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

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
@@ -2075,12 +2075,18 @@ rdev_attr_store(struct kobject *kobj, st
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
