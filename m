From: akpm@linux-foundation.org
Subject: + drm-kill-some-unused-drm_proc-macros-from-drmph.patch added to -mm tree
Date: Mon, 02 Nov 2009 22:52:12 -0800
Message-ID: <200911030652.nA36qClt030069@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49512 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751154AbZKCGwS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 3 Nov 2009 01:52:18 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dilinger@collabora.co.uk, airlied@linux.ie


The patch titled
     drm: kill some unused DRM_PROC macros from drmP.h
has been added to the -mm tree.  Its filename is
     drm-kill-some-unused-drm_proc-macros-from-drmph.patch

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
