From: akpm@osdl.org
Subject: - drm-fix-return-value-check.patch removed from -mm tree
Date: Tue, 12 Dec 2006 22:56:32 -0800
Message-ID: <200612130656.kBD6uWTg030734@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:57962 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965045AbWLMG4g (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 13 Dec 2006 01:56:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akinobu.mita@gmail.com, airlied@linux.ie, mm-commits@vger.kernel.org


The patch titled
     drm: fix return value check
has been removed from the -mm tree.  Its filename was
     drm-fix-return-value-check.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: drm: fix return value check
From: Akinobu Mita <akinobu.mita@gmail.com>

class_create() and class_device_create() return error code as a pointer on
failure.  These return values need to be checked by IS_ERR().

Cc: David Airlie <airlied@linux.ie>
Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/char/drm/drm_sysfs.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN drivers/char/drm/drm_sysfs.c~drm-fix-return-value-check drivers/char/drm/drm_sysfs.c
--- a/drivers/char/drm/drm_sysfs.c~drm-fix-return-value-check
+++ a/drivers/char/drm/drm_sysfs.c
@@ -45,8 +45,8 @@ struct class *drm_sysfs_create(struct mo
 	int err;
 
 	class = class_create(owner, name);
-	if (!class) {
-		err = -ENOMEM;
+	if (IS_ERR(class)) {
+		err = PTR_ERR(class);
 		goto err_out;
 	}
 
@@ -113,8 +113,8 @@ struct class_device *drm_sysfs_device_ad
 					MKDEV(DRM_MAJOR, head->minor),
 					&(head->dev->pdev)->dev,
 					"card%d", head->minor);
-	if (!class_dev) {
-		err = -ENOMEM;
+	if (IS_ERR(class_dev)) {
+		err = PTR_ERR(class_dev);
 		goto err_out;
 	}
 
_

Patches currently in -mm which might be from akinobu.mita@gmail.com are

origin.patch
acpi-fix-single-linked-list-manipulation.patch
acpi-processor-prevent-loading-module-on-failures.patch
git-alsa.patch
audit-fix-kstrdup-error-check.patch
git-drm.patch
ata-fix-platform_device_register_simple-error-check.patch
git-mtd.patch
net-use-bitrev8.patch
gss_spkm3-fix-error-handling-in-module-init.patch
auth_gss-unregister-gss_domain-when-unloading-module.patch
iscsi-fix-crypto_alloc_hash-error-check.patch

