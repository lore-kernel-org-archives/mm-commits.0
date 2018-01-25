From: akpm@linux-foundation.org
Subject: +
 fix-explanation-of-lower-bits-in-the-sparsemem-mem_map-pointer-v2.patch
 added to -mm tree
Date: Thu, 25 Jan 2018 14:43:22 -0800
Message-ID: <5a6a5d8a.gS2f3A0uMQwrPHMa%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46824 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751238AbeAYWnX (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 25 Jan 2018 17:43:23 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ptesarik@suse.com, aryabinin@virtuozzo.com, hannes@cmpxchg.org, kemi.wang@intel.com, mgorman@techsingularity.net, mhocko@suse.com, vbabka@suse.cz, yasu.isimatu@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: fix-explanation-of-lower-bits-in-the-sparsemem-mem_map-pointer-v2
has been added to the -mm tree.  Its filename is
     fix-explanation-of-lower-bits-in-the-sparsemem-mem_map-pointer-v2.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fix-explanation-of-lower-bits-in-the-sparsemem-mem_map-pointer-v2.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fix-explanation-of-lower-bits-in-the-sparsemem-mem_map-pointer-v2.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
fix-explanation-of-lower-bits-in-the-sparsemem-mem_map-pointer-v2.patch

