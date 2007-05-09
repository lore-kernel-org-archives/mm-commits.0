From: akpm@linux-foundation.org
Subject: - parport-dev-driver-model-support.patch removed from -mm tree
Date: Tue, 08 May 2007 19:47:50 -0700
Message-ID: <200705090247.l492loI7009023@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:39447 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1032101AbXEICsD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 22:48:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: david-b@pacbell.net, benh@kernel.crashing.org, dbrownell@users.sourceforge.net, paulus@samba.org, mm-commits@vger.kernel.org


The patch titled
     parport->dev driver model support
has been removed from the -mm tree.  Its filename was
     parport-dev-driver-model-support.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: parport->dev driver model support
From: David Brownell <david-b@pacbell.net>

Currently a parport_driver can't get a handle on the device node for the
underlying parport (PNPACPI, PCI, etc).  That prevents correct placement of
sysfs child nodes, which can affect things like power management.

This patch adds a field to "struct parport" pointing to that device node, and
updates non-legacy port drivers to initialize that device pointer.  That field
replaces the analagous PCI-only support in parport_pc.

[akpm@linux-foundation.org: fix powerpc build]
Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/parport/parport_cs.c     |    2 -
 drivers/parport/parport_mfc3.c   |    1 
 drivers/parport/parport_pc.c     |   31 +++++++++++++++--------------
 drivers/parport/parport_serial.c |    2 -
 drivers/parport/parport_sunbpp.c |    1 
 drivers/parport/share.c          |    5 ++++
 include/asm-powerpc/parport.h    |    5 ----
 include/linux/parport.h          |    8 +++++--
 include/linux/parport_pc.h       |    3 --
 9 files changed, 33 insertions(+), 25 deletions(-)

diff -puN drivers/parport/parport_cs.c~parport-dev-driver-model-support drivers/parport/parport_cs.c
--- a/drivers/parport/parport_cs.c~parport-dev-driver-model-support
+++ a/drivers/parport/parport_cs.c
@@ -201,7 +201,7 @@ static int parport_config(struct pcmcia_
 
     p = parport_pc_probe_port(link->io.BasePort1, link->io.BasePort2,
 			      link->irq.AssignedIRQ, PARPORT_DMA_NONE,
-			      NULL);
+			      &link->dev);
     if (p == NULL) {
 	printk(KERN_NOTICE "parport_cs: parport_pc_probe_port() at "
 	       "0x%3x, irq %u failed\n", link->io.BasePort1,
diff -puN drivers/parport/parport_mfc3.c~parport-dev-driver-model-support drivers/parport/parport_mfc3.c
--- a/drivers/parport/parport_mfc3.c~parport-dev-driver-model-support
+++ a/drivers/parport/parport_mfc3.c
@@ -356,6 +356,7 @@ static int __init parport_mfc3_init(void
 				if (request_irq(IRQ_AMIGA_PORTS, mfc3_interrupt, IRQF_SHARED, p->name, &pp_mfc3_ops))
 					goto out_irq;
 		}
+		p->dev = &z->dev;
 
 		this_port[pias++] = p;
 		printk(KERN_INFO "%s: Multiface III port using irq\n", p->name);
diff -puN drivers/parport/parport_pc.c~parport-dev-driver-model-support drivers/parport/parport_pc.c
--- a/drivers/parport/parport_pc.c~parport-dev-driver-model-support
+++ a/drivers/parport/parport_pc.c
@@ -620,6 +620,7 @@ static size_t parport_pc_fifo_write_bloc
 	unsigned long dmaflag;
 	size_t left = length;
 	const struct parport_pc_private *priv = port->physport->private_data;
+	struct device *dev = port->physport->dev;
 	dma_addr_t dma_addr, dma_handle;
 	size_t maxlen = 0x10000; /* max 64k per DMA transfer */
 	unsigned long start = (unsigned long) buf;
@@ -631,8 +632,8 @@ dump_parport_state ("enter fifo_write_bl
 		if ((start ^ end) & ~0xffffUL)
 			maxlen = 0x10000 - (start & 0xffff);
 
-		dma_addr = dma_handle = pci_map_single(priv->dev, (void *)buf, length,
-						       PCI_DMA_TODEVICE);
+		dma_addr = dma_handle = dma_map_single(dev, (void *)buf, length,
+						       DMA_TO_DEVICE);
         } else {
 		/* above 16 MB we use a bounce buffer as ISA-DMA is not possible */
 		maxlen   = PAGE_SIZE;          /* sizeof(priv->dma_buf) */
@@ -728,9 +729,9 @@ dump_parport_state ("enter fifo_write_bl
 
 	/* Turn off DMA mode */
 	frob_econtrol (port, 1<<3, 0);
-	
+
 	if (dma_handle)
-		pci_unmap_single(priv->dev, dma_handle, length, PCI_DMA_TODEVICE);
+		dma_unmap_single(dev, dma_handle, length, DMA_TO_DEVICE);
 
 dump_parport_state ("leave fifo_write_block_dma", port);
 	return length - left;
@@ -2146,7 +2147,7 @@ static DEFINE_SPINLOCK(ports_lock);
 struct parport *parport_pc_probe_port (unsigned long int base,
 				       unsigned long int base_hi,
 				       int irq, int dma,
-				       struct pci_dev *dev)
+				       struct device *dev)
 {
 	struct parport_pc_private *priv;
 	struct parport_operations *ops;
@@ -2180,9 +2181,10 @@ struct parport *parport_pc_probe_port (u
 	priv->fifo_depth = 0;
 	priv->dma_buf = NULL;
 	priv->dma_handle = 0;
-	priv->dev = dev;
 	INIT_LIST_HEAD(&priv->list);
 	priv->port = p;
+
+	p->dev = dev;
 	p->base_hi = base_hi;
 	p->modes = PARPORT_MODE_PCSPP | PARPORT_MODE_SAFEININT;
 	p->private_data = priv;
@@ -2305,9 +2307,10 @@ struct parport *parport_pc_probe_port (u
 				p->dma = PARPORT_DMA_NONE;
 			} else {
 				priv->dma_buf =
-				  pci_alloc_consistent(priv->dev,
+				  dma_alloc_coherent(dev,
 						       PAGE_SIZE,
-						       &priv->dma_handle);
+						       &priv->dma_handle,
+						       GFP_KERNEL);
 				if (! priv->dma_buf) {
 					printk (KERN_WARNING "%s: "
 						"cannot get buffer for DMA, "
@@ -2383,7 +2386,7 @@ void parport_pc_unregister_port (struct 
 		release_region(p->base_hi, 3);
 #if defined(CONFIG_PARPORT_PC_FIFO) && defined(HAS_DMA)
 	if (priv->dma_buf)
-		pci_free_consistent(priv->dev, PAGE_SIZE,
+		dma_free_coherent(p->physport->dev, PAGE_SIZE,
 				    priv->dma_buf,
 				    priv->dma_handle);
 #endif
@@ -2489,7 +2492,7 @@ static int __devinit sio_ite_8872_probe 
 	 */
 	release_resource(base_res);
 	if (parport_pc_probe_port (ite8872_lpt, ite8872_lpthi,
-				   irq, PARPORT_DMA_NONE, NULL)) {
+				   irq, PARPORT_DMA_NONE, &pdev->dev)) {
 		printk (KERN_INFO
 			"parport_pc: ITE 8872 parallel port: io=0x%X",
 			ite8872_lpt);
@@ -2672,7 +2675,7 @@ static int __devinit sio_via_probe (stru
 	}
 
 	/* finally, do the probe with values obtained */
-	if (parport_pc_probe_port (port1, port2, irq, dma, NULL)) {
+	if (parport_pc_probe_port (port1, port2, irq, dma, &pdev->dev)) {
 		printk (KERN_INFO
 			"parport_pc: VIA parallel port: io=0x%X", port1);
 		if (irq != PARPORT_IRQ_NONE)
@@ -2970,7 +2973,7 @@ static int parport_pc_pci_probe (struct 
 			parport_pc_pci_tbl[i + last_sio].device, io_lo, io_hi);
 		data->ports[count] =
 			parport_pc_probe_port (io_lo, io_hi, PARPORT_IRQ_NONE,
-					       PARPORT_DMA_NONE, dev);
+					       PARPORT_DMA_NONE, &dev->dev);
 		if (data->ports[count])
 			count++;
 	}
@@ -3077,8 +3080,8 @@ static int parport_pc_pnp_probe(struct p
 	} else
 		dma = PARPORT_DMA_NONE;
 
-	printk(KERN_INFO "parport: PnPBIOS parport detected.\n");
-	if (!(pdata = parport_pc_probe_port (io_lo, io_hi, irq, dma, NULL)))
+	dev_info(&dev->dev, "reported by %s\n", dev->protocol->name);
+	if (!(pdata = parport_pc_probe_port (io_lo, io_hi, irq, dma, &dev->dev)))
 		return -ENODEV;
 
 	pnp_set_drvdata(dev,pdata);
diff -puN drivers/parport/parport_serial.c~parport-dev-driver-model-support drivers/parport/parport_serial.c
--- a/drivers/parport/parport_serial.c~parport-dev-driver-model-support
+++ a/drivers/parport/parport_serial.c
@@ -305,7 +305,7 @@ static int __devinit parport_register (s
 		dev_dbg(&dev->dev, "PCI parallel port detected: I/O at "
 			"%#lx(%#lx)\n", io_lo, io_hi);
 		port = parport_pc_probe_port (io_lo, io_hi, PARPORT_IRQ_NONE,
-					      PARPORT_DMA_NONE, dev);
+					      PARPORT_DMA_NONE, &dev->dev);
 		if (port) {
 			priv->port[priv->num_par++] = port;
 			success = 1;
diff -puN drivers/parport/parport_sunbpp.c~parport-dev-driver-model-support drivers/parport/parport_sunbpp.c
--- a/drivers/parport/parport_sunbpp.c~parport-dev-driver-model-support
+++ a/drivers/parport/parport_sunbpp.c
@@ -322,6 +322,7 @@ static int __devinit init_one_port(struc
 		goto out_free_ops;
 
 	p->size = size;
+	p->dev = &sdev->ofdev.dev;
 
 	if ((err = request_irq(p->irq, parport_sunbpp_interrupt,
 			       IRQF_SHARED, p->name, p)) != 0) {
diff -puN drivers/parport/share.c~parport-dev-driver-model-support drivers/parport/share.c
--- a/drivers/parport/share.c~parport-dev-driver-model-support
+++ a/drivers/parport/share.c
@@ -365,6 +365,11 @@ void parport_announce_port (struct parpo
 	parport_daisy_init(port);
 #endif
 
+	if (!port->dev)
+		printk(KERN_WARNING "%s: fix this legacy "
+				"no-device port driver!\n",
+				port->name);
+
 	parport_proc_register(port);
 	mutex_lock(&registration_lock);
 	spin_lock_irq(&parportlist_lock);
diff -puN include/asm-powerpc/parport.h~parport-dev-driver-model-support include/asm-powerpc/parport.h
--- a/include/asm-powerpc/parport.h~parport-dev-driver-model-support
+++ a/include/asm-powerpc/parport.h
@@ -12,11 +12,6 @@
 
 #include <asm/prom.h>
 
-extern struct parport *parport_pc_probe_port (unsigned long int base,
-                                              unsigned long int base_hi,
-                                              int irq, int dma,
-                                              struct pci_dev *dev);
-
 static int __devinit parport_pc_find_nonpci_ports (int autoirq, int autodma)
 {
 	struct device_node *np;
diff -puN include/linux/parport.h~parport-dev-driver-model-support include/linux/parport.h
--- a/include/linux/parport.h~parport-dev-driver-model-support
+++ a/include/linux/parport.h
@@ -279,6 +279,10 @@ struct parport {
 	int dma;
 	int muxport;		/* which muxport (if any) this is */
 	int portnum;		/* which physical parallel port (not mux) */
+	struct device *dev;	/* Physical device associated with IO/DMA.
+				 * This may unfortulately be null if the
+				 * port has a legacy driver.
+				 */
 
 	struct parport *physport;
 				/* If this is a non-default mux
@@ -289,7 +293,7 @@ struct parport {
 				   following structure members are
 				   meaningless: devices, cad, muxsel,
 				   waithead, waittail, flags, pdir,
-				   ieee1284, *_lock.
+				   dev, ieee1284, *_lock.
 
 				   It this is a default mux parport, or
 				   there is no mux involved, this points to
@@ -302,7 +306,7 @@ struct parport {
 
 	struct pardevice *waithead;
 	struct pardevice *waittail;
-	
+
 	struct list_head list;
 	unsigned int flags;
 
diff -puN include/linux/parport_pc.h~parport-dev-driver-model-support include/linux/parport_pc.h
--- a/include/linux/parport_pc.h~parport-dev-driver-model-support
+++ a/include/linux/parport_pc.h
@@ -38,7 +38,6 @@ struct parport_pc_private {
 	/* buffer suitable for DMA, if DMA enabled */
 	char *dma_buf;
 	dma_addr_t dma_handle;
-	struct pci_dev *dev;
 	struct list_head list;
 	struct parport *port;
 };
@@ -232,7 +231,7 @@ extern int parport_pc_claim_resources(st
 extern struct parport *parport_pc_probe_port (unsigned long base,
 					      unsigned long base_hi,
 					      int irq, int dma,
-					      struct pci_dev *dev);
+					      struct device *dev);
 extern void parport_pc_unregister_port (struct parport *p);
 
 #endif
_

Patches currently in -mm which might be from david-b@pacbell.net are

origin.patch
acpi-driver-model-flags-and-platform_enable_wake.patch
update-documentation-driver-model-platformtxt.patch
use-common-cpu_is_xxx-macros-on-at91-and-avr32.patch
atmel_spi-remove-unnecessary-and-wrong-ifdefs.patch
