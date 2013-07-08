From: akpm@linux-foundation.org
Subject: [merged] mm-arm64-kill-poison_init_mem.patch removed from -mm
 tree
Date: Mon, 08 Jul 2013 12:26:08 -0700
Message-ID: <51db1250.sn+R4oQSWStbpm9L%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50608 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752477Ab3GHT0K (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Jul 2013 15:26:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, yinghai@kernel.org, wujianguo@huawei.com, will.deacon@arm.com, wency@cn.fujitsu.com, walken@google.com, tj@kernel.org, tglx@linutronix.de, tangchen@cn.fujitsu.com, sworddragon2@aol.com, rusty@rustcorp.com.au, rmk@arm.linux.org.uk, riel@redhat.com, mst@redhat.com, mingo@redhat.com, minchan@kernel.org, mel@csn.ul.ie, m.szyprowski@samsung.com, konrad.wilk@oracle.com, kamezawa.hiroyu@jp.fujitsu.com, js1304@gmail.com, jiang.liu@huawei.com, jeremy@goop.org, isimatu.yasuaki@jp.fujitsu.com, hpa@zytor.com, geert@linux-m68k.org, dhowells@redhat.com, cmetcalf@tilera.com, catalin.marinas@arm.com, arnd@arndb.de, liuj97@gmail.com

Subject: [merged] mm-arm64-kill-poison_init_mem.patch removed from -mm tree
To: liuj97@gmail.com,arnd@arndb.de,catalin.marinas@arm.com,cmetcalf@tilera.com,dhowells@redhat.com,geert@linux-m68k.org,hpa@zytor.com,isimatu.yasuaki@jp.fujitsu.com,jeremy@goop.org,jiang.liu@huawei.com,js1304@gmail.com,kamezawa.hiroyu@jp.fujitsu.com,konrad.wilk@oracle.com,m.szyprowski@samsung.com,mel@csn.ul.ie,minchan@kernel.org,mingo@redhat.com,mst@redhat.com,riel@redhat.com,rmk@arm.linux.org.uk,rusty@rustcorp.com.au,sworddragon2@aol.com,tangchen@cn.fujitsu.com,tglx@linutronix.de,tj@kernel.org,walken@google.com,wency@cn.fujitsu.com,will.deacon@arm.com,wujianguo@huawei.com,yinghai@kernel.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 08 Jul 2013 12:26:08 -0700


The patch titled
     Subject: mm/ARM64: kill poison_init_mem()
has been removed from the -mm tree.  Its filename was
     mm-arm64-kill-poison_init_mem.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jiang Liu <liuj97@gmail.com>
Subject: mm/ARM64: kill poison_init_mem()

Use free_reserved_area() to poison initmem memory pages and kill
poison_init_mem() on ARM64.

Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will.deacon@arm.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>
Cc: <sworddragon2@aol.com>
Cc: Arnd Bergmann <arnd@arndb.de>
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
Cc: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Russell King <rmk@arm.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/mm/init.c |   17 +++--------------
 1 file changed, 3 insertions(+), 14 deletions(-)

diff -puN arch/arm64/mm/init.c~mm-arm64-kill-poison_init_mem arch/arm64/mm/init.c
--- a/arch/arm64/mm/init.c~mm-arm64-kill-poison_init_mem
+++ a/arch/arm64/mm/init.c
@@ -197,14 +197,6 @@ void __init bootmem_init(void)
 	max_pfn = max_low_pfn = max;
 }
 
-/*
- * Poison init memory with an undefined instruction (0x0).
- */
-static inline void poison_init_mem(void *s, size_t count)
-{
-	memset(s, 0, count);
-}
-
 #ifndef CONFIG_SPARSEMEM_VMEMMAP
 static inline void free_memmap(unsigned long start_pfn, unsigned long end_pfn)
 {
@@ -386,8 +378,7 @@ void __init mem_init(void)
 
 void free_initmem(void)
 {
-	poison_init_mem(__init_begin, __init_end - __init_begin);
-	free_initmem_default(-1);
+	free_initmem_default(0);
 }
 
 #ifdef CONFIG_BLK_DEV_INITRD
@@ -396,10 +387,8 @@ static int keep_initrd;
 
 void free_initrd_mem(unsigned long start, unsigned long end)
 {
-	if (!keep_initrd) {
-		poison_init_mem((void *)start, PAGE_ALIGN(end) - start);
-		free_reserved_area((void *)start, (void *)end, -1, "initrd");
-	}
+	if (!keep_initrd)
+		free_reserved_area((void *)start, (void *)end, 0, "initrd");
 }
 
 static int __init keepinitrd_setup(char *__unused)
_

Patches currently in -mm which might be from liuj97@gmail.com are

origin.patch
linux-next.patch

