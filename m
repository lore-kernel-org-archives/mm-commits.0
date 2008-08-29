From: akpm@linux-foundation.org
Subject: + cirrusfb-simplify-clock-calculation.patch added to -mm tree
Date: Thu, 28 Aug 2008 17:48:13 -0700
Message-ID: <200808290048.m7T0mDK8023106@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59190 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753571AbYH2Asl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 28 Aug 2008 20:48:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: krzysztof.h1@wp.pl


The patch titled
     cirrusfb: simplify clock calculation
has been added to the -mm tree.  Its filename is
     cirrusfb-simplify-clock-calculation.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cirrusfb: simplify clock calculation
From: Krzysztof Helt <krzysztof.h1@wp.pl>

Simplify clock calculation.

Signed-off-by: Krzysztof Helt <krzysztof.h1@wp.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/cirrusfb.c |   40 +++++++++++++++++--------------------
 1 file changed, 19 insertions(+), 21 deletions(-)

diff -puN drivers/video/cirrusfb.c~cirrusfb-simplify-clock-calculation drivers/video/cirrusfb.c
--- a/drivers/video/cirrusfb.c~cirrusfb-simplify-clock-calculation
+++ a/drivers/video/cirrusfb.c
@@ -3075,38 +3075,36 @@ static void bestclock(long freq, long *b
 	f = freq * 10;
 
 	for (n = 32; n < 128; n++) {
+		int s = 0;
+
 		d = (143181 * n) / f;
 		if ((d >= 7) && (d <= 63)) {
-			if (d > 31)
-				d = (d / 2) * 2;
-			h = (14318 * n) / d;
+			int temp = d;
+
+			if (temp > 31) {
+				s = 1;
+				temp >>= 1;
+			}
+			h = ((14318 * n) / temp) >> s;
 			if (abs(h - freq) < abs(*best - freq)) {
 				*best = h;
 				*nom = n;
-				if (d < 32) {
-					*den = d;
-					*div = 0;
-				} else {
-					*den = d / 2;
-					*div = 1;
-				}
+				*den = temp;
+				*div = s;
 			}
 		}
-		d = DIV_ROUND_UP(143181 * n, f);
+		d++;
 		if ((d >= 7) && (d <= 63)) {
-			if (d > 31)
-				d = (d / 2) * 2;
-			h = (14318 * n) / d;
+			if (d > 31) {
+				s = 1;
+				d >>= 1;
+			}
+			h = ((14318 * n) / d) >> s;
 			if (abs(h - freq) < abs(*best - freq)) {
 				*best = h;
 				*nom = n;
-				if (d < 32) {
-					*den = d;
-					*div = 0;
-				} else {
-					*den = d / 2;
-					*div = 1;
-				}
+				*den = d;
+				*div = s;
 			}
 		}
 	}
_

Patches currently in -mm which might be from krzysztof.h1@wp.pl are

cirrusfb-check_par-fixes.patch
tdfxfb-fix-sdram-memory-size-detection.patch
tdfxfb-fix-frame-buffer-name-overrun.patch
linux-next.patch
fb-metronome-printk-format-warning.patch
rtc-m48t59-reduce-structure-m48t59_private.patch
rtc-m48t59-add-support-for-m48t02-and-m48t59-chips-2nd-rev.patch
fb-convert-lock-unlock_kernel-into-local-fb-mutex.patch
neofb-reduce-panning-function.patch
viafb-accelc-accelh-update.patch
viafb-viafbdevc-update.patch
fbdev-kconfig-update.patch
fbdev-kconfig-update-fix.patch
neofb-kill-some-redundant-code.patch
vga16fb-remove-open_lock-mutex.patch
neofb-remove-open_lock-mutex.patch
cirrusfb-remove-information-about-memory-size-during-mode-change.patch
cirrusfb-simplify-clock-calculation.patch
cirrusfb-remove-24-bpp-mode.patch
cirrusfb-drop-device-pointers-from-cirrusfb_info.patch
tdfxfb-do-not-make-changes-to-default-tdfx_fix.patch

