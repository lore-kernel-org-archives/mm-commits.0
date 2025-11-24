Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1F4A2F7AD4
	for <mm-commits@vger.kernel.org>; Mon, 24 Nov 2025 23:09:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764025791; cv=none; b=hTtrl9rKYb2zOi2A999q8X9I0wcy/a37SniGAhEpWqvaoHbJpkUWSO8OjJHfDtiUBFDvTIUCrzog20/YZKm7fp7Tt89uRoKapcGhEW6g+y0IuL3KbsE8coDcpXrpIq/8FPoSePc3gfRs4rL2mwbP+pL6HxySAk83iWi/aatke0o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764025791; c=relaxed/simple;
	bh=riFrNKiDRAe26lyi83qBQMSfnRHZ747PtnfvQP6qZPw=;
	h=Date:To:From:Subject:Message-Id; b=uUKhDJmYLEc8GLwIpZfAsuM2ySpPsT6bNQDRtNZAZjgxdhlLWLkwIaKmdPAqy6mP0PDrT6xennRkU1qqz21aUGmlwvpUi+oHq7v191tZnpgLXic2xoQLOrq/825WWfBEAKiXaBAkVP4DY8cMaVQ7W6PkVs7JwIxcnmQQyosfRUs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=g5YrRwdf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="g5YrRwdf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69AE8C4CEFB;
	Mon, 24 Nov 2025 23:09:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1764025789;
	bh=riFrNKiDRAe26lyi83qBQMSfnRHZ747PtnfvQP6qZPw=;
	h=Date:To:From:Subject:From;
	b=g5YrRwdfwlFLot4BbFjijvL8M0ZlEtfb1ldaCOkliwwgP2Hee5k7oWKZW/5/rlb+P
	 XKlbKnkstFbG4eu5GpS7AZhQAZT7STVJlEorLL71tXOIF/iMoqPivdQSvGoODVE5LD
	 HoqiBdQC/N5L072DRZG2Umu6B1z0AMmtVflajFqk=
Date: Mon, 24 Nov 2025 15:09:48 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ying.huang@linux.alibaba.com,simona@ffwll.ch,ryan.roberts@arm.com,rcampbell@nvidia.com,rakie.kim@sk.com,osalvador@suse.de,npache@redhat.com,mpenttil@redhat.com,matthew.brost@intel.com,lyude@redhat.com,lorenzo.stoakes@oracle.com,Liam.Howlett@oracle.com,joshua.hahnjy@gmail.com,gourry@gourry.net,francois.dugast@intel.com,dev.jain@arm.com,david@redhat.com,dakr@kernel.org,byungchul@sk.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,apopple@nvidia.com,airlied@gmail.com,balbirs@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-memremap-add-driver-callback-support-for-folio-splitting.patch removed from -mm tree
Message-Id: <20251124230949.69AE8C4CEFB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/memremap: add driver callback support for folio splitting
has been removed from the -mm tree.  Its filename was
     mm-memremap-add-driver-callback-support-for-folio-splitting.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Balbir Singh <balbirs@nvidia.com>
Subject: mm/memremap: add driver callback support for folio splitting
Date: Wed, 1 Oct 2025 16:57:01 +1000

When a zone device page is split (via huge pmd folio split).  The driver
callback for folio_split is invoked to let the device driver know that the
folio size has been split into a smaller order.

Provide a default implementation for drivers that do not provide this
callback that copies the pgmap and mapping fields for the split folios.

Update the HMM test driver to handle the split.

Link: https://lkml.kernel.org/r/20251001065707.920170-11-balbirs@nvidia.com
Signed-off-by: Balbir Singh <balbirs@nvidia.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Rakie Kim <rakie.kim@sk.com>
Cc: Byungchul Park <byungchul@sk.com>
Cc: Gregory Price <gourry@gourry.net>
Cc: Ying Huang <ying.huang@linux.alibaba.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Cc: Nico Pache <npache@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Lyude Paul <lyude@redhat.com>
Cc: Danilo Krummrich <dakr@kernel.org>
Cc: David Airlie <airlied@gmail.com>
Cc: Simona Vetter <simona@ffwll.ch>
Cc: Ralph Campbell <rcampbell@nvidia.com>
Cc: Mika Penttilä <mpenttil@redhat.com>
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: Francois Dugast <francois.dugast@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memremap.h |   29 +++++++++++++++++++++++++++++
 lib/test_hmm.c           |   35 +++++++++++++++++++++++++++++++++++
 2 files changed, 64 insertions(+)

--- a/include/linux/memremap.h~mm-memremap-add-driver-callback-support-for-folio-splitting
+++ a/include/linux/memremap.h
@@ -100,6 +100,13 @@ struct dev_pagemap_ops {
 	 */
 	int (*memory_failure)(struct dev_pagemap *pgmap, unsigned long pfn,
 			      unsigned long nr_pages, int mf_flags);
+
+	/*
+	 * Used for private (un-addressable) device memory only.
+	 * This callback is used when a folio is split into
+	 * a smaller folio
+	 */
+	void (*folio_split)(struct folio *head, struct folio *tail);
 };
 
 #define PGMAP_ALTMAP_VALID	(1 << 0)
@@ -235,6 +242,23 @@ static inline void zone_device_folio_ini
 		folio_set_large_rmappable(folio);
 }
 
+static inline void zone_device_private_split_cb(struct folio *original_folio,
+						struct folio *new_folio)
+{
+	if (folio_is_device_private(original_folio)) {
+		if (!original_folio->pgmap->ops->folio_split) {
+			if (new_folio) {
+				new_folio->pgmap = original_folio->pgmap;
+				new_folio->page.mapping =
+					original_folio->page.mapping;
+			}
+		} else {
+			original_folio->pgmap->ops->folio_split(original_folio,
+								 new_folio);
+		}
+	}
+}
+
 #else
 static inline void *devm_memremap_pages(struct device *dev,
 		struct dev_pagemap *pgmap)
@@ -268,6 +292,11 @@ static inline unsigned long memremap_com
 {
 	return PAGE_SIZE;
 }
+
+static inline void zone_device_private_split_cb(struct folio *original_folio,
+						struct folio *new_folio)
+{
+}
 #endif /* CONFIG_ZONE_DEVICE */
 
 static inline void put_dev_pagemap(struct dev_pagemap *pgmap)
--- a/lib/test_hmm.c~mm-memremap-add-driver-callback-support-for-folio-splitting
+++ a/lib/test_hmm.c
@@ -1654,9 +1654,44 @@ err:
 	return ret;
 }
 
+static void dmirror_devmem_folio_split(struct folio *head, struct folio *tail)
+{
+	struct page *rpage = BACKING_PAGE(folio_page(head, 0));
+	struct page *rpage_tail;
+	struct folio *rfolio;
+	unsigned long offset = 0;
+
+	if (!rpage) {
+		tail->page.zone_device_data = NULL;
+		return;
+	}
+
+	rfolio = page_folio(rpage);
+
+	if (tail == NULL) {
+		folio_reset_order(rfolio);
+		rfolio->mapping = NULL;
+		folio_set_count(rfolio, 1);
+		return;
+	}
+
+	offset = folio_pfn(tail) - folio_pfn(head);
+
+	rpage_tail = folio_page(rfolio, offset);
+	tail->page.zone_device_data = rpage_tail;
+	rpage_tail->zone_device_data = rpage->zone_device_data;
+	clear_compound_head(rpage_tail);
+	rpage_tail->mapping = NULL;
+
+	folio_page(tail, 0)->mapping = folio_page(head, 0)->mapping;
+	tail->pgmap = head->pgmap;
+	folio_set_count(page_folio(rpage_tail), 1);
+}
+
 static const struct dev_pagemap_ops dmirror_devmem_ops = {
 	.folio_free	= dmirror_devmem_free,
 	.migrate_to_ram	= dmirror_devmem_fault,
+	.folio_split	= dmirror_devmem_folio_split,
 };
 
 static int dmirror_device_init(struct dmirror_device *mdevice, int id)
_

Patches currently in -mm which might be from balbirs@nvidia.com are


