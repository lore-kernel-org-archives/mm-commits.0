Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B4B039A7F6
	for <mm-commits@vger.kernel.org>; Wed,  1 Jul 2026 23:28:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782948518; cv=none; b=vDfix/vnqoMWQfJrYVGuR2yf8lEObKsbbgrFKcv2u1+UTCEVLZKRgAUx6Ch1CH2MH+oIsUrW1lvl0lC1EfxI9OHSU/NoYhuBq1aYJ70bvXoy6SkixDHvMyfNuhGru4syxmr5Cvh6SkpzITZi8szka2+cDj+pVCgIS7UIiM800CA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782948518; c=relaxed/simple;
	bh=cvhethVp0vdHz+P4eKszIAUKFDzis2XvWIFRdC7W8U0=;
	h=Date:To:From:Subject:Message-Id; b=m6mXfK3tUbllbCv0EmVcr6eoF4dTXnle4Hd2zBSE0j7fm21bppO1StHKihah/A2rGKvHEHcBkhp1JrNeHgF6RKLbCuo2+XA/65FkiND6e/NK0MkUEw8uLwb64QQqL5qYsknSRz+jTAvbjGi67OrVjyFqltyj4ecWN9HYa6hdb2Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=QZIyHnDS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="QZIyHnDS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDBFD1F000E9;
	Wed,  1 Jul 2026 23:28:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782948516;
	bh=Dsycgaf1TaiF/h+HPjaW642/lny0FoJXM1mrlTfyP+4=;
	h=Date:To:From:Subject;
	b=QZIyHnDSwfdClsX5VoRU2hNn8XSqBcN4jne1nRbc0iHWjZvb6/aqlwpA/exgpep+G
	 LoKWXAlrlVUsNY+yh/HMdC/+JG4VWezuBlyiaHI0CoE7bChXPXvyIfUoYbAnRISGKn
	 MeikxD4eXnX2nY4b3bsIKPof6qgrRob34ryj3yjI=
Date: Wed, 01 Jul 2026 16:28:36 -0700
To: mm-commits@vger.kernel.org,lizhe.67@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-extend-the-template-fast-path-to-zone-device-compound-tails.patch added to mm-new branch
Message-Id: <20260701232836.BDBFD1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: extend the template fast path to zone-device compound tails
has been added to the -mm mm-new branch.  Its filename is
     mm-extend-the-template-fast-path-to-zone-device-compound-tails.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-extend-the-template-fast-path-to-zone-device-compound-tails.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

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

mm-fix-stale-zone_device-refcount-comment.patch
mm-factor-zone-device-page-init-helpers-out-of-__init_zone_device_page.patch
mm-add-a-set_page_section_from_pfn-helper.patch
mm-add-a-template-based-fast-path-for-zone-device-page-init.patch
mm-extend-the-template-fast-path-to-zone-device-compound-tails.patch
string-introduce-memcpy_nt-helpers.patch
x86-string-extend-memcpy_flushcache-fixed-size-fastpaths.patch
mm-use-memcpy_nt-in-zone-device-template-copies.patch

