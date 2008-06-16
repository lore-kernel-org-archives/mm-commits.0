From: akpm@linux-foundation.org
Subject: - driver-video-cirrusfb-fix-ram-address-printk.patch removed from -mm tree
Date: Sun, 15 Jun 2008 23:03:50 -0700
Message-ID: <200806160603.m5G63oT3010626@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40561 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751146AbYFPGDx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 16 Jun 2008 02:03:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: phdm@macqel.be, jirislaby@gmail.com, mm-commits@vger.kernel.org


The patch titled
     drivers/video/cirrusfb: fix RAM address printk
has been removed from the -mm tree.  Its filename was
     driver-video-cirrusfb-fix-ram-address-printk.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/video/cirrusfb: fix RAM address printk
From: Philippe De Muyter <phdm@macqel.be>

In the cirrusfb driver, the RAM address printk has a superfluous 'x' that
could be interpreted as "don't care", while it is actually a typo.  Fix
that.

[akpm@linux-foundation.org: join the two printk strings to make it atomic]
Signed-off-by: Philippe De Muyter <phdm@macqel.be>
Cc: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/cirrusfb.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN drivers/video/cirrusfb.c~driver-video-cirrusfb-fix-ram-address-printk drivers/video/cirrusfb.c
--- a/drivers/video/cirrusfb.c~driver-video-cirrusfb-fix-ram-address-printk
+++ a/drivers/video/cirrusfb.c
@@ -2432,9 +2432,9 @@ static int cirrusfb_pci_register(struct 
 	info->screen_size = board_size;
 	cinfo->unmap = cirrusfb_pci_unmap;
 
-	printk(KERN_INFO " RAM (%lu kB) at 0xx%lx, ",
-		info->screen_size >> 10, board_addr);
-	printk(KERN_INFO "Cirrus Logic chipset on PCI bus\n");
+	printk(KERN_INFO "RAM (%lu kB) at 0x%lx, Cirrus "
+			"Logic chipset on PCI bus\n",
+			info->screen_size >> 10, board_addr);
 	pci_set_drvdata(pdev, info);
 
 	ret = cirrusfb_register(info);
_

Patches currently in -mm which might be from phdm@macqel.be are

origin.patch

