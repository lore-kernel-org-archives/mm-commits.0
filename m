From: akpm@linux-foundation.org
Subject: [alternative-merged] drm-kill-more-unused-drm-macros.patch removed from -mm tree
Date: Thu, 19 Nov 2009 13:22:15 -0800
Message-ID: <200911192122.nAJLMFPr024587@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51794 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753298AbZKSVWi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Nov 2009 16:22:38 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dilinger@collabora.co.uk, airlied@linux.ie, mm-commits@vger.kernel.org


The patch titled
     drm: kill more unused DRM macros
has been removed from the -mm tree.  Its filename was
     drm-kill-more-unused-drm-macros.patch

This patch was dropped because an alternative patch was merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drm: kill more unused DRM macros
From: Andres Salomon <dilinger@collabora.co.uk>

There are a few more macros in drmP.h that are unused; DRM_GET_PRIV_SAREA,
DRM_ARRAY_SIZE, and DRM_WAITCOUNT can go away completely.

Unfortunately, DRM_COPY is still used in one place, but we can at least
move it to where it's used.  It's an awful looking macro..

[akpm: fix overeagerness]
Signed-off-by: Andres Salomon <dilinger@collabora.co.uk>
Cc: Dave Airlie <airlied@linux.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpu/drm/drm_drv.c |   12 ++++++++++++
 include/drm/drmP.h        |   23 -----------------------
 2 files changed, 12 insertions(+), 23 deletions(-)

diff -puN drivers/gpu/drm/drm_drv.c~drm-kill-more-unused-drm-macros drivers/gpu/drm/drm_drv.c
--- a/drivers/gpu/drm/drm_drv.c~drm-kill-more-unused-drm-macros
+++ a/drivers/gpu/drm/drm_drv.c
@@ -366,6 +366,18 @@ module_init(drm_core_init);
 module_exit(drm_core_exit);
 
 /**
+ * Copy and IOCTL return string to user space
+ */
+#define DRM_COPY(name, value)                                         \
+	len = strlen(value);                                          \
+	if (len > name##_len) len = name##_len;                       \
+	name##_len = strlen(value);                                   \
+	if (len && name) {                                            \
+		if (copy_to_user(name, value, len))                   \
+			return -EFAULT;                               \
+	}
+
+/**
  * Get version information
  *
  * \param inode device inode.
diff -puN include/drm/drmP.h~drm-kill-more-unused-drm-macros include/drm/drmP.h
--- a/include/drm/drmP.h~drm-kill-more-unused-drm-macros
+++ a/include/drm/drmP.h
@@ -255,19 +255,8 @@ extern void drm_ut_debug_printk(unsigned
 
 #define DRM_LEFTCOUNT(x) (((x)->rp + (x)->count - (x)->wp) % ((x)->count + 1))
 #define DRM_BUFCOUNT(x) ((x)->count - DRM_LEFTCOUNT(x))
-#define DRM_WAITCOUNT(dev,idx) DRM_BUFCOUNT(&dev->queuelist[idx]->waitlist)
 
 #define DRM_IF_VERSION(maj, min) (maj << 16 | min)
-/**
- * Get the private SAREA mapping.
- *
- * \param _dev DRM device.
- * \param _ctx context number.
- * \param _map output mapping.
- */
-#define DRM_GET_PRIV_SAREA(_dev, _ctx, _map) do {	\
-	(_map) = (_dev)->context_sareas[_ctx];		\
-} while(0)
 
 /**
  * Test that the hardware lock is held by the caller, returning otherwise.
@@ -287,18 +276,6 @@ do {										\
 } while (0)
 
 /**
- * Copy and IOCTL return string to user space
- */
-#define DRM_COPY( name, value )						\
-	len = strlen( value );						\
-	if ( len > name##_len ) len = name##_len;			\
-	name##_len = strlen( value );					\
-	if ( len && name ) {						\
-		if ( copy_to_user( name, value, len ) )			\
-			return -EFAULT;					\
-	}
