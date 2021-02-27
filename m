Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63FA9C433E6
	for <mm-commits@archiver.kernel.org>; Sat, 27 Feb 2021 02:30:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2B79B64F31
	for <mm-commits@archiver.kernel.org>; Sat, 27 Feb 2021 02:30:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230124AbhB0Cap (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 26 Feb 2021 21:30:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:51610 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230122AbhB0CaT (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 26 Feb 2021 21:30:19 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8E21E64F37;
        Sat, 27 Feb 2021 02:29:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614392960;
        bh=A3tJUrq1WHFcrFWjGk6zTxJ+oTZdogIq4d11S53Gpu8=;
        h=Date:From:To:Subject:From;
        b=kAozVT2378MmSKM+tP4C1Bd5pD7PRyHnpmnQ2oGYUPv6W5H7xsUCpLaYrcCw5hLYa
         L1E84oJG/v2yc8oSuouGP7jxFBBKsbLVU5oHNc58x3iFSHXlhWGDMFxkpGoA8C/QDL
         b08Psgcr916SCXYMEpPBoC4JTKAqZ9uo6hqPt2jo=
Date:   Fri, 26 Feb 2021 18:29:20 -0800
From:   akpm@linux-foundation.org
To:     cai@lca.pw, dan.j.williams@intel.com, david@redhat.com,
        mhocko@suse.com, mm-commits@vger.kernel.org,
        naoya.horiguchi@nec.com, osalvador@suse.de
Subject:  [merged]
 mm-fix-memory_failure-handling-of-dax-namespace-metadata.patch removed from
 -mm tree
Message-ID: <20210227022920.81Usi-cGD%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: fix memory_failure() handling of dax-namespace metadata
has been removed from the -mm tree.  Its filename was
     mm-fix-memory_failure-handling-of-dax-namespace-metadata.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Dan Williams <dan.j.williams@intel.com>
Subject: mm: fix memory_failure() handling of dax-namespace metadata

Given 'struct dev_pagemap' spans both data pages and metadata pages be
careful to consult the altmap if present to delineate metadata.  In fact
the pfn_first() helper already identifies the first valid data pfn, so
export that helper for other code paths via pgmap_pfn_valid().

Other usage of get_dev_pagemap() are not a concern because those are
operating on known data pfns having been looked up by get_user_pages(). 
I.e.  metadata pfns are never user mapped.

Link: https://lkml.kernel.org/r/161058501758.1840162.4239831989762604527.stgit@dwillia2-desk3.amr.corp.intel.com
Fixes: 6100e34b2526 ("mm, memory_failure: Teach memory_failure() about dev_pagemap pages")
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Reported-by: David Hildenbrand <david@redhat.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Qian Cai <cai@lca.pw>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memremap.h |    6 ++++++
 mm/memory-failure.c      |    6 ++++++
 mm/memremap.c            |   15 +++++++++++++++
 3 files changed, 27 insertions(+)

--- a/include/linux/memremap.h~mm-fix-memory_failure-handling-of-dax-namespace-metadata
+++ a/include/linux/memremap.h
@@ -137,6 +137,7 @@ void *devm_memremap_pages(struct device
 void devm_memunmap_pages(struct device *dev, struct dev_pagemap *pgmap);
 struct dev_pagemap *get_dev_pagemap(unsigned long pfn,
 		struct dev_pagemap *pgmap);
+bool pgmap_pfn_valid(struct dev_pagemap *pgmap, unsigned long pfn);
 
 unsigned long vmem_altmap_offset(struct vmem_altmap *altmap);
 void vmem_altmap_free(struct vmem_altmap *altmap, unsigned long nr_pfns);
@@ -165,6 +166,11 @@ static inline struct dev_pagemap *get_de
 	return NULL;
 }
 
+static inline bool pgmap_pfn_valid(struct dev_pagemap *pgmap, unsigned long pfn)
+{
+	return false;
+}
+
 static inline unsigned long vmem_altmap_offset(struct vmem_altmap *altmap)
 {
 	return 0;
--- a/mm/memory-failure.c~mm-fix-memory_failure-handling-of-dax-namespace-metadata
+++ a/mm/memory-failure.c
@@ -1312,6 +1312,12 @@ static int memory_failure_dev_pagemap(un
 		 */
 		put_page(page);
 
+	/* device metadata space is not recoverable */
+	if (!pgmap_pfn_valid(pgmap, pfn)) {
+		rc = -ENXIO;
+		goto out;
+	}
+
 	/*
 	 * Prevent the inode from being freed while we are interrogating
 	 * the address_space, typically this would be handled by
--- a/mm/memremap.c~mm-fix-memory_failure-handling-of-dax-namespace-metadata
+++ a/mm/memremap.c
@@ -80,6 +80,21 @@ static unsigned long pfn_first(struct de
 	return pfn + vmem_altmap_offset(pgmap_altmap(pgmap));
 }
 
+bool pgmap_pfn_valid(struct dev_pagemap *pgmap, unsigned long pfn)
+{
+	int i;
+
+	for (i = 0; i < pgmap->nr_range; i++) {
+		struct range *range = &pgmap->ranges[i];
+
+		if (pfn >= PHYS_PFN(range->start) &&
+		    pfn <= PHYS_PFN(range->end))
+			return pfn >= pfn_first(pgmap, i);
+	}
+
+	return false;
+}
+
 static unsigned long pfn_end(struct dev_pagemap *pgmap, int range_id)
 {
 	const struct range *range = &pgmap->ranges[range_id];
_

Patches currently in -mm which might be from dan.j.williams@intel.com are


