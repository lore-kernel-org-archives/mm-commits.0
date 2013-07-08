From: akpm@linux-foundation.org
Subject: [merged]
 mm-enhance-free_reserved_area-to-support-poisoning-memory-with-zero.patch
 removed from -mm tree
Date: Mon, 08 Jul 2013 12:26:06 -0700
Message-ID: <51db124e.IZ1lF25+PiO5RHV3%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50587 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752477Ab3GHT0I (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Jul 2013 15:26:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, yinghai@kernel.org, wujianguo@huawei.com, will.deacon@arm.com, wency@cn.fujitsu.com, walken@google.com, tj@kernel.org, tglx@linutronix.de, tangchen@cn.fujitsu.com, sworddragon2@aol.com, rusty@rustcorp.com.au, rmk@arm.linux.org.uk, riel@redhat.com, mst@redhat.com, mingo@redhat.com, minchan@kernel.org, mel@csn.ul.ie, m.szyprowski@samsung.com, konrad.wilk@oracle.com, kamezawa.hiroyu@jp.fujitsu.com, js1304@gmail.com, jiang.liu@huawei.com, jeremy@goop.org, isimatu.yasuaki@jp.fujitsu.com, hpa@zytor.com, geert@linux-m68k.org, dhowells@redhat.com, cmetcalf@tilera.com, catalin.marinas@arm.com, arnd@arndb.de, liuj97@gmail.com

Subject: [merged] mm-enhance-free_reserved_area-to-support-poisoning-memory-with-zero.patch removed from -mm tree
To: liuj97@gmail.com,arnd@arndb.de,catalin.marinas@arm.com,cmetcalf@tilera.com,dhowells@redhat.com,geert@linux-m68k.org,hpa@zytor.com,isimatu.yasuaki@jp.fujitsu.com,jeremy@goop.org,jiang.liu@huawei.com,js1304@gmail.com,kamezawa.hiroyu@jp.fujitsu.com,konrad.wilk@oracle.com,m.szyprowski@samsung.com,mel@csn.ul.ie,minchan@kernel.org,mingo@redhat.com,mst@redhat.com,riel@redhat.com,rmk@arm.linux.org.uk,rusty@rustcorp.com.au,sworddragon2@aol.com,tangchen@cn.fujitsu.com,tglx@linutronix.de,tj@kernel.org,walken@google.com,wency@cn.fujitsu.com,will.deacon@arm.com,wujianguo@huawei.com,yinghai@kernel.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 08 Jul 2013 12:26:06 -0700


The patch titled
     Subject: mm: enhance free_reserved_area() to support poisoning memory with zero
has been removed from the -mm tree.  Its filename was
     mm-enhance-free_reserved_area-to-support-poisoning-memory-with-zero.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jiang Liu <liuj97@gmail.com>
Subject: mm: enhance free_reserved_area() to support poisoning memory with zero

Address more review comments from last round of code review.
1) Enhance free_reserved_area() to support poisoning freed memory with
   pattern '0'. This could be used to get rid of poison_init_mem()
   on ARM64.
2) A previous patch has disabled memory poison for initmem on s390
   by mistake, so restore to the original behavior.
3) Remove redundant PAGE_ALIGN() when calling free_reserved_area().

Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>
Cc: <sworddragon2@aol.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Chris Metcalf <cmetcalf@tilera.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Jianguo Wu <wujianguo@huawei.com>
Cc: Joonsoo Kim <js1304@gmail.com>
Cc: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Michel Lespinasse <walken@google.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Rik van Riel <riel@redhat.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Tang Chen <tangchen@cn.fujitsu.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Wen Congyang <wency@cn.fujitsu.com>
Cc: Will Deacon <will.deacon@arm.com>
Cc: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Russell King <rmk@arm.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/alpha/kernel/sys_nautilus.c |    2 +-
 arch/alpha/mm/init.c             |    4 ++--
 arch/arc/mm/init.c               |    4 ++--
 arch/arm/mm/init.c               |    8 ++++----
 arch/arm64/mm/init.c             |    4 ++--
 arch/avr32/mm/init.c             |    4 ++--
 arch/blackfin/mm/init.c          |    4 ++--
 arch/c6x/mm/init.c               |    4 ++--
 arch/cris/mm/init.c              |    2 +-
 arch/frv/mm/init.c               |    4 ++--
 arch/h8300/mm/init.c             |    4 ++--
 arch/ia64/mm/init.c              |    2 +-
 arch/m32r/mm/init.c              |    4 ++--
 arch/m68k/mm/init.c              |    4 ++--
 arch/microblaze/mm/init.c        |    4 ++--
 arch/openrisc/mm/init.c          |    4 ++--
 arch/parisc/mm/init.c            |    4 ++--
 arch/powerpc/kernel/kvm.c        |    9 ++-------
 arch/powerpc/mm/mem.c            |    2 +-
 arch/s390/mm/init.c              |    2 +-
 arch/sh/mm/init.c                |    4 ++--
 arch/um/kernel/mem.c             |    2 +-
 arch/unicore32/mm/init.c         |    4 ++--
 arch/xtensa/mm/init.c            |    4 ++--
 include/linux/mm.h               |    7 ++++---
 mm/page_alloc.c                  |    2 +-
 26 files changed, 49 insertions(+), 53 deletions(-)

diff -puN arch/alpha/kernel/sys_nautilus.c~mm-enhance-free_reserved_area-to-support-poisoning-memory-with-zero arch/alpha/kernel/sys_nautilus.c
--- a/arch/alpha/kernel/sys_nautilus.c~mm-enhance-free_reserved_area-to-support-poisoning-memory-with-zero
+++ a/arch/alpha/kernel/sys_nautilus.c
@@ -239,7 +239,7 @@ nautilus_init_pci(void)
 		memtop = pci_mem;
 	if (memtop > alpha_mv.min_mem_address) {
 		free_reserved_area(__va(alpha_mv.min_mem_address),
-				   __va(memtop), 0, NULL);
+				   __va(memtop), -1, NULL);
 		printk("nautilus_init_pci: %ldk freed\n",
 			(memtop - alpha_mv.min_mem_address) >> 10);
 	}
diff -puN arch/alpha/mm/init.c~mm-enhance-free_reserved_area-to-support-poisoning-memory-with-zero arch/alpha/mm/init.c
--- a/arch/alpha/mm/init.c~mm-enhance-free_reserved_area-to-support-poisoning-memory-with-zero
+++ a/arch/alpha/mm/init.c
@@ -319,13 +319,13 @@ mem_init(void)
 void
 free_initmem(void)
 {
-	free_initmem_default(0);
+	free_initmem_default(-1);
 }
 
 #ifdef CONFIG_BLK_DEV_INITRD
 void
 free_initrd_mem(unsigned long start, unsigned long end)
 {
-	free_reserved_area((void *)start, (void *)end, 0, "initrd");
+	free_reserved_area((void *)start, (void *)end, -1, "initrd");
 }
 #endif
diff -puN arch/arc/mm/init.c~mm-enhance-free_reserved_area-to-support-poisoning-memory-with-zero arch/arc/mm/init.c
--- a/arch/arc/mm/init.c~mm-enhance-free_reserved_area-to-support-poisoning-memory-with-zero
+++ a/arch/arc/mm/init.c
@@ -146,13 +146,13 @@ void __init mem_init(void)
  */
 void __init_refok free_initmem(void)
 {
-	free_initmem_default(0);
+	free_initmem_default(-1);
 }
 
 #ifdef CONFIG_BLK_DEV_INITRD
 void __init free_initrd_mem(unsigned long start, unsigned long end)
 {
-	free_reserved_area((void *)start, (void *)end, 0, "initrd");
+	free_reserved_area((void *)start, (void *)end, -1, "initrd");
 }
 #endif
 
diff -puN arch/arm/mm/init.c~mm-enhance-free_reserved_area-to-support-poisoning-memory-with-zero arch/arm/mm/init.c
--- a/arch/arm/mm/init.c~mm-enhance-free_reserved_area-to-support-poisoning-memory-with-zero
+++ a/arch/arm/mm/init.c
@@ -601,7 +601,7 @@ void __init mem_init(void)
 
 #ifdef CONFIG_SA1111
 	/* now that our DMA memory is actually so designated, we can free it */
-	free_reserved_area(__va(PHYS_PFN_OFFSET), swapper_pg_dir, 0, NULL);
+	free_reserved_area(__va(PHYS_PFN_OFFSET), swapper_pg_dir, -1, NULL);
 #endif
 
 	free_highpages();
@@ -729,12 +729,12 @@ void free_initmem(void)
 	extern char __tcm_start, __tcm_end;
 
 	poison_init_mem(&__tcm_start, &__tcm_end - &__tcm_start);
-	free_reserved_area(&__tcm_start, &__tcm_end, 0, "TCM link");
+	free_reserved_area(&__tcm_start, &__tcm_end, -1, "TCM link");
 #endif
 
 	poison_init_mem(__init_begin, __init_end - __init_begin);
 	if (!machine_is_integrator() && !machine_is_cintegrator())
-		free_initmem_default(0);
+		free_initmem_default(-1);
 }
 
 #ifdef CONFIG_BLK_DEV_INITRD
@@ -745,7 +745,7 @@ void free_initrd_mem(unsigned long start
 {
 	if (!keep_initrd) {
 		poison_init_mem((void *)start, PAGE_ALIGN(end) - start);
-		free_reserved_area((void *)start, (void *)end, 0, "initrd");
+		free_reserved_area((void *)start, (void *)end, -1, "initrd");
 	}
 }
 
diff -puN arch/arm64/mm/init.c~mm-enhance-free_reserved_area-to-support-poisoning-memory-with-zero arch/arm64/mm/init.c
--- a/arch/arm64/mm/init.c~mm-enhance-free_reserved_area-to-support-poisoning-memory-with-zero
+++ a/arch/arm64/mm/init.c
@@ -387,7 +387,7 @@ void __init mem_init(void)
 void free_initmem(void)
 {
 	poison_init_mem(__init_begin, __init_end - __init_begin);
-	free_initmem_default(0);
+	free_initmem_default(-1);
 }
 
 #ifdef CONFIG_BLK_DEV_INITRD
@@ -398,7 +398,7 @@ void free_initrd_mem(unsigned long start
 {
 	if (!keep_initrd) {
 		poison_init_mem((void *)start, PAGE_ALIGN(end) - start);
-		free_reserved_area((void *)start, (void *)end, 0, "initrd");
+		free_reserved_area((void *)start, (void *)end, -1, "initrd");
 	}
 }
 
diff -puN arch/avr32/mm/init.c~mm-enhance-free_reserved_area-to-support-poisoning-memory-with-zero arch/avr32/mm/init.c
--- a/arch/avr32/mm/init.c~mm-enhance-free_reserved_area-to-support-poisoning-memory-with-zero
+++ a/arch/avr32/mm/init.c
@@ -148,12 +148,12 @@ void __init mem_init(void)
 
 void free_initmem(void)
 {
-	free_initmem_default(0);
+	free_initmem_default(-1);
 }
 
 #ifdef CONFIG_BLK_DEV_INITRD
 void free_initrd_mem(unsigned long start, unsigned long end)
 {
-	free_reserved_area((void *)start, (void *)end, 0, "initrd");
+	free_reserved_area((void *)start, (void *)end, -1, "initrd");
 }
 #endif
diff -puN arch/blackfin/mm/init.c~mm-enhance-free_reserved_area-to-support-poisoning-memory-with-zero arch/blackfin/mm/init.c
--- a/arch/blackfin/mm/init.c~mm-enhance-free_reserved_area-to-support-poisoning-memory-with-zero
+++ a/arch/blackfin/mm/init.c
@@ -133,7 +133,7 @@ void __init mem_init(void)
 void __init free_initrd_mem(unsigned long start, unsigned long end)
 {
 #ifndef CONFIG_MPU
-	free_reserved_area((void *)start, (void *)end, 0, "initrd");
+	free_reserved_area((void *)start, (void *)end, -1, "initrd");
 #endif
 }
 #endif
@@ -141,7 +141,7 @@ void __init free_initrd_mem(unsigned lon
 void __init_refok free_initmem(void)
 {
 #if defined CONFIG_RAMKERNEL && !defined CONFIG_MPU
-	free_initmem_default(0);
+	free_initmem_default(-1);
 	if (memory_start == (unsigned long)(&__init_end))
 		memory_start = (unsigned long)(&__init_begin);
 #endif
diff -puN arch/c6x/mm/init.c~mm-enhance-free_reserved_area-to-support-poisoning-memory-with-zero arch/c6x/mm/init.c
--- a/arch/c6x/mm/init.c~mm-enhance-free_reserved_area-to-support-poisoning-memory-with-zero
+++ a/arch/c6x/mm/init.c
@@ -78,11 +78,11 @@ void __init mem_init(void)
 #ifdef CONFIG_BLK_DEV_INITRD
 void __init free_initrd_mem(unsigned long start, unsigned long end)
 {
-	free_reserved_area((void *)start, (void *)end, 0, "initrd");
+	free_reserved_area((void *)start, (void *)end, -1, "initrd");
 }
 #endif
 
 void __init free_initmem(void)
 {
-	free_initmem_default(0);
+	free_initmem_default(-1);
 }
diff -puN arch/cris/mm/init.c~mm-enhance-free_reserved_area-to-support-poisoning-memory-with-zero arch/cris/mm/init.c
--- a/arch/cris/mm/init.c~mm-enhance-free_reserved_area-to-support-poisoning-memory-with-zero
+++ a/arch/cris/mm/init.c
@@ -65,5 +65,5 @@ mem_init(void)
 void 
 free_initmem(void)
 {
-	free_initmem_default(0);
+	free_initmem_default(-1);
 }
diff -puN arch/frv/mm/init.c~mm-enhance-free_reserved_area-to-support-poisoning-memory-with-zero arch/frv/mm/init.c
--- a/arch/frv/mm/init.c~mm-enhance-free_reserved_area-to-support-poisoning-memory-with-zero
+++ a/arch/frv/mm/init.c
@@ -162,7 +162,7 @@ void __init mem_init(void)
 void free_initmem(void)
 {
 #if defined(CONFIG_RAMKERNEL) && !defined(CONFIG_PROTECT_KERNEL)
-	free_initmem_default(0);
+	free_initmem_default(-1);
 #endif
 } /* end free_initmem() */
 
@@ -173,6 +173,6 @@ void free_initmem(void)
 #ifdef CONFIG_BLK_DEV_INITRD
 void __init free_initrd_mem(unsigned long start, unsigned long end)
 {
-	free_reserved_area((void *)start, (void *)end, 0, "initrd");
+	free_reserved_area((void *)start, (void *)end, -1, "initrd");
 } /* end free_initrd_mem() */
 #endif
diff -puN arch/h8300/mm/init.c~mm-enhance-free_reserved_area-to-support-poisoning-memory-with-zero arch/h8300/mm/init.c
--- a/arch/h8300/mm/init.c~mm-enhance-free_reserved_area-to-support-poisoning-memory-with-zero
+++ a/arch/h8300/mm/init.c
@@ -161,7 +161,7 @@ void __init mem_init(void)
 #ifdef CONFIG_BLK_DEV_INITRD
 void free_initrd_mem(unsigned long start, unsigned long end)
 {
-	free_reserved_area((void *)start, (void *)end, 0, "initrd");
+	free_reserved_area((void *)start, (void *)end, -1, "initrd");
 }
 #endif
 
@@ -169,7 +169,7 @@ void
 free_initmem(void)
 {
 #ifdef CONFIG_RAMKERNEL
-	free_initmem_default(0);
+	free_initmem_default(-1);
 #endif
 }
 
diff -puN arch/ia64/mm/init.c~mm-enhance-free_reserved_area-to-support-poisoning-memory-with-zero arch/ia64/mm/init.c
--- a/arch/ia64/mm/init.c~mm-enhance-free_reserved_area-to-support-poisoning-memory-with-zero
+++ a/arch/ia64/mm/init.c
@@ -155,7 +155,7 @@ void
 free_initmem (void)
 {
 	free_reserved_area(ia64_imva(__init_begin), ia64_imva(__init_end),
-			   0, "unused kernel");
+			   -1, "unused kernel");
 }
 
 void __init
diff -puN arch/m32r/mm/init.c~mm-enhance-free_reserved_area-to-support-poisoning-memory-with-zero arch/m32r/mm/init.c
--- a/arch/m32r/mm/init.c~mm-enhance-free_reserved_area-to-support-poisoning-memory-with-zero
+++ a/arch/m32r/mm/init.c
@@ -181,7 +181,7 @@ void __init mem_init(void)
  *======================================================================*/
 void free_initmem(void)
 {
-	free_initmem_default(0);
+	free_initmem_default(-1);
 }
 
 #ifdef CONFIG_BLK_DEV_INITRD
@@ -191,6 +191,6 @@ void free_initmem(void)
  *======================================================================*/
 void free_initrd_mem(unsigned long start, unsigned long end)
 {
-	free_reserved_area((void *)start, (void *)end, 0, "initrd");
+	free_reserved_area((void *)start, (void *)end, -1, "initrd");
 }
 #endif
diff -puN arch/m68k/mm/init.c~mm-enhance-free_reserved_area-to-support-poisoning-memory-with-zero arch/m68k/mm/init.c
--- a/arch/m68k/mm/init.c~mm-enhance-free_reserved_area-to-support-poisoning-memory-with-zero
+++ a/arch/m68k/mm/init.c
@@ -110,7 +110,7 @@ void __init paging_init(void)
 void free_initmem(void)
 {
 #ifndef CONFIG_MMU_SUN3
-	free_initmem_default(0);
+	free_initmem_default(-1);
 #endif /* CONFIG_MMU_SUN3 */
 }
 
@@ -202,6 +202,6 @@ void __init mem_init(void)
 #ifdef CONFIG_BLK_DEV_INITRD
 void free_initrd_mem(unsigned long start, unsigned long end)
 {
-	free_reserved_area((void *)start, (void *)end, 0, "initrd");
+	free_reserved_area((void *)start, (void *)end, -1, "initrd");
 }
 #endif
diff -puN arch/microblaze/mm/init.c~mm-enhance-free_reserved_area-to-support-poisoning-memory-with-zero arch/microblaze/mm/init.c
--- a/arch/microblaze/mm/init.c~mm-enhance-free_reserved_area-to-support-poisoning-memory-with-zero
+++ a/arch/microblaze/mm/init.c
@@ -235,13 +235,13 @@ void __init setup_memory(void)
 #ifdef CONFIG_BLK_DEV_INITRD
 void free_initrd_mem(unsigned long start, unsigned long end)
 {
-	free_reserved_area((void *)start, (void *)end, 0, "initrd");
+	free_reserved_area((void *)start, (void *)end, -1, "initrd");
 }
 #endif
 
 void free_initmem(void)
 {
-	free_initmem_default(0);
+	free_initmem_default(-1);
 }
 
 void __init mem_init(void)
diff -puN arch/openrisc/mm/init.c~mm-enhance-free_reserved_area-to-support-poisoning-memory-with-zero arch/openrisc/mm/init.c
--- a/arch/openrisc/mm/init.c~mm-enhance-free_reserved_area-to-support-poisoning-memory-with-zero
+++ a/arch/openrisc/mm/init.c
@@ -261,11 +261,11 @@ void __init mem_init(void)
 #ifdef CONFIG_BLK_DEV_INITRD
 void free_initrd_mem(unsigned long start, unsigned long end)
 {
-	free_reserved_area((void *)start, (void *)end, 0, "initrd");
+	free_reserved_area((void *)start, (void *)end, -1, "initrd");
 }
 #endif
 
 void free_initmem(void)
 {
-	free_initmem_default(0);
+	free_initmem_default(-1);
 }
diff -puN arch/parisc/mm/init.c~mm-enhance-free_reserved_area-to-support-poisoning-memory-with-zero arch/parisc/mm/init.c
--- a/arch/parisc/mm/init.c~mm-enhance-free_reserved_area-to-support-poisoning-memory-with-zero
+++ a/arch/parisc/mm/init.c
@@ -532,7 +532,7 @@ void free_initmem(void)
 	 * pages are no-longer executable */
 	flush_icache_range(init_begin, init_end);
 	
-	num_physpages += free_initmem_default(0);
+	num_physpages += free_initmem_default(-1);
 
 	/* set up a new led state on systems shipped LED State panel */
 	pdc_chassis_send_status(PDC_CHASSIS_DIRECT_BCOMPLETE);
@@ -1101,7 +1101,7 @@ void flush_tlb_all(void)
 #ifdef CONFIG_BLK_DEV_INITRD
 void free_initrd_mem(unsigned long start, unsigned long end)
 {
-	num_physpages += free_reserved_area((void *)start, (void *)end, 0,
+	num_physpages += free_reserved_area((void *)start, (void *)end, -1,
 					    "initrd");
 }
 #endif
diff -puN arch/powerpc/kernel/kvm.c~mm-enhance-free_reserved_area-to-support-poisoning-memory-with-zero arch/powerpc/kernel/kvm.c
--- a/arch/powerpc/kernel/kvm.c~mm-enhance-free_reserved_area-to-support-poisoning-memory-with-zero
+++ a/arch/powerpc/kernel/kvm.c
@@ -750,13 +750,8 @@ EXPORT_SYMBOL_GPL(kvm_hypercall);
 
 static __init void kvm_free_tmp(void)
 {
-	unsigned long start, end;
-
-	start = (ulong)&kvm_tmp[kvm_tmp_index + (PAGE_SIZE - 1)] & PAGE_MASK;
-	end = (ulong)&kvm_tmp[ARRAY_SIZE(kvm_tmp)] & PAGE_MASK;
-
-	/* Free the tmp space we don't need */
-	free_reserved_area((void *)start, (void *)end, 0, NULL);
+	free_reserved_area(&kvm_tmp[kvm_tmp_index],
+			   &kvm_tmp[ARRAY_SIZE(kvm_tmp)], -1, NULL);
 }
 
 static int __init kvm_guest_init(void)
diff -puN arch/powerpc/mm/mem.c~mm-enhance-free_reserved_area-to-support-poisoning-memory-with-zero arch/powerpc/mm/mem.c
--- a/arch/powerpc/mm/mem.c~mm-enhance-free_reserved_area-to-support-poisoning-memory-with-zero
+++ a/arch/powerpc/mm/mem.c
@@ -407,7 +407,7 @@ void free_initmem(void)
 #ifdef CONFIG_BLK_DEV_INITRD
 void __init free_initrd_mem(unsigned long start, unsigned long end)
 {
-	free_reserved_area((void *)start, (void *)end, 0, "initrd");
+	free_reserved_area((void *)start, (void *)end, -1, "initrd");
 }
 #endif
 
diff -puN arch/s390/mm/init.c~mm-enhance-free_reserved_area-to-support-poisoning-memory-with-zero arch/s390/mm/init.c
--- a/arch/s390/mm/init.c~mm-enhance-free_reserved_area-to-support-poisoning-memory-with-zero
+++ a/arch/s390/mm/init.c
@@ -166,7 +166,7 @@ void __init mem_init(void)
 
 void free_initmem(void)
 {
-	free_initmem_default(0);
+	free_initmem_default(POISON_FREE_INITMEM);
 }
 
 #ifdef CONFIG_BLK_DEV_INITRD
diff -puN arch/sh/mm/init.c~mm-enhance-free_reserved_area-to-support-poisoning-memory-with-zero arch/sh/mm/init.c
--- a/arch/sh/mm/init.c~mm-enhance-free_reserved_area-to-support-poisoning-memory-with-zero
+++ a/arch/sh/mm/init.c
@@ -499,13 +499,13 @@ void __init mem_init(void)
 
 void free_initmem(void)
 {
-	free_initmem_default(0);
+	free_initmem_default(-1);
 }
 
 #ifdef CONFIG_BLK_DEV_INITRD
 void free_initrd_mem(unsigned long start, unsigned long end)
 {
-	free_reserved_area((void *)start, (void *)end, 0, "initrd");
+	free_reserved_area((void *)start, (void *)end, -1, "initrd");
 }
 #endif
 
diff -puN arch/um/kernel/mem.c~mm-enhance-free_reserved_area-to-support-poisoning-memory-with-zero arch/um/kernel/mem.c
--- a/arch/um/kernel/mem.c~mm-enhance-free_reserved_area-to-support-poisoning-memory-with-zero
+++ a/arch/um/kernel/mem.c
@@ -244,7 +244,7 @@ void free_initmem(void)
 #ifdef CONFIG_BLK_DEV_INITRD
 void free_initrd_mem(unsigned long start, unsigned long end)
 {
-	free_reserved_area((void *)start, (void *)end, 0, "initrd");
+	free_reserved_area((void *)start, (void *)end, -1, "initrd");
 }
 #endif
 
diff -puN arch/unicore32/mm/init.c~mm-enhance-free_reserved_area-to-support-poisoning-memory-with-zero arch/unicore32/mm/init.c
--- a/arch/unicore32/mm/init.c~mm-enhance-free_reserved_area-to-support-poisoning-memory-with-zero
+++ a/arch/unicore32/mm/init.c
@@ -476,7 +476,7 @@ void __init mem_init(void)
 
 void free_initmem(void)
 {
-	free_initmem_default(0);
+	free_initmem_default(-1);
 }
 
 #ifdef CONFIG_BLK_DEV_INITRD
@@ -486,7 +486,7 @@ static int keep_initrd;
 void free_initrd_mem(unsigned long start, unsigned long end)
 {
 	if (!keep_initrd)
-		free_reserved_area((void *)start, (void *)end, 0, "initrd");
+		free_reserved_area((void *)start, (void *)end, -1, "initrd");
 }
 
 static int __init keepinitrd_setup(char *__unused)
diff -puN arch/xtensa/mm/init.c~mm-enhance-free_reserved_area-to-support-poisoning-memory-with-zero arch/xtensa/mm/init.c
--- a/arch/xtensa/mm/init.c~mm-enhance-free_reserved_area-to-support-poisoning-memory-with-zero
+++ a/arch/xtensa/mm/init.c
@@ -214,11 +214,11 @@ extern int initrd_is_mapped;
 void free_initrd_mem(unsigned long start, unsigned long end)
 {
 	if (initrd_is_mapped)
-		free_reserved_area((void *)start, (void *)end, 0, "initrd");
+		free_reserved_area((void *)start, (void *)end, -1, "initrd");
 }
 #endif
 
 void free_initmem(void)
 {
-	free_initmem_default(0);
+	free_initmem_default(-1);
 }
diff -puN include/linux/mm.h~mm-enhance-free_reserved_area-to-support-poisoning-memory-with-zero include/linux/mm.h
--- a/include/linux/mm.h~mm-enhance-free_reserved_area-to-support-poisoning-memory-with-zero
+++ a/include/linux/mm.h
@@ -1308,7 +1308,7 @@ extern void free_initmem(void);
 /*
  * Free reserved pages within range [PAGE_ALIGN(start), end & PAGE_MASK)
  * into the buddy system. The freed pages will be poisoned with pattern
- * "poison" if it's non-zero.
+ * "poison" if it's within range [0, UCHAR_MAX].
  * Return pages freed into the buddy system.
  */
 extern unsigned long free_reserved_area(void *start, void *end,
@@ -1348,8 +1348,9 @@ static inline void mark_page_reserved(st
 
 /*
  * Default method to free all the __init memory into the buddy system.
- * The freed pages will be poisoned with pattern "poison" if it is
- * non-zero. Return pages freed into the buddy system.
+ * The freed pages will be poisoned with pattern "poison" if it's within
+ * range [0, UCHAR_MAX].
+ * Return pages freed into the buddy system.
  */
 static inline unsigned long free_initmem_default(int poison)
 {
diff -puN mm/page_alloc.c~mm-enhance-free_reserved_area-to-support-poisoning-memory-with-zero mm/page_alloc.c
--- a/mm/page_alloc.c~mm-enhance-free_reserved_area-to-support-poisoning-memory-with-zero
+++ a/mm/page_alloc.c
@@ -5214,7 +5214,7 @@ unsigned long free_reserved_area(void *s
 	start = (void *)PAGE_ALIGN((unsigned long)start);
 	end = (void *)((unsigned long)end & PAGE_MASK);
 	for (pos = start; pos < end; pos += PAGE_SIZE, pages++) {
-		if (poison)
+		if ((unsigned int)poison <= 0xFF)
 			memset(pos, poison, PAGE_SIZE);
 		free_reserved_page(virt_to_page(pos));
 	}
_

Patches currently in -mm which might be from liuj97@gmail.com are

origin.patch
linux-next.patch

