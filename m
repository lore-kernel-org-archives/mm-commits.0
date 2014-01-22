From: akpm@linux-foundation.org
Subject: [merged]
 mm-page_cgroup-use-memblock-apis-for-early-memory-allocations.patch removed from -mm tree
Date: Wed, 22 Jan 2014 12:14:16 -0800
Message-ID: <52e02698.JotdxyO4kJNy3iGr%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54866 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756041AbaAVUOR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 22 Jan 2014 15:14:17 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, yinghai@kernel.org, tony@atomide.com, tj@kernel.org, santosh.shilimkar@ti.com, rjw@sisk.pl, pavel@ucw.cz, paul@pwsan.com, mhocko@suse.cz, linux@arm.linux.org.uk, konrad.wilk@oracle.com, kamezawa.hiroyu@jp.fujitsu.com, hpa@zytor.com, hannes@cmpxchg.org, gregkh@linuxfoundation.org, cl@linux-foundation.org, arnd@arndb.de, grygorii.strashko@ti.com

Subject: [merged] mm-page_cgroup-use-memblock-apis-for-early-memory-allocations.patch removed from -mm tree
To: grygorii.strashko@ti.com,arnd@arndb.de,cl@linux-foundation.org,gregkh@linuxfoundation.org,hannes@cmpxchg.org,hpa@zytor.com,kamezawa.hiroyu@jp.fujitsu.com,konrad.wilk@oracle.com,linux@arm.linux.org.uk,mhocko@suse.cz,paul@pwsan.com,pavel@ucw.cz,rjw@sisk.pl,santosh.shilimkar@ti.com,tj@kernel.org,tony@atomide.com,yinghai@kernel.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 22 Jan 2014 12:14:16 -0800


The patch titled
     Subject: mm/page_cgroup.c: use memblock apis for early memory allocations
has been removed from the -mm tree.  Its filename was
     mm-page_cgroup-use-memblock-apis-for-early-memory-allocations.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Grygorii Strashko <grygorii.strashko@ti.com>
Subject: mm/page_cgroup.c: use memblock apis for early memory allocations

Switch to memblock interfaces for early memory allocator instead of
bootmem allocator.  No functional change in beahvior than what it is in
current code from bootmem users points of view.

Archs already converted to NO_BOOTMEM now directly use memblock interfaces
instead of bootmem wrappers build on top of memblock.  And the archs which
still uses bootmem, these new apis just fallback to exiting bootmem APIs.

Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
Signed-off-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Christoph Lameter <cl@linux-foundation.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Grygorii Strashko <grygorii.strashko@ti.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Paul Walmsley <paul@pwsan.com>
Cc: Pavel Machek <pavel@ucw.cz>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Tejun Heo <tj@kernel.org>
Cc: Tony Lindgren <tony@atomide.com>
Cc: Yinghai Lu <yinghai@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_cgroup.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN mm/page_cgroup.c~mm-page_cgroup-use-memblock-apis-for-early-memory-allocations mm/page_cgroup.c
--- a/mm/page_cgroup.c~mm-page_cgroup-use-memblock-apis-for-early-memory-allocations
+++ a/mm/page_cgroup.c
@@ -54,8 +54,9 @@ static int __init alloc_node_page_cgroup
 
 	table_size = sizeof(struct page_cgroup) * nr_pages;
 
-	base = __alloc_bootmem_node_nopanic(NODE_DATA(nid),
-			table_size, PAGE_SIZE, __pa(MAX_DMA_ADDRESS));
+	base = memblock_virt_alloc_try_nid_nopanic(
+			table_size, PAGE_SIZE, __pa(MAX_DMA_ADDRESS),
+			BOOTMEM_ALLOC_ACCESSIBLE, nid);
 	if (!base)
 		return -ENOMEM;
 	NODE_DATA(nid)->node_page_cgroup = base;
_

Patches currently in -mm which might be from grygorii.strashko@ti.com are

origin.patch
mm-nobootmem-free_all_bootmem-again.patch
rtc-rtc-twl-use-devm_-functions.patch
rtc-rtc-vr41xx-use-devm_-functions.patch
linux-next.patch

