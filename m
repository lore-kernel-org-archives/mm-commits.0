From: akpm@linux-foundation.org
Subject: - gxfb-lxfb-use-vsa-definitions-when-fetching-framebuffer-size.patch removed from -mm tree
Date: Mon, 28 Apr 2008 14:59:05 -0700
Message-ID: <200804282159.m3SLx5L5018550@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36647 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965445AbYD1V7V (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Apr 2008 17:59:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dilinger@queued.net, adaplas@pol.net, dilinger@debian.org, jordan.crouse@amd.com, mm-commits@vger.kernel.org


The patch titled
     gxfb/lxfb: use VSA definitions when fetching framebuffer size
has been removed from the -mm tree.  Its filename was
     gxfb-lxfb-use-vsa-definitions-when-fetching-framebuffer-size.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: gxfb/lxfb: use VSA definitions when fetching framebuffer size
From: Andres Salomon <dilinger@queued.net>

..Rather than using magic constants.

Signed-off-by: Andres Salomon <dilinger@debian.org>
Cc: Jordan Crouse <jordan.crouse@amd.com>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/geode/display_gx.c |    7 ++++---
 drivers/video/geode/lxfb_ops.c   |    6 +++---
 include/asm-x86/geode.h          |    1 +
 3 files changed, 8 insertions(+), 6 deletions(-)

diff -puN drivers/video/geode/display_gx.c~gxfb-lxfb-use-vsa-definitions-when-fetching-framebuffer-size drivers/video/geode/display_gx.c
--- a/drivers/video/geode/display_gx.c~gxfb-lxfb-use-vsa-definitions-when-fetching-framebuffer-size
+++ a/drivers/video/geode/display_gx.c
@@ -17,6 +17,7 @@
 #include <asm/io.h>
 #include <asm/div64.h>
 #include <asm/delay.h>
+#include <asm/geode.h>
 
 #include "gxfb.h"
 
@@ -28,10 +29,10 @@ unsigned int gx_frame_buffer_size(void)
 	/* Virtual register class = 0x02 */
 	/* VG_MEM_SIZE(512Kb units) = 0x00 */
 
-	outw(0xFC53, 0xAC1C);
-	outw(0x0200, 0xAC1C);
+	outw(VSA_VR_UNLOCK, VSA_VRC_INDEX);
+	outw(VSA_VR_MEM_SIZE, VSA_VRC_INDEX);
 
-	val = (unsigned int)(inw(0xAC1E)) & 0xFFl;
+	val = (unsigned int)(inw(VSA_VRC_DATA)) & 0xFFl;
 	return (val << 19);
 }
 
diff -puN drivers/video/geode/lxfb_ops.c~gxfb-lxfb-use-vsa-definitions-when-fetching-framebuffer-size drivers/video/geode/lxfb_ops.c
--- a/drivers/video/geode/lxfb_ops.c~gxfb-lxfb-use-vsa-definitions-when-fetching-framebuffer-size
+++ a/drivers/video/geode/lxfb_ops.c
@@ -333,10 +333,10 @@ unsigned int lx_framebuffer_size(void)
 	/* Virtual Register Class    = 0x02                     */
 	/* VG_MEM_SIZE (1MB units)   = 0x00                     */
 
-	outw(0xFC53, 0xAC1C);
-	outw(0x0200, 0xAC1C);
+	outw(VSA_VR_UNLOCK, VSA_VRC_INDEX);
+	outw(VSA_VR_MEM_SIZE, VSA_VRC_INDEX);
 
-	val = (unsigned int)(inw(0xAC1E)) & 0xFE;
+	val = (unsigned int)(inw(VSA_VRC_DATA)) & 0xFE;
 	return (val << 20);
 }
 
diff -puN include/asm-x86/geode.h~gxfb-lxfb-use-vsa-definitions-when-fetching-framebuffer-size include/asm-x86/geode.h
--- a/include/asm-x86/geode.h~gxfb-lxfb-use-vsa-definitions-when-fetching-framebuffer-size
+++ a/include/asm-x86/geode.h
@@ -109,6 +109,7 @@ extern int geode_get_dev_base(unsigned i
 #define VSA_VRC_DATA		0xAC1E
 #define VSA_VR_UNLOCK		0xFC53	/* unlock virtual register */
 #define VSA_VR_SIGNATURE	0x0003
+#define VSA_VR_MEM_SIZE		0x0200
 #define VSA_SIG			0x4132	/* signature is ascii 'VSA2' */
 
 /* GPIO */
_

Patches currently in -mm which might be from dilinger@queued.net are

origin.patch
git-kbuild.patch
x86-olpc-add-one-laptop-per-child-architecture-support.patch

