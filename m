Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F534C433FE
	for <mm-commits@archiver.kernel.org>; Thu,  2 Dec 2021 21:32:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243217AbhLBVgL (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 2 Dec 2021 16:36:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377097AbhLBVgK (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 2 Dec 2021 16:36:10 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3956C061757
        for <mm-commits@vger.kernel.org>; Thu,  2 Dec 2021 13:32:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 6E1DCCE2473
        for <mm-commits@vger.kernel.org>; Thu,  2 Dec 2021 21:32:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C187C00446;
        Thu,  2 Dec 2021 21:32:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1638480763;
        bh=XV4KKMpxBw3yVxe1am8981H9XM2BtBt3TfMX1JNl2RI=;
        h=Date:From:To:Subject:From;
        b=D2OgqS0PYRgGQANdxCp8q1BWnylS7Fbb6PmxXMPAoiDhx6sknTCKYOQE3KAdb7NAh
         PsFu3QKo07YMyS9LmYFIA6G29PS+P4YrcQ425HRXpp2J/UYowgR+AlXDPibJsgEtCS
         NyBvW3h2PmxGuED4CM/VC+McWrn5d74XQ+KHN/K4=
Date:   Thu, 02 Dec 2021 13:32:42 -0800
From:   akpm@linux-foundation.org
To:     corbet@lwn.net, dan.j.williams@intel.com, dave.jiang@intel.com,
        hch@lst.de, jane.chu@oracle.com, jgg@nvidia.com, jgg@ziepe.ca,
        jhubbard@nvidia.com, joao.m.martins@oracle.com,
        mike.kravetz@oracle.com, mm-commits@vger.kernel.org,
        naoya.horiguchi@nec.com, songmuchun@bytedance.com,
        vishal.l.verma@intel.com, willy@infradead.org
Subject:  +
 mm-memremap-add-zone_device-support-for-compound-pages.patch added to -mm
 tree
Message-ID: <20211202213242.oB_1FdD-p%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memremap: add ZONE_DEVICE support for compound pages
has been added to the -mm tree.  Its filename is
     mm-memremap-add-zone_device-support-for-compound-pages.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-memremap-add-zone_device-support-for-compound-pages.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-memremap-add-zone_device-support-for-compound-pages.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Joao Martins <joao.m.martins@oracle.com>
Subject: mm/memremap: add ZONE_DEVICE support for compound pages

Add a new @vmemmap_shift property for struct dev_pagemap which specifies
that a devmap is composed of a set of compound pages of order
@vmemmap_shift, instead of base pages.  When a compound page devmap is
requested, all but the first page are initialised as tail pages instead of
order-0 pages.

For certain ZONE_DEVICE users like device-dax which have a fixed page
size, this creates an opportunity to optimize GUP and GUP-fast walkers,
treating it the same way as THP or hugetlb pages.

Additionally, commit 7118fc2906e2 ("hugetlb: address ref count racing in
prep_compound_gigantic_page") removed set_page_count() because the setting
of page ref count to zero was redundant.  devmap pages don't come from
page allocator though and only head page refcount is used for compound
pages, hence initialize tail page count to zero.

Link: https://lkml.kernel.org/r/20211202204422.26777-5-joao.m.martins@oracle.com
Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
Reviewed-by: Dan Williams <dan.j.williams@intel.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Dave Jiang <dave.jiang@intel.com>
Cc: Jane Chu <jane.chu@oracle.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Naoya Horiguchi <naoya.horiguchi@nec.com>
Cc: Vishal Verma <vishal.l.verma@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memremap.h |   11 ++++++++++
 mm/memremap.c            |   18 +++++++++++------
 mm/page_alloc.c          |   38 ++++++++++++++++++++++++++++++++++++-
 3 files changed, 60 insertions(+), 7 deletions(-)

--- a/include/linux/memremap.h~mm-memremap-add-zone_device-support-for-compound-pages
+++ a/include/linux/memremap.h
@@ -99,6 +99,11 @@ struct dev_pagemap_ops {
  * @done: completion for @internal_ref
  * @type: memory type: see MEMORY_* in memory_hotplug.h
  * @flags: PGMAP_* flags to specify defailed behavior
+ * @vmemmap_shift: structural definition of how the vmemmap page metadata
+ *      is populated, specifically the metadata page order.
+ *	A zero value (default) uses base pages as the vmemmap metadata
+ *	representation. A bigger value will set up compound struct pages
+ *	of the requested order value.
  * @ops: method table
  * @owner: an opaque pointer identifying the entity that manages this
  *	instance.  Used by various helpers to make sure that no
@@ -114,6 +119,7 @@ struct dev_pagemap {
 	struct completion done;
 	enum memory_type type;
 	unsigned int flags;
+	unsigned long vmemmap_shift;
 	const struct dev_pagemap_ops *ops;
 	void *owner;
 	int nr_range;
@@ -130,6 +136,11 @@ static inline struct vmem_altmap *pgmap_
 	return NULL;
 }
 
+static inline unsigned long pgmap_vmemmap_nr(struct dev_pagemap *pgmap)
+{
+	return 1 << pgmap->vmemmap_shift;
+}
+
 #ifdef CONFIG_ZONE_DEVICE
 bool pfn_zone_device_reserved(unsigned long pfn);
 void *memremap_pages(struct dev_pagemap *pgmap, int nid);
--- a/mm/memremap.c~mm-memremap-add-zone_device-support-for-compound-pages
+++ a/mm/memremap.c
@@ -102,11 +102,17 @@ static unsigned long pfn_end(struct dev_
 	return (range->start + range_len(range)) >> PAGE_SHIFT;
 }
 
-static unsigned long pfn_next(unsigned long pfn)
+static unsigned long pfn_next(struct dev_pagemap *pgmap, unsigned long pfn)
 {
-	if (pfn % 1024 == 0)
+	if (pfn % (1024 << pgmap->vmemmap_shift))
 		cond_resched();
-	return pfn + 1;
+	return pfn + pgmap_vmemmap_nr(pgmap);
+}
+
+static unsigned long pfn_len(struct dev_pagemap *pgmap, unsigned long range_id)
+{
+	return (pfn_end(pgmap, range_id) -
+		pfn_first(pgmap, range_id)) >> pgmap->vmemmap_shift;
 }
 
 /*
@@ -130,7 +136,8 @@ bool pfn_zone_device_reserved(unsigned l
 }
 
 #define for_each_device_pfn(pfn, map, i) \
-	for (pfn = pfn_first(map, i); pfn < pfn_end(map, i); pfn = pfn_next(pfn))
+	for (pfn = pfn_first(map, i); pfn < pfn_end(map, i); \
+	     pfn = pfn_next(map, pfn))
 
 static void dev_pagemap_kill(struct dev_pagemap *pgmap)
 {
@@ -315,8 +322,7 @@ static int pagemap_range(struct dev_page
 	memmap_init_zone_device(&NODE_DATA(nid)->node_zones[ZONE_DEVICE],
 				PHYS_PFN(range->start),
 				PHYS_PFN(range_len(range)), pgmap);
-	percpu_ref_get_many(pgmap->ref, pfn_end(pgmap, range_id)
-			- pfn_first(pgmap, range_id));
+	percpu_ref_get_many(pgmap->ref, pfn_len(pgmap, range_id));
 	return 0;
 
 err_add_memory:
--- a/mm/page_alloc.c~mm-memremap-add-zone_device-support-for-compound-pages
+++ a/mm/page_alloc.c
@@ -6612,6 +6612,35 @@ static void __ref __init_zone_device_pag
 	}
 }
 
+static void __ref memmap_init_compound(struct page *head,
+				       unsigned long head_pfn,
+				       unsigned long zone_idx, int nid,
+				       struct dev_pagemap *pgmap,
+				       unsigned long nr_pages)
+{
+	unsigned long pfn, end_pfn = head_pfn + nr_pages;
+	unsigned int order = pgmap->vmemmap_shift;
+
+	__SetPageHead(head);
+	for (pfn = head_pfn + 1; pfn < end_pfn; pfn++) {
+		struct page *page = pfn_to_page(pfn);
+
+		__init_zone_device_page(page, pfn, zone_idx, nid, pgmap);
+		prep_compound_tail(head, pfn - head_pfn);
+		set_page_count(page, 0);
+
+		/*
+		 * The first tail page stores compound_mapcount_ptr() and
+		 * compound_order() and the second tail page stores
+		 * compound_pincount_ptr(). Call prep_compound_head() after
+		 * the first and second tail pages have been initialized to
+		 * not have the data overwritten.
+		 */
+		if (pfn == head_pfn + 2)
+			prep_compound_head(head, order);
+	}
+}
+
 void __ref memmap_init_zone_device(struct zone *zone,
 				   unsigned long start_pfn,
 				   unsigned long nr_pages,
@@ -6620,6 +6649,7 @@ void __ref memmap_init_zone_device(struc
 	unsigned long pfn, end_pfn = start_pfn + nr_pages;
 	struct pglist_data *pgdat = zone->zone_pgdat;
 	struct vmem_altmap *altmap = pgmap_altmap(pgmap);
+	unsigned int pfns_per_compound = pgmap_vmemmap_nr(pgmap);
 	unsigned long zone_idx = zone_idx(zone);
 	unsigned long start = jiffies;
 	int nid = pgdat->node_id;
@@ -6637,10 +6667,16 @@ void __ref memmap_init_zone_device(struc
 		nr_pages = end_pfn - start_pfn;
 	}
 
-	for (pfn = start_pfn; pfn < end_pfn; pfn++) {
+	for (pfn = start_pfn; pfn < end_pfn; pfn += pfns_per_compound) {
 		struct page *page = pfn_to_page(pfn);
 
 		__init_zone_device_page(page, pfn, zone_idx, nid, pgmap);
+
+		if (pfns_per_compound == 1)
+			continue;
+
+		memmap_init_compound(page, pfn, zone_idx, nid, pgmap,
+				     pfns_per_compound);
 	}
 
 	pr_info("%s initialised %lu pages in %ums\n", __func__,
_

Patches currently in -mm which might be from joao.m.martins@oracle.com are

mm-page_alloc-split-prep_compound_page-into-head-and-tail-subparts.patch
mm-page_alloc-refactor-memmap_init_zone_device-page-init.patch
mm-memremap-add-zone_device-support-for-compound-pages.patch
device-dax-use-align-for-determining-pgoff.patch
device-dax-use-struct_size.patch
device-dax-ensure-dev_dax-pgmap-is-valid-for-dynamic-devices.patch
device-dax-factor-out-page-mapping-initialization.patch
device-dax-set-mapping-prior-to-vmf_insert_pfn_pmdpud.patch
device-dax-remove-pfn-from-__dev_dax_ptepmdpud_fault.patch
device-dax-compound-devmap-support.patch

