Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDFE0399CF2
	for <mm-commits@vger.kernel.org>; Mon, 31 Aug 2026 23:46:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788219971; cv=none; b=BUz1+5Erte8yJOvyOLtLjJc4SjqBNvrjQtUPqABcaE9j16iaqdg20tYSlc4s/1nwh++G/CfG5+OHXtr3Pa37pMLEWOpb8UKNdk/683oM7ApZKO4jPBA4CmMVnvb89IBItX9ol08QLaoJm3ib5S8vEVqoGXGrLE8cH7NdGtC79cQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788219971; c=relaxed/simple;
	bh=K0IfU3MSOZXr99YcG3dg+wI72gFeyenlrZxjCiR+Sf4=;
	h=Date:To:From:Subject:Message-Id; b=HwiFyNF682YELkBEFPlNsKNL/wL2lJOchUtmNgP1BgTfjtnm/F8IJ9mYa6qZSb4OfMTYZSaKqxbVFe0lKRnN5iVB2gqrJSQPTi5mfzjyrXRkiNtxMFwF5vflbOnthN9X/+ux89+pRYONWFjEnO618AQu1iNBuVdDx/p9U2938s0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=w+R6Kjp9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="w+R6Kjp9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E80EC1F000E9;
	Mon, 31 Aug 2026 23:46:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788219967;
	bh=3DS4yzzdDpCJDNDx4IN19dV7uYzg7TF1OhMtzCcLzlA=;
	h=Date:To:From:Subject;
	b=w+R6Kjp9wNjGbfZxlVAGwVRrZcTx2Wa5fCgmoR+VJItoLvk5vVxfM4y3/u004xGPi
	 H+H6++ZNzsUGUAmMnMrrLYQBXs3CK1d5WAORClYzcRjNqC16xKSUYmOj6UoYPSZwD5
	 22wtL+7rnnhpNUY8rjWtw7SPqX9Lc4z6tiCPbQi8=
Date: Mon, 31 Aug 2026 16:46:06 -0700
To: mm-commits@vger.kernel.org,rppt@kernel.org,muchun.song@linux.dev,mingo@redhat.com,kees@kernel.org,david@kernel.org,dave.hansen@linux.intel.com,bp@alien8.de,balbirs@nvidia.com,arnd@arndb.de,apopple@nvidia.com,lizhe.67@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-add-a-template-based-fast-path-for-zone-device-page-init.patch added to mm-new branch
Message-Id: <20260831234606.E80EC1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: add a template-based fast path for zone-device page init
has been added to the -mm mm-new branch.  Its filename is
     mm-add-a-template-based-fast-path-for-zone-device-page-init.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-add-a-template-based-fast-path-for-zone-device-page-init.patch

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
Subject: mm: add a template-based fast path for zone-device page init
Date: Mon, 31 Aug 2026 19:16:34 +0800

memmap_init_zone_device() repeats nearly identical head-page
initialization for each PFN.  Initialize the first real ZONE_DEVICE head
page through the existing path, copy that final state into a reusable
template, refresh the PFN-dependent fields in that template before each
copy, and copy it into the remaining destination pages.

Use the template path unconditionally.  The page_ref_set tracepoint is
primarily a debugging aid, while this code is still initializing struct
pages before they are handed out.  From the perspective of users of those
pages, the initialization-time refcount transitions are not part of the
observable page lifetime.

This means page_ref_set will no longer observe every initialization-time
refcount assignment for copied ZONE_DEVICE head pages.  The impact is
controlled because the final initialized struct page state is unchanged,
and keeping a separate non-template path only for this local tracepoint
observability would add complexity to the common path.

This patch accelerates head-page initialization.  The pfns_per_compound ==
1 case gets the full benefit here, compound tails are handled in the next
patch.

Tested in a VM with a 100 GB fsdax namespace device configured with
map=dev on Intel Ice Lake server.  This test exercises the nd_pmem rebind
path (pfns_per_compound == 1).

Test procedure:
Rebind the nd_pmem driver 30 times and collect the memmap initialization
time from the pr_debug() output of memmap_init_zone_device().

Base(v7.3-rc1):
  Average of rebinds for nd_pmem driver: 221.07 ms

With this patch and its prerequisites applied:
  Average of rebinds for nd_pmem driver: 155.00 ms

This reduces the average memmap initialization time measured during
rebind from 221.07 ms to 155.00 ms, or about 29.9%.

Link: https://lore.kernel.org/20260831111638.76012-4-lizhe.67@bytedance.com
Signed-off-by: Li Zhe <lizhe.67@bytedance.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Balbir Singh <balbirs@nvidia.com>
Cc: "Borislav Petkov (AMD)" <bp@alien8.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: David Hildenbrand (Arm) <david@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Kees Cook <kees@kernel.org>
Cc: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mm_init.c |   38 +++++++++++++++++++++++++++++++++++---
 1 file changed, 35 insertions(+), 3 deletions(-)

--- a/mm/mm_init.c~mm-add-a-template-based-fast-path-for-zone-device-page-init
+++ a/mm/mm_init.c
@@ -1029,6 +1029,17 @@ static void __ref __init_zone_device_pag
 	}
 }
 
+static void zone_device_page_init_from_template(struct page *page,
+		unsigned long pfn, struct page *template)
+{
+	set_page_section_from_pfn(template, pfn);
+#ifdef WANT_PAGE_VIRTUAL
+	if (!is_highmem_idx(ZONE_DEVICE))
+		set_page_address(template, __va(pfn << PAGE_SHIFT));
+#endif
+	memcpy(page, template, sizeof(*page));
+}
+
 /*
  * With compound page geometry and when struct pages are stored in ram most
  * tail pages are reused. Consequently, the amount of unique struct pages to
@@ -1091,6 +1102,8 @@ void __ref memmap_init_zone_device(struc
 	unsigned long zone_idx = zone_idx(zone);
 	unsigned long start = jiffies;
 	int nid = pgdat->node_id;
+	struct page template;
+	struct page *page;
 
 	if (WARN_ON_ONCE(!pgmap || zone_idx != ZONE_DEVICE))
 		return;
@@ -1105,10 +1118,29 @@ void __ref memmap_init_zone_device(struc
 		nr_pages = end_pfn - start_pfn;
 	}
 
-	for (pfn = start_pfn; pfn < end_pfn; pfn += pfns_per_compound) {
-		struct page *page = pfn_to_page(pfn);
+	if (!nr_pages)
+		return;
 
-		__init_zone_device_page(page, pfn, zone_idx, nid, pgmap);
+	/*
+	 * Seed the reusable head-page template from the first real struct
+	 * page. The normal page-init and refcount helpers must operate on
+	 * a real memmap entry rather than a stack object.
+	 */
+	pfn = start_pfn;
+	page = pfn_to_page(pfn);
+	__init_zone_device_page(page, pfn, zone_idx, nid, pgmap);
+	memcpy(&template, page, sizeof(*page));
+	if (pfns_per_compound != 1)
+		memmap_init_compound(page, pfn, zone_idx, nid, pgmap,
+				     compound_nr_pages(pfn, altmap, pgmap));
+	pfn += pfns_per_compound;
+
+	/* Initialize the remaining head pages from template. */
+	for (; pfn < end_pfn; pfn += pfns_per_compound) {
+		page = pfn_to_page(pfn);
+
+		zone_device_page_init_from_template(page, pfn,
+						    &template);
 
 		if (IS_ALIGNED(pfn, PAGES_PER_SECTION))
 			cond_resched();
_

Patches currently in -mm which might be from lizhe.67@bytedance.com are

mm-fix-stale-zone_device-refcount-comment.patch
mm-add-a-set_page_section_from_pfn-helper.patch
mm-add-a-template-based-fast-path-for-zone-device-page-init.patch
mm-extend-the-template-fast-path-to-zone-device-compound-tails.patch
string-introduce-memcpy_nontemporal.patch
mm-use-memcpy_nontemporal-in-zone-device-template-copies.patch
x86-string-extend-memcpy_flushcache-fixed-size-fastpaths.patch

