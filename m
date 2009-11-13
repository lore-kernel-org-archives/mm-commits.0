From: akpm@linux-foundation.org
Subject: [merged] savagefb-fix-blanking-mode-on-crt-display.patch removed from -mm tree
Date: Fri, 13 Nov 2009 11:26:16 -0800
Message-ID: <200911131926.nADJQGNZ027747@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60713 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932102AbZKMT0M (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 13 Nov 2009 14:26:12 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: krzysztof.h1@wp.pl, mm-commits@vger.kernel.org


The patch titled
     savagefb: fix blanking mode on CRT display
has been removed from the -mm tree.  Its filename was
     savagefb-fix-blanking-mode-on-crt-display.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: savagefb: fix blanking mode on CRT display
From: Krzysztof Helt <krzysztof.h1@wp.pl>

Fix wrong bit mask for blanking register.  Due to the error a CRT monitor
blanks off due to wrong frequency (out of range) instead of PM signal
(vertical and horizontal frequencies cut off).

Just compare the mask with bits set in the switch(blank) clause below the
changed line.

Signed-off-by: Krzysztof Helt <krzysztof.h1@wp.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN drivers/video/savage/savagefb_driver.c~savagefb-fix-blanking-mode-on-crt-display drivers/video/savage/savagefb_driver.c
--- a/drivers/video/savage/savagefb_driver.c~savagefb-fix-blanking-mode-on-crt-display
+++ a/drivers/video/savage/savagefb_driver.c
@@ -1565,7 +1565,7 @@ static int savagefb_blank(int blank, str
 		vga_out8(0x3c5, sr8, par);
 		vga_out8(0x3c4, 0x0d, par);
 		srd = vga_in8(0x3c5, par);
-		srd &= 0x03;
+		srd &= 0x50;
 
 		switch (blank) {
 		case FB_BLANK_UNBLANK:
_

Patches currently in -mm which might be from krzysztof.h1@wp.pl are

linux-next.patch
add-palette-register-check.patch
intelfb-fix-setting-of-active-pipe-with-lvds-displays.patch

