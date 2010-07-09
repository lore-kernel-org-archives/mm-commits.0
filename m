From: akpm@linux-foundation.org
Subject: + s3c-fb-fix-section-mismatch.patch added to -mm tree
Date: Fri, 09 Jul 2010 16:09:19 -0700
Message-ID: <201007092309.o69N9Kto031006@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57349 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755612Ab0GIXJg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 9 Jul 2010 19:09:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: m.szyprowski@samsung.com, ben-linux@fluff.org, inki.dae@samsung.com, kyungmin.park@samsung.com


The patch titled
     s3c-fb: fix section mismatch
has been added to the -mm tree.  Its filename is
     s3c-fb-fix-section-mismatch.patch

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
Subject: s3c-fb: fix section mismatch
From: Marek Szyprowski <m.szyprowski@samsung.com>

This patch fixes the following section mismatch errors:

WARNING: vmlinux.o(.data+0x20b40): Section mismatch in reference from the variable s3c_fb_driver_ids to the (unknown reference) .devinit.data:(unknown)
The variable s3c_fb_driver_ids references
the (unknown reference) __devinitdata (unknown)
If the reference is valid then annotate the
variable with __init* or __refdata (see linux/init.h) or name the variable:
*driver, *_template, *_timer, *_sht, *_ops, *_probe, *_probe_one, *_console,

WARNING: vmlinux.o(.data+0x20b58): Section mismatch in reference from the variable s3c_fb_driver_ids to the (unknown reference) .devinit.data:(unknown)
The variable s3c_fb_driver_ids references
the (unknown reference) __devinitdata (unknown)
If the reference is valid then annotate the
variable with __init* or __refdata (see linux/init.h) or name the variable:
*driver, *_template, *_timer, *_sht, *_ops, *_probe, *_probe_one, *_console,

WARNING: vmlinux.o(.data+0x20b70): Section mismatch in reference from the variable s3c_fb_driver_ids to the (unknown reference) .devinit.data:(unknown)
The variable s3c_fb_driver_ids references
the (unknown reference) __devinitdata (unknown)
If the reference is valid then annotate the
variable with __init* or __refdata (see linux/init.h) or name the variable:
*driver, *_template, *_timer, *_sht, *_ops, *_probe, *_probe_one, *_console,

Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
Cc: InKi Dae <inki.dae@samsung.com>
Cc: Ben Dooks <ben-linux@fluff.org>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/s3c-fb.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff -puN drivers/video/s3c-fb.c~s3c-fb-fix-section-mismatch drivers/video/s3c-fb.c
--- a/drivers/video/s3c-fb.c~s3c-fb-fix-section-mismatch
+++ a/drivers/video/s3c-fb.c
@@ -1478,7 +1478,7 @@ static int s3c_fb_resume(struct platform
 #define VALID_BPP124 (VALID_BPP(1) | VALID_BPP(2) | VALID_BPP(4))
 #define VALID_BPP1248 (VALID_BPP124 | VALID_BPP(8))
 
-static struct s3c_fb_win_variant s3c_fb_data_64xx_wins[] __devinitdata = {
+static struct s3c_fb_win_variant s3c_fb_data_64xx_wins[] = {
 	[0] = {
 		.has_osd_c	= 1,
 		.osd_size_off	= 0x8,
@@ -1526,7 +1526,7 @@ static struct s3c_fb_win_variant s3c_fb_
 	},
 };
 
-static struct s3c_fb_driverdata s3c_fb_data_64xx __devinitdata = {
+static struct s3c_fb_driverdata s3c_fb_data_64xx = {
 	.variant = {
 		.nr_windows	= 5,
 		.vidtcon	= VIDTCON0,
@@ -1556,7 +1556,7 @@ static struct s3c_fb_driverdata s3c_fb_d
 	.win[4]	= &s3c_fb_data_64xx_wins[4],
 };
 
-static struct s3c_fb_driverdata s3c_fb_data_s5pc100 __devinitdata = {
+static struct s3c_fb_driverdata s3c_fb_data_s5pc100 = {
 	.variant = {
 		.nr_windows	= 5,
 		.vidtcon	= VIDTCON0,
@@ -1586,7 +1586,7 @@ static struct s3c_fb_driverdata s3c_fb_d
 	.win[4]	= &s3c_fb_data_64xx_wins[4],
 };
 
-static struct s3c_fb_driverdata s3c_fb_data_s5pv210 __devinitdata = {
+static struct s3c_fb_driverdata s3c_fb_data_s5pv210 = {
 	.variant = {
 		.nr_windows	= 5,
 		.vidtcon	= VIDTCON0,
@@ -1617,7 +1617,7 @@ static struct s3c_fb_driverdata s3c_fb_d
 };
 
 /* S3C2443/S3C2416 style hardware */
-static struct s3c_fb_driverdata s3c_fb_data_s3c2443 __devinitdata = {
+static struct s3c_fb_driverdata s3c_fb_data_s3c2443 = {
 	.variant = {
 		.nr_windows	= 2,
 		.is_2443	= 1,
_

Patches currently in -mm which might be from m.szyprowski@samsung.com are

origin.patch
linux-next.patch
sdhci-s3c-add-missing-remove-function.patch
sdhci-s3c-add-support-for-the-non-standard-minimal-clock-value.patch
sdhci-s3c-add-support-for-the-non-standard-minimal-clock-value-fix.patch
sdhci-s3c-add-support-for-new-card-detection-methods.patch
s3c-fb-change-to-depending-on-config_s3c_fb_dev.patch
s3c-fb-add-default-window-feature.patch
s3c-fb-fix-distortedness-situation-for-the-mode-more-then-24bpp.patch
s3c-fb-only-init-window-colour-key-controls-for-windows-with-blending.patch
s3c-fb-initial-move-to-unifying-the-header-files.patch
s3c-fb-udpate-to-support-s3c2416-s3c2443-style-hardware.patch
s3c-fb-integrate-palette-setup-code-into-main-driver.patch
s3c-fb-fix-various-null-references-on-framebuffer-memory-alloc-failure.patch
s3c-fb-correct-framesel1-bitfield-defines-for-vidintcon0-register.patch
s3c-fb-separate-s5pc100-and-s5pv210-framebuffer-driver-data-structures.patch
s3c-fb-add-device-name-initialization.patch
s3c-fb-add-support-for-display-panning.patch
s3c-fb-add-wait-for-vsync-ioctl.patch
s3c-fb-window-3-of-64xx-does-not-have-an-osd_d-register.patch
s3c-fb-add-shadowcon-shadow-register-locking-support-for-s5pv210.patch
s3c-fb-correct-window-osd-size-and-alpha-register-handling.patch
s3c-fb-protect-window-specific-registers-during-updates.patch
s3c-fb-fix-section-mismatch.patch
s3c-fb-add-support-for-dma-channel-control-on-s5pv210.patch

