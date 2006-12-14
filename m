From: akpm@osdl.org
Subject: + tgafb-fix-copying-overlapping-areas.patch added to -mm tree
Date: Wed, 13 Dec 2006 16:16:07 -0800
Message-ID: <200612140016.kBE0G7XI025766@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:60811 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751805AbWLNAQW (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 13 Dec 2006 19:16:22 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: macro@linux-mips.org, adaplas@pol.net, jsimmons@infradead.org


The patch titled
     tgafb: fix copying overlapping areas
has been added to the -mm tree.  Its filename is
     tgafb-fix-copying-overlapping-areas.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: tgafb: fix copying overlapping areas
From: "Maciej W. Rozycki" <macro@linux-mips.org>

The direction of copying in the copyarea functions is selected incorrectly,
resulting in corruption.  This is a fix.

Signed-off-by: Maciej W. Rozycki <macro@linux-mips.org>
Cc: James Simmons <jsimmons@infradead.org>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/video/tgafb.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/video/tgafb.c~tgafb-fix-copying-overlapping-areas drivers/video/tgafb.c
--- a/drivers/video/tgafb.c~tgafb-fix-copying-overlapping-areas
+++ a/drivers/video/tgafb.c
@@ -885,7 +885,7 @@ copyarea_line_8bpp(struct fb_info *info,
 
 	n64 = (height * width) / 64;
 
-	if (dy < sy) {
+	if (sy < dy) {
 		spos = (sy + height) * width;
 		dpos = (dy + height) * width;
 
@@ -933,7 +933,7 @@ copyarea_line_32bpp(struct fb_info *info
 
 	n16 = (height * width) / 16;
 
-	if (dy < sy) {
+	if (sy < dy) {
 		src = tga_fb + (sy + height) * width * 4;
 		dst = tga_fb + (dy + height) * width * 4;
 
_

Patches currently in -mm which might be from macro@linux-mips.org are

origin.patch
i386-io_apic-fix-a-typo-in-an-irq-handler-name.patch
tgafb-switch-to-framebuffer_alloc.patch
tgafb-fix-copying-overlapping-areas.patch
tgafb-support-the-directcolor-visual.patch
tgafb-fix-the-mode-register-setting.patch
tgafb-module-support-fixes.patch
tgafb-sync-on-green-support-fixes.patch

