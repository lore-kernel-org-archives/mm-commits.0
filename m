From: akpm@linux-foundation.org
Subject: + uvesafb-the-driver-core-uvesafb-try-to-set-mode-with-default-timings-if-setting-it-with-our-own-timings-failed.patch added to -mm tree
Date: Wed, 15 Aug 2007 13:58:30 -0700
Message-ID: <200708152058.l7FKwU99014670@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38910 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751401AbXHOU6m (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 15 Aug 2007 16:58:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: spock@gentoo.org, adaplas@pol.net


The patch titled
     uvesafb: try to set mode with default timings if setting it with our own timings failed
has been added to the -mm tree.  Its filename is
     uvesafb-the-driver-core-uvesafb-try-to-set-mode-with-default-timings-if-setting-it-with-our-own-timings-failed.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
uvesafb-the-driver-core-uvesafb-set-the-refresh-rate-to-60hz-if-nocrtc-is-used.patch
uvesafb-the-driver-core-uvesafb-always-use-mutexes-when-accessing-uvfb_tasks.patch
uvesafb-the-driver-core-uvesafb-fix-a-typo-in-a-warning.patch
uvesafb-the-driver-core-uvesafb-use-visual_truecolor-as-the-default-visual.patch
uvesafb-the-driver-core-uvesafb-use-the-default-refresh-rate-if-the-monitor-limits-are-not-set.patch
uvesafb-the-driver-core-uvesafb-try-to-set-mode-with-default-timings-if-setting-it-with-our-own-timings-failed.patch
uvesafb-documentation.patch
uvesafb-documentation-uvesafb-add-info-about-pmipal-yrap-and-ypan-being-available-only-on-x86.patch
