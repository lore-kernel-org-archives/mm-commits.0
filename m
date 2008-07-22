From: akpm@linux-foundation.org
Subject: + video-fb-cleanup-fb_major-usage.patch added to -mm tree
Date: Tue, 22 Jul 2008 03:42:38 -0700
Message-ID: <200807221042.m6MAgcFF024019@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55956 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754475AbYGVKni (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 22 Jul 2008 06:43:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: phdm@macqel.be, adaplas@pol.net, krzysztof.h1@poczta.fm


The patch titled
     video/fb: cleanup FB_MAJOR usage
has been added to the -mm tree.  Its filename is
     video-fb-cleanup-fb_major-usage.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: video/fb: cleanup FB_MAJOR usage
From: Philippe De Muyter <phdm@macqel.be>

Currently, linux/major.h defines a GRAPHDEV_MAJOR (29) that nobody uses,
and linux/fb.h defines the real FB_MAJOR (also 29), that only fbmem.c
needs.  Drop GRAPHDEV_MAJOR from major.h, move FB_MAJOR definition from
fb.h to major.h, and fix fbmem.c to use major.h's definition.

Signed-off-by: Philippe De Muyter <phdm@macqel.be>
Cc: Krzysztof Helt <krzysztof.h1@poczta.fm>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/fbmem.c |    1 +
 include/linux/fb.h    |    1 -
 include/linux/major.h |    2 +-
 3 files changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/video/fbmem.c~video-fb-cleanup-fb_major-usage drivers/video/fbmem.c
--- a/drivers/video/fbmem.c~video-fb-cleanup-fb_major-usage
+++ a/drivers/video/fbmem.c
@@ -35,6 +35,7 @@
 #include <linux/device.h>
 #include <linux/efi.h>
 #include <linux/fb.h>
+#include <linux/major.h>
 
 #include <asm/fb.h>
 
diff -puN include/linux/fb.h~video-fb-cleanup-fb_major-usage include/linux/fb.h
--- a/include/linux/fb.h~video-fb-cleanup-fb_major-usage
+++ a/include/linux/fb.h
@@ -8,7 +8,6 @@ struct dentry;
 
 /* Definitions of frame buffers						*/
 
-#define FB_MAJOR		29
 #define FB_MAX			32	/* sufficient for now */
 
 /* ioctls
diff -puN include/linux/major.h~video-fb-cleanup-fb_major-usage include/linux/major.h
--- a/include/linux/major.h~video-fb-cleanup-fb_major-usage
+++ a/include/linux/major.h
@@ -53,7 +53,7 @@
 #define STL_SIOMEMMAJOR		28
 #define ACSI_MAJOR		28
 #define AZTECH_CDROM_MAJOR	29
-#define GRAPHDEV_MAJOR		29   /* SparcLinux & Linux/68k /dev/fb */
+#define FB_MAJOR		29   /* /dev/fb* framebuffers */
 #define CM206_CDROM_MAJOR	32
 #define IDE2_MAJOR		33
 #define IDE3_MAJOR		34
_

Patches currently in -mm which might be from phdm@macqel.be are

origin.patch
video-fb-cleanup-fb_major-usage.patch

