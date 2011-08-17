From: akpm@linux-foundation.org
Subject: [obsolete] drm-add-missing-header-file-linuc-typesh.patch removed from -mm tree
Date: Wed, 17 Aug 2011 14:09:02 -0700
Message-ID: <201108172109.p7HL92Su028494@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36187 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754428Ab1HQVJH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 17 Aug 2011 17:09:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: amwang@redhat.com, airlied@linux.ie, mm-commits@vger.kernel.org


The patch titled
     drm: add missing header file <linuc/types.h>
has been removed from the -mm tree.  Its filename was
     drm-add-missing-header-file-linuc-typesh.patch

This patch was dropped because it is obsolete

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drm: add missing header file <linuc/types.h>
From: Amerigo Wang <amwang@redhat.com>

This patch fixes the following 'make headers_check' errors:

linux-2.6/usr/include/drm/drm_mode.h:85: found __[us]{8,16,32,64} type without #include <linux/types.h>
linux-2.6/usr/include/drm/i915_drm.h:120: found __[us]{8,16,32,64} type without #include <linux/types.h>
linux-2.6/usr/include/drm/mga_drm.h:260: found __[us]{8,16,32,64} type without #include <linux/types.h>
linux-2.6/usr/include/drm/radeon_drm.h:758: found __[us]{8,16,32,64} type without #include <linux/types.h>
linux-2.6/usr/include/drm/via_drm.h:117: found __[us]{8,16,32,64} type without #include <linux/types.h>

Signed-off-by: WANG Cong <amwang@redhat.com>
Cc: Dave Airlie <airlied@linux.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/drm/drm_mode.h   |    2 ++
 include/drm/i915_drm.h   |    1 +
 include/drm/mga_drm.h    |    1 +
 include/drm/radeon_drm.h |    1 +
 include/drm/via_drm.h    |    1 +
 5 files changed, 6 insertions(+)

diff -puN include/drm/drm_mode.h~drm-add-missing-header-file-linuc-typesh include/drm/drm_mode.h
--- a/include/drm/drm_mode.h~drm-add-missing-header-file-linuc-typesh
+++ a/include/drm/drm_mode.h
@@ -81,6 +81,8 @@
 #define DRM_MODE_DIRTY_ON       1
 #define DRM_MODE_DIRTY_ANNOTATE 2
 
+#include <linux/types.h>
+
 struct drm_mode_modeinfo {
 	__u32 clock;
 	__u16 hdisplay, hsync_start, hsync_end, htotal, hskew;
diff -puN include/drm/i915_drm.h~drm-add-missing-header-file-linuc-typesh include/drm/i915_drm.h
--- a/include/drm/i915_drm.h~drm-add-missing-header-file-linuc-typesh
+++ a/include/drm/i915_drm.h
@@ -27,6 +27,7 @@
 #ifndef _I915_DRM_H_
 #define _I915_DRM_H_
 
+#include <linux/types.h>
 #include "drm.h"
 
 /* Please note that modifications to all structs defined here are
diff -puN include/drm/mga_drm.h~drm-add-missing-header-file-linuc-typesh include/drm/mga_drm.h
--- a/include/drm/mga_drm.h~drm-add-missing-header-file-linuc-typesh
+++ a/include/drm/mga_drm.h
@@ -35,6 +35,7 @@
 #ifndef __MGA_DRM_H__
 #define __MGA_DRM_H__
 
+#include <linux/types.h>
 #include "drm.h"
 
 /* WARNING: If you change any of these defines, make sure to change the
diff -puN include/drm/radeon_drm.h~drm-add-missing-header-file-linuc-typesh include/drm/radeon_drm.h
--- a/include/drm/radeon_drm.h~drm-add-missing-header-file-linuc-typesh
+++ a/include/drm/radeon_drm.h
@@ -33,6 +33,7 @@
 #ifndef __RADEON_DRM_H__
 #define __RADEON_DRM_H__
 
+#include <linux/types.h>
 #include "drm.h"
 
 /* WARNING: If you change any of these defines, make sure to change the
diff -puN include/drm/via_drm.h~drm-add-missing-header-file-linuc-typesh include/drm/via_drm.h
--- a/include/drm/via_drm.h~drm-add-missing-header-file-linuc-typesh
+++ a/include/drm/via_drm.h
@@ -24,6 +24,7 @@
 #ifndef _VIA_DRM_H_
 #define _VIA_DRM_H_
 
+#include <linux/types.h>
 #include "drm.h"
 
 /* WARNING: These defines must be the same as what the Xserver uses.
_

Patches currently in -mm which might be from amwang@redhat.com are

linux-next.patch
nbd-use-task_pid_nr-to-get-current-pid.patch
nbd-replace-sysfs_create_file-with-device_create_file.patch
nbd-replace-printk-kern_err-with-dev_err.patch
nbd-lower-the-loglevel-of-an-error-message.patch
nbd-replace-some-printk-with-dev_warn-and-dev_info.patch
nbd-replace-some-printk-with-dev_warn-and-dev_info-checkpatch-fixes.patch

