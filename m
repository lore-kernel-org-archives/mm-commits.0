From: akpm@linux-foundation.org
Subject: [alternative-merged] drm-replace-drm_copy-macro-w-a-function.patch removed from -mm tree
Date: Thu, 19 Nov 2009 13:22:24 -0800
Message-ID: <200911192122.nAJLMOFr024933@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59647 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754026AbZKSVWn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Nov 2009 16:22:43 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dilinger@collabora.co.uk, airlied@linux.ie, mm-commits@vger.kernel.org


The patch titled
     drm: replace DRM_COPY macro w/ a function
has been removed from the -mm tree.  Its filename was
     drm-replace-drm_copy-macro-w-a-function.patch

This patch was dropped because an alternative patch was merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drm: replace DRM_COPY macro w/ a function
From: Andres Salomon <dilinger@collabora.co.uk>

Don't inline it; the compiler can figure it out.  Comments added that are
based upon my interpretation of the code.  Hopefully they're correct. :)

Signed-off-by: Andres Salomon <dilinger@collabora.co.uk>
Cc: Dave Airlie <airlied@linux.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpu/drm/drm_drv.c |   34 ++++++++++++++++++++++------------
 1 file changed, 22 insertions(+), 12 deletions(-)

diff -puN drivers/gpu/drm/drm_drv.c~drm-replace-drm_copy-macro-w-a-function drivers/gpu/drm/drm_drv.c
--- a/drivers/gpu/drm/drm_drv.c~drm-replace-drm_copy-macro-w-a-function
+++ a/drivers/gpu/drm/drm_drv.c
@@ -368,14 +368,25 @@ module_exit(drm_core_exit);
 /**
  * Copy and IOCTL return string to user space
  */
-#define DRM_COPY(name, value)                                         \
-	len = strlen(value);                                          \
-	if (len > name##_len) len = name##_len;                       \
-	name##_len = strlen(value);                                   \
-	if (len && name) {                                            \
-		if (copy_to_user(name, value, len))                   \
-			return -EFAULT;                               \
-	}
+static int drm_copy_field(char *buf, size_t *buf_len, const char *value)
+{
+	int len;
+
+	/* don't overflow userbuf */
+	len = strlen(value);
+	if (len > *buf_len)
+		len = *buf_len;
+
+	/* let userspace know exact length of driver value (which could be
+	 * larger than the userspace-supplied buffer) */
+	*buf_len = strlen(value);
+
+	/* finally, try filling in the userbuf */
+	if (len && buf)
+		if (copy_to_user(buf, value, len))
+			return -EFAULT;
+	return 0;
+}
 
 /**
  * Get version information
@@ -392,14 +403,13 @@ static int drm_version(struct drm_device
 		       struct drm_file *file_priv)
 {
 	struct drm_version *version = data;
-	int len;
 
 	version->version_major = dev->driver->major;
 	version->version_minor = dev->driver->minor;
 	version->version_patchlevel = dev->driver->patchlevel;
-	DRM_COPY(version->name, dev->driver->name);
-	DRM_COPY(version->date, dev->driver->date);
-	DRM_COPY(version->desc, dev->driver->desc);
+	drm_copy_field(version->name, &version->name_len, dev->driver->name);
+	drm_copy_field(version->date, &version->date_len, dev->driver->date);
+	drm_copy_field(version->desc, &version->desc_len, dev->driver->desc);
 
 	return 0;
 }
_

Patches currently in -mm which might be from dilinger@collabora.co.uk are

linux-next.patch
drm-replace-drm_copy-macro-w-a-function.patch
drm-check-return-values-in-drm_version.patch
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

