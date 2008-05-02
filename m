From: akpm@linux-foundation.org
Subject: - 8250-switch-8250-drivers-to-use-_nocache-ioremaps.patch removed from -mm tree
Date: Fri, 02 May 2008 12:42:54 -0700
Message-ID: <200805021942.m42JgsTO011238@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57119 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932449AbYEBToD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 2 May 2008 15:44:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alan@lxorguk.ukuu.org.uk, alan@redhat.com, mingo@elte.hu, rmk@arm.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     8250: switch 8250 drivers to use _nocache ioremaps
has been removed from the -mm tree.  Its filename was
     8250-switch-8250-drivers-to-use-_nocache-ioremaps.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: 8250: switch 8250 drivers to use _nocache ioremaps
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

Signed-off-by: Alan Cox <alan@redhat.com>
Cc: Russell King <rmk@arm.linux.org.uk>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/serial/8250.c       |    3 ++-
 drivers/serial/8250_early.c |    2 +-
 drivers/serial/8250_pci.c   |   14 ++++++++------
 3 files changed, 11 insertions(+), 8 deletions(-)

diff -puN drivers/serial/8250.c~8250-switch-8250-drivers-to-use-_nocache-ioremaps drivers/serial/8250.c
--- a/drivers/serial/8250.c~8250-switch-8250-drivers-to-use-_nocache-ioremaps
+++ a/drivers/serial/8250.c
@@ -2271,7 +2271,8 @@ static int serial8250_request_std_resour
 		}
 
 		if (up->port.flags & UPF_IOREMAP) {
-			up->port.membase = ioremap(up->port.mapbase, size);
+			up->port.membase = ioremap_nocache(up->port.mapbase,
+									size);
 			if (!up->port.membase) {
 				release_mem_region(up->port.mapbase, size);
 				ret = -ENOMEM;
diff -puN drivers/serial/8250_early.c~8250-switch-8250-drivers-to-use-_nocache-ioremaps drivers/serial/8250_early.c
--- a/drivers/serial/8250_early.c~8250-switch-8250-drivers-to-use-_nocache-ioremaps
+++ a/drivers/serial/8250_early.c
@@ -153,7 +153,7 @@ static int __init parse_options(struct e
 			(void __iomem *)__fix_to_virt(FIX_EARLYCON_MEM_BASE);
 		port->membase += port->mapbase & ~PAGE_MASK;
 #else
-		port->membase = ioremap(port->mapbase, 64);
+		port->membase = ioremap_nocache(port->mapbase, 64);
 		if (!port->membase) {
 			printk(KERN_ERR "%s: Couldn't ioremap 0x%llx\n",
 				__func__,
diff -puN drivers/serial/8250_pci.c~8250-switch-8250-drivers-to-use-_nocache-ioremaps drivers/serial/8250_pci.c
--- a/drivers/serial/8250_pci.c~8250-switch-8250-drivers-to-use-_nocache-ioremaps
+++ a/drivers/serial/8250_pci.c
@@ -86,7 +86,7 @@ setup_port(struct serial_private *priv, 
 		len =  pci_resource_len(dev, bar);
 
 		if (!priv->remapped_bar[bar])
-			priv->remapped_bar[bar] = ioremap(base, len);
+			priv->remapped_bar[bar] = ioremap_nocache(base, len);
 		if (!priv->remapped_bar[bar])
 			return -ENOMEM;
 
@@ -270,7 +270,7 @@ static int pci_plx9050_init(struct pci_d
 	/*
 	 * enable/disable interrupts
 	 */
-	p = ioremap(pci_resource_start(dev, 0), 0x80);
+	p = ioremap_nocache(pci_resource_start(dev, 0), 0x80);
 	if (p == NULL)
 		return -ENOMEM;
 	writel(irq_config, p + 0x4c);
@@ -294,7 +294,7 @@ static void __devexit pci_plx9050_exit(s
 	/*
 	 * disable interrupts
 	 */
-	p = ioremap(pci_resource_start(dev, 0), 0x80);
+	p = ioremap_nocache(pci_resource_start(dev, 0), 0x80);
 	if (p != NULL) {
 		writel(0, p + 0x4c);
 
@@ -341,7 +341,8 @@ static int sbs_init(struct pci_dev *dev)
 {
 	u8 __iomem *p;
 
-	p = ioremap(pci_resource_start(dev, 0), pci_resource_len(dev, 0));
+	p = ioremap_nocache(pci_resource_start(dev, 0),
+						pci_resource_len(dev, 0));
 
 	if (p == NULL)
 		return -ENOMEM;
@@ -365,7 +366,8 @@ static void __devexit sbs_exit(struct pc
 {
 	u8 __iomem *p;
 
-	p = ioremap(pci_resource_start(dev, 0), pci_resource_len(dev, 0));
+	p = ioremap_nocache(pci_resource_start(dev, 0),
+					pci_resource_len(dev, 0));
 	/* FIXME: What if resource_len < OCT_REG_CR_OFF */
 	if (p != NULL)
 		writeb(0, p + OCT_REG_CR_OFF);
@@ -419,7 +421,7 @@ static int pci_siig10x_init(struct pci_d
 		break;
 	}
 
-	p = ioremap(pci_resource_start(dev, 0), 0x80);
+	p = ioremap_nocache(pci_resource_start(dev, 0), 0x80);
 	if (p == NULL)
 		return -ENOMEM;
 
_

Patches currently in -mm which might be from alan@lxorguk.ukuu.org.uk are

origin.patch
git-gfs2-nmw.patch
add-time_is_after_jiffies-and-others-which-compare-with-jiffies.patch
pata_atiixp-simplex-clear.patch
pata_atiixp-dont-disable.patch
8390-split-8390-support-into-a-pausing-and-a-non-pausing-driver-core.patch
parisc-new-termios-definitions.patch
git-scsi-misc.patch
sxc-fix-printk-warnings-on-sparc32.patch
put_pid-make-sure-we-dont-free-the-live-pid.patch

