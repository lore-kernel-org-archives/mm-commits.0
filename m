From: akpm@linux-foundation.org
Subject: +
 mm-change-signature-of-free_reserved_area-to-fix-building-warnings.patch
 added to -mm tree
Date: Thu, 30 May 2013 15:16:49 -0700
Message-ID: <51a7cfd1.SllBG2ZiV/xfeTBv%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60319 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759027Ab3E3WQv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 30 May 2013 18:16:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, yinghai@kernel.org, wujianguo@huawei.com, will.deacon@arm.com, wency@cn.fujitsu.com, walken@google.com, tj@kernel.org, tglx@linutronix.de, tangchen@cn.fujitsu.com, sworddragon2@aol.com, rusty@rustcorp.com.au, rmk@arm.linux.org.uk, riel@redhat.com, mst@redhat.com, mingo@redhat.com, minchan@kernel.org, mel@csn.ul.ie, m.szyprowski@samsung.com, konrad.wilk@oracle.com, kamezawa.hiroyu@jp.fujitsu.com, js1304@gmail.com, jiang.liu@huawei.com, jeremy@goop.org, isimatu.yasuaki@jp.fujitsu.com, hpa@zytor.com, geert@linux-m68k.org, dhowells@redhat.com, cmetcalf@tilera.com, catalin.marinas@arm.com, arnd@arndb.de, liuj97@gmail.com

Subject: + mm-change-signature-of-free_reserved_area-to-fix-building-warnings.patch added to -mm tree
To: liuj97@gmail.com,arnd@arndb.de,catalin.marinas@arm.com,cmetcalf@tilera.com,dhowells@redhat.com,geert@linux-m68k.org,hpa@zytor.com,isimatu.yasuaki@jp.fujitsu.com,jeremy@goop.org,jiang.liu@huawei.com,js1304@gmail.com,kamezawa.hiroyu@jp.fujitsu.com,konrad.wilk@oracle.com,m.szyprowski@samsung.com,mel@csn.ul.ie,minchan@kernel.org,mingo@redhat.com,mst@redhat.com,riel@redhat.com,rmk@arm.linux.org.uk,rusty@rustcorp.com.au,sworddragon2@aol.com,tangchen@cn.fujitsu.com,tglx@linutronix.de,tj@kernel.org,walken@google.com,wency@cn.fujitsu.com,will.deacon@arm.com,wujianguo@huawei.com,yinghai@kernel.org
From: akpm@linux-foundation.org
Date: Thu, 30 May 2013 15:16:49 -0700


The patch titled
     Subject: mm: change signature of free_reserved_area() to fix building warnings
has been added to the -mm tree.  Its filename is
     mm-change-signature-of-free_reserved_area-to-fix-building-warnings.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Jiang Liu <liuj97@gmail.com>
Subject: mm: change signature of free_reserved_area() to fix building warnings

Change signature of free_reserved_area() according to Russell King's
suggestion to fix following build warnings:

arch/arm/mm/init.c: In function 'mem_init':
arch/arm/mm/init.c:603:2: warning: passing argument 1 of 'free_reserved_area' makes integer from pointer without a cast [enabled by default]
  free_reserved_area(__va(PHYS_PFN_OFFSET), swapper_pg_dir, 0, NULL);
  ^
In file included from include/linux/mman.h:4:0,
                 from arch/arm/mm/init.c:15:
include/linux/mm.h:1301:22: note: expected 'long unsigned int' but argument is of type 'void *'
 extern unsigned long free_reserved_area(unsigned long start, unsigned long end,

   mm/page_alloc.c: In function 'free_reserved_area':
>> mm/page_alloc.c:5134:3: warning: passing argument 1 of 'virt_to_phys' makes pointer from integer without a cast [enabled by default]
   In file included from arch/mips/include/asm/page.h:49:0,
                    from include/linux/mmzone.h:20,
                    from include/linux/gfp.h:4,
                    from include/linux/mm.h:8,
                    from mm/page_alloc.c:18:
   arch/mips/include/asm/io.h:119:29: note: expected 'const volatile void *' but argument is of type 'long unsigned int'
   mm/page_alloc.c: In function 'free_area_init_nodes':
   mm/page_alloc.c:5030:34: warning: array subscript is below array bounds [-Warray-bounds]

Also address some minor code review comments.

Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
Reported-by: Arnd Bergmann <arnd@arndb.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>
Cc: <sworddragon2@aol.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Chris Metcalf <cmetcalf@tilera.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
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

 arch/alpha/kernel/sys_nautilus.c |    4 ++--
 arch/alpha/mm/init.c             |    2 +-
 arch/arc/mm/init.c               |    2 +-
 arch/arm/mm/init.c               |    2 +-
 arch/arm64/mm/init.c             |    2 +-
 arch/avr32/mm/init.c             |    2 +-
 arch/blackfin/mm/init.c          |    2 +-
 arch/c6x/mm/init.c               |    2 +-
 arch/frv/mm/init.c               |    2 +-
 arch/h8300/mm/init.c             |    2 +-
 arch/ia64/mm/init.c              |    3 +--
 arch/m32r/mm/init.c              |    2 +-
 arch/m68k/mm/init.c              |    2 +-
 arch/metag/mm/init.c             |    3 ++-
 arch/microblaze/mm/init.c        |    2 +-
 arch/mips/mm/init.c              |    3 ++-
 arch/mn10300/mm/init.c           |    3 ++-
 arch/openrisc/mm/init.c          |    2 +-
 arch/parisc/mm/init.c            |    3 ++-
 arch/powerpc/kernel/kvm.c        |    2 +-
 arch/powerpc/mm/mem.c            |    2 +-
 arch/s390/mm/init.c              |    3 ++-
 arch/score/mm/init.c             |    3 ++-
 arch/sh/mm/init.c                |    2 +-
 arch/sparc/mm/init_32.c          |    4 ++--
 arch/sparc/mm/init_64.c          |    4 ++--
 arch/um/kernel/mem.c             |    2 +-
 arch/unicore32/mm/init.c         |    2 +-
 arch/xtensa/mm/init.c            |    2 +-
 include/linux/mm.h               |    5 ++---
 mm/page_alloc.c                  |   19 ++++++++++---------
 31 files changed, 50 insertions(+), 45 deletions(-)

diff -puN arch/alpha/kernel/sys_nautilus.c~mm-change-signature-of-free_reserved_area-to-fix-building-warnings arch/alpha/kernel/sys_nautilus.c
--- a/arch/alpha/kernel/sys_nautilus.c~mm-change-signature-of-free_reserved_area-to-fix-building-warnings
+++ a/arch/alpha/kernel/sys_nautilus.c
@@ -238,8 +238,8 @@ nautilus_init_pci(void)
 	if (pci_mem < memtop)
 		memtop = pci_mem;
 	if (memtop > alpha_mv.min_mem_address) {
-		free_reserved_area((unsigned long)__va(alpha_mv.min_mem_address),
-				   (unsigned long)__va(memtop), 0, NULL);
+		free_reserved_area(__va(alpha_mv.min_mem_address),
+				   __va(memtop), 0, NULL);
 		printk("nautilus_init_pci: %ldk freed\n",
 			(memtop - alpha_mv.min_mem_address) >> 10);
 	}
diff -puN arch/alpha/mm/init.c~mm-change-signature-of-free_reserved_area-to-fix-building-warnings arch/alpha/mm/init.c
--- a/arch/alpha/mm/init.c~mm-change-signature-of-free_reserved_area-to-fix-building-warnings
+++ a/arch/alpha/mm/init.c
@@ -326,6 +326,6 @@ free_initmem(void)
 void
 free_initrd_mem(unsigned long start, unsigned long end)
 {
-	free_reserved_area(start, end, 0, "initrd");
+	free_reserved_area((void *)start, (void *)end, 0, "initrd");
 }
 #endif
diff -puN arch/arc/mm/init.c~mm-change-signature-of-free_reserved_area-to-fix-building-warnings arch/arc/mm/init.c
--- a/arch/arc/mm/init.c~mm-change-signature-of-free_reserved_area-to-fix-building-warnings
+++ a/arch/arc/mm/init.c
@@ -152,7 +152,7 @@ void __init_refok free_initmem(void)
 #ifdef CONFIG_BLK_DEV_INITRD
 void __init free_initrd_mem(unsigned long start, unsigned long end)
 {
-	free_reserved_area(start, end, 0, "initrd");
+	free_reserved_area((void *)start, (void *)end, 0, "initrd");
 }
 #endif
 
diff -puN arch/arm/mm/init.c~mm-change-signature-of-free_reserved_area-to-fix-building-warnings arch/arm/mm/init.c
--- a/arch/arm/mm/init.c~mm-change-signature-of-free_reserved_area-to-fix-building-warnings
+++ a/arch/arm/mm/init.c
@@ -744,7 +744,7 @@ void free_initrd_mem(unsigned long start
 {
 	if (!keep_initrd) {
 		poison_init_mem((void *)start, PAGE_ALIGN(end) - start);
-		free_reserved_area(start, end, 0, "initrd");
+		free_reserved_area((void *)start, (void *)end, 0, "initrd");
 	}
 }
 
diff -puN arch/arm64/mm/init.c~mm-change-signature-of-free_reserved_area-to-fix-building-warnings arch/arm64/mm/init.c
--- a/arch/arm64/mm/init.c~mm-change-signature-of-free_reserved_area-to-fix-building-warnings
+++ a/arch/arm64/mm/init.c
@@ -398,7 +398,7 @@ void free_initrd_mem(unsigned long start
 {
 	if (!keep_initrd) {
 		poison_init_mem((void *)start, PAGE_ALIGN(end) - start);
-		free_reserved_area(start, end, 0, "initrd");
+		free_reserved_area((void *)start, (void *)end, 0, "initrd");
 	}
 }
 
diff -puN arch/avr32/mm/init.c~mm-change-signature-of-free_reserved_area-to-fix-building-warnings arch/avr32/mm/init.c
--- a/arch/avr32/mm/init.c~mm-change-signature-of-free_reserved_area-to-fix-building-warnings
+++ a/arch/avr32/mm/init.c
@@ -154,6 +154,6 @@ void free_initmem(void)
 #ifdef CONFIG_BLK_DEV_INITRD
 void free_initrd_mem(unsigned long start, unsigned long end)
 {
-	free_reserved_area(start, end, 0, "initrd");
+	free_reserved_area((void *)start, (void *)end, 0, "initrd");
 }
 #endif
diff -puN arch/blackfin/mm/init.c~mm-change-signature-of-free_reserved_area-to-fix-building-warnings arch/blackfin/mm/init.c
--- a/arch/blackfin/mm/init.c~mm-change-signature-of-free_reserved_area-to-fix-building-warnings
+++ a/arch/blackfin/mm/init.c
@@ -133,7 +133,7 @@ void __init mem_init(void)
 void __init free_initrd_mem(unsigned long start, unsigned long end)
 {
 #ifndef CONFIG_MPU
-	free_reserved_area(start, end, 0, "initrd");
+	free_reserved_area((void *)start, (void *)end, 0, "initrd");
 #endif
 }
 #endif
diff -puN arch/c6x/mm/init.c~mm-change-signature-of-free_reserved_area-to-fix-building-warnings arch/c6x/mm/init.c
--- a/arch/c6x/mm/init.c~mm-change-signature-of-free_reserved_area-to-fix-building-warnings
+++ a/arch/c6x/mm/init.c
@@ -77,7 +77,7 @@ void __init mem_init(void)
 #ifdef CONFIG_BLK_DEV_INITRD
 void __init free_initrd_mem(unsigned long start, unsigned long end)
 {
-	free_reserved_area(start, end, 0, "initrd");
+	free_reserved_area((void *)start, (void *)end, 0, "initrd");
 }
 #endif
 
diff -puN arch/frv/mm/init.c~mm-change-signature-of-free_reserved_area-to-fix-building-warnings arch/frv/mm/init.c
--- a/arch/frv/mm/init.c~mm-change-signature-of-free_reserved_area-to-fix-building-warnings
+++ a/arch/frv/mm/init.c
@@ -173,6 +173,6 @@ void free_initmem(void)
 #ifdef CONFIG_BLK_DEV_INITRD
 void __init free_initrd_mem(unsigned long start, unsigned long end)
 {
-	free_reserved_area(start, end, 0, "initrd");
+	free_reserved_area((void *)start, (void *)end, 0, "initrd");
 } /* end free_initrd_mem() */
 #endif
diff -puN arch/h8300/mm/init.c~mm-change-signature-of-free_reserved_area-to-fix-building-warnings arch/h8300/mm/init.c
--- a/arch/h8300/mm/init.c~mm-change-signature-of-free_reserved_area-to-fix-building-warnings
+++ a/arch/h8300/mm/init.c
@@ -161,7 +161,7 @@ void __init mem_init(void)
 #ifdef CONFIG_BLK_DEV_INITRD
 void free_initrd_mem(unsigned long start, unsigned long end)
 {
-	free_reserved_area(start, end, 0, "initrd");
+	free_reserved_area((void *)start, (void *)end, 0, "initrd");
 }
 #endif
 
diff -puN arch/ia64/mm/init.c~mm-change-signature-of-free_reserved_area-to-fix-building-warnings arch/ia64/mm/init.c
--- a/arch/ia64/mm/init.c~mm-change-signature-of-free_reserved_area-to-fix-building-warnings
+++ a/arch/ia64/mm/init.c
@@ -154,8 +154,7 @@ ia64_init_addr_space (void)
 void
 free_initmem (void)
 {
-	free_reserved_area((unsigned long)ia64_imva(__init_begin),
-			   (unsigned long)ia64_imva(__init_end),
+	free_reserved_area(ia64_imva(__init_begin), ia64_imva(__init_end),
 			   0, "unused kernel");
 }
 
diff -puN arch/m32r/mm/init.c~mm-change-signature-of-free_reserved_area-to-fix-building-warnings arch/m32r/mm/init.c
--- a/arch/m32r/mm/init.c~mm-change-signature-of-free_reserved_area-to-fix-building-warnings
+++ a/arch/m32r/mm/init.c
@@ -191,6 +191,6 @@ void free_initmem(void)
  *======================================================================*/
 void free_initrd_mem(unsigned long start, unsigned long end)
 {
-	free_reserved_area(start, end, 0, "initrd");
+	free_reserved_area((void *)start, (void *)end, 0, "initrd");
 }
 #endif
diff -puN arch/m68k/mm/init.c~mm-change-signature-of-free_reserved_area-to-fix-building-warnings arch/m68k/mm/init.c
--- a/arch/m68k/mm/init.c~mm-change-signature-of-free_reserved_area-to-fix-building-warnings
+++ a/arch/m68k/mm/init.c
@@ -202,6 +202,6 @@ void __init mem_init(void)
 #ifdef CONFIG_BLK_DEV_INITRD
 void free_initrd_mem(unsigned long start, unsigned long end)
 {
-	free_reserved_area(start, end, 0, "initrd");
+	free_reserved_area((void *)start, (void *)end, 0, "initrd");
 }
 #endif
diff -puN arch/metag/mm/init.c~mm-change-signature-of-free_reserved_area-to-fix-building-warnings arch/metag/mm/init.c
--- a/arch/metag/mm/init.c~mm-change-signature-of-free_reserved_area-to-fix-building-warnings
+++ a/arch/metag/mm/init.c
@@ -414,7 +414,8 @@ void free_initmem(void)
 #ifdef CONFIG_BLK_DEV_INITRD
 void free_initrd_mem(unsigned long start, unsigned long end)
 {
-	free_reserved_area(start, end, POISON_FREE_INITMEM, "initrd");
+	free_reserved_area((void *)start, (void *)end, POISON_FREE_INITMEM,
+			   "initrd");
 }
 #endif
 
diff -puN arch/microblaze/mm/init.c~mm-change-signature-of-free_reserved_area-to-fix-building-warnings arch/microblaze/mm/init.c
--- a/arch/microblaze/mm/init.c~mm-change-signature-of-free_reserved_area-to-fix-building-warnings
+++ a/arch/microblaze/mm/init.c
@@ -235,7 +235,7 @@ void __init setup_memory(void)
 #ifdef CONFIG_BLK_DEV_INITRD
 void free_initrd_mem(unsigned long start, unsigned long end)
 {
-	free_reserved_area(start, end, 0, "initrd");
+	free_reserved_area((void *)start, (void *)end, 0, "initrd");
 }
 #endif
 
diff -puN arch/mips/mm/init.c~mm-change-signature-of-free_reserved_area-to-fix-building-warnings arch/mips/mm/init.c
--- a/arch/mips/mm/init.c~mm-change-signature-of-free_reserved_area-to-fix-building-warnings
+++ a/arch/mips/mm/init.c
@@ -440,7 +440,8 @@ void free_init_pages(const char *what, u
 #ifdef CONFIG_BLK_DEV_INITRD
 void free_initrd_mem(unsigned long start, unsigned long end)
 {
-	free_reserved_area(start, end, POISON_FREE_INITMEM, "initrd");
+	free_reserved_area((void *)start, (void *)end, POISON_FREE_INITMEM,
+			   "initrd");
 }
 #endif
 
diff -puN arch/mn10300/mm/init.c~mm-change-signature-of-free_reserved_area-to-fix-building-warnings arch/mn10300/mm/init.c
--- a/arch/mn10300/mm/init.c~mm-change-signature-of-free_reserved_area-to-fix-building-warnings
+++ a/arch/mn10300/mm/init.c
@@ -152,6 +152,7 @@ void free_initmem(void)
 #ifdef CONFIG_BLK_DEV_INITRD
 void free_initrd_mem(unsigned long start, unsigned long end)
 {
-	free_reserved_area(start, end, POISON_FREE_INITMEM, "initrd");
+	free_reserved_area((void *)start, (void *)end, POISON_FREE_INITMEM,
+			   "initrd");
 }
 #endif
diff -puN arch/openrisc/mm/init.c~mm-change-signature-of-free_reserved_area-to-fix-building-warnings arch/openrisc/mm/init.c
--- a/arch/openrisc/mm/init.c~mm-change-signature-of-free_reserved_area-to-fix-building-warnings
+++ a/arch/openrisc/mm/init.c
@@ -261,7 +261,7 @@ void __init mem_init(void)
 #ifdef CONFIG_BLK_DEV_INITRD
 void free_initrd_mem(unsigned long start, unsigned long end)
 {
-	free_reserved_area(start, end, 0, "initrd");
+	free_reserved_area((void *)start, (void *)end, 0, "initrd");
 }
 #endif
 
diff -puN arch/parisc/mm/init.c~mm-change-signature-of-free_reserved_area-to-fix-building-warnings arch/parisc/mm/init.c
--- a/arch/parisc/mm/init.c~mm-change-signature-of-free_reserved_area-to-fix-building-warnings
+++ a/arch/parisc/mm/init.c
@@ -1101,6 +1101,7 @@ void flush_tlb_all(void)
 #ifdef CONFIG_BLK_DEV_INITRD
 void free_initrd_mem(unsigned long start, unsigned long end)
 {
-	num_physpages += free_reserved_area(start, end, 0, "initrd");
+	num_physpages += free_reserved_area((void *)start, (void *)end, 0,
+					    "initrd");
 }
 #endif
diff -puN arch/powerpc/kernel/kvm.c~mm-change-signature-of-free_reserved_area-to-fix-building-warnings arch/powerpc/kernel/kvm.c
--- a/arch/powerpc/kernel/kvm.c~mm-change-signature-of-free_reserved_area-to-fix-building-warnings
+++ a/arch/powerpc/kernel/kvm.c
@@ -756,7 +756,7 @@ static __init void kvm_free_tmp(void)
 	end = (ulong)&kvm_tmp[ARRAY_SIZE(kvm_tmp)] & PAGE_MASK;
 
 	/* Free the tmp space we don't need */
-	free_reserved_area(start, end, 0, NULL);
+	free_reserved_area((void *)start, (void *)end, 0, NULL);
 }
 
 static int __init kvm_guest_init(void)
diff -puN arch/powerpc/mm/mem.c~mm-change-signature-of-free_reserved_area-to-fix-building-warnings arch/powerpc/mm/mem.c
--- a/arch/powerpc/mm/mem.c~mm-change-signature-of-free_reserved_area-to-fix-building-warnings
+++ a/arch/powerpc/mm/mem.c
@@ -407,7 +407,7 @@ void free_initmem(void)
 #ifdef CONFIG_BLK_DEV_INITRD
 void __init free_initrd_mem(unsigned long start, unsigned long end)
 {
-	free_reserved_area(start, end, 0, "initrd");
+	free_reserved_area((void *)start, (void *)end, 0, "initrd");
 }
 #endif
 
diff -puN arch/s390/mm/init.c~mm-change-signature-of-free_reserved_area-to-fix-building-warnings arch/s390/mm/init.c
--- a/arch/s390/mm/init.c~mm-change-signature-of-free_reserved_area-to-fix-building-warnings
+++ a/arch/s390/mm/init.c
@@ -172,7 +172,8 @@ void free_initmem(void)
 #ifdef CONFIG_BLK_DEV_INITRD
 void __init free_initrd_mem(unsigned long start, unsigned long end)
 {
-	free_reserved_area(start, end, POISON_FREE_INITMEM, "initrd");
+	free_reserved_area((void *)start, (void *)end, POISON_FREE_INITMEM,
+			   "initrd");
 }
 #endif
 
diff -puN arch/score/mm/init.c~mm-change-signature-of-free_reserved_area-to-fix-building-warnings arch/score/mm/init.c
--- a/arch/score/mm/init.c~mm-change-signature-of-free_reserved_area-to-fix-building-warnings
+++ a/arch/score/mm/init.c
@@ -108,7 +108,8 @@ void __init mem_init(void)
 #ifdef CONFIG_BLK_DEV_INITRD
 void free_initrd_mem(unsigned long start, unsigned long end)
 {
-	free_reserved_area(start, end, POISON_FREE_INITMEM, "initrd");
+	free_reserved_area((void *)start, (void *)end, POISON_FREE_INITMEM,
+			   "initrd");
 }
 #endif
 
diff -puN arch/sh/mm/init.c~mm-change-signature-of-free_reserved_area-to-fix-building-warnings arch/sh/mm/init.c
--- a/arch/sh/mm/init.c~mm-change-signature-of-free_reserved_area-to-fix-building-warnings
+++ a/arch/sh/mm/init.c
@@ -505,7 +505,7 @@ void free_initmem(void)
 #ifdef CONFIG_BLK_DEV_INITRD
 void free_initrd_mem(unsigned long start, unsigned long end)
 {
-	free_reserved_area(start, end, 0, "initrd");
+	free_reserved_area((void *)start, (void *)end, 0, "initrd");
 }
 #endif
 
diff -puN arch/sparc/mm/init_32.c~mm-change-signature-of-free_reserved_area-to-fix-building-warnings arch/sparc/mm/init_32.c
--- a/arch/sparc/mm/init_32.c~mm-change-signature-of-free_reserved_area-to-fix-building-warnings
+++ a/arch/sparc/mm/init_32.c
@@ -372,8 +372,8 @@ void free_initmem (void)
 #ifdef CONFIG_BLK_DEV_INITRD
 void free_initrd_mem(unsigned long start, unsigned long end)
 {
-	num_physpages += free_reserved_area(start, end, POISON_FREE_INITMEM,
-					    "initrd");
+	num_physpages += free_reserved_area((void *)start, (void *)end,
+					    POISON_FREE_INITMEM, "initrd");
 }
 #endif
 
diff -puN arch/sparc/mm/init_64.c~mm-change-signature-of-free_reserved_area-to-fix-building-warnings arch/sparc/mm/init_64.c
--- a/arch/sparc/mm/init_64.c~mm-change-signature-of-free_reserved_area-to-fix-building-warnings
+++ a/arch/sparc/mm/init_64.c
@@ -2124,8 +2124,8 @@ void free_initmem(void)
 #ifdef CONFIG_BLK_DEV_INITRD
 void free_initrd_mem(unsigned long start, unsigned long end)
 {
-	num_physpages += free_reserved_area(start, end, POISON_FREE_INITMEM,
-					    "initrd");
+	num_physpages += free_reserved_area((void *)start, (void *)end,
+					    POISON_FREE_INITMEM, "initrd");
 }
 #endif
 
diff -puN arch/um/kernel/mem.c~mm-change-signature-of-free_reserved_area-to-fix-building-warnings arch/um/kernel/mem.c
--- a/arch/um/kernel/mem.c~mm-change-signature-of-free_reserved_area-to-fix-building-warnings
+++ a/arch/um/kernel/mem.c
@@ -244,7 +244,7 @@ void free_initmem(void)
 #ifdef CONFIG_BLK_DEV_INITRD
 void free_initrd_mem(unsigned long start, unsigned long end)
 {
-	free_reserved_area(start, end, 0, "initrd");
+	free_reserved_area((void *)start, (void *)end, 0, "initrd");
 }
 #endif
 
diff -puN arch/unicore32/mm/init.c~mm-change-signature-of-free_reserved_area-to-fix-building-warnings arch/unicore32/mm/init.c
--- a/arch/unicore32/mm/init.c~mm-change-signature-of-free_reserved_area-to-fix-building-warnings
+++ a/arch/unicore32/mm/init.c
@@ -486,7 +486,7 @@ static int keep_initrd;
 void free_initrd_mem(unsigned long start, unsigned long end)
 {
 	if (!keep_initrd)
-		free_reserved_area(start, end, 0, "initrd");
+		free_reserved_area((void *)start, (void *)end, 0, "initrd");
 }
 
 static int __init keepinitrd_setup(char *__unused)
diff -puN arch/xtensa/mm/init.c~mm-change-signature-of-free_reserved_area-to-fix-building-warnings arch/xtensa/mm/init.c
--- a/arch/xtensa/mm/init.c~mm-change-signature-of-free_reserved_area-to-fix-building-warnings
+++ a/arch/xtensa/mm/init.c
@@ -214,7 +214,7 @@ extern int initrd_is_mapped;
 void free_initrd_mem(unsigned long start, unsigned long end)
 {
 	if (initrd_is_mapped)
-		free_reserved_area(start, end, 0, "initrd");
+		free_reserved_area((void *)start, (void *)end, 0, "initrd");
 }
 #endif
 
diff -puN include/linux/mm.h~mm-change-signature-of-free_reserved_area-to-fix-building-warnings include/linux/mm.h
--- a/include/linux/mm.h~mm-change-signature-of-free_reserved_area-to-fix-building-warnings
+++ a/include/linux/mm.h
@@ -1311,7 +1311,7 @@ extern void free_initmem(void);
  * "poison" if it's non-zero.
  * Return pages freed into the buddy system.
  */
-extern unsigned long free_reserved_area(unsigned long start, unsigned long end,
+extern unsigned long free_reserved_area(void *start, void *end,
 					int poison, char *s);
 #ifdef	CONFIG_HIGHMEM
 /*
@@ -1355,8 +1355,7 @@ static inline unsigned long free_initmem
 {
 	extern char __init_begin[], __init_end[];
 
-	return free_reserved_area(PAGE_ALIGN((unsigned long)&__init_begin) ,
-				  ((unsigned long)&__init_end) & PAGE_MASK,
+	return free_reserved_area(&__init_begin, &__init_end,
 				  poison, "unused kernel");
 }
 
diff -puN mm/page_alloc.c~mm-change-signature-of-free_reserved_area-to-fix-building-warnings mm/page_alloc.c
--- a/mm/page_alloc.c~mm-change-signature-of-free_reserved_area-to-fix-building-warnings
+++ a/mm/page_alloc.c
@@ -5218,25 +5218,26 @@ early_param("movablecore", cmdline_parse
 
 #endif /* CONFIG_HAVE_MEMBLOCK_NODE_MAP */
 
-unsigned long free_reserved_area(unsigned long start, unsigned long end,
-				 int poison, char *s)
+unsigned long free_reserved_area(void *start, void *end, int poison, char *s)
 {
-	unsigned long pages, pos;
+	void *pos;
+	unsigned long pages = 0;
 
-	pos = start = PAGE_ALIGN(start);
-	end &= PAGE_MASK;
-	for (pages = 0; pos < end; pos += PAGE_SIZE, pages++) {
+	start = (void *)PAGE_ALIGN((unsigned long)start);
+	end = (void *)((unsigned long)end & PAGE_MASK);
+	for (pos = start; pos < end; pos += PAGE_SIZE, pages++) {
 		if (poison)
-			memset((void *)pos, poison, PAGE_SIZE);
-		free_reserved_page(virt_to_page((void *)pos));
+			memset(pos, poison, PAGE_SIZE);
+		free_reserved_page(virt_to_page(pos));
 	}
 
 	if (pages && s)
-		pr_info("Freeing %s memory: %ldK (%lx - %lx)\n",
+		pr_info("Freeing %s memory: %ldK (%p - %p)\n",
 			s, pages << (PAGE_SHIFT - 10), start, end);
 
 	return pages;
 }
+EXPORT_SYMBOL(free_reserved_area);
 
 #ifdef	CONFIG_HIGHMEM
 void free_highmem_page(struct page *page)
_

Patches currently in -mm which might be from liuj97@gmail.com are

linux-next.patch
mm-change-signature-of-free_reserved_area-to-fix-building-warnings.patch
mm-enhance-free_reserved_area-to-support-poisoning-memory-with-zero.patch
mm-arm64-kill-poison_init_mem.patch
mm-x86-use-free_reserved_area-to-simplify-code.patch
mm-tile-use-common-help-functions-to-free-reserved-pages.patch
mm-fix-some-trivial-typos-in-comments.patch
mm-use-managed_pages-to-calculate-default-zonelist-order.patch
mm-accurately-calculate-zone-managed_pages-for-highmem-zones.patch
mm-use-a-dedicated-lock-to-protect-totalram_pages-and-zone-managed_pages.patch
mm-make-__free_pages_bootmem-only-available-at-boot-time.patch
mm-correctly-update-zone-managed_pages.patch
mm-correctly-update-zone-managed_pages-fix.patch
mm-concentrate-modification-of-totalram_pages-into-the-mm-core.patch
mm-report-available-pages-as-memtotal-for-each-numa-node.patch

