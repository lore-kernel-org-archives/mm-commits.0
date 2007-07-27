From: akpm@linux-foundation.org
Subject: + x86_64-get-boot_cpu_id-as-early-for-k8_scan_nodes.patch added to -mm tree
Date: Thu, 26 Jul 2007 23:37:36 -0700
Message-ID: <200707270637.l6R6ba3Z009776@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59142 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758563AbXG0Gh4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 27 Jul 2007 02:37:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: yhlu.kernel@gmail.com, ak@suse.de, clameter@sgi.com, lenb@kernel.org


The patch titled
     x86_64: get boot_cpu_id as early for k8_scan_nodes
has been added to the -mm tree.  Its filename is
     x86_64-get-boot_cpu_id-as-early-for-k8_scan_nodes.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: x86_64: get boot_cpu_id as early for k8_scan_nodes
From: "Yinghai Lu" <yhlu.kernel@gmail.com>

When acpi=off or there is no SRAT defined, apicid_to_node is got from K8
Northbridge PCI configuration space in k8_scan_nodes() in
arch/x86_64/mm/k8toplogy.c.

The problem is that it assumes bsp apic id is 0 at that point.

For four socket system with Quad core cpus installed, all cpus apic id is
offset by 4, and bsp apic id is 4.

For eight socket system with dual core cpus installed, all cpus apic id is
offset by 2, and bsp apic id is 2.

We need get boot_cpu_id --- bsp apic id, before k8_scan_nodes by called.

So create early_acpi_boot_init and early_get_smp_config for get boot_cpu_id.

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Christoph Lameter <clameter@sgi.com>
Cc: Andi Kleen <ak@suse.de>
Cc: Len Brown <lenb@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/acpi/boot.c |   70 +++++++++++++++++++++++++
 arch/x86_64/kernel/apic.c    |   24 ++++++++
 arch/x86_64/kernel/mpparse.c |   89 ++++++++++++++++++++++++---------
 arch/x86_64/kernel/setup.c   |   21 +++++++
 arch/x86_64/mm/k8topology.c  |    8 ++
 include/asm-x86_64/apic.h    |    1 
 include/asm-x86_64/mpspec.h  |    2 
 include/linux/acpi.h         |    5 +
 8 files changed, 196 insertions(+), 24 deletions(-)

diff -puN arch/i386/kernel/acpi/boot.c~x86_64-get-boot_cpu_id-as-early-for-k8_scan_nodes arch/i386/kernel/acpi/boot.c
--- a/arch/i386/kernel/acpi/boot.c~x86_64-get-boot_cpu_id-as-early-for-k8_scan_nodes
+++ a/arch/i386/kernel/acpi/boot.c
@@ -736,6 +736,32 @@ unsigned long __init acpi_find_rsdp(void
  * Parse LAPIC entries in MADT
  * returns 0 on success, < 0 on error
  */
+static int __init early_acpi_parse_madt_lapic_addr_ovr(void)
+{
+	int count;
+
+	if (!cpu_has_apic)
+		return -ENODEV;
+
+	/*
+	 * Note that the LAPIC address is obtained from the MADT (32-bit value)
+	 * and (optionally) overriden by a LAPIC_ADDR_OVR entry (64-bit value).
+	 */
+
+	count =
+	    acpi_table_parse_madt(ACPI_MADT_TYPE_LOCAL_APIC_OVERRIDE,
+				  acpi_parse_lapic_addr_ovr, 0);
+	if (count < 0) {
+		printk(KERN_ERR PREFIX
+		       "Error parsing LAPIC address override entry\n");
+		return count;
+	}
+
+	mp_register_lapic_address(acpi_lapic_addr);
+
+	return count;
+}
+
 static int __init acpi_parse_madt_lapic_entries(void)
 {
 	int count;
@@ -862,6 +888,33 @@ static inline int acpi_parse_madt_ioapic
 }
 #endif	/* !CONFIG_X86_IO_APIC */
 
+static void __init early_acpi_process_madt(void)
+{
+#ifdef CONFIG_X86_LOCAL_APIC
+	int error;
+
+	if (!acpi_table_parse(ACPI_SIG_MADT, acpi_parse_madt)) {
+
+		/*
+		 * Parse MADT LAPIC entries
+		 */
+		error = early_acpi_parse_madt_lapic_addr_ovr();
+		if (!error) {
+			acpi_lapic = 1;
+			smp_found_config = 1;
+		}
+		if (error == -EINVAL) {
+			/*
+			 * Dell Precision Workstation 410, 610 come here.
+			 */
+			printk(KERN_ERR PREFIX
+			       "Invalid BIOS MADT, disabling ACPI\n");
+			disable_acpi();
+		}
+	}
+#endif
+}
+
 static void __init acpi_process_madt(void)
 {
 #ifdef CONFIG_X86_LOCAL_APIC
@@ -1194,6 +1247,23 @@ int __init acpi_boot_table_init(void)
 	return 0;
 }
 
+int __init early_acpi_boot_init(void)
+{
+	/*
+	 * If acpi_disabled, bail out
+	 * One exception: acpi=ht continues far enough to enumerate LAPICs
+	 */
+	if (acpi_disabled && !acpi_ht)
+		return 1;
+
+	/*
+	 * Process the Multiple APIC Description Table (MADT), if present
+	 */
+	early_acpi_process_madt();
+
+	return 0;
+}
+
 int __init acpi_boot_init(void)
 {
 	/*
diff -puN arch/x86_64/kernel/apic.c~x86_64-get-boot_cpu_id-as-early-for-k8_scan_nodes arch/x86_64/kernel/apic.c
--- a/arch/x86_64/kernel/apic.c~x86_64-get-boot_cpu_id-as-early-for-k8_scan_nodes
+++ a/arch/x86_64/kernel/apic.c
@@ -689,6 +689,30 @@ static int __init ioapic_insert_resource
 late_initcall(ioapic_insert_resources);
 #endif
 
+void __init early_init_lapic_mapping(void)
+{
+	unsigned long apic_phys;
+
+	/*
+	 * If no local APIC can be found then go out
+	 * : it means there is no mpatable and MADT
+	 */
+	if (!smp_found_config)
+		return;
+
+	apic_phys = mp_lapic_addr;
+
+	set_fixmap_nocache(FIX_APIC_BASE, apic_phys);
+	apic_printk(APIC_VERBOSE, "mapped APIC to %16lx (%16lx)\n",
+				 APIC_BASE, apic_phys);
+
+	/*
+	 * Fetch the APIC ID of the BSP in case we have a
+	 * default configuration (or the MP table is broken).
+	 */
+	boot_cpu_id = GET_APIC_ID(apic_read(APIC_ID));
+}
+
 void __init init_apic_mappings(void)
 {
 	unsigned long apic_phys;
diff -puN arch/x86_64/kernel/mpparse.c~x86_64-get-boot_cpu_id-as-early-for-k8_scan_nodes arch/x86_64/kernel/mpparse.c
--- a/arch/x86_64/kernel/mpparse.c~x86_64-get-boot_cpu_id-as-early-for-k8_scan_nodes
+++ a/arch/x86_64/kernel/mpparse.c
@@ -202,8 +202,7 @@ static void __init MP_lintsrc_info (stru
 /*
  * Read/parse the MPC
  */
-
-static int __init smp_read_mpc(struct mp_config_table *mpc)
+static int __init smp_read_mpc(struct mp_config_table *mpc, unsigned early)
 {
 	char str[16];
 	int count=sizeof(*mpc);
@@ -244,6 +243,9 @@ static int __init smp_read_mpc(struct mp
 	if (!acpi_lapic)
 		mp_lapic_addr = mpc->mpc_lapic;
 
+	if (early)
+		return 1;
+
 	/*
 	 *	Now process the configuration blocks.
 	 */
@@ -455,27 +457,38 @@ static struct intel_mp_floating *mpf_fou
 /*
  * Scan the memory blocks for an SMP configuration block.
  */
-void __init get_smp_config (void)
+static void __init __get_smp_config(unsigned early)
 {
 	struct intel_mp_floating *mpf = mpf_found;
 
+	if (acpi_lapic && early)
+		return;
 	/*
- 	 * ACPI supports both logical (e.g. Hyper-Threading) and physical 
- 	 * processors, where MPS only supports physical.
- 	 */
- 	if (acpi_lapic && acpi_ioapic) {
- 		printk(KERN_INFO "Using ACPI (MADT) for SMP configuration information\n");
- 		return;
-	}
- 	else if (acpi_lapic)
- 		printk(KERN_INFO "Using ACPI for processor (LAPIC) configuration information\n");
+	 * ACPI supports both logical (e.g. Hyper-Threading) and physical
+	 * processors, where MPS only supports physical.
+	 */
+	if (acpi_lapic && acpi_ioapic) {
+		printk(KERN_INFO "Using ACPI (MADT) for SMP configuration "
+			"information\n");
+		return;
+	} else if (acpi_lapic)
+		printk(KERN_INFO "Using ACPI for processor (LAPIC) "
+			"configuration information\n");
 
-	printk("Intel MultiProcessor Specification v1.%d\n", mpf->mpf_specification);
+	printk(KERN_INFO "Intel MultiProcessor Specification v1.%d\n",
+		mpf->mpf_specification);
 
 	/*
 	 * Now see if we need to read further.
 	 */
 	if (mpf->mpf_feature1 != 0) {
+		if (early) {
+			/*
+			 * local APIC has default address
+			 */
+			mp_lapic_addr = APIC_DEFAULT_PHYS_BASE;
+			return;
+		}
 
 		printk(KERN_INFO "Default MP configuration #%d\n", mpf->mpf_feature1);
 		construct_default_ISA_mptable(mpf->mpf_feature1);
@@ -486,12 +499,15 @@ void __init get_smp_config (void)
 		 * Read the physical hardware table.  Anything here will
 		 * override the defaults.
 		 */
-		if (!smp_read_mpc(phys_to_virt(mpf->mpf_physptr))) {
+		if (!smp_read_mpc(phys_to_virt(mpf->mpf_physptr), early)) {
 			smp_found_config = 0;
 			printk(KERN_ERR "BIOS bug, MP table errors detected!...\n");
 			printk(KERN_ERR "... disabling SMP support. (tell your hw vendor)\n");
 			return;
 		}
+
+		if (early)
+			return;
 		/*
 		 * If there are no explicit MP IRQ entries, then we are
 		 * broken.  We set up most of the low 16 IO-APIC pins to
@@ -513,13 +529,25 @@ void __init get_smp_config (void)
 	} else
 		BUG();
 
-	printk(KERN_INFO "Processors: %d\n", num_processors);
+	if (!early)
+		printk(KERN_INFO "Processors: %d\n", num_processors);
 	/*
 	 * Only use the first configuration found.
 	 */
 }
 
-static int __init smp_scan_config (unsigned long base, unsigned long length)
+void __init early_get_smp_config(void)
+{
+	__get_smp_config(1);
+}
+
+void __init get_smp_config(void)
+{
+	__get_smp_config(0);
+}
+
+static int __init smp_scan_config(unsigned long base, unsigned long length,
+				  unsigned reserve)
 {
 	extern void __bad_mpf_size(void); 
 	unsigned int *bp = phys_to_virt(base);
@@ -538,10 +566,15 @@ static int __init smp_scan_config (unsig
 				|| (mpf->mpf_specification == 4)) ) {
 
 			smp_found_config = 1;
+			mpf_found = mpf;
+
+			if (!reserve)
+				return 1;
+
 			reserve_bootmem_generic(virt_to_phys(mpf), PAGE_SIZE);
 			if (mpf->mpf_physptr)
-				reserve_bootmem_generic(mpf->mpf_physptr, PAGE_SIZE);
-			mpf_found = mpf;
+				reserve_bootmem_generic(mpf->mpf_physptr,
+							PAGE_SIZE);
 			return 1;
 		}
 		bp += 4;
@@ -550,7 +583,7 @@ static int __init smp_scan_config (unsig
 	return 0;
 }
 
-void __init find_smp_config(void)
+static void __init __find_smp_config(unsigned reserve)
 {
 	unsigned int address;
 
@@ -562,9 +595,9 @@ void __init find_smp_config(void)
 	 * 2) Scan the top 1K of base RAM
 	 * 3) Scan the 64K of bios
 	 */
-	if (smp_scan_config(0x0,0x400) ||
-		smp_scan_config(639*0x400,0x400) ||
-			smp_scan_config(0xF0000,0x10000))
+	if (smp_scan_config(0x0, 0x400, reserve) ||
+		smp_scan_config(639*0x400, 0x400, reserve) ||
+			smp_scan_config(0xF0000, 0x10000, reserve))
 		return;
 	/*
 	 * If it is an SMP machine we should know now.
@@ -581,13 +614,23 @@ void __init find_smp_config(void)
 
 	address = *(unsigned short *)phys_to_virt(0x40E);
 	address <<= 4;
-	if (smp_scan_config(address, 0x1000))
+	if (smp_scan_config(address, 0x1000, reserve))
 		return;
 
 	/* If we have come this far, we did not find an MP table  */
 	 printk(KERN_INFO "No mptable found.\n");
 }
 
+void __init early_find_smp_config(void)
+{
+	__find_smp_config(0);
+}
+
+void __init find_smp_config(void)
+{
+	__find_smp_config(1);
+}
+
 /* --------------------------------------------------------------------------
                             ACPI-based MP Configuration
    -------------------------------------------------------------------------- */
diff -puN arch/x86_64/kernel/setup.c~x86_64-get-boot_cpu_id-as-early-for-k8_scan_nodes arch/x86_64/kernel/setup.c
--- a/arch/x86_64/kernel/setup.c~x86_64-get-boot_cpu_id-as-early-for-k8_scan_nodes
+++ a/arch/x86_64/kernel/setup.c
@@ -299,6 +299,27 @@ void __init setup_arch(char **cmdline_p)
 	acpi_numa_init();
 #endif
 
+	/*
+	 * Find possible boot-time SMP configuration:
+	 */
+	early_find_smp_config();
+#ifdef CONFIG_ACPI
+	/*
+	 * Read APIC information from ACPI tables.
+	 */
+	early_acpi_boot_init();
+#endif
+	/*
+	 * get boot-time SMP configuration:
+	 */
+	if (smp_found_config)
+		early_get_smp_config();
+	/*
+	 * need to get boot_cpu_id so can use that to create apicid_to_node
+	 * in k8_scan_nodes() called by numa_initmem_init
+	 */
+	early_init_lapic_mapping();
+
 #ifdef CONFIG_NUMA
 	numa_initmem_init(0, end_pfn); 
 #else
diff -puN arch/x86_64/mm/k8topology.c~x86_64-get-boot_cpu_id-as-early-for-k8_scan_nodes arch/x86_64/mm/k8topology.c
--- a/arch/x86_64/mm/k8topology.c~x86_64-get-boot_cpu_id-as-early-for-k8_scan_nodes
+++ a/arch/x86_64/mm/k8topology.c
@@ -52,6 +52,7 @@ int __init k8_scan_nodes(unsigned long s
 	unsigned cores;
 	unsigned bits;
 	int j;
+	unsigned apicid_base;
 
 	if (!early_pci_allowed())
 		return -1;
@@ -170,11 +171,16 @@ int __init k8_scan_nodes(unsigned long s
 	/* use the coreid bits from early_identify_cpu */
 	bits = boot_cpu_data.x86_coreid_bits;
 	cores = (1<<bits);
+	apicid_base = 0;
+	if (boot_cpu_id > 0) {
+		printk(KERN_INFO "BSP APIC ID: %02x\n", boot_cpu_id);
+		apicid_base = boot_cpu_id;
+	}
 
 	for (i = 0; i < 8; i++) {
 		if (nodes[i].start != nodes[i].end) { 
 			nodeid = nodeids[i];
-			for (j = 0; j < cores; j++)
+			for (j = apicid_base; j < cores + apicid_base; j++)
 				apicid_to_node[(nodeid << bits) + j] = i;
 			setup_node_bootmem(i, nodes[i].start, nodes[i].end); 
 		} 
diff -puN include/asm-x86_64/apic.h~x86_64-get-boot_cpu_id-as-early-for-k8_scan_nodes include/asm-x86_64/apic.h
--- a/include/asm-x86_64/apic.h~x86_64-get-boot_cpu_id-as-early-for-k8_scan_nodes
+++ a/include/asm-x86_64/apic.h
@@ -73,6 +73,7 @@ extern void cache_APIC_registers (void);
 extern void sync_Arb_IDs (void);
 extern void init_bsp_APIC (void);
 extern void setup_local_APIC (void);
+extern void early_init_lapic_mapping(void);
 extern void init_apic_mappings (void);
 extern void smp_local_timer_interrupt (void);
 extern void setup_boot_APIC_clock (void);
diff -puN include/asm-x86_64/mpspec.h~x86_64-get-boot_cpu_id-as-early-for-k8_scan_nodes include/asm-x86_64/mpspec.h
--- a/include/asm-x86_64/mpspec.h~x86_64-get-boot_cpu_id-as-early-for-k8_scan_nodes
+++ a/include/asm-x86_64/mpspec.h
@@ -164,6 +164,8 @@ extern int mp_bus_id_to_pci_bus [MAX_MP_
 
 extern unsigned int boot_cpu_physical_apicid;
 extern int smp_found_config;
+extern void early_find_smp_config(void);
+extern void early_get_smp_config(void);
 extern void find_smp_config (void);
 extern void get_smp_config (void);
 extern int nr_ioapics;
diff -puN include/linux/acpi.h~x86_64-get-boot_cpu_id-as-early-for-k8_scan_nodes include/linux/acpi.h
--- a/include/linux/acpi.h~x86_64-get-boot_cpu_id-as-early-for-k8_scan_nodes
+++ a/include/linux/acpi.h
@@ -80,6 +80,7 @@ typedef int (*acpi_table_entry_handler) 
 
 char * __acpi_map_table (unsigned long phys_addr, unsigned long size);
 unsigned long acpi_find_rsdp (void);
+int early_acpi_boot_init(void);
 int acpi_boot_init (void);
 int acpi_boot_table_init (void);
 int acpi_numa_init (void);
@@ -234,6 +235,10 @@ extern int pnpacpi_disabled;
 
 #else	/* CONFIG_ACPI */
 
+static inline int early_acpi_boot_init(void)
+{
+	return 0;
+}
 static inline int acpi_boot_init(void)
 {
 	return 0;
_

Patches currently in -mm which might be from yhlu.kernel@gmail.com are

x86_64-get-mp_bus_to_node-as-early-v2.patch
x86_64-use-bus-conf-in-nb-conf-fun1-to-get-bus-range-on-node.patch
try-parent-numa_node-at-first-before-using-default-v2.patch
net-use-numa_node-in-net_devcice-dev-instead-of-parent.patch
dma-use-dev_to_node-to-get-node-for-device-in-dma_alloc_pages.patch
x86_64-store-core-id-bits-in-cpuinfo_x8.patch
x86_64-use-core-id-bits-for-apicid_to_node-initialization.patch
x86_64-remove-never-used-apic_mapped.patch
x86_64-get-boot_cpu_id-as-early-for-k8_scan_nodes.patch
