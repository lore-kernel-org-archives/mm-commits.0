From: akpm@linux-foundation.org
Subject: + savagefb-fix-blanking-mode-on-crt-display.patch added to -mm tree
Date: Wed, 28 Oct 2009 16:27:56 -0700
Message-ID: <200910282327.n9SNRuML013047@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39025 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755044AbZJ1X1x (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 28 Oct 2009 19:27:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: krzysztof.h1@wp.pl


The patch titled
     savagefb: fix blanking mode on CRT display
has been added to the -mm tree.  Its filename is
     savagefb-fix-blanking-mode-on-crt-display.patch

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
fb-remove-fb_save_state-and-fb_restore_state-operations.patch
savagefb-fix-blanking-mode-on-crt-display.patch
intelfb-fix-setting-of-active-pipe-with-lvds-displays.patch

