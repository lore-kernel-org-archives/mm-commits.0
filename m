From: akpm@linux-foundation.org
Subject: + uvesafb-the-driver-core-uvesafb-use-the-default-refresh-rate-if-the-monitor-limits-are-not-set.patch added to -mm tree
Date: Wed, 15 Aug 2007 13:58:28 -0700
Message-ID: <200708152058.l7FKwSOs014667@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47311 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753448AbXHOU6r (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 15 Aug 2007 16:58:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: spock@gentoo.org, adaplas@pol.net


The patch titled
     uvesafb: use the default refresh rate if the monitor limits are not set
has been added to the -mm tree.  Its filename is
     uvesafb-the-driver-core-uvesafb-use-the-default-refresh-rate-if-the-monitor-limits-are-not-set.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: uvesafb: use the default refresh rate if the monitor limits are not set
From: Michal Januszewski <spock@gentoo.org>

Use the default refresh rate if the monitor limits aren't set (either using
data from the EDID block, or explicitly by the user).

Signed-off-by: Michal Januszewski <spock@gentoo.org>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/uvesafb.c |   11 ++++++++---
 1 files changed, 8 insertions(+), 3 deletions(-)

diff -puN drivers/video/uvesafb.c~uvesafb-the-driver-core-uvesafb-use-the-default-refresh-rate-if-the-monitor-limits-are-not-set drivers/video/uvesafb.c
--- a/drivers/video/uvesafb.c~uvesafb-the-driver-core-uvesafb-use-the-default-refresh-rate-if-the-monitor-limits-are-not-set
+++ a/drivers/video/uvesafb.c
@@ -689,10 +689,13 @@ static void __devinit uvesafb_vbe_getmon
 
 	/*
 	 * If we don't get all necessary data from the EDID block,
-	 * mark it as incompatible with the GTF.
+	 * mark it as incompatible with the GTF and set nocrtc so
+	 * that we always use the default BIOS refresh rate.
 	 */
-	if (uvesafb_vbe_getedid(task, info))
+	if (uvesafb_vbe_getedid(task, info)) {
 		info->monspecs.gtf = 0;
+		par->nocrtc = 1;
+	}
 
 	/* Kernel command line overrides. */
 	if (maxclk)
@@ -711,6 +714,7 @@ static void __devinit uvesafb_vbe_getmon
 		info->monspecs.vfmin = 60;
 		info->monspecs.hfmin = 29000;
 		info->monspecs.gtf = 1;
+		par->nocrtc = 0;
 	}
 
 	if (info->monspecs.gtf)
@@ -720,7 +724,8 @@ static void __devinit uvesafb_vbe_getmon
 			(int)(info->monspecs.hfmax / 1000),
 			(int)(info->monspecs.dclkmax / 1000000));
 	else
-		printk(KERN_INFO "uvesafb: no monitor limits have been set\n");
+		printk(KERN_INFO "uvesafb: no monitor limits have been set, "
+				 "default refresh rate will be used\n");
 
 	/* Add VBE modes to the modelist. */
 	for (i = 0; i < par->vbe_modes_cnt; i++) {
_

Patches currently in -mm which might be from spock@gentoo.org are

fbdev-export-fb_destroy_modelist.patch
connector-change-connectors-max-message-size.patch
uvesafb-add-connector-entries.patch
uvesafb-the-driver-core.patch
uvesafb-the-driver-core-uvesafb-set-the-refresh-rate-to-60hz-if-nocrtc-is-used.patch
uvesafb-the-driver-core-uvesafb-always-use-mutexes-when-accessing-uvfb_tasks.patch
uvesafb-the-driver-core-uvesafb-fix-a-typo-in-a-warning.patch
uvesafb-the-driver-core-uvesafb-use-visual_truecolor-as-the-default-visual.patch
uvesafb-the-driver-core-uvesafb-use-the-default-refresh-rate-if-the-monitor-limits-are-not-set.patch
uvesafb-the-driver-core-uvesafb-try-to-set-mode-with-default-timings-if-setting-it-with-our-own-timings-failed.patch
uvesafb-documentation.patch
uvesafb-documentation-uvesafb-add-info-about-pmipal-yrap-and-ypan-being-available-only-on-x86.patch
