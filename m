Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLACK
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01125C433DB
	for <mm-commits@archiver.kernel.org>; Sun, 17 Jan 2021 22:01:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C0F04207DE
	for <mm-commits@archiver.kernel.org>; Sun, 17 Jan 2021 22:01:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730122AbhAQWBe (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 17 Jan 2021 17:01:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:58854 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729956AbhAQWB1 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 17 Jan 2021 17:01:27 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 904512250E;
        Sun, 17 Jan 2021 22:00:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1610920847;
        bh=ww5TyybtvzNkS8SkzTK9PEIky5yisNDk3ww5wJUoqHg=;
        h=Date:From:To:Subject:From;
        b=Zt1OQ9u3wa2vvk8w6+QWV018UXQfr8SkJCgovQYqMy9n7diJ30UR/+tpM+2NG0kLN
         haJYBrPO9z2+T5+73LOkvWlkQNMhs1h7vRvE+b87ySGfQd2rAsCTq2EzFnGjTM+IOB
         cWPmN2TIbu3wFDs4YW5dxN1H+Q8OdVbqXTxeiQdM=
Date:   Sun, 17 Jan 2021 14:00:45 -0800
From:   akpm@linux-foundation.org
To:     cai@lca.pw, dan.j.williams@intel.com, david@redhat.com,
        mhocko@suse.com, mm-commits@vger.kernel.org,
        naoya.horiguchi@nec.com, osalvador@suse.de
Subject:  +
 mm-fix-memory_failure-handling-of-dax-namespace-metadata.patch added to -mm
 tree
Message-ID: <20210117220045.kuII7KOcO%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: fix memory_failure() handling of dax-namespace metadata
has been added to the -mm tree.  Its filename is
     mm-fix-memory_failure-handling-of-dax-namespace-metadata.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-fix-memory_failure-handling-of-dax-namespace-metadata.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-fix-memory_failure-handling-of-dax-namespace-metadata.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Cc: Naoya Horiguchi <naoya.horiguchi@nec.com>
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
@@ -138,6 +138,7 @@ void *devm_memremap_pages(struct device
 void devm_memunmap_pages(struct device *dev, struct dev_pagemap *pgmap);
 struct dev_pagemap *get_dev_pagemap(unsigned long pfn,
 		struct dev_pagemap *pgmap);
+bool pgmap_pfn_valid(struct dev_pagemap *pgmap, unsigned long pfn);
 
 unsigned long vmem_altmap_offset(struct vmem_altmap *altmap);
 void vmem_altmap_free(struct vmem_altmap *altmap, unsigned long nr_pfns);
@@ -171,6 +172,11 @@ static inline struct dev_pagemap *get_de
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
@@ -1308,6 +1308,12 @@ static int memory_failure_dev_pagemap(un
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

mm-fix-page-reference-leak-in-soft_offline_page.patch
mm-move-pfn_to_online_page-out-of-line.patch
mm-teach-pfn_to_online_page-to-consider-subsection-validity.patch
mm-teach-pfn_to_online_page-about-zone_device-section-collisions.patch
mm-fix-memory_failure-handling-of-dax-namespace-metadata.patch

