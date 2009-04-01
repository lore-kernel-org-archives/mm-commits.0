From: akpm@linux-foundation.org
Subject: [merged] cirrusfb-fix-clock-doubling.patch removed from -mm tree
Date: Wed, 01 Apr 2009 11:42:55 -0700
Message-ID: <200904011842.n31IgtQd009863@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50188 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759443AbZDAS5y (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Apr 2009 14:57:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: krzysztof.h1@wp.pl, mm-commits@vger.kernel.org


The patch titled
     cirrusfb: fix clock doubling
has been removed from the -mm tree.  Its filename was
     cirrusfb-fix-clock-doubling.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cirrusfb: fix clock doubling
From: Krzysztof Helt <krzysztof.h1@wp.pl>

Cirrus' Alpine and Picasso4 chips uses DAC clock doubling to achieve full
range of pixclock frequencies.

[akpm@linux-foundation.org: fix spelling, use usual comment layout]
Signed-off-by: Krzysztof Helt <krzysztof.h1@wp.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/cirrusfb.c |   19 ++++++++++++++++++-
 1 file changed, 18 insertions(+), 1 deletion(-)

diff -puN drivers/video/cirrusfb.c~cirrusfb-fix-clock-doubling drivers/video/cirrusfb.c
--- a/drivers/video/cirrusfb.c~cirrusfb-fix-clock-doubling
+++ a/drivers/video/cirrusfb.c
@@ -470,10 +470,25 @@ static int cirrusfb_check_pixclock(const
 	/* If the frequency is greater than we can support, we might be able
 	 * to use multiplexing for the video mode */
 	if (freq > maxclock) {
+		dev_err(info->device,
+			"Frequency greater than maxclock (%ld kHz)\n",
+			maxclock);
+		return -EINVAL;
+	}
+	/*
+	 * Additional constraint: 8bpp uses DAC clock doubling to allow maximum
+	 * pixel clock
+	 */
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
@@ -815,6 +830,8 @@ static int cirrusfb_set_par_foo(struct f
 	freq = PICOS2KHZ(var->pixclock);
 	if (cinfo->btype == BT_ALPINE && var->bits_per_pixel == 24)
 		freq *= 3;
+	if (cinfo->multiplexing)
+		freq /= 2;
 
 	bestclock(freq, &nom, &den, &div);
 
_

Patches currently in -mm which might be from krzysztof.h1@wp.pl are

origin.patch
linux-next.patch
tdfxfb-move-i2c-functionality-into-the-tdfxfb.patch
tdfxfb-make-use-of-ddc-information-about-connected-monitor.patch

