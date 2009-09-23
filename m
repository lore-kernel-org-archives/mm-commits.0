From: akpm@linux-foundation.org
Subject: [merged] viafb-pass-reference-to-pci-device-when-calling-framebuffer_alloc.patch removed from -mm tree
Date: Wed, 23 Sep 2009 13:02:40 -0700
Message-ID: <200909232002.n8NK2edb017625@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57234 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752895AbZIWUKN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Sep 2009 16:10:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: laforge@gnumonks.org, FlorianSchandinat@gmx.de, HaraldWelte@viatech.com, JosephChan@via.com.tw, ScottFang@viatech.com.cn, corbet@lwn.net, mm-commits@vger.kernel.org


The patch titled
     viafb: pass reference to pci device when calling framebuffer_alloc()
has been removed from the -mm tree.  Its filename was
     viafb-pass-reference-to-pci-device-when-calling-framebuffer_alloc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch

