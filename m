From: akpm@linux-foundation.org
Subject: - pata_cmd64x-correct-the-speed-ranges.patch removed from -mm tree
Date: Mon, 06 Aug 2007 00:53:15 -0700
Message-ID: <200708060753.l767rFv3016322@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43331 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754726AbXHFHxe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 6 Aug 2007 03:53:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alan@lxorguk.ukuu.org.uk, alan@redhat.com, sshtylyov@ru.mvista.com, mm-commits@vger.kernel.org


The patch titled
     pata_cmd64x: correct the speed ranges
has been removed from the -mm tree.  Its filename was
     pata_cmd64x-correct-the-speed-ranges.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: pata_cmd64x: correct the speed ranges
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

I must have been half asleep when doing the original code.

Signed-off-by: Alan Cox <alan@redhat.com>
Acked-by: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ata/pata_cmd64x.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN drivers/ata/pata_cmd64x.c~pata_cmd64x-correct-the-speed-ranges drivers/ata/pata_cmd64x.c
--- a/drivers/ata/pata_cmd64x.c~pata_cmd64x-correct-the-speed-ranges
+++ a/drivers/ata/pata_cmd64x.c
@@ -31,7 +31,7 @@
 #include <linux/libata.h>
 
 #define DRV_NAME "pata_cmd64x"
-#define DRV_VERSION "0.2.3"
+#define DRV_VERSION "0.2.4"
 
 /*
  * CMD64x specific registers definition.
@@ -397,7 +397,7 @@ static int cmd64x_init_one(struct pci_de
 			.flags = ATA_FLAG_SLAVE_POSS,
 			.pio_mask = 0x1f,
 			.mwdma_mask = 0x07,
-			.udma_mask = ATA_UDMA1,
+			.udma_mask = ATA_UDMA2,
 			.port_ops = &cmd64x_port_ops
 		},
 		{	/* CMD 646 rev 1  */
@@ -412,7 +412,7 @@ static int cmd64x_init_one(struct pci_de
 			.flags = ATA_FLAG_SLAVE_POSS,
 			.pio_mask = 0x1f,
 			.mwdma_mask = 0x07,
-			.udma_mask = ATA_UDMA2,
+			.udma_mask = ATA_UDMA4,
 			.port_ops = &cmd648_port_ops
 		},
 		{	/* CMD 649 */
@@ -420,7 +420,7 @@ static int cmd64x_init_one(struct pci_de
 			.flags = ATA_FLAG_SLAVE_POSS,
 			.pio_mask = 0x1f,
 			.mwdma_mask = 0x07,
-			.udma_mask = ATA_UDMA3,
+			.udma_mask = ATA_UDMA5,
 			.port_ops = &cmd648_port_ops
 		}
 	};
_

Patches currently in -mm which might be from alan@lxorguk.ukuu.org.uk are

nozomi-shoot-defunct-label.patch
git-libata-all.patch
pata_acpi-rework-the-acpi-drivers-based-upon-experience.patch
libata-add-irq_flags-to-struct-pata_platform_info-fix.patch
libata-acpi-checks-for-80wire-cable-headers.patch
libata-acpi-checks-for-80wire-cable-implementation.patch
libata-acpi-checks-for-80wire-cable-use-in-pata_amd.patch
libata-acpi-checks-for-80wire-cable-use-in-pata_via.patch
libata-correct-iordy-handling.patch
libata-fix-hopefully-all-the-remaining-problems-with.patch
tty-add-the-new-ioctls-and-definitionto-the-mips.patch
add-blacklisting-capability-to-serial_pci-to-avoid-misdetection.patch
add-blacklisting-capability-to-serial_pci-to-avoid-misdetection-fix.patch
dtc-clean-up-indent-damage-and-add-printk-levels.patch
kl5kusb105-switch-to-new-speed-api.patch
mct_u232-convert-to-proper-speed-handling-api-fix.patch
geode-mfgpt-support-for-geode-class-machines.patch
geode-mfgpt-clock-event-device-support.patch
xtensa-enable-arbitary-tty-speed-setting-ioctls.patch
usb-serial-fix-oti6858c-segfault-in-termios-handling.patch
blackfin-enable-arbitary-speed-serial-setting.patch
char-cyclades-remove-bottom-half-processing.patch
