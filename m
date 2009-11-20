From: akpm@linux-foundation.org
Subject: [merged] drm-kill-some-unused-drm_proc-macros-from-drmph.patch removed from -mm tree
Date: Fri, 20 Nov 2009 11:30:51 -0800
Message-ID: <200911201930.nAKJUpNt011665@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52469 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751652AbZKTTbS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 20 Nov 2009 14:31:18 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dilinger@collabora.co.uk, airlied@linux.ie, mm-commits@vger.kernel.org


The patch titled
     drm: kill some unused DRM_PROC macros from drmP.h
has been removed from the -mm tree.  Its filename was
     drm-kill-some-unused-drm_proc-macros-from-drmph.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drm: kill some unused DRM_PROC macros from drmP.h
From: Andres Salomon <dilinger@collabora.co.uk>

i915_gem_proc.c appears to have been the last user of the DRM_PROC_*
macros, and it has gone away.  The macros should die as well.

Signed-off-by: Andres Salomon <dilinger@collabora.co.uk>
Cc: Dave Airlie <airlied@linux.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/drm/drmP.h |   10 ----------
 1 file changed, 10 deletions(-)

diff -puN include/drm/drmP.h~drm-kill-some-unused-drm_proc-macros-from-drmph include/drm/drmP.h
--- a/include/drm/drmP.h~drm-kill-some-unused-drm_proc-macros-from-drmph
+++ a/include/drm/drmP.h
@@ -245,16 +245,6 @@ extern void drm_ut_debug_printk(unsigned
 
 #endif
 
-#define DRM_PROC_LIMIT (PAGE_SIZE-80)
-
-#define DRM_PROC_PRINT(fmt, arg...)					\
-   len += sprintf(&buf[len], fmt , ##arg);				\
-   if (len > DRM_PROC_LIMIT) { *eof = 1; return len - offset; }
-
-#define DRM_PROC_PRINT_RET(ret, fmt, arg...)				\
-   len += sprintf(&buf[len], fmt , ##arg);				\
-   if (len > DRM_PROC_LIMIT) { ret; *eof = 1; return len - offset; }
