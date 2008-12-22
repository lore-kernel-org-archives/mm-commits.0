From: akpm@linux-foundation.org
Subject: + powerpc-change-u64-s64-to-a-long-long-integer-type.patch added to -mm tree
Date: Mon, 22 Dec 2008 14:43:39 -0800
Message-ID: <200812222243.mBMMhdwU028419@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57671 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755145AbYLVWoA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 22 Dec 2008 17:44:00 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mingo@elte.hu, benh@kernel.crashing.org, paulus@samba.org, sfr@canb.auug.org.au


The patch titled
     powerpc: change u64/s64 to a long long integer type
has been added to the -mm tree.  Its filename is
     powerpc-change-u64-s64-to-a-long-long-integer-type.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: powerpc: change u64/s64 to a long long integer type
From: Ingo Molnar <mingo@elte.hu>

Convert arch/powerpc/ over to long long based u64:

 -#ifdef __powerpc64__
 -# include <asm-generic/int-l64.h>
 -#else
 -# include <asm-generic/int-ll64.h>
 -#endif
 +#include <asm-generic/int-ll64.h>

This will avoid reoccuring spurious warnings in core kernel code that
comes when people test on their own hardware.  (i.e.  x86 in ~98% of the
cases) This is what x86 uses and it generally helps keep 64-bit code
32-bit clean too.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/include/asm/rtas.h               |    2 
 arch/powerpc/include/asm/types.h              |    6 --
 arch/powerpc/kernel/dma-iommu.c               |    4 -
 arch/powerpc/kernel/iommu.c                   |   12 ++---
 arch/powerpc/kernel/lparcfg.c                 |   10 ++--
 arch/powerpc/kernel/prom.c                    |    4 -
 arch/powerpc/kernel/prom_init.c               |    2 
 arch/powerpc/kernel/setup_64.c                |    6 +-
 arch/powerpc/mm/stab.c                        |    4 -
 arch/powerpc/oprofile/cell/vma_map.c          |    2 
 arch/powerpc/oprofile/op_model_pa6t.c         |    6 +-
 arch/powerpc/platforms/cell/beat_htab.c       |   21 +++++----
 arch/powerpc/platforms/cell/beat_interrupt.c  |    2 
 arch/powerpc/platforms/cell/beat_udbg.c       |    4 -
 arch/powerpc/platforms/cell/celleb_scc_epci.c |    4 -
 arch/powerpc/platforms/cell/interrupt.c       |    2 
 arch/powerpc/platforms/cell/io-workarounds.c  |    2 
 arch/powerpc/platforms/cell/iommu.c           |    6 +-
 arch/powerpc/platforms/cell/ras.c             |    8 +--
 arch/powerpc/platforms/cell/spu_base.c        |    8 +--
 arch/powerpc/platforms/cell/spu_callbacks.c   |    2 
 arch/powerpc/platforms/iseries/iommu.c        |    4 -
 arch/powerpc/platforms/pasemi/cpufreq.c       |    2 
 arch/powerpc/platforms/pseries/iommu.c        |   35 +++++++---------
 arch/powerpc/sysdev/mpic.c                    |    2 
 drivers/char/hvc_beat.c                       |    4 -
 drivers/net/pasemi_mac.c                      |    6 +-
 drivers/pcmcia/electra_cf.c                   |    2 
 drivers/scsi/ibmvscsi/ibmvscsi.c              |   12 ++---
 29 files changed, 90 insertions(+), 94 deletions(-)

diff -puN arch/powerpc/include/asm/rtas.h~powerpc-change-u64-s64-to-a-long-long-integer-type arch/powerpc/include/asm/rtas.h
--- a/arch/powerpc/include/asm/rtas.h~powerpc-change-u64-s64-to-a-long-long-integer-type
+++ a/arch/powerpc/include/asm/rtas.h
@@ -18,7 +18,7 @@
  */
 
 #define RTAS_UNKNOWN_SERVICE (-1)
-#define RTAS_INSTANTIATE_MAX (1UL<<30) /* Don't instantiate rtas at/above this value */
+#define RTAS_INSTANTIATE_MAX (1ULL<<30) /* Don't instantiate rtas at/above this value */
 
 /* Buffer size for ppc_rtas system call. */
 #define RTAS_RMOBUF_MAX (64 * 1024)
diff -puN arch/powerpc/include/asm/types.h~powerpc-change-u64-s64-to-a-long-long-integer-type arch/powerpc/include/asm/types.h
--- a/arch/powerpc/include/asm/types.h~powerpc-change-u64-s64-to-a-long-long-integer-type
+++ a/arch/powerpc/include/asm/types.h
@@ -1,11 +1,7 @@
 #ifndef _ASM_POWERPC_TYPES_H
 #define _ASM_POWERPC_TYPES_H
 
-#ifdef __powerpc64__
-# include <asm-generic/int-l64.h>
-#else
-# include <asm-generic/int-ll64.h>
-#endif
+#include <asm-generic/int-ll64.h>
 
 #ifndef __ASSEMBLY__
 
diff -puN arch/powerpc/kernel/dma-iommu.c~powerpc-change-u64-s64-to-a-long-long-integer-type arch/powerpc/kernel/dma-iommu.c
--- a/arch/powerpc/kernel/dma-iommu.c~powerpc-change-u64-s64-to-a-long-long-integer-type
+++ a/arch/powerpc/kernel/dma-iommu.c
@@ -79,10 +79,10 @@ static int dma_iommu_dma_supported(struc
 		       "Warning: IOMMU offset too big for device mask\n");
 		if (tbl)
 			printk(KERN_INFO
-			       "mask: 0x%08lx, table offset: 0x%08lx\n",
+			       "mask: 0x%08llx, table offset: 0x%08lx\n",
 				mask, tbl->it_offset);
 		else
-			printk(KERN_INFO "mask: 0x%08lx, table unavailable\n",
+			printk(KERN_INFO "mask: 0x%08llx, table unavailable\n",
 				mask);
 		return 0;
 	} else
diff -puN arch/powerpc/kernel/iommu.c~powerpc-change-u64-s64-to-a-long-long-integer-type arch/powerpc/kernel/iommu.c
--- a/arch/powerpc/kernel/iommu.c~powerpc-change-u64-s64-to-a-long-long-integer-type
+++ a/arch/powerpc/kernel/iommu.c
@@ -239,12 +239,12 @@ static void __iommu_free(struct iommu_ta
 		if (printk_ratelimit()) {
 			printk(KERN_INFO "iommu_free: invalid entry\n");
 			printk(KERN_INFO "\tentry     = 0x%lx\n", entry); 
-			printk(KERN_INFO "\tdma_addr  = 0x%lx\n", (u64)dma_addr);
-			printk(KERN_INFO "\tTable     = 0x%lx\n", (u64)tbl);
-			printk(KERN_INFO "\tbus#      = 0x%lx\n", (u64)tbl->it_busno);
-			printk(KERN_INFO "\tsize      = 0x%lx\n", (u64)tbl->it_size);
-			printk(KERN_INFO "\tstartOff  = 0x%lx\n", (u64)tbl->it_offset);
-			printk(KERN_INFO "\tindex     = 0x%lx\n", (u64)tbl->it_index);
+			printk(KERN_INFO "\tdma_addr  = 0x%llx\n", (u64)dma_addr);
+			printk(KERN_INFO "\tTable     = 0x%llx\n", (u64)tbl);
+			printk(KERN_INFO "\tbus#      = 0x%llx\n", (u64)tbl->it_busno);
+			printk(KERN_INFO "\tsize      = 0x%llx\n", (u64)tbl->it_size);
+			printk(KERN_INFO "\tstartOff  = 0x%llx\n", (u64)tbl->it_offset);
+			printk(KERN_INFO "\tindex     = 0x%llx\n", (u64)tbl->it_index);
 			WARN_ON(1);
 		}
 		return;
diff -puN arch/powerpc/kernel/lparcfg.c~powerpc-change-u64-s64-to-a-long-long-integer-type arch/powerpc/kernel/lparcfg.c
--- a/arch/powerpc/kernel/lparcfg.c~powerpc-change-u64-s64-to-a-long-long-integer-type
+++ a/arch/powerpc/kernel/lparcfg.c
@@ -240,7 +240,7 @@ static void parse_ppp_data(struct seq_fi
 	if (rc)
 		return;
 
-	seq_printf(m, "partition_entitled_capacity=%ld\n",
+	seq_printf(m, "partition_entitled_capacity=%lld\n",
 	           ppp_data.entitlement);
 	seq_printf(m, "group=%d\n", ppp_data.group_num);
 	seq_printf(m, "system_active_processors=%d\n",
@@ -265,7 +265,7 @@ static void parse_ppp_data(struct seq_fi
 		   ppp_data.unallocated_weight);
 	seq_printf(m, "capacity_weight=%d\n", ppp_data.weight);
 	seq_printf(m, "capped=%d\n", ppp_data.capped);
-	seq_printf(m, "unallocated_capacity=%ld\n",
+	seq_printf(m, "unallocated_capacity=%lld\n",
 		   ppp_data.unallocated_entitlement);
 }
 
@@ -509,10 +509,10 @@ static ssize_t update_ppp(u64 *entitleme
 	} else
 		return -EINVAL;
 
-	pr_debug("%s: current_entitled = %lu, current_weight = %u\n",
+	pr_debug("%s: current_entitled = %llu, current_weight = %u\n",
 		 __func__, ppp_data.entitlement, ppp_data.weight);
 
-	pr_debug("%s: new_entitled = %lu, new_weight = %u\n",
+	pr_debug("%s: new_entitled = %llu, new_weight = %u\n",
 		 __func__, new_entitled, new_weight);
 
 	retval = plpar_hcall_norets(H_SET_PPP, new_entitled, new_weight);
@@ -558,7 +558,7 @@ static ssize_t update_mpp(u64 *entitleme
 	pr_debug("%s: current_entitled = %lu, current_weight = %u\n",
 	         __func__, mpp_data.entitled_mem, mpp_data.mem_weight);
 
-	pr_debug("%s: new_entitled = %lu, new_weight = %u\n",
+	pr_debug("%s: new_entitled = %llu, new_weight = %u\n",
 		 __func__, new_entitled, new_weight);
 
 	rc = plpar_hcall_norets(H_SET_MPP, new_entitled, new_weight);
diff -puN arch/powerpc/kernel/prom.c~powerpc-change-u64-s64-to-a-long-long-integer-type arch/powerpc/kernel/prom.c
--- a/arch/powerpc/kernel/prom.c~powerpc-change-u64-s64-to-a-long-long-integer-type
+++ a/arch/powerpc/kernel/prom.c
@@ -824,11 +824,11 @@ static int __init early_init_dt_scan_cho
 #endif
 
 #ifdef CONFIG_KEXEC
-	lprop = (u64*)of_get_flat_dt_prop(node, "linux,crashkernel-base", NULL);
+	lprop = (unsigned long *)of_get_flat_dt_prop(node, "linux,crashkernel-base", NULL);
 	if (lprop)
 		crashk_res.start = *lprop;
 
-	lprop = (u64*)of_get_flat_dt_prop(node, "linux,crashkernel-size", NULL);
+	lprop = (unsigned long *)of_get_flat_dt_prop(node, "linux,crashkernel-size", NULL);
 	if (lprop)
 		crashk_res.end = crashk_res.start + *lprop - 1;
 #endif
diff -puN arch/powerpc/kernel/prom_init.c~powerpc-change-u64-s64-to-a-long-long-integer-type arch/powerpc/kernel/prom_init.c
--- a/arch/powerpc/kernel/prom_init.c~powerpc-change-u64-s64-to-a-long-long-integer-type
+++ a/arch/powerpc/kernel/prom_init.c
@@ -1210,7 +1210,7 @@ static void __init prom_initialize_tce_t
 		/* Initialize the table to have a one-to-one mapping
 		 * over the allocated size.
 		 */
-		tce_entryp = (unsigned long *)base;
+		tce_entryp = (u64 *)base;
 		for (i = 0; i < (minsize >> 3) ;tce_entryp++, i++) {
 			tce_entry = (i << PAGE_SHIFT);
 			tce_entry |= 0x3;
diff -puN arch/powerpc/kernel/setup_64.c~powerpc-change-u64-s64-to-a-long-long-integer-type arch/powerpc/kernel/setup_64.c
--- a/arch/powerpc/kernel/setup_64.c~powerpc-change-u64-s64-to-a-long-long-integer-type
+++ a/arch/powerpc/kernel/setup_64.c
@@ -432,8 +432,8 @@ void __init setup_system(void)
 	printk("Starting Linux PPC64 %s\n", init_utsname()->version);
 
 	printk("-----------------------------------------------------\n");
-	printk("ppc64_pft_size                = 0x%lx\n", ppc64_pft_size);
-	printk("physicalMemorySize            = 0x%lx\n", lmb_phys_mem_size());
+	printk("ppc64_pft_size                = 0x%llx\n", ppc64_pft_size);
+	printk("physicalMemorySize            = 0x%llx\n", lmb_phys_mem_size());
 	if (ppc64_caches.dline_size != 0x80)
 		printk("ppc64_caches.dcache_line_size = 0x%x\n",
 		       ppc64_caches.dline_size);
@@ -491,7 +491,7 @@ static void __init emergency_stack_init(
 	 * bringup, we need to get at them in real mode. This means they
 	 * must also be within the RMO region.
 	 */
-	limit = min(0x10000000UL, lmb.rmo_size);
+	limit = min(0x10000000ULL, lmb.rmo_size);
 
 	for_each_possible_cpu(i) {
 		unsigned long sp;
diff -puN arch/powerpc/mm/stab.c~powerpc-change-u64-s64-to-a-long-long-integer-type arch/powerpc/mm/stab.c
--- a/arch/powerpc/mm/stab.c~powerpc-change-u64-s64-to-a-long-long-integer-type
+++ a/arch/powerpc/mm/stab.c
@@ -251,8 +251,8 @@ void __init stabs_alloc(void)
 
 		paca[cpu].stab_addr = newstab;
 		paca[cpu].stab_real = virt_to_abs(newstab);
-		printk(KERN_INFO "Segment table for CPU %d at 0x%lx "
-		       "virtual, 0x%lx absolute\n",
+		printk(KERN_INFO "Segment table for CPU %d at 0x%llx "
+		       "virtual, 0x%llx absolute\n",
 		       cpu, paca[cpu].stab_addr, paca[cpu].stab_real);
 	}
 }
diff -puN arch/powerpc/oprofile/cell/vma_map.c~powerpc-change-u64-s64-to-a-long-long-integer-type arch/powerpc/oprofile/cell/vma_map.c
--- a/arch/powerpc/oprofile/cell/vma_map.c~powerpc-change-u64-s64-to-a-long-long-integer-type
+++ a/arch/powerpc/oprofile/cell/vma_map.c
@@ -92,7 +92,7 @@ vma_map_add(struct vma_to_fileoffset_map
  * A pointer to the first vma_map in the generated list
  * of vma_maps is returned.  */
 struct vma_to_fileoffset_map *create_vma_map(const struct spu *aSpu,
-					     unsigned long __spu_elf_start)
+					     u64 __spu_elf_start)
 {
 	static const unsigned char expected[EI_PAD] = {
 		[EI_MAG0] = ELFMAG0,
diff -puN arch/powerpc/oprofile/op_model_pa6t.c~powerpc-change-u64-s64-to-a-long-long-integer-type arch/powerpc/oprofile/op_model_pa6t.c
--- a/arch/powerpc/oprofile/op_model_pa6t.c~powerpc-change-u64-s64-to-a-long-long-integer-type
+++ a/arch/powerpc/oprofile/op_model_pa6t.c
@@ -132,7 +132,7 @@ static int pa6t_reg_setup(struct op_coun
 	for (pmc = 0; pmc < cur_cpu_spec->num_pmcs; pmc++) {
 		/* counters are 40 bit. Move to cputable at some point? */
 		reset_value[pmc] = (0x1UL << 39) - ctr[pmc].count;
-		pr_debug("reset_value for pmc%u inited to 0x%lx\n",
+		pr_debug("reset_value for pmc%u inited to 0x%llx\n",
 				 pmc, reset_value[pmc]);
 	}
 
@@ -177,7 +177,7 @@ static int pa6t_start(struct op_counter_
 
 	oprofile_running = 1;
 
-	pr_debug("start on cpu %d, mmcr0 %lx\n", smp_processor_id(), mmcr0);
+	pr_debug("start on cpu %d, mmcr0 %llx\n", smp_processor_id(), mmcr0);
 
 	return 0;
 }
@@ -193,7 +193,7 @@ static void pa6t_stop(void)
 
 	oprofile_running = 0;
 
-	pr_debug("stop on cpu %d, mmcr0 %lx\n", smp_processor_id(), mmcr0);
+	pr_debug("stop on cpu %d, mmcr0 %llx\n", smp_processor_id(), mmcr0);
 }
 
 /* handle the perfmon overflow vector */
diff -puN arch/powerpc/platforms/cell/beat_htab.c~powerpc-change-u64-s64-to-a-long-long-integer-type arch/powerpc/platforms/cell/beat_htab.c
--- a/arch/powerpc/platforms/cell/beat_htab.c~powerpc-change-u64-s64-to-a-long-long-integer-type
+++ a/arch/powerpc/platforms/cell/beat_htab.c
@@ -44,8 +44,8 @@ static DEFINE_SPINLOCK(beat_htab_lock);
 
 static inline unsigned int beat_read_mask(unsigned hpte_group)
 {
-	unsigned long hpte_v[5];
 	unsigned long rmask = 0;
+	u64 hpte_v[5];
 
 	beat_read_htab_entries(0, hpte_group + 0, hpte_v);
 	if (!(hpte_v[0] & HPTE_V_BOLTED))
@@ -93,8 +93,7 @@ static long beat_lpar_hpte_insert(unsign
 				  int psize, int ssize)
 {
 	unsigned long lpar_rc;
-	unsigned long slot;
-	unsigned long hpte_v, hpte_r;
+	u64 hpte_v, hpte_r, slot;
 
 	/* same as iseries */
 	if (vflags & HPTE_V_SECONDARY)
@@ -153,8 +152,9 @@ static long beat_lpar_hpte_remove(unsign
 
 static unsigned long beat_lpar_hpte_getword0(unsigned long slot)
 {
-	unsigned long dword0, dword[5];
+	unsigned long dword0;
 	unsigned long lpar_rc;
+	u64 dword[5];
 
 	lpar_rc = beat_read_htab_entries(0, slot & ~3UL, dword);
 
@@ -170,7 +170,7 @@ static void beat_lpar_hptab_clear(void)
 	unsigned long size_bytes = 1UL << ppc64_pft_size;
 	unsigned long hpte_count = size_bytes >> 4;
 	int i;
-	unsigned long dummy0, dummy1;
+	u64 dummy0, dummy1;
 
 	/* TODO: Use bulk call */
 	for (i = 0; i < hpte_count; i++)
@@ -189,7 +189,8 @@ static long beat_lpar_hpte_updatepp(unsi
 				    int psize, int ssize, int local)
 {
 	unsigned long lpar_rc;
-	unsigned long dummy0, dummy1, want_v;
+	u64 dummy0, dummy1;
+	unsigned long want_v;
 
 	want_v = hpte_encode_v(va, psize, MMU_SEGSIZE_256M);
 
@@ -255,7 +256,8 @@ static void beat_lpar_hpte_updateboltedp
 					  unsigned long ea,
 					  int psize, int ssize)
 {
-	unsigned long lpar_rc, slot, vsid, va, dummy0, dummy1;
+	unsigned long lpar_rc, slot, vsid, va;
+	u64 dummy0, dummy1;
 
 	vsid = get_kernel_vsid(ea, MMU_SEGSIZE_256M);
 	va = (vsid << 28) | (ea & 0x0fffffff);
@@ -276,7 +278,7 @@ static void beat_lpar_hpte_invalidate(un
 {
 	unsigned long want_v;
 	unsigned long lpar_rc;
-	unsigned long dummy1, dummy2;
+	u64 dummy1, dummy2;
 	unsigned long flags;
 
 	DBG_LOW("    inval : slot=%lx, va=%016lx, psize: %d, local: %d\n",
@@ -315,8 +317,7 @@ static long beat_lpar_hpte_insert_v3(uns
 				  int psize, int ssize)
 {
 	unsigned long lpar_rc;
-	unsigned long slot;
-	unsigned long hpte_v, hpte_r;
+	u64 hpte_v, hpte_r, slot;
 
 	/* same as iseries */
 	if (vflags & HPTE_V_SECONDARY)
diff -puN arch/powerpc/platforms/cell/beat_interrupt.c~powerpc-change-u64-s64-to-a-long-long-integer-type arch/powerpc/platforms/cell/beat_interrupt.c
--- a/arch/powerpc/platforms/cell/beat_interrupt.c~powerpc-change-u64-s64-to-a-long-long-integer-type
+++ a/arch/powerpc/platforms/cell/beat_interrupt.c
@@ -99,7 +99,7 @@ static void beatic_end_irq(unsigned int 
 	err = beat_downcount_of_interrupt(irq_plug);
 	if (err != 0) {
 		if ((err & 0xFFFFFFFF) != 0xFFFFFFF5) /* -11: wrong state */
-			panic("Failed to downcount IRQ! Error = %16lx", err);
+			panic("Failed to downcount IRQ! Error = %16llx", err);
 
 		printk(KERN_ERR "IRQ over-downcounted, plug %d\n", irq_plug);
 	}
diff -puN arch/powerpc/platforms/cell/beat_udbg.c~powerpc-change-u64-s64-to-a-long-long-integer-type arch/powerpc/platforms/cell/beat_udbg.c
--- a/arch/powerpc/platforms/cell/beat_udbg.c~powerpc-change-u64-s64-to-a-long-long-integer-type
+++ a/arch/powerpc/platforms/cell/beat_udbg.c
@@ -40,8 +40,8 @@ static void udbg_putc_beat(char c)
 }
 
 /* Buffered chars getc */
-static long inbuflen;
-static long inbuf[2];	/* must be 2 longs */
+static u64 inbuflen;
+static u64 inbuf[2];	/* must be 2 longs */
 
 static int udbg_getc_poll_beat(void)
 {
diff -puN arch/powerpc/platforms/cell/celleb_scc_epci.c~powerpc-change-u64-s64-to-a-long-long-integer-type arch/powerpc/platforms/cell/celleb_scc_epci.c
--- a/arch/powerpc/platforms/cell/celleb_scc_epci.c~powerpc-change-u64-s64-to-a-long-long-integer-type
+++ a/arch/powerpc/platforms/cell/celleb_scc_epci.c
@@ -405,7 +405,7 @@ static int __init celleb_setup_epci(stru
 	hose->cfg_addr = ioremap(r.start, (r.end - r.start + 1));
 	if (!hose->cfg_addr)
 		goto error;
-	pr_debug("EPCI: cfg_addr map 0x%016lx->0x%016lx + 0x%016lx\n",
+	pr_debug("EPCI: cfg_addr map 0x%016llx->0x%016lx + 0x%016llx\n",
 		 r.start, (unsigned long)hose->cfg_addr, (r.end - r.start + 1));
 
 	if (of_address_to_resource(node, 2, &r))
@@ -413,7 +413,7 @@ static int __init celleb_setup_epci(stru
 	hose->cfg_data = ioremap(r.start, (r.end - r.start + 1));
 	if (!hose->cfg_data)
 		goto error;
-	pr_debug("EPCI: cfg_data map 0x%016lx->0x%016lx + 0x%016lx\n",
+	pr_debug("EPCI: cfg_data map 0x%016llx->0x%016lx + 0x%016llx\n",
 		 r.start, (unsigned long)hose->cfg_data, (r.end - r.start + 1));
 
 	hose->ops = &celleb_epci_ops;
diff -puN arch/powerpc/platforms/cell/interrupt.c~powerpc-change-u64-s64-to-a-long-long-integer-type arch/powerpc/platforms/cell/interrupt.c
--- a/arch/powerpc/platforms/cell/interrupt.c~powerpc-change-u64-s64-to-a-long-long-integer-type
+++ a/arch/powerpc/platforms/cell/interrupt.c
@@ -148,7 +148,7 @@ static unsigned int iic_get_irq(void)
 
 	iic = &__get_cpu_var(iic);
 	*(unsigned long *) &pending =
-		in_be64((unsigned long __iomem *) &iic->regs->pending_destr);
+		in_be64((unsigned long long __iomem *) &iic->regs->pending_destr);
 	if (!(pending.flags & CBE_IIC_IRQ_VALID))
 		return NO_IRQ;
 	virq = irq_linear_revmap(iic_host, iic_pending_to_hwnum(pending));
diff -puN arch/powerpc/platforms/cell/io-workarounds.c~powerpc-change-u64-s64-to-a-long-long-integer-type arch/powerpc/platforms/cell/io-workarounds.c
--- a/arch/powerpc/platforms/cell/io-workarounds.c~powerpc-change-u64-s64-to-a-long-long-integer-type
+++ a/arch/powerpc/platforms/cell/io-workarounds.c
@@ -130,7 +130,7 @@ static const struct ppc_pci_io __devinit
 
 };
 
-static void __iomem *iowa_ioremap(unsigned long addr, unsigned long size,
+static void __iomem *iowa_ioremap(phys_addr_t addr, unsigned long size,
 						unsigned long flags)
 {
 	struct iowa_bus *bus;
diff -puN arch/powerpc/platforms/cell/iommu.c~powerpc-change-u64-s64-to-a-long-long-integer-type arch/powerpc/platforms/cell/iommu.c
--- a/arch/powerpc/platforms/cell/iommu.c~powerpc-change-u64-s64-to-a-long-long-integer-type
+++ a/arch/powerpc/platforms/cell/iommu.c
@@ -150,7 +150,7 @@ static int cbe_nr_iommus;
 static void invalidate_tce_cache(struct cbe_iommu *iommu, unsigned long *pte,
 		long n_ptes)
 {
-	unsigned long __iomem *reg;
+	u64 __iomem *reg;
 	unsigned long val;
 	long n;
 
@@ -855,7 +855,7 @@ static int __init cell_iommu_init_disabl
 	 */
 	if (np && size < lmb_end_of_DRAM()) {
 		printk(KERN_WARNING "iommu: force-enabled, dma window"
-		       " (%ldMB) smaller than total memory (%ldMB)\n",
+		       " (%ldMB) smaller than total memory (%lldMB)\n",
 		       size >> 20, lmb_end_of_DRAM() >> 20);
 		return -ENODEV;
 	}
@@ -985,7 +985,7 @@ static void cell_dma_dev_setup_fixed(str
 	addr = cell_iommu_get_fixed_address(dev) + dma_iommu_fixed_base;
 	archdata->dma_data = (void *)addr;
 
-	dev_dbg(dev, "iommu: fixed addr = %lx\n", addr);
+	dev_dbg(dev, "iommu: fixed addr = %llx\n", addr);
 }
 
 static void insert_16M_pte(unsigned long addr, unsigned long *ptab,
diff -puN arch/powerpc/platforms/cell/ras.c~powerpc-change-u64-s64-to-a-long-long-integer-type arch/powerpc/platforms/cell/ras.c
--- a/arch/powerpc/platforms/cell/ras.c~powerpc-change-u64-s64-to-a-long-long-integer-type
+++ a/arch/powerpc/platforms/cell/ras.c
@@ -38,16 +38,16 @@ static void dump_fir(int cpu)
 	/* Todo: do some nicer parsing of bits and based on them go down
 	 * to other sub-units FIRs and not only IIC
 	 */
-	printk(KERN_ERR "Global Checkstop FIR    : 0x%016lx\n",
+	printk(KERN_ERR "Global Checkstop FIR    : 0x%016llx\n",
 	       in_be64(&pregs->checkstop_fir));
-	printk(KERN_ERR "Global Recoverable FIR  : 0x%016lx\n",
+	printk(KERN_ERR "Global Recoverable FIR  : 0x%016llx\n",
 	       in_be64(&pregs->checkstop_fir));
-	printk(KERN_ERR "Global MachineCheck FIR : 0x%016lx\n",
+	printk(KERN_ERR "Global MachineCheck FIR : 0x%016llx\n",
 	       in_be64(&pregs->spec_att_mchk_fir));
 
 	if (iregs == NULL)
 		return;
-	printk(KERN_ERR "IOC FIR                 : 0x%016lx\n",
+	printk(KERN_ERR "IOC FIR                 : 0x%016llx\n",
 	       in_be64(&iregs->ioc_fir));
 
 }
diff -puN arch/powerpc/platforms/cell/spu_base.c~powerpc-change-u64-s64-to-a-long-long-integer-type arch/powerpc/platforms/cell/spu_base.c
--- a/arch/powerpc/platforms/cell/spu_base.c~powerpc-change-u64-s64-to-a-long-long-integer-type
+++ a/arch/powerpc/platforms/cell/spu_base.c
@@ -139,10 +139,10 @@ static void spu_restart_dma(struct spu *
 {
 	struct spu_priv2 __iomem *priv2 = spu->priv2;
 
-	if (!test_bit(SPU_CONTEXT_SWITCH_PENDING, &spu->flags))
+	if (!test_bit(SPU_CONTEXT_SWITCH_PENDING, (unsigned long *)&spu->flags))
 		out_be64(&priv2->mfc_control_RW, MFC_CNTL_RESTART_DMA_COMMAND);
 	else {
-		set_bit(SPU_CONTEXT_FAULT_PENDING, &spu->flags);
+		set_bit(SPU_CONTEXT_FAULT_PENDING, (unsigned long *)&spu->flags);
 		mb();
 	}
 }
@@ -151,7 +151,7 @@ static inline void spu_load_slb(struct s
 {
 	struct spu_priv2 __iomem *priv2 = spu->priv2;
 
-	pr_debug("%s: adding SLB[%d] 0x%016lx 0x%016lx\n",
+	pr_debug("%s: adding SLB[%d] 0x%016llx 0x%016llx\n",
 			__func__, slbe, slb->vsid, slb->esid);
 
 	out_be64(&priv2->slb_index_W, slbe);
@@ -221,7 +221,7 @@ static int __spu_trap_data_map(struct sp
 {
 	int ret;
 
-	pr_debug("%s, %lx, %lx\n", __func__, dsisr, ea);
+	pr_debug("%s, %llx, %lx\n", __func__, dsisr, ea);
 
 	/*
 	 * Handle kernel space hash faults immediately. User hash
diff -puN arch/powerpc/platforms/cell/spu_callbacks.c~powerpc-change-u64-s64-to-a-long-long-integer-type arch/powerpc/platforms/cell/spu_callbacks.c
--- a/arch/powerpc/platforms/cell/spu_callbacks.c~powerpc-change-u64-s64-to-a-long-long-integer-type
+++ a/arch/powerpc/platforms/cell/spu_callbacks.c
@@ -54,7 +54,7 @@ long spu_sys_callback(struct spu_syscall
 	long (*syscall)(u64 a1, u64 a2, u64 a3, u64 a4, u64 a5, u64 a6);
 
 	if (s->nr_ret >= ARRAY_SIZE(spu_syscall_table)) {
-		pr_debug("%s: invalid syscall #%ld", __func__, s->nr_ret);
+		pr_debug("%s: invalid syscall #%lld", __func__, s->nr_ret);
 		return -ENOSYS;
 	}
 
diff -puN arch/powerpc/platforms/iseries/iommu.c~powerpc-change-u64-s64-to-a-long-long-integer-type arch/powerpc/platforms/iseries/iommu.c
--- a/arch/powerpc/platforms/iseries/iommu.c~powerpc-change-u64-s64-to-a-long-long-integer-type
+++ a/arch/powerpc/platforms/iseries/iommu.c
@@ -66,7 +66,7 @@ static int tce_build_iSeries(struct iomm
 
 		rc = HvCallXm_setTce((u64)tbl->it_index, (u64)index, tce);
 		if (rc)
-			panic("PCI_DMA: HvCallXm_setTce failed, Rc: 0x%lx\n",
+			panic("PCI_DMA: HvCallXm_setTce failed, Rc: 0x%llx\n",
 					rc);
 		index++;
 		uaddr += TCE_PAGE_SIZE;
@@ -81,7 +81,7 @@ static void tce_free_iSeries(struct iomm
 	while (npages--) {
 		rc = HvCallXm_setTce((u64)tbl->it_index, (u64)index, 0);
 		if (rc)
-			panic("PCI_DMA: HvCallXm_setTce failed, Rc: 0x%lx\n",
+			panic("PCI_DMA: HvCallXm_setTce failed, Rc: 0x%llx\n",
 					rc);
 		index++;
 	}
diff -puN arch/powerpc/platforms/pasemi/cpufreq.c~powerpc-change-u64-s64-to-a-long-long-integer-type arch/powerpc/platforms/pasemi/cpufreq.c
--- a/arch/powerpc/platforms/pasemi/cpufreq.c~powerpc-change-u64-s64-to-a-long-long-integer-type
+++ a/arch/powerpc/platforms/pasemi/cpufreq.c
@@ -112,7 +112,7 @@ static int get_gizmo_latency(void)
 
 static void set_astate(int cpu, unsigned int astate)
 {
-	u64 flags;
+	unsigned long flags;
 
 	/* Return if called before init has run */
 	if (unlikely(!sdcasr_mapbase))
diff -puN arch/powerpc/platforms/pseries/iommu.c~powerpc-change-u64-s64-to-a-long-long-integer-type arch/powerpc/platforms/pseries/iommu.c
--- a/arch/powerpc/platforms/pseries/iommu.c~powerpc-change-u64-s64-to-a-long-long-integer-type
+++ a/arch/powerpc/platforms/pseries/iommu.c
@@ -127,10 +127,10 @@ static int tce_build_pSeriesLP(struct io
 		}
 
 		if (rc && printk_ratelimit()) {
-			printk("tce_build_pSeriesLP: plpar_tce_put failed. rc=%ld\n", rc);
-			printk("\tindex   = 0x%lx\n", (u64)tbl->it_index);
-			printk("\ttcenum  = 0x%lx\n", (u64)tcenum);
-			printk("\ttce val = 0x%lx\n", tce );
+			printk("tce_build_pSeriesLP: plpar_tce_put failed. rc=%lld\n", rc);
+			printk("\tindex   = 0x%llx\n", (u64)tbl->it_index);
+			printk("\ttcenum  = 0x%llx\n", (u64)tcenum);
+			printk("\ttce val = 0x%llx\n", tce );
 			show_stack(current, (unsigned long *)__get_SP());
 		}
 
@@ -210,10 +210,10 @@ static int tce_buildmulti_pSeriesLP(stru
 	}
 
 	if (rc && printk_ratelimit()) {
-		printk("tce_buildmulti_pSeriesLP: plpar_tce_put failed. rc=%ld\n", rc);
-		printk("\tindex   = 0x%lx\n", (u64)tbl->it_index);
-		printk("\tnpages  = 0x%lx\n", (u64)npages);
-		printk("\ttce[0] val = 0x%lx\n", tcep[0]);
+		printk("tce_buildmulti_pSeriesLP: plpar_tce_put failed. rc=%lld\n", rc);
+		printk("\tindex   = 0x%llx\n", (u64)tbl->it_index);
+		printk("\tnpages  = 0x%llx\n", (u64)npages);
+		printk("\ttce[0] val = 0x%llx\n", tcep[0]);
 		show_stack(current, (unsigned long *)__get_SP());
 	}
 	return ret;
@@ -227,9 +227,9 @@ static void tce_free_pSeriesLP(struct io
 		rc = plpar_tce_put((u64)tbl->it_index, (u64)tcenum << 12, 0);
 
 		if (rc && printk_ratelimit()) {
-			printk("tce_free_pSeriesLP: plpar_tce_put failed. rc=%ld\n", rc);
-			printk("\tindex   = 0x%lx\n", (u64)tbl->it_index);
-			printk("\ttcenum  = 0x%lx\n", (u64)tcenum);
+			printk("tce_free_pSeriesLP: plpar_tce_put failed. rc=%lld\n", rc);
+			printk("\tindex   = 0x%llx\n", (u64)tbl->it_index);
+			printk("\ttcenum  = 0x%llx\n", (u64)tcenum);
 			show_stack(current, (unsigned long *)__get_SP());
 		}
 
@@ -246,9 +246,9 @@ static void tce_freemulti_pSeriesLP(stru
 
 	if (rc && printk_ratelimit()) {
 		printk("tce_freemulti_pSeriesLP: plpar_tce_stuff failed\n");
-		printk("\trc      = %ld\n", rc);
-		printk("\tindex   = 0x%lx\n", (u64)tbl->it_index);
-		printk("\tnpages  = 0x%lx\n", (u64)npages);
+		printk("\trc      = %lld\n", rc);
+		printk("\tindex   = 0x%llx\n", (u64)tbl->it_index);
+		printk("\tnpages  = 0x%llx\n", (u64)npages);
 		show_stack(current, (unsigned long *)__get_SP());
 	}
 }
@@ -261,10 +261,9 @@ static unsigned long tce_get_pSeriesLP(s
 	rc = plpar_tce_get((u64)tbl->it_index, (u64)tcenum << 12, &tce_ret);
 
 	if (rc && printk_ratelimit()) {
-		printk("tce_get_pSeriesLP: plpar_tce_get failed. rc=%ld\n",
-			rc);
-		printk("\tindex   = 0x%lx\n", (u64)tbl->it_index);
-		printk("\ttcenum  = 0x%lx\n", (u64)tcenum);
+		printk("tce_get_pSeriesLP: plpar_tce_get failed. rc=%lld\n", rc);
+		printk("\tindex   = 0x%llx\n", (u64)tbl->it_index);
+		printk("\ttcenum  = 0x%llx\n", (u64)tcenum);
 		show_stack(current, (unsigned long *)__get_SP());
 	}
 
diff -puN arch/powerpc/sysdev/mpic.c~powerpc-change-u64-s64-to-a-long-long-integer-type arch/powerpc/sysdev/mpic.c
--- a/arch/powerpc/sysdev/mpic.c~powerpc-change-u64-s64-to-a-long-long-integer-type
+++ a/arch/powerpc/sysdev/mpic.c
@@ -435,7 +435,7 @@ static void __init mpic_scan_ht_msi(stru
 		addr = addr | ((u64)readl(base + HT_MSI_ADDR_HI) << 32);
 	}
 
-	printk(KERN_DEBUG "mpic:   - HT:%02x.%x %s MSI mapping found @ 0x%lx\n",
+	printk(KERN_DEBUG "mpic:   - HT:%02x.%x %s MSI mapping found @ 0x%llx\n",
 		PCI_SLOT(devfn), PCI_FUNC(devfn),
 		flags & HT_MSI_FLAGS_ENABLE ? "enabled" : "disabled", addr);
 
diff -puN drivers/char/hvc_beat.c~powerpc-change-u64-s64-to-a-long-long-integer-type drivers/char/hvc_beat.c
--- a/drivers/char/hvc_beat.c~powerpc-change-u64-s64-to-a-long-long-integer-type
+++ a/drivers/char/hvc_beat.c
@@ -44,7 +44,7 @@ static int hvc_beat_get_chars(uint32_t v
 	static unsigned char q[sizeof(unsigned long) * 2]
 		__attribute__((aligned(sizeof(unsigned long))));
 	static int qlen = 0;
-	unsigned long got;
+	u64 got;
 
 again:
 	if (qlen) {
@@ -63,7 +63,7 @@ again:
 		}
 	}
 	if (beat_get_term_char(vtermno, &got,
-		((unsigned long *)q), ((unsigned long *)q) + 1) == 0) {
+		((u64 *)q), ((u64 *)q) + 1) == 0) {
 		qlen = got;
 		goto again;
 	}
diff -puN drivers/net/pasemi_mac.c~powerpc-change-u64-s64-to-a-long-long-integer-type drivers/net/pasemi_mac.c
--- a/drivers/net/pasemi_mac.c~powerpc-change-u64-s64-to-a-long-long-integer-type
+++ a/drivers/net/pasemi_mac.c
@@ -712,7 +712,7 @@ static inline void pasemi_mac_rx_error(c
 	rcmdsta = read_dma_reg(PAS_DMA_RXINT_RCMDSTA(mac->dma_if));
 	ccmdsta = read_dma_reg(PAS_DMA_RXCHAN_CCMDSTA(chan->chno));
 
-	printk(KERN_ERR "pasemi_mac: rx error. macrx %016lx, rx status %lx\n",
+	printk(KERN_ERR "pasemi_mac: rx error. macrx %016llx, rx status %llx\n",
 		macrx, *chan->status);
 
 	printk(KERN_ERR "pasemi_mac: rcmdsta %08x ccmdsta %08x\n",
@@ -730,8 +730,8 @@ static inline void pasemi_mac_tx_error(c
 
 	cmdsta = read_dma_reg(PAS_DMA_TXCHAN_TCMDSTA(chan->chno));
 
-	printk(KERN_ERR "pasemi_mac: tx error. mactx 0x%016lx, "\
-		"tx status 0x%016lx\n", mactx, *chan->status);
+	printk(KERN_ERR "pasemi_mac: tx error. mactx 0x%016llx, "\
+		"tx status 0x%016llx\n", mactx, *chan->status);
 
 	printk(KERN_ERR "pasemi_mac: tcmdsta 0x%08x\n", cmdsta);
 }
diff -puN drivers/pcmcia/electra_cf.c~powerpc-change-u64-s64-to-a-long-long-integer-type drivers/pcmcia/electra_cf.c
--- a/drivers/pcmcia/electra_cf.c~powerpc-change-u64-s64-to-a-long-long-integer-type
+++ a/drivers/pcmcia/electra_cf.c
@@ -297,7 +297,7 @@ static int __devinit electra_cf_probe(st
 		goto fail3;
 	}
 
-	dev_info(device, "at mem 0x%lx io 0x%lx irq %d\n",
+	dev_info(device, "at mem 0x%lx io 0x%llx irq %d\n",
 		 cf->mem_phys, io.start, cf->irq);
 
 	cf->active = 1;
diff -puN drivers/scsi/ibmvscsi/ibmvscsi.c~powerpc-change-u64-s64-to-a-long-long-integer-type drivers/scsi/ibmvscsi/ibmvscsi.c
--- a/drivers/scsi/ibmvscsi/ibmvscsi.c~powerpc-change-u64-s64-to-a-long-long-integer-type
+++ a/drivers/scsi/ibmvscsi/ibmvscsi.c
@@ -1060,7 +1060,7 @@ static int ibmvscsi_eh_abort_handler(str
 	}
 
 	sdev_printk(KERN_INFO, cmd->device,
-                    "aborting command. lun 0x%lx, tag 0x%lx\n",
+                    "aborting command. lun 0x%llx, tag 0x%llx\n",
 		    (((u64) lun) << 48), (u64) found_evt);
 
 	wait_for_completion(&evt->comp);
@@ -1081,7 +1081,7 @@ static int ibmvscsi_eh_abort_handler(str
 	if (rsp_rc) {
 		if (printk_ratelimit())
 			sdev_printk(KERN_WARNING, cmd->device,
-				    "abort code %d for task tag 0x%lx\n",
+				    "abort code %d for task tag 0x%llx\n",
 				    rsp_rc, tsk_mgmt->task_tag);
 		return FAILED;
 	}
@@ -1101,12 +1101,12 @@ static int ibmvscsi_eh_abort_handler(str
 
 	if (found_evt == NULL) {
 		spin_unlock_irqrestore(hostdata->host->host_lock, flags);
-		sdev_printk(KERN_INFO, cmd->device, "aborted task tag 0x%lx completed\n",
+		sdev_printk(KERN_INFO, cmd->device, "aborted task tag 0x%llx completed\n",
 			    tsk_mgmt->task_tag);
 		return SUCCESS;
 	}
 
-	sdev_printk(KERN_INFO, cmd->device, "successfully aborted task tag 0x%lx\n",
+	sdev_printk(KERN_INFO, cmd->device, "successfully aborted task tag 0x%llx\n",
 		    tsk_mgmt->task_tag);
 
 	cmd->result = (DID_ABORT << 16);
@@ -1181,7 +1181,7 @@ static int ibmvscsi_eh_device_reset_hand
 		return FAILED;
 	}
 
-	sdev_printk(KERN_INFO, cmd->device, "resetting device. lun 0x%lx\n",
+	sdev_printk(KERN_INFO, cmd->device, "resetting device. lun 0x%llx\n",
 		    (((u64) lun) << 48));
 
 	wait_for_completion(&evt->comp);
@@ -1202,7 +1202,7 @@ static int ibmvscsi_eh_device_reset_hand
 	if (rsp_rc) {
 		if (printk_ratelimit())
 			sdev_printk(KERN_WARNING, cmd->device,
-				    "reset code %d for task tag 0x%lx\n",
+				    "reset code %d for task tag 0x%llx\n",
 				    rsp_rc, tsk_mgmt->task_tag);
 		return FAILED;
 	}
_

Patches currently in -mm which might be from mingo@elte.hu are

origin.patch
linux-next.patch
revert-sched-fix-uneven-per-cpu-task_group-share-distribution.patch
x86-remove-init_mm-export-as-planned-for-2626.patch
powerpc-change-u64-s64-to-a-long-long-integer-type.patch
cpuacct-refactoring-cpuusage_read-cpuusage_write.patch
cpuacct-export-percpu-cpuacct-cgroup-stats.patch
irq-free-setup_irq-interrupt-using-free_irq.patch
vfs-fix-switch_names-breakage-in-short-to-short-case.patch
mm-invoke-oom-killer-from-page-fault.patch
mm-invoke-oom-killer-from-page-fault-fix.patch
mm-invoke-oom-killer-from-page-fault-fix-fix-2.patch
mm-show-node-to-memory-section-relationship-with-symlinks-in-sysfs.patch
mm-show-node-to-memory-section-relationship-with-symlinks-in-sysfs-v3.patch
page_fault-retry-with-nopage_retry.patch
page_fault-retry-with-nopage_retry-fix.patch
page_fault-retry-with-nopage_retry-fix-fix.patch
oops-handling-ensure-that-any-oops-is-flushed-to-the-mtdoops-console.patch
remove-remaining-unwinder-code.patch
poll-allow-f_op-poll-to-sleep-take6.patch
documentation-when-to-bug-and-when-to-not-bug.patch
allow-times-and-time-system-calls-to-return-small-negative-values.patch
smp_call_function_single-be-slightly-less-stupid.patch
kernel-hrtimerc-kill-warning.patch
softirq-introduce-statistics-for-softirq.patch
proc-export-statistics-for-softirq-to-proc.patch
proc-update-document-for-proc-softirqs-and-proc-stat.patch
irq-remove-unnecessary-ifdef.patch
checkpatch-struct-file_operations-should-normally-be-const.patch
kprobes-add-kprobe_insn_mutex-and-cleanup-arch_remove_kprobe.patch
xen-add-xenfs-to-allow-usermode-xen-interaction.patch
xen-add-xenfs-to-allow-usermode-xen-interaction-fix-xenbus-message-reads.patch
futex-update-futex_q-to-clarify-single-waiter-semantics.patch
futex-cleanup-futex_unlock_pi-fault-handling.patch
unaligned-wire-up-trivial-arches-for-new-common-unaligned-header.patch
linuxpps-core-support.patch
pps-userland-header-file-for-pps-api.patch
pps-documentation-programs-and-examples.patch
pps-linuxpps-clients-support.patch
ldisc-new-dcd_change-method-for-line-disciplines.patch
pps-parallel-port-clients-support.patch
factor-out-ifdefs-from-kernel-spinlockc-to-lock_contended_flags.patch
allow-rwlocks-to-re-enable-interrupts.patch
ia64-implement-interrupt-enabling-rwlocks.patch
ia64-implement-interrupt-enabling-rwlocks-fix.patch
remove-lots-of-double-semicolons.patch
generic-swap-sched-remove-local-swap-macro.patch
make-frame_pointer-default=y.patch
mutex-subsystem-synchro-test-module.patch

