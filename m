From: akpm@linux-foundation.org
Subject: + fbcon-prevent-cursor-disappearance-after-switching-to-512-character-font.patch added to -mm tree
Date: Sun, 10 Aug 2008 12:45:57 -0700
Message-ID: <200808101945.m7AJjvZH029590@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41127 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753340AbYHJTqq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 10 Aug 2008 15:46:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: krzysztof.h1@wp.pl, hanzelpeter@gmail.com


The patch titled
     fbcon: prevent cursor disappearance after switching to 512 character font
has been added to the -mm tree.  Its filename is
     fbcon-prevent-cursor-disappearance-after-switching-to-512-character-font.patch

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
Subject: fbcon: prevent cursor disappearance after switching to 512 character font
From: Krzysztof Helt <krzysztof.h1@wp.pl>

Adjust and honor the vc_scrl_erase_char for 256 and 512 character fonts.

It fixes the issue with disappearing cursor during scrolling
(http://bugzilla.kernel.org/show_bug.cgi?id=11258).  The issue was
reported and tracked by Peter Hanzel.

Signed-off-by: Krzysztof Helt <krzysztof.h1@wp.pl>
Reported-by: Peter Hanzel <hanzelpeter@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/console/fbcon.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/video/console/fbcon.c~fbcon-prevent-cursor-disappearance-after-switching-to-512-character-font drivers/video/console/fbcon.c
--- a/drivers/video/console/fbcon.c~fbcon-prevent-cursor-disappearance-after-switching-to-512-character-font
+++ a/drivers/video/console/fbcon.c
@@ -2518,7 +2518,7 @@ static int fbcon_do_set_font(struct vc_d
 			c = vc->vc_video_erase_char;
 			vc->vc_video_erase_char =
 			    ((c & 0xfe00) >> 1) | (c & 0xff);
-			c = vc->vc_def_color;
+			c = vc->vc_scrl_erase_char;
 			vc->vc_scrl_erase_char =
 			    ((c & 0xFE00) >> 1) | (c & 0xFF);
 			vc->vc_attr >>= 1;
@@ -2551,7 +2551,7 @@ static int fbcon_do_set_font(struct vc_d
 			if (vc->vc_can_do_color) {
 				vc->vc_video_erase_char =
 				    ((c & 0xff00) << 1) | (c & 0xff);
-				c = vc->vc_def_color;
+				c = vc->vc_scrl_erase_char;
 				vc->vc_scrl_erase_char =
 				    ((c & 0xFF00) << 1) | (c & 0xFF);
 				vc->vc_attr <<= 1;
_

Patches currently in -mm which might be from krzysztof.h1@wp.pl are

origin.patch
sm501-update-debugging-low-information-messages.patch
matrox-maven-fix-a-broken-error-path.patch
matroxfb-i2c-structure-templates-clean-up.patch
matrox-maven-convert-to-a-new-style-i2c-driver.patch
atmel_lcdfb-set-ypanstep-to-1-and-enable-y-panning-on-at91.patch
atmel_lcdfb-add-board-parameter-specify-framebuffer-memory-size.patch
fbcon-prevent-cursor-disappearance-after-switching-to-512-character-font.patch
linux-next.patch
rtc-m48t59-reduce-structure-m48t59_private.patch
x86-fdiv-bug-detection-fix.patch
fb-convert-lock-unlock_kernel-into-local-fb-mutex.patch

