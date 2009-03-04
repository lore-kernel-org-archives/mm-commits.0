From: akpm@linux-foundation.org
Subject: + cirrusfb-fix-clock-doubling.patch added to -mm tree
Date: Wed, 04 Mar 2009 14:34:12 -0800
Message-ID: <200903042234.n24MYCTG010862@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49713 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751139AbZCDWeQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 4 Mar 2009 17:34:16 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: krzysztof.h1@wp.pl


The patch titled
     cirrusfb: fix clock doubling
has been added to the -mm tree.  Its filename is
     cirrusfb-fix-clock-doubling.patch

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
Subject: cirrusfb: fix clock doubling
From: Krzysztof Helt <krzysztof.h1@wp.pl>

Cirrus' Alpine and Picasso4 chips uses DAC clock doubling to achieve full
range of pixclock frequencies.

Signed-off-by: Krzysztof Helt <krzysztof.h1@wp.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/cirrusfb.c |   17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

diff -puN drivers/video/cirrusfb.c~cirrusfb-fix-clock-doubling drivers/video/cirrusfb.c
--- a/drivers/video/cirrusfb.c~cirrusfb-fix-clock-doubling
+++ a/drivers/video/cirrusfb.c
@@ -470,10 +470,23 @@ static int cirrusfb_check_pixclock(const
 	/* If the frequency is greater than we can support, we might be able
 	 * to use multiplexing for the video mode */
 	if (freq > maxclock) {
+		dev_err(info->device,
+			"Frequency greater than maxclock (%ld kHz)\n",
+			maxclock);
+		return -EINVAL;
+	}
+	/* Additional constrain: 8bpp uses DAC clock doubling
+	 * to allow maximum pixel clock */
+	if (var->bits_per_pixel == 8) {
 		switch (cinfo->btype) {
 		case BT_ALPINE:
+		case BT_PICASSO4:
+			if (freq > 85500)
+				cinfo->multiplexing = 1;
+			break;
 		case BT_GD5480:
-			cinfo->multiplexing = 1;
+			if (freq > 135100)
+				cinfo->multiplexing = 1;
 			break;
 
 		default:
@@ -815,6 +828,8 @@ static int cirrusfb_set_par_foo(struct f
 	freq = PICOS2KHZ(var->pixclock);
 	if (cinfo->btype == BT_ALPINE && var->bits_per_pixel == 24)
 		freq *= 3;
+	if (cinfo->multiplexing)
+		freq /= 2;
 
 	bestclock(freq, &nom, &den, &div);
 
_

Patches currently in -mm which might be from krzysztof.h1@wp.pl are

linux-next.patch
cirrusfb-convert-printks-to-dev_foo-fix-fix3.patch
cirrusfb-fix-laguna-chipset-memory-detection-and-clock-setting.patch
cirrusfb-add-laguna-additional-overflow-register.patch
cirrusfb-add-mmio-registers-for-laguna-chipsets.patch
cirrusfb-do-not-calculate-line-length-twice.patch
cirrusfb-use-5-6-5-rgb-for-16bpp-mode.patch
cirrusfb-various-improvements.patch
cirrusfb-laguna-chipset-8bpp-fix.patch
cirrusfb-check_var-improvements.patch
cirrusfb-various-laguna-fixes.patch
cirrusfb-acceleration-improvements.patch
cirrusfb-add-imageblit-function.patch
cirrusfb-fix-error-paths-in-cirrusfb_xxx_register.patch
cirrusfb-fix-error-paths-in-cirrusfb_xxx_register-fix.patch
cirrusfb-gd5446-fixes.patch
cirrusfb-use-24bpp-instead-of-32bpp.patch
cirrusfb-fix-clock-doubling.patch
cirrusfb-fix-clock-doubling-fix.patch
drivers-video-sgivwfbc-fix-memory-leaks-in-removal-path.patch
tdfxfb-fix-memory-leaks-in-removal-path.patch
tridentfb-fix-memory-leaks-in-removal-path.patch
vfb-fix-memory-leaks-in-removal-path.patch
sstfb-check-fb_alloc_cmap-return-value-and-handle-failure-properly.patch
stifb-check-fb_alloc_cmap-return-value-and-handle-failure-properly.patch
valkyriefb-check-fb_alloc_cmap-return-value-and-handle-failure-properly.patch
68328fb-fix-cmap-memory-leaks.patch
amba-clcd-fix-cmap-memory-leaks.patch
amifb-check-fb_alloc_cmap-return-value-and-handle-failure-properly.patch
asiliantfb-fix-cmap-memory-leaks.patch
asiliantfb-fix-cmap-memory-leaks-fix.patch

