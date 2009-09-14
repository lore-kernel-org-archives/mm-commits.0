From: akpm@linux-foundation.org
Subject: + viafb-choose-acceleration-engine-for-vx855.patch added to -mm tree
Date: Mon, 14 Sep 2009 14:54:03 -0700
Message-ID: <200909142154.n8ELs3jX028532@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46773 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755116AbZINVyf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 14 Sep 2009 17:54:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: FlorianSchandinat@gmx.de, JosephChan@via.com.tw, ScottFang@viatech.com.cn, corbet@lwn.net


The patch titled
     viafb: choose acceleration engine for VX855
has been added to the -mm tree.  Its filename is
     viafb-choose-acceleration-engine-for-vx855.patch

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
Subject: viafb: choose acceleration engine for VX855
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>

Enable 2D hardware acceleration on VX855 for copyarea, imageblit and
fillrect by selecting the correct engine which is the same as in VX800.

Signed-off-by: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Cc: Scott Fang <ScottFang@viatech.com.cn>
Cc: Joseph Chan <JosephChan@via.com.tw>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/via/accel.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/video/via/accel.c~viafb-choose-acceleration-engine-for-vx855 drivers/video/via/accel.c
--- a/drivers/video/via/accel.c~viafb-choose-acceleration-engine-for-vx855
+++ a/drivers/video/via/accel.c
@@ -337,6 +337,7 @@ int viafb_init_engine(struct fb_info *in
 		viapar->shared->hw_bitblt = hw_bitblt_1;
 		break;
 	case UNICHROME_VX800:
+	case UNICHROME_VX855:
 		viapar->shared->hw_bitblt = hw_bitblt_2;
 		break;
 	default:
_

Patches currently in -mm which might be from FlorianSchandinat@gmx.de are

viafb-remove-duplicated-cx700-register-init.patch
viafb-remove-temporary-start-address-setting.patch
viafb-merge-viafb_update_viafb_par-in-viafb_update_fix.patch
viafb-split-viafb_set_start_addr-up.patch
viafb-fix-ioremap_nocache-error-handling.patch
viafb-clean-up-viamodeh.patch
viafb-remove-duplicated-mode-information.patch
viafb-clean-up-duoview.patch
viafb-clean-up-virtual-memory-handling.patch
viafb-remove-unused-video-device-stuff.patch
viafb-remove-lvds-initialization.patch
viafb-another-small-cleanup-of-viafb_par.patch
viafb-improve-viafb_par.patch
viafb-2d-engine-rewrite.patch
viafb-2d-engine-rewrite-v2.patch
viafb-switch-to-seq_file.patch
viafb-cleanup-viafb_cursor.patch
viafb-improve-pitch-handling.patch
viafb-hardware-acceleration-initialization-cleanup.patch
viafb-make-module-parameters-visible-in-sysfs.patch
viafb-remove-unused-structure-member.patch
viafb-use-read-only-mode-parsing.patch
viafb-add-support-for-the-vx855-chipset.patch
viafb-choose-acceleration-engine-for-vx855.patch
viafb-make-viafb-a-first-class-citizen-using-pci_driver.patch
viafb-pass-reference-to-pci-device-when-calling-framebuffer_alloc.patch
fb-fix-fb_pan_display-range-check.patch
fb-do-not-ignore-fb_set_par-errors.patch

