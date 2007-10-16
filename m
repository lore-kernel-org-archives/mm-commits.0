From: akpm@linux-foundation.org
Subject: - pcmcia-compactflash-driver-for-pa-semi-electra-boards-fix.patch removed from -mm tree
Date: Tue, 16 Oct 2007 15:02:58 -0700
Message-ID: <200710162202.l9GM2xRI019832@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40334 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1765838AbXJPWDD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Oct 2007 18:03:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: olof@lixom.net, benh@kernel.crashing.org, mm-commits@vger.kernel.org


The patch titled
     pcmcia: updates to electra_cf driver
has been removed from the -mm tree.  Its filename was
     pcmcia-compactflash-driver-for-pa-semi-electra-boards-fix.patch

This patch was dropped because it was folded into pcmcia-compactflash-driver-for-pa-semi-electra-boards.patch

------------------------------------------------------
Subject: pcmcia: updates to electra_cf driver
From: Olof Johansson <olof@lixom.net>

Fix build of electra_cf, since the IO space setup interfaces were
changed when BenH rewrote it.

Also clean it up a bit, add 5V support, make it unloadable, remove some
dead variables, etc.

Signed-off-by: Olof Johansson <olof@lixom.net>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pcmcia/Kconfig      |    4 +--
 drivers/pcmcia/electra_cf.c |   38 ++++++++++++++++++++--------------
 2 files changed, 25 insertions(+), 17 deletions(-)

diff -puN drivers/pcmcia/Kconfig~pcmcia-compactflash-driver-for-pa-semi-electra-boards-fix drivers/pcmcia/Kconfig
--- a/drivers/pcmcia/Kconfig~pcmcia-compactflash-driver-for-pa-semi-electra-boards-fix
+++ a/drivers/pcmcia/Kconfig
@@ -256,8 +256,8 @@ config AT91_CF
 	  Or choose M to compile the driver as a module named "at91_cf".
 
 config ELECTRA_CF
-	bool "Electra CompactFlash Controller"
-	depends on PCMCIA=y && PPC_PASEMI
+	tristate "Electra CompactFlash Controller"
+	depends on PCMCIA && PPC_PASEMI
 	help
 	  Say Y here to support the CompactFlash controller on the
 	  PA Semi Electra eval board.
diff -puN drivers/pcmcia/electra_cf.c~pcmcia-compactflash-driver-for-pa-semi-electra-boards-fix drivers/pcmcia/electra_cf.c
--- a/drivers/pcmcia/electra_cf.c~pcmcia-compactflash-driver-for-pa-semi-electra-boards-fix
+++ a/drivers/pcmcia/electra_cf.c
@@ -28,6 +28,7 @@
 #include <linux/init.h>
 #include <linux/delay.h>
 #include <linux/interrupt.h>
+#include <linux/vmalloc.h>
 
 #include <pcmcia/ss.h>
 #include <asm/of_platform.h>
@@ -105,10 +106,8 @@ static int electra_cf_get_status(struct 
 
 	/* NOTE CF is always 3VCARD */
 	if (electra_cf_present(cf)) {
-		struct electra_cf_socket *cf;
-
 		*sp = SS_READY | SS_DETECT | SS_POWERON | SS_3VCARD;
-		cf = container_of(s, struct electra_cf_socket, socket);
+
 		s->pci_irq = cf->irq;
 	} else
 		*sp = 0;
@@ -134,8 +133,10 @@ static int electra_cf_set_socket(struct 
 	case 33:
 		gpio = (1 << cf->gpio_3v);
 		break;
+	case 5:
+		gpio = (1 << cf->gpio_5v);
+		break;
 	default:
-		/* CF is 3.3V only */
 		return -EINVAL;
 	}
 
@@ -188,6 +189,7 @@ static int __devinit electra_cf_probe(st
 	int status;
 	const unsigned int *prop;
 	int err;
+	struct vm_struct *area;
 
 	err = of_address_to_resource(np, 0, &mem);
 	if (err)
@@ -206,22 +208,27 @@ static int __devinit electra_cf_probe(st
 
 	cf->ofdev = ofdev;
 	cf->mem_phys = mem.start;
-	cf->mem_base = ioremap(mem.start, mem.end - mem.start);
+	cf->mem_size = PAGE_ALIGN(mem.end - mem.start);
+	cf->mem_base = ioremap(cf->mem_phys, cf->mem_size);
 	cf->io_size = PAGE_ALIGN(io.end - io.start);
 
-	cf->io_virt = reserve_phb_iospace(cf->io_size);
+	area = __get_vm_area(cf->io_size, 0, PHB_IO_BASE, PHB_IO_END);
+	if (area == NULL)
+		return -ENOMEM;
+
+	cf->io_virt = (void __iomem *)(area->addr);
 
 	cf->gpio_base = ioremap(0xfc103000, 0x1000);
 	dev_set_drvdata(device, cf);
 
-	if (!cf->mem_base || !cf->io_virt || !cf->gpio_base) {
+	if (!cf->mem_base || !cf->io_virt || !cf->gpio_base ||
+	    (__ioremap_at(io.start, cf->io_virt, cf->io_size,
+		_PAGE_NO_CACHE | _PAGE_GUARDED) == NULL)) {
 		dev_err(device, "can't ioremap ranges\n");
 		status = -ENOMEM;
 		goto fail1;
 	}
 
-	__ioremap_explicit(io.start, (unsigned long)cf->io_virt, cf->io_size,
-			   _PAGE_NO_CACHE | _PAGE_GUARDED);
 
 	cf->io_base = (unsigned long)cf->io_virt - VMALLOC_END;
 
@@ -263,8 +270,7 @@ static int __devinit electra_cf_probe(st
 	cf->socket.io_offset = cf->io_base;
 
 	/* reserve chip-select regions */
-	if (!request_mem_region(mem.start, mem.end + 1 - mem.start,
-				driver_name)) {
+	if (!request_mem_region(cf->mem_phys, cf->mem_size, driver_name)) {
 		status = -ENXIO;
 		dev_err(device, "Can't claim memory region\n");
 		goto fail1;
@@ -291,21 +297,22 @@ static int __devinit electra_cf_probe(st
 	}
 
 	dev_info(device, "at mem 0x%lx io 0x%lx irq %d\n",
-		 mem.start, io.start, cf->irq);
+		 cf->mem_phys, io.start, cf->irq);
 
 	cf->active = 1;
 	electra_cf_timer((unsigned long)cf);
 	return 0;
 
 fail3:
-	release_mem_region(io.start, io.end + 1 - io.start);
+	release_region(cf->io_base, cf->io_size);
 fail2:
-	release_mem_region(mem.start, mem.end + 1 - mem.start);
+	release_mem_region(cf->mem_phys, cf->mem_size);
 fail1:
 	if (cf->irq != NO_IRQ)
 		free_irq(cf->irq, cf);
 
-	/* XXX No way to undo the ioremap_explicit at this time */
+	if (cf->io_virt)
+		__iounmap_at(cf->io_virt, cf->io_size);
 	if (cf->mem_base)
 		iounmap(cf->mem_base);
 	if (cf->gpio_base)
@@ -328,6 +335,7 @@ static int __devexit electra_cf_remove(s
 	free_irq(cf->irq, cf);
 	del_timer_sync(&cf->timer);
 
+	__iounmap_at(cf->io_virt, cf->io_size);
 	iounmap(cf->mem_base);
 	iounmap(cf->gpio_base);
 	release_mem_region(cf->mem_phys, cf->mem_size);
_

Patches currently in -mm which might be from olof@lixom.net are

origin.patch
pcmcia-compactflash-driver-for-pa-semi-electra-boards.patch
pcmcia-compactflash-driver-for-pa-semi-electra-boards-fix.patch
