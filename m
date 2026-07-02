Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E4A63161A4
	for <mm-commits@vger.kernel.org>; Thu,  2 Jul 2026 16:03:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783008234; cv=none; b=OUlalOopA5lGCf9wKampDkn++HSLVNL0OQr9WUivvDkyAxdOR46IMKDrZnqBxqGsK/Xihn7Rvx8uuHFJSQhLE973ZdD7jxkiXjk+o+fTzm2s23yNLVMTcQJM7syS6z5+WEc9/rnTaihMZR83cOZwXZ0jvHl/8/4KtWXUZadXia4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783008234; c=relaxed/simple;
	bh=qmedK4Cc4HO5TG9N8WwzhCYEyaIri1V+o7F8E9kjg8Y=;
	h=Date:To:From:Subject:Message-Id; b=OVem1h69XwzIZuq0ngveYCvfJ4RDySNHqHdEsZm75U5Mo/CsiuW/eu8TaOnyqV718vUwLcHfXkEBhHtFI8OMh1XzpEaBVnawgxguT5hy7pdv0lSPhixynnOky3ijUh+2X7sOKiz+OcYH9cTbUHS5uwFrw7FrEYz0dCL0DPLlZhc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Wq+o9wJq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Wq+o9wJq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52A0C1F00A3A;
	Thu,  2 Jul 2026 16:03:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783008233;
	bh=6s3/7ZEnaLMLUx4oQZ+oz53X91iU+MSVgiY0rXa+I8g=;
	h=Date:To:From:Subject;
	b=Wq+o9wJqNqv4u/ai/9Cz9uSDSzxK/Zyh/oCMh72PrVrXm19geAl4C+WgbJB9Inv5i
	 rvB22zvzK3zxs2EfbL6HueomogXoN/zKUGl7Nxea9tPeBrFjj8Lx78WcjGSBHTmZD0
	 BI1TnnHSENaVLHnNgdKPxUFAUXODY2oeOsTq9WYI=
Date: Thu, 02 Jul 2026 09:03:52 -0700
To: mm-commits@vger.kernel.org,lizhe.67@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-extend-the-template-fast-path-to-zone-device-compound-tails.patch removed from -mm tree
Message-Id: <20260702160353.52A0C1F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: extend the template fast path to zone-device compound tails
has been removed from the -mm tree.  Its filename was
     mm-extend-the-template-fast-path-to-zone-device-compound-tails.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: "Li Zhe" <lizhe.67@bytedance.com>
Subject: mm: extend the template fast path to zone-device compound tails
Date: Wed, 1 Jul 2026 17:05:50 +0800

The template fast path from the previous patch only accelerates head
pages.  Compound tails in memmap_init_compound() still go through the slow
path one by one.

Build separate head and tail templates and reuse one prepared tail
template across the tail pages in a compound range.  Head pages preserve
the existing refcount policy, while compound tails always start with a
refcount of 0 after prep_compound_tail().

This extends the template-copy fast path to pfns_per_compound > 1 without
changing the existing slow path.  Tail-page PFN-dependent fields are
refreshed in the reusable tail template before each copy.

Tested in a VM with a 100 GB devdax namespace (align=2097152) on Intel Ice
Lake server.  This test exercises the dax_pmem rebind path and measures
memmap initialization latency.

Test procedure:
Unbind and rebind the dax_pmem driver 30 times, collect memmap
initialization time from the pr_debug() output of memmap_init_zone_device().

Base(v7.2-rc1):
  First binding: 1462 ms
  Average of subsequent rebinds: 273.31 ms

With this patch and its prerequisites applied:
  First binding: 1403 ms
  Average of subsequent rebinds: 244.37 ms

This reduces the average rebind time from 273.31 ms to 244.37 ms, or
about 10.6%.

Link: https://lore.kernel.org/20260701090553.62691-6-lizhe.67@bytedance.com
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

 mm/mm_init.c |   47 ++++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 40 insertions(+), 7 deletions(-)

--- a/mm/mm_init.c~mm-extend-the-template-fast-path-to-zone-device-compound-tails
+++ a/mm/mm_init.c
@@ -1071,6 +1071,16 @@ static inline void zone_device_template_
 	memcpy(template, src, sizeof(*template));
 }
 
+static inline void zone_device_tail_page_init(struct page *page,
+		unsigned long pfn, unsigned long zone_idx, int nid,
+		struct dev_pagemap *pgmap, const struct page *head,
+		unsigned int order)
+{
+	zone_device_page_init_slow(page, pfn, zone_idx, nid, pgmap);
+	prep_compound_tail(page, head, order);
+	set_page_count(page, 0);
+}
+
 /*
  * 'template' is a reusable page prototype rather than a strictly immutable
  * object. Most ZONE_DEVICE fields stay constant across the pages covered by
@@ -1128,10 +1138,12 @@ static void __ref memmap_init_compound(s
 				       unsigned long head_pfn,
 				       unsigned long zone_idx, int nid,
 				       struct dev_pagemap *pgmap,
-				       unsigned long nr_pages)
+				       unsigned long nr_pages,
+				       bool use_template)
 {
 	unsigned long pfn, end_pfn = head_pfn + nr_pages;
 	unsigned int order = pgmap->vmemmap_shift;
+	struct page template;
 
 	/*
 	 * We have to initialize the pages, including setting up page links.
@@ -1140,12 +1152,31 @@ static void __ref memmap_init_compound(s
 	 * the pages in the same go.
 	 */
 	__SetPageHead(head);
-	for (pfn = head_pfn + 1; pfn < end_pfn; pfn++) {
+
+	pfn = head_pfn + 1;
+	/*
+	 * All tails of the same compound page share the state established by
+	 * prep_compound_tail(). Reuse one tail template for the whole range and
+	 * refresh only the PFN-dependent fields in that template before each copy.
+	 */
+	if (use_template) {
 		struct page *page = pfn_to_page(pfn);
 
-		zone_device_page_init_slow(page, pfn, zone_idx, nid, pgmap);
-		prep_compound_tail(page, head, order);
-		set_page_count(page, 0);
+		zone_device_tail_page_init(page, pfn, zone_idx, nid,
+					   pgmap, head, order);
+		zone_device_template_page_init(&template, page);
+		pfn++;
+	}
+
+	for (; pfn < end_pfn; pfn++) {
+		struct page *page = pfn_to_page(pfn);
+
+		if (use_template)
+			zone_device_page_init_from_template(page, pfn,
+							    &template);
+		else
+			zone_device_tail_page_init(page, pfn, zone_idx, nid,
+						   pgmap, head, order);
 	}
 	prep_compound_head(head, order);
 }
@@ -1195,7 +1226,8 @@ void __ref memmap_init_zone_device(struc
 		zone_device_template_page_init(&template, page);
 		if (pfns_per_compound != 1)
 			memmap_init_compound(page, pfn, zone_idx, nid, pgmap,
-				compound_nr_pages(start_pfn, altmap, pgmap));
+				compound_nr_pages(start_pfn, altmap, pgmap),
+				use_template);
 		pfn += pfns_per_compound;
 	}
 
@@ -1216,7 +1248,8 @@ void __ref memmap_init_zone_device(struc
 			continue;
 
 		memmap_init_compound(page, pfn, zone_idx, nid, pgmap,
-				     compound_nr_pages(pfn, altmap, pgmap));
+				     compound_nr_pages(pfn, altmap, pgmap),
+				     use_template);
 	}
 
 	pageblock_migratetype_init_range(start_pfn, nr_pages, MIGRATE_MOVABLE, false);
_

Patches currently in -mm which might be from lizhe.67@bytedance.com are

string-introduce-memcpy_nt-helpers.patch
x86-string-extend-memcpy_flushcache-fixed-size-fastpaths.patch
mm-use-memcpy_nt-in-zone-device-template-copies.patch

