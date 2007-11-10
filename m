From: akpm@linux-foundation.org
Subject: + uvesafb-fix-warnings-about-unused-variables-on-non-x86.patch added to -mm tree
Date: Fri, 09 Nov 2007 16:47:18 -0800
Message-ID: <200711100047.lAA0lIm8007604@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47210 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751060AbXKJArd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 9 Nov 2007 19:47:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: frank@lichtenheld.de, adaplas@pol.net, spock@gentoo.org


The patch titled
     uvesafb: fix warnings about unused variables on non-x86
has been added to the -mm tree.  Its filename is
     uvesafb-fix-warnings-about-unused-variables-on-non-x86.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: uvesafb: fix warnings about unused variables on non-x86
From: Frank Lichtenheld <frank@lichtenheld.de>

Variables that are only used in #ifdef CONFIG_X86 should also only be
declared there.

Signed-off-by: Frank Lichtenheld <frank@lichtenheld.de>
Cc: Michal Januszewski <spock@gentoo.org>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/uvesafb.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff -puN drivers/video/uvesafb.c~uvesafb-fix-warnings-about-unused-variables-on-non-x86 drivers/video/uvesafb.c
--- a/drivers/video/uvesafb.c~uvesafb-fix-warnings-about-unused-variables-on-non-x86
+++ a/drivers/video/uvesafb.c
@@ -926,8 +926,10 @@ static int uvesafb_setpalette(struct uve
 		int start, struct fb_info *info)
 {
 	struct uvesafb_ktask *task;
+#ifdef CONFIG_X86
 	struct uvesafb_par *par = info->par;
 	int i = par->mode_idx;
+#endif
 	int err = 0;
 
 	/*
@@ -1103,11 +1105,11 @@ static int uvesafb_pan_display(struct fb
 
 static int uvesafb_blank(int blank, struct fb_info *info)
 {
-	struct uvesafb_par *par = info->par;
 	struct uvesafb_ktask *task;
 	int err = 1;
-
 #ifdef CONFIG_X86
+	struct uvesafb_par *par = info->par;
+
 	if (par->vbe_ib.capabilities & VBE_CAP_VGACOMPAT) {
 		int loop = 10000;
 		u8 seq = 0, crtc17 = 0;
_

Patches currently in -mm which might be from frank@lichtenheld.de are

uvesafb-fix-warnings-about-unused-variables-on-non-x86.patch
