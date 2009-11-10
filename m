From: akpm@linux-foundation.org
Subject: + drm-replace-drm_copy-macro-w-a-function.patch added to -mm tree
Date: Tue, 10 Nov 2009 12:32:44 -0800
Message-ID: <200911102032.nAAKWicv007066@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40473 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758082AbZKJUcu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 10 Nov 2009 15:32:50 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dilinger@collabora.co.uk, airlied@linux.ie


The patch titled
     drm: replace DRM_COPY macro w/ a function
has been added to the -mm tree.  Its filename is
     drm-replace-drm_copy-macro-w-a-function.patch

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
Subject: drm: replace DRM_COPY macro w/ a function
From: Andres Salomon <dilinger@collabora.co.uk>

Don't inline it; the compiler can figure it out.  Comments added that are
based upon my interpretation of the code.  Hopefully they're correct. :)

Signed-off-by: Andres Salomon <dilinger@collabora.co.uk>
Cc: Dave Airlie <airlied@linux.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


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
cs5535-gpio-add-amd-cs5535-cs5536-gpio-driver-support.patch
cs5535-gpio-request-function-mask-names-added.patch
alsa-cs5535audio-free-olpc-quirks-from-reliance-on-mgeode_lx-cpu-optimization.patch
drm-kill-some-unused-drm_proc-macros-from-drmph.patch
drm-kill-more-unused-drm-macros.patch
drm-replace-drm_copy-macro-w-a-function.patch
drm-check-return-values-in-drm_version.patch

