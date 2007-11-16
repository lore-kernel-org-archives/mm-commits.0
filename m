From: akpm@linux-foundation.org
Subject: + fix-boot-problem-with-iseries-lacking-hugepage-support.patch added to -mm tree
Date: Thu, 15 Nov 2007 19:26:11 -0800
Message-ID: <200711160326.lAG3QBa2030760@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52879 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1764755AbXKPD0U (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Nov 2007 22:26:20 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mel@csn.ul.ie, benh@kernel.crashing.org, paulus@samba.org, sfr@canb.auug.org.au


The patch titled
     Fix boot problem with iSeries lacking hugepage support
has been added to the -mm tree.  Its filename is
     fix-boot-problem-with-iseries-lacking-hugepage-support.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Fix boot problem with iSeries lacking hugepage support
From: mel@skynet.ie (Mel Gorman)

Ordinarily the size of a pageblock is determined at compile-time based on the
hugepage size. On PPC64, the hugepage size is determined at runtime based on
what is supported by the machine. With legacy machines such as iSeries that
do not support hugepages, HPAGE_SHIFT is 0. This results in pageblock_order
being set to -PAGE_SHIFT and a crash results shortly afterwards.

This patch adds a function to select a sensible value for pageblock order by
default when HUGETLB_PAGE_SIZE_VARIABLE is set. It checks that HPAGE_SHIFT
is a sensible value before using the hugepage size; if it is not MAX_ORDER-1
is used.

This is a fix for 2.6.24.

Credit goes to Stephen Rothwell for identifying the bug and testing candidate
patches.  Additional credit goes to Andy Whitcroft for spotting a problem
with respects to IA-64 before releasing. Additional credit to David Gibson
for testing with the libhugetlbfs test suite.

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
Tested-by: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/Kconfig |    5 +++++
 mm/page_alloc.c      |   23 +++++++++++++++++++++--
 2 files changed, 26 insertions(+), 2 deletions(-)

diff -puN arch/powerpc/Kconfig~fix-boot-problem-with-iseries-lacking-hugepage-support arch/powerpc/Kconfig
--- a/arch/powerpc/Kconfig~fix-boot-problem-with-iseries-lacking-hugepage-support
+++ a/arch/powerpc/Kconfig
@@ -187,6 +187,11 @@ config FORCE_MAX_ZONEORDER
 	default "9" if PPC_64K_PAGES
 	default "13"
 
+config HUGETLB_PAGE_SIZE_VARIABLE
+	bool
+	depends on HUGETLB_PAGE
+	default y
+
 config MATH_EMULATION
 	bool "Math emulation"
 	depends on 4xx || 8xx || E200 || PPC_MPC832x || E500
diff -puN mm/page_alloc.c~fix-boot-problem-with-iseries-lacking-hugepage-support mm/page_alloc.c
--- a/mm/page_alloc.c~fix-boot-problem-with-iseries-lacking-hugepage-support
+++ a/mm/page_alloc.c
@@ -3266,6 +3266,16 @@ static void inline setup_usemap(struct p
 #endif /* CONFIG_SPARSEMEM */
 
 #ifdef CONFIG_HUGETLB_PAGE_SIZE_VARIABLE
+
+/* Return a sensible default order for the pageblock size. */
+static inline int pageblock_default_order(void)
+{
+	if (HPAGE_SHIFT > PAGE_SHIFT)
+		return HUGETLB_PAGE_ORDER;
+
+	return MAX_ORDER-1;
+}
+
 /* Initialise the number of pages represented by NR_PAGEBLOCK_BITS */
 static inline void __init set_pageblock_order(unsigned int order)
 {
@@ -3281,7 +3291,16 @@ static inline void __init set_pageblock_
 }
 #else /* CONFIG_HUGETLB_PAGE_SIZE_VARIABLE */
 
-/* Defined this way to avoid accidently referencing HUGETLB_PAGE_ORDER */
+/*
+ * When CONFIG_HUGETLB_PAGE_SIZE_VARIABLE is not set, set_pageblock_order()
+ * and pageblock_default_order() are unused as pageblock_order is set
+ * at compile-time. See include/linux/pageblock-flags.h for the values of
+ * pageblock_order based on the kernel config
+ */
+static inline int pageblock_default_order(unsigned int order)
+{
+	return MAX_ORDER-1;
+}
 #define set_pageblock_order(x)	do {} while (0)
 
 #endif /* CONFIG_HUGETLB_PAGE_SIZE_VARIABLE */
@@ -3366,7 +3385,7 @@ static void __meminit free_area_init_cor
 		if (!size)
 			continue;
 
-		set_pageblock_order(HUGETLB_PAGE_ORDER);
+		set_pageblock_order(pageblock_default_order());
 		setup_usemap(pgdat, zone, size);
 		ret = init_currently_empty_zone(zone, zone_start_pfn,
 						size, MEMMAP_EARLY);
_

Patches currently in -mm which might be from mel@csn.ul.ie are

origin.patch
fix-boot-problem-with-iseries-lacking-hugepage-support.patch
fix-build-failure-when-config_infiniband_ipoib_cm-is-not-defined.patch
mem-policy-fix-mempolicy-usage-in-pci-driver.patch
memory-hotplug-add-removable-to-sysfs-to-show-memblock-removability.patch
page-allocator-clean-up-pcp-draining-functions.patch
page-allocator-get-rid-of-the-list-of-cold-pages.patch
page-allocator-get-rid-of-the-list-of-cold-pages-fix.patch
page-owner-tracking-leak-detector.patch
add-debugging-aid-for-memory-initialisation-problems.patch
