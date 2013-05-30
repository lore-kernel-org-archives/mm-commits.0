From: akpm@linux-foundation.org
Subject: + mm-x86-use-free_reserved_area-to-simplify-code.patch added to
 -mm tree
Date: Thu, 30 May 2013 15:16:54 -0700
Message-ID: <51a7cfd6.DS36G020vG1CyBeK%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60390 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759153Ab3E3WQ4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 30 May 2013 18:16:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, yinghai@kernel.org, wujianguo@huawei.com, will.deacon@arm.com, wency@cn.fujitsu.com, walken@google.com, tj@kernel.org, tglx@linutronix.de, tangchen@cn.fujitsu.com, sworddragon2@aol.com, rusty@rustcorp.com.au, rmk@arm.linux.org.uk, riel@redhat.com, mst@redhat.com, mingo@redhat.com, minchan@kernel.org, mel@csn.ul.ie, m.szyprowski@samsung.com, konrad.wilk@oracle.com, kamezawa.hiroyu@jp.fujitsu.com, js1304@gmail.com, jiang.liu@huawei.com, jeremy@goop.org, isimatu.yasuaki@jp.fujitsu.com, hpa@zytor.com, geert@linux-m68k.org, dhowells@redhat.com, cmetcalf@tilera.com, catalin.marinas@arm.com, arnd@arndb.de, liuj97@gmail.com

Subject: + mm-x86-use-free_reserved_area-to-simplify-code.patch added to -mm tree
To: liuj97@gmail.com,arnd@arndb.de,catalin.marinas@arm.com,cmetcalf@tilera.com,dhowells@redhat.com,geert@linux-m68k.org,hpa@zytor.com,isimatu.yasuaki@jp.fujitsu.com,jeremy@goop.org,jiang.liu@huawei.com,js1304@gmail.com,kamezawa.hiroyu@jp.fujitsu.com,konrad.wilk@oracle.com,m.szyprowski@samsung.com,mel@csn.ul.ie,minchan@kernel.org,mingo@redhat.com,mst@redhat.com,riel@redhat.com,rmk@arm.linux.org.uk,rusty@rustcorp.com.au,sworddragon2@aol.com,tangchen@cn.fujitsu.com,tglx@linutronix.de,tj@kernel.org,walken@google.com,wency@cn.fujitsu.com,will.deacon@arm.com,wujianguo@huawei.com,yinghai@kernel.org
From: akpm@linux-foundation.org
Date: Thu, 30 May 2013 15:16:54 -0700


The patch titled
     Subject: mm/x86: use free_reserved_area() to simplify code
has been added to the -mm tree.  Its filename is
     mm-x86-use-free_reserved_area-to-simplify-code.patch

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
Subject: mm/x86: use free_reserved_area() to simplify code

Use common help function free_reserved_area() to simplify code.

Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Tang Chen <tangchen@cn.fujitsu.com>
Cc: Wen Congyang <wency@cn.fujitsu.com>
Cc: Jianguo Wu <wujianguo@huawei.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>
Cc: <sworddragon2@aol.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Chris Metcalf <cmetcalf@tilera.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Joonsoo Kim <js1304@gmail.com>
Cc: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Michel Lespinasse <walken@google.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Rik van Riel <riel@redhat.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Tejun Heo <tj@kernel.org>
Cc: Will Deacon <will.deacon@arm.com>
Cc: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Cc: Russell King <rmk@arm.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/mm/init.c    |   14 +++-----------
 arch/x86/mm/init_64.c |    5 ++---
 2 files changed, 5 insertions(+), 14 deletions(-)

diff -puN arch/x86/mm/init.c~mm-x86-use-free_reserved_area-to-simplify-code arch/x86/mm/init.c
--- a/arch/x86/mm/init.c~mm-x86-use-free_reserved_area-to-simplify-code
+++ a/arch/x86/mm/init.c
@@ -494,7 +494,6 @@ int devmem_is_allowed(unsigned long page
 
 void free_init_pages(char *what, unsigned long begin, unsigned long end)
 {
-	unsigned long addr;
 	unsigned long begin_aligned, end_aligned;
 
 	/* Make sure boundaries are page aligned */
@@ -509,8 +508,6 @@ void free_init_pages(char *what, unsigne
 	if (begin >= end)
 		return;
 
-	addr = begin;
-
 	/*
 	 * If debugging page accesses then do not free this memory but
 	 * mark them not present - any buggy init-section access will
@@ -529,18 +526,13 @@ void free_init_pages(char *what, unsigne
 	set_memory_nx(begin, (end - begin) >> PAGE_SHIFT);
 	set_memory_rw(begin, (end - begin) >> PAGE_SHIFT);
 
-	printk(KERN_INFO "Freeing %s: %luk freed\n", what, (end - begin) >> 10);
-
-	for (; addr < end; addr += PAGE_SIZE) {
-		memset((void *)addr, POISON_FREE_INITMEM, PAGE_SIZE);
-		free_reserved_page(virt_to_page(addr));
-	}
+	free_reserved_area((void *)begin, (void *)end, POISON_FREE_INITMEM, what);
 #endif
 }
 
 void free_initmem(void)
 {
-	free_init_pages("unused kernel memory",
+	free_init_pages("unused kernel",
 			(unsigned long)(&__init_begin),
 			(unsigned long)(&__init_end));
 }
@@ -566,7 +558,7 @@ void __init free_initrd_mem(unsigned lon
 	 *   - relocate_initrd()
 	 * So here We can do PAGE_ALIGN() safely to get partial page to be freed
 	 */
-	free_init_pages("initrd memory", start, PAGE_ALIGN(end));
+	free_init_pages("initrd", start, PAGE_ALIGN(end));
 }
 #endif
 
diff -puN arch/x86/mm/init_64.c~mm-x86-use-free_reserved_area-to-simplify-code arch/x86/mm/init_64.c
--- a/arch/x86/mm/init_64.c~mm-x86-use-free_reserved_area-to-simplify-code
+++ a/arch/x86/mm/init_64.c
@@ -1166,11 +1166,10 @@ void mark_rodata_ro(void)
 	set_memory_ro(start, (end-start) >> PAGE_SHIFT);
 #endif
 
-	free_init_pages("unused kernel memory",
+	free_init_pages("unused kernel",
 			(unsigned long) __va(__pa_symbol(text_end)),
 			(unsigned long) __va(__pa_symbol(rodata_start)));
-
-	free_init_pages("unused kernel memory",
+	free_init_pages("unused kernel",
 			(unsigned long) __va(__pa_symbol(rodata_end)),
 			(unsigned long) __va(__pa_symbol(_sdata)));
 }
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

