From: akpm@linux-foundation.org
Subject: + mm-exclude-zone_device-from-gfp_zone_table.patch added to -mm
 tree
Date: Fri, 04 Mar 2016 12:18:51 -0800
Message-ID: <56d9edab.a8GYaB+tUEB4npHN%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38487 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759058AbcCDUSw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 Mar 2016 15:18:52 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dan.j.williams@intel.com, dave.hansen@linux.intel.com, iamjoonsoo.kim@lge.com, markk@clara.co.uk, mgorman@suse.de, riel@redhat.com, sudipm.mukherjee@gmail.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: exclude ZONE_DEVICE from GFP_ZONE_TABLE
has been added to the -mm tree.  Its filename is
     mm-exclude-zone_device-from-gfp_zone_table.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-exclude-zone_device-from-gfp_zone_table.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-exclude-zone_device-from-gfp_zone_table.patch

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
Subject: mm: exclude ZONE_DEVICE from GFP_ZONE_TABLE

ZONE_DEVICE (merged in 4.3) and ZONE_CMA (proposed) are examples of new mm
zones that are bumping up against the current maximum limit of 4 zones,
i.e.  2 bits in page->flags for the GFP_ZONE_TABLE.

The GFP_ZONE_TABLE poses an interesting constraint since
include/linux/gfp.h gets included by the 32-bit portion of a 64-bit build.
We need to be careful to only build the table for zones that have a
corresponding gfp_t flag.  GFP_ZONES_SHIFT is introduced for this purpose.
This patch does not attempt to solve the problem of adding a new zone
that also has a corresponding GFP_ flag.

Vlastimil points out that ZONE_DEVICE, by depending on x86_64 and
SPARSEMEM_VMEMMAP implies that SECTIONS_WIDTH is zero.  In other words
even though ZONE_DEVICE does not fit in GFP_ZONE_TABLE it is free to
consume another bit in page->flags (expand ZONES_WIDTH) with room to
spare.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=110931
Fixes: 033fbae988fc ("mm: ZONE_DEVICE for "device memory"")
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Reported-by: Mark <markk@clara.co.uk>
Reported-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Rik van Riel <riel@redhat.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/gfp.h               |   33 ++++++++++++++++------------
 include/linux/page-flags-layout.h |    2 +
 mm/Kconfig                        |    2 -
 3 files changed, 22 insertions(+), 15 deletions(-)

diff -puN include/linux/gfp.h~mm-exclude-zone_device-from-gfp_zone_table include/linux/gfp.h
--- a/include/linux/gfp.h~mm-exclude-zone_device-from-gfp_zone_table
+++ a/include/linux/gfp.h
@@ -331,22 +331,29 @@ static inline bool gfpflags_allow_blocki
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
+	(ZONE_NORMAL << 0 * GFP_ZONES_SHIFT)				       \
+	| (OPT_ZONE_DMA << ___GFP_DMA * GFP_ZONES_SHIFT)		       \
+	| (OPT_ZONE_HIGHMEM << ___GFP_HIGHMEM * GFP_ZONES_SHIFT)	       \
+	| (OPT_ZONE_DMA32 << ___GFP_DMA32 * GFP_ZONES_SHIFT)		       \
+	| (ZONE_NORMAL << ___GFP_MOVABLE * GFP_ZONES_SHIFT)		       \
+	| (OPT_ZONE_DMA << (___GFP_MOVABLE | ___GFP_DMA) * GFP_ZONES_SHIFT)    \
+	| (ZONE_MOVABLE << (___GFP_MOVABLE | ___GFP_HIGHMEM) * GFP_ZONES_SHIFT)\
+	| (OPT_ZONE_DMA32 << (___GFP_MOVABLE | ___GFP_DMA32) * GFP_ZONES_SHIFT)\
 )
 
 /*
@@ -371,8 +378,8 @@ static inline enum zone_type gfp_zone(gf
 	enum zone_type z;
 	int bit = (__force int) (flags & GFP_ZONEMASK);
 
-	z = (GFP_ZONE_TABLE >> (bit * ZONES_SHIFT)) &
-					 ((1 << ZONES_SHIFT) - 1);
+	z = (GFP_ZONE_TABLE >> (bit * GFP_ZONES_SHIFT)) &
+					 ((1 << GFP_ZONES_SHIFT) - 1);
 	VM_BUG_ON((GFP_ZONE_BAD >> bit) & 1);
 	return z;
 }
diff -puN include/linux/page-flags-layout.h~mm-exclude-zone_device-from-gfp_zone_table include/linux/page-flags-layout.h
--- a/include/linux/page-flags-layout.h~mm-exclude-zone_device-from-gfp_zone_table
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
diff -puN mm/Kconfig~mm-exclude-zone_device-from-gfp_zone_table mm/Kconfig
--- a/mm/Kconfig~mm-exclude-zone_device-from-gfp_zone_table
+++ a/mm/Kconfig
@@ -651,8 +651,6 @@ config IDLE_PAGE_TRACKING
 
 config ZONE_DEVICE
 	bool "Device memory (pmem, etc...) hotplug support" if EXPERT
-	default !ZONE_DMA
-	depends on !ZONE_DMA
 	depends on MEMORY_HOTPLUG
 	depends on MEMORY_HOTREMOVE
 	depends on X86_64 #arch_add_memory() comprehends device memory
_

Patches currently in -mm which might be from dan.j.williams@intel.com are

list-kill-list_force_poison.patch
mm-fix-mixed-zone-detection-in-devm_memremap_pages.patch
mm-exclude-zone_device-from-gfp_zone_table.patch

