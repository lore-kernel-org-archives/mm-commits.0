From: akpm@linux-foundation.org
Subject: [merged] mtd-rbtx4939-add-mtd-support.patch removed from -mm tree
Date: Mon, 30 Mar 2009 12:05:42 -0700
Message-ID: <200903301905.n2UJ5gWg018729@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57590 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757121AbZC3T2M (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 30 Mar 2009 15:28:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: anemo@mba.ocn.ne.jp, dwmw2@infradead.org, ralf@linux-mips.org, mm-commits@vger.kernel.org


The patch titled
     mtd: RBTX4939: add MTD support
has been removed from the -mm tree.  Its filename was
     mtd-rbtx4939-add-mtd-support.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mtd: RBTX4939: add MTD support
From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>

Add platform support for NOR flash chips on RBTX4939 board.
This board has complex flash mappings, controlled by its DIPSW setting.

[akpm@linux-foundation.org: Use min_t]
Signed-off-by: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/mips/include/asm/txx9/rbtx4939.h |    9 +
 arch/mips/txx9/rbtx4939/setup.c       |  157 ++++++++++++++++++++++++
 2 files changed, 166 insertions(+)

diff -puN arch/mips/include/asm/txx9/rbtx4939.h~mtd-rbtx4939-add-mtd-support arch/mips/include/asm/txx9/rbtx4939.h
--- a/arch/mips/include/asm/txx9/rbtx4939.h~mtd-rbtx4939-add-mtd-support
+++ a/arch/mips/include/asm/txx9/rbtx4939.h
@@ -130,4 +130,13 @@
 void rbtx4939_prom_init(void);
 void rbtx4939_irq_setup(void);
 
+struct mtd_partition;
+struct map_info;
+struct rbtx4939_flash_data {
+	unsigned int width;
+	unsigned int nr_parts;
+	struct mtd_partition *parts;
+	void (*map_init)(struct map_info *map);
+};
+
 #endif /* __ASM_TXX9_RBTX4939_H */
diff -puN arch/mips/txx9/rbtx4939/setup.c~mtd-rbtx4939-add-mtd-support arch/mips/txx9/rbtx4939/setup.c
--- a/arch/mips/txx9/rbtx4939/setup.c~mtd-rbtx4939-add-mtd-support
+++ a/arch/mips/txx9/rbtx4939/setup.c
@@ -16,6 +16,9 @@
 #include <linux/leds.h>
 #include <linux/interrupt.h>
 #include <linux/smc91x.h>
+#include <linux/mtd/mtd.h>
+#include <linux/mtd/partitions.h>
+#include <linux/mtd/map.h>
 #include <asm/reboot.h>
 #include <asm/txx9/generic.h>
 #include <asm/txx9/pci.h>
@@ -282,6 +285,159 @@ static void rbtx4939_7segled_putc(unsign
 	__rbtx4939_7segled_putc(pos, val);
 }
 
+#if defined(CONFIG_MTD_RBTX4939) || defined(CONFIG_MTD_RBTX4939_MODULE)
+/* special mapping for boot rom */
+static unsigned long rbtx4939_flash_fixup_ofs(unsigned long ofs)
+{
+	u8 bdipsw = readb(rbtx4939_bdipsw_addr) & 0x0f;
+	unsigned char shift;
+
+	if (bdipsw & 8) {
+		/* BOOT Mode: USER ROM1 / USER ROM2 */
+		shift = bdipsw & 3;
+		/* rotate A[23:22] */
+		return (ofs & ~0xc00000) | ((((ofs >> 22) + shift) & 3) << 22);
+	}
+#ifdef __BIG_ENDIAN
+	if (bdipsw == 0)
+		/* BOOT Mode: Monitor ROM */
+		ofs ^= 0x400000;	/* swap A[22] */
+#endif
+	return ofs;
+}
+
+static map_word rbtx4939_flash_read16(struct map_info *map, unsigned long ofs)
+{
+	map_word r;
+
+	ofs = rbtx4939_flash_fixup_ofs(ofs);
+	r.x[0] = __raw_readw(map->virt + ofs);
+	return r;
+}
+
+static void rbtx4939_flash_write16(struct map_info *map, const map_word datum,
+				   unsigned long ofs)
+{
+	ofs = rbtx4939_flash_fixup_ofs(ofs);
+	__raw_writew(datum.x[0], map->virt + ofs);
+	mb();	/* see inline_map_write() in mtd/map.h */
+}
+
+static void rbtx4939_flash_copy_from(struct map_info *map, void *to,
+				     unsigned long from, ssize_t len)
+{
+	u8 bdipsw = readb(rbtx4939_bdipsw_addr) & 0x0f;
+	unsigned char shift;
+	ssize_t curlen;
+
+	from += (unsigned long)map->virt;
+	if (bdipsw & 8) {
+		/* BOOT Mode: USER ROM1 / USER ROM2 */
+		shift = bdipsw & 3;
+		while (len) {
+			curlen = min_t(unsigned long, len,
+				     0x400000 -	(from & (0x400000 - 1)));
+			memcpy(to,
+			       (void *)((from & ~0xc00000) |
+					((((from >> 22) + shift) & 3) << 22)),
+			       curlen);
+			len -= curlen;
+			from += curlen;
+			to += curlen;
+		}
+		return;
+	}
+#ifdef __BIG_ENDIAN
+	if (bdipsw == 0) {
+		/* BOOT Mode: Monitor ROM */
+		while (len) {
+			curlen = min_t(unsigned long, len,
+				     0x400000 - (from & (0x400000 - 1)));
+			memcpy(to, (void *)(from ^ 0x400000), curlen);
+			len -= curlen;
+			from += curlen;
+			to += curlen;
+		}
+		return;
+	}
+#endif
+	memcpy(to, (void *)from, len);
+}
+
+static void rbtx4939_flash_map_init(struct map_info *map)
+{
+	map->read = rbtx4939_flash_read16;
+	map->write = rbtx4939_flash_write16;
+	map->copy_from = rbtx4939_flash_copy_from;
+}
+
+static void __init rbtx4939_mtd_init(void)
+{
+	static struct {
+		struct platform_device dev;
+		struct resource res;
+		struct rbtx4939_flash_data data;
+	} pdevs[4];
+	int i;
+	static char names[4][8];
+	static struct mtd_partition parts[4];
+	struct rbtx4939_flash_data *boot_pdata = &pdevs[0].data;
+	u8 bdipsw = readb(rbtx4939_bdipsw_addr) & 0x0f;
+
+	if (bdipsw & 8) {
+		/* BOOT Mode: USER ROM1 / USER ROM2 */
+		boot_pdata->nr_parts = 4;
+		for (i = 0; i < boot_pdata->nr_parts; i++) {
+			sprintf(names[i], "img%d", 4 - i);
+			parts[i].name = names[i];
+			parts[i].size = 0x400000;
+			parts[i].offset = MTDPART_OFS_NXTBLK;
+		}
+	} else if (bdipsw == 0) {
+		/* BOOT Mode: Monitor ROM */
+		boot_pdata->nr_parts = 2;
+		strcpy(names[0], "big");
+		strcpy(names[1], "little");
+		for (i = 0; i < boot_pdata->nr_parts; i++) {
+			parts[i].name = names[i];
+			parts[i].size = 0x400000;
+			parts[i].offset = MTDPART_OFS_NXTBLK;
+		}
+	} else {
+		/* BOOT Mode: ROM Emulator */
+		boot_pdata->nr_parts = 2;
+		parts[0].name = "boot";
+		parts[0].offset = 0xc00000;
+		parts[0].size = 0x400000;
+		parts[1].name = "user";
+		parts[1].offset = 0;
+		parts[1].size = 0xc00000;
+	}
+	boot_pdata->parts = parts;
+	boot_pdata->map_init = rbtx4939_flash_map_init;
+
+	for (i = 0; i < ARRAY_SIZE(pdevs); i++) {
+		struct resource *r = &pdevs[i].res;
+		struct platform_device *dev = &pdevs[i].dev;
+
+		r->start = 0x1f000000 - i * 0x1000000;
+		r->end = r->start + 0x1000000 - 1;
+		r->flags = IORESOURCE_MEM;
+		pdevs[i].data.width = 2;
+		dev->num_resources = 1;
+		dev->resource = r;
+		dev->id = i;
+		dev->name = "rbtx4939-flash";
+		dev->dev.platform_data = &pdevs[i].data;
+		platform_device_register(dev);
+	}
+}
+#else
+static void __init rbtx4939_mtd_init(void)
+{
+}
+#endif
+
 static void __init rbtx4939_arch_init(void)
 {
 	rbtx4939_pci_setup();
@@ -333,6 +489,7 @@ static void __init rbtx4939_device_init(
 	    platform_device_add_data(pdev, &smc_pdata, sizeof(smc_pdata)) ||
 	    platform_device_add(pdev))
 		platform_device_put(pdev);
+	rbtx4939_mtd_init();
 	/* TC58DVM82A1FT: tDH=10ns, tWP=tRP=tREADID=35ns */
 	tx4939_ndfmc_init(10, 35,
 			  (1 << 1) | (1 << 2),
_

Patches currently in -mm which might be from anemo@mba.ocn.ne.jp are

origin.patch
linux-next.patch
kgdb-kgdboc-console-poll-hooks-for-serial_txx9-uart.patch
serial_txx9-use-container_of-instead-of-direct-cast.patch

