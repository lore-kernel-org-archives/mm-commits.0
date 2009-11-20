From: akpm@linux-foundation.org
Subject: [merged] drm-check-return-values-in-drm_version.patch removed from -mm tree
Date: Fri, 20 Nov 2009 11:30:54 -0800
Message-ID: <200911201930.nAKJUs04011804@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49127 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753392AbZKTTbX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 20 Nov 2009 14:31:23 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dilinger@collabora.co.uk, airlied@linux.ie, mm-commits@vger.kernel.org


The patch titled
     drm: check return values in drm_version
has been removed from the -mm tree.  Its filename was
     drm-check-return-values-in-drm_version.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drm: check return values in drm_version
From: Andres Salomon <dilinger@collabora.co.uk>

In drm_version, actually check the results from function calls so that
we're not potentially passing garbage back to userspace.

Signed-off-by: Andres Salomon <dilinger@collabora.co.uk>
Cc: Dave Airlie <airlied@linux.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpu/drm/drm_drv.c |   14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff -puN drivers/gpu/drm/drm_drv.c~drm-check-return-values-in-drm_version drivers/gpu/drm/drm_drv.c
--- a/drivers/gpu/drm/drm_drv.c~drm-check-return-values-in-drm_version
+++ a/drivers/gpu/drm/drm_drv.c
@@ -403,15 +403,21 @@ static int drm_version(struct drm_device
 		       struct drm_file *file_priv)
 {
 	struct drm_version *version = data;
+	int err;
 
 	version->version_major = dev->driver->major;
 	version->version_minor = dev->driver->minor;
 	version->version_patchlevel = dev->driver->patchlevel;
-	drm_copy_field(version->name, &version->name_len, dev->driver->name);
-	drm_copy_field(version->date, &version->date_len, dev->driver->date);
-	drm_copy_field(version->desc, &version->desc_len, dev->driver->desc);
+	err = drm_copy_field(version->name, &version->name_len,
+			dev->driver->name);
+	if (!err)
+		err = drm_copy_field(version->date, &version->date_len,
+				dev->driver->date);
+	if (!err)
+		err = drm_copy_field(version->desc, &version->desc_len,
+				dev->driver->desc);
 
-	return 0;
+	return err;
 }
 
 /**
_

Patches currently in -mm which might be from dilinger@collabora.co.uk are

linux-next.patch
cs5535-gpio-add-amd-cs5535-cs5536-gpio-driver-support.patch
cs5535-gpio-request-function-mask-names-added.patch
alsa-cs5535audio-free-olpc-quirks-from-reliance-on-mgeode_lx-cpu-optimization.patch
cs5535-add-a-generic-mfgpt-driver.patch
cs5535-add-a-generic-clock-event-mfgpt-driver.patch
cs5535-move-the-divil-msr-definition-into-linux-cs5535h.patch
cs5535-move-vsa2-checks-into-linux-cs5535h.patch
cs5535-define-lxfb-gxfb-msrs-in-linux-cs5535h.patch
cs5535-drop-the-geode-specific-mfgpt-gpio-code.patch
lxfb-add-copyright-license-info.patch

