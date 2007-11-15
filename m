From: akpm@linux-foundation.org
Subject: - uvesafb-fix-warnings-about-unused-variables-on-non-x86.patch removed from -mm tree
Date: Thu, 15 Nov 2007 13:08:31 -0800
Message-ID: <200711152108.lAFL8VPT015367@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42264 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1765004AbXKOVJA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Nov 2007 16:09:00 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: frank@lichtenheld.de, adaplas@pol.net, spock@gentoo.org, mm-commits@vger.kernel.org


The patch titled
     uvesafb: fix warnings about unused variables on non-x86
has been removed from the -mm tree.  Its filename was
     uvesafb-fix-warnings-about-unused-variables-on-non-x86.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
