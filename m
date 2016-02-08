From: akpm@linux-foundation.org
Subject: + mm-config_nr_zones_extended.patch added to -mm tree
Date: Mon, 08 Feb 2016 15:20:59 -0800
Message-ID: <56b922db.60+T4vZgqbNQt30n%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46832 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753152AbcBHXVA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Feb 2016 18:21:00 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dan.j.williams@intel.com, dave.hansen@linux.intel.com, iamjoonsoo.kim@lge.com, markk@clara.co.uk, mgorman@suse.de, riel@redhat.com, sudipm.mukherjee@gmail.com, mm-commits@vger.kernel.org


The patch titled
     From: Dan Williams <dan.j.williams@intel.com>
has been added to the -mm tree.  Its filename is
     mm-config_nr_zones_extended.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-config_nr_zones_extended.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-config_nr_zones_extended.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Dan Williams <dan.j.williams@intel.com>
Subject: mm: CONFIG_NR_ZONES_EXTENDED

ZONE_DEVICE (merged in 4.3) and ZONE_CMA (proposed) are examples of new mm
zones that are bumping up against the current maximum limit of 4 zones,
i.e.  2 bits in page->flags.  When adding a zone this equation still needs
to be satisified:

    SECTIONS_WIDTH + ZONES_WIDTH + NODES_SHIFT + LAST_CPUPID_SHIFT
	  <= BITS_PER_LONG - NR_PAGEFLAGS

ZONE_DEVICE currently tries to satisfy this equation by requiring that
ZONE_DMA be disabled, but this is untenable given generic kernels want to
support ZONE_DEVICE and ZONE_DMA simultaneously.  ZONE_CMA would like to
increase the amount of memory covered per section, but that limits the
minimum granularity at which consecutive memory ranges can be added via
devm_memremap_pages().

The trade-off of what is acceptable to sacrifice depends heavily on the
platform.  For example, ZONE_CMA is targeted for 32-bit platforms where
page->flags is constrained, but those platforms likely do not care about
the minimum granularity of memory hotplug.  A big iron machine with 1024
numa nodes can likely sacrifice ZONE_DMA where a general purpose
distribution kernel can not.

CONFIG_NR_ZONES_EXTENDED is a configuration symbol that gets selected when
the number of configured zones exceeds 4.  It documents the configuration
symbols and definitions that get modified when ZONES_WIDTH is greater than
2.

For now, it steals a bit from NODES_SHIFT.  Later on it can be used to
document the definitions that get modified when a 32-bit configuration
wants more zone bits.

Note that GFP_ZONE_TABLE poses an interesting constraint since
include/linux/gfp.h gets included by the 32-bit portion of a 64-bit build.
We need to be careful to only build the table for zones that have a
corresponding gfp_t flag.  GFP_ZONES_SHIFT is introduced for this purpose.
This patch does not attempt to solve the problem of adding a new zone
that also has a corresponding GFP_ flag.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=110931
Fixes: 033fbae988fc ("mm: ZONE_DEVICE for "device memory"")
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Reported-by: Mark <markk@clara.co.uk>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Rik van Riel <riel@redhat.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/Kconfig                  |    6 +++--
 include/linux/gfp.h               |   33 ++++++++++++++++------------
 include/linux/page-flags-layout.h |    2 +
 mm/Kconfig                        |    7 ++++-
 4 files changed, 31 insertions(+), 17 deletions(-)

diff -puN arch/x86/Kconfig~mm-config_nr_zones_extended arch/x86/Kconfig
--- a/arch/x86/Kconfig~mm-config_nr_zones_extended
+++ a/arch/x86/Kconfig
@@ -1408,8 +1408,10 @@ config NUMA_EMU
 
 config NODES_SHIFT
 	int "Maximum NUMA Nodes (as a power of 2)" if !MAXSMP
-	range 1 10
-	default "10" if MAXSMP
+	range 1 10 if !NR_ZONES_EXTENDED
+	range 1 9 if NR_ZONES_EXTENDED
+	default "10" if MAXSMP && !NR_ZONES_EXTENDED
+	default "9" if MAXSMP && NR_ZONES_EXTENDED
 	default "6" if X86_64
 	default "3"
 	depends on NEED_MULTIPLE_NODES
diff -puN include/linux/gfp.h~mm-config_nr_zones_extended include/linux/gfp.h
--- a/include/linux/gfp.h~mm-config_nr_zones_extended
+++ a/include/linux/gfp.h
@@ -333,22 +333,29 @@ static inline bool gfpflags_allow_blocki
  *       0xe    => BAD (MOVABLE+DMA32+HIGHMEM)
  *       0xf    => BAD (MOVABLE+DMA32+HIGHMEM+DMA)
  *
- * ZONES_SHIFT must be <= 2 on 32 bit platforms.
+ * GFP_ZONES_SHIFT must be <= 2 on 32 bit platforms.
  */
 
-#if 16 * ZONES_SHIFT > BITS_PER_LONG
-#error ZONES_SHIFT too large to create GFP_ZONE_TABLE integer
+#if defined(CONFIG_ZONE_DEVICE) && (MAX_NR_ZONES-1) <= 4
+/* ZONE_DEVICE is not a valid GFP zone specifier */
+#define GFP_ZONES_SHIFT 2
+#else
+#define GFP_ZONES_SHIFT ZONES_SHIFT
+#endif
+
+#if 16 * GFP_ZONES_SHIFT > BITS_PER_LONG
+#error GFP_ZONES_SHIFT too large to create GFP_ZONE_TABLE integer
 #endif
 
 #define GFP_ZONE_TABLE ( \
-	(ZONE_NORMAL << 0 * ZONES_SHIFT)				      \
-	| (OPT_ZONE_DMA << ___GFP_DMA * ZONES_SHIFT)			      \
-	| (OPT_ZONE_HIGHMEM << ___GFP_HIGHMEM * ZONES_SHIFT)		      \
-	| (OPT_ZONE_DMA32 << ___GFP_DMA32 * ZONES_SHIFT)		      \
-	| (ZONE_NORMAL << ___GFP_MOVABLE * ZONES_SHIFT)			      \
-	| (OPT_ZONE_DMA << (___GFP_MOVABLE | ___GFP_DMA) * ZONES_SHIFT)	      \
-	| (ZONE_MOVABLE << (___GFP_MOVABLE | ___GFP_HIGHMEM) * ZONES_SHIFT)   \
-	| (OPT_ZONE_DMA32 << (___GFP_MOVABLE | ___GFP_DMA32) * ZONES_SHIFT)   \
+	(ZONE_NORMAL << 0 * GFP_ZONES_SHIFT)					\
+	| (OPT_ZONE_DMA << ___GFP_DMA * GFP_ZONES_SHIFT)			\
+	| (OPT_ZONE_HIGHMEM << ___GFP_HIGHMEM * GFP_ZONES_SHIFT)		\
+	| (OPT_ZONE_DMA32 << ___GFP_DMA32 * GFP_ZONES_SHIFT)		      	\
+	| (ZONE_NORMAL << ___GFP_MOVABLE * GFP_ZONES_SHIFT)			\
+	| (OPT_ZONE_DMA << (___GFP_MOVABLE | ___GFP_DMA) * GFP_ZONES_SHIFT)	\
+	| (ZONE_MOVABLE << (___GFP_MOVABLE | ___GFP_HIGHMEM) * GFP_ZONES_SHIFT)	\
+	| (OPT_ZONE_DMA32 << (___GFP_MOVABLE | ___GFP_DMA32) * GFP_ZONES_SHIFT)	\
 )
 
 /*
@@ -373,8 +380,8 @@ static inline enum zone_type gfp_zone(gf
 	enum zone_type z;
 	int bit = (__force int) (flags & GFP_ZONEMASK);
 
-	z = (GFP_ZONE_TABLE >> (bit * ZONES_SHIFT)) &
-					 ((1 << ZONES_SHIFT) - 1);
+	z = (GFP_ZONE_TABLE >> (bit * GFP_ZONES_SHIFT)) &
+					 ((1 << GFP_ZONES_SHIFT) - 1);
 	VM_BUG_ON((GFP_ZONE_BAD >> bit) & 1);
 	return z;
 }
diff -puN include/linux/page-flags-layout.h~mm-config_nr_zones_extended include/linux/page-flags-layout.h
--- a/include/linux/page-flags-layout.h~mm-config_nr_zones_extended
+++ a/include/linux/page-flags-layout.h
@@ -17,6 +17,8 @@
 #define ZONES_SHIFT 1
 #elif MAX_NR_ZONES <= 4
 #define ZONES_SHIFT 2
+#elif MAX_NR_ZONES <= 8
+#define ZONES_SHIFT 3
 #else
 #error ZONES_SHIFT -- too many zones configured adjust calculation
 #endif
diff -puN mm/Kconfig~mm-config_nr_zones_extended mm/Kconfig
--- a/mm/Kconfig~mm-config_nr_zones_extended
+++ a/mm/Kconfig
@@ -652,8 +652,6 @@ config IDLE_PAGE_TRACKING
 
 config ZONE_DEVICE
 	bool "Device memory (pmem, etc...) hotplug support" if EXPERT
-	default !ZONE_DMA
-	depends on !ZONE_DMA
 	depends on MEMORY_HOTPLUG
 	depends on MEMORY_HOTREMOVE
 	depends on X86_64 #arch_add_memory() comprehends device memory
@@ -667,5 +665,10 @@ config ZONE_DEVICE
 
 	  If FS_DAX is enabled, then say Y.
 
+config NR_ZONES_EXTENDED
+	bool
+	default n if !64BIT
+	default y if ZONE_DEVICE && ZONE_DMA && ZONE_DMA32
+
 config FRAME_VECTOR
 	bool
_

Patches currently in -mm which might be from dan.j.williams@intel.com are

mm-config_nr_zones_extended.patch

