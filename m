From: akpm@linux-foundation.org
Subject: - intel_agp-cleanup-intel-private-data.patch removed from -mm tree
Date: Fri, 08 Jun 2007 10:35:09 -0700
Message-ID: <200706081735.l58HZ91O006343@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50964 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S936816AbXFHRf5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Jun 2007 13:35:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: zhenyu.z.wang@intel.com, davej@codemonkey.org.uk, eric@anholt.net, keithp@keithp.com, mm-commits@vger.kernel.org


The patch titled
     agpgart: intel_agp: cleanup intel private data
has been removed from the -mm tree.  Its filename was
     intel_agp-cleanup-intel-private-data.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: agpgart: intel_agp: cleanup intel private data
From: Wang Zhenyu <zhenyu.z.wang@intel.com>

A single private gart data is used by all drivers, this makes it clean.  Eric
Anholt wrote the original patch.

Signed-off-by: Wang Zhenyu <zhenyu.z.wang@intel.com>
Cc: Dave Jones <davej@codemonkey.org.uk>
Cc: Keith Packard <keithp@keithp.com>
Cc: Eric Anholt <eric@anholt.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/agp/intel-agp.c |  193 +++++++++++++++------------------
 1 file changed, 90 insertions(+), 103 deletions(-)

diff -puN drivers/char/agp/intel-agp.c~intel_agp-cleanup-intel-private-data drivers/char/agp/intel-agp.c
--- a/drivers/char/agp/intel-agp.c~intel_agp-cleanup-intel-private-data
+++ a/drivers/char/agp/intel-agp.c
@@ -93,11 +93,18 @@ static struct gatt_mask intel_i810_masks
 	 .type = INTEL_AGP_CACHED_MEMORY}
 };
 
-static struct _intel_i810_private {
-	struct pci_dev *i810_dev;	/* device one */
+static struct _intel_private {
+	struct pci_dev *pcidev;	/* device one */
 	volatile u8 __iomem *registers;
+	volatile u32 __iomem *gtt;		/* I915G */
 	int num_dcache_entries;
-} intel_i810_private;
+	/* gtt_entries is the number of gtt entries that are already mapped
+	 * to stolen memory.  Stolen memory is larger than the memory mapped
+	 * through gtt_entries, as it includes some reserved space for the BIOS
+	 * popup and for the GTT.
+	 */
+	int gtt_entries;			/* i830+ */
+} intel_private;
 
 static int intel_i810_fetch_size(void)
 {
@@ -134,32 +141,32 @@ static int intel_i810_configure(void)
 
 	current_size = A_SIZE_FIX(agp_bridge->current_size);
 
-	if (!intel_i810_private.registers) {
-		pci_read_config_dword(intel_i810_private.i810_dev, I810_MMADDR, &temp);
+	if (!intel_private.registers) {
+		pci_read_config_dword(intel_private.pcidev, I810_MMADDR, &temp);
 		temp &= 0xfff80000;
 
-		intel_i810_private.registers = ioremap(temp, 128 * 4096);
-		if (!intel_i810_private.registers) {
+		intel_private.registers = ioremap(temp, 128 * 4096);
+		if (!intel_private.registers) {
 			printk(KERN_ERR PFX "Unable to remap memory.\n");
 			return -ENOMEM;
 		}
 	}
 
-	if ((readl(intel_i810_private.registers+I810_DRAM_CTL)
+	if ((readl(intel_private.registers+I810_DRAM_CTL)
 		& I810_DRAM_ROW_0) == I810_DRAM_ROW_0_SDRAM) {
 		/* This will need to be dynamically assigned */
 		printk(KERN_INFO PFX "detected 4MB dedicated video ram.\n");
-		intel_i810_private.num_dcache_entries = 1024;
+		intel_private.num_dcache_entries = 1024;
 	}
-	pci_read_config_dword(intel_i810_private.i810_dev, I810_GMADDR, &temp);
+	pci_read_config_dword(intel_private.pcidev, I810_GMADDR, &temp);
 	agp_bridge->gart_bus_addr = (temp & PCI_BASE_ADDRESS_MEM_MASK);
-	writel(agp_bridge->gatt_bus_addr | I810_PGETBL_ENABLED, intel_i810_private.registers+I810_PGETBL_CTL);
-	readl(intel_i810_private.registers+I810_PGETBL_CTL);	/* PCI Posting. */
+	writel(agp_bridge->gatt_bus_addr | I810_PGETBL_ENABLED, intel_private.registers+I810_PGETBL_CTL);
+	readl(intel_private.registers+I810_PGETBL_CTL);	/* PCI Posting. */
 
 	if (agp_bridge->driver->needs_scratch_page) {
 		for (i = 0; i < current_size->num_entries; i++) {
-			writel(agp_bridge->scratch_page, intel_i810_private.registers+I810_PTE_BASE+(i*4));
-			readl(intel_i810_private.registers+I810_PTE_BASE+(i*4));	/* PCI posting. */
+			writel(agp_bridge->scratch_page, intel_private.registers+I810_PTE_BASE+(i*4));
+			readl(intel_private.registers+I810_PTE_BASE+(i*4));	/* PCI posting. */
 		}
 	}
 	global_cache_flush();
@@ -168,9 +175,9 @@ static int intel_i810_configure(void)
 
 static void intel_i810_cleanup(void)
 {
-	writel(0, intel_i810_private.registers+I810_PGETBL_CTL);
-	readl(intel_i810_private.registers);	/* PCI Posting. */
-	iounmap(intel_i810_private.registers);
+	writel(0, intel_private.registers+I810_PGETBL_CTL);
+	readl(intel_private.registers);	/* PCI Posting. */
+	iounmap(intel_private.registers);
 }
 
 static void intel_i810_tlbflush(struct agp_memory *mem)
@@ -268,9 +275,9 @@ static int intel_i810_insert_entries(str
 			global_cache_flush();
 		for (i = pg_start; i < (pg_start + mem->page_count); i++) {
 			writel((i*4096)|I810_PTE_LOCAL|I810_PTE_VALID,
-			       intel_i810_private.registers+I810_PTE_BASE+(i*4));
+			       intel_private.registers+I810_PTE_BASE+(i*4));
 		}
-		readl(intel_i810_private.registers+I810_PTE_BASE+((i-1)*4));
+		readl(intel_private.registers+I810_PTE_BASE+((i-1)*4));
 		break;
 	case AGP_PHYS_MEMORY:
 	case AGP_NORMAL_MEMORY:
@@ -280,9 +287,9 @@ static int intel_i810_insert_entries(str
 			writel(agp_bridge->driver->mask_memory(agp_bridge,
 							       mem->memory[i],
 							       mask_type),
-			       intel_i810_private.registers+I810_PTE_BASE+(j*4));
+			       intel_private.registers+I810_PTE_BASE+(j*4));
 		}
-		readl(intel_i810_private.registers+I810_PTE_BASE+((j-1)*4));
+		readl(intel_private.registers+I810_PTE_BASE+((j-1)*4));
 		break;
 	default:
 		goto out_err;
@@ -305,9 +312,9 @@ static int intel_i810_remove_entries(str
 		return 0;
 
 	for (i = pg_start; i < (mem->page_count + pg_start); i++) {
-		writel(agp_bridge->scratch_page, intel_i810_private.registers+I810_PTE_BASE+(i*4));
+		writel(agp_bridge->scratch_page, intel_private.registers+I810_PTE_BASE+(i*4));
 	}
-	readl(intel_i810_private.registers+I810_PTE_BASE+((i-1)*4));
+	readl(intel_private.registers+I810_PTE_BASE+((i-1)*4));
 
 	agp_bridge->driver->tlb_flush(mem);
 	return 0;
@@ -361,7 +368,7 @@ static struct agp_memory *intel_i810_all
 	struct agp_memory *new;
 
 	if (type == AGP_DCACHE_MEMORY) {
-		if (pg_count != intel_i810_private.num_dcache_entries)
+		if (pg_count != intel_private.num_dcache_entries)
 			return NULL;
 
 		new = agp_create_memory(1);
@@ -411,18 +418,6 @@ static struct aper_size_info_fixed intel
 	{512, 131072, 7},
 };
 
-static struct _intel_i830_private {
-	struct pci_dev *i830_dev;		/* device one */
-	volatile u8 __iomem *registers;
-	volatile u32 __iomem *gtt;		/* I915G */
-	/* gtt_entries is the number of gtt entries that are already mapped
-	 * to stolen memory.  Stolen memory is larger than the memory mapped
-	 * through gtt_entries, as it includes some reserved space for the BIOS
-	 * popup and for the GTT.
-	 */
-	int gtt_entries;
-} intel_i830_private;
-
 static void intel_i830_init_gtt_entries(void)
 {
 	u16 gmch_ctrl;
@@ -436,7 +431,7 @@ static void intel_i830_init_gtt_entries(
 
 	if (IS_I965) {
 		u32 pgetbl_ctl;
-		pgetbl_ctl = readl(intel_i830_private.registers+I810_PGETBL_CTL);
+		pgetbl_ctl = readl(intel_private.registers+I810_PGETBL_CTL);
 
 		/* The 965 has a field telling us the size of the GTT,
 		 * which may be larger than what is necessary to map the
@@ -478,7 +473,7 @@ static void intel_i830_init_gtt_entries(
 			gtt_entries = MB(8) - KB(size);
 			break;
 		case I830_GMCH_GMS_LOCAL:
-			rdct = readb(intel_i830_private.registers+I830_RDRAM_CHANNEL_TYPE);
+			rdct = readb(intel_private.registers+I830_RDRAM_CHANNEL_TYPE);
 			gtt_entries = (I830_RDRAM_ND(rdct) + 1) *
 					MB(ddt[I830_RDRAM_DDT(rdct)]);
 			local = 1;
@@ -536,7 +531,7 @@ static void intel_i830_init_gtt_entries(
 		       "No pre-allocated video memory detected.\n");
 	gtt_entries /= KB(4);
 
-	intel_i830_private.gtt_entries = gtt_entries;
+	intel_private.gtt_entries = gtt_entries;
 }
 
 /* The intel i830 automatically initializes the agp aperture during POST.
@@ -554,14 +549,14 @@ static int intel_i830_create_gatt_table(
 	num_entries = size->num_entries;
 	agp_bridge->gatt_table_real = NULL;
 
-	pci_read_config_dword(intel_i830_private.i830_dev,I810_MMADDR,&temp);
+	pci_read_config_dword(intel_private.pcidev,I810_MMADDR,&temp);
 	temp &= 0xfff80000;
 
-	intel_i830_private.registers = ioremap(temp,128 * 4096);
-	if (!intel_i830_private.registers)
+	intel_private.registers = ioremap(temp,128 * 4096);
+	if (!intel_private.registers)
 		return -ENOMEM;
 
-	temp = readl(intel_i830_private.registers+I810_PGETBL_CTL) & 0xfffff000;
+	temp = readl(intel_private.registers+I810_PGETBL_CTL) & 0xfffff000;
 	global_cache_flush();	/* FIXME: ?? */
 
 	/* we have to call this as early as possible after the MMIO base address is known */
@@ -621,20 +616,20 @@ static int intel_i830_configure(void)
 
 	current_size = A_SIZE_FIX(agp_bridge->current_size);
 
-	pci_read_config_dword(intel_i830_private.i830_dev,I810_GMADDR,&temp);
+	pci_read_config_dword(intel_private.pcidev,I810_GMADDR,&temp);
 	agp_bridge->gart_bus_addr = (temp & PCI_BASE_ADDRESS_MEM_MASK);
 
 	pci_read_config_word(agp_bridge->dev,I830_GMCH_CTRL,&gmch_ctrl);
 	gmch_ctrl |= I830_GMCH_ENABLED;
 	pci_write_config_word(agp_bridge->dev,I830_GMCH_CTRL,gmch_ctrl);
 
-	writel(agp_bridge->gatt_bus_addr|I810_PGETBL_ENABLED, intel_i830_private.registers+I810_PGETBL_CTL);
-	readl(intel_i830_private.registers+I810_PGETBL_CTL);	/* PCI Posting. */
+	writel(agp_bridge->gatt_bus_addr|I810_PGETBL_ENABLED, intel_private.registers+I810_PGETBL_CTL);
+	readl(intel_private.registers+I810_PGETBL_CTL);	/* PCI Posting. */
 
 	if (agp_bridge->driver->needs_scratch_page) {
-		for (i = intel_i830_private.gtt_entries; i < current_size->num_entries; i++) {
-			writel(agp_bridge->scratch_page, intel_i830_private.registers+I810_PTE_BASE+(i*4));
-			readl(intel_i830_private.registers+I810_PTE_BASE+(i*4));	/* PCI Posting. */
+		for (i = intel_private.gtt_entries; i < current_size->num_entries; i++) {
+			writel(agp_bridge->scratch_page, intel_private.registers+I810_PTE_BASE+(i*4));
+			readl(intel_private.registers+I810_PTE_BASE+(i*4));	/* PCI Posting. */
 		}
 	}
 
@@ -644,7 +639,7 @@ static int intel_i830_configure(void)
 
 static void intel_i830_cleanup(void)
 {
-	iounmap(intel_i830_private.registers);
+	iounmap(intel_private.registers);
 }
 
 static int intel_i830_insert_entries(struct agp_memory *mem,off_t pg_start, int type)
@@ -660,9 +655,9 @@ static int intel_i830_insert_entries(str
 	temp = agp_bridge->current_size;
 	num_entries = A_SIZE_FIX(temp)->num_entries;
 
-	if (pg_start < intel_i830_private.gtt_entries) {
-		printk (KERN_DEBUG PFX "pg_start == 0x%.8lx,intel_i830_private.gtt_entries == 0x%.8x\n",
-				pg_start,intel_i830_private.gtt_entries);
+	if (pg_start < intel_private.gtt_entries) {
+		printk (KERN_DEBUG PFX "pg_start == 0x%.8lx,intel_private.gtt_entries == 0x%.8x\n",
+				pg_start,intel_private.gtt_entries);
 
 		printk (KERN_INFO PFX "Trying to insert into local/stolen memory\n");
 		goto out_err;
@@ -690,9 +685,9 @@ static int intel_i830_insert_entries(str
 	for (i = 0, j = pg_start; i < mem->page_count; i++, j++) {
 		writel(agp_bridge->driver->mask_memory(agp_bridge,
 						       mem->memory[i], mask_type),
-		       intel_i830_private.registers+I810_PTE_BASE+(j*4));
+		       intel_private.registers+I810_PTE_BASE+(j*4));
 	}
-	readl(intel_i830_private.registers+I810_PTE_BASE+((j-1)*4));
+	readl(intel_private.registers+I810_PTE_BASE+((j-1)*4));
 	agp_bridge->driver->tlb_flush(mem);
 
 out:
@@ -710,15 +705,15 @@ static int intel_i830_remove_entries(str
 	if (mem->page_count == 0)
 		return 0;
 
-	if (pg_start < intel_i830_private.gtt_entries) {
+	if (pg_start < intel_private.gtt_entries) {
 		printk (KERN_INFO PFX "Trying to disable local/stolen memory\n");
 		return -EINVAL;
 	}
 
 	for (i = pg_start; i < (mem->page_count + pg_start); i++) {
-		writel(agp_bridge->scratch_page, intel_i830_private.registers+I810_PTE_BASE+(i*4));
+		writel(agp_bridge->scratch_page, intel_private.registers+I810_PTE_BASE+(i*4));
 	}
-	readl(intel_i830_private.registers+I810_PTE_BASE+((i-1)*4));
+	readl(intel_private.registers+I810_PTE_BASE+((i-1)*4));
 
 	agp_bridge->driver->tlb_flush(mem);
 	return 0;
@@ -741,7 +736,7 @@ static int intel_i915_configure(void)
 
 	current_size = A_SIZE_FIX(agp_bridge->current_size);
 
-	pci_read_config_dword(intel_i830_private.i830_dev, I915_GMADDR, &temp);
+	pci_read_config_dword(intel_private.pcidev, I915_GMADDR, &temp);
 
 	agp_bridge->gart_bus_addr = (temp & PCI_BASE_ADDRESS_MEM_MASK);
 
@@ -749,13 +744,13 @@ static int intel_i915_configure(void)
 	gmch_ctrl |= I830_GMCH_ENABLED;
 	pci_write_config_word(agp_bridge->dev,I830_GMCH_CTRL,gmch_ctrl);
 
-	writel(agp_bridge->gatt_bus_addr|I810_PGETBL_ENABLED, intel_i830_private.registers+I810_PGETBL_CTL);
-	readl(intel_i830_private.registers+I810_PGETBL_CTL);	/* PCI Posting. */
+	writel(agp_bridge->gatt_bus_addr|I810_PGETBL_ENABLED, intel_private.registers+I810_PGETBL_CTL);
+	readl(intel_private.registers+I810_PGETBL_CTL);	/* PCI Posting. */
 
 	if (agp_bridge->driver->needs_scratch_page) {
-		for (i = intel_i830_private.gtt_entries; i < current_size->num_entries; i++) {
-			writel(agp_bridge->scratch_page, intel_i830_private.gtt+i);
-			readl(intel_i830_private.gtt+i);	/* PCI Posting. */
+		for (i = intel_private.gtt_entries; i < current_size->num_entries; i++) {
+			writel(agp_bridge->scratch_page, intel_private.gtt+i);
+			readl(intel_private.gtt+i);	/* PCI Posting. */
 		}
 	}
 
@@ -765,8 +760,8 @@ static int intel_i915_configure(void)
 
 static void intel_i915_cleanup(void)
 {
-	iounmap(intel_i830_private.gtt);
-	iounmap(intel_i830_private.registers);
+	iounmap(intel_private.gtt);
+	iounmap(intel_private.registers);
 }
 
 static int intel_i915_insert_entries(struct agp_memory *mem,off_t pg_start,
@@ -783,9 +778,9 @@ static int intel_i915_insert_entries(str
 	temp = agp_bridge->current_size;
 	num_entries = A_SIZE_FIX(temp)->num_entries;
 
-	if (pg_start < intel_i830_private.gtt_entries) {
-		printk (KERN_DEBUG PFX "pg_start == 0x%.8lx,intel_i830_private.gtt_entries == 0x%.8x\n",
-				pg_start,intel_i830_private.gtt_entries);
+	if (pg_start < intel_private.gtt_entries) {
+		printk (KERN_DEBUG PFX "pg_start == 0x%.8lx,intel_private.gtt_entries == 0x%.8x\n",
+				pg_start,intel_private.gtt_entries);
 
 		printk (KERN_INFO PFX "Trying to insert into local/stolen memory\n");
 		goto out_err;
@@ -812,10 +807,10 @@ static int intel_i915_insert_entries(str
 
 	for (i = 0, j = pg_start; i < mem->page_count; i++, j++) {
 		writel(agp_bridge->driver->mask_memory(agp_bridge,
-			mem->memory[i], mask_type), intel_i830_private.gtt+j);
+			mem->memory[i], mask_type), intel_private.gtt+j);
 	}
 
-	readl(intel_i830_private.gtt+j-1);
+	readl(intel_private.gtt+j-1);
 	agp_bridge->driver->tlb_flush(mem);
 
  out:
@@ -833,15 +828,15 @@ static int intel_i915_remove_entries(str
 	if (mem->page_count == 0)
 		return 0;
 
-	if (pg_start < intel_i830_private.gtt_entries) {
+	if (pg_start < intel_private.gtt_entries) {
 		printk (KERN_INFO PFX "Trying to disable local/stolen memory\n");
 		return -EINVAL;
 	}
 
 	for (i = pg_start; i < (mem->page_count + pg_start); i++) {
-		writel(agp_bridge->scratch_page, intel_i830_private.gtt+i);
+		writel(agp_bridge->scratch_page, intel_private.gtt+i);
 	}
-	readl(intel_i830_private.gtt+i-1);
+	readl(intel_private.gtt+i-1);
 
 	agp_bridge->driver->tlb_flush(mem);
 	return 0;
@@ -857,7 +852,7 @@ static int intel_i9xx_fetch_size(void)
 	int aper_size; /* size in megabytes */
 	int i;
 
-	aper_size = pci_resource_len(intel_i830_private.i830_dev, 2) / MB(1);
+	aper_size = pci_resource_len(intel_private.pcidev, 2) / MB(1);
 
 	for (i = 0; i < num_sizes; i++) {
 		if (aper_size == intel_i830_sizes[i].size) {
@@ -885,20 +880,20 @@ static int intel_i915_create_gatt_table(
 	num_entries = size->num_entries;
 	agp_bridge->gatt_table_real = NULL;
 
-	pci_read_config_dword(intel_i830_private.i830_dev, I915_MMADDR, &temp);
-	pci_read_config_dword(intel_i830_private.i830_dev, I915_PTEADDR,&temp2);
+	pci_read_config_dword(intel_private.pcidev, I915_MMADDR, &temp);
+	pci_read_config_dword(intel_private.pcidev, I915_PTEADDR,&temp2);
 
-	intel_i830_private.gtt = ioremap(temp2, 256 * 1024);
-	if (!intel_i830_private.gtt)
+	intel_private.gtt = ioremap(temp2, 256 * 1024);
+	if (!intel_private.gtt)
 		return -ENOMEM;
 
 	temp &= 0xfff80000;
 
-	intel_i830_private.registers = ioremap(temp,128 * 4096);
-	if (!intel_i830_private.registers)
+	intel_private.registers = ioremap(temp,128 * 4096);
+	if (!intel_private.registers)
 		return -ENOMEM;
 
-	temp = readl(intel_i830_private.registers+I810_PGETBL_CTL) & 0xfffff000;
+	temp = readl(intel_private.registers+I810_PGETBL_CTL) & 0xfffff000;
 	global_cache_flush();	/* FIXME: ? */
 
 	/* we have to call this as early as possible after the MMIO base address is known */
@@ -945,20 +940,20 @@ static int intel_i965_create_gatt_table(
        num_entries = size->num_entries;
        agp_bridge->gatt_table_real = NULL;
 
-       pci_read_config_dword(intel_i830_private.i830_dev, I915_MMADDR, &temp);
+       pci_read_config_dword(intel_private.pcidev, I915_MMADDR, &temp);
 
        temp &= 0xfff00000;
-       intel_i830_private.gtt = ioremap((temp + (512 * 1024)) , 512 * 1024);
+       intel_private.gtt = ioremap((temp + (512 * 1024)) , 512 * 1024);
 
-       if (!intel_i830_private.gtt)
+       if (!intel_private.gtt)
                return -ENOMEM;
 
 
-       intel_i830_private.registers = ioremap(temp,128 * 4096);
-       if (!intel_i830_private.registers)
+       intel_private.registers = ioremap(temp,128 * 4096);
+       if (!intel_private.registers)
                return -ENOMEM;
 
-       temp = readl(intel_i830_private.registers+I810_PGETBL_CTL) & 0xfffff000;
+       temp = readl(intel_private.registers+I810_PGETBL_CTL) & 0xfffff000;
        global_cache_flush();   /* FIXME: ? */
 
        /* we have to call this as early as possible after the MMIO base address is known */
@@ -1736,7 +1731,7 @@ static int find_i810(u16 device)
 	i810_dev = pci_get_device(PCI_VENDOR_ID_INTEL, device, NULL);
 	if (!i810_dev)
 		return 0;
-	intel_i810_private.i810_dev = i810_dev;
+	intel_private.pcidev = i810_dev;
 	return 1;
 }
 
@@ -1753,7 +1748,7 @@ static int find_i830(u16 device)
 	if (!i830_dev)
 		return 0;
 
-	intel_i830_private.i830_dev = i830_dev;
+	intel_private.pcidev = i830_dev;
 	return 1;
 }
 
@@ -1953,11 +1948,7 @@ static int __devinit agp_intel_probe(str
 
 	bridge->dev = pdev;
 	bridge->capndx = cap_ptr;
-
-	if (bridge->driver == &intel_810_driver)
-		bridge->dev_private_data = &intel_i810_private;
-	else if (bridge->driver == &intel_830_driver)
-		bridge->dev_private_data = &intel_i830_private;
+	bridge->dev_private_data = &intel_private;
 
 	printk(KERN_INFO PFX "Detected an Intel %s Chipset.\n", name);
 
@@ -2009,10 +2000,8 @@ static void __devexit agp_intel_remove(s
 
 	agp_remove_bridge(bridge);
 
-	if (intel_i810_private.i810_dev)
-		pci_dev_put(intel_i810_private.i810_dev);
-	if (intel_i830_private.i830_dev)
-		pci_dev_put(intel_i830_private.i830_dev);
+	if (intel_private.pcidev)
+		pci_dev_put(intel_private.pcidev);
 
 	agp_put_bridge(bridge);
 }
@@ -2196,10 +2185,8 @@ static int agp_intel_resume(struct pci_d
 	 * as host bridge (00:00) resumes before graphics device (02:00),
 	 * then our access to its pci space can work right.
 	 */
-	if (intel_i810_private.i810_dev)
-		pci_restore_state(intel_i810_private.i810_dev);
-	if (intel_i830_private.i830_dev)
-		pci_restore_state(intel_i830_private.i830_dev);
+	if (intel_private.pcidev)
+		pci_restore_state(intel_private.pcidev);
 
 	if (bridge->driver == &intel_generic_driver)
 		intel_configure();
_

Patches currently in -mm which might be from zhenyu.z.wang@intel.com are

git-agpgart.patch
