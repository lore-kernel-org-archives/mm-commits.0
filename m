From: akpm@linux-foundation.org
Subject: [merged] viafb-fix-ioremap_nocache-error-handling.patch removed from -mm tree
Date: Wed, 23 Sep 2009 13:01:40 -0700
Message-ID: <200909232001.n8NK1eWX015600@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39973 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752212AbZIWUKJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Sep 2009 16:10:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: FlorianSchandinat@gmx.de, JosephChan@via.com.tw, ScottFang@viatech.com.cn, corbet@lwn.net, laforge@gnumonks.org, mm-commits@vger.kernel.org


The patch titled
     viafb: fix ioremap_nocache error handling
has been removed from the -mm tree.  Its filename was
     viafb-fix-ioremap_nocache-error-handling.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
Cc: Harald Welte <laforge@gnumonks.org>
Cc: Jonathan Corbet <corbet@lwn.net>
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

origin.patch

