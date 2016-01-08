From: akpm@linux-foundation.org
Subject: + mm-page_allocc-introduce-kernelcore=mirror-option.patch added
 to -mm tree
Date: Fri, 08 Jan 2016 15:16:42 -0800
Message-ID: <5690435a.agRsA4oaOPSHUfNO%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49403 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756177AbcAHXQn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Jan 2016 18:16:43 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: izumi.taku@jp.fujitsu.com, arnd@arndb.de, dave.hansen@intel.com, kamezawa.hiroyu@jp.fujitsu.com, matt@codeblueprint.co.uk, mel@csn.ul.ie, qiuxishi@huawei.com, steve.capper@linaro.org, sudeep.holla@arm.com, tony.luck@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_alloc.c: introduce kernelcore=mirror option
has been added to the -mm tree.  Its filename is
     mm-page_allocc-introduce-kernelcore=mirror-option.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-page_allocc-introduce-kernelcore%3Dmirror-option.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-page_allocc-introduce-kernelcore%3Dmirror-option.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Taku Izumi <izumi.taku@jp.fujitsu.com>
Subject: mm/page_alloc.c: introduce kernelcore=mirror option

This patch extends existing "kernelcore" option and introduces
kernelcore=mirror option.  By specifying "mirror" instead of specifying
the amount of memory, non-mirrored (non-reliable) region will be arranged
into ZONE_MOVABLE.

Signed-off-by: Taku Izumi <izumi.taku@jp.fujitsu.com>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Xishi Qiu <qiuxishi@huawei.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Matt Fleming <matt@codeblueprint.co.uk>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Steve Capper <steve.capper@linaro.org>
Cc: Sudeep Holla <sudeep.holla@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/kernel-parameters.txt |   12 ++
 mm/page_alloc.c                     |  114 ++++++++++++++++++++++++--
 2 files changed, 119 insertions(+), 7 deletions(-)

diff -puN Documentation/kernel-parameters.txt~mm-page_allocc-introduce-kernelcore=mirror-option Documentation/kernel-parameters.txt
--- a/Documentation/kernel-parameters.txt~mm-page_allocc-introduce-kernelcore=mirror-option
+++ a/Documentation/kernel-parameters.txt
@@ -1696,7 +1696,9 @@ bytes respectively. Such letter suffixes
 
 	keepinitrd	[HW,ARM]
 
-	kernelcore=nn[KMG]	[KNL,X86,IA-64,PPC] This parameter
+	kernelcore=	[KNL,X86,IA-64,PPC]
+			Format: nn[KMGTPE] | "mirror"
+			This parameter
 			specifies the amount of memory usable by the kernel
 			for non-movable allocations.  The requested amount is
 			spread evenly throughout all nodes in the system. The
@@ -1712,6 +1714,14 @@ bytes respectively. Such letter suffixes
 			use the HighMem zone if it exists, and the Normal
 			zone if it does not.
 
+			Instead of specifying the amount of memory (nn[KMGTPE]),
+			you can specify "mirror" option. In case "mirror"
+			option is specified, mirrored (reliable) memory is used
+			for non-movable allocations and remaining memory is used
+			for Movable pages. nn[KMGTPE] and "mirror" are exclusive,
+			so you can NOT specify nn[KMGTPE] and "mirror" at the same
+			time.
+
 	kgdbdbgp=	[KGDB,HW] kgdb over EHCI usb debug port.
 			Format: <Controller#>[,poll interval]
 			The controller # is the number of the ehci usb debug
diff -puN mm/page_alloc.c~mm-page_allocc-introduce-kernelcore=mirror-option mm/page_alloc.c
--- a/mm/page_alloc.c~mm-page_allocc-introduce-kernelcore=mirror-option
+++ a/mm/page_alloc.c
@@ -247,6 +247,7 @@ static unsigned long __meminitdata arch_
 static unsigned long __initdata required_kernelcore;
 static unsigned long __initdata required_movablecore;
 static unsigned long __meminitdata zone_movable_pfn[MAX_NUMNODES];
+static bool mirrored_kernelcore;
 
 /* movable_zone is the "real" zone pages in ZONE_MOVABLE are taken from */
 int movable_zone;
@@ -4596,6 +4597,9 @@ void __meminit memmap_init_zone(unsigned
 	unsigned long pfn;
 	struct zone *z;
 	unsigned long nr_initialised = 0;
+#ifdef CONFIG_HAVE_MEMBLOCK_NODE_MAP
+	struct memblock_region *r = NULL, *tmp;
+#endif
 
 	if (highest_memmap_pfn < end_pfn - 1)
 		highest_memmap_pfn = end_pfn - 1;
@@ -4622,6 +4626,40 @@ void __meminit memmap_init_zone(unsigned
 			if (!update_defer_init(pgdat, pfn, end_pfn,
 						&nr_initialised))
 				break;
+
+			/*
+			 * if not mirrored_kernelcore and ZONE_MOVABLE exists,
+			 * range from zone_movable_pfn[nid] to end of each node
+			 * should be ZONE_MOVABLE not ZONE_NORMAL. skip it.
+			 */
+			if (!mirrored_kernelcore && zone_movable_pfn[nid])
+				if (zone == ZONE_NORMAL &&
+				    pfn >= zone_movable_pfn[nid])
+					continue;
+
+#ifdef CONFIG_HAVE_MEMBLOCK_NODE_MAP
+			/*
+			 * check given memblock attribute by firmware which
+			 * can affect kernel memory layout.
+			 * if zone==ZONE_MOVABLE but memory is mirrored,
+			 * it's an overlapped memmap init. skip it.
+			 */
+			if (mirrored_kernelcore && zone == ZONE_MOVABLE) {
+				if (!r ||
+				    pfn >= memblock_region_memory_end_pfn(r)) {
+					for_each_memblock(memory, tmp)
+						if (pfn < memblock_region_memory_end_pfn(tmp))
+							break;
+					r = tmp;
+				}
+				if (pfn >= memblock_region_memory_base_pfn(r) &&
+				    memblock_is_mirror(r)) {
+					/* already initialized as NORMAL */
+					pfn = memblock_region_memory_end_pfn(r);
+					continue;
+				}
+			}
+#endif
 		}
 
 		/*
@@ -5040,11 +5078,6 @@ static void __meminit adjust_zone_range_
 			*zone_end_pfn = min(node_end_pfn,
 				arch_zone_highest_possible_pfn[movable_zone]);
 
-		/* Adjust for ZONE_MOVABLE starting within this range */
-		} else if (*zone_start_pfn < zone_movable_pfn[nid] &&
-				*zone_end_pfn > zone_movable_pfn[nid]) {
-			*zone_end_pfn = zone_movable_pfn[nid];
-
 		/* Check if this whole range is within ZONE_MOVABLE */
 		} else if (*zone_start_pfn >= zone_movable_pfn[nid])
 			*zone_start_pfn = *zone_end_pfn;
@@ -5129,6 +5162,7 @@ static unsigned long __meminit zone_abse
 	unsigned long zone_low = arch_zone_lowest_possible_pfn[zone_type];
 	unsigned long zone_high = arch_zone_highest_possible_pfn[zone_type];
 	unsigned long zone_start_pfn, zone_end_pfn;
+	unsigned long nr_absent;
 
 	/* When hotadd a new node from cpu_up(), the node should be empty */
 	if (!node_start_pfn && !node_end_pfn)
@@ -5140,7 +5174,39 @@ static unsigned long __meminit zone_abse
 	adjust_zone_range_for_zone_movable(nid, zone_type,
 			node_start_pfn, node_end_pfn,
 			&zone_start_pfn, &zone_end_pfn);
-	return __absent_pages_in_range(nid, zone_start_pfn, zone_end_pfn);
+	nr_absent = __absent_pages_in_range(nid, zone_start_pfn, zone_end_pfn);
+
+	/*
+	 * ZONE_MOVABLE handling.
+	 * Treat pages to be ZONE_MOVABLE in ZONE_NORMAL as absent pages
+	 * and vice versa.
+	 */
+	if (zone_movable_pfn[nid]) {
+		if (mirrored_kernelcore) {
+			unsigned long start_pfn, end_pfn;
+			struct memblock_region *r;
+
+			for_each_memblock(memory, r) {
+				start_pfn = clamp(memblock_region_memory_base_pfn(r),
+						  zone_start_pfn, zone_end_pfn);
+				end_pfn = clamp(memblock_region_memory_end_pfn(r),
+						zone_start_pfn, zone_end_pfn);
+
+				if (zone_type == ZONE_MOVABLE &&
+				    memblock_is_mirror(r))
+					nr_absent += end_pfn - start_pfn;
+
+				if (zone_type == ZONE_NORMAL &&
+				    !memblock_is_mirror(r))
+					nr_absent += end_pfn - start_pfn;
+			}
+		} else {
+			if (zone_type == ZONE_NORMAL)
+				nr_absent += node_end_pfn - zone_movable_pfn[nid];
+		}
+	}
+
+	return nr_absent;
 }
 
 #else /* CONFIG_HAVE_MEMBLOCK_NODE_MAP */
@@ -5648,6 +5714,36 @@ static void __init find_zone_movable_pfn
 	}
 
 	/*
+	 * If kernelcore=mirror is specified, ignore movablecore option
+	 */
+	if (mirrored_kernelcore) {
+		bool mem_below_4gb_not_mirrored = false;
+
+		for_each_memblock(memory, r) {
+			if (memblock_is_mirror(r))
+				continue;
+
+			nid = r->nid;
+
+			usable_startpfn = memblock_region_memory_base_pfn(r);
+
+			if (usable_startpfn < 0x100000) {
+				mem_below_4gb_not_mirrored = true;
+				continue;
+			}
+
+			zone_movable_pfn[nid] = zone_movable_pfn[nid] ?
+				min(usable_startpfn, zone_movable_pfn[nid]) :
+				usable_startpfn;
+		}
+
+		if (mem_below_4gb_not_mirrored)
+			pr_warn("This configuration results in unmirrored kernel memory.");
+
+		goto out2;
+	}
+
+	/*
 	 * If movablecore=nn[KMG] was specified, calculate what size of
 	 * kernelcore that corresponds so that memory usable for
 	 * any allocation type is evenly spread. If both kernelcore
@@ -5907,6 +6003,12 @@ static int __init cmdline_parse_core(cha
  */
 static int __init cmdline_parse_kernelcore(char *p)
 {
+	/* parse kernelcore=mirror */
+	if (parse_option_str(p, "mirror")) {
+		mirrored_kernelcore = true;
+		return 0;
+	}
+
 	return cmdline_parse_core(p, &required_kernelcore);
 }
 
_

Patches currently in -mm which might be from izumi.taku@jp.fujitsu.com are

mm-page_allocc-calculate-zone_start_pfn-at-zone_spanned_pages_in_node.patch
mm-page_allocc-introduce-kernelcore=mirror-option.patch

