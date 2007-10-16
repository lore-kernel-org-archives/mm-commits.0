From: akpm@linux-foundation.org
Subject: - uvesafb-the-driver-core-uvesafb-try-to-set-mode-with-default-timings-if-setting-it-with-our-own-timings-failed.patch removed from -mm tree
Date: Mon, 15 Oct 2007 21:56:55 -0700
Message-ID: <200710160456.l9G4utII009847@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36028 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756088AbXJPE46 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Oct 2007 00:56:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: spock@gentoo.org, adaplas@pol.net, mm-commits@vger.kernel.org


The patch titled
     uvesafb: try to set mode with default timings if setting it with our own timings failed
has been removed from the -mm tree.  Its filename was
     uvesafb-the-driver-core-uvesafb-try-to-set-mode-with-default-timings-if-setting-it-with-our-own-timings-failed.patch

This patch was dropped because it was folded into uvesafb-the-driver-core.patch

------------------------------------------------------
Subject: uvesafb: try to set mode with default timings if setting it with our own timings failed
From: Michal Januszewski <spock@gentoo.org>

Sometimes the BIOS might not perform the mode switch correctly because of the
timings that we requested.  In case this happens, try to set the video mode
with the default timings instead.

Signed-off-by: Michal Januszewski <spock@gentoo.org>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/uvesafb.c |   24 ++++++++++++++++++++----
 1 files changed, 20 insertions(+), 4 deletions(-)

diff -puN drivers/video/uvesafb.c~uvesafb-the-driver-core-uvesafb-try-to-set-mode-with-default-timings-if-setting-it-with-our-own-timings-failed drivers/video/uvesafb.c
--- a/drivers/video/uvesafb.c~uvesafb-the-driver-core-uvesafb-try-to-set-mode-with-default-timings-if-setting-it-with-our-own-timings-failed
+++ a/drivers/video/uvesafb.c
@@ -1218,6 +1218,7 @@ static int uvesafb_set_par(struct fb_inf
 	task = uvesafb_prep();
 	if (!task)
 		return -ENOMEM;
+setmode:
 	task->t.regs.eax = 0x4f02;
 	task->t.regs.ebx = mode->mode_id | 0x4000;	/* use LFB */
 
@@ -1260,10 +1261,25 @@ static int uvesafb_set_par(struct fb_inf
 
 	err = uvesafb_exec(task);
 	if (err || (task->t.regs.eax & 0xffff) != 0x004f) {
-		printk(KERN_ERR "uvesafb: mode switch failed (eax=0x%x, "
-				"err=%d)\n", task->t.regs.eax, err);
-		err = -EINVAL;
-		goto out;
+		/*
+		 * The mode switch might have failed because we tried to
+		 * use our own timings.  Try again with the default timings.
+		 */
+		if (crtc != NULL) {
+			printk(KERN_WARNING "uvesafb: mode switch failed "
+				"(eax=0x%x, err=%d). Trying again with "
+				"default timings.\n", task->t.regs.eax, err);
+			uvesafb_reset(task);
+			kfree(crtc);
+			crtc = NULL;
+			info->var.pixclock = 0;
+			goto setmode;
+		} else {
+			printk(KERN_ERR "uvesafb: mode switch failed (eax="
+				"0x%x, err=%d)\n", task->t.regs.eax, err);
+			err = -EINVAL;
+			goto out;
+		}
 	}
 	par->mode_idx = i;
 
_

Patches currently in -mm which might be from spock@gentoo.org are

fbdev-export-fb_destroy_modelist.patch
connector-change-connectors-max-message-size.patch
uvesafb-add-connector-entries.patch
uvesafb-the-driver-core.patch
uvesafb-the-driver-core-uvesafb-try-to-set-mode-with-default-timings-if-setting-it-with-our-own-timings-failed.patch
uvesafb-the-driver-core-dont-access-vga-registers-directly-when-running-on-non-x86.patch
uvesafb-documentation.patch
uvesafb-documentation-uvesafb-add-info-about-pmipal-yrap-and-ypan-being-available-only-on-x86.patch
fbdev-find-mode-with-the-highest-safest-refresh-rate-in-fb_find_mode.patch
