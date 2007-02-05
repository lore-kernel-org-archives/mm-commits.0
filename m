From: akpm@linux-foundation.org
Subject: - git-acpi-fix_i386_srat.patch removed from -mm tree
Date: Mon, 05 Feb 2007 12:41:04 -0800
Message-ID: <200702052041.l15Kf5VP030547@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:32897 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933414AbXBEUwC (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 5 Feb 2007 15:52:02 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alexey.y.starikovskiy@intel.com, clg@fr.ibm.com, kmannth@us.ibm.com, lenb@kernel.org, robert.moore@intel.com, mm-commits@vger.kernel.org


The patch titled
     git-acpi: fix_i386_srat
has been removed from the -mm tree.  Its filename was
     git-acpi-fix_i386_srat.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: git-acpi: fix_i386_srat
From: "Starikovskiy, Alexey Y" <alexey.y.starikovskiy@intel.com>

arch/i386/kernel/srat.c: In function 'parse_cpu_affinity_structure':
arch/i386/kernel/srat.c:68: error: dereferencing pointer to incomplete
ype
arch/i386/kernel/srat.c:72: error: dereferencing pointer to incomplete
ype
arch/i386/kernel/srat.c:72: error: dereferencing pointer to incomplete
ype
arch/i386/kernel/srat.c:74: error: dereferencing pointer to incomplete
ype
arch/i386/kernel/srat.c:74: error: dereferencing pointer to incomplete
ype
arch/i386/kernel/srat.c:77: error: dereferencing pointer to incomplete
ype
arch/i386/kernel/srat.c:77: error: dereferencing pointer to incomplete
type
arch/i386/kernel/srat.c: In function 'parse_memory_affinity_structure':
arch/i386/kernel/srat.c:93: error: dereferencing pointer to incomplete

Cc: "Cedric Le Goater" <clg@fr.ibm.com>
Cc: "Moore, Robert" <robert.moore@intel.com>
Cc: "keith mannthey" <kmannth@us.ibm.com>
Cc: Len Brown <lenb@kernel.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 arch/i386/kernel/srat.c |   77 ++++++++++++++++++--------------------
 1 files changed, 37 insertions(+), 40 deletions(-)

diff -puN arch/i386/kernel/srat.c~git-acpi-fix_i386_srat arch/i386/kernel/srat.c
--- a/arch/i386/kernel/srat.c~git-acpi-fix_i386_srat
+++ a/arch/i386/kernel/srat.c
@@ -62,19 +62,19 @@ extern void * boot_ioremap(unsigned long
 /* Identify CPU proximity domains */
 static void __init parse_cpu_affinity_structure(char *p)
 {
-	struct acpi_table_processor_affinity *cpu_affinity = 
-				(struct acpi_table_processor_affinity *) p;
+	struct acpi_srat_cpu_affinity *cpu_affinity =
+				(struct acpi_srat_cpu_affinity *) p;
 
-	if (!cpu_affinity->flags.enabled)
+	if ((cpu_affinity->flags & ACPI_SRAT_CPU_ENABLED) == 0)
 		return;		/* empty entry */
 
 	/* mark this node as "seen" in node bitmap */
-	BMAP_SET(pxm_bitmap, cpu_affinity->proximity_domain);
+	BMAP_SET(pxm_bitmap, cpu_affinity->proximity_domain_lo);
 
-	apicid_to_pxm[cpu_affinity->apic_id] = cpu_affinity->proximity_domain;
+	apicid_to_pxm[cpu_affinity->apic_id] = cpu_affinity->proximity_domain_lo;
 
 	printk("CPU 0x%02X in proximity domain 0x%02X\n",
-		cpu_affinity->apic_id, cpu_affinity->proximity_domain);
+		cpu_affinity->apic_id, cpu_affinity->proximity_domain_lo);
 }
 
 /*
@@ -87,25 +87,24 @@ static void __init parse_memory_affinity
 	unsigned long start_pfn, end_pfn; 
 	u8 pxm;
 	struct node_memory_chunk_s *p, *q, *pend;
-	struct acpi_table_memory_affinity *memory_affinity =
-			(struct acpi_table_memory_affinity *) sratp;
+	struct acpi_srat_mem_affinity *memory_affinity =
+			(struct acpi_srat_mem_affinity *) sratp;
 
-	if (!memory_affinity->flags.enabled)
+	if ((memory_affinity->flags & ACPI_SRAT_MEM_ENABLED) == 0)
 		return;		/* empty entry */
 
+	pxm = memory_affinity->proximity_domain & 0xff;
+
 	/* mark this node as "seen" in node bitmap */
-	BMAP_SET(pxm_bitmap, memory_affinity->proximity_domain);
+	BMAP_SET(pxm_bitmap, pxm);
 
 	/* calculate info for memory chunk structure */
-	paddr = memory_affinity->base_addr_hi;
-	paddr = (paddr << 32) | memory_affinity->base_addr_lo;
-	size = memory_affinity->length_hi;
-	size = (size << 32) | memory_affinity->length_lo;
+	paddr = memory_affinity->base_address;
+	size = memory_affinity->length;
 	
 	start_pfn = paddr >> PAGE_SHIFT;
 	end_pfn = (paddr + size) >> PAGE_SHIFT;
 	
-	pxm = memory_affinity->proximity_domain;
 
 	if (num_memory_chunks >= MAXCHUNKS) {
 		printk("Too many mem chunks in SRAT. Ignoring %lld MBytes at %llx\n",
@@ -132,8 +131,8 @@ static void __init parse_memory_affinity
 	printk("Memory range 0x%lX to 0x%lX (type 0x%X) in proximity domain 0x%02X %s\n",
 		start_pfn, end_pfn,
 		memory_affinity->memory_type,
-		memory_affinity->proximity_domain,
-		(memory_affinity->flags.hot_pluggable ?
+		pxm,
+		((memory_affinity->flags & ACPI_SRAT_MEM_HOT_PLUGGABLE) ?
 		 "enabled and removable" : "enabled" ) );
 }
 
@@ -185,10 +184,10 @@ static int __init acpi20_parse_srat(stru
 	num_memory_chunks = 0;
 	while (p < end) {
 		switch (*p) {
-		case ACPI_SRAT_PROCESSOR_AFFINITY:
+		case ACPI_SRAT_TYPE_CPU_AFFINITY:
 			parse_cpu_affinity_structure(p);
 			break;
-		case ACPI_SRAT_MEMORY_AFFINITY:
+		case ACPI_SRAT_TYPE_MEMORY_AFFINITY:
 			parse_memory_affinity_structure(p);
 			break;
 		default:
@@ -262,31 +261,29 @@ out_fail:
 	return 0;
 }
 
+struct acpi_static_rsdt {
+	struct acpi_table_rsdt table;
+	u32 padding[7]; /* Allow for 7 more table entries */
+};
+
 int __init get_memcfg_from_srat(void)
 {
 	struct acpi_table_header *header = NULL;
 	struct acpi_table_rsdp *rsdp = NULL;
 	struct acpi_table_rsdt *rsdt = NULL;
-	struct acpi_pointer *rsdp_address = NULL;
-	struct acpi_table_rsdt saved_rsdt;
+	acpi_native_uint rsdp_address = 0;
+	struct acpi_static_rsdt saved_rsdt;
 	int tables = 0;
 	int i = 0;
 
-	if (ACPI_FAILURE(acpi_find_root_pointer(ACPI_PHYSICAL_ADDRESSING,
-						rsdp_address))) {
+	if (ACPI_FAILURE(acpi_find_root_pointer(&rsdp_address))) {
 		printk("%s: System description tables not found\n",
 		       __FUNCTION__);
 		goto out_err;
 	}
 
-	if (rsdp_address->pointer_type == ACPI_PHYSICAL_POINTER) {
-		printk("%s: assigning address to rsdp\n", __FUNCTION__);
-		rsdp = (struct acpi_table_rsdp *)
-				(u32)rsdp_address->pointer.physical;
-	} else {
-		printk("%s: rsdp_address is not a physical pointer\n", __FUNCTION__);
-		goto out_err;
-	}
+	printk("%s: assigning address to rsdp\n", __FUNCTION__);
+	rsdp = (struct acpi_table_rsdp *)(u32)rsdp_address;
 	if (!rsdp) {
 		printk("%s: Didn't find ACPI root!\n", __FUNCTION__);
 		goto out_err;
@@ -295,13 +292,13 @@ int __init get_memcfg_from_srat(void)
 	printk(KERN_INFO "%.8s v%d [%.6s]\n", rsdp->signature, rsdp->revision,
 		rsdp->oem_id);
 
-	if (strncmp(rsdp->signature, RSDP_SIG,strlen(RSDP_SIG))) {
+	if (strncmp(rsdp->signature, ACPI_SIG_RSDP,strlen(ACPI_SIG_RSDP))) {
 		printk(KERN_WARNING "%s: RSDP table signature incorrect\n", __FUNCTION__);
 		goto out_err;
 	}
 
 	rsdt = (struct acpi_table_rsdt *)
-	    boot_ioremap(rsdp->rsdt_address, sizeof(struct acpi_table_rsdt));
+	    boot_ioremap(rsdp->rsdt_physical_address, sizeof(struct acpi_table_rsdt));
 
 	if (!rsdt) {
 		printk(KERN_WARNING
@@ -310,9 +307,9 @@ int __init get_memcfg_from_srat(void)
 		goto out_err;
 	}
 
-	header = & rsdt->header;
+	header = &rsdt->header;
 
-	if (strncmp(header->signature, RSDT_SIG, strlen(RSDT_SIG))) {
+	if (strncmp(header->signature, ACPI_SIG_RSDT, strlen(ACPI_SIG_RSDT))) {
 		printk(KERN_WARNING "ACPI: RSDT signature incorrect\n");
 		goto out_err;
 	}
@@ -330,9 +327,9 @@ int __init get_memcfg_from_srat(void)
 
 	memcpy(&saved_rsdt, rsdt, sizeof(saved_rsdt));
 
-	if (saved_rsdt.header.length > sizeof(saved_rsdt)) {
+	if (saved_rsdt.table.header.length > sizeof(saved_rsdt)) {
 		printk(KERN_WARNING "ACPI: Too big length in RSDT: %d\n",
-		       saved_rsdt.header.length);
+		       saved_rsdt.table.header.length);
 		goto out_err;
 	}
 
@@ -341,15 +338,15 @@ int __init get_memcfg_from_srat(void)
 	for (i = 0; i < tables; i++) {
 		/* Map in header, then map in full table length. */
 		header = (struct acpi_table_header *)
-			boot_ioremap(saved_rsdt.entry[i], sizeof(struct acpi_table_header));
+			boot_ioremap(saved_rsdt.table.table_offset_entry[i], sizeof(struct acpi_table_header));
 		if (!header)
 			break;
 		header = (struct acpi_table_header *)
-			boot_ioremap(saved_rsdt.entry[i], header->length);
+			boot_ioremap(saved_rsdt.table.table_offset_entry[i], header->length);
 		if (!header)
 			break;
 
-		if (strncmp((char *) &header->signature, "SRAT", 4))
+		if (strncmp((char *) &header->signature, ACPI_SIG_SRAT, 4))
 			continue;
 
 		/* we've found the srat table. don't need to look at any more tables */
_

Patches currently in -mm which might be from alexey.y.starikovskiy@intel.com are

git-acpi.patch
