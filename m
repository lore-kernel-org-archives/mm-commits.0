From: akpm@linux-foundation.org
Subject: + viafb-pass-reference-to-pci-device-when-calling-framebuffer_alloc.patch added to -mm tree
Date: Mon, 14 Sep 2009 14:54:07 -0700
Message-ID: <200909142154.n8ELs7bI028664@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35713 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755118AbZINVyo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 14 Sep 2009 17:54:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: laforge@gnumonks.org, FlorianSchandinat@gmx.de, HaraldWelte@viatech.com, JosephChan@via.com.tw, ScottFang@viatech.com.cn, corbet@lwn.net


The patch titled
     viafb: pass reference to pci device when calling framebuffer_alloc()
has been added to the -mm tree.  Its filename is
     viafb-pass-reference-to-pci-device-when-calling-framebuffer_alloc.patch

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
Subject: viafb: pass reference to pci device when calling framebuffer_alloc()
From: Harald Welte <laforge@gnumonks.org>

Signed-off-by: Harald Welte <HaraldWelte@viatech.com>
Signed-off-by: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Cc: Scott Fang <ScottFang@viatech.com.cn>
Cc: Joseph Chan <JosephChan@via.com.tw>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/via/viafbdev.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN drivers/video/via/viafbdev.c~viafb-pass-reference-to-pci-device-when-calling-framebuffer_alloc drivers/video/via/viafbdev.c
--- a/drivers/video/via/viafbdev.c~viafb-pass-reference-to-pci-device-when-calling-framebuffer_alloc
+++ a/drivers/video/via/viafbdev.c
@@ -1857,7 +1857,8 @@ static int __devinit via_pci_probe(struc
 	 * variables
 	*/
 	viafbinfo = framebuffer_alloc(viafb_par_length +
-		ALIGN(sizeof(struct viafb_shared), BITS_PER_LONG/8), NULL);
+		ALIGN(sizeof(struct viafb_shared), BITS_PER_LONG/8),
+		&pdev->dev);
 	if (!viafbinfo) {
 		printk(KERN_ERR"Could not allocate memory for viafb_info.\n");
 		return -ENODEV;
@@ -1982,7 +1983,7 @@ static int __devinit via_pci_probe(struc
 	default_var.vsync_len = 4;
 
 	if (viafb_dual_fb) {
-		viafbinfo1 = framebuffer_alloc(viafb_par_length, NULL);
+		viafbinfo1 = framebuffer_alloc(viafb_par_length, &pdev->dev);
 		if (!viafbinfo1) {
 			printk(KERN_ERR
 			"allocate the second framebuffer struct error\n");
_

Patches currently in -mm which might be from laforge@gnumonks.org are

pcmcia-fix-read-buffer-overflow.patch
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
viafb-make-viafb-a-first-class-citizen-using-pci_driver.patch
viafb-pass-reference-to-pci-device-when-calling-framebuffer_alloc.patch

