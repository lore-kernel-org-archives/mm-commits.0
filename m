From: akpm@linux-foundation.org
Subject: - pnp-use-dev_printk-for-quirk-messages.patch removed from -mm tree
Date: Mon, 28 Apr 2008 15:00:10 -0700
Message-ID: <200804282200.m3SM0A26018670@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44729 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965543AbYD1WAT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Apr 2008 18:00:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bjorn.helgaas@hp.com, ambx1@neo.rr.com, mm-commits@vger.kernel.org


The patch titled
     PNP: use dev_printk for quirk messages
has been removed from the -mm tree.  Its filename was
     pnp-use-dev_printk-for-quirk-messages.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: PNP: use dev_printk for quirk messages
From: Bjorn Helgaas <bjorn.helgaas@hp.com>

Convert quirk printks to dev_printk().

[akpm@linux-foundation.org: fix warnings, improve output text]
Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Adam Belay <ambx1@neo.rr.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pnp/quirks.c |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff -puN drivers/pnp/quirks.c~pnp-use-dev_printk-for-quirk-messages drivers/pnp/quirks.c
--- a/drivers/pnp/quirks.c~pnp-use-dev_printk-for-quirk-messages
+++ a/drivers/pnp/quirks.c
@@ -49,8 +49,11 @@ static void quirk_awe32_resources(struct
 		port2->max += 0x400;
 		port3->min += 0x800;
 		port3->max += 0x800;
+		dev_info(&dev->dev,
+			"AWE32 quirk - added ioports 0x%lx and 0x%lx\n",
+			(unsigned long)port2->min,
+			(unsigned long)port3->min);
 	}
-	printk(KERN_INFO "pnp: AWE32 quirk - adding two ports\n");
 }
 
 static void quirk_cmi8330_resources(struct pnp_dev *dev)
@@ -73,7 +76,8 @@ static void quirk_cmi8330_resources(stru
 			    IORESOURCE_DMA_8BIT)
 				dma->map = 0x000A;
 	}
-	printk(KERN_INFO "pnp: CMI8330 quirk - fixing interrupts and dma\n");
+	dev_info(&dev->dev, "CMI8330 quirk - forced possible IRQs to 5, 7, 10 "
+		"and DMA channels to 1, 3\n");
 }
 
 static void quirk_sb16audio_resources(struct pnp_dev *dev)
@@ -104,8 +108,7 @@ static void quirk_sb16audio_resources(st
 		changed = 1;
 	}
 	if (changed)
-		printk(KERN_INFO
-		       "pnp: SB audio device quirk - increasing port range\n");
+		dev_info(&dev->dev, "SB audio device quirk - increased port range\n");
 }
 
 
_

Patches currently in -mm which might be from bjorn.helgaas@hp.com are

origin.patch
mm-only-enforce-acpi-resource-conflict-checks.patch
smsc-ircc2-wrap-pnp-probe-code-in-ifdef-config_pnp.patch
nsc-ircc-wrap-pnp-probe-code-in-ifdef-config_pnp.patch
simplify-initcall_debug-output.patch
proc-introduce-proc_create_data-to-setup-de-data.patch
drivers-use-non-racy-method-for-proc-entries-creation-2.patch
parport_pc-wrap-pnp-probe-code-in-ifdef-config_pnp.patch
tpm-change-kconfig-dependencies-from-pnpacpi-to-pnp.patch

