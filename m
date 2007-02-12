From: akpm@linux-foundation.org
Subject: - tgafb-fix-copying-overlapping-areas.patch removed from -mm tree
Date: Mon, 12 Feb 2007 14:49:19 -0800
Message-ID: <200702122249.l1CMnJtu014099@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:45918 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030362AbXBLWwm (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 12 Feb 2007 17:52:42 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: macro@linux-mips.org, adaplas@pol.net, jsimmons@infradead.org, mm-commits@vger.kernel.org


The patch titled
     tgafb: fix copying overlapping areas
has been removed from the -mm tree.  Its filename was
     tgafb-fix-copying-overlapping-areas.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: tgafb: fix copying overlapping areas
From: "Maciej W. Rozycki" <macro@linux-mips.org>

The direction of copying in the copyarea functions is selected incorrectly,
resulting in corruption.  This is a fix.

Signed-off-by: Maciej W. Rozycki <macro@linux-mips.org>
Cc: James Simmons <jsimmons@infradead.org>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/tgafb.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

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
aio-use-flush_work.patch
kblockd-use-flush_work.patch
relayfs-use-flush_keventd_work.patch
tg3-use-flush_keventd_work.patch
e1000-use-flush_keventd_work.patch
libata-use-flush_work.patch
phy-use-flush_work.patch
