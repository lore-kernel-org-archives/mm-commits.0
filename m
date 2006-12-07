From: akpm@osdl.org
Subject: - ioremap-balanced-with-iounmap-for-drivers-char-moxac.patch removed from -mm tree
Date: Thu, 07 Dec 2006 15:00:54 -0800
Message-ID: <200612072300.kB7N0s8q029681@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:51401 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1163628AbWLGXBH (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 7 Dec 2006 18:01:07 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: amol@verismonetworks.com, alan@redhat.com, mm-commits@vger.kernel.org


The patch titled
     ioremap balanced with iounmap for drivers/char/moxa.c
has been removed from the -mm tree.  Its filename was
     ioremap-balanced-with-iounmap-for-drivers-char-moxac.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: ioremap balanced with iounmap for drivers/char/moxa.c
From: Amol Lad <amol@verismonetworks.com>

Signed-off-by: Amol Lad <amol@verismonetworks.com>
Acked-by: Alan Cox <alan@redhat.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/char/moxa.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff -puN drivers/char/moxa.c~ioremap-balanced-with-iounmap-for-drivers-char-moxac drivers/char/moxa.c
--- a/drivers/char/moxa.c~ioremap-balanced-with-iounmap-for-drivers-char-moxac
+++ a/drivers/char/moxa.c
@@ -498,9 +498,12 @@ static void __exit moxa_exit(void)
 		printk("Couldn't unregister MOXA Intellio family serial driver\n");
 	put_tty_driver(moxaDriver);
 
-	for (i = 0; i < MAX_BOARDS; i++)
+	for (i = 0; i < MAX_BOARDS; i++) {
+		if (moxaBaseAddr[i])
+			iounmap(moxaBaseAddr[i]);
 		if (moxa_boards[i].busType == MOXA_BUS_TYPE_PCI)
 			pci_dev_put(moxa_boards[i].pciInfo.pdev);
+	}
 
 	if (verbose)
 		printk("Done\n");
_

Patches currently in -mm which might be from amol@verismonetworks.com are

origin.patch
git-cpufreq.patch
drivers-scsi-ncr5380c-replacing-yield-with-a.patch
drivers-scsi-megaraidc-replacing-yield-with-a.patch
drivers-scsi-mca_53c9xc-save_flags-cli-removal.patch
drivers-isdn-handcrafted-min-max-macro-removal.patch
drivers-isdn-handcrafted-min-max-macro-removal-fix.patch
ioremap-balanced-with-iounmap-for-drivers-video-virgefb.patch
ioremap-balanced-with-iounmap-for-drivers-video-vesafb.patch
ioremap-balanced-with-iounmap-for-drivers-video-tridentfb.patch
ioremap-balanced-with-iounmap-for-drivers-video-tgafb.patch
ioremap-balanced-with-iounmap-for-drivers-video-stifb.patch
ioremap-balanced-with-iounmap-for-drivers-video-retz3fb.patch
ioremap-balanced-with-iounmap-for-drivers-video-pvr2fb.patch
ioremap-balanced-with-iounmap-for-drivers-video-platinumfb.patch
ioremap-balanced-with-iounmap-for-drivers-video-offb.patch
ioremap-balanced-with-iounmap-for-drivers-video-macfb.patch
ioremap-balanced-with-iounmap-for-drivers-video-hpfb.patch
ioremap-balanced-with-iounmap-for-drivers-video-fm2fb.patch
ioremap-balanced-with-iounmap-for-drivers-video-ffb.patch
ioremap-balanced-with-iounmap-for-drivers-video-cyberfb.patch
ioremap-balanced-with-iounmap-for-drivers-video-cirrusfb.patch
ioremap-balanced-with-iounmap-for-drivers-video-atyfb_base.patch
ioremap-balanced-with-iounmap-for-drivers-video-atafb.patch
ioremap-balanced-with-iounmap-for-drivers-video-amifb.patch
ioremap-balanced-with-iounmap-for-drivers-video-S3triofb.patch

