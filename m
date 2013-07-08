From: akpm@linux-foundation.org
Subject: [merged]
 mm-use-managed_pages-to-calculate-default-zonelist-order.patch removed from -mm tree
Date: Mon, 08 Jul 2013 12:26:16 -0700
Message-ID: <51db1258.icbKGQPLTvALvVSP%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50685 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752510Ab3GHT0S (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Jul 2013 15:26:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, yinghai@kernel.org, wujianguo@huawei.com, will.deacon@arm.com, wency@cn.fujitsu.com, walken@google.com, tj@kernel.org, tglx@linutronix.de, tangchen@cn.fujitsu.com, sworddragon2@aol.com, rusty@rustcorp.com.au, rmk@arm.linux.org.uk, riel@redhat.com, mst@redhat.com, mingo@redhat.com, minchan@kernel.org, mel@csn.ul.ie, m.szyprowski@samsung.com, konrad.wilk@oracle.com, kamezawa.hiroyu@jp.fujitsu.com, js1304@gmail.com, jiang.liu@huawei.com, jeremy@goop.org, isimatu.yasuaki@jp.fujitsu.com, hpa@zytor.com, geert@linux-m68k.org, dhowells@redhat.com, cmetcalf@tilera.com, catalin.marinas@arm.com, arnd@arndb.de, liuj97@gmail.com

Subject: [merged] mm-use-managed_pages-to-calculate-default-zonelist-order.patch removed from -mm tree
To: liuj97@gmail.com,arnd@arndb.de,catalin.marinas@arm.com,cmetcalf@tilera.com,dhowells@redhat.com,geert@linux-m68k.org,hpa@zytor.com,isimatu.yasuaki@jp.fujitsu.com,jeremy@goop.org,jiang.liu@huawei.com,js1304@gmail.com,kamezawa.hiroyu@jp.fujitsu.com,konrad.wilk@oracle.com,m.szyprowski@samsung.com,mel@csn.ul.ie,minchan@kernel.org,mingo@redhat.com,mst@redhat.com,riel@redhat.com,rmk@arm.linux.org.uk,rusty@rustcorp.com.au,sworddragon2@aol.com,tangchen@cn.fujitsu.com,tglx@linutronix.de,tj@kernel.org,walken@google.com,wency@cn.fujitsu.com,will.deacon@arm.com,wujianguo@huawei.com,yinghai@kernel.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 08 Jul 2013 12:26:16 -0700


The patch titled
     Subject: mm: use managed_pages to calculate default zonelist order
has been removed from the -mm tree.  Its filename was
     mm-use-managed_pages-to-calculate-default-zonelist-order.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jiang Liu <liuj97@gmail.com>
Subject: mm: use managed_pages to calculate default zonelist order

Use zone->managed_pages instead of zone->present_pages to calculate
default zonelist order because managed_pages means allocatable pages.

Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>
Cc: <sworddragon2@aol.com>
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

 mm/page_alloc.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN mm/page_alloc.c~mm-use-managed_pages-to-calculate-default-zonelist-order mm/page_alloc.c
--- a/mm/page_alloc.c~mm-use-managed_pages-to-calculate-default-zonelist-order
+++ a/mm/page_alloc.c
@@ -3438,8 +3438,8 @@ static int default_zonelist_order(void)
 			z = &NODE_DATA(nid)->node_zones[zone_type];
 			if (populated_zone(z)) {
 				if (zone_type < ZONE_NORMAL)
-					low_kmem_size += z->present_pages;
-				total_size += z->present_pages;
+					low_kmem_size += z->managed_pages;
+				total_size += z->managed_pages;
 			} else if (zone_type == ZONE_NORMAL) {
 				/*
 				 * If any node has only lowmem, then node order
_

Patches currently in -mm which might be from liuj97@gmail.com are

origin.patch
linux-next.patch

