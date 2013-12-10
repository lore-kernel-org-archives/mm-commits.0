From: akpm@linux-foundation.org
Subject: +
 mm-memblock-reorder-parameters-of-memblock_find_in_range_node.patch added
 to -mm tree
Date: Mon, 09 Dec 2013 16:29:08 -0800
Message-ID: <52a66054.9JS78GksTCMJUgHw%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55599 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750699Ab3LJA3J (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Dec 2013 19:29:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, yinghai@kernel.org, tony@atomide.com, tj@kernel.org, santosh.shilimkar@ti.com, rjw@sisk.pl, pavel@ucw.cz, paul@pwsan.com, mhocko@suse.cz, linux@arm.linux.org.uk, konrad.wilk@oracle.com, kamezawa.hiroyu@jp.fujitsu.com, hpa@zytor.com, hannes@cmpxchg.org, gregkh@linuxfoundation.org, cl@linux-foundation.org, arnd@arndb.de, grygorii.strashko@ti.com

Subject: + mm-memblock-reorder-parameters-of-memblock_find_in_range_node.patch added to -mm tree
To: grygorii.strashko@ti.com,arnd@arndb.de,cl@linux-foundation.org,gregkh@linuxfoundation.org,hannes@cmpxchg.org,hpa@zytor.com,kamezawa.hiroyu@jp.fujitsu.com,konrad.wilk@oracle.com,linux@arm.linux.org.uk,mhocko@suse.cz,paul@pwsan.com,pavel@ucw.cz,rjw@sisk.pl,santosh.shilimkar@ti.com,tj@kernel.org,tony@atomide.com,yinghai@kernel.org
From: akpm@linux-foundation.org
Date: Mon, 09 Dec 2013 16:29:08 -0800


The patch titled
     Subject: mm/memblock: reorder parameters of memblock_find_in_range_node
has been added to the -mm tree.  Its filename is
     mm-memblock-reorder-parameters-of-memblock_find_in_range_node.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-memblock-reorder-parameters-of-memblock_find_in_range_node.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-memblock-reorder-parameters-of-memblock_find_in_range_node.patch

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
Subject: mm/memblock: reorder parameters of memblock_find_in_range_node

Reorder parameters of memblock_find_in_range_node to be consistent
with other memblock APIs.

The change was suggested by Tejun Heo <tj@kernel.org>.

Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
Signed-off-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Tejun Heo <tj@kernel.org>
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
Cc: Tony Lindgren <tony@atomide.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memblock.h |    5 +++--
 mm/memblock.c            |   16 ++++++++--------
 mm/nobootmem.c           |    2 +-
 3 files changed, 12 insertions(+), 11 deletions(-)

diff -puN include/linux/memblock.h~mm-memblock-reorder-parameters-of-memblock_find_in_range_node include/linux/memblock.h
--- a/include/linux/memblock.h~mm-memblock-reorder-parameters-of-memblock_find_in_range_node
+++ a/include/linux/memblock.h
@@ -55,8 +55,9 @@ extern bool movable_node_enabled;
 #define memblock_dbg(fmt, ...) \
 	if (memblock_debug) printk(KERN_INFO pr_fmt(fmt), ##__VA_ARGS__)
 
-phys_addr_t memblock_find_in_range_node(phys_addr_t start, phys_addr_t end,
-				phys_addr_t size, phys_addr_t align, int nid);
+phys_addr_t memblock_find_in_range_node(phys_addr_t size, phys_addr_t align,
+					    phys_addr_t start, phys_addr_t end,
+					    int nid);
 phys_addr_t memblock_find_in_range(phys_addr_t start, phys_addr_t end,
 				   phys_addr_t size, phys_addr_t align);
 phys_addr_t get_allocated_memblock_reserved_regions_info(phys_addr_t *addr);
diff -puN mm/memblock.c~mm-memblock-reorder-parameters-of-memblock_find_in_range_node mm/memblock.c
--- a/mm/memblock.c~mm-memblock-reorder-parameters-of-memblock_find_in_range_node
+++ a/mm/memblock.c
@@ -157,10 +157,10 @@ __memblock_find_range_top_down(phys_addr
 
 /**
  * memblock_find_in_range_node - find free area in given range and node
- * @start: start of candidate range
- * @end: end of candidate range, can be %MEMBLOCK_ALLOC_{ANYWHERE|ACCESSIBLE}
  * @size: size of free area to find
  * @align: alignment of free area to find
+ * @start: start of candidate range
+ * @end: end of candidate range, can be %MEMBLOCK_ALLOC_{ANYWHERE|ACCESSIBLE}
  * @nid: nid of the free area to find, %MAX_NUMNODES for any node
  *
  * Find @size free area aligned to @align in the specified range and node.
@@ -176,9 +176,9 @@ __memblock_find_range_top_down(phys_addr
  * RETURNS:
  * Found address on success, 0 on failure.
  */
-phys_addr_t __init_memblock memblock_find_in_range_node(phys_addr_t start,
-					phys_addr_t end, phys_addr_t size,
-					phys_addr_t align, int nid)
+phys_addr_t __init_memblock memblock_find_in_range_node(phys_addr_t size,
+					phys_addr_t align, phys_addr_t start,
+					phys_addr_t end, int nid)
 {
 	int ret;
 	phys_addr_t kernel_end;
@@ -241,8 +241,8 @@ phys_addr_t __init_memblock memblock_fin
 					phys_addr_t end, phys_addr_t size,
 					phys_addr_t align)
 {
-	return memblock_find_in_range_node(start, end, size, align,
-					   MAX_NUMNODES);
+	return memblock_find_in_range_node(size, align, start, end,
+					    MAX_NUMNODES);
 }
 
 static void __init_memblock memblock_remove_region(struct memblock_type *type, unsigned long r)
@@ -975,7 +975,7 @@ static phys_addr_t __init memblock_alloc
 	/* align @size to avoid excessive fragmentation on reserved array */
 	size = round_up(size, align);
 
-	found = memblock_find_in_range_node(0, max_addr, size, align, nid);
+	found = memblock_find_in_range_node(size, align, 0, max_addr, nid);
 	if (found && !memblock_reserve(found, size))
 		return found;
 
diff -puN mm/nobootmem.c~mm-memblock-reorder-parameters-of-memblock_find_in_range_node mm/nobootmem.c
--- a/mm/nobootmem.c~mm-memblock-reorder-parameters-of-memblock_find_in_range_node
+++ a/mm/nobootmem.c
@@ -41,7 +41,7 @@ static void * __init __alloc_memory_core
 	if (limit > memblock.current_limit)
 		limit = memblock.current_limit;
 
-	addr = memblock_find_in_range_node(goal, limit, size, align, nid);
+	addr = memblock_find_in_range_node(size, align, goal, limit, nid);
 	if (!addr)
 		return NULL;
 
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

