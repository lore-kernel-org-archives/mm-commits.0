Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57B7E3264FF
	for <mm-commits@vger.kernel.org>; Thu,  2 Jul 2026 16:03:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783008233; cv=none; b=OhuQt9yOOiKnyi8IyMTX++xWKwn3Lp2mUm0fBHRS7nUESARb4VUjCvLJe9rDFzlBxpUBkPU6erR+XgyMZJZan72uHri5Su+VK8eP4ZB6Y2eF0CoTnq/U9SHhfE2fWQ6yV2AFVwLqLnzu+pAp56NgjES8KtkitY3i0tfFs8RJ6bQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783008233; c=relaxed/simple;
	bh=3gmMwU4J4UxlduQ3aCEJN+Vp6EHCnkrDvSTxrZw4gag=;
	h=Date:To:From:Subject:Message-Id; b=Xkd2OjuS9Wev5C5tWrWN5k6xv4mTdm6AxTp1Bt4do6nF2ns6hbbB3JUn/Df72icj5aMTEiX5tUmxLk6Cvvj0+LwDk/UXyI7m9e+s3TgfatuHWzZ5wmvpv3sNWtzT2Bt0T5fB9gRmTD+JBy920sbc577nj/HBbSOAfdQpomBdHdo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=baY7A4Cm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="baY7A4Cm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 202511F00A3E;
	Thu,  2 Jul 2026 16:03:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783008232;
	bh=NTZXb1ao8w+z0fRA+Hw2h0/+cMALI4SHwOZtdACp+wE=;
	h=Date:To:From:Subject;
	b=baY7A4CmNFJYU0VsmCXyuCVIpjHgffK/MLpfxMFx5YmG04e6xBv7v2Dj2MaELlh+U
	 jcILqowpDQ96pW1kLe2LVSxEfn0BISj8kXITeHfPj8Xo4qBpcGDNpBMN/q67TKRHco
	 qSofXtXCWP0EyZP17cYb/huzElG83UmT7DsjfYHU=
Date: Thu, 02 Jul 2026 09:03:51 -0700
To: mm-commits@vger.kernel.org,lizhe.67@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-add-a-template-based-fast-path-for-zone-device-page-init.patch removed from -mm tree
Message-Id: <20260702160352.202511F00A3E@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: add a template-based fast path for zone-device page init
has been removed from the -mm tree.  Its filename was
     mm-add-a-template-based-fast-path-for-zone-device-page-init.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: "Li Zhe" <lizhe.67@bytedance.com>
Subject: mm: add a template-based fast path for zone-device page init
Date: Wed, 1 Jul 2026 17:05:49 +0800

memmap_init_zone_device() repeats nearly identical head-page
initialization for each PFN.  Prepare one reusable ZONE_DEVICE head-page
template through the existing slow path, refresh the PFN-dependent fields
in that template before each copy, and memcpy it into each destination
page.

The optimized path assigns _refcount through the copied template, so keep
it disabled when the page_ref_set tracepoint is enabled.

This patch accelerates head-page initialization.  The pfns_per_compound ==
1 case gets the full benefit here, compound tails are handled in the next
patch.

Tested in a VM with a 100 GB fsdax namespace device configured with
map=dev on Intel Ice Lake server.  This test exercises the nd_pmem rebind
path (pfns_per_compound == 1).

Test procedure:
Rebind the nd_pmem driver 30 times and collect the memmap initialization
time from the pr_debug() output of memmap_init_zone_device().

Base(v7.2-rc1):
  First binding: 1456 ms
  Average of subsequent rebinds: 244.28 ms

With this patch and its prerequisites applied:
  First binding: 1440 ms
  Average of subsequent rebinds: 217.19 ms

This reduces the average rebind time from 244.28 ms to 217.19 ms, or
about 11%.

Link: https://lore.kernel.org/20260701090553.62691-5-lizhe.67@bytedance.com
Signed-off-by: Li Zhe <lizhe.67@bytedance.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Balbir Singh <balbirs@nvidia.com>
Cc: "Borislav Petkov (AMD)" <bp@alien8.de>
Cc: David Hildenbrand <david@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Kees Cook <kees@kernel.org>
Cc: Mike Rapoport (Microsoft) <rppt@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mm_init.c |   76 +++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 74 insertions(+), 2 deletions(-)

--- a/mm/mm_init.c~mm-add-a-template-based-fast-path-for-zone-device-page-init
+++ a/mm/mm_init.c
@@ -1056,6 +1056,50 @@ static void __ref zone_device_page_init_
 		set_page_count(page, 0);
 }
 
+static inline bool zone_device_page_init_optimization_enabled(void)
+{
+	/*
+	 * The template fast path copies a preinitialized struct page image.
+	 * Skip it when the page_ref_set tracepoint is enabled.
+	 */
+	return !page_ref_tracepoint_active(page_ref_set);
+}
+
+static inline void zone_device_template_page_init(struct page *template,
+						  struct page *src)
+{
+	memcpy(template, src, sizeof(*template));
+}
+
+/*
+ * 'template' is a reusable page prototype rather than a strictly immutable
+ * object. Most ZONE_DEVICE fields stay constant across the pages covered by
+ * the current template, but section bits and page->virtual may still depend
+ * on the PFN. Refresh those PFN-dependent fields in the template before
+ * copying it into @page.
+ */
+static inline void zone_device_page_update_template(struct page *template,
+		unsigned long pfn)
+{
+	set_page_section_from_pfn(template, pfn);
+#ifdef WANT_PAGE_VIRTUAL
+	if (!is_highmem_idx(ZONE_DEVICE))
+		set_page_address(template, __va(pfn << PAGE_SHIFT));
+#endif
+}
+
+static void zone_device_page_init_from_template(struct page *page,
+		unsigned long pfn, struct page *template)
+{
+	/*
+	 * 'template' carries the invariant portion of a ZONE_DEVICE struct
+	 * page. Update the PFN-dependent fields in place before copying it
+	 * to the destination page.
+	 */
+	zone_device_page_update_template(template, pfn);
+	memcpy(page, template, sizeof(*page));
+}
+
 /*
  * With compound page geometry and when struct pages are stored in ram most
  * tail pages are reused. Consequently, the amount of unique struct pages to
@@ -1111,6 +1155,7 @@ void __ref memmap_init_zone_device(struc
 				   unsigned long nr_pages,
 				   struct dev_pagemap *pgmap)
 {
+	bool use_template = zone_device_page_init_optimization_enabled();
 	unsigned long pfn, end_pfn = start_pfn + nr_pages;
 	struct pglist_data *pgdat = zone->zone_pgdat;
 	struct vmem_altmap *altmap = pgmap_altmap(pgmap);
@@ -1118,6 +1163,7 @@ void __ref memmap_init_zone_device(struc
 	unsigned long zone_idx = zone_idx(zone);
 	unsigned long start = jiffies;
 	int nid = pgdat->node_id;
+	struct page template;
 
 	if (WARN_ON_ONCE(!pgmap || zone_idx != ZONE_DEVICE))
 		return;
@@ -1132,10 +1178,36 @@ void __ref memmap_init_zone_device(struc
 		nr_pages = end_pfn - start_pfn;
 	}
 
-	for (pfn = start_pfn; pfn < end_pfn; pfn += pfns_per_compound) {
-		struct page *page = pfn_to_page(pfn);
+
+	if (!nr_pages)
+		return;
+
+	pfn = start_pfn;
+	/*
+	 * Seed the reusable head-page template from the first real struct
+	 * page, because the existing page-init and pageblock helpers expect
+	 * a real memmap entry rather than a stack object.
+	 */
+	if (use_template) {
+		struct page *page = pfn_to_page(start_pfn);
 
 		zone_device_page_init_slow(page, pfn, zone_idx, nid, pgmap);
+		zone_device_template_page_init(&template, page);
+		if (pfns_per_compound != 1)
+			memmap_init_compound(page, pfn, zone_idx, nid, pgmap,
+				compound_nr_pages(start_pfn, altmap, pgmap));
+		pfn += pfns_per_compound;
+	}
+
+	for (; pfn < end_pfn; pfn += pfns_per_compound) {
+		struct page *page = pfn_to_page(pfn);
+
+		if (use_template)
+			zone_device_page_init_from_template(page, pfn,
+							    &template);
+		else
+			zone_device_page_init_slow(page, pfn, zone_idx,
+						   nid, pgmap);
 
 		if (IS_ALIGNED(pfn, PAGES_PER_SECTION))
 			cond_resched();
_

Patches currently in -mm which might be from lizhe.67@bytedance.com are

mm-extend-the-template-fast-path-to-zone-device-compound-tails.patch
string-introduce-memcpy_nt-helpers.patch
x86-string-extend-memcpy_flushcache-fixed-size-fastpaths.patch
mm-use-memcpy_nt-in-zone-device-template-copies.patch

