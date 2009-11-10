From: akpm@linux-foundation.org
Subject: + drm-check-return-values-in-drm_version.patch added to -mm tree
Date: Tue, 10 Nov 2009 12:32:48 -0800
Message-ID: <200911102032.nAAKWmh7007197@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50265 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758081AbZKJUcu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 10 Nov 2009 15:32:50 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dilinger@collabora.co.uk, airlied@linux.ie


The patch titled
     drm: check return values in drm_version
has been added to the -mm tree.  Its filename is
     drm-check-return-values-in-drm_version.patch

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
Subject: drm: check return values in drm_version
From: Andres Salomon <dilinger@collabora.co.uk>

In drm_version, actually check the results from function calls so that
we're not potentially passing garbage back to userspace.

Signed-off-by: Andres Salomon <dilinger@collabora.co.uk>
Cc: Dave Airlie <airlied@linux.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


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
drm-kill-some-unused-drm_proc-macros-from-drmph.patch
drm-kill-more-unused-drm-macros.patch
drm-replace-drm_copy-macro-w-a-function.patch
drm-check-return-values-in-drm_version.patch

