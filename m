From: akpm@linux-foundation.org
Subject: [merged] drivers-gpu-drm-drm_sysfsc-sysfs-files-error-handling.patch removed from -mm tree
Date: Thu, 06 May 2010 12:08:48 -0400
Message-ID: <201005061910.o46JAIun008519@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37593 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754263Ab0EFTKZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 6 May 2010 15:10:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: error27@gmail.com, airlied@linux.ie, gregkh@suse.de, mm-commits@vger.kernel.org


The patch titled
     drivers/gpu/drm/drm_sysfs.c: sysfs files error handling
has been removed from the -mm tree.  Its filename was
     drivers-gpu-drm-drm_sysfsc-sysfs-files-error-handling.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/gpu/drm/drm_sysfs.c: sysfs files error handling
From: Dan Carpenter <error27@gmail.com>

In the original code we used "j" as an iterator but we used "i" as an
index.

-               for (j = 0; j < i; j++)
-                       device_remove_file(&connector->kdev,
-                                          &connector_attrs[i]);

Smatch complained about that because "i" was potentially passed the end of
the array.  Which makes sense if we should be using "j" there.

I also thought that we should remove the files for &connector_attrs_opt1
but to do that I had to add separate iterators for &connector_attrs and
&connector_attrs_opt1.

Signed-off-by: Dan Carpenter <error27@gmail.com>
Cc: David Airlie <airlied@linux.ie>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpu/drm/drm_sysfs.c |   21 ++++++++++++---------
 1 file changed, 12 insertions(+), 9 deletions(-)

diff -puN drivers/gpu/drm/drm_sysfs.c~drivers-gpu-drm-drm_sysfsc-sysfs-files-error-handling drivers/gpu/drm/drm_sysfs.c
--- a/drivers/gpu/drm/drm_sysfs.c~drivers-gpu-drm-drm_sysfsc-sysfs-files-error-handling
+++ a/drivers/gpu/drm/drm_sysfs.c
@@ -354,7 +354,10 @@ static struct bin_attribute edid_attr = 
 int drm_sysfs_connector_add(struct drm_connector *connector)
 {
 	struct drm_device *dev = connector->dev;
-	int ret = 0, i, j;
+	int attr_cnt = 0;
+	int opt_cnt = 0;
+	int i;
+	int ret = 0;
 
 	/* We shouldn't get called more than once for the same connector */
 	BUG_ON(device_is_registered(&connector->kdev));
@@ -377,8 +380,8 @@ int drm_sysfs_connector_add(struct drm_c
 
 	/* Standard attributes */
 
-	for (i = 0; i < ARRAY_SIZE(connector_attrs); i++) {
-		ret = device_create_file(&connector->kdev, &connector_attrs[i]);
+	for (attr_cnt = 0; attr_cnt < ARRAY_SIZE(connector_attrs); attr_cnt++) {
+		ret = device_create_file(&connector->kdev, &connector_attrs[attr_cnt]);
 		if (ret)
 			goto err_out_files;
 	}
@@ -394,8 +397,8 @@ int drm_sysfs_connector_add(struct drm_c
 		case DRM_MODE_CONNECTOR_SVIDEO:
 		case DRM_MODE_CONNECTOR_Component:
 		case DRM_MODE_CONNECTOR_TV:
-			for (i = 0; i < ARRAY_SIZE(connector_attrs_opt1); i++) {
-				ret = device_create_file(&connector->kdev, &connector_attrs_opt1[i]);
+			for (opt_cnt = 0; opt_cnt < ARRAY_SIZE(connector_attrs_opt1); opt_cnt++) {
+				ret = device_create_file(&connector->kdev, &connector_attrs_opt1[opt_cnt]);
 				if (ret)
 					goto err_out_files;
 			}
@@ -414,10 +417,10 @@ int drm_sysfs_connector_add(struct drm_c
 	return 0;
 
 err_out_files:
-	if (i > 0)
-		for (j = 0; j < i; j++)
-			device_remove_file(&connector->kdev,
-					   &connector_attrs[i]);
+	for (i = 0; i < opt_cnt; i++)
+		device_remove_file(&connector->kdev, &connector_attrs_opt1[i]);
+	for (i = 0; i < attr_cnt; i++)
+		device_remove_file(&connector->kdev, &connector_attrs[i]);
 	device_unregister(&connector->kdev);
 
 out:
_

Patches currently in -mm which might be from error27@gmail.com are

origin.patch
linux-next.patch
scsi-remove-superfluous-null-pointer-check-from-scsi_kill_request.patch
mm-document-follow_page.patch
dynamic_debug-small-cleanup-in-ddebug_proc_write.patch
sis-strcpy-=-strlcpy.patch
proc-cleanup-remove-unused-assignments.patch
fs-sysv-dereferencing-err_ptr.patch

