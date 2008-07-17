From: akpm@linux-foundation.org
Subject: + calgary-iommu-use-the-first-kernels-tce-tables-in-kdump.patch added to -mm tree
Date: Thu, 17 Jul 2008 16:16:47 -0700
Message-ID: <200807172316.m6HNGmf1011917@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45502 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753740AbYGQXUJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 17 Jul 2008 19:20:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: chandru@in.ibm.com, mingo@elte.hu, muli@il.ibm.com, tglx@linutronix.de


The patch titled
     calgary iommu: Use the first kernel's tce tables in kdump
has been added to the -mm tree.  Its filename is
     calgary-iommu-use-the-first-kernels-tce-tables-in-kdump.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: calgary iommu: Use the first kernel's tce tables in kdump
From: Chandru Siddalingappa <chandru@in.ibm.com>

kdump kernel fails to boot with calgary iommu and aacraid driver on a x366
box.  The ongoing dma's of aacraid from the first kernel continue to exist
until the driver is loaded in the kdump kernel.  Calgary is initialized
prior to aacraid and creation of new tce tables causes wrong dma's to
occur.  Here we try to get the tce tables of the first kernel in kdump
kernel and use them.  While in the kdump kernel we do not allocate new tce
tables but instead read the base addres register contents of calgary iommu
and use the tables that the registers point to.  With these changes the
kdump kernel and hence aacraid now boots normally.

Signed-off-by: Chandru Siddalingappa <chandru@in.ibm.com>
Acked-by: Muli Ben-Yehuda <muli@il.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/pci-calgary_64.c |   85 ++++++++++++++++++++++++++---
 include/linux/crash_dump.h       |    8 ++
 2 files changed, 87 insertions(+), 6 deletions(-)

diff -puN arch/x86/kernel/pci-calgary_64.c~calgary-iommu-use-the-first-kernels-tce-tables-in-kdump arch/x86/kernel/pci-calgary_64.c
--- a/arch/x86/kernel/pci-calgary_64.c~calgary-iommu-use-the-first-kernels-tce-tables-in-kdump
+++ a/arch/x86/kernel/pci-calgary_64.c
@@ -29,6 +29,7 @@
 #include <linux/mm.h>
 #include <linux/spinlock.h>
 #include <linux/string.h>
+#include <linux/crash_dump.h>
 #include <linux/dma-mapping.h>
 #include <linux/bitops.h>
 #include <linux/pci_ids.h>
@@ -168,6 +169,8 @@ static void calgary_dump_error_regs(stru
 static void calioc2_handle_quirks(struct iommu_table *tbl, struct pci_dev *dev);
 static void calioc2_tce_cache_blast(struct iommu_table *tbl);
 static void calioc2_dump_error_regs(struct iommu_table *tbl);
+static void calgary_init_bitmap_from_tce_table(struct iommu_table *tbl);
+static void get_tce_space_from_tar(void);
 
 static struct cal_chipset_ops calgary_chip_ops = {
 	.handle_quirks = calgary_handle_quirks,
@@ -797,7 +800,11 @@ static int __init calgary_setup_tar(stru
 
 	tbl = pci_iommu(dev->bus);
 	tbl->it_base = (unsigned long)bus_info[dev->bus->number].tce_space;
-	tce_free(tbl, 0, tbl->it_size);
+
+	if (is_kdump_kernel())
+		calgary_init_bitmap_from_tce_table(tbl);
+	else
+		tce_free(tbl, 0, tbl->it_size);
 
 	if (is_calgary(dev->device))
 		tbl->chip_ops = &calgary_chip_ops;
@@ -1176,6 +1183,10 @@ static int __init calgary_init(void)
 	if (ret)
 		return ret;
 
+	/* Purely for kdump kernel case  */
+	if (is_kdump_kernel())
+		get_tce_space_from_tar();
+
 	do {
 		dev = pci_get_device(PCI_VENDOR_ID_IBM, PCI_ANY_ID, dev);
 		if (!dev)
@@ -1234,6 +1245,23 @@ error:
 	return ret;
 }
 
+/*
+ * calgary_init_bitmap_from_tce_table():
+ * Funtion for kdump case. In the second/kdump kernel initialize
+ * the bitmap based on the tce table entries obtained from first kernel
+ */
+static void calgary_init_bitmap_from_tce_table(struct iommu_table *tbl)
+{
+	u64 *tp;
+	unsigned int index;
+	tp = ((u64 *)tbl->it_base);
+	for (index = 0 ; index < tbl->it_size; index++) {
+		if (*tp != 0x0)
+			set_bit(index, tbl->it_map);
+		tp++;
+	}
+}
+
 static inline int __init determine_tce_table_size(u64 ram)
 {
 	int ret;
@@ -1318,12 +1346,50 @@ static int __init calgary_bus_has_device
 	return (val != 0xffffffff);
 }
 
+/*
+ * get_tce_space_from_tar():
+ * Function for kdump case. Get the tce tables from first kernel
+ * by reading the contents of the base adress register of calgary iommu
+ */
+static void get_tce_space_from_tar()
+{
+	int bus;
+	void __iomem *target;
+	unsigned long tce_space;
+
+	for (bus = 0; bus < MAX_PHB_BUS_NUM; bus++) {
+		struct calgary_bus_info *info = &bus_info[bus];
+		unsigned short pci_device;
+		u32 val;
+
+		val = read_pci_config(bus, 0, 0, 0);
+		pci_device = (val & 0xFFFF0000) >> 16;
+
+		if (!is_cal_pci_dev(pci_device))
+			continue;
+		if (info->translation_disabled)
+			continue;
+
+		if (calgary_bus_has_devices(bus, pci_device) ||
+			translate_empty_slots) {
+			target = calgary_reg(bus_info[bus].bbar,
+				tar_offset(bus));
+			tce_space = be64_to_cpu(readq(target));
+			tce_space = tce_space & TAR_SW_BITS;
+
+			tce_space = tce_space & (~specified_table_size);
+			info->tce_space = (u64 *)__va(tce_space);
+		}
+	}
+	return;
+}
+
 void __init detect_calgary(void)
 {
 	int bus;
 	void *tbl;
 	int calgary_found = 0;
-	unsigned long ptr;
+	unsigned long ptr, max_pfn;
 	unsigned int offset, prev_offset;
 	int ret;
 
@@ -1373,6 +1439,7 @@ void __init detect_calgary(void)
 		return;
 	}
 
+	max_pfn = is_kdump_kernel() ? saved_max_pfn : end_pfn ;
 	specified_table_size = determine_tce_table_size(max_pfn * PAGE_SIZE);
 
 	for (bus = 0; bus < MAX_PHB_BUS_NUM; bus++) {
@@ -1391,10 +1458,16 @@ void __init detect_calgary(void)
 
 		if (calgary_bus_has_devices(bus, pci_device) ||
 		    translate_empty_slots) {
-			tbl = alloc_tce_table();
-			if (!tbl)
-				goto cleanup;
-			info->tce_space = tbl;
+			/*
+			 * If it is kdump kernel, find and use tce tables
+			 * from first kernel, else allocate tce tables here
+			 */
+			if (!is_kdump_kernel()) {
+				tbl = alloc_tce_table();
+				if (!tbl)
+					goto cleanup;
+				info->tce_space = tbl;
+			}
 			calgary_found = 1;
 		}
 	}
diff -puN include/linux/crash_dump.h~calgary-iommu-use-the-first-kernels-tce-tables-in-kdump include/linux/crash_dump.h
--- a/include/linux/crash_dump.h~calgary-iommu-use-the-first-kernels-tce-tables-in-kdump
+++ a/include/linux/crash_dump.h
@@ -22,5 +22,13 @@ extern struct proc_dir_entry *proc_vmcor
 
 #define vmcore_elf_check_arch(x) (elf_check_arch(x) || vmcore_elf_check_arch_cross(x))
 
+static inline int is_kdump_kernel(void)
+{
+	return (elfcorehdr_addr != ELFCORE_ADDR_MAX) ? 1 : 0 ;
+}
+#else /* !CONFIG_CRASH_DUMP */
+static inline int is_kdump_kernel(void) { return 0; }
 #endif /* CONFIG_CRASH_DUMP */
+
+extern unsigned long saved_max_pfn;
 #endif /* LINUX_CRASHDUMP_H */
_

Patches currently in -mm which might be from chandru@in.ibm.com are

calgary-iommu-use-the-first-kernels-tce-tables-in-kdump.patch
calgary-iommu-use-the-first-kernels-tce-tables-in-kdump-coding-style-fixes.patch

