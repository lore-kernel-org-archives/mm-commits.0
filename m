From: akpm@linux-foundation.org
Subject: [patch 103/119] include/linux/mmzone.h: fix explanation of
 lower bits in the SPARSEMEM mem_map pointer
Date: Wed, 31 Jan 2018 16:20:26 -0800
Message-ID: <20180201002026.SeUh-T9-l%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36326 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754559AbeBAAU2 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 31 Jan 2018 19:20:28 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, aryabinin@virtuozzo.com, hannes@cmpxchg.org, kemi.wang@intel.com, mgorman@techsingularity.net, mhocko@suse.com, mm-commits@vger.kernel.org, ptesarik@suse.com, torvalds@linux-foundation.org, vbabka@suse.cz, yasu.isimatu@gmail.com

From: Petr Tesarik <ptesarik@suse.com>
Subject: include/linux/mmzone.h: fix explanation of lower bits in the SPARSEMEM mem_map pointer

The comment is confusing.  On the one hand, it refers to 32-bit alignment
(struct page alignment on 32-bit platforms), but this would only guarantee
that the 2 lowest bits must be zero.  On the other hand, it claims that at
least 3 bits are available, and 3 bits are actually used.

This is not broken, because there is a stronger alignment guarantee, just
less obvious.  Let's fix the comment to make it clear how many bits are
available and why.

Although memmap arrays are allocated in various places, the resulting
pointer is encoded eventually, so I am adding a BUG_ON() here to enforce
at runtime that all expected bits are indeed available.

I have also added a BUILD_BUG_ON to check that PFN_SECTION_SHIFT is
sufficient, because this part of the calculation can be easily checked at
build time.

[ptesarik@suse.com: v2]
  Link: http://lkml.kernel.org/r/20180125100516.589ea6af@ezekiel.suse.cz
Link: http://lkml.kernel.org/r/20180119080908.3a662e6f@ezekiel.suse.cz
Signed-off-by: Petr Tesarik <ptesarik@suse.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kemi Wang <kemi.wang@intel.com>
Cc: YASUAKI ISHIMATSU <yasu.isimatu@gmail.com>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h |   12 ++++++++++--
 mm/sparse.c            |    6 +++++-
 2 files changed, 15 insertions(+), 3 deletions(-)

diff -puN include/linux/mmzone.h~fix-explanation-of-lower-bits-in-the-sparsemem-mem_map-pointer include/linux/mmzone.h
--- a/include/linux/mmzone.h~fix-explanation-of-lower-bits-in-the-sparsemem-mem_map-pointer
+++ a/include/linux/mmzone.h
@@ -1166,8 +1166,16 @@ extern unsigned long usemap_size(void);
 
 /*
  * We use the lower bits of the mem_map pointer to store
- * a little bit of information.  There should be at least
- * 3 bits here due to 32-bit alignment.
+ * a little bit of information.  The pointer is calculated
+ * as mem_map - section_nr_to_pfn(pnum).  The result is
+ * aligned to the minimum alignment of the two values:
+ *   1. All mem_map arrays are page-aligned.
+ *   2. section_nr_to_pfn() always clears PFN_SECTION_SHIFT
+ *      lowest bits.  PFN_SECTION_SHIFT is arch-specific
+ *      (equal SECTION_SIZE_BITS - PAGE_SHIFT), and the
+ *      worst combination is powerpc with 256k pages,
+ *      which results in PFN_SECTION_SHIFT equal 6.
+ * To sum it up, at least 6 bits are available.
  */
 #define	SECTION_MARKED_PRESENT	(1UL<<0)
 #define SECTION_HAS_MEM_MAP	(1UL<<1)
diff -puN mm/sparse.c~fix-explanation-of-lower-bits-in-the-sparsemem-mem_map-pointer mm/sparse.c
--- a/mm/sparse.c~fix-explanation-of-lower-bits-in-the-sparsemem-mem_map-pointer
+++ a/mm/sparse.c
@@ -264,7 +264,11 @@ unsigned long __init node_memmap_size_by
  */
 static unsigned long sparse_encode_mem_map(struct page *mem_map, unsigned long pnum)
 {
-	return (unsigned long)(mem_map - (section_nr_to_pfn(pnum)));
+	unsigned long coded_mem_map =
+		(unsigned long)(mem_map - (section_nr_to_pfn(pnum)));
+	BUILD_BUG_ON(SECTION_MAP_LAST_BIT > (1UL<<PFN_SECTION_SHIFT));
+	BUG_ON(coded_mem_map & ~SECTION_MAP_MASK);
+	return coded_mem_map;
 }
 
 /*
_
