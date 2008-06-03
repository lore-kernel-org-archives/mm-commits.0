From: akpm@linux-foundation.org
Subject: - x86-update-macros-used-by-uv-platform.patch removed from -mm tree
Date: Tue, 03 Jun 2008 12:02:32 -0700
Message-ID: <200806031902.m53J2W7V014806@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41836 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755109AbYFCTDZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 3 Jun 2008 15:03:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: steiner@sgi.com, mm-commits@vger.kernel.org


The patch titled
     x86: update macros used by UV platform
has been removed from the -mm tree.  Its filename was
     x86-update-macros-used-by-uv-platform.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: x86: update macros used by UV platform
From: Jack Steiner <steiner@sgi.com>

Update the UV address macros to better describe the fields of UV physical
addresses.  Improve comments in the header files.  Add additional MMR
definitions.

Signed-off-by: Jack Steiner <steiner@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/genx2apic_uv_x.c |  141 +++++---
 include/asm-x86/uv/uv_hub.h      |  188 +++++++---
 include/asm-x86/uv/uv_mmrs.h     |  509 ++++++++++++++++++++++++++++-
 3 files changed, 731 insertions(+), 107 deletions(-)

diff -puN arch/x86/kernel/genx2apic_uv_x.c~x86-update-macros-used-by-uv-platform arch/x86/kernel/genx2apic_uv_x.c
--- a/arch/x86/kernel/genx2apic_uv_x.c~x86-update-macros-used-by-uv-platform
+++ a/arch/x86/kernel/genx2apic_uv_x.c
@@ -5,7 +5,7 @@
  *
  * SGI UV APIC functions (note: not an Intel compatible APIC)
  *
- * Copyright (C) 2007 Silicon Graphics, Inc. All rights reserved.
+ * Copyright (C) 2007-2008 Silicon Graphics, Inc. All rights reserved.
  */
 
 #include <linux/threads.h>
@@ -55,37 +55,37 @@ static cpumask_t uv_vector_allocation_do
 int uv_wakeup_secondary(int phys_apicid, unsigned int start_rip)
 {
 	unsigned long val;
-	int nasid;
+	int pnode;
 
-	nasid = uv_apicid_to_nasid(phys_apicid);
+	pnode = uv_apicid_to_pnode(phys_apicid);
 	val = (1UL << UVH_IPI_INT_SEND_SHFT) |
 	    (phys_apicid << UVH_IPI_INT_APIC_ID_SHFT) |
 	    (((long)start_rip << UVH_IPI_INT_VECTOR_SHFT) >> 12) |
 	    APIC_DM_INIT;
-	uv_write_global_mmr64(nasid, UVH_IPI_INT, val);
+	uv_write_global_mmr64(pnode, UVH_IPI_INT, val);
 	mdelay(10);
 
 	val = (1UL << UVH_IPI_INT_SEND_SHFT) |
 	    (phys_apicid << UVH_IPI_INT_APIC_ID_SHFT) |
 	    (((long)start_rip << UVH_IPI_INT_VECTOR_SHFT) >> 12) |
 	    APIC_DM_STARTUP;
-	uv_write_global_mmr64(nasid, UVH_IPI_INT, val);
+	uv_write_global_mmr64(pnode, UVH_IPI_INT, val);
 	return 0;
 }
 
 static void uv_send_IPI_one(int cpu, int vector)
 {
 	unsigned long val, apicid, lapicid;
-	int nasid;
+	int pnode;
 
 	apicid = per_cpu(x86_cpu_to_apicid, cpu); /* ZZZ - cache node-local ? */
 	lapicid = apicid & 0x3f;		/* ZZZ macro needed */
-	nasid = uv_apicid_to_nasid(apicid);
+	pnode = uv_apicid_to_pnode(apicid);
 	val =
 	    (1UL << UVH_IPI_INT_SEND_SHFT) | (lapicid <<
 					      UVH_IPI_INT_APIC_ID_SHFT) |
 	    (vector << UVH_IPI_INT_VECTOR_SHFT);
-	uv_write_global_mmr64(nasid, UVH_IPI_INT, val);
+	uv_write_global_mmr64(pnode, UVH_IPI_INT, val);
 }
 
 static void uv_send_IPI_mask(cpumask_t mask, int vector)
@@ -159,39 +159,81 @@ struct genapic apic_x2apic_uv_x = {
 	.phys_pkg_id = phys_pkg_id,	/* Fixme ZZZ */
 };
 
-static __cpuinit void set_x2apic_extra_bits(int nasid)
+static __cpuinit void set_x2apic_extra_bits(int pnode)
 {
-	__get_cpu_var(x2apic_extra_bits) = ((nasid >> 1) << 6);
+	__get_cpu_var(x2apic_extra_bits) = (pnode << 6);
 }
 
 /*
  * Called on boot cpu.
  */
+static __init int boot_pnode_to_blade(int pnode)
+{
+	int blade;
+
+	for (blade = 0; blade < uv_num_possible_blades(); blade++)
+		if (pnode == uv_blade_info[blade].pnode)
+			return blade;
+	BUG();
+}
+
+struct redir_addr {
+	unsigned long redirect;
+	unsigned long alias;
+};
+
+#define DEST_SHIFT UVH_RH_GAM_ALIAS210_REDIRECT_CONFIG_0_MMR_DEST_BASE_SHFT
+
+static __initdata struct redir_addr redir_addrs[] = {
+	{UVH_RH_GAM_ALIAS210_REDIRECT_CONFIG_0_MMR, UVH_SI_ALIAS0_OVERLAY_CONFIG},
+	{UVH_RH_GAM_ALIAS210_REDIRECT_CONFIG_1_MMR, UVH_SI_ALIAS1_OVERLAY_CONFIG},
+	{UVH_RH_GAM_ALIAS210_REDIRECT_CONFIG_2_MMR, UVH_SI_ALIAS2_OVERLAY_CONFIG},
+};
+
+static __init void get_lowmem_redirect(unsigned long *base, unsigned long *size)
+{
+	union uvh_si_alias0_overlay_config_u alias;
+	union uvh_rh_gam_alias210_redirect_config_2_mmr_u redirect;
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(redir_addrs); i++) {
+		alias.v = uv_read_local_mmr(redir_addrs[i].alias);
+		if (alias.s.base == 0) {
+			*size = (1UL << alias.s.m_alias);
+			redirect.v = uv_read_local_mmr(redir_addrs[i].redirect);
+			*base = (unsigned long)redirect.s.dest_base << DEST_SHIFT;
+			return;
+		}
+	}
+	BUG();
+}
+
 static __init void uv_system_init(void)
 {
 	union uvh_si_addr_map_config_u m_n_config;
-	int bytes, nid, cpu, lcpu, nasid, last_nasid, blade;
-	unsigned long mmr_base;
+	union uvh_node_id_u node_id;
+	unsigned long gnode_upper, lowmem_redir_base, lowmem_redir_size;
+	int bytes, nid, cpu, lcpu, pnode, blade, i, j, m_val, n_val;
+	unsigned long mmr_base, present;
 
 	m_n_config.v = uv_read_local_mmr(UVH_SI_ADDR_MAP_CONFIG);
+	m_val = m_n_config.s.m_skt;
+	n_val = m_n_config.s.n_skt;
 	mmr_base =
 	    uv_read_local_mmr(UVH_RH_GAM_MMR_OVERLAY_CONFIG_MMR) &
 	    ~UV_MMR_ENABLE;
 	printk(KERN_DEBUG "UV: global MMR base 0x%lx\n", mmr_base);
 
-	last_nasid = -1;
-	for_each_possible_cpu(cpu) {
-		nid = cpu_to_node(cpu);
-		nasid = uv_apicid_to_nasid(per_cpu(x86_cpu_to_apicid, cpu));
-		if (nasid != last_nasid)
-			uv_possible_blades++;
-		last_nasid = nasid;
-	}
+	for(i = 0; i < UVH_NODE_PRESENT_TABLE_DEPTH; i++)
+		uv_possible_blades +=
+		  hweight64(uv_read_local_mmr( UVH_NODE_PRESENT_TABLE + i * 8));
 	printk(KERN_DEBUG "UV: Found %d blades\n", uv_num_possible_blades());
 
 	bytes = sizeof(struct uv_blade_info) * uv_num_possible_blades();
 	uv_blade_info = alloc_bootmem_pages(bytes);
 
+	get_lowmem_redirect(&lowmem_redir_base, &lowmem_redir_size);
+
 	bytes = sizeof(uv_node_to_blade[0]) * num_possible_nodes();
 	uv_node_to_blade = alloc_bootmem_pages(bytes);
 	memset(uv_node_to_blade, 255, bytes);
@@ -200,43 +242,56 @@ static __init void uv_system_init(void)
 	uv_cpu_to_blade = alloc_bootmem_pages(bytes);
 	memset(uv_cpu_to_blade, 255, bytes);
 
-	last_nasid = -1;
-	blade = -1;
-	lcpu = -1;
-	for_each_possible_cpu(cpu) {
-		nid = cpu_to_node(cpu);
-		nasid = uv_apicid_to_nasid(per_cpu(x86_cpu_to_apicid, cpu));
-		if (nasid != last_nasid) {
-			blade++;
-			lcpu = -1;
-			uv_blade_info[blade].nr_posible_cpus = 0;
+	blade = 0;
+	for (i = 0; i < UVH_NODE_PRESENT_TABLE_DEPTH; i++) {
+		present = uv_read_local_mmr(UVH_NODE_PRESENT_TABLE + i * 8);
+		for (j = 0; j < 64; j++) {
+			if (!test_bit(j, &present))
+				continue;
+			uv_blade_info[blade].pnode = (i * 64 + j);
+			uv_blade_info[blade].nr_possible_cpus = 0;
 			uv_blade_info[blade].nr_online_cpus = 0;
+			blade++;
 		}
-		last_nasid = nasid;
-		lcpu++;
+	}
 
-		uv_cpu_hub_info(cpu)->m_val = m_n_config.s.m_skt;
-		uv_cpu_hub_info(cpu)->n_val = m_n_config.s.n_skt;
+	node_id.v = uv_read_local_mmr(UVH_NODE_ID);
+	gnode_upper = (((unsigned long)node_id.s.node_id) &
+		       ~((1 << n_val) - 1)) << m_val;
+
+	for_each_present_cpu(cpu) {
+		nid = cpu_to_node(cpu);
+		pnode = uv_apicid_to_pnode(per_cpu(x86_cpu_to_apicid, cpu));
+		blade = boot_pnode_to_blade(pnode);
+		lcpu = uv_blade_info[blade].nr_possible_cpus;
+		uv_blade_info[blade].nr_possible_cpus++;
+
+		uv_cpu_hub_info(cpu)->lowmem_remap_base = lowmem_redir_base;
+		uv_cpu_hub_info(cpu)->lowmem_remap_top =
+					lowmem_redir_base + lowmem_redir_size;
+		uv_cpu_hub_info(cpu)->m_val = m_val;
+		uv_cpu_hub_info(cpu)->n_val = m_val;
 		uv_cpu_hub_info(cpu)->numa_blade_id = blade;
 		uv_cpu_hub_info(cpu)->blade_processor_id = lcpu;
-		uv_cpu_hub_info(cpu)->local_nasid = nasid;
-		uv_cpu_hub_info(cpu)->gnode_upper =
-		    nasid & ~((1 << uv_hub_info->n_val) - 1);
+		uv_cpu_hub_info(cpu)->pnode = pnode;
+		uv_cpu_hub_info(cpu)->pnode_mask = (1 << n_val) - 1;
+		uv_cpu_hub_info(cpu)->gpa_mask = (1 << (m_val + n_val)) - 1;
+		uv_cpu_hub_info(cpu)->gnode_upper = gnode_upper;
 		uv_cpu_hub_info(cpu)->global_mmr_base = mmr_base;
 		uv_cpu_hub_info(cpu)->coherency_domain_number = 0;/* ZZZ */
-		uv_blade_info[blade].nasid = nasid;
-		uv_blade_info[blade].nr_posible_cpus++;
 		uv_node_to_blade[nid] = blade;
 		uv_cpu_to_blade[cpu] = blade;
 
-		printk(KERN_DEBUG "UV cpu %d, apicid 0x%x, nasid %d, nid %d\n",
-		       cpu, per_cpu(x86_cpu_to_apicid, cpu), nasid, nid);
-		printk(KERN_DEBUG "UV   lcpu %d, blade %d\n", lcpu, blade);
+		printk(KERN_DEBUG "UV cpu %d, apicid 0x%x, pnode %d, nid %d, "
+			"lcpu %d, blade %d\n",
+			cpu, per_cpu(x86_cpu_to_apicid, cpu), pnode, nid,
+			lcpu, blade);
 	}
 }
 
 /*
  * Called on each cpu to initialize the per_cpu UV data area.
+ * 	ZZZ hotplug not supported yet
  */
 void __cpuinit uv_cpu_init(void)
 {
@@ -246,5 +301,5 @@ void __cpuinit uv_cpu_init(void)
 	uv_blade_info[uv_numa_blade_id()].nr_online_cpus++;
 
 	if (get_uv_system_type() == UV_NON_UNIQUE_APIC)
-		set_x2apic_extra_bits(uv_hub_info->local_nasid);
+		set_x2apic_extra_bits(uv_hub_info->pnode);
 }
diff -puN include/asm-x86/uv/uv_hub.h~x86-update-macros-used-by-uv-platform include/asm-x86/uv/uv_hub.h
--- a/include/asm-x86/uv/uv_hub.h~x86-update-macros-used-by-uv-platform
+++ a/include/asm-x86/uv/uv_hub.h
@@ -5,7 +5,7 @@
  *
  * SGI UV architectural definitions
  *
- * Copyright (C) 2007 Silicon Graphics, Inc. All rights reserved.
+ * Copyright (C) 2007-2008 Silicon Graphics, Inc. All rights reserved.
  */
 
 #ifndef __ASM_X86_UV_HUB_H__
@@ -20,26 +20,49 @@
 /*
  * Addressing Terminology
  *
- * 	NASID - network ID of a router, Mbrick or Cbrick. Nasid values of
- * 		routers always have low bit of 1, C/MBricks have low bit
- * 		equal to 0. Most addressing macros that target UV hub chips
- * 		right shift the NASID by 1 to exclude the always-zero bit.
+ *	M       - The low M bits of a physical address represent the offset
+ *		  into the blade local memory. RAM memory on a blade is physically
+ *		  contiguous (although various IO spaces may punch holes in
+ *		  it)..
+ *
+ * 	N	- Number of bits in the node portion of a socket physical
+ * 		  address.
+ *
+ * 	NASID   - network ID of a router, Mbrick or Cbrick. Nasid values of
+ * 	 	  routers always have low bit of 1, C/MBricks have low bit
+ * 		  equal to 0. Most addressing macros that target UV hub chips
+ * 		  right shift the NASID by 1 to exclude the always-zero bit.
+ * 		  NASIDs contain up to 15 bits.
+ *
+ *	GNODE   - NASID right shifted by 1 bit. Most mmrs contain gnodes instead
+ *		  of nasids.
+ *
+ * 	PNODE   - the low N bits of the GNODE. The PNODE is the most useful variant
+ * 		  of the nasid for socket usage.
+ *
+ *
+ *  NumaLink Global Physical Address Format:
+ *  +--------------------------------+---------------------+
+ *  |00..000|      GNODE             |      NodeOffset     |
+ *  +--------------------------------+---------------------+
+ *          |<-------53 - M bits --->|<--------M bits ----->
  *
- *	SNASID - NASID right shifted by 1 bit.
+ *	M - number of node offset bits (35 .. 40)
  *
  *
  *  Memory/UV-HUB Processor Socket Address Format:
- *  +--------+---------------+---------------------+
- *  |00..0000|    SNASID     |      NodeOffset     |
- *  +--------+---------------+---------------------+
- *           <--- N bits --->|<--------M bits ----->
+ *  +----------------+---------------+---------------------+
+ *  |00..000000000000|   PNODE       |      NodeOffset     |
+ *  +----------------+---------------+---------------------+
+ *                   <--- N bits --->|<--------M bits ----->
  *
- *	M number of node offset bits (35 .. 40)
- *	N number of SNASID bits (0 .. 10)
+ *	M - number of node offset bits (35 .. 40)
+ *	N - number of PNODE bits (0 .. 10)
  *
  *		Note: M + N cannot currently exceed 44 (x86_64) or 46 (IA64).
  *		The actual values are configuration dependent and are set at
- *		boot time
+ *		boot time. M & N values are set by the hardware/BIOS at boot.
+ *
  *
  * APICID format
  * 	NOTE!!!!!! This is the current format of the APICID. However, code
@@ -48,14 +71,14 @@
  *
  * 		1111110000000000
  * 		5432109876543210
- *		nnnnnnnnnnlc0cch
+ *		pppppppppplc0cch
  *		sssssssssss
  *
- *			n  = snasid bits
+ *			p  = pnode bits
  *			l =  socket number on board
  *			c  = core
  *			h  = hyperthread
- *			s  = bits that are in the socket CSR
+ *			s  = bits that are in the SOCKET_ID CSR
  *
  *	Note: Processor only supports 12 bits in the APICID register. The ACPI
  *	      tables hold all 16 bits. Software needs to be aware of this.
@@ -74,7 +97,7 @@
  * This value is also the value of the maximum number of non-router NASIDs
  * in the numalink fabric.
  *
- * NOTE: a brick may be 1 or 2 OS nodes. Don't get these confused.
+ * NOTE: a brick may contain 1 or 2 OS nodes. Don't get these confused.
  */
 #define UV_MAX_NUMALINK_BLADES	16384
 
@@ -96,8 +119,12 @@
  */
 struct uv_hub_info_s {
 	unsigned long	global_mmr_base;
-	unsigned short	local_nasid;
-	unsigned short	gnode_upper;
+	unsigned long	gpa_mask;
+	unsigned long	gnode_upper;
+	unsigned long	lowmem_remap_top;
+	unsigned long	lowmem_remap_base;
+	unsigned short	pnode;
+	unsigned short	pnode_mask;
 	unsigned short	coherency_domain_number;
 	unsigned short	numa_blade_id;
 	unsigned char	blade_processor_id;
@@ -112,83 +139,124 @@ DECLARE_PER_CPU(struct uv_hub_info_s, __
  * Local & Global MMR space macros.
  * 	Note: macros are intended to be used ONLY by inline functions
  * 	in this file - not by other kernel code.
+ * 		n -  NASID (full 15-bit global nasid)
+ * 		g -  GNODE (full 15-bit global nasid, right shifted 1)
+ * 		p -  PNODE (local part of nsids, right shifted 1)
  */
-#define UV_SNASID(n)			((n) >> 1)
-#define UV_NASID(n)			((n) << 1)
+#define UV_NASID_TO_PNODE(n)		(((n) >> 1) & uv_hub_info->pnode_mask)
+#define UV_PNODE_TO_NASID(p)		(((p) << 1) | uv_hub_info->gnode_upper)
 
 #define UV_LOCAL_MMR_BASE		0xf4000000UL
 #define UV_GLOBAL_MMR32_BASE		0xf8000000UL
 #define UV_GLOBAL_MMR64_BASE		(uv_hub_info->global_mmr_base)
 
-#define UV_GLOBAL_MMR32_SNASID_MASK	0x3ff
-#define UV_GLOBAL_MMR32_SNASID_SHIFT	15
-#define UV_GLOBAL_MMR64_SNASID_SHIFT	26
+#define UV_GLOBAL_MMR32_PNODE_SHIFT	15
+#define UV_GLOBAL_MMR64_PNODE_SHIFT	26
+
+#define UV_GLOBAL_MMR32_PNODE_BITS(p)	((p) << (UV_GLOBAL_MMR32_PNODE_SHIFT))
+
+#define UV_GLOBAL_MMR64_PNODE_BITS(p)					\
+	((unsigned long)(p) << UV_GLOBAL_MMR64_PNODE_SHIFT)
 
-#define UV_GLOBAL_MMR32_NASID_BITS(n)					\
-		(((UV_SNASID(n) & UV_GLOBAL_MMR32_SNASID_MASK)) <<	\
-		(UV_GLOBAL_MMR32_SNASID_SHIFT))
+#define UV_APIC_PNODE_SHIFT	6
+
+/*
+ * Macros for converting between kernel virtual addresses, socket local physical
+ * addresses, and UV global physical addresses.
+ * 	Note: use the standard __pa() & __va() macros for converting
+ * 	      between socket virtual and socket physical addresses.
+ */
 
-#define UV_GLOBAL_MMR64_NASID_BITS(n)					\
-	((unsigned long)UV_SNASID(n) << UV_GLOBAL_MMR64_SNASID_SHIFT)
+/* socket phys RAM --> UV global physical address */
+static inline unsigned long uv_soc_phys_ram_to_gpa(unsigned long paddr)
+{
+	if (paddr < uv_hub_info->lowmem_remap_top)
+		paddr += uv_hub_info->lowmem_remap_base;
+	return paddr | uv_hub_info->gnode_upper;
+}
+
+
+/* socket virtual --> UV global physical address */
+static inline unsigned long uv_gpa(void *v)
+{
+	return __pa(v) | uv_hub_info->gnode_upper;
+}
+
+/* socket virtual --> UV global physical address */
+static inline void *uv_vgpa(void *v)
+{
+	return (void *)uv_gpa(v);
+}
+
+/* UV global physical address --> socket virtual */
+static inline void *uv_va(unsigned long gpa)
+{
+	return __va(gpa & uv_hub_info->gpa_mask);
+}
+
+/* pnode, offset --> socket virtual */
+static inline void *uv_pnode_offset_to_vaddr(int pnode, unsigned long offset)
+{
+	return __va(((unsigned long)pnode << uv_hub_info->m_val) | offset);
+}
 
-#define UV_APIC_NASID_SHIFT	6
 
 /*
- * Extract a NASID from an APICID (full apicid, not processor subset)
+ * Extract a PNODE from an APICID (full apicid, not processor subset)
  */
-static inline int uv_apicid_to_nasid(int apicid)
+static inline int uv_apicid_to_pnode(int apicid)
 {
-	return (UV_NASID(apicid >> UV_APIC_NASID_SHIFT));
+	return (apicid >> UV_APIC_PNODE_SHIFT);
 }
 
 /*
  * Access global MMRs using the low memory MMR32 space. This region supports
  * faster MMR access but not all MMRs are accessible in this space.
  */
-static inline unsigned long *uv_global_mmr32_address(int nasid,
+static inline unsigned long *uv_global_mmr32_address(int pnode,
 				unsigned long offset)
 {
 	return __va(UV_GLOBAL_MMR32_BASE |
-		       UV_GLOBAL_MMR32_NASID_BITS(nasid) | offset);
+		       UV_GLOBAL_MMR32_PNODE_BITS(pnode) | offset);
 }
 
-static inline void uv_write_global_mmr32(int nasid, unsigned long offset,
+static inline void uv_write_global_mmr32(int pnode, unsigned long offset,
 				 unsigned long val)
 {
-	*uv_global_mmr32_address(nasid, offset) = val;
+	*uv_global_mmr32_address(pnode, offset) = val;
 }
 
-static inline unsigned long uv_read_global_mmr32(int nasid,
+static inline unsigned long uv_read_global_mmr32(int pnode,
 						 unsigned long offset)
 {
-	return *uv_global_mmr32_address(nasid, offset);
+	return *uv_global_mmr32_address(pnode, offset);
 }
 
 /*
  * Access Global MMR space using the MMR space located at the top of physical
  * memory.
  */
-static inline unsigned long *uv_global_mmr64_address(int nasid,
+static inline unsigned long *uv_global_mmr64_address(int pnode,
 				unsigned long offset)
 {
 	return __va(UV_GLOBAL_MMR64_BASE |
-		       UV_GLOBAL_MMR64_NASID_BITS(nasid) | offset);
+		    UV_GLOBAL_MMR64_PNODE_BITS(pnode) | offset);
 }
 
-static inline void uv_write_global_mmr64(int nasid, unsigned long offset,
+static inline void uv_write_global_mmr64(int pnode, unsigned long offset,
 				unsigned long val)
 {
-	*uv_global_mmr64_address(nasid, offset) = val;
+	*uv_global_mmr64_address(pnode, offset) = val;
 }
 
-static inline unsigned long uv_read_global_mmr64(int nasid,
+static inline unsigned long uv_read_global_mmr64(int pnode,
 						 unsigned long offset)
 {
-	return *uv_global_mmr64_address(nasid, offset);
+	return *uv_global_mmr64_address(pnode, offset);
 }
 
 /*
- * Access node local MMRs. Faster than using global space but only local MMRs
+ * Access hub local MMRs. Faster than using global space but only local MMRs
  * are accessible.
  */
 static inline unsigned long *uv_local_mmr_address(unsigned long offset)
@@ -207,15 +275,15 @@ static inline void uv_write_local_mmr(un
 }
 
 /*
- * Structures and definitions for converting between cpu, node, and blade
+ * Structures and definitions for converting between cpu, node, pnode, and blade
  * numbers.
  */
 struct uv_blade_info {
-	unsigned short	nr_posible_cpus;
+	unsigned short	nr_possible_cpus;
 	unsigned short	nr_online_cpus;
-	unsigned short	nasid;
+	unsigned short	pnode;
 };
-struct uv_blade_info *uv_blade_info;
+extern struct uv_blade_info *uv_blade_info;
 extern short *uv_node_to_blade;
 extern short *uv_cpu_to_blade;
 extern short uv_possible_blades;
@@ -244,16 +312,16 @@ static inline int uv_node_to_blade_id(in
 	return uv_node_to_blade[nid];
 }
 
-/* Convert a blade id to the NASID of the blade */
-static inline int uv_blade_to_nasid(int bid)
+/* Convert a blade id to the PNODE of the blade */
+static inline int uv_blade_to_pnode(int bid)
 {
-	return uv_blade_info[bid].nasid;
+	return uv_blade_info[bid].pnode;
 }
 
 /* Determine the number of possible cpus on a blade */
 static inline int uv_blade_nr_possible_cpus(int bid)
 {
-	return uv_blade_info[bid].nr_posible_cpus;
+	return uv_blade_info[bid].nr_possible_cpus;
 }
 
 /* Determine the number of online cpus on a blade */
@@ -262,16 +330,16 @@ static inline int uv_blade_nr_online_cpu
 	return uv_blade_info[bid].nr_online_cpus;
 }
 
-/* Convert a cpu id to the NASID of the blade containing the cpu */
-static inline int uv_cpu_to_nasid(int cpu)
+/* Convert a cpu id to the PNODE of the blade containing the cpu */
+static inline int uv_cpu_to_pnode(int cpu)
 {
-	return uv_blade_info[uv_cpu_to_blade_id(cpu)].nasid;
+	return uv_blade_info[uv_cpu_to_blade_id(cpu)].pnode;
 }
 
-/* Convert a node number to the NASID of the blade */
-static inline int uv_node_to_nasid(int nid)
+/* Convert a linux node number to the PNODE of the blade */
+static inline int uv_node_to_pnode(int nid)
 {
-	return uv_blade_info[uv_node_to_blade_id(nid)].nasid;
+	return uv_blade_info[uv_node_to_blade_id(nid)].pnode;
 }
 
 /* Maximum possible number of blades */
diff -puN include/asm-x86/uv/uv_mmrs.h~x86-update-macros-used-by-uv-platform include/asm-x86/uv/uv_mmrs.h
--- a/include/asm-x86/uv/uv_mmrs.h~x86-update-macros-used-by-uv-platform
+++ a/include/asm-x86/uv/uv_mmrs.h
@@ -11,11 +11,46 @@
 #ifndef __ASM_X86_UV_MMRS__
 #define __ASM_X86_UV_MMRS__
 
-/*
- *       AUTO GENERATED - Do not edit
- */
+#define UV_MMR_ENABLE		(1UL << 63)
 
- #define UV_MMR_ENABLE		(1UL << 63)
+/* ========================================================================= */
+/*                           UVH_BAU_DATA_CONFIG                             */
+/* ========================================================================= */
+#define UVH_BAU_DATA_CONFIG 0x61680UL
+#define UVH_BAU_DATA_CONFIG_32 0x0450
+
+#define UVH_BAU_DATA_CONFIG_VECTOR_SHFT 0
+#define UVH_BAU_DATA_CONFIG_VECTOR_MASK 0x00000000000000ffUL
+#define UVH_BAU_DATA_CONFIG_DM_SHFT 8
+#define UVH_BAU_DATA_CONFIG_DM_MASK 0x0000000000000700UL
+#define UVH_BAU_DATA_CONFIG_DESTMODE_SHFT 11
+#define UVH_BAU_DATA_CONFIG_DESTMODE_MASK 0x0000000000000800UL
+#define UVH_BAU_DATA_CONFIG_STATUS_SHFT 12
+#define UVH_BAU_DATA_CONFIG_STATUS_MASK 0x0000000000001000UL
+#define UVH_BAU_DATA_CONFIG_P_SHFT 13
+#define UVH_BAU_DATA_CONFIG_P_MASK 0x0000000000002000UL
+#define UVH_BAU_DATA_CONFIG_T_SHFT 15
+#define UVH_BAU_DATA_CONFIG_T_MASK 0x0000000000008000UL
+#define UVH_BAU_DATA_CONFIG_M_SHFT 16
+#define UVH_BAU_DATA_CONFIG_M_MASK 0x0000000000010000UL
+#define UVH_BAU_DATA_CONFIG_APIC_ID_SHFT 32
+#define UVH_BAU_DATA_CONFIG_APIC_ID_MASK 0xffffffff00000000UL
+
+union uvh_bau_data_config_u {
+    unsigned long	v;
+    struct uvh_bau_data_config_s {
+	unsigned long	vector_  :  8;  /* RW */
+	unsigned long	dm       :  3;  /* RW */
+	unsigned long	destmode :  1;  /* RW */
+	unsigned long	status   :  1;  /* RO */
+	unsigned long	p        :  1;  /* RO */
+	unsigned long	rsvd_14  :  1;  /*    */
+	unsigned long	t        :  1;  /* RO */
+	unsigned long	m        :  1;  /* RW */
+	unsigned long	rsvd_17_31: 15;  /*    */
+	unsigned long	apic_id  : 32;  /* RW */
+    } s;
+};
 
 /* ========================================================================= */
 /*                               UVH_IPI_INT                                 */
@@ -109,6 +144,7 @@ union uvh_lb_bau_intd_payload_queue_tail
 /*                   UVH_LB_BAU_INTD_SOFTWARE_ACKNOWLEDGE                    */
 /* ========================================================================= */
 #define UVH_LB_BAU_INTD_SOFTWARE_ACKNOWLEDGE 0x320080UL
+#define UVH_LB_BAU_INTD_SOFTWARE_ACKNOWLEDGE_32 0x0aa0
 
 #define UVH_LB_BAU_INTD_SOFTWARE_ACKNOWLEDGE_PENDING_0_SHFT 0
 #define UVH_LB_BAU_INTD_SOFTWARE_ACKNOWLEDGE_PENDING_0_MASK 0x0000000000000001UL
@@ -169,6 +205,7 @@ union uvh_lb_bau_intd_software_acknowled
 /*                UVH_LB_BAU_INTD_SOFTWARE_ACKNOWLEDGE_ALIAS                 */
 /* ========================================================================= */
 #define UVH_LB_BAU_INTD_SOFTWARE_ACKNOWLEDGE_ALIAS 0x0000000000320088UL
+#define UVH_LB_BAU_INTD_SOFTWARE_ACKNOWLEDGE_ALIAS_32 0x0aa8
 
 /* ========================================================================= */
 /*                     UVH_LB_BAU_SB_ACTIVATION_CONTROL                      */
@@ -248,6 +285,331 @@ union uvh_lb_bau_sb_descriptor_base_u {
 };
 
 /* ========================================================================= */
+/*                      UVH_LB_MCAST_AOERR0_RPT_ENABLE                       */
+/* ========================================================================= */
+#define UVH_LB_MCAST_AOERR0_RPT_ENABLE 0x50b20UL
+
+#define UVH_LB_MCAST_AOERR0_RPT_ENABLE_MCAST_OBESE_MSG_SHFT 0
+#define UVH_LB_MCAST_AOERR0_RPT_ENABLE_MCAST_OBESE_MSG_MASK 0x0000000000000001UL
+#define UVH_LB_MCAST_AOERR0_RPT_ENABLE_MCAST_DATA_SB_ERR_SHFT 1
+#define UVH_LB_MCAST_AOERR0_RPT_ENABLE_MCAST_DATA_SB_ERR_MASK 0x0000000000000002UL
+#define UVH_LB_MCAST_AOERR0_RPT_ENABLE_MCAST_NACK_BUFF_PARITY_SHFT 2
+#define UVH_LB_MCAST_AOERR0_RPT_ENABLE_MCAST_NACK_BUFF_PARITY_MASK 0x0000000000000004UL
+#define UVH_LB_MCAST_AOERR0_RPT_ENABLE_MCAST_TIMEOUT_SHFT 3
+#define UVH_LB_MCAST_AOERR0_RPT_ENABLE_MCAST_TIMEOUT_MASK 0x0000000000000008UL
+#define UVH_LB_MCAST_AOERR0_RPT_ENABLE_MCAST_INACTIVE_REPLY_SHFT 4
+#define UVH_LB_MCAST_AOERR0_RPT_ENABLE_MCAST_INACTIVE_REPLY_MASK 0x0000000000000010UL
+#define UVH_LB_MCAST_AOERR0_RPT_ENABLE_MCAST_UPGRADE_ERROR_SHFT 5
+#define UVH_LB_MCAST_AOERR0_RPT_ENABLE_MCAST_UPGRADE_ERROR_MASK 0x0000000000000020UL
+#define UVH_LB_MCAST_AOERR0_RPT_ENABLE_MCAST_REG_COUNT_UNDERFLOW_SHFT 6
+#define UVH_LB_MCAST_AOERR0_RPT_ENABLE_MCAST_REG_COUNT_UNDERFLOW_MASK 0x0000000000000040UL
+#define UVH_LB_MCAST_AOERR0_RPT_ENABLE_MCAST_REP_OBESE_MSG_SHFT 7
+#define UVH_LB_MCAST_AOERR0_RPT_ENABLE_MCAST_REP_OBESE_MSG_MASK 0x0000000000000080UL
+#define UVH_LB_MCAST_AOERR0_RPT_ENABLE_UCACHE_REQ_RUNT_MSG_SHFT 8
+#define UVH_LB_MCAST_AOERR0_RPT_ENABLE_UCACHE_REQ_RUNT_MSG_MASK 0x0000000000000100UL
+#define UVH_LB_MCAST_AOERR0_RPT_ENABLE_UCACHE_REQ_OBESE_MSG_SHFT 9
+#define UVH_LB_MCAST_AOERR0_RPT_ENABLE_UCACHE_REQ_OBESE_MSG_MASK 0x0000000000000200UL
+#define UVH_LB_MCAST_AOERR0_RPT_ENABLE_UCACHE_REQ_DATA_SB_ERR_SHFT 10
+#define UVH_LB_MCAST_AOERR0_RPT_ENABLE_UCACHE_REQ_DATA_SB_ERR_MASK 0x0000000000000400UL
+#define UVH_LB_MCAST_AOERR0_RPT_ENABLE_UCACHE_REP_RUNT_MSG_SHFT 11
+#define UVH_LB_MCAST_AOERR0_RPT_ENABLE_UCACHE_REP_RUNT_MSG_MASK 0x0000000000000800UL
+#define UVH_LB_MCAST_AOERR0_RPT_ENABLE_UCACHE_REP_OBESE_MSG_SHFT 12
+#define UVH_LB_MCAST_AOERR0_RPT_ENABLE_UCACHE_REP_OBESE_MSG_MASK 0x0000000000001000UL
+#define UVH_LB_MCAST_AOERR0_RPT_ENABLE_UCACHE_REP_DATA_SB_ERR_SHFT 13
+#define UVH_LB_MCAST_AOERR0_RPT_ENABLE_UCACHE_REP_DATA_SB_ERR_MASK 0x0000000000002000UL
+#define UVH_LB_MCAST_AOERR0_RPT_ENABLE_UCACHE_REP_COMMAND_ERR_SHFT 14
+#define UVH_LB_MCAST_AOERR0_RPT_ENABLE_UCACHE_REP_COMMAND_ERR_MASK 0x0000000000004000UL
+#define UVH_LB_MCAST_AOERR0_RPT_ENABLE_UCACHE_PEND_TIMEOUT_SHFT 15
+#define UVH_LB_MCAST_AOERR0_RPT_ENABLE_UCACHE_PEND_TIMEOUT_MASK 0x0000000000008000UL
+#define UVH_LB_MCAST_AOERR0_RPT_ENABLE_MACC_REQ_RUNT_MSG_SHFT 16
+#define UVH_LB_MCAST_AOERR0_RPT_ENABLE_MACC_REQ_RUNT_MSG_MASK 0x0000000000010000UL
+#define UVH_LB_MCAST_AOERR0_RPT_ENABLE_MACC_REQ_OBESE_MSG_SHFT 17
+#define UVH_LB_MCAST_AOERR0_RPT_ENABLE_MACC_REQ_OBESE_MSG_MASK 0x0000000000020000UL
+#define UVH_LB_MCAST_AOERR0_RPT_ENABLE_MACC_REQ_DATA_SB_ERR_SHFT 18
+#define UVH_LB_MCAST_AOERR0_RPT_ENABLE_MACC_REQ_DATA_SB_ERR_MASK 0x0000000000040000UL
+#define UVH_LB_MCAST_AOERR0_RPT_ENABLE_MACC_REP_RUNT_MSG_SHFT 19
+#define UVH_LB_MCAST_AOERR0_RPT_ENABLE_MACC_REP_RUNT_MSG_MASK 0x0000000000080000UL
+#define UVH_LB_MCAST_AOERR0_RPT_ENABLE_MACC_REP_OBESE_MSG_SHFT 20
+#define UVH_LB_MCAST_AOERR0_RPT_ENABLE_MACC_REP_OBESE_MSG_MASK 0x0000000000100000UL
+#define UVH_LB_MCAST_AOERR0_RPT_ENABLE_MACC_REP_DATA_SB_ERR_SHFT 21
+#define UVH_LB_MCAST_AOERR0_RPT_ENABLE_MACC_REP_DATA_SB_ERR_MASK 0x0000000000200000UL
+#define UVH_LB_MCAST_AOERR0_RPT_ENABLE_MACC_TIMEOUT_SHFT 22
+#define UVH_LB_MCAST_AOERR0_RPT_ENABLE_MACC_TIMEOUT_MASK 0x0000000000400000UL
+#define UVH_LB_MCAST_AOERR0_RPT_ENABLE_MACC_SPURIOUS_EVENT_SHFT 23
+#define UVH_LB_MCAST_AOERR0_RPT_ENABLE_MACC_SPURIOUS_EVENT_MASK 0x0000000000800000UL
+#define UVH_LB_MCAST_AOERR0_RPT_ENABLE_IOH_DESTINATION_TABLE_PARITY_SHFT 24
+#define UVH_LB_MCAST_AOERR0_RPT_ENABLE_IOH_DESTINATION_TABLE_PARITY_MASK 0x0000000001000000UL
+#define UVH_LB_MCAST_AOERR0_RPT_ENABLE_GET_HAD_ERROR_REPLY_SHFT 25
+#define UVH_LB_MCAST_AOERR0_RPT_ENABLE_GET_HAD_ERROR_REPLY_MASK 0x0000000002000000UL
+#define UVH_LB_MCAST_AOERR0_RPT_ENABLE_GET_TIMEOUT_SHFT 26
+#define UVH_LB_MCAST_AOERR0_RPT_ENABLE_GET_TIMEOUT_MASK 0x0000000004000000UL
+#define UVH_LB_MCAST_AOERR0_RPT_ENABLE_LOCK_MANAGER_HAD_ERROR_REPLY_SHFT 27
+#define UVH_LB_MCAST_AOERR0_RPT_ENABLE_LOCK_MANAGER_HAD_ERROR_REPLY_MASK 0x0000000008000000UL
+#define UVH_LB_MCAST_AOERR0_RPT_ENABLE_PUT_HAD_ERROR_REPLY_SHFT 28
+#define UVH_LB_MCAST_AOERR0_RPT_ENABLE_PUT_HAD_ERROR_REPLY_MASK 0x0000000010000000UL
+#define UVH_LB_MCAST_AOERR0_RPT_ENABLE_PUT_TIMEOUT_SHFT 29
+#define UVH_LB_MCAST_AOERR0_RPT_ENABLE_PUT_TIMEOUT_MASK 0x0000000020000000UL
+#define UVH_LB_MCAST_AOERR0_RPT_ENABLE_SB_ACTIVATION_OVERRUN_SHFT 30
+#define UVH_LB_MCAST_AOERR0_RPT_ENABLE_SB_ACTIVATION_OVERRUN_MASK 0x0000000040000000UL
+#define UVH_LB_MCAST_AOERR0_RPT_ENABLE_COMPLETED_GB_ACTIVATION_HAD_ERROR_REPLY_SHFT 31
+#define UVH_LB_MCAST_AOERR0_RPT_ENABLE_COMPLETED_GB_ACTIVATION_HAD_ERROR_REPLY_MASK 0x0000000080000000UL
+#define UVH_LB_MCAST_AOERR0_RPT_ENABLE_COMPLETED_GB_ACTIVATION_TIMEOUT_SHFT 32
+#define UVH_LB_MCAST_AOERR0_RPT_ENABLE_COMPLETED_GB_ACTIVATION_TIMEOUT_MASK 0x0000000100000000UL
+#define UVH_LB_MCAST_AOERR0_RPT_ENABLE_DESCRIPTOR_BUFFER_0_PARITY_SHFT 33
+#define UVH_LB_MCAST_AOERR0_RPT_ENABLE_DESCRIPTOR_BUFFER_0_PARITY_MASK 0x0000000200000000UL
+#define UVH_LB_MCAST_AOERR0_RPT_ENABLE_DESCRIPTOR_BUFFER_1_PARITY_SHFT 34
+#define UVH_LB_MCAST_AOERR0_RPT_ENABLE_DESCRIPTOR_BUFFER_1_PARITY_MASK 0x0000000400000000UL
+#define UVH_LB_MCAST_AOERR0_RPT_ENABLE_SOCKET_DESTINATION_TABLE_PARITY_SHFT 35
+#define UVH_LB_MCAST_AOERR0_RPT_ENABLE_SOCKET_DESTINATION_TABLE_PARITY_MASK 0x0000000800000000UL
+#define UVH_LB_MCAST_AOERR0_RPT_ENABLE_BAU_REPLY_PAYLOAD_CORRUPTION_SHFT 36
+#define UVH_LB_MCAST_AOERR0_RPT_ENABLE_BAU_REPLY_PAYLOAD_CORRUPTION_MASK 0x0000001000000000UL
+#define UVH_LB_MCAST_AOERR0_RPT_ENABLE_IO_PORT_DESTINATION_TABLE_PARITY_SHFT 37
+#define UVH_LB_MCAST_AOERR0_RPT_ENABLE_IO_PORT_DESTINATION_TABLE_PARITY_MASK 0x0000002000000000UL
+#define UVH_LB_MCAST_AOERR0_RPT_ENABLE_INTD_SOFT_ACK_TIMEOUT_SHFT 38
+#define UVH_LB_MCAST_AOERR0_RPT_ENABLE_INTD_SOFT_ACK_TIMEOUT_MASK 0x0000004000000000UL
+#define UVH_LB_MCAST_AOERR0_RPT_ENABLE_INT_REP_OBESE_MSG_SHFT 39
+#define UVH_LB_MCAST_AOERR0_RPT_ENABLE_INT_REP_OBESE_MSG_MASK 0x0000008000000000UL
+#define UVH_LB_MCAST_AOERR0_RPT_ENABLE_INT_REP_COMMAND_ERR_SHFT 40
+#define UVH_LB_MCAST_AOERR0_RPT_ENABLE_INT_REP_COMMAND_ERR_MASK 0x0000010000000000UL
+#define UVH_LB_MCAST_AOERR0_RPT_ENABLE_INT_TIMEOUT_SHFT 41
+#define UVH_LB_MCAST_AOERR0_RPT_ENABLE_INT_TIMEOUT_MASK 0x0000020000000000UL
+
+union uvh_lb_mcast_aoerr0_rpt_enable_u {
+    unsigned long	v;
+    struct uvh_lb_mcast_aoerr0_rpt_enable_s {
+	unsigned long	mcast_obese_msg                         :  1;  /* RW */
+	unsigned long	mcast_data_sb_err                       :  1;  /* RW */
+	unsigned long	mcast_nack_buff_parity                  :  1;  /* RW */
+	unsigned long	mcast_timeout                           :  1;  /* RW */
+	unsigned long	mcast_inactive_reply                    :  1;  /* RW */
+	unsigned long	mcast_upgrade_error                     :  1;  /* RW */
+	unsigned long	mcast_reg_count_underflow               :  1;  /* RW */
+	unsigned long	mcast_rep_obese_msg                     :  1;  /* RW */
+	unsigned long	ucache_req_runt_msg                     :  1;  /* RW */
+	unsigned long	ucache_req_obese_msg                    :  1;  /* RW */
+	unsigned long	ucache_req_data_sb_err                  :  1;  /* RW */
+	unsigned long	ucache_rep_runt_msg                     :  1;  /* RW */
+	unsigned long	ucache_rep_obese_msg                    :  1;  /* RW */
+	unsigned long	ucache_rep_data_sb_err                  :  1;  /* RW */
+	unsigned long	ucache_rep_command_err                  :  1;  /* RW */
+	unsigned long	ucache_pend_timeout                     :  1;  /* RW */
+	unsigned long	macc_req_runt_msg                       :  1;  /* RW */
+	unsigned long	macc_req_obese_msg                      :  1;  /* RW */
+	unsigned long	macc_req_data_sb_err                    :  1;  /* RW */
+	unsigned long	macc_rep_runt_msg                       :  1;  /* RW */
+	unsigned long	macc_rep_obese_msg                      :  1;  /* RW */
+	unsigned long	macc_rep_data_sb_err                    :  1;  /* RW */
+	unsigned long	macc_timeout                            :  1;  /* RW */
+	unsigned long	macc_spurious_event                     :  1;  /* RW */
+	unsigned long	ioh_destination_table_parity            :  1;  /* RW */
+	unsigned long	get_had_error_reply                     :  1;  /* RW */
+	unsigned long	get_timeout                             :  1;  /* RW */
+	unsigned long	lock_manager_had_error_reply            :  1;  /* RW */
+	unsigned long	put_had_error_reply                     :  1;  /* RW */
+	unsigned long	put_timeout                             :  1;  /* RW */
+	unsigned long	sb_activation_overrun                   :  1;  /* RW */
+	unsigned long	completed_gb_activation_had_error_reply :  1;  /* RW */
+	unsigned long	completed_gb_activation_timeout         :  1;  /* RW */
+	unsigned long	descriptor_buffer_0_parity              :  1;  /* RW */
+	unsigned long	descriptor_buffer_1_parity              :  1;  /* RW */
+	unsigned long	socket_destination_table_parity         :  1;  /* RW */
+	unsigned long	bau_reply_payload_corruption            :  1;  /* RW */
+	unsigned long	io_port_destination_table_parity        :  1;  /* RW */
+	unsigned long	intd_soft_ack_timeout                   :  1;  /* RW */
+	unsigned long	int_rep_obese_msg                       :  1;  /* RW */
+	unsigned long	int_rep_command_err                     :  1;  /* RW */
+	unsigned long	int_timeout                             :  1;  /* RW */
+	unsigned long	rsvd_42_63                              : 22;  /*    */
+    } s;
+};
+
+/* ========================================================================= */
+/*                          UVH_LOCAL_INT0_CONFIG                            */
+/* ========================================================================= */
+#define UVH_LOCAL_INT0_CONFIG 0x61000UL
+
+#define UVH_LOCAL_INT0_CONFIG_VECTOR_SHFT 0
+#define UVH_LOCAL_INT0_CONFIG_VECTOR_MASK 0x00000000000000ffUL
+#define UVH_LOCAL_INT0_CONFIG_DM_SHFT 8
+#define UVH_LOCAL_INT0_CONFIG_DM_MASK 0x0000000000000700UL
+#define UVH_LOCAL_INT0_CONFIG_DESTMODE_SHFT 11
+#define UVH_LOCAL_INT0_CONFIG_DESTMODE_MASK 0x0000000000000800UL
+#define UVH_LOCAL_INT0_CONFIG_STATUS_SHFT 12
+#define UVH_LOCAL_INT0_CONFIG_STATUS_MASK 0x0000000000001000UL
+#define UVH_LOCAL_INT0_CONFIG_P_SHFT 13
+#define UVH_LOCAL_INT0_CONFIG_P_MASK 0x0000000000002000UL
+#define UVH_LOCAL_INT0_CONFIG_T_SHFT 15
+#define UVH_LOCAL_INT0_CONFIG_T_MASK 0x0000000000008000UL
+#define UVH_LOCAL_INT0_CONFIG_M_SHFT 16
+#define UVH_LOCAL_INT0_CONFIG_M_MASK 0x0000000000010000UL
+#define UVH_LOCAL_INT0_CONFIG_APIC_ID_SHFT 32
+#define UVH_LOCAL_INT0_CONFIG_APIC_ID_MASK 0xffffffff00000000UL
+
+union uvh_local_int0_config_u {
+    unsigned long	v;
+    struct uvh_local_int0_config_s {
+	unsigned long	vector_  :  8;  /* RW */
+	unsigned long	dm       :  3;  /* RW */
+	unsigned long	destmode :  1;  /* RW */
+	unsigned long	status   :  1;  /* RO */
+	unsigned long	p        :  1;  /* RO */
+	unsigned long	rsvd_14  :  1;  /*    */
+	unsigned long	t        :  1;  /* RO */
+	unsigned long	m        :  1;  /* RW */
+	unsigned long	rsvd_17_31: 15;  /*    */
+	unsigned long	apic_id  : 32;  /* RW */
+    } s;
+};
+
+/* ========================================================================= */
+/*                          UVH_LOCAL_INT0_ENABLE                            */
+/* ========================================================================= */
+#define UVH_LOCAL_INT0_ENABLE 0x65000UL
+
+#define UVH_LOCAL_INT0_ENABLE_LB_HCERR_SHFT 0
+#define UVH_LOCAL_INT0_ENABLE_LB_HCERR_MASK 0x0000000000000001UL
+#define UVH_LOCAL_INT0_ENABLE_GR0_HCERR_SHFT 1
+#define UVH_LOCAL_INT0_ENABLE_GR0_HCERR_MASK 0x0000000000000002UL
+#define UVH_LOCAL_INT0_ENABLE_GR1_HCERR_SHFT 2
+#define UVH_LOCAL_INT0_ENABLE_GR1_HCERR_MASK 0x0000000000000004UL
+#define UVH_LOCAL_INT0_ENABLE_LH_HCERR_SHFT 3
+#define UVH_LOCAL_INT0_ENABLE_LH_HCERR_MASK 0x0000000000000008UL
+#define UVH_LOCAL_INT0_ENABLE_RH_HCERR_SHFT 4
+#define UVH_LOCAL_INT0_ENABLE_RH_HCERR_MASK 0x0000000000000010UL
+#define UVH_LOCAL_INT0_ENABLE_XN_HCERR_SHFT 5
+#define UVH_LOCAL_INT0_ENABLE_XN_HCERR_MASK 0x0000000000000020UL
+#define UVH_LOCAL_INT0_ENABLE_SI_HCERR_SHFT 6
+#define UVH_LOCAL_INT0_ENABLE_SI_HCERR_MASK 0x0000000000000040UL
+#define UVH_LOCAL_INT0_ENABLE_LB_AOERR0_SHFT 7
+#define UVH_LOCAL_INT0_ENABLE_LB_AOERR0_MASK 0x0000000000000080UL
+#define UVH_LOCAL_INT0_ENABLE_GR0_AOERR0_SHFT 8
+#define UVH_LOCAL_INT0_ENABLE_GR0_AOERR0_MASK 0x0000000000000100UL
+#define UVH_LOCAL_INT0_ENABLE_GR1_AOERR0_SHFT 9
+#define UVH_LOCAL_INT0_ENABLE_GR1_AOERR0_MASK 0x0000000000000200UL
+#define UVH_LOCAL_INT0_ENABLE_LH_AOERR0_SHFT 10
+#define UVH_LOCAL_INT0_ENABLE_LH_AOERR0_MASK 0x0000000000000400UL
+#define UVH_LOCAL_INT0_ENABLE_RH_AOERR0_SHFT 11
+#define UVH_LOCAL_INT0_ENABLE_RH_AOERR0_MASK 0x0000000000000800UL
+#define UVH_LOCAL_INT0_ENABLE_XN_AOERR0_SHFT 12
+#define UVH_LOCAL_INT0_ENABLE_XN_AOERR0_MASK 0x0000000000001000UL
+#define UVH_LOCAL_INT0_ENABLE_SI_AOERR0_SHFT 13
+#define UVH_LOCAL_INT0_ENABLE_SI_AOERR0_MASK 0x0000000000002000UL
+#define UVH_LOCAL_INT0_ENABLE_LB_AOERR1_SHFT 14
+#define UVH_LOCAL_INT0_ENABLE_LB_AOERR1_MASK 0x0000000000004000UL
+#define UVH_LOCAL_INT0_ENABLE_GR0_AOERR1_SHFT 15
+#define UVH_LOCAL_INT0_ENABLE_GR0_AOERR1_MASK 0x0000000000008000UL
+#define UVH_LOCAL_INT0_ENABLE_GR1_AOERR1_SHFT 16
+#define UVH_LOCAL_INT0_ENABLE_GR1_AOERR1_MASK 0x0000000000010000UL
+#define UVH_LOCAL_INT0_ENABLE_LH_AOERR1_SHFT 17
+#define UVH_LOCAL_INT0_ENABLE_LH_AOERR1_MASK 0x0000000000020000UL
+#define UVH_LOCAL_INT0_ENABLE_RH_AOERR1_SHFT 18
+#define UVH_LOCAL_INT0_ENABLE_RH_AOERR1_MASK 0x0000000000040000UL
+#define UVH_LOCAL_INT0_ENABLE_XN_AOERR1_SHFT 19
+#define UVH_LOCAL_INT0_ENABLE_XN_AOERR1_MASK 0x0000000000080000UL
+#define UVH_LOCAL_INT0_ENABLE_SI_AOERR1_SHFT 20
+#define UVH_LOCAL_INT0_ENABLE_SI_AOERR1_MASK 0x0000000000100000UL
+#define UVH_LOCAL_INT0_ENABLE_RH_VPI_INT_SHFT 21
+#define UVH_LOCAL_INT0_ENABLE_RH_VPI_INT_MASK 0x0000000000200000UL
+#define UVH_LOCAL_INT0_ENABLE_SYSTEM_SHUTDOWN_INT_SHFT 22
+#define UVH_LOCAL_INT0_ENABLE_SYSTEM_SHUTDOWN_INT_MASK 0x0000000000400000UL
+#define UVH_LOCAL_INT0_ENABLE_LB_IRQ_INT_0_SHFT 23
+#define UVH_LOCAL_INT0_ENABLE_LB_IRQ_INT_0_MASK 0x0000000000800000UL
+#define UVH_LOCAL_INT0_ENABLE_LB_IRQ_INT_1_SHFT 24
+#define UVH_LOCAL_INT0_ENABLE_LB_IRQ_INT_1_MASK 0x0000000001000000UL
+#define UVH_LOCAL_INT0_ENABLE_LB_IRQ_INT_2_SHFT 25
+#define UVH_LOCAL_INT0_ENABLE_LB_IRQ_INT_2_MASK 0x0000000002000000UL
+#define UVH_LOCAL_INT0_ENABLE_LB_IRQ_INT_3_SHFT 26
+#define UVH_LOCAL_INT0_ENABLE_LB_IRQ_INT_3_MASK 0x0000000004000000UL
+#define UVH_LOCAL_INT0_ENABLE_LB_IRQ_INT_4_SHFT 27
+#define UVH_LOCAL_INT0_ENABLE_LB_IRQ_INT_4_MASK 0x0000000008000000UL
+#define UVH_LOCAL_INT0_ENABLE_LB_IRQ_INT_5_SHFT 28
+#define UVH_LOCAL_INT0_ENABLE_LB_IRQ_INT_5_MASK 0x0000000010000000UL
+#define UVH_LOCAL_INT0_ENABLE_LB_IRQ_INT_6_SHFT 29
+#define UVH_LOCAL_INT0_ENABLE_LB_IRQ_INT_6_MASK 0x0000000020000000UL
+#define UVH_LOCAL_INT0_ENABLE_LB_IRQ_INT_7_SHFT 30
+#define UVH_LOCAL_INT0_ENABLE_LB_IRQ_INT_7_MASK 0x0000000040000000UL
+#define UVH_LOCAL_INT0_ENABLE_LB_IRQ_INT_8_SHFT 31
+#define UVH_LOCAL_INT0_ENABLE_LB_IRQ_INT_8_MASK 0x0000000080000000UL
+#define UVH_LOCAL_INT0_ENABLE_LB_IRQ_INT_9_SHFT 32
+#define UVH_LOCAL_INT0_ENABLE_LB_IRQ_INT_9_MASK 0x0000000100000000UL
+#define UVH_LOCAL_INT0_ENABLE_LB_IRQ_INT_10_SHFT 33
+#define UVH_LOCAL_INT0_ENABLE_LB_IRQ_INT_10_MASK 0x0000000200000000UL
+#define UVH_LOCAL_INT0_ENABLE_LB_IRQ_INT_11_SHFT 34
+#define UVH_LOCAL_INT0_ENABLE_LB_IRQ_INT_11_MASK 0x0000000400000000UL
+#define UVH_LOCAL_INT0_ENABLE_LB_IRQ_INT_12_SHFT 35
+#define UVH_LOCAL_INT0_ENABLE_LB_IRQ_INT_12_MASK 0x0000000800000000UL
+#define UVH_LOCAL_INT0_ENABLE_LB_IRQ_INT_13_SHFT 36
+#define UVH_LOCAL_INT0_ENABLE_LB_IRQ_INT_13_MASK 0x0000001000000000UL
+#define UVH_LOCAL_INT0_ENABLE_LB_IRQ_INT_14_SHFT 37
+#define UVH_LOCAL_INT0_ENABLE_LB_IRQ_INT_14_MASK 0x0000002000000000UL
+#define UVH_LOCAL_INT0_ENABLE_LB_IRQ_INT_15_SHFT 38
+#define UVH_LOCAL_INT0_ENABLE_LB_IRQ_INT_15_MASK 0x0000004000000000UL
+#define UVH_LOCAL_INT0_ENABLE_L1_NMI_INT_SHFT 39
+#define UVH_LOCAL_INT0_ENABLE_L1_NMI_INT_MASK 0x0000008000000000UL
+#define UVH_LOCAL_INT0_ENABLE_STOP_CLOCK_SHFT 40
+#define UVH_LOCAL_INT0_ENABLE_STOP_CLOCK_MASK 0x0000010000000000UL
+#define UVH_LOCAL_INT0_ENABLE_ASIC_TO_L1_SHFT 41
+#define UVH_LOCAL_INT0_ENABLE_ASIC_TO_L1_MASK 0x0000020000000000UL
+#define UVH_LOCAL_INT0_ENABLE_L1_TO_ASIC_SHFT 42
+#define UVH_LOCAL_INT0_ENABLE_L1_TO_ASIC_MASK 0x0000040000000000UL
+#define UVH_LOCAL_INT0_ENABLE_LTC_INT_SHFT 43
+#define UVH_LOCAL_INT0_ENABLE_LTC_INT_MASK 0x0000080000000000UL
+#define UVH_LOCAL_INT0_ENABLE_LA_SEQ_TRIGGER_SHFT 44
+#define UVH_LOCAL_INT0_ENABLE_LA_SEQ_TRIGGER_MASK 0x0000100000000000UL
+
+union uvh_local_int0_enable_u {
+    unsigned long	v;
+    struct uvh_local_int0_enable_s {
+	unsigned long	lb_hcerr            :  1;  /* RW */
+	unsigned long	gr0_hcerr           :  1;  /* RW */
+	unsigned long	gr1_hcerr           :  1;  /* RW */
+	unsigned long	lh_hcerr            :  1;  /* RW */
+	unsigned long	rh_hcerr            :  1;  /* RW */
+	unsigned long	xn_hcerr            :  1;  /* RW */
+	unsigned long	si_hcerr            :  1;  /* RW */
+	unsigned long	lb_aoerr0           :  1;  /* RW */
+	unsigned long	gr0_aoerr0          :  1;  /* RW */
+	unsigned long	gr1_aoerr0          :  1;  /* RW */
+	unsigned long	lh_aoerr0           :  1;  /* RW */
+	unsigned long	rh_aoerr0           :  1;  /* RW */
+	unsigned long	xn_aoerr0           :  1;  /* RW */
+	unsigned long	si_aoerr0           :  1;  /* RW */
+	unsigned long	lb_aoerr1           :  1;  /* RW */
+	unsigned long	gr0_aoerr1          :  1;  /* RW */
+	unsigned long	gr1_aoerr1          :  1;  /* RW */
+	unsigned long	lh_aoerr1           :  1;  /* RW */
+	unsigned long	rh_aoerr1           :  1;  /* RW */
+	unsigned long	xn_aoerr1           :  1;  /* RW */
+	unsigned long	si_aoerr1           :  1;  /* RW */
+	unsigned long	rh_vpi_int          :  1;  /* RW */
+	unsigned long	system_shutdown_int :  1;  /* RW */
+	unsigned long	lb_irq_int_0        :  1;  /* RW */
+	unsigned long	lb_irq_int_1        :  1;  /* RW */
+	unsigned long	lb_irq_int_2        :  1;  /* RW */
+	unsigned long	lb_irq_int_3        :  1;  /* RW */
+	unsigned long	lb_irq_int_4        :  1;  /* RW */
+	unsigned long	lb_irq_int_5        :  1;  /* RW */
+	unsigned long	lb_irq_int_6        :  1;  /* RW */
+	unsigned long	lb_irq_int_7        :  1;  /* RW */
+	unsigned long	lb_irq_int_8        :  1;  /* RW */
+	unsigned long	lb_irq_int_9        :  1;  /* RW */
+	unsigned long	lb_irq_int_10       :  1;  /* RW */
+	unsigned long	lb_irq_int_11       :  1;  /* RW */
+	unsigned long	lb_irq_int_12       :  1;  /* RW */
+	unsigned long	lb_irq_int_13       :  1;  /* RW */
+	unsigned long	lb_irq_int_14       :  1;  /* RW */
+	unsigned long	lb_irq_int_15       :  1;  /* RW */
+	unsigned long	l1_nmi_int          :  1;  /* RW */
+	unsigned long	stop_clock          :  1;  /* RW */
+	unsigned long	asic_to_l1          :  1;  /* RW */
+	unsigned long	l1_to_asic          :  1;  /* RW */
+	unsigned long	ltc_int             :  1;  /* RW */
+	unsigned long	la_seq_trigger      :  1;  /* RW */
+	unsigned long	rsvd_45_63          : 19;  /*    */
+    } s;
+};
+
+/* ========================================================================= */
 /*                               UVH_NODE_ID                                 */
 /* ========================================================================= */
 #define UVH_NODE_ID 0x0UL
@@ -284,6 +646,73 @@ union uvh_node_id_u {
 };
 
 /* ========================================================================= */
+/*                          UVH_NODE_PRESENT_TABLE                           */
+/* ========================================================================= */
+#define UVH_NODE_PRESENT_TABLE 0x1400UL
+#define UVH_NODE_PRESENT_TABLE_DEPTH 16
+
+#define UVH_NODE_PRESENT_TABLE_NODES_SHFT 0
+#define UVH_NODE_PRESENT_TABLE_NODES_MASK 0xffffffffffffffffUL
+
+union uvh_node_present_table_u {
+    unsigned long	v;
+    struct uvh_node_present_table_s {
+	unsigned long	nodes : 64;  /* RW */
+    } s;
+};
+
+/* ========================================================================= */
+/*                UVH_RH_GAM_ALIAS210_REDIRECT_CONFIG_0_MMR                  */
+/* ========================================================================= */
+#define UVH_RH_GAM_ALIAS210_REDIRECT_CONFIG_0_MMR 0x16000d0UL
+
+#define UVH_RH_GAM_ALIAS210_REDIRECT_CONFIG_0_MMR_DEST_BASE_SHFT 24
+#define UVH_RH_GAM_ALIAS210_REDIRECT_CONFIG_0_MMR_DEST_BASE_MASK 0x00003fffff000000UL
+
+union uvh_rh_gam_alias210_redirect_config_0_mmr_u {
+    unsigned long	v;
+    struct uvh_rh_gam_alias210_redirect_config_0_mmr_s {
+	unsigned long	rsvd_0_23 : 24;  /*    */
+	unsigned long	dest_base : 22;  /* RW */
+	unsigned long	rsvd_46_63: 18;  /*    */
+    } s;
+};
+
+/* ========================================================================= */
+/*                UVH_RH_GAM_ALIAS210_REDIRECT_CONFIG_1_MMR                  */
+/* ========================================================================= */
+#define UVH_RH_GAM_ALIAS210_REDIRECT_CONFIG_1_MMR 0x16000e0UL
+
+#define UVH_RH_GAM_ALIAS210_REDIRECT_CONFIG_1_MMR_DEST_BASE_SHFT 24
+#define UVH_RH_GAM_ALIAS210_REDIRECT_CONFIG_1_MMR_DEST_BASE_MASK 0x00003fffff000000UL
+
+union uvh_rh_gam_alias210_redirect_config_1_mmr_u {
+    unsigned long	v;
+    struct uvh_rh_gam_alias210_redirect_config_1_mmr_s {
+	unsigned long	rsvd_0_23 : 24;  /*    */
+	unsigned long	dest_base : 22;  /* RW */
+	unsigned long	rsvd_46_63: 18;  /*    */
+    } s;
+};
+
+/* ========================================================================= */
+/*                UVH_RH_GAM_ALIAS210_REDIRECT_CONFIG_2_MMR                  */
+/* ========================================================================= */
+#define UVH_RH_GAM_ALIAS210_REDIRECT_CONFIG_2_MMR 0x16000f0UL
+
+#define UVH_RH_GAM_ALIAS210_REDIRECT_CONFIG_2_MMR_DEST_BASE_SHFT 24
+#define UVH_RH_GAM_ALIAS210_REDIRECT_CONFIG_2_MMR_DEST_BASE_MASK 0x00003fffff000000UL
+
+union uvh_rh_gam_alias210_redirect_config_2_mmr_u {
+    unsigned long	v;
+    struct uvh_rh_gam_alias210_redirect_config_2_mmr_s {
+	unsigned long	rsvd_0_23 : 24;  /*    */
+	unsigned long	dest_base : 22;  /* RW */
+	unsigned long	rsvd_46_63: 18;  /*    */
+    } s;
+};
+
+/* ========================================================================= */
 /*                    UVH_RH_GAM_GRU_OVERLAY_CONFIG_MMR                      */
 /* ========================================================================= */
 #define UVH_RH_GAM_GRU_OVERLAY_CONFIG_MMR 0x1600010UL
@@ -369,5 +798,77 @@ union uvh_si_addr_map_config_u {
     } s;
 };
 
+/* ========================================================================= */
+/*                       UVH_SI_ALIAS0_OVERLAY_CONFIG                        */
+/* ========================================================================= */
+#define UVH_SI_ALIAS0_OVERLAY_CONFIG 0xc80008UL
+
+#define UVH_SI_ALIAS0_OVERLAY_CONFIG_BASE_SHFT 24
+#define UVH_SI_ALIAS0_OVERLAY_CONFIG_BASE_MASK 0x00000000ff000000UL
+#define UVH_SI_ALIAS0_OVERLAY_CONFIG_M_ALIAS_SHFT 48
+#define UVH_SI_ALIAS0_OVERLAY_CONFIG_M_ALIAS_MASK 0x001f000000000000UL
+#define UVH_SI_ALIAS0_OVERLAY_CONFIG_ENABLE_SHFT 63
+#define UVH_SI_ALIAS0_OVERLAY_CONFIG_ENABLE_MASK 0x8000000000000000UL
+
+union uvh_si_alias0_overlay_config_u {
+    unsigned long	v;
+    struct uvh_si_alias0_overlay_config_s {
+	unsigned long	rsvd_0_23: 24;  /*    */
+	unsigned long	base    :  8;  /* RW */
+	unsigned long	rsvd_32_47: 16;  /*    */
+	unsigned long	m_alias :  5;  /* RW */
+	unsigned long	rsvd_53_62: 10;  /*    */
+	unsigned long	enable  :  1;  /* RW */
+    } s;
+};
+
+/* ========================================================================= */
+/*                       UVH_SI_ALIAS1_OVERLAY_CONFIG                        */
+/* ========================================================================= */
+#define UVH_SI_ALIAS1_OVERLAY_CONFIG 0xc80010UL
+
+#define UVH_SI_ALIAS1_OVERLAY_CONFIG_BASE_SHFT 24
+#define UVH_SI_ALIAS1_OVERLAY_CONFIG_BASE_MASK 0x00000000ff000000UL
+#define UVH_SI_ALIAS1_OVERLAY_CONFIG_M_ALIAS_SHFT 48
+#define UVH_SI_ALIAS1_OVERLAY_CONFIG_M_ALIAS_MASK 0x001f000000000000UL
+#define UVH_SI_ALIAS1_OVERLAY_CONFIG_ENABLE_SHFT 63
+#define UVH_SI_ALIAS1_OVERLAY_CONFIG_ENABLE_MASK 0x8000000000000000UL
+
+union uvh_si_alias1_overlay_config_u {
+    unsigned long	v;
+    struct uvh_si_alias1_overlay_config_s {
+	unsigned long	rsvd_0_23: 24;  /*    */
+	unsigned long	base    :  8;  /* RW */
+	unsigned long	rsvd_32_47: 16;  /*    */
+	unsigned long	m_alias :  5;  /* RW */
+	unsigned long	rsvd_53_62: 10;  /*    */
+	unsigned long	enable  :  1;  /* RW */
+    } s;
+};
+
+/* ========================================================================= */
+/*                       UVH_SI_ALIAS2_OVERLAY_CONFIG                        */
+/* ========================================================================= */
+#define UVH_SI_ALIAS2_OVERLAY_CONFIG 0xc80018UL
+
+#define UVH_SI_ALIAS2_OVERLAY_CONFIG_BASE_SHFT 24
+#define UVH_SI_ALIAS2_OVERLAY_CONFIG_BASE_MASK 0x00000000ff000000UL
+#define UVH_SI_ALIAS2_OVERLAY_CONFIG_M_ALIAS_SHFT 48
+#define UVH_SI_ALIAS2_OVERLAY_CONFIG_M_ALIAS_MASK 0x001f000000000000UL
+#define UVH_SI_ALIAS2_OVERLAY_CONFIG_ENABLE_SHFT 63
+#define UVH_SI_ALIAS2_OVERLAY_CONFIG_ENABLE_MASK 0x8000000000000000UL
+
+union uvh_si_alias2_overlay_config_u {
+    unsigned long	v;
+    struct uvh_si_alias2_overlay_config_s {
+	unsigned long	rsvd_0_23: 24;  /*    */
+	unsigned long	base    :  8;  /* RW */
+	unsigned long	rsvd_32_47: 16;  /*    */
+	unsigned long	m_alias :  5;  /* RW */
+	unsigned long	rsvd_53_62: 10;  /*    */
+	unsigned long	enable  :  1;  /* RW */
+    } s;
+};
+
 
 #endif /* __ASM_X86_UV_MMRS__ */
_

Patches currently in -mm which might be from steiner@sgi.com are

linux-next.patch

