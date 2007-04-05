From: akpm@linux-foundation.org
Subject: - mtd-pmc-msp71xx-flash-rootfs-mappings.patch removed from -mm tree
Date: Wed, 04 Apr 2007 19:00:21 -0700
Message-ID: <200704050200.l3520LBD004813@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:38033 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932368AbXDECAd (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 4 Apr 2007 22:00:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: stjeanma@pmc-sierra.com, Marc_St-Jean@pmc-sierra.com, dwmw2@infradead.org, mm-commits@vger.kernel.org


The patch titled
     mtd: PMC MSP71xx flash/rootfs mappings
has been removed from the -mm tree.  Its filename was
     mtd-pmc-msp71xx-flash-rootfs-mappings.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: mtd: PMC MSP71xx flash/rootfs mappings
From: Marc St-Jean <stjeanma@pmc-sierra.com>

Add flash and rootfs mappings for the PMC-Sierra MSP71xx devices.

This patch references some platform support files previously submitted to
the linux-mips@linux-mips.org list.

Signed-off-by: Marc St-Jean <Marc_St-Jean@pmc-sierra.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mtd/maps/Kconfig          |   33 +++++
 drivers/mtd/maps/Makefile         |    2 
 drivers/mtd/maps/pmcmsp-flash.c   |  184 ++++++++++++++++++++++++++++
 drivers/mtd/maps/pmcmsp-ramroot.c |  105 +++++++++++++++
 4 files changed, 324 insertions(+)

diff -puN drivers/mtd/maps/Kconfig~mtd-pmc-msp71xx-flash-rootfs-mappings drivers/mtd/maps/Kconfig
--- a/drivers/mtd/maps/Kconfig~mtd-pmc-msp71xx-flash-rootfs-mappings
+++ a/drivers/mtd/maps/Kconfig
@@ -69,6 +69,39 @@ config MTD_PHYSMAP_OF
 	  physically into the CPU's memory. The mapping description here is
 	  taken from OF device tree.
 
+config MTD_PMC_MSP_EVM
+	tristate "CFI Flash device mapped on PMC-Sierra MSP"
+	depends on PMC_MSP && MTD_CFI
+	select MTD_PARTITIONS
+	help
+	  This provides a 'mapping' driver which support the way
+          in which user-programmable flash chips are connected on the
+          PMC-Sierra MSP eval/demo boards
+
+choice
+	prompt "Maximum mappable memory avialable for flash IO"
+	depends on MTD_PMC_MSP_EVM
+	default MSP_FLASH_MAP_LIMIT_32M
+
+config MSP_FLASH_MAP_LIMIT_32M
+	bool "32M"
+
+endchoice
+
+config MSP_FLASH_MAP_LIMIT
+	hex
+	default "0x02000000"
+	depends on MSP_FLASH_MAP_LIMIT_32M
+
+config MTD_PMC_MSP_RAMROOT
+	tristate "Embedded RAM block device for root on PMC-Sierra MSP"
+	depends on PMC_MSP_EMBEDDED_ROOTFS && \
+			(MTD_BLOCK || MTD_BLOCK_RO) && \
+			MTD_RAM
+	help
+	  This provides support for the embedded root file system
+          on PMC MSP devices.  This memory is mapped as a MTD block device.
+
 config MTD_SUN_UFLASH
 	tristate "Sun Microsystems userflash support"
 	depends on SPARC && MTD_CFI
diff -puN drivers/mtd/maps/Makefile~mtd-pmc-msp71xx-flash-rootfs-mappings drivers/mtd/maps/Makefile
--- a/drivers/mtd/maps/Makefile~mtd-pmc-msp71xx-flash-rootfs-mappings
+++ a/drivers/mtd/maps/Makefile
@@ -27,6 +27,8 @@ obj-$(CONFIG_MTD_CEIVA)		+= ceiva.o
 obj-$(CONFIG_MTD_OCTAGON)	+= octagon-5066.o
 obj-$(CONFIG_MTD_PHYSMAP)	+= physmap.o
 obj-$(CONFIG_MTD_PHYSMAP_OF)	+= physmap_of.o
+obj-$(CONFIG_MTD_PMC_MSP_EVM)   += pmcmsp-flash.o
+obj-$(CONFIG_MTD_PMC_MSP_RAMROOT)+= pmcmsp-ramroot.o
 obj-$(CONFIG_MTD_PNC2000)	+= pnc2000.o
 obj-$(CONFIG_MTD_PCMCIA)	+= pcmciamtd.o
 obj-$(CONFIG_MTD_RPXLITE)	+= rpxlite.o
diff -puN /dev/null drivers/mtd/maps/pmcmsp-flash.c
--- /dev/null
+++ a/drivers/mtd/maps/pmcmsp-flash.c
@@ -0,0 +1,184 @@
+/*
+ * Mapping of a custom board with both AMD CFI and JEDEC flash in partitions.
+ * Config with both CFI and JEDEC device support.
+ *
+ * Basically physmap.c with the addition of partitions and
+ * an array of mapping info to accomodate more than one flash type per board.
+ *
+ * Copyright 2005-2007 PMC-Sierra, Inc.
+ *
+ *  This program is free software; you can redistribute  it and/or modify it
+ *  under  the terms of  the GNU General  Public License as published by the
+ *  Free Software Foundation;  either version 2 of the  License, or (at your
+ *  option) any later version.
+ *
+ *  THIS  SOFTWARE  IS PROVIDED   ``AS  IS'' AND   ANY  EXPRESS OR IMPLIED
+ *  WARRANTIES,   INCLUDING, BUT NOT  LIMITED  TO, THE IMPLIED WARRANTIES OF
+ *  MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.  IN
+ *  NO  EVENT  SHALL   THE AUTHOR  BE    LIABLE FOR ANY   DIRECT, INDIRECT,
+ *  INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT
+ *  NOT LIMITED   TO, PROCUREMENT OF  SUBSTITUTE GOODS  OR SERVICES; LOSS OF
+ *  USE, DATA,  OR PROFITS; OR  BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
+ *  ANY THEORY OF LIABILITY, WHETHER IN  CONTRACT, STRICT LIABILITY, OR TORT
+ *  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF
+ *  THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
+ *
+ *  You should have received a copy of the  GNU General Public License along
+ *  with this program; if not, write  to the Free Software Foundation, Inc.,
+ *  675 Mass Ave, Cambridge, MA 02139, USA.
+ */
+
+#include <linux/module.h>
+#include <linux/types.h>
+#include <linux/kernel.h>
+#include <linux/mtd/mtd.h>
+#include <linux/mtd/map.h>
+#include <linux/mtd/partitions.h>
+
+#include <asm/io.h>
+
+#include <msp_prom.h>
+#include <msp_regs.h>
+
+
+static struct mtd_info **msp_flash;
+static struct mtd_partition **msp_parts;
+static struct map_info *msp_maps;
+static int fcnt;
+
+#define DEBUG_MARKER printk(KERN_NOTICE "%s[%d]\n",__FUNCTION__,__LINE__)
+
+int __init init_msp_flash(void)
+{
+	int i, j;
+	int offset, coff;
+	char *env;
+	int pcnt;
+	char flash_name[] = "flash0";
+	char part_name[] = "flash0_0";
+	unsigned addr, size;
+
+	/* If ELB is disabled by "ful-mux" mode, we can't get at flash */
+	if ((*DEV_ID_REG & DEV_ID_SINGLE_PC) &&
+	    (*ELB_1PC_EN_REG & SINGLE_PCCARD)) {
+		printk(KERN_NOTICE "Single PC Card mode: no flash access\n");
+		return -ENXIO;
+	}
+
+	/* examine the prom environment for flash devices */
+	for (fcnt = 0; (env = prom_getenv(flash_name)); fcnt++)
+		flash_name[5] = '0' + fcnt + 1;
+
+	if (fcnt < 1)
+		return -ENXIO;
+
+	printk(KERN_NOTICE "Found %d PMC flash devices\n", fcnt);
+	msp_flash = (struct mtd_info **)kmalloc(
+			fcnt * sizeof(struct map_info *), GFP_KERNEL);
+	msp_parts = (struct mtd_partition **)kmalloc(
+			fcnt * sizeof(struct mtd_partition *), GFP_KERNEL);
+	msp_maps = (struct map_info *)kmalloc(
+			fcnt * sizeof(struct mtd_info), GFP_KERNEL);
+	memset(msp_maps, 0, fcnt * sizeof(struct mtd_info));
+
+	/* loop over the flash devices, initializing each */
+	for (i = 0; i < fcnt; i++) {
+		/* examine the prom environment for flash partititions */
+		part_name[5] = '0' + i;
+		part_name[7] = '0';
+		for (pcnt = 0; (env = prom_getenv(part_name)); pcnt++)
+			part_name[7] = '0' + pcnt + 1;
+
+		if (pcnt == 0) {
+			printk(KERN_NOTICE "Skipping flash device %d "
+				"(no partitions defined)\n", i);
+			continue;
+		}
+
+		msp_parts[i] = (struct mtd_partition *)kmalloc(
+			pcnt * sizeof(struct mtd_partition), GFP_KERNEL);
+		memset(msp_parts[i], 0, pcnt * sizeof(struct mtd_partition));
+
+		/* now initialize the devices proper */
+		flash_name[5] = '0' + i;
+		env = prom_getenv(flash_name);
+
+		if (sscanf(env, "%x:%x", &addr, &size) < 2)
+			return -ENXIO;
+		addr = CPHYSADDR(addr);
+
+		printk(KERN_NOTICE
+			"MSP flash device \"%s\": 0x%08x at 0x%08x\n",
+			flash_name, size, addr);
+		/* This must matchs the actual size of the flash chip */
+		msp_maps[i].size = size;
+		msp_maps[i].phys = addr;
+
+		/*
+		 * Platforms have a specific limit of the size of memory
+		 * which may be mapped for flash:
+		 */
+		if (size > CONFIG_MSP_FLASH_MAP_LIMIT)
+			size = CONFIG_MSP_FLASH_MAP_LIMIT;
+		msp_maps[i].virt = ioremap(addr, size);
+		msp_maps[i].bankwidth = 1;
+		msp_maps[i].name = strncpy(kmalloc(7, GFP_KERNEL),
+					flash_name, 7);
+
+		if (msp_maps[i].virt == NULL)
+			return -ENXIO;
+
+		for (j = 0; j < pcnt; j++) {
+			part_name[5] = '0' + i;
+			part_name[7] = '0' + j;
+
+			env = prom_getenv(part_name);
+
+			if (sscanf(env, "%x:%x:%n", &offset, &size, &coff) < 2)
+				return -ENXIO;
+
+			msp_parts[i][j].size = size;
+			msp_parts[i][j].offset = offset;
+			msp_parts[i][j].name = env + coff;
+		}
+
+		/* now probe and add the device */
+		simple_map_init(&msp_maps[i]);
+		msp_flash[i] = do_map_probe("cfi_probe", &msp_maps[i]);
+		if (msp_flash[i]) {
+			msp_flash[i]->owner = THIS_MODULE;
+			add_mtd_partitions(msp_flash[i], msp_parts[i], pcnt);
+		} else {
+			printk(KERN_ERR "map probe failed for flash\n");
+			return -ENXIO;
+		}
+	}
+
+	return 0;
+}
+
+static void __exit cleanup_msp_flash(void)
+{
+	int i;
+
+	for (i = 0; i < sizeof(msp_flash) / sizeof(struct mtd_info **); i++) {
+		del_mtd_partitions(msp_flash[i]);
+		map_destroy(msp_flash[i]);
+		iounmap((void *)msp_maps[i].virt);
+
+		/* free the memory */
+		kfree(msp_maps[i].name);
+		kfree(msp_parts[i]);
+	}
+
+	kfree(msp_flash);
+	kfree(msp_parts);
+	kfree(msp_maps);
+}
+
+MODULE_AUTHOR("PMC-Sierra, Inc");
+MODULE_DESCRIPTION("MTD map driver for PMC-Sierra MSP boards");
+MODULE_LICENSE("GPL");
+
+module_init(init_msp_flash);
+module_exit(cleanup_msp_flash);
diff -puN /dev/null drivers/mtd/maps/pmcmsp-ramroot.c
--- /dev/null
+++ a/drivers/mtd/maps/pmcmsp-ramroot.c
@@ -0,0 +1,105 @@
+/*
+ * Mapping of the rootfs in a physical region of memory
+ *
+ * Copyright (C) 2005-2007 PMC-Sierra Inc.
+ * Author: Andrew Hughes, Andrew_Hughes@pmc-sierra.com
+ *
+ *  This program is free software; you can redistribute  it and/or modify it
+ *  under  the terms of  the GNU General  Public License as published by the
+ *  Free Software Foundation;  either version 2 of the  License, or (at your
+ *  option) any later version.
+ *
+ *  THIS  SOFTWARE  IS PROVIDED   ``AS  IS'' AND   ANY  EXPRESS OR IMPLIED
+ *  WARRANTIES,   INCLUDING, BUT NOT  LIMITED  TO, THE IMPLIED WARRANTIES OF
+ *  MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.  IN
+ *  NO  EVENT  SHALL   THE AUTHOR  BE    LIABLE FOR ANY   DIRECT, INDIRECT,
+ *  INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT
+ *  NOT LIMITED   TO, PROCUREMENT OF  SUBSTITUTE GOODS  OR SERVICES; LOSS OF
+ *  USE, DATA,  OR PROFITS; OR  BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
+ *  ANY THEORY OF LIABILITY, WHETHER IN  CONTRACT, STRICT LIABILITY, OR TORT
+ *  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF
+ *  THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
+ *
+ *  You should have received a copy of the  GNU General Public License along
+ *  with this program; if not, write  to the Free Software Foundation, Inc.,
+ *  675 Mass Ave, Cambridge, MA 02139, USA.
+ */
+
+#include <linux/module.h>
+#include <linux/types.h>
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/slab.h>
+#include <linux/fs.h>
+#include <linux/root_dev.h>
+#include <linux/mtd/mtd.h>
+#include <linux/mtd/map.h>
+
+#include <asm/io.h>
+
+#include <msp_prom.h>
+
+static struct mtd_info *rr_mtd;
+
+struct map_info rr_map = {
+	.name = "ramroot",
+	.bankwidth = 4,
+};
+
+static int __init init_rrmap(void)
+{
+	void *ramroot_start;
+	unsigned long ramroot_size;
+
+	/* Check for supported rootfs types */
+	if (get_ramroot(&ramroot_start, &ramroot_size)) {
+		rr_map.phys = CPHYSADDR(ramroot_start);
+		rr_map.size = ramroot_size;
+
+		printk(KERN_NOTICE
+			"PMC embedded root device: 0x%08lx @ 0x%08lx\n",
+			rr_map.size, (unsigned long)rr_map.phys);
+	} else {
+		printk(KERN_ERR
+			"init_rrmap: no supported embedded rootfs detected!\n");
+		return -ENXIO;
+	}
+
+	/* Map rootfs to I/O space for block device driver */
+	rr_map.virt = ioremap(rr_map.phys, rr_map.size);
+	if (!rr_map.virt) {
+		printk(KERN_ERR "Failed to ioremap\n");
+		return -EIO;
+	}
+
+	simple_map_init(&rr_map);
+
+	rr_mtd = do_map_probe("map_ram", &rr_map);
+	if (rr_mtd) {
+		rr_mtd->owner = THIS_MODULE;
+
+		add_mtd_device(rr_mtd);
+		ROOT_DEV = MKDEV(MTD_BLOCK_MAJOR, rr_mtd->index);
+
+		return 0;
+	}
+
+	iounmap(rr_map.virt);
+	return -ENXIO;
+}
+
+static void __exit cleanup_rrmap(void)
+{
+	del_mtd_device(rr_mtd);
+	map_destroy(rr_mtd);
+
+	iounmap(rr_map.virt);
+	rr_map.virt = NULL;
+}
+
+MODULE_AUTHOR("PMC-Sierra, Inc");
+MODULE_DESCRIPTION("MTD map driver for embedded PMC-Sierra MSP filesystem");
+MODULE_LICENSE("GPL");
+
+module_init(init_rrmap);
+module_exit(cleanup_rrmap);
_

Patches currently in -mm which might be from stjeanma@pmc-sierra.com are

git-mtd.patch
serial-driver-pmc-msp71xx.patch
