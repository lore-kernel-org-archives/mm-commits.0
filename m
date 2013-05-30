From: akpm@linux-foundation.org
Subject: + mm-make-__free_pages_bootmem-only-available-at-boot-time.patch
 added to -mm tree
Date: Thu, 30 May 2013 15:17:03 -0700
Message-ID: <51a7cfdf.hu3rOabjEoYn9L5/%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60479 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759156Ab3E3WRG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 30 May 2013 18:17:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, yinghai@kernel.org, wujianguo@huawei.com, will.deacon@arm.com, wency@cn.fujitsu.com, walken@google.com, tj@kernel.org, tglx@linutronix.de, tangchen@cn.fujitsu.com, sworddragon2@aol.com, rusty@rustcorp.com.au, rmk@arm.linux.org.uk, riel@redhat.com, mst@redhat.com, mingo@redhat.com, minchan@kernel.org, mel@csn.ul.ie, m.szyprowski@samsung.com, konrad.wilk@oracle.com, kamezawa.hiroyu@jp.fujitsu.com, js1304@gmail.com, jiang.liu@huawei.com, jeremy@goop.org, isimatu.yasuaki@jp.fujitsu.com, hpa@zytor.com, geert@linux-m68k.org, dhowells@redhat.com, cmetcalf@tilera.com, catalin.marinas@arm.com, arnd@arndb.de, liuj97@gmail.com

Subject: + mm-make-__free_pages_bootmem-only-available-at-boot-time.patch added to -mm tree
To: liuj97@gmail.com,arnd@arndb.de,catalin.marinas@arm.com,cmetcalf@tilera.com,dhowells@redhat.com,geert@linux-m68k.org,hpa@zytor.com,isimatu.yasuaki@jp.fujitsu.com,jeremy@goop.org,jiang.liu@huawei.com,js1304@gmail.com,kamezawa.hiroyu@jp.fujitsu.com,konrad.wilk@oracle.com,m.szyprowski@samsung.com,mel@csn.ul.ie,minchan@kernel.org,mingo@redhat.com,mst@redhat.com,riel@redhat.com,rmk@arm.linux.org.uk,rusty@rustcorp.com.au,sworddragon2@aol.com,tangchen@cn.fujitsu.com,tglx@linutronix.de,tj@kernel.org,walken@google.com,wency@cn.fujitsu.com,will.deacon@arm.com,wujianguo@huawei.com,yinghai@kernel.org
From: akpm@linux-foundation.org
Date: Thu, 30 May 2013 15:17:03 -0700


The patch titled
     Subject: mm: make __free_pages_bootmem() only available at boot time
has been added to the -mm tree.  Its filename is
     mm-make-__free_pages_bootmem-only-available-at-boot-time.patch

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
Subject: mm: make __free_pages_bootmem() only available at boot time

In order to simpilify management of totalram_pages and
zone->managed_pages, make __free_pages_bootmem() only available at boot
time.  With this change applied, __free_pages_bootmem() will only be used
by bootmem.c and nobootmem.c at boot time, so mark it as __init.  Other
callers of __free_pages_bootmem() have been converted to use
free_reserved_page(), which handles totalram_pages and zone->managed_pages
in a safer way.

This patch also fix a bug in free_pagetable() for x86_64, which should
increase zone->managed_pages instead of zone->present_pages when freeing
reserved pages.

And now we have managed_pages_count_lock to protect totalram_pages and
zone->managed_pages, so remove the redundant ppb_lock lock in
put_page_bootmem().  This greatly simplifies the locking rules.

Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Wen Congyang <wency@cn.fujitsu.com>
Cc: Tang Chen <tangchen@cn.fujitsu.com>
Cc: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Minchan Kim <minchan@kernel.org>
Cc: "Michael S. Tsirkin" <mst@redhat.com>
Cc: <sworddragon2@aol.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Chris Metcalf <cmetcalf@tilera.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Jianguo Wu <wujianguo@huawei.com>
Cc: Joonsoo Kim <js1304@gmail.com>
Cc: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Michel Lespinasse <walken@google.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Tejun Heo <tj@kernel.org>
Cc: Will Deacon <will.deacon@arm.com>
Cc: Russell King <rmk@arm.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/mm/init_64.c |   18 ++----------------
 mm/memory_hotplug.c   |   16 ++--------------
 mm/page_alloc.c       |    9 +--------
 3 files changed, 5 insertions(+), 38 deletions(-)

diff -puN arch/x86/mm/init_64.c~mm-make-__free_pages_bootmem-only-available-at-boot-time arch/x86/mm/init_64.c
--- a/arch/x86/mm/init_64.c~mm-make-__free_pages_bootmem-only-available-at-boot-time
+++ a/arch/x86/mm/init_64.c
@@ -712,36 +712,22 @@ EXPORT_SYMBOL_GPL(arch_add_memory);
 
 static void __meminit free_pagetable(struct page *page, int order)
 {
-	struct zone *zone;
-	bool bootmem = false;
 	unsigned long magic;
 	unsigned int nr_pages = 1 << order;
 
 	/* bootmem page has reserved flag */
 	if (PageReserved(page)) {
 		__ClearPageReserved(page);
-		bootmem = true;
 
 		magic = (unsigned long)page->lru.next;
 		if (magic == SECTION_INFO || magic == MIX_SECTION_INFO) {
 			while (nr_pages--)
 				put_page_bootmem(page++);
 		} else
-			__free_pages_bootmem(page, order);
+			while (nr_pages--)
+				free_reserved_page(page++);
 	} else
 		free_pages((unsigned long)page_address(page), order);
-
-	/*
-	 * SECTION_INFO pages and MIX_SECTION_INFO pages
-	 * are all allocated by bootmem.
-	 */
-	if (bootmem) {
-		zone = page_zone(page);
-		zone_span_writelock(zone);
-		zone->present_pages += nr_pages;
-		zone_span_writeunlock(zone);
-		totalram_pages += nr_pages;
-	}
 }
 
 static void __meminit free_pte_table(pte_t *pte_start, pmd_t *pmd)
diff -puN mm/memory_hotplug.c~mm-make-__free_pages_bootmem-only-available-at-boot-time mm/memory_hotplug.c
--- a/mm/memory_hotplug.c~mm-make-__free_pages_bootmem-only-available-at-boot-time
+++ a/mm/memory_hotplug.c
@@ -101,12 +101,9 @@ void get_page_bootmem(unsigned long info
 	atomic_inc(&page->_count);
 }
 
-/* reference to __meminit __free_pages_bootmem is valid
- * so use __ref to tell modpost not to generate a warning */
-void __ref put_page_bootmem(struct page *page)
+void put_page_bootmem(struct page *page)
 {
 	unsigned long type;
-	static DEFINE_MUTEX(ppb_lock);
 
 	type = (unsigned long) page->lru.next;
 	BUG_ON(type < MEMORY_HOTPLUG_MIN_BOOTMEM_TYPE ||
@@ -116,17 +113,8 @@ void __ref put_page_bootmem(struct page
 		ClearPagePrivate(page);
 		set_page_private(page, 0);
 		INIT_LIST_HEAD(&page->lru);
-
-		/*
-		 * Please refer to comment for __free_pages_bootmem()
-		 * for why we serialize here.
-		 */
-		mutex_lock(&ppb_lock);
-		__free_pages_bootmem(page, 0);
-		mutex_unlock(&ppb_lock);
-		totalram_pages++;
+		free_reserved_page(page);
 	}
-
 }
 
 #ifdef CONFIG_HAVE_BOOTMEM_INFO_NODE
diff -puN mm/page_alloc.c~mm-make-__free_pages_bootmem-only-available-at-boot-time mm/page_alloc.c
--- a/mm/page_alloc.c~mm-make-__free_pages_bootmem-only-available-at-boot-time
+++ a/mm/page_alloc.c
@@ -745,14 +745,7 @@ static void __free_pages_ok(struct page
 	local_irq_restore(flags);
 }
 
-/*
- * Read access to zone->managed_pages is safe because it's unsigned long,
- * but we still need to serialize writers. Currently all callers of
- * __free_pages_bootmem() except put_page_bootmem() should only be used
- * at boot time. So for shorter boot time, we shift the burden to
- * put_page_bootmem() to serialize writers.
- */
-void __meminit __free_pages_bootmem(struct page *page, unsigned int order)
+void __init __free_pages_bootmem(struct page *page, unsigned int order)
 {
 	unsigned int nr_pages = 1 << order;
 	unsigned int loop;
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

