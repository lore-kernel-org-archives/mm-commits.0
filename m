From: akpm@linux-foundation.org
Subject: + mm-hugetlb-use-memblock-apis-for-early-memory-allocations.patch added to -mm tree
Date: Mon, 09 Dec 2013 16:29:28 -0800
Message-ID: <52a66068.7DldZw2bNwGp7UeR%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55745 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751542Ab3LJA33 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Dec 2013 19:29:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, yinghai@kernel.org, tony@atomide.com, tj@kernel.org, santosh.shilimkar@ti.com, rjw@sisk.pl, pavel@ucw.cz, paul@pwsan.com, mhocko@suse.cz, linux@arm.linux.org.uk, konrad.wilk@oracle.com, kamezawa.hiroyu@jp.fujitsu.com, hpa@zytor.com, hannes@cmpxchg.org, gregkh@linuxfoundation.org, cl@linux-foundation.org, arnd@arndb.de, grygorii.strashko@ti.com

Subject: + mm-hugetlb-use-memblock-apis-for-early-memory-allocations.patch added to -mm tree
To: grygorii.strashko@ti.com,arnd@arndb.de,cl@linux-foundation.org,gregkh@linuxfoundation.org,hannes@cmpxchg.org,hpa@zytor.com,kamezawa.hiroyu@jp.fujitsu.com,konrad.wilk@oracle.com,linux@arm.linux.org.uk,mhocko@suse.cz,paul@pwsan.com,pavel@ucw.cz,rjw@sisk.pl,santosh.shilimkar@ti.com,tj@kernel.org,tony@atomide.com,yinghai@kernel.org
From: akpm@linux-foundation.org
Date: Mon, 09 Dec 2013 16:29:28 -0800


The patch titled
     Subject: mm/hugetlb.c: use memblock apis for early memory allocations
has been added to the -mm tree.  Its filename is
     mm-hugetlb-use-memblock-apis-for-early-memory-allocations.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-hugetlb-use-memblock-apis-for-early-memory-allocations.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-hugetlb-use-memblock-apis-for-early-memory-allocations.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Grygorii Strashko <grygorii.strashko@ti.com>
Subject: mm/hugetlb.c: use memblock apis for early memory allocations

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

 mm/hugetlb.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff -puN mm/hugetlb.c~mm-hugetlb-use-memblock-apis-for-early-memory-allocations mm/hugetlb.c
--- a/mm/hugetlb.c~mm-hugetlb-use-memblock-apis-for-early-memory-allocations
+++ a/mm/hugetlb.c
@@ -1271,9 +1271,9 @@ int __weak alloc_bootmem_huge_page(struc
 	for_each_node_mask_to_alloc(h, nr_nodes, node, &node_states[N_MEMORY]) {
 		void *addr;
 
-		addr = __alloc_bootmem_node_nopanic(NODE_DATA(node),
-				huge_page_size(h), huge_page_size(h), 0);
-
+		addr = memblock_virt_alloc_try_nid_nopanic(
+				huge_page_size(h), huge_page_size(h),
+				0, BOOTMEM_ALLOC_ACCESSIBLE, node);
 		if (addr) {
 			/*
 			 * Use the beginning of the huge page to store the
@@ -1313,8 +1313,8 @@ static void __init gather_bootmem_preall
 
 #ifdef CONFIG_HIGHMEM
 		page = pfn_to_page(m->phys >> PAGE_SHIFT);
-		free_bootmem_late((unsigned long)m,
-				  sizeof(struct huge_bootmem_page));
+		memblock_free_late(__pa(m),
+				   sizeof(struct huge_bootmem_page));
 #else
 		page = virt_to_page(m);
 #endif
_

Patches currently in -mm which might be from grygorii.strashko@ti.com are

mm-memblock-debug-correct-displaying-of-upper-memory-boundary.patch
mm-memblock-debug-dont-free-reserved-array-if-arch_discard_memblock.patch
mm-bootmem-remove-duplicated-declaration-of-__free_pages_bootmem.patch
mm-memblock-remove-unnecessary-inclusions-of-bootmemh.patch
mm-memblock-drop-warn-and-use-smp_cache_bytes-as-a-default-alignment.patch
mm-memblock-reorder-parameters-of-memblock_find_in_range_node.patch
mm-memblock-switch-to-use-numa_no_node-instead-of-max_numnodes.patch
mm-memblock-add-memblock-memory-allocation-apis.patch
mm-memblock-add-memblock-memory-allocation-apis-fix.patch
mm-init-use-memblock-apis-for-early-memory-allocations.patch
mm-printk-use-memblock-apis-for-early-memory-allocations.patch
mm-page_alloc-use-memblock-apis-for-early-memory-allocations.patch
mm-power-use-memblock-apis-for-early-memory-allocations.patch
lib-swiotlbc-use-memblock-apis-for-early-memory-allocations.patch
lib-cpumaskc-use-memblock-apis-for-early-memory-allocations.patch
mm-sparse-use-memblock-apis-for-early-memory-allocations.patch
mm-hugetlb-use-memblock-apis-for-early-memory-allocations.patch
mm-page_cgroup-use-memblock-apis-for-early-memory-allocations.patch
mm-percpu-use-memblock-apis-for-early-memory-allocations.patch
mm-memory_hotplug-use-memblock-apis-for-early-memory-allocations.patch
drivers-firmware-memmapc-use-memblock-apis-for-early-memory-allocations.patch
arch-arm-kernel-use-memblock-apis-for-early-memory-allocations.patch
arch-arm-mm-initc-use-memblock-apis-for-early-memory-allocations.patch
arch-arm-mach-omap2-omap_hwmodc-use-memblock-apis-for-early-memory-allocations.patch
rtc-rtc-twl-use-devm_-functions.patch
rtc-rtc-vr41xx-use-devm_-functions.patch
linux-next.patch

