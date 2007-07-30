From: akpm@linux-foundation.org
Subject: + merge-the-sonics-silicon-backplane-subsystem-update.patch added to -mm tree
Date: Mon, 30 Jul 2007 14:23:08 -0700
Message-ID: <200707302123.l6ULNCK2031101@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42673 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S968338AbXG3VYp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 30 Jul 2007 17:24:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mb@bu3sch.de, linville@tuxdriver.com


The patch titled
     Merge the Sonics Silicon Backplane subsystem (update)
has been added to the -mm tree.  Its filename is
     merge-the-sonics-silicon-backplane-subsystem-update.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Merge the Sonics Silicon Backplane subsystem (update)
From: Michael Buesch <mb@bu3sch.de>

Signed-off-by: Michael Buesch <mb@bu3sch.de>
Acked-by: John Linville <linville@tuxdriver.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/Makefile                          |    2 
 drivers/ssb/Kconfig                       |    3 
 drivers/ssb/Makefile                      |   18 +
 drivers/ssb/driver_chipcommon.c           |   28 +-
 drivers/ssb/driver_mipscore.c             |   38 +--
 drivers/ssb/driver_pcicore.c              |   48 ++--
 drivers/ssb/main.c                        |  197 ++++++++++++--------
 drivers/ssb/pci.c                         |   16 +
 drivers/ssb/pcmcia.c                      |   12 -
 drivers/ssb/scan.c                        |   22 +-
 drivers/ssb/ssb_private.h                 |   31 ---
 include/linux/ssb/ssb.h                   |   30 ++-
 include/linux/ssb/ssb_driver_chipcommon.h |    2 
 include/linux/ssb/ssb_driver_extif.h      |    3 
 include/linux/ssb/ssb_driver_mips.h       |    3 
 include/linux/ssb/ssb_driver_pci.h        |    2 
 include/linux/ssb/ssb_regs.h              |   12 -
 17 files changed, 257 insertions(+), 210 deletions(-)

diff -puN drivers/Makefile~merge-the-sonics-silicon-backplane-subsystem-update drivers/Makefile
--- a/drivers/Makefile~merge-the-sonics-silicon-backplane-subsystem-update
+++ a/drivers/Makefile
@@ -47,7 +47,6 @@ obj-$(CONFIG_MTD)		+= mtd/
 obj-$(CONFIG_SPI)		+= spi/
 obj-$(CONFIG_PCCARD)		+= pcmcia/
 obj-$(CONFIG_DIO)		+= dio/
-obj-$(CONFIG_SSB)		+= ssb/
 obj-$(CONFIG_SBUS)		+= sbus/
 obj-$(CONFIG_KVM)		+= kvm/
 obj-$(CONFIG_ZORRO)		+= zorro/
@@ -91,3 +90,4 @@ obj-$(CONFIG_DCA)		+= dca/
 obj-$(CONFIG_HID)		+= hid/
 obj-$(CONFIG_PPC_PS3)		+= ps3/
 obj-$(CONFIG_OF)		+= of/
+obj-$(CONFIG_SSB)		+= ssb/
diff -puN drivers/ssb/Kconfig~merge-the-sonics-silicon-backplane-subsystem-update drivers/ssb/Kconfig
--- a/drivers/ssb/Kconfig~merge-the-sonics-silicon-backplane-subsystem-update
+++ a/drivers/ssb/Kconfig
@@ -2,7 +2,7 @@ menu "Sonics Silicon Backplane"
 
 config SSB
 	tristate "Sonics Silicon Backplane support"
-	depends on EXPERIMENTAL && HAS_IOMEM
+	depends on EXPERIMENTAL
 	help
 	  Support for the Sonics Silicon Backplane bus
 
@@ -58,7 +58,6 @@ config SSB_SERIAL
 config SSB_DRIVER_PCICORE
 	bool "SSB PCI core driver"
 	depends on SSB && SSB_PCIHOST
-	default y
 	help
 	  Driver for the Sonics Silicon Backplane attached
 	  Broadcom PCI core.
diff -puN drivers/ssb/Makefile~merge-the-sonics-silicon-backplane-subsystem-update drivers/ssb/Makefile
--- a/drivers/ssb/Makefile~merge-the-sonics-silicon-backplane-subsystem-update
+++ a/drivers/ssb/Makefile
@@ -1,11 +1,13 @@
-ssb-builtin-drivers-y					+= driver_chipcommon.o
-ssb-builtin-drivers-$(CONFIG_SSB_DRIVER_MIPS)		+= driver_mipscore.o
-ssb-builtin-drivers-$(CONFIG_SSB_DRIVER_PCICORE)	+= driver_pcicore.o
+# core
+ssb-y					+= main.o scan.o
 
-ssb-hostsupport-$(CONFIG_SSB_PCIHOST)			+= pci.o pcihost_wrapper.o
-ssb-hostsupport-$(CONFIG_SSB_PCMCIAHOST)		+= pcmcia.o
+# host support
+ssb-$(CONFIG_SSB_PCIHOST)		+= pci.o pcihost_wrapper.o
+ssb-$(CONFIG_SSB_PCMCIAHOST)		+= pcmcia.o
 
-obj-$(CONFIG_SSB) += ssb.o
+# built-in drivers
+ssb-y					+= driver_chipcommon.o
+ssb-$(CONFIG_SSB_DRIVER_MIPS)		+= driver_mipscore.o
+ssb-$(CONFIG_SSB_DRIVER_PCICORE)	+= driver_pcicore.o
 
-ssb-objs	:= main.o scan.o \
-		   $(ssb-hostsupport-y) $(ssb-builtin-drivers-y)
+obj-$(CONFIG_SSB)			+= ssb.o
diff -puN drivers/ssb/driver_chipcommon.c~merge-the-sonics-silicon-backplane-subsystem-update drivers/ssb/driver_chipcommon.c
--- a/drivers/ssb/driver_chipcommon.c~merge-the-sonics-silicon-backplane-subsystem-update
+++ a/drivers/ssb/driver_chipcommon.c
@@ -16,7 +16,7 @@
 
 
 /* Clock sources */
-enum {
+enum ssb_clksrc {
 	/* PCI clock */
 	SSB_CHIPCO_CLKSRC_PCI,
 	/* Crystal slow clock oscillator */
@@ -85,15 +85,15 @@ void ssb_chipco_set_clockmode(struct ssb
 			ssb_pci_xtal(bus, SSB_GPIO_XTAL, 0);
 		break;
 	default:
-		assert(0);
+		SSB_WARN_ON(1);
 	}
 }
 
 /* Get the Slow Clock Source */
-static int chipco_pctl_get_slowclksrc(struct ssb_chipcommon *cc)
+static enum ssb_clksrc chipco_pctl_get_slowclksrc(struct ssb_chipcommon *cc)
 {
 	struct ssb_bus *bus = cc->dev->bus;
-	u32 tmp = 0;
+	u32 uninitialized_var(tmp);
 
 	if (cc->dev->id.revision < 6) {
 		if (bus->bustype == SSB_BUSTYPE_SSB ||
@@ -123,9 +123,9 @@ static int chipco_pctl_get_slowclksrc(st
 /* Get maximum or minimum (depending on get_max flag) slowclock frequency. */
 static int chipco_pctl_clockfreqlimit(struct ssb_chipcommon *cc, int get_max)
 {
-	int limit;
-	int clocksrc;
-	int divisor;
+	int uninitialized_var(limit);
+	enum ssb_clksrc clocksrc;
+	int divisor = 1;
 	u32 tmp;
 
 	clocksrc = chipco_pctl_get_slowclksrc(cc);
@@ -138,13 +138,11 @@ static int chipco_pctl_clockfreqlimit(st
 			divisor = 32;
 			break;
 		default:
-			assert(0);
-			divisor = 1;
+			SSB_WARN_ON(1);
 		}
 	} else if (cc->dev->id.revision < 10) {
 		switch (clocksrc) {
 		case SSB_CHIPCO_CLKSRC_LOPWROS:
-			divisor = 1;
 			break;
 		case SSB_CHIPCO_CLKSRC_XTALOS:
 		case SSB_CHIPCO_CLKSRC_PCI:
@@ -152,9 +150,6 @@ static int chipco_pctl_clockfreqlimit(st
 			divisor = (tmp >> 16) + 1;
 			divisor *= 4;
 			break;
-		default:
-			assert(0);
-			divisor = 1;
 		}
 	} else {
 		tmp = chipco_read32(cc, SSB_CHIPCO_SYSCLKCTL);
@@ -181,9 +176,6 @@ static int chipco_pctl_clockfreqlimit(st
 		else
 			limit = 25000000;
 		break;
-	default:
-		assert(0);
-		limit = 0;
 	}
 	limit /= divisor;
 
@@ -235,7 +227,7 @@ static void calc_fast_powerup_delay(stru
 	minfreq = chipco_pctl_clockfreqlimit(cc, 0);
 	pll_on_delay = chipco_read32(cc, SSB_CHIPCO_PLLONDELAY);
 	tmp = (((pll_on_delay + 2) * 1000000) + (minfreq - 1)) / minfreq;
-	assert((tmp & ~0xFFFF) == 0);
+	SSB_WARN_ON(tmp & ~0xFFFF);
 
 	cc->fast_pwrup_delay = tmp;
 }
@@ -355,7 +347,7 @@ int ssb_chipco_serial_init(struct ssb_ch
 			div = 2; /* Minimum divisor */
 			chipco_write32(cc, SSB_CHIPCO_CLKDIV,
 				       (chipco_read32(cc, SSB_CHIPCO_CLKDIV)
-				        & ~SSB_CHIPCO_CLKDIV_UART) | div);
+					& ~SSB_CHIPCO_CLKDIV_UART) | div);
 		} else {
 			/* Fixed internal backplane clock */
 			baud_base = 88000000;
diff -puN drivers/ssb/driver_mipscore.c~merge-the-sonics-silicon-backplane-subsystem-update drivers/ssb/driver_mipscore.c
--- a/drivers/ssb/driver_mipscore.c~merge-the-sonics-silicon-backplane-subsystem-update
+++ a/drivers/ssb/driver_mipscore.c
@@ -13,7 +13,7 @@
 #include <linux/serial.h>
 #include <linux/serial_core.h>
 #include <linux/serial_reg.h>
-#include <asm/time.h>
+#include <linux/time.h>
 
 #include "ssb_private.h"
 
@@ -224,7 +224,6 @@ void ssb_mipscore_init(struct ssb_mipsco
 		tmp = tmp | CEIL(120, ns);		/* W0 = 120nS */
 		W_REG(&eir->prog_waitcount, tmp);
 	}
-	else... chipcommon
 #endif
 	if (bus->chipco.dev)
 		ssb_chipco_timing_init(&bus->chipco, ns);
@@ -233,23 +232,24 @@ void ssb_mipscore_init(struct ssb_mipsco
 	for (irq = 2, i = 0; i < bus->nr_devices; i++) {
 		dev = &(bus->devices[i]);
 		dev->irq = ssb_mips_irq(dev) + 2;
-		switch(dev->id.coreid) {
-			case SSB_DEV_USB11_HOST:
-				/* shouldn't need a separate irq line for non-4710, most of them have a proper
-				 * external usb controller on the pci */
-				if ((bus->chip_id == 0x4710) && (irq <= 4)) {
-					set_irq(dev, irq++);
-					break;
-				}
-			case SSB_DEV_PCI:
-			case SSB_DEV_ETHERNET:
-			case SSB_DEV_80211:
-			case SSB_DEV_USB20_HOST:
-				/* These devices get their own IRQ line if available, the rest goes on IRQ0 */
-				if (irq <= 4) {
-					set_irq(dev, irq++);
-					break;
-				}
+		switch (dev->id.coreid) {
+		case SSB_DEV_USB11_HOST:
+			/* shouldn't need a separate irq line for non-4710, most of them have a proper
+			 * external usb controller on the pci */
+			if ((bus->chip_id == 0x4710) && (irq <= 4)) {
+				set_irq(dev, irq++);
+				break;
+			}
+			/* fallthrough */
+		case SSB_DEV_PCI:
+		case SSB_DEV_ETHERNET:
+		case SSB_DEV_80211:
+		case SSB_DEV_USB20_HOST:
+			/* These devices get their own IRQ line if available, the rest goes on IRQ0 */
+			if (irq <= 4) {
+				set_irq(dev, irq++);
+				break;
+			}
 		}
 	}
 
diff -puN drivers/ssb/driver_pcicore.c~merge-the-sonics-silicon-backplane-subsystem-update drivers/ssb/driver_pcicore.c
--- a/drivers/ssb/driver_pcicore.c~merge-the-sonics-silicon-backplane-subsystem-update
+++ a/drivers/ssb/driver_pcicore.c
@@ -34,8 +34,10 @@ void pcicore_write32(struct ssb_pcicore 
 #ifdef CONFIG_SSB_PCICORE_HOSTMODE
 
 #include <asm/paccess.h>
-/* Read the bus and catch bus exceptions. This is MIPS specific. */
-#define mips_busprobe(val, addr)	get_dbe((val), (addr))
+/* Probe a 32bit value on the bus and catch bus exceptions.
+ * Returns nonzero on a bus exception.
+ * This is MIPS specific */
+#define mips_busprobe32(val, addr)	get_dbe((val), ((u32 *)(addr)))
 
 /* Assume one-hot slot wiring */
 #define SSB_PCI_SLOT_MAX	16
@@ -45,8 +47,8 @@ static DEFINE_SPINLOCK(cfgspace_lock);
 /* Core to access the external PCI config space. Can only have one. */
 static struct ssb_pcicore *extpci_core;
 
-u32 pci_iobase = 0x100;
-u32 pci_membase = SSB_PCI_DMA;
+static u32 ssb_pcicore_pcibus_iobase = 0x100;
+static u32 ssb_pcicore_pcibus_membase = SSB_PCI_DMA;
 
 int pcibios_plat_dev_init(struct pci_dev *d)
 {
@@ -54,12 +56,16 @@ int pcibios_plat_dev_init(struct pci_dev
 	int pos, size;
 	u32 *base;
 
-	printk("PCI: Fixing up device %s\n", pci_name(d));
+	ssb_printk(KERN_INFO "PCI: Fixing up device %s\n",
+		   pci_name(d));
 
 	/* Fix up resource bases */
 	for (pos = 0; pos < 6; pos++) {
 		res = &d->resource[pos];
-		base = ((res->flags & IORESOURCE_IO) ? &pci_iobase : &pci_membase);
+		if (res->flags & IORESOURCE_IO)
+			base = &ssb_pcicore_pcibus_iobase;
+		else
+			base = &ssb_pcicore_pcibus_membase;
 		if (res->end) {
 			size = res->end - res->start + 1;
 			if (*base & (size - 1))
@@ -85,7 +91,7 @@ static void __init ssb_fixup_pcibridge(s
 	if (dev->bus->number != 0 || PCI_SLOT(dev->devfn) != 0)
 		return;
 
-	printk("PCI: fixing up bridge\n");
+	ssb_printk(KERN_INFO "PCI: fixing up bridge\n");
 
 	/* Enable PCI bridge bus mastering and memory space */
 	pci_set_master(dev);
@@ -147,7 +153,7 @@ static int ssb_extpci_read_config(struct
 	u32 addr, val;
 	void __iomem *mmio;
 
-	assert(pc->hostmode);
+	SSB_WARN_ON(!pc->hostmode);
 	if (unlikely(len != 1 && len != 2 && len != 4))
 		goto out;
 	addr = get_cfgspace_addr(pc, bus, dev, func, off);
@@ -158,7 +164,7 @@ static int ssb_extpci_read_config(struct
 	if (!mmio)
 		goto out;
 
-	if (mips_busprobe(val, (u32 *) mmio)) {
+	if (mips_busprobe32(val, mmio)) {
 		val = 0xffffffff;
 		goto unmap;
 	}
@@ -193,7 +199,7 @@ static int ssb_extpci_write_config(struc
 	u32 addr, val = 0;
 	void __iomem *mmio;
 
-	assert(pc->hostmode);
+	SSB_WARN_ON(!pc->hostmode);
 	if (unlikely(len != 1 && len != 2 && len != 4))
 		goto out;
 	addr = get_cfgspace_addr(pc, bus, dev, func, off);
@@ -204,7 +210,7 @@ static int ssb_extpci_write_config(struc
 	if (!mmio)
 		goto out;
 
-	if (mips_busprobe(val, (u32 *) mmio)) {
+	if (mips_busprobe32(val, mmio)) {
 		val = 0xffffffff;
 		goto unmap;
 	}
@@ -269,7 +275,7 @@ static struct pci_ops ssb_pcicore_pciops
 static struct resource ssb_pcicore_mem_resource = {
 	.name	= "SSB PCIcore external memory",
 	.start	= SSB_PCI_DMA,
-	.end	= (u32)SSB_PCI_DMA + (u32)SSB_PCI_DMA_SZ - 1,
+	.end	= SSB_PCI_DMA + SSB_PCI_DMA_SZ - 1,
 	.flags	= IORESOURCE_MEM,
 };
 
@@ -291,10 +297,8 @@ static void ssb_pcicore_init_hostmode(st
 {
 	u32 val;
 
-	if (extpci_core) {
-		WARN_ON(1);
+	if (WARN_ON(extpci_core))
 		return;
-	}
 	extpci_core = pc;
 
 	ssb_dprintk(KERN_INFO PFX "PCIcore in host mode found\n");
@@ -304,12 +308,12 @@ static void ssb_pcicore_init_hostmode(st
 	pcicore_write32(pc, SSB_PCICORE_CTL, val);
 	val |= SSB_PCICORE_CTL_CLK; /* Clock on */
 	pcicore_write32(pc, SSB_PCICORE_CTL, val);
-	udelay(150);
+	udelay(150); /* Assertion time demanded by the PCI standard */
 	val |= SSB_PCICORE_CTL_RST; /* Deassert RST# */
 	pcicore_write32(pc, SSB_PCICORE_CTL, val);
-	udelay(1);
+	udelay(1); /* Assertion time demanded by the PCI standard */
 
-	//TODO cardbus mode
+	/*TODO cardbus mode */
 
 	/* 64MB I/O window */
 	pcicore_write32(pc, SSB_PCICORE_SBTOPCI0,
@@ -364,7 +368,7 @@ static int pcicore_is_in_hostmode(struct
 	if (bus->chip_id == 0x5350)
 		return 0;
 
-	return !mips_busprobe(tmp, (u32 *) (bus->mmio + (pc->dev->core_index * SSB_CORE_SIZE)));
+	return !mips_busprobe32(tmp, (bus->mmio + (pc->dev->core_index * SSB_CORE_SIZE)));
 }
 #endif /* CONFIG_SSB_PCICORE_HOSTMODE */
 
@@ -430,6 +434,7 @@ static void ssb_pcie_mdio_write(struct s
 	v |= (u32)address << 18;
 	v |= data;
 	pcicore_write32(pc, mdio_data, v);
+	/* Wait for the device to complete the transaction */
 	udelay(10);
 	for (i = 0; i < 10; i++) {
 		v = pcicore_read32(pc, mdio_control);
@@ -458,7 +463,8 @@ static void ssb_commit_settings(struct s
 	struct ssb_device *dev;
 
 	dev = bus->chipco.dev ? bus->chipco.dev : bus->pcicore.dev;
-	assert(dev);
+	if (WARN_ON(!dev))
+		return;
 	/* This forces an update of the cached registers. */
 	ssb_broadcast_value(dev, 0xFD8, 0);
 }
@@ -531,7 +537,7 @@ int ssb_pcicore_dev_irqvecs_enable(struc
 			pcicore_write32(pc, SSB_PCICORE_SBTOPCI2, tmp);
 		}
 	} else {
-		assert(pdev->id.coreid == SSB_DEV_PCIE);
+		WARN_ON(pdev->id.coreid != SSB_DEV_PCIE);
 		//TODO: Better make defines for all these magic PCIE values.
 		if ((pdev->id.revision == 0) || (pdev->id.revision == 1)) {
 			/* TLP Workaround register. */
diff -puN drivers/ssb/main.c~merge-the-sonics-silicon-backplane-subsystem-update drivers/ssb/main.c
--- a/drivers/ssb/main.c~merge-the-sonics-silicon-backplane-subsystem-update
+++ a/drivers/ssb/main.c
@@ -13,35 +13,43 @@
 #include <linux/delay.h>
 #include <linux/ssb/ssb.h>
 #include <linux/ssb/ssb_regs.h>
-#include <linux/dma-mapping.h>
 
-#ifdef CONFIG_SSB_PCIHOST
-# include <linux/pci.h>
-#endif
+#include <linux/pci.h>
 
-#ifdef CONFIG_SSB_PCMCIAHOST
-# include <pcmcia/cs_types.h>
-# include <pcmcia/cs.h>
-# include <pcmcia/cistpl.h>
-# include <pcmcia/ds.h>
-#endif
+#include <pcmcia/cs_types.h>
+#include <pcmcia/cs.h>
+#include <pcmcia/cistpl.h>
+#include <pcmcia/ds.h>
 
 
 MODULE_DESCRIPTION("Sonics Silicon Backplane driver");
 MODULE_LICENSE("GPL");
 
 
+/* Temporary list of yet-to-be-attached buses */
 static LIST_HEAD(attach_queue);
+/* List if running buses */
 static LIST_HEAD(buses);
+/* Software ID counter */
 static unsigned int next_busnumber;
+/* buses_mutes locks the two buslists and the next_busnumber.
+ * Don't lock this directly, but use ssb_buses_[un]lock() below. */
 static DEFINE_MUTEX(buses_mutex);
 
+/* There are differences in the codeflow, if the bus is
+ * initialized from early boot, as various needed services
+ * are not available early. This is a mechanism to delay
+ * these initializations to after early boot has finished.
+ * It's also used to avoid mutex locking, as that's not
+ * available and needed early. */
+static bool ssb_is_early_boot = 1;
+
 static void ssb_buses_lock(void);
 static void ssb_buses_unlock(void);
 
 
 #ifdef CONFIG_SSB_PCIHOST
-struct ssb_bus * ssb_pci_dev_to_bus(struct pci_dev *pdev)
+struct ssb_bus *ssb_pci_dev_to_bus(struct pci_dev *pdev)
 {
 	struct ssb_bus *bus;
 
@@ -59,7 +67,7 @@ found:
 }
 #endif /* CONFIG_SSB_PCIHOST */
 
-static struct ssb_device * ssb_device_get(struct ssb_device *dev)
+static struct ssb_device *ssb_device_get(struct ssb_device *dev)
 {
 	if (dev)
 		get_device(dev->dev);
@@ -160,20 +168,53 @@ int ssb_devices_freeze(struct ssb_bus *b
 	int i;
 	pm_message_t state = PMSG_FREEZE;
 
+	/* First check that we are capable to freeze all devices. */
 	for (i = 0; i < bus->nr_devices; i++) {
 		dev = &(bus->devices[i]);
-		if (!dev->dev->driver)
+		if (!dev->dev ||
+		    !dev->dev->driver ||
+		    !device_is_registered(dev->dev))
+			continue;
+		drv = drv_to_ssb_drv(dev->dev->driver);
+		if (!drv)
 			continue;
-		if (!device_is_registered(dev->dev))
+		if (!drv->suspend) {
+			/* Nope, can't suspend this one. */
+			return -EOPNOTSUPP;
+		}
+	}
+	/* Now suspend all devices */
+	for (i = 0; i < bus->nr_devices; i++) {
+		dev = &(bus->devices[i]);
+		if (!dev->dev ||
+		    !dev->dev->driver ||
+		    !device_is_registered(dev->dev))
 			continue;
 		drv = drv_to_ssb_drv(dev->dev->driver);
-		if (drv && drv->suspend) {
-			err = drv->suspend(dev, state);
-			if (err)
-				goto out;
+		if (!drv)
+			continue;
+		err = drv->suspend(dev, state);
+		if (err) {
+			ssb_printk(KERN_ERR PFX "Failed to freeze device %s\n",
+				   dev->dev->bus_id);
+			goto err_unwind;
 		}
 	}
-out:
+
+	return 0;
+err_unwind:
+	for (i--; i >= 0; i--) {
+		dev = &(bus->devices[i]);
+		if (!dev->dev ||
+		    !dev->dev->driver ||
+		    !device_is_registered(dev->dev))
+			continue;
+		drv = drv_to_ssb_drv(dev->dev->driver);
+		if (!drv)
+			continue;
+		if (drv->resume)
+			drv->resume(dev);
+	}
 	return err;
 }
 
@@ -181,24 +222,28 @@ int ssb_devices_thaw(struct ssb_bus *bus
 {
 	struct ssb_device *dev;
 	struct ssb_driver *drv;
-	int err = 0;
+	int err;
 	int i;
 
 	for (i = 0; i < bus->nr_devices; i++) {
 		dev = &(bus->devices[i]);
-		if (!dev->dev->driver)
-			continue;
-		if (!device_is_registered(dev->dev))
+		if (!dev->dev ||
+		    !dev->dev->driver ||
+		    !device_is_registered(dev->dev))
 			continue;
 		drv = drv_to_ssb_drv(dev->dev->driver);
-		if (drv && drv->resume) {
-			err = drv->resume(dev);
-			if (err)
-				goto out;
+		if (!drv)
+			continue;
+		if (SSB_WARN_ON(!drv->resume))
+			continue;
+		err = drv->resume(dev);
+		if (err) {
+			ssb_printk(KERN_ERR PFX "Failed to thaw device %s\n",
+				   dev->dev->bus_id);
 		}
 	}
-out:
-	return err;
+
+	return 0;
 }
 #endif /* CONFIG_SSB_PCIHOST */
 
@@ -273,7 +318,7 @@ static int ssb_bus_match(struct device *
 }
 
 static struct bus_type ssb_bustype = {
-	.name		= NULL, /* Intentionally NULL to indicate early boot */
+	.name		= "ssb",
 	.match		= ssb_bus_match,
 	.probe		= ssb_device_probe,
 	.remove		= ssb_device_remove,
@@ -282,17 +327,17 @@ static struct bus_type ssb_bustype = {
 	.resume		= ssb_device_resume,
 };
 
-#define is_early_boot()		(ssb_bustype.name == NULL)
-
 static void ssb_buses_lock(void)
 {
-	if (!is_early_boot())
+	/* See the comment at the ssb_is_early_boot definition */
+	if (!ssb_is_early_boot)
 		mutex_lock(&buses_mutex);
 }
 
 static void ssb_buses_unlock(void)
 {
-	if (!is_early_boot())
+	/* See the comment at the ssb_is_early_boot definition */
+	if (!ssb_is_early_boot)
 		mutex_unlock(&buses_mutex);
 }
 
@@ -468,6 +513,7 @@ static void ssb_ssb_write32(struct ssb_d
 	writel(value, bus->mmio + offset);
 }
 
+/* Ops for the plain SSB bus without a host-device (no PCI or PCMCIA). */
 static const struct ssb_bus_ops ssb_ssb_ops = {
 	.read16		= ssb_ssb_read16,
 	.read32		= ssb_ssb_read32,
@@ -476,8 +522,7 @@ static const struct ssb_bus_ops ssb_ssb_
 };
 
 static int ssb_fetch_invariants(struct ssb_bus *bus,
-				int (*get_invariants)(struct ssb_bus *bus,
-						      struct ssb_init_invariants *iv))
+				ssb_invariants_func_t get_invariants)
 {
 	struct ssb_init_invariants iv;
 	int err;
@@ -493,8 +538,7 @@ out:
 }
 
 static int ssb_bus_register(struct ssb_bus *bus,
-			    int (*get_invariants)(struct ssb_bus *bus,
-			    			  struct ssb_init_invariants *iv),
+			    ssb_invariants_func_t get_invariants,
 			    unsigned long baseaddr)
 {
 	int err;
@@ -529,9 +573,10 @@ static int ssb_bus_register(struct ssb_b
 	if (err)
 		goto err_pcmcia_exit;
 
-	/* Queue it for attach */
+	/* Queue it for attach.
+	 * See the comment at the ssb_is_early_boot definition. */
 	list_add_tail(&bus->list, &attach_queue);
-	if (!is_early_boot()) {
+	if (!ssb_is_early_boot) {
 		/* This is not early boot, so we must attach the bus now */
 		err = ssb_attach_queued_buses();
 		if (err)
@@ -602,8 +647,7 @@ EXPORT_SYMBOL(ssb_bus_pcmciabus_register
 
 int ssb_bus_ssbbus_register(struct ssb_bus *bus,
 			    unsigned long baseaddr,
-			    int (*get_invariants)(struct ssb_bus *bus,
-			    			  struct ssb_init_invariants *iv))
+			    ssb_invariants_func_t get_invariants)
 {
 	int err;
 
@@ -696,13 +740,13 @@ u32 ssb_calc_clock_rate(u32 plltype, u32
 	case SSB_PLLTYPE_2: /* 48Mhz, 4 dividers */
 		n1 += SSB_CHIPCO_CLK_T2_BIAS;
 		n2 += SSB_CHIPCO_CLK_T2_BIAS;
-		assert((n1 >= 2) && (n1 <= 7));
-		assert((n2 >= 5) && (n2 <= 23));
+		SSB_WARN_ON(!((n1 >= 2) && (n1 <= 7)));
+		SSB_WARN_ON(!((n2 >= 5) && (n2 <= 23)));
 		break;
 	case SSB_PLLTYPE_5: /* 25Mhz, 4 dividers */
 		return 100000000;
 	default:
-		assert(0);
+		SSB_WARN_ON(1);
 	}
 
 	switch (plltype) {
@@ -751,9 +795,9 @@ u32 ssb_calc_clock_rate(u32 plltype, u32
 		m1 += SSB_CHIPCO_CLK_T2_BIAS;
 		m2 += SSB_CHIPCO_CLK_T2M2_BIAS;
 		m3 += SSB_CHIPCO_CLK_T2_BIAS;
-		assert((m1 >= 2) && (m1 <= 7));
-		assert((m2 >= 3) && (m2 <= 10));
-		assert((m3 >= 2) && (m3 <= 7));
+		SSB_WARN_ON(!((m1 >= 2) && (m1 <= 7)));
+		SSB_WARN_ON(!((m2 >= 3) && (m2 <= 10)));
+		SSB_WARN_ON(!((m3 >= 2) && (m3 <= 7)));
 
 		if (!(mc & SSB_CHIPCO_CLK_T2MC_M1BYP))
 			clock /= m1;
@@ -763,7 +807,7 @@ u32 ssb_calc_clock_rate(u32 plltype, u32
 			clock /= m3;
 		return clock;
 	default:
-		assert(0);
+		SSB_WARN_ON(1);
 	}
 	return 0;
 }
@@ -805,7 +849,7 @@ static u32 ssb_tmslow_reject_bitmask(str
 	case SSB_IDLOW_SSBREV_23:
 		return SSB_TMSLOW_REJECT_23;
 	default:
-		assert(0);
+		WARN_ON(1);
 	}
 	return (SSB_TMSLOW_REJECT_22 | SSB_TMSLOW_REJECT_23);
 }
@@ -823,6 +867,18 @@ int ssb_device_is_enabled(struct ssb_dev
 }
 EXPORT_SYMBOL(ssb_device_is_enabled);
 
+static void ssb_flush_tmslow(struct ssb_device *dev)
+{
+	/* Make _really_ sure the device has finished the TMSLOW
+	 * register write transaction, as we risk running into
+	 * a machine check exception otherwise.
+	 * Do this by reading the register back to commit the
+	 * PCI write and delay an additional usec for the device
+	 * to react to the change. */
+	ssb_read32(dev, SSB_TMSLOW);
+	udelay(1);
+}
+
 void ssb_device_enable(struct ssb_device *dev, u32 core_specific_flags)
 {
 	u32 val;
@@ -831,9 +887,7 @@ void ssb_device_enable(struct ssb_device
 	ssb_write32(dev, SSB_TMSLOW,
 		    SSB_TMSLOW_RESET | SSB_TMSLOW_CLOCK |
 		    SSB_TMSLOW_FGC | core_specific_flags);
-	/* flush */
-	ssb_read32(dev, SSB_TMSLOW);
-	udelay(1);
+	ssb_flush_tmslow(dev);
 
 	/* Clear SERR if set. This is a hw bug workaround. */
 	if (ssb_read32(dev, SSB_TMSHIGH) & SSB_TMSHIGH_SERR)
@@ -848,18 +902,16 @@ void ssb_device_enable(struct ssb_device
 	ssb_write32(dev, SSB_TMSLOW,
 		    SSB_TMSLOW_CLOCK | SSB_TMSLOW_FGC |
 		    core_specific_flags);
-	/* flush */
-	ssb_read32(dev, SSB_TMSLOW);
-	udelay(1);
+	ssb_flush_tmslow(dev);
 
 	ssb_write32(dev, SSB_TMSLOW, SSB_TMSLOW_CLOCK |
 		    core_specific_flags);
-	/* flush */
-	ssb_read32(dev, SSB_TMSLOW);
-	udelay(1);
+	ssb_flush_tmslow(dev);
 }
 EXPORT_SYMBOL(ssb_device_enable);
 
+/* Wait for a bit in a register to get set or unset.
+ * timeout is in units of ten-microseconds */
 static int ssb_wait_bit(struct ssb_device *dev, u16 reg, u32 bitmask,
 			int timeout, int set)
 {
@@ -899,22 +951,18 @@ void ssb_device_disable(struct ssb_devic
 		    SSB_TMSLOW_FGC | SSB_TMSLOW_CLOCK |
 		    reject | SSB_TMSLOW_RESET |
 		    core_specific_flags);
-	/* flush */
-	ssb_read32(dev, SSB_TMSLOW);
-	udelay(1);
+	ssb_flush_tmslow(dev);
 
 	ssb_write32(dev, SSB_TMSLOW,
 		    reject | SSB_TMSLOW_RESET |
 		    core_specific_flags);
-	/* flush */
-	ssb_read32(dev, SSB_TMSLOW);
-	udelay(1);
+	ssb_flush_tmslow(dev);
 }
 EXPORT_SYMBOL(ssb_device_disable);
 
 u32 ssb_dma_translation(struct ssb_device *dev)
 {
-	switch(dev->bus->bustype) {
+	switch (dev->bus->bustype) {
 	case SSB_BUSTYPE_SSB:
 		return 0;
 	case SSB_BUSTYPE_PCI:
@@ -965,7 +1013,7 @@ error:
 }
 EXPORT_SYMBOL(ssb_bus_may_powerdown);
 
-int ssb_bus_powerup(struct ssb_bus *bus, int dynamic_pctl)
+int ssb_bus_powerup(struct ssb_bus *bus, bool dynamic_pctl)
 {
 	struct ssb_chipcommon *cc;
 	int err;
@@ -994,15 +1042,15 @@ u32 ssb_admatch_base(u32 adm)
 		base = (adm & SSB_ADM_BASE0);
 		break;
 	case SSB_ADM_TYPE1:
-		assert(!(adm & SSB_ADM_NEG)); /* unsupported */
+		SSB_WARN_ON(adm & SSB_ADM_NEG); /* unsupported */
 		base = (adm & SSB_ADM_BASE1);
 		break;
 	case SSB_ADM_TYPE2:
-		assert(!(adm & SSB_ADM_NEG)); /* unsupported */
+		SSB_WARN_ON(adm & SSB_ADM_NEG); /* unsupported */
 		base = (adm & SSB_ADM_BASE2);
 		break;
 	default:
-		assert(0);
+		SSB_WARN_ON(1);
 	}
 
 	return base;
@@ -1018,15 +1066,15 @@ u32 ssb_admatch_size(u32 adm)
 		size = ((adm & SSB_ADM_SZ0) >> SSB_ADM_SZ0_SHIFT);
 		break;
 	case SSB_ADM_TYPE1:
-		assert(!(adm & SSB_ADM_NEG)); /* unsupported */
+		SSB_WARN_ON(adm & SSB_ADM_NEG); /* unsupported */
 		size = ((adm & SSB_ADM_SZ1) >> SSB_ADM_SZ1_SHIFT);
 		break;
 	case SSB_ADM_TYPE2:
-		assert(!(adm & SSB_ADM_NEG)); /* unsupported */
+		SSB_WARN_ON(adm & SSB_ADM_NEG); /* unsupported */
 		size = ((adm & SSB_ADM_SZ2) >> SSB_ADM_SZ2_SHIFT);
 		break;
 	default:
-		assert(0);
+		SSB_WARN_ON(1);
 	}
 	size = (1 << (size + 1));
 
@@ -1038,7 +1086,8 @@ static int __init ssb_modinit(void)
 {
 	int err;
 
-	ssb_bustype.name = "ssb";
+	/* See the comment at the ssb_is_early_boot definition */
+	ssb_is_early_boot = 0;
 	err = bus_register(&ssb_bustype);
 	if (err)
 		return err;
diff -puN drivers/ssb/pci.c~merge-the-sonics-silicon-backplane-subsystem-update drivers/ssb/pci.c
--- a/drivers/ssb/pci.c~merge-the-sonics-silicon-backplane-subsystem-update
+++ a/drivers/ssb/pci.c
@@ -23,6 +23,7 @@
 #include "ssb_private.h"
 
 
+/* Lowlevel coreswitching */
 int ssb_pci_switch_coreidx(struct ssb_bus *bus, u8 coreidx)
 {
 	int err;
@@ -74,6 +75,7 @@ int ssb_pci_switch_core(struct ssb_bus *
 	return err;
 }
 
+/* Enable/disable the on board crystal oscillator and/or PLL. */
 int ssb_pci_xtal(struct ssb_bus *bus, u32 what, int turn_on)
 {
 	int err;
@@ -158,7 +160,9 @@ err_pci:
 	goto out;
 }
 
+/* Get the word-offset for a SSB_SPROM_XXX define. */
 #define SPOFF(offset)	(((offset) - SSB_SPROM_BASE) / sizeof(u16))
+/* Helper to extract some _offset, which is one of the SSB_SPROM_XXX defines. */
 #define SPEX(_outvar, _offset, _mask, _shift)	\
 	out->_outvar = ((in[SPOFF(_offset)] & (_mask)) >> (_shift))
 
@@ -533,6 +537,7 @@ static void ssb_pci_write32(struct ssb_d
 	writel(value, bus->mmio + offset);
 }
 
+/* Not "static", as it's used in main.c */
 const struct ssb_bus_ops ssb_pci_ops = {
 	.read16		= ssb_pci_read16,
 	.read32		= ssb_pci_read32,
@@ -590,6 +595,9 @@ static ssize_t ssb_pci_attr_sprom_show(s
 	if (!sprom)
 		goto out;
 
+	/* Use interruptible locking, as the SPROM write might
+	 * be holding the lock for several seconds. So allow userspace
+	 * to cancel operation. */
 	err = -ERESTARTSYS;
 	if (mutex_lock_interruptible(&bus->pci_sprom_mutex))
 		goto out_kfree;
@@ -632,10 +640,18 @@ static ssize_t ssb_pci_attr_sprom_store(
 		goto out_kfree;
 	}
 
+	/* Use interruptible locking, as the SPROM write might
+	 * be holding the lock for several seconds. So allow userspace
+	 * to cancel operation. */
 	err = -ERESTARTSYS;
 	if (mutex_lock_interruptible(&bus->pci_sprom_mutex))
 		goto out_kfree;
 	err = ssb_devices_freeze(bus);
+	if (err == -EOPNOTSUPP) {
+		ssb_printk(KERN_ERR PFX "SPROM write: Could not freeze devices. "
+			   "No suspend support. Is CONFIG_PM enabled?\n");
+		goto out_unlock;
+	}
 	if (err) {
 		ssb_printk(KERN_ERR PFX "SPROM write: Could not freeze all devices\n");
 		goto out_unlock;
diff -puN drivers/ssb/pcmcia.c~merge-the-sonics-silicon-backplane-subsystem-update drivers/ssb/pcmcia.c
--- a/drivers/ssb/pcmcia.c~merge-the-sonics-silicon-backplane-subsystem-update
+++ a/drivers/ssb/pcmcia.c
@@ -112,7 +112,7 @@ int ssb_pcmcia_switch_segment(struct ssb
 	conf_reg_t reg;
 	int res, err = 0;
 
-	assert(seg == 0 || seg == 1);
+	SSB_WARN_ON((seg != 0) && (seg != 1));
 	reg.Offset = 0x34;
 	reg.Function = 0;
 	spin_lock_irqsave(&bus->bar_lock, flags);
@@ -145,6 +145,9 @@ error:
 	goto out_unlock;
 }
 
+/* These are the main device register access functions.
+ * do_select_core is inline to have the likely hotpath inline.
+ * All unlikely codepaths are out-of-line. */
 static inline int do_select_core(struct ssb_bus *bus,
 				 struct ssb_device *dev,
 				 u16 *offset)
@@ -176,7 +179,7 @@ static u16 ssb_pcmcia_read16(struct ssb_
 	if (unlikely(do_select_core(bus, dev, &offset)))
 		return 0xFFFF;
 	x = readw(bus->mmio + offset);
-//printk("R16 0x%04X, 0x%04X\n", offset, x);
+
 	return x;
 }
 
@@ -188,7 +191,7 @@ static u32 ssb_pcmcia_read32(struct ssb_
 	if (unlikely(do_select_core(bus, dev, &offset)))
 		return 0xFFFFFFFF;
 	x = readl(bus->mmio + offset);
-//printk("R32 0x%04X, 0x%08X\n", offset, x);
+
 	return x;
 }
 
@@ -198,7 +201,6 @@ static void ssb_pcmcia_write16(struct ss
 
 	if (unlikely(do_select_core(bus, dev, &offset)))
 		return;
-//printk("W16 0x%04X, 0x%04X\n", offset, value);
 	writew(value, bus->mmio + offset);
 }
 
@@ -208,13 +210,13 @@ static void ssb_pcmcia_write32(struct ss
 
 	if (unlikely(do_select_core(bus, dev, &offset)))
 		return;
-//printk("W32 0x%04X, 0x%08X\n", offset, value);
 	readw(bus->mmio + offset);
 	writew(value >> 16, bus->mmio + offset + 2);
 	readw(bus->mmio + offset);
 	writew(value, bus->mmio + offset);
 }
 
+/* Not "static", as it's used in main.c */
 const struct ssb_bus_ops ssb_pcmcia_ops = {
 	.read16		= ssb_pcmcia_read16,
 	.read32		= ssb_pcmcia_read32,
diff -puN drivers/ssb/scan.c~merge-the-sonics-silicon-backplane-subsystem-update drivers/ssb/scan.c
--- a/drivers/ssb/scan.c~merge-the-sonics-silicon-backplane-subsystem-update
+++ a/drivers/ssb/scan.c
@@ -15,19 +15,17 @@
 #include <linux/ssb/ssb.h>
 #include <linux/ssb/ssb_regs.h>
 #include <linux/pci.h>
-#include <asm/io.h>
+#include <linux/io.h>
 
-#ifdef CONFIG_SSB_PCMCIAHOST
-# include <pcmcia/cs_types.h>
-# include <pcmcia/cs.h>
-# include <pcmcia/cistpl.h>
-# include <pcmcia/ds.h>
-#endif
+#include <pcmcia/cs_types.h>
+#include <pcmcia/cs.h>
+#include <pcmcia/cistpl.h>
+#include <pcmcia/ds.h>
 
 #include "ssb_private.h"
 
 
-const char * ssb_core_name(u16 coreid)
+const char *ssb_core_name(u16 coreid)
 {
 	switch (coreid) {
 	case SSB_DEV_CHIPCOMMON:
@@ -205,7 +203,7 @@ void ssb_iounmap(struct ssb_bus *bus)
 #ifdef CONFIG_SSB_PCIHOST
 		pci_iounmap(bus->host_pci, bus->mmio);
 #else
-		assert(0); /* Can't reach this code. */
+		SSB_BUG_ON(1); /* Can't reach this code. */
 #endif
 		break;
 	}
@@ -213,8 +211,8 @@ void ssb_iounmap(struct ssb_bus *bus)
 	bus->mapped_device = NULL;
 }
 
-static void __iomem * ssb_ioremap(struct ssb_bus *bus,
-				  unsigned long baseaddr)
+static void __iomem *ssb_ioremap(struct ssb_bus *bus,
+				 unsigned long baseaddr)
 {
 	void __iomem *mmio = NULL;
 
@@ -229,7 +227,7 @@ static void __iomem * ssb_ioremap(struct
 #ifdef CONFIG_SSB_PCIHOST
 		mmio = pci_iomap(bus->host_pci, 0, ~0UL);
 #else
-		assert(0); /* Can't reach this code. */
+		SSB_BUG_ON(1); /* Can't reach this code. */
 #endif
 		break;
 	}
diff -puN drivers/ssb/ssb_private.h~merge-the-sonics-silicon-backplane-subsystem-update drivers/ssb/ssb_private.h
--- a/drivers/ssb/ssb_private.h~merge-the-sonics-silicon-backplane-subsystem-update
+++ a/drivers/ssb/ssb_private.h
@@ -3,7 +3,6 @@
 
 #include <linux/ssb/ssb.h>
 #include <linux/types.h>
-#include <asm/io.h>
 
 
 #define PFX	"ssb: "
@@ -16,32 +15,20 @@
 
 /* dprintk: Debugging printk; vanishes for non-debug compilation */
 #ifdef CONFIG_SSB_DEBUG
-# define ssb_dprintk(fmt, x...)	ssb_printk(fmt ,##x)
+# define ssb_dprintk(fmt, x...)	ssb_printk(fmt , ##x)
 #else
 # define ssb_dprintk(fmt, x...)	do { /* nothing */ } while (0)
 #endif
 
-/* printkl: Rate limited printk */
-#define ssb_printkl(fmt, x...)	do {		\
-	if (printk_ratelimit())			\
-		ssb_printk(fmt ,##x);		\
-				} while (0)
-
-/* dprintkl: Rate limited debugging printk */
 #ifdef CONFIG_SSB_DEBUG
-# define ssb_dprintkl			ssb_printkl
+# define SSB_WARN_ON(x)		WARN_ON(x)
+# define SSB_BUG_ON(x)		BUG_ON(x)
 #else
-# define ssb_dprintkl(fmt, x...)	do { /* nothing */ } while (0)
+static inline int __ssb_do_nothing(int x) { return x; }
+# define SSB_WARN_ON(x)		__ssb_do_nothing(unlikely(!!(x)))
+# define SSB_BUG_ON(x)		__ssb_do_nothing(unlikely(!!(x)))
 #endif
 
-#define assert(cond)	do {						\
-	if (unlikely(!(cond))) {					\
-		ssb_dprintk(KERN_ERR PFX "BUG: Assertion failed (%s) "	\
-			    "at: %s:%d:%s()\n",				\
-			    #cond, __FILE__, __LINE__, __func__);	\
-	}								\
-		       } while (0)
-
 
 /* pci.c */
 #ifdef CONFIG_SSB_PCIHOST
@@ -120,7 +107,7 @@ static inline int ssb_pcmcia_init(struct
 
 
 /* scan.c */
-extern const char * ssb_core_name(u16 coreid);
+extern const char *ssb_core_name(u16 coreid);
 extern int ssb_bus_scan(struct ssb_bus *bus,
 			unsigned long baseaddr);
 extern void ssb_iounmap(struct ssb_bus *ssb);
@@ -128,10 +115,8 @@ extern void ssb_iounmap(struct ssb_bus *
 
 /* core.c */
 extern u32 ssb_calc_clock_rate(u32 plltype, u32 n, u32 m);
-#ifdef CONFIG_SSB_PCIHOST
 extern int ssb_devices_freeze(struct ssb_bus *bus);
 extern int ssb_devices_thaw(struct ssb_bus *bus);
-extern struct ssb_bus * ssb_pci_dev_to_bus(struct pci_dev *pdev);
-#endif /* CONFIG_SSB_PCIHOST */
+extern struct ssb_bus *ssb_pci_dev_to_bus(struct pci_dev *pdev);
 
 #endif /* LINUX_SSB_PRIVATE_H_ */
diff -puN include/linux/ssb/ssb.h~merge-the-sonics-silicon-backplane-subsystem-update include/linux/ssb/ssb.h
--- a/include/linux/ssb/ssb.h~merge-the-sonics-silicon-backplane-subsystem-update
+++ a/include/linux/ssb/ssb.h
@@ -1,14 +1,11 @@
 #ifndef LINUX_SSB_H_
 #define LINUX_SSB_H_
-#ifdef __KERNEL__
 
 #include <linux/device.h>
 #include <linux/list.h>
 #include <linux/types.h>
 #include <linux/spinlock.h>
-#ifdef CONFIG_SSB_PCIHOST
-# include <linux/pci.h>
-#endif
+#include <linux/pci.h>
 
 #include <linux/ssb/ssb_regs.h>
 
@@ -198,7 +195,8 @@ struct ssb_device {
 static inline
 struct ssb_device * dev_to_ssb_dev(struct device *dev)
 {
-	struct __ssb_dev_wrapper *wrap = container_of(dev, struct __ssb_dev_wrapper, dev);
+	struct __ssb_dev_wrapper *wrap;
+	wrap = container_of(dev, struct __ssb_dev_wrapper, dev);
 	return wrap->sdev;
 }
 
@@ -296,6 +294,7 @@ struct ssb_bus {
 	struct pcmcia_device *host_pcmcia;
 
 #ifdef CONFIG_SSB_PCIHOST
+	/* Mutex to protect the SPROM writing. */
 	struct mutex pci_sprom_mutex;
 #endif
 
@@ -342,6 +341,9 @@ struct ssb_init_invariants {
 	struct ssb_boardinfo boardinfo;
 	struct ssb_sprom sprom;
 };
+/* Type of function to fetch the invariants. */
+typedef int (*ssb_invariants_func_t)(struct ssb_bus *bus,
+				     struct ssb_init_invariants *iv);
 
 /* Register a SSB system bus. get_invariants() is called after the
  * basic system devices are initialized.
@@ -349,8 +351,7 @@ struct ssb_init_invariants {
  * Put the invariants into the struct pointed to by iv. */
 extern int ssb_bus_ssbbus_register(struct ssb_bus *bus,
 				   unsigned long baseaddr,
-				   int (*get_invariants)(struct ssb_bus *bus,
-				   			 struct ssb_init_invariants *iv));
+				   ssb_invariants_func_t get_invariants);
 #ifdef CONFIG_SSB_PCIHOST
 extern int ssb_bus_pcibus_register(struct ssb_bus *bus,
 				   struct pci_dev *host_pci);
@@ -365,8 +366,12 @@ extern void ssb_bus_unregister(struct ss
 
 extern u32 ssb_clockspeed(struct ssb_bus *bus);
 
+/* Is the device enabled in hardware? */
 int ssb_device_is_enabled(struct ssb_device *dev);
+/* Enable a device and pass device-specific SSB_TMSLOW flags.
+ * If no device-specific flags are available, use 0. */
 void ssb_device_enable(struct ssb_device *dev, u32 core_specific_flags);
+/* Disable a device in hardware and pass SSB_TMSLOW flags (if any). */
 void ssb_device_disable(struct ssb_device *dev, u32 core_specific_flags);
 
 
@@ -408,9 +413,15 @@ static inline void ssb_pcihost_unregiste
 #endif /* CONFIG_SSB_PCIHOST */
 
 
-/* Bus-Power handling functions. */
+/* If a driver is shutdown or suspended, call this to signal
+ * that the bus may be completely powered down. SSB will decide,
+ * if it's really time to power down the bus, based on if there
+ * are other devices that want to run. */
 extern int ssb_bus_may_powerdown(struct ssb_bus *bus);
-extern int ssb_bus_powerup(struct ssb_bus *bus, int dynamic_pctl);
+/* Before initializing and enabling a device, call this to power-up the bus.
+ * If you want to allow use of dynamic-power-control, pass the flag.
+ * Otherwise static always-on powercontrol will be used. */
+extern int ssb_bus_powerup(struct ssb_bus *bus, bool dynamic_pctl);
 
 
 /* Various helper functions */
@@ -418,5 +429,4 @@ extern u32 ssb_admatch_base(u32 adm);
 extern u32 ssb_admatch_size(u32 adm);
 
 
-#endif /* __KERNEL__ */
 #endif /* LINUX_SSB_H_ */
diff -puN include/linux/ssb/ssb_driver_chipcommon.h~merge-the-sonics-silicon-backplane-subsystem-update include/linux/ssb/ssb_driver_chipcommon.h
--- a/include/linux/ssb/ssb_driver_chipcommon.h~merge-the-sonics-silicon-backplane-subsystem-update
+++ a/include/linux/ssb/ssb_driver_chipcommon.h
@@ -12,7 +12,6 @@
  *
  * Licensed under the GPL version 2. See COPYING for details.
  */
-#ifdef __KERNEL__
 
 /** ChipCommon core registers. **/
 
@@ -383,5 +382,4 @@ extern int ssb_chipco_serial_init(struct
 				  struct ssb_serial_port *ports);
 #endif /* CONFIG_SSB_SERIAL */
 
-#endif /* __KERNEL__ */
 #endif /* LINUX_SSB_CHIPCO_H_ */
diff -puN include/linux/ssb/ssb_driver_extif.h~merge-the-sonics-silicon-backplane-subsystem-update include/linux/ssb/ssb_driver_extif.h
--- a/include/linux/ssb/ssb_driver_extif.h~merge-the-sonics-silicon-backplane-subsystem-update
+++ a/include/linux/ssb/ssb_driver_extif.h
@@ -20,8 +20,6 @@
 #ifndef LINUX_SSB_EXTIFCORE_H_
 #define LINUX_SSB_EXTIFCORE_H_
 
-#ifdef __KERNEL__
-
 struct ssb_extif {
 	struct ssb_device *dev;
 };
@@ -159,5 +157,4 @@ struct ssb_extif {
 #define SSB_EXTIF_WATCHDOG_CLK		48000000	/* Hz */
 
 
-#endif /* __KERNEL__ */
 #endif /* LINUX_SSB_EXTIFCORE_H_ */
diff -puN include/linux/ssb/ssb_driver_mips.h~merge-the-sonics-silicon-backplane-subsystem-update include/linux/ssb/ssb_driver_mips.h
--- a/include/linux/ssb/ssb_driver_mips.h~merge-the-sonics-silicon-backplane-subsystem-update
+++ a/include/linux/ssb/ssb_driver_mips.h
@@ -1,8 +1,6 @@
 #ifndef LINUX_SSB_MIPSCORE_H_
 #define LINUX_SSB_MIPSCORE_H_
 
-#ifdef __KERNEL__
-
 #ifdef CONFIG_SSB_DRIVER_MIPS
 
 struct ssb_device;
@@ -43,5 +41,4 @@ void ssb_mipscore_init(struct ssb_mipsco
 
 #endif /* CONFIG_SSB_DRIVER_MIPS */
 
-#endif /* __KERNEL__ */
 #endif /* LINUX_SSB_MIPSCORE_H_ */
diff -puN include/linux/ssb/ssb_driver_pci.h~merge-the-sonics-silicon-backplane-subsystem-update include/linux/ssb/ssb_driver_pci.h
--- a/include/linux/ssb/ssb_driver_pci.h~merge-the-sonics-silicon-backplane-subsystem-update
+++ a/include/linux/ssb/ssb_driver_pci.h
@@ -1,6 +1,5 @@
 #ifndef LINUX_SSB_PCICORE_H_
 #define LINUX_SSB_PCICORE_H_
-#ifdef __KERNEL__
 
 #ifdef CONFIG_SSB_DRIVER_PCICORE
 
@@ -104,5 +103,4 @@ int ssb_pcicore_dev_irqvecs_enable(struc
 }
 
 #endif /* CONFIG_SSB_DRIVER_PCICORE */
-#endif /* __KERNEL__ */
 #endif /* LINUX_SSB_PCICORE_H_ */
diff -puN include/linux/ssb/ssb_regs.h~merge-the-sonics-silicon-backplane-subsystem-update include/linux/ssb/ssb_regs.h
--- a/include/linux/ssb/ssb_regs.h~merge-the-sonics-silicon-backplane-subsystem-update
+++ a/include/linux/ssb/ssb_regs.h
@@ -1,6 +1,5 @@
 #ifndef LINUX_SSB_REGS_H_
 #define LINUX_SSB_REGS_H_
-#ifdef __KERNEL__
 
 
 /* SiliconBackplane Address Map.
@@ -22,10 +21,10 @@
 
 #define SSB_PCI_DMA		0x40000000	/* Client Mode sb2pcitranslation2 (1 GB) */
 #define SSB_PCI_DMA_SZ		0x40000000	/* Client Mode sb2pcitranslation2 size in bytes */
-#define SSB_PCIE_DMA_L32		0x00000000	/* PCIE Client Mode sb2pcitranslation2 (2 ZettaBytes), low 32 bits */
-#define SSB_PCIE_DMA_H32		0x80000000	/* PCIE Client Mode sb2pcitranslation2 (2 ZettaBytes), high 32 bits */
-#define	SSB_EUART		(SB_EXTIF_BASE + 0x00800000)
-#define	SSB_LED			(SB_EXTIF_BASE + 0x00900000)
+#define SSB_PCIE_DMA_L32	0x00000000	/* PCIE Client Mode sb2pcitranslation2 (2 ZettaBytes), low 32 bits */
+#define SSB_PCIE_DMA_H32	0x80000000	/* PCIE Client Mode sb2pcitranslation2 (2 ZettaBytes), high 32 bits */
+#define	SSB_EUART		(SSB_EXTIF_BASE + 0x00800000)
+#define	SSB_LED			(SSB_EXTIF_BASE + 0x00900000)
 
 
 /* Enumeration space constants */
@@ -268,7 +267,7 @@ enum {
 	SSB_SPROM1CCODE_NONE,
 };
 
-/* Address-Match values and masks (SSB_ADMATCH?) */
+/* Address-Match values and masks (SSB_ADMATCHxxx) */
 #define SSB_ADM_TYPE			0x00000003	/* Address type */
 #define  SSB_ADM_TYPE0			0
 #define  SSB_ADM_TYPE1			1
@@ -290,5 +289,4 @@ enum {
 #define SSB_ADM_BASE2_SHIFT		16
 
 
-#endif /* __KERNEL__ */
 #endif /* LINUX_SSB_REGS_H_ */
_

Patches currently in -mm which might be from mb@bu3sch.de are

merge-the-sonics-silicon-backplane-subsystem.patch
merge-the-sonics-silicon-backplane-subsystem-fix.patch
avoid-ssb-compililation-on-s390.patch
b44-ssb-fix-irq-routing-bits-on-the-backplane.patch
merge-the-sonics-silicon-backplane-subsystem-update.patch
ssb-add-a-driver-for-the-broadcom-ohci-core.patch
pure_initcall-id-inconsistency.patch
