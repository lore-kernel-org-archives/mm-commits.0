From: akpm@linux-foundation.org
Subject: + mm-report-available-pages-as-memtotal-for-each-numa-node.patch
 added to -mm tree
Date: Thu, 30 May 2013 15:17:11 -0700
Message-ID: <51a7cfe7.94CSID1ElG92nh3d%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60549 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759393Ab3E3WRM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 30 May 2013 18:17:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, yinghai@kernel.org, wujianguo@huawei.com, will.deacon@arm.com, wency@cn.fujitsu.com, walken@google.com, tj@kernel.org, tglx@linutronix.de, tangchen@cn.fujitsu.com, sworddragon2@aol.com, rusty@rustcorp.com.au, rmk@arm.linux.org.uk, riel@redhat.com, mst@redhat.com, mingo@redhat.com, minchan@kernel.org, mel@csn.ul.ie, m.szyprowski@samsung.com, konrad.wilk@oracle.com, kamezawa.hiroyu@jp.fujitsu.com, js1304@gmail.com, jiang.liu@huawei.com, jeremy@goop.org, isimatu.yasuaki@jp.fujitsu.com, hpa@zytor.com, geert@linux-m68k.org, dhowells@redhat.com, cmetcalf@tilera.com, catalin.marinas@arm.com, arnd@arndb.de, liuj97@gmail.com

Subject: + mm-report-available-pages-as-memtotal-for-each-numa-node.patch added to -mm tree
To: liuj97@gmail.com,arnd@arndb.de,catalin.marinas@arm.com,cmetcalf@tilera.com,dhowells@redhat.com,geert@linux-m68k.org,hpa@zytor.com,isimatu.yasuaki@jp.fujitsu.com,jeremy@goop.org,jiang.liu@huawei.com,js1304@gmail.com,kamezawa.hiroyu@jp.fujitsu.com,konrad.wilk@oracle.com,m.szyprowski@samsung.com,mel@csn.ul.ie,minchan@kernel.org,mingo@redhat.com,mst@redhat.com,riel@redhat.com,rmk@arm.linux.org.uk,rusty@rustcorp.com.au,sworddragon2@aol.com,tangchen@cn.fujitsu.com,tglx@linutronix.de,tj@kernel.org,walken@google.com,wency@cn.fujitsu.com,will.deacon@arm.com,wujianguo@huawei.com,yinghai@kernel.org
From: akpm@linux-foundation.org
Date: Thu, 30 May 2013 15:17:10 -0700


The patch titled
     Subject: mm: report available pages as "MemTotal" for each NUMA node
has been added to the -mm tree.  Its filename is
     mm-report-available-pages-as-memtotal-for-each-numa-node.patch

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
Subject: mm: report available pages as "MemTotal" for each NUMA node

As reported by https://bugzilla.kernel.org/show_bug.cgi?id=53501,
"MemTotal" from /proc/meminfo means memory pages managed by the buddy
system (managed_pages), but "MemTotal" from /sys/.../node/nodex/meminfo
means physical pages present (present_pages) within the NUMA node.
There's a difference between managed_pages and present_pages due to
bootmem allocator and reserved pages.

And Documentation/filesystems/proc.txt says
    MemTotal: Total usable ram (i.e. physical ram minus a few reserved
              bits and the kernel binary code)

So change /sys/.../node/nodex/meminfo to report available pages within
the node as "MemTotal".

Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
Reported-by: <sworddragon2@aol.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Minchan Kim <minchan@kernel.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Arnd Bergmann <arnd@arndb.de>
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
Cc: Michel Lespinasse <walken@google.com>
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

 mm/page_alloc.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff -puN mm/page_alloc.c~mm-report-available-pages-as-memtotal-for-each-numa-node mm/page_alloc.c
--- a/mm/page_alloc.c~mm-report-available-pages-as-memtotal-for-each-numa-node
+++ a/mm/page_alloc.c
@@ -2904,9 +2904,13 @@ EXPORT_SYMBOL(si_meminfo);
 #ifdef CONFIG_NUMA
 void si_meminfo_node(struct sysinfo *val, int nid)
 {
+	int zone_type;		/* needs to be signed */
+	unsigned long managed_pages = 0;
 	pg_data_t *pgdat = NODE_DATA(nid);
 
-	val->totalram = pgdat->node_present_pages;
+	for (zone_type = 0; zone_type < MAX_NR_ZONES; zone_type++)
+		managed_pages += pgdat->node_zones[zone_type].managed_pages;
+	val->totalram = managed_pages;
 	val->freeram = node_page_state(nid, NR_FREE_PAGES);
 #ifdef CONFIG_HIGHMEM
 	val->totalhigh = pgdat->node_zones[ZONE_HIGHMEM].managed_pages;
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

