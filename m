From: akpm@linux-foundation.org
Subject: [-]
 =?US-ASCII?Q?mm-pgmap-use-correct-alignment-when-looking-at-first-pfn-fro?=
 =?US-ASCII?Q?m-a-region.patch?= removed from -mm tree
Date: Thu, 30 Jan 2020 20:27:19 -0800
Message-ID: <20200131042719.kaN60pupK%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:34622 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727448AbgAaE1V (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 30 Jan 2020 23:27:21 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aneesh.kumar@linux.ibm.com, dan.j.williams@intel.com, mm-commits@vger.kernel.org, rcampbell@nvidia.com


The patch titled
     Subject: mm/pgmap: use correct alignment when looking at first pfn from a region
has been removed from the -mm tree.  Its filename was
     mm-pgmap-use-correct-alignment-when-looking-at-first-pfn-from-a-region.patch

This patch was dropped because lack of interest

------------------------------------------------------
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
Subject: mm/pgmap: use correct alignment when looking at first pfn from a region

vmem_altmap_offset() adjusts the section aligned base_pfn offset.  So we
need to make sure we account for the same when computing base_pfn.

ie, for altmap_valid case, our pfn_first should be:

pfn_first = altmap->base_pfn + vmem_altmap_offset(altmap);

This was found by code inspection. If the pmem region is not correctly
section aligned we can skip pfns while iterating device pfn using 

	for_each_device_pfn(pfn, pgmap)

[akpm@linux-foundation.org: coding style fixes]
Link: http://lkml.kernel.org/r/20190917153129.12905-1-aneesh.kumar@linux.ibm.com
Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Cc: Ralph Campbell <rcampbell@nvidia.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memremap.c |   12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

--- a/mm/memremap.c~mm-pgmap-use-correct-alignment-when-looking-at-first-pfn-from-a-region
+++ a/mm/memremap.c
@@ -56,8 +56,16 @@ static void pgmap_array_delete(struct re
 
 static unsigned long pfn_first(struct dev_pagemap *pgmap)
 {
-	return PHYS_PFN(pgmap->res.start) +
-		vmem_altmap_offset(pgmap_altmap(pgmap));
+	const struct resource *res = &pgmap->res;
+	struct vmem_altmap *altmap = pgmap_altmap(pgmap);
+	unsigned long pfn;
+
+	if (altmap)
+		pfn = altmap->base_pfn + vmem_altmap_offset(altmap);
+	else
+		pfn = PHYS_PFN(res->start);
+
+	return pfn;
 }
 
 static unsigned long pfn_end(struct dev_pagemap *pgmap)
_

Patches currently in -mm which might be from aneesh.kumar@linux.ibm.com are

mm-memmap_init-update-variable-name-in-memmap_init_zone.patch
