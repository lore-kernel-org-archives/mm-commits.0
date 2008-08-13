From: akpm@linux-foundation.org
Subject: - fbcon-prevent-cursor-disappearance-after-switching-to-512-character-font.patch removed from -mm tree
Date: Wed, 13 Aug 2008 01:52:59 -0700
Message-ID: <200808130852.m7D8qxAA008274@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58985 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753080AbYHMJCv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 13 Aug 2008 05:02:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: krzysztof.h1@wp.pl, hanzelpeter@gmail.com, mm-commits@vger.kernel.org


The patch titled
     fbcon: prevent cursor disappearance after switching to 512 character font
has been removed from the -mm tree.  Its filename was
     fbcon-prevent-cursor-disappearance-after-switching-to-512-character-font.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

linux-next.patch
rtc-m48t59-reduce-structure-m48t59_private.patch
rtc-m48t59-add-support-for-m48t02-and-m48t59-chips-2nd-rev.patch
fb-convert-lock-unlock_kernel-into-local-fb-mutex.patch
neofb-reduce-panning-function.patch
fbdev-kconfig-update.patch
fbdev-kconfig-update-fix.patch

