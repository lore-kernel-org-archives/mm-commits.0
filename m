From: akpm@linux-foundation.org
Subject: + viafb-fix-ioremap_nocache-error-handling.patch added to -mm tree
Date: Fri, 14 Aug 2009 15:42:06 -0700
Message-ID: <200908142242.n7EMg6Lj001784@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49526 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753661AbZHNWmJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 14 Aug 2009 18:42:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: FlorianSchandinat@gmx.de, JosephChan@via.com.tw, ScottFang@viatech.com.cn


The patch titled
     viafb: fix ioremap_nocache error handling
has been added to the -mm tree.  Its filename is
     viafb-fix-ioremap_nocache-error-handling.patch

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
Subject: viafb: fix ioremap_nocache error handling
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>

Correct the returned error code for remapping the video framebuffer. 
Introduce error handling for remapping MMIO register address space to
avoid a NULL pointer dereference.  Disable hardware acceleration if
remapping MMIO register address space failed as those registers are only
used for hardware acceleration.

Signed-off-by: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Cc: Scott Fang <ScottFang@viatech.com.cn>
Cc: Joseph Chan <JosephChan@via.com.tw>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/via/viafbdev.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff -puN drivers/video/via/viafbdev.c~viafb-fix-ioremap_nocache-error-handling drivers/video/via/viafbdev.c
--- a/drivers/video/via/viafbdev.c~viafb-fix-ioremap_nocache-error-handling
+++ a/drivers/video/via/viafbdev.c
@@ -2134,12 +2134,16 @@ static int __devinit via_pci_probe(void)
 
 	if (!viaparinfo->fbmem_virt) {
 		printk(KERN_INFO "ioremap failed\n");
-		return -1;
+		return -ENOMEM;
 	}
 
 	viafb_get_mmio_info(&viaparinfo->mmio_base, &viaparinfo->mmio_len);
 	viaparinfo->io_virt = ioremap_nocache(viaparinfo->mmio_base,
 		viaparinfo->mmio_len);
+	if (!viaparinfo->io_virt) {
+		printk(KERN_WARNING "ioremap failed: hardware acceleration disabled\n");
+		viafb_accel = 0;
+	}
 
 	viafbinfo->node = 0;
 	viafbinfo->fbops = &viafb_ops;
_

Patches currently in -mm which might be from FlorianSchandinat@gmx.de are

viafb-remove-duplicated-cx700-register-init.patch
viafb-remove-temporary-start-address-setting.patch
viafb-merge-viafb_update_viafb_par-in-viafb_update_fix.patch
viafb-split-viafb_set_start_addr-up.patch
viafb-fix-ioremap_nocache-error-handling.patch
fb-fix-fb_pan_display-range-check.patch

