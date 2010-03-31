From: akpm@linux-foundation.org
Subject: + drivers-gpu-drm-drm_sysfsc-sysfs-files-error-handling.patch added to -mm tree
Date: Wed, 31 Mar 2010 16:05:17 -0700
Message-ID: <201003312305.o2VN5H2J014254@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60169 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932174Ab0CaXFy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 31 Mar 2010 19:05:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: error27@gmail.com, airlied@linux.ie, gregkh@suse.de


The patch titled
     drivers/gpu/drm/drm_sysfs.c: sysfs files error handling
has been added to the -mm tree.  Its filename is
     drivers-gpu-drm-drm_sysfsc-sysfs-files-error-handling.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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

linux-next.patch
power_meter-acpi_device_class-power_meter_resource-too-long.patch
dpt_i20-several-use-after-free-issues.patch
sbshc-acpi_device_class-smbus_host_controller-too-long.patch
acpi_pad-processor_aggregator-name-too-long.patch
drivers-gpu-drm-via-via_videoc-fix-off-by-one-issue.patch
backlight-backlight_device_register-return-err_ptr.patch
scsi-remove-superfluous-null-pointer-check-from-scsi_kill_request.patch
iscsi-change-to.patch
drbd-potential-null-dereference.patch
musb-potential-use-after-free.patch
dynamic_debug-small-cleanup-in-ddebug_proc_write.patch
sis-strcpy-=-strlcpy.patch
proc-cleanup-remove-unused-assignments.patch
drivers-media-video-au0828-au0828-videoc-off-by-one-bug.patch
drivers-gpu-drm-radeon-radeon_atombiosc-range-check-issues.patch
drivers-gpu-drm-drm_sysfsc-sysfs-files-error-handling.patch
drivers-gpu-drm-drm_memoryc-fix-check-for-end-of-loop.patch
drivers-mfd-pcf50633-corec-off-by-one-issue.patch
drivers-staging-otus-hal-hpanic-using-the-wrong-variable.patch
drivers-staging-comedi-drivers-dt2801c-off-by-one-issue.patch
drivers-media-video-zc0301-zc0301_corec-improve-error-handling.patch
drivers-media-video-et61x251-et61x251_corec-improve-error-handling.patch
drivers-media-video-sn9c102-sn9c102_corec-improve-error-handling.patch

