From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-clean-up-free_area_init_node-and-its-helpers.patch
 added to -mm tree
Date: Mon, 13 Apr 2020 17:26:55 -0700
Message-ID: <20200414002655.89EFC12fN%akpm@linux-foundation.org>
References: <20200412004155.1a8f4e081b4e03ef5903abb5@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:33070 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727914AbgDNA1A (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 13 Apr 2020 20:27:00 -0400
In-Reply-To: <20200412004155.1a8f4e081b4e03ef5903abb5@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bcain@codeaurora.org, bhe@redhat.com, catalin.marinas@arm.com, corbet@lwn.net, dalias@libc.org, davem@davemloft.net, deller@gmx.de, geert@linux-m68k.org, gerg@linux-m68k.org, green.hu@gmail.com, guoren@kernel.org, gxt@pku.edu.cn, heiko.carstens@de.ibm.com, Hoan@os.amperecomputing.com, James.Bottomley@HansenPartnership.com, jcmvbkbc@gmail.com, ley.foon.tan@intel.com, linux@armlinux.org.uk, mattst88@gmail.com, mhocko@kernel.org, mm-commits@vger.kernel.org, monstr@monstr.eu, mpe@ellerman.id.au, msalter@redhat.com, nickhu@andestech.com, paul.walmsley@sifive.com, richard@nod.at, rppt@linux.ibm.com, shorne@gmail.com, tony.luck@intel.com, tsbogend@alpha.franken.de, vgupta@synopsys.com, ysato@users.sourceforge.jp


The patch titled
     Subject: mm: clean up free_area_init_node() and its helpers
has been added to the -mm tree.  Its filename is
     mm-clean-up-free_area_init_node-and-its-helpers.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-clean-up-free_area_init_node-and-its-helpers.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-clean-up-free_area_init_node-and-its-helpers.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Mike Rapoport <rppt@linux.ibm.com>
Subject: mm: clean up free_area_init_node() and its helpers

free_area_init_node() now always uses memblock info and the zone PFN
limits so it does not need the backwards compatibility functions to
calculate the zone spanned and absent pages.  The removal of the compat_
versions of zone_{abscent,spanned}_pages_in_node() in turn, makes
zone_size and zhole_size parameters unused.

The node_start_pfn is determined by get_pfn_range_for_nid(), so there is
no need to pass it to free_area_init_node().

As a result, the only required parameter to free_area_init_node() is the
node ID, all the rest are removed along with no longer used
compat_zone_{abscent,spanned}_pages_in_node() helpers.

Link: http://lkml.kernel.org/r/20200412194859.12663-20-rppt@kernel.org
Signed-off-by: Mike Rapoport <rppt@linux.ibm.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Brian Cain <bcain@codeaurora.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Greentime Hu <green.hu@gmail.com>
Cc: Greg Ungerer <gerg@linux-m68k.org>
Cc: Guan Xuetao <gxt@pku.edu.cn>
Cc: Guo Ren <guoren@kernel.org>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Helge Deller <deller@gmx.de>
Cc: Hoan Tran <Hoan@os.amperecomputing.com>
Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Ley Foon Tan <ley.foon.tan@intel.com>
Cc: Mark Salter <msalter@redhat.com>
Cc: Matt Turner <mattst88@gmail.com>
Cc: Max Filippov <jcmvbkbc@gmail.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Michal Simek <monstr@monstr.eu>
Cc: Nick Hu <nickhu@andestech.com>
Cc: Paul Walmsley <paul.walmsley@sifive.com>
Cc: Richard Weinberger <richard@nod.at>
Cc: Rich Felker <dalias@libc.org>
Cc: Russell King <linux@armlinux.org.uk>
Cc: Stafford Horne <shorne@gmail.com>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Vineet Gupta <vgupta@synopsys.com>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |  104 +++++++++-------------------------------------
 1 file changed, 22 insertions(+), 82 deletions(-)

--- a/mm/page_alloc.c~mm-clean-up-free_area_init_node-and-its-helpers
+++ a/mm/page_alloc.c
@@ -6441,8 +6441,7 @@ static unsigned long __init zone_spanned
 					unsigned long node_start_pfn,
 					unsigned long node_end_pfn,
 					unsigned long *zone_start_pfn,
-					unsigned long *zone_end_pfn,
-					unsigned long *ignored)
+					unsigned long *zone_end_pfn)
 {
 	unsigned long zone_low = arch_zone_lowest_possible_pfn[zone_type];
 	unsigned long zone_high = arch_zone_highest_possible_pfn[zone_type];
@@ -6506,8 +6505,7 @@ unsigned long __init absent_pages_in_ran
 static unsigned long __init zone_absent_pages_in_node(int nid,
 					unsigned long zone_type,
 					unsigned long node_start_pfn,
-					unsigned long node_end_pfn,
-					unsigned long *ignored)
+					unsigned long node_end_pfn)
 {
 	unsigned long zone_low = arch_zone_lowest_possible_pfn[zone_type];
 	unsigned long zone_high = arch_zone_highest_possible_pfn[zone_type];
@@ -6554,43 +6552,9 @@ static unsigned long __init zone_absent_
 	return nr_absent;
 }
 
-static inline unsigned long __init compat_zone_spanned_pages_in_node(int nid,
-					unsigned long zone_type,
-					unsigned long node_start_pfn,
-					unsigned long node_end_pfn,
-					unsigned long *zone_start_pfn,
-					unsigned long *zone_end_pfn,
-					unsigned long *zones_size)
-{
-	unsigned int zone;
-
-	*zone_start_pfn = node_start_pfn;
-	for (zone = 0; zone < zone_type; zone++)
-		*zone_start_pfn += zones_size[zone];
-
-	*zone_end_pfn = *zone_start_pfn + zones_size[zone_type];
-
-	return zones_size[zone_type];
-}
-
-static inline unsigned long __init compat_zone_absent_pages_in_node(int nid,
-						unsigned long zone_type,
-						unsigned long node_start_pfn,
-						unsigned long node_end_pfn,
-						unsigned long *zholes_size)
-{
-	if (!zholes_size)
-		return 0;
-
-	return zholes_size[zone_type];
-}
-
 static void __init calculate_node_totalpages(struct pglist_data *pgdat,
 						unsigned long node_start_pfn,
-						unsigned long node_end_pfn,
-						unsigned long *zones_size,
-						unsigned long *zholes_size,
-						bool compat)
+						unsigned long node_end_pfn)
 {
 	unsigned long realtotalpages = 0, totalpages = 0;
 	enum zone_type i;
@@ -6601,31 +6565,14 @@ static void __init calculate_node_totalp
 		unsigned long spanned, absent;
 		unsigned long size, real_size;
 
-		if (compat) {
-			spanned = compat_zone_spanned_pages_in_node(
-						pgdat->node_id, i,
-						node_start_pfn,
-						node_end_pfn,
-						&zone_start_pfn,
-						&zone_end_pfn,
-						zones_size);
-			absent = compat_zone_absent_pages_in_node(
-						pgdat->node_id, i,
-						node_start_pfn,
-						node_end_pfn,
-						zholes_size);
-		} else {
-			spanned = zone_spanned_pages_in_node(pgdat->node_id, i,
-						node_start_pfn,
-						node_end_pfn,
-						&zone_start_pfn,
-						&zone_end_pfn,
-						zones_size);
-			absent = zone_absent_pages_in_node(pgdat->node_id, i,
-						node_start_pfn,
-						node_end_pfn,
-						zholes_size);
-		}
+		spanned = zone_spanned_pages_in_node(pgdat->node_id, i,
+						     node_start_pfn,
+						     node_end_pfn,
+						     &zone_start_pfn,
+						     &zone_end_pfn);
+		absent = zone_absent_pages_in_node(pgdat->node_id, i,
+						   node_start_pfn,
+						   node_end_pfn);
 
 		size = spanned;
 		real_size = size - absent;
@@ -6947,10 +6894,7 @@ static inline void pgdat_set_deferred_ra
 static inline void pgdat_set_deferred_range(pg_data_t *pgdat) {}
 #endif
 
-static void __init __free_area_init_node(int nid, unsigned long *zones_size,
-					 unsigned long node_start_pfn,
-					 unsigned long *zholes_size,
-					 bool compat)
+static void __init free_area_init_node(int nid)
 {
 	pg_data_t *pgdat = NODE_DATA(nid);
 	unsigned long start_pfn = 0;
@@ -6959,19 +6903,16 @@ static void __init __free_area_init_node
 	/* pg_data_t should be reset to zero when it's allocated */
 	WARN_ON(pgdat->nr_zones || pgdat->kswapd_classzone_idx);
 
+	get_pfn_range_for_nid(nid, &start_pfn, &end_pfn);
+
 	pgdat->node_id = nid;
-	pgdat->node_start_pfn = node_start_pfn;
+	pgdat->node_start_pfn = start_pfn;
 	pgdat->per_cpu_nodestats = NULL;
-	if (!compat) {
-		get_pfn_range_for_nid(nid, &start_pfn, &end_pfn);
-		pr_info("Initmem setup node %d [mem %#018Lx-%#018Lx]\n", nid,
-			(u64)start_pfn << PAGE_SHIFT,
-			end_pfn ? ((u64)end_pfn << PAGE_SHIFT) - 1 : 0);
-	} else {
-		start_pfn = node_start_pfn;
-	}
-	calculate_node_totalpages(pgdat, start_pfn, end_pfn,
-				  zones_size, zholes_size, compat);
+
+	pr_info("Initmem setup node %d [mem %#018Lx-%#018Lx]\n", nid,
+		(u64)start_pfn << PAGE_SHIFT,
+		end_pfn ? ((u64)end_pfn << PAGE_SHIFT) - 1 : 0);
+	calculate_node_totalpages(pgdat, start_pfn, end_pfn);
 
 	alloc_node_mem_map(pgdat);
 	pgdat_set_deferred_range(pgdat);
@@ -6981,7 +6922,7 @@ static void __init __free_area_init_node
 
 void __init free_area_init_memoryless_node(int nid)
 {
-	__free_area_init_node(nid, NULL, 0, NULL, false);
+	free_area_init_node(nid);
 }
 
 #if !defined(CONFIG_FLAT_NODE_MEM_MAP)
@@ -7509,8 +7450,7 @@ void __init free_area_init(unsigned long
 	init_unavailable_mem();
 	for_each_online_node(nid) {
 		pg_data_t *pgdat = NODE_DATA(nid);
-		__free_area_init_node(nid, NULL,
-				      find_min_pfn_for_node(nid), NULL, false);
+		free_area_init_node(nid);
 
 		/* Any memory on that node */
 		if (pgdat->node_present_pages)
_

Patches currently in -mm which might be from rppt@linux.ibm.com are

mm-memblock-replace-dereferences-of-memblock_regionnid-with-api-calls.patch
mm-make-early_pfn_to_nid-and-related-defintions-close-to-each-other.patch
mm-remove-config_have_memblock_node_map-option.patch
mm-free_area_init-use-maximal-zone-pfns-rather-than-zone-sizes.patch
mm-use-free_area_init-instead-of-free_area_init_nodes.patch
alpha-simplify-detection-of-memory-zone-boundaries.patch
arm-simplify-detection-of-memory-zone-boundaries.patch
arm64-simplify-detection-of-memory-zone-boundaries-for-uma-configs.patch
csky-simplify-detection-of-memory-zone-boundaries.patch
m68k-mm-simplify-detection-of-memory-zone-boundaries.patch
parisc-simplify-detection-of-memory-zone-boundaries.patch
sparc32-simplify-detection-of-memory-zone-boundaries.patch
unicore32-simplify-detection-of-memory-zone-boundaries.patch
xtensa-simplify-detection-of-memory-zone-boundaries.patch
mm-remove-early_pfn_in_nid-and-config_nodes_span_other_nodes.patch
mm-free_area_init-allow-defining-max_zone_pfn-in-descending-order.patch
mm-rename-free_area_init_node-to-free_area_init_memoryless_node.patch
mm-clean-up-free_area_init_node-and-its-helpers.patch
mm-simplify-find_min_pfn_with_active_regions.patch
docs-vm-update-memory-models-documentation.patch
