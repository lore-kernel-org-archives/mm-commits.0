From: akpm@linux-foundation.org
Subject: - alpha-remove-remaining-__function__-occurences.patch removed from -mm tree
Date: Mon, 28 Apr 2008 14:54:28 -0700
Message-ID: <200804282154.m3SLsS1N018010@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42964 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935873AbYD1Vyl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Apr 2008 17:54:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: harvey.harrison@gmail.com, ink@jurassic.park.msu.ru, rth@twiddle.net, mm-commits@vger.kernel.org


The patch titled
     alpha: remove remaining __FUNCTION__ occurrences
has been removed from the -mm tree.  Its filename was
     alpha-remove-remaining-__function__-occurences.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: alpha: remove remaining __FUNCTION__ occurrences
From: Harvey Harrison <harvey.harrison@gmail.com>

__FUNCTION__ is gcc-specific, use __func__

The change in pci-iommu,c should be safe as arena has not been assigned
when we get to this point.

Some were within #if 0 blocks, have changed them and left the blocks
as they appear to be debugging infrastructure.

A #define FN __FUNCTION__ was removed and occurances of FN were replaced
with __func__ as well.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Richard Henderson <rth@twiddle.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/alpha/kernel/core_marvel.c  |    6 ++---
 arch/alpha/kernel/core_t2.c      |   24 +++++++-------------
 arch/alpha/kernel/core_titan.c   |   34 ++++++++++++++---------------
 arch/alpha/kernel/core_tsunami.c |   28 +++++++++++------------
 arch/alpha/kernel/pci.c          |    2 -
 arch/alpha/kernel/pci_iommu.c    |   34 ++++++++++++-----------------
 arch/alpha/kernel/smp.c          |    4 +--
 arch/alpha/kernel/srm_env.c      |    2 -
 arch/alpha/kernel/sys_alcor.c    |    2 -
 arch/alpha/kernel/sys_marvel.c   |   12 +++++-----
 arch/alpha/kernel/sys_sable.c    |    6 ++---
 arch/alpha/kernel/sys_sio.c      |    2 -
 12 files changed, 72 insertions(+), 84 deletions(-)

diff -puN arch/alpha/kernel/core_marvel.c~alpha-remove-remaining-__function__-occurences arch/alpha/kernel/core_marvel.c
--- a/arch/alpha/kernel/core_marvel.c~alpha-remove-remaining-__function__-occurences
+++ a/arch/alpha/kernel/core_marvel.c
@@ -994,7 +994,7 @@ marvel_agp_configure(alpha_agp_info *agp
 		 * rate, but warn the user.
 		 */
 		printk("%s: unknown PLL setting RNGB=%lx (PLL6_CTL=%016lx)\n",
-		       __FUNCTION__, IO7_PLL_RNGB(agp_pll), agp_pll);
+		       __func__, IO7_PLL_RNGB(agp_pll), agp_pll);
 		break;
 	}
 
@@ -1044,13 +1044,13 @@ marvel_agp_translate(alpha_agp_info *agp
 
 	if (addr < agp->aperture.bus_base ||
 	    addr >= agp->aperture.bus_base + agp->aperture.size) {
-		printk("%s: addr out of range\n", __FUNCTION__);
+		printk("%s: addr out of range\n", __func__);
 		return -EINVAL;
 	}
 
 	pte = aper->arena->ptes[baddr >> PAGE_SHIFT];
 	if (!(pte & 1)) {
-		printk("%s: pte not valid\n", __FUNCTION__);
+		printk("%s: pte not valid\n", __func__);
 		return -EINVAL;
 	} 
 	return (pte >> 1) << PAGE_SHIFT;
diff -puN arch/alpha/kernel/core_t2.c~alpha-remove-remaining-__function__-occurences arch/alpha/kernel/core_t2.c
--- a/arch/alpha/kernel/core_t2.c~alpha-remove-remaining-__function__-occurences
+++ a/arch/alpha/kernel/core_t2.c
@@ -336,10 +336,7 @@ t2_direct_map_window1(unsigned long base
 
 #if DEBUG_PRINT_FINAL_SETTINGS
 	printk("%s: setting WBASE1=0x%lx WMASK1=0x%lx TBASE1=0x%lx\n",
-	       __FUNCTION__,
-	       *(vulp)T2_WBASE1,
-	       *(vulp)T2_WMASK1,
-	       *(vulp)T2_TBASE1);
+	       __func__, *(vulp)T2_WBASE1, *(vulp)T2_WMASK1, *(vulp)T2_TBASE1);
 #endif
 }
 
@@ -366,10 +363,7 @@ t2_sg_map_window2(struct pci_controller 
 
 #if DEBUG_PRINT_FINAL_SETTINGS
 	printk("%s: setting WBASE2=0x%lx WMASK2=0x%lx TBASE2=0x%lx\n",
-	       __FUNCTION__,
-	       *(vulp)T2_WBASE2,
-	       *(vulp)T2_WMASK2,
-	       *(vulp)T2_TBASE2);
+	       __func__, *(vulp)T2_WBASE2, *(vulp)T2_WMASK2, *(vulp)T2_TBASE2);
 #endif
 }
 
@@ -377,15 +371,15 @@ static void __init
 t2_save_configuration(void)
 {
 #if DEBUG_PRINT_INITIAL_SETTINGS
-	printk("%s: HAE_1 was 0x%lx\n", __FUNCTION__, srm_hae); /* HW is 0 */
-	printk("%s: HAE_2 was 0x%lx\n", __FUNCTION__, *(vulp)T2_HAE_2);
-	printk("%s: HAE_3 was 0x%lx\n", __FUNCTION__, *(vulp)T2_HAE_3);
-	printk("%s: HAE_4 was 0x%lx\n", __FUNCTION__, *(vulp)T2_HAE_4);
-	printk("%s: HBASE was 0x%lx\n", __FUNCTION__, *(vulp)T2_HBASE);
+	printk("%s: HAE_1 was 0x%lx\n", __func__, srm_hae); /* HW is 0 */
+	printk("%s: HAE_2 was 0x%lx\n", __func__, *(vulp)T2_HAE_2);
+	printk("%s: HAE_3 was 0x%lx\n", __func__, *(vulp)T2_HAE_3);
+	printk("%s: HAE_4 was 0x%lx\n", __func__, *(vulp)T2_HAE_4);
+	printk("%s: HBASE was 0x%lx\n", __func__, *(vulp)T2_HBASE);
 
-	printk("%s: WBASE1=0x%lx WMASK1=0x%lx TBASE1=0x%lx\n", __FUNCTION__, 
+	printk("%s: WBASE1=0x%lx WMASK1=0x%lx TBASE1=0x%lx\n", __func__,
 	       *(vulp)T2_WBASE1, *(vulp)T2_WMASK1, *(vulp)T2_TBASE1);
-	printk("%s: WBASE2=0x%lx WMASK2=0x%lx TBASE2=0x%lx\n", __FUNCTION__, 
+	printk("%s: WBASE2=0x%lx WMASK2=0x%lx TBASE2=0x%lx\n", __func__,
 	       *(vulp)T2_WBASE2, *(vulp)T2_WMASK2, *(vulp)T2_TBASE2);
 #endif
 
diff -puN arch/alpha/kernel/core_titan.c~alpha-remove-remaining-__function__-occurences arch/alpha/kernel/core_titan.c
--- a/arch/alpha/kernel/core_titan.c~alpha-remove-remaining-__function__-occurences
+++ a/arch/alpha/kernel/core_titan.c
@@ -365,21 +365,21 @@ void __init
 titan_init_arch(void)
 {
 #if 0
-	printk("%s: titan_init_arch()\n", __FUNCTION__);
-	printk("%s: CChip registers:\n", __FUNCTION__);
-	printk("%s: CSR_CSC 0x%lx\n", __FUNCTION__, TITAN_cchip->csc.csr);
-	printk("%s: CSR_MTR 0x%lx\n", __FUNCTION__, TITAN_cchip->mtr.csr);
-	printk("%s: CSR_MISC 0x%lx\n", __FUNCTION__, TITAN_cchip->misc.csr);
-	printk("%s: CSR_DIM0 0x%lx\n", __FUNCTION__, TITAN_cchip->dim0.csr);
-	printk("%s: CSR_DIM1 0x%lx\n", __FUNCTION__, TITAN_cchip->dim1.csr);
-	printk("%s: CSR_DIR0 0x%lx\n", __FUNCTION__, TITAN_cchip->dir0.csr);
-	printk("%s: CSR_DIR1 0x%lx\n", __FUNCTION__, TITAN_cchip->dir1.csr);
-	printk("%s: CSR_DRIR 0x%lx\n", __FUNCTION__, TITAN_cchip->drir.csr);
-
-	printk("%s: DChip registers:\n", __FUNCTION__);
-	printk("%s: CSR_DSC 0x%lx\n", __FUNCTION__, TITAN_dchip->dsc.csr);
-	printk("%s: CSR_STR 0x%lx\n", __FUNCTION__, TITAN_dchip->str.csr);
-	printk("%s: CSR_DREV 0x%lx\n", __FUNCTION__, TITAN_dchip->drev.csr);
+	printk("%s: titan_init_arch()\n", __func__);
+	printk("%s: CChip registers:\n", __func__);
+	printk("%s: CSR_CSC 0x%lx\n", __func__, TITAN_cchip->csc.csr);
+	printk("%s: CSR_MTR 0x%lx\n", __func__, TITAN_cchip->mtr.csr);
+	printk("%s: CSR_MISC 0x%lx\n", __func__, TITAN_cchip->misc.csr);
+	printk("%s: CSR_DIM0 0x%lx\n", __func__, TITAN_cchip->dim0.csr);
+	printk("%s: CSR_DIM1 0x%lx\n", __func__, TITAN_cchip->dim1.csr);
+	printk("%s: CSR_DIR0 0x%lx\n", __func__, TITAN_cchip->dir0.csr);
+	printk("%s: CSR_DIR1 0x%lx\n", __func__, TITAN_cchip->dir1.csr);
+	printk("%s: CSR_DRIR 0x%lx\n", __func__, TITAN_cchip->drir.csr);
+
+	printk("%s: DChip registers:\n", __func__);
+	printk("%s: CSR_DSC 0x%lx\n", __func__, TITAN_dchip->dsc.csr);
+	printk("%s: CSR_STR 0x%lx\n", __func__, TITAN_dchip->str.csr);
+	printk("%s: CSR_DREV 0x%lx\n", __func__, TITAN_dchip->drev.csr);
 #endif
 
 	boot_cpuid = __hard_smp_processor_id();
@@ -700,13 +700,13 @@ titan_agp_translate(alpha_agp_info *agp,
 
 	if (addr < agp->aperture.bus_base ||
 	    addr >= agp->aperture.bus_base + agp->aperture.size) {
-		printk("%s: addr out of range\n", __FUNCTION__);
+		printk("%s: addr out of range\n", __func__);
 		return -EINVAL;
 	}
 
 	pte = aper->arena->ptes[baddr >> PAGE_SHIFT];
 	if (!(pte & 1)) {
-		printk("%s: pte not valid\n", __FUNCTION__);
+		printk("%s: pte not valid\n", __func__);
 		return -EINVAL;
 	}
 
diff -puN arch/alpha/kernel/core_tsunami.c~alpha-remove-remaining-__function__-occurences arch/alpha/kernel/core_tsunami.c
--- a/arch/alpha/kernel/core_tsunami.c~alpha-remove-remaining-__function__-occurences
+++ a/arch/alpha/kernel/core_tsunami.c
@@ -241,8 +241,6 @@ tsunami_probe_write(volatile unsigned lo
 #define tsunami_probe_read(ADDR) 1
 #endif /* NXM_MACHINE_CHECKS_ON_TSUNAMI */
 
-#define FN __FUNCTION__
-
 static void __init
 tsunami_init_one_pchip(tsunami_pchip *pchip, int index)
 {
@@ -383,27 +381,27 @@ tsunami_init_arch(void)
 	/* NXMs just don't matter to Tsunami--unless they make it
 	   choke completely. */
 	tmp = (unsigned long)(TSUNAMI_cchip - 1);
-	printk("%s: probing bogus address:  0x%016lx\n", FN, bogus_addr);
+	printk("%s: probing bogus address:  0x%016lx\n", __func__, bogus_addr);
 	printk("\tprobe %s\n",
 	       tsunami_probe_write((unsigned long *)bogus_addr)
 	       ? "succeeded" : "failed");
 #endif /* NXM_MACHINE_CHECKS_ON_TSUNAMI */
 
 #if 0
-	printk("%s: CChip registers:\n", FN);
-	printk("%s: CSR_CSC 0x%lx\n", FN, TSUNAMI_cchip->csc.csr);
-	printk("%s: CSR_MTR 0x%lx\n", FN, TSUNAMI_cchip.mtr.csr);
-	printk("%s: CSR_MISC 0x%lx\n", FN, TSUNAMI_cchip->misc.csr);
-	printk("%s: CSR_DIM0 0x%lx\n", FN, TSUNAMI_cchip->dim0.csr);
-	printk("%s: CSR_DIM1 0x%lx\n", FN, TSUNAMI_cchip->dim1.csr);
-	printk("%s: CSR_DIR0 0x%lx\n", FN, TSUNAMI_cchip->dir0.csr);
-	printk("%s: CSR_DIR1 0x%lx\n", FN, TSUNAMI_cchip->dir1.csr);
-	printk("%s: CSR_DRIR 0x%lx\n", FN, TSUNAMI_cchip->drir.csr);
+	printk("%s: CChip registers:\n", __func__);
+	printk("%s: CSR_CSC 0x%lx\n", __func__, TSUNAMI_cchip->csc.csr);
+	printk("%s: CSR_MTR 0x%lx\n", __func__, TSUNAMI_cchip.mtr.csr);
+	printk("%s: CSR_MISC 0x%lx\n", __func__, TSUNAMI_cchip->misc.csr);
+	printk("%s: CSR_DIM0 0x%lx\n", __func__, TSUNAMI_cchip->dim0.csr);
+	printk("%s: CSR_DIM1 0x%lx\n", __func__, TSUNAMI_cchip->dim1.csr);
+	printk("%s: CSR_DIR0 0x%lx\n", __func__, TSUNAMI_cchip->dir0.csr);
+	printk("%s: CSR_DIR1 0x%lx\n", __func__, TSUNAMI_cchip->dir1.csr);
+	printk("%s: CSR_DRIR 0x%lx\n", __func__, TSUNAMI_cchip->drir.csr);
 
 	printk("%s: DChip registers:\n");
-	printk("%s: CSR_DSC 0x%lx\n", FN, TSUNAMI_dchip->dsc.csr);
-	printk("%s: CSR_STR 0x%lx\n", FN, TSUNAMI_dchip->str.csr);
-	printk("%s: CSR_DREV 0x%lx\n", FN, TSUNAMI_dchip->drev.csr);
+	printk("%s: CSR_DSC 0x%lx\n", __func__, TSUNAMI_dchip->dsc.csr);
+	printk("%s: CSR_STR 0x%lx\n", __func__, TSUNAMI_dchip->str.csr);
+	printk("%s: CSR_DREV 0x%lx\n", __func__, TSUNAMI_dchip->drev.csr);
 #endif
 	/* With multiple PCI busses, we play with I/O as physical addrs.  */
 	ioport_resource.end = ~0UL;
diff -puN arch/alpha/kernel/pci.c~alpha-remove-remaining-__function__-occurences arch/alpha/kernel/pci.c
--- a/arch/alpha/kernel/pci.c~alpha-remove-remaining-__function__-occurences
+++ a/arch/alpha/kernel/pci.c
@@ -208,7 +208,7 @@ pdev_save_srm_config(struct pci_dev *dev
 
 	tmp = kmalloc(sizeof(*tmp), GFP_KERNEL);
 	if (!tmp) {
-		printk(KERN_ERR "%s: kmalloc() failed!\n", __FUNCTION__);
+		printk(KERN_ERR "%s: kmalloc() failed!\n", __func__);
 		return;
 	}
 	tmp->next = srm_saved_configs;
diff -puN arch/alpha/kernel/pci_iommu.c~alpha-remove-remaining-__function__-occurences arch/alpha/kernel/pci_iommu.c
--- a/arch/alpha/kernel/pci_iommu.c~alpha-remove-remaining-__function__-occurences
+++ a/arch/alpha/kernel/pci_iommu.c
@@ -79,25 +79,21 @@ iommu_arena_new_node(int nid, struct pci
 
 #ifdef CONFIG_DISCONTIGMEM
 
-        if (!NODE_DATA(nid) ||
-            (NULL == (arena = alloc_bootmem_node(NODE_DATA(nid),
-                                                 sizeof(*arena))))) {
-                printk("%s: couldn't allocate arena from node %d\n"
-                       "    falling back to system-wide allocation\n",
-                       __FUNCTION__, nid);
-                arena = alloc_bootmem(sizeof(*arena));
-        }
-
-        if (!NODE_DATA(nid) ||
-            (NULL == (arena->ptes = __alloc_bootmem_node(NODE_DATA(nid),
-                                                         mem_size,
-                                                         align,
-                                                         0)))) {
-                printk("%s: couldn't allocate arena ptes from node %d\n"
-                       "    falling back to system-wide allocation\n",
-                       __FUNCTION__, nid);
-                arena->ptes = __alloc_bootmem(mem_size, align, 0);
-        }
+	arena = alloc_bootmem_node(NODE_DATA(nid), sizeof(*arena));
+	if (!NODE_DATA(nid) || !arena) {
+		printk("%s: couldn't allocate arena from node %d\n"
+		       "    falling back to system-wide allocation\n",
+		       __func__, nid);
+		arena = alloc_bootmem(sizeof(*arena));
+	}
+
+	arena->ptes = __alloc_bootmem_node(NODE_DATA(nid), mem_size, align, 0);
+	if (!NODE_DATA(nid) || !arena->ptes) {
+		printk("%s: couldn't allocate arena ptes from node %d\n"
+		       "    falling back to system-wide allocation\n",
+		       __func__, nid);
+		arena->ptes = __alloc_bootmem(mem_size, align, 0);
+	}
 
 #else /* CONFIG_DISCONTIGMEM */
 
diff -puN arch/alpha/kernel/smp.c~alpha-remove-remaining-__function__-occurences arch/alpha/kernel/smp.c
--- a/arch/alpha/kernel/smp.c~alpha-remove-remaining-__function__-occurences
+++ a/arch/alpha/kernel/smp.c
@@ -755,7 +755,7 @@ smp_call_function_on_cpu (void (*func) (
 	if (atomic_read(&data.unstarted_count) > 0) {
 		long start_time = jiffies;
 		printk(KERN_ERR "%s: initial timeout -- trying long wait\n",
-		       __FUNCTION__);
+		       __func__);
 		timeout = jiffies + 30 * HZ;
 		while (atomic_read(&data.unstarted_count) > 0
 		       && time_before(jiffies, timeout))
@@ -764,7 +764,7 @@ smp_call_function_on_cpu (void (*func) (
 			long delta = jiffies - start_time;
 			printk(KERN_ERR 
 			       "%s: response %ld.%ld seconds into long wait\n",
-			       __FUNCTION__, delta / HZ,
+			       __func__, delta / HZ,
 			       (100 * (delta - ((delta / HZ) * HZ))) / HZ);
 		}
 	}
diff -puN arch/alpha/kernel/srm_env.c~alpha-remove-remaining-__function__-occurences arch/alpha/kernel/srm_env.c
--- a/arch/alpha/kernel/srm_env.c~alpha-remove-remaining-__function__-occurences
+++ a/arch/alpha/kernel/srm_env.c
@@ -199,7 +199,7 @@ srm_env_init(void)
 		printk(KERN_INFO "%s: This Alpha system doesn't "
 				"know about SRM (or you've booted "
 				"SRM->MILO->Linux, which gets "
-				"misdetected)...\n", __FUNCTION__);
+				"misdetected)...\n", __func__);
 		return -ENODEV;
 	}
 
diff -puN arch/alpha/kernel/sys_alcor.c~alpha-remove-remaining-__function__-occurences arch/alpha/kernel/sys_alcor.c
--- a/arch/alpha/kernel/sys_alcor.c~alpha-remove-remaining-__function__-occurences
+++ a/arch/alpha/kernel/sys_alcor.c
@@ -259,7 +259,7 @@ alcor_init_pci(void)
 	if (dev && dev->devfn == PCI_DEVFN(6,0)) {
 		alpha_mv.sys.cia.gru_int_req_bits = XLT_GRU_INT_REQ_BITS; 
 		printk(KERN_INFO "%s: Detected AS500 or XLT motherboard.\n",
-		       __FUNCTION__);
+		       __func__);
 	}
 	pci_dev_put(dev);
 }
diff -puN arch/alpha/kernel/sys_marvel.c~alpha-remove-remaining-__function__-occurences arch/alpha/kernel/sys_marvel.c
--- a/arch/alpha/kernel/sys_marvel.c~alpha-remove-remaining-__function__-occurences
+++ a/arch/alpha/kernel/sys_marvel.c
@@ -80,7 +80,7 @@ io7_get_irq_ctl(unsigned int irq, struct
 	if (!(io7 = marvel_find_io7(pid))) {
 		printk(KERN_ERR 
 		       "%s for nonexistent io7 -- vec %x, pid %d\n",
-		       __FUNCTION__, irq, pid);
+		       __func__, irq, pid);
 		return NULL;
 	}
 
@@ -90,7 +90,7 @@ io7_get_irq_ctl(unsigned int irq, struct
 	if (irq >= 0x180) {
 		printk(KERN_ERR 
 		       "%s for invalid irq -- pid %d adjusted irq %x\n",
-		       __FUNCTION__, pid, irq);
+		       __func__, pid, irq);
 		return NULL;
 	}
 
@@ -110,8 +110,8 @@ io7_enable_irq(unsigned int irq)
 
 	ctl = io7_get_irq_ctl(irq, &io7);
 	if (!ctl || !io7) {
-		printk(KERN_ERR "%s: get_ctl failed for irq %x\n", 
-		       __FUNCTION__, irq);
+		printk(KERN_ERR "%s: get_ctl failed for irq %x\n",
+		       __func__, irq);
 		return;
 	}
 		
@@ -130,8 +130,8 @@ io7_disable_irq(unsigned int irq)
 
 	ctl = io7_get_irq_ctl(irq, &io7);
 	if (!ctl || !io7) {
-		printk(KERN_ERR "%s: get_ctl failed for irq %x\n", 
-		       __FUNCTION__, irq);
+		printk(KERN_ERR "%s: get_ctl failed for irq %x\n",
+		       __func__, irq);
 		return;
 	}
 		
diff -puN arch/alpha/kernel/sys_sable.c~alpha-remove-remaining-__function__-occurences arch/alpha/kernel/sys_sable.c
--- a/arch/alpha/kernel/sys_sable.c~alpha-remove-remaining-__function__-occurences
+++ a/arch/alpha/kernel/sys_sable.c
@@ -454,7 +454,7 @@ sable_lynx_enable_irq(unsigned int irq)
 	spin_unlock(&sable_lynx_irq_lock);
 #if 0
 	printk("%s: mask 0x%lx bit 0x%x irq 0x%x\n",
-	       __FUNCTION__, mask, bit, irq);
+	       __func__, mask, bit, irq);
 #endif
 }
 
@@ -470,7 +470,7 @@ sable_lynx_disable_irq(unsigned int irq)
 	spin_unlock(&sable_lynx_irq_lock);
 #if 0
 	printk("%s: mask 0x%lx bit 0x%x irq 0x%x\n",
-	       __FUNCTION__, mask, bit, irq);
+	       __func__, mask, bit, irq);
 #endif
 }
 
@@ -524,7 +524,7 @@ sable_lynx_srm_device_interrupt(unsigned
 	irq = sable_lynx_irq_swizzle->mask_to_irq[bit];
 #if 0
 	printk("%s: vector 0x%lx bit 0x%x irq 0x%x\n",
-	       __FUNCTION__, vector, bit, irq);
+	       __func__, vector, bit, irq);
 #endif
 	handle_irq(irq);
 }
diff -puN arch/alpha/kernel/sys_sio.c~alpha-remove-remaining-__function__-occurences arch/alpha/kernel/sys_sio.c
--- a/arch/alpha/kernel/sys_sio.c~alpha-remove-remaining-__function__-occurences
+++ a/arch/alpha/kernel/sys_sio.c
@@ -89,7 +89,7 @@ sio_pci_route(void)
 	/* First, ALWAYS read and print the original setting. */
 	pci_bus_read_config_dword(pci_isa_hose->bus, PCI_DEVFN(7, 0), 0x60,
 				  &orig_route_tab);
-	printk("%s: PIRQ original 0x%x new 0x%x\n", __FUNCTION__,
+	printk("%s: PIRQ original 0x%x new 0x%x\n", __func__,
 	       orig_route_tab, alpha_mv.sys.sio.route_tab);
 
 #if defined(ALPHA_RESTORE_SRM_SETUP)
_

Patches currently in -mm which might be from harvey.harrison@gmail.com are

origin.patch
cifs-remove-global_extern-macro.patch
input-replace-remaining-__function__-occurrences.patch
git-kvm.patch
git-mips.patch
git-nfsd.patch
nfs-replace-remaining-__function__-occurrences.patch
parisc-replace-remaining-__function__-occurences.patch
drivers-parisc-replace-remaining-__function__-occurrences.patch
pcmcia-replace-remaining-__function__-occurrences.patch
scsi-replace-remaining-__function__-occurrences.patch
fusion-replace-remaining-__function__-occurrences.patch
scsi-replace-__inline-with-inline.patch
git-watchdog.patch
git-xfs.patch
xtensa-replace-remaining-__function__-occurences.patch
power-replace-remaining-__function__-occurrences.patch
adfs-work-around-bogus-sparse-warning.patch
coda-add-static-to-functions-in-dirc.patch
befs-fix-sparse-warning-in-linuxvfsc.patch
autofs4-fix-sparse-warning-in-rootc.patch
firmware-replace-remaining-__function__-occurrences.patch
drivers-misc-replace-remaining-__function__-occurrences.patch
xen-make-blkif_getgeo-static.patch
ecryptfs-replace-remaining-__function__-occurrences.patch
cgroup-fix-sparse-warning-of-shadow-symbol-in-cgroupc.patch
ext4-replace-remaining-__function__-occurrences.patch
jdb2-replace-remaining-__function__-occurrences.patch
char-fix-sparse-shadowed-variable-warnings-in-espc.patch
char-espc-fix-possible-double-unlock.patch
char-rocketc-fix-sparse-variable-shadowing-and-int-as-null-pointer.patch
cycladesc-fix-sparse-shadowed-variable-warnings.patch
epcac-static-functions-and-integer-as-null-pointer-fixes.patch
epcac-static-functions-and-integer-as-null-pointer-fixes-checkpatch-fixes.patch
add-macros-similar-to-min-max-min_t-max_t.patch
add-macros-similar-to-min-max-min_t-max_t-doc.patch
ide-eliminate-fit-macro.patch
ata-remove-fit-macro.patch
b43-replace-limit_value-macro-with-clamp_val.patch
b43legacy-replace-limit_value-macro-with-clamp_val.patch
fuse-use-clamp-rather-than-nested-min-max.patch
ide-tape-use-clamp_t-rather-than-nested-min_t-max_t.patch
input-ff-memlessc-use-clamp_val-macro.patch
dccp-ccid2c-ccid3c-use-clamp-clamp_t.patch
drivers-replace-remaining-__function__-occurrences.patch
kernel-add-common-infrastructure-for-unaligned-access.patch
kernel-move-arches-to-use-common-unaligned-access.patch
drivers-block-use-get_unaligned_-helpers.patch
hid-core-use-get_unaligned_-helpers.patch
char-use-get_unaligned_-helpers.patch
input-use-get_unaligned_-helpers.patch
mmc-use-get-put_unaligned_-helpers.patch
net-use-get-put_unaligned_-helpers.patch
wireless-use-get-put_unaligned_-helpers.patch
pcmcia-use-get-put_unaligned_-helpers.patch
usb-use-get-put_unaligned_-helpers.patch
video-use-get-put_unaligned_-helpers.patch
fat-use-get-put_unaligned_-helpers.patch
hfsplus-use-get-put_unaligned_-helpers.patch
isofs-use-get-put_unaligned_-helpers.patch
ncpfs-use-get-put_unaligned_-helpers.patch
ncpfs-use-get-put_unaligned_-helpers-checkpatch-fixes.patch
mm-remove-remaining-__function__-occurances.patch
block-remove-remaining-__function__-occurances.patch
kernel-replace-remaining-__function__-occurances.patch
lib-replace-remaining-__function__-occurances.patch
afs-replace-remaining-__function__-occurrences.patch
fs-replace-remaining-__function__-occurrences.patch
drivers-char-replace-remaining-__function__-occurrences.patch
serial-replace-remaining-__function__-occurrences.patch

