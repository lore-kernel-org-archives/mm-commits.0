From: akpm@linux-foundation.org
Subject: [folded-merged]
 fix-explanation-of-lower-bits-in-the-sparsemem-mem_map-pointer-v2.patch
 removed from -mm tree
Date: Wed, 31 Jan 2018 16:06:37 -0800
Message-ID: <5a725a0d.QqfOyJkiJpDBGnWc%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58720 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753472AbeBAAGi (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 31 Jan 2018 19:06:38 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ptesarik@suse.com, aryabinin@virtuozzo.com, hannes@cmpxchg.org, kemi.wang@intel.com, mgorman@techsingularity.net, mhocko@suse.com, vbabka@suse.cz, yasu.isimatu@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: fix-explanation-of-lower-bits-in-the-sparsemem-mem_map-pointer-v2
has been removed from the -mm tree.  Its filename was
     fix-explanation-of-lower-bits-in-the-sparsemem-mem_map-pointer-v2.patch

This patch was dropped because it was folded into fix-explanation-of-lower-bits-in-the-sparsemem-mem_map-pointer.patch

------------------------------------------------------
From: Petr Tesarik <ptesarik@suse.com>
Subject: fix-explanation-of-lower-bits-in-the-sparsemem-mem_map-pointer-v2

Link: http://lkml.kernel.org/r/20180125100516.589ea6af@ezekiel.suse.cz
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

 mm/sparse.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff -puN mm/sparse.c~fix-explanation-of-lower-bits-in-the-sparsemem-mem_map-pointer-v2 mm/sparse.c
--- a/mm/sparse.c~fix-explanation-of-lower-bits-in-the-sparsemem-mem_map-pointer-v2
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

Patches currently in -mm which might be from ptesarik@suse.com are

fix-explanation-of-lower-bits-in-the-sparsemem-mem_map-pointer.patch

