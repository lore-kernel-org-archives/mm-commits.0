Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6ED93F44CD
	for <mm-commits@vger.kernel.org>; Wed,  1 Jul 2026 23:28:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782948512; cv=none; b=eg6UM/tf/AkBUuciuC6TyZGnTQC49SLLR9cmsDdMNv1/tF+SkwiLR2bANZP4OgGf/hO6Lfp+sa2iVS5/uWr/wQxbiy4yuItdBQ5eqImw9HX7dZ2PY1c8mkOYmxeAbt1ah4xNHvXt91AArbX17HgULPw9RGYmB3Um3RR442Kn2BQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782948512; c=relaxed/simple;
	bh=1N//cC6502feEnKqMWHxsASOkH2UH+s2bOQxEvCNqns=;
	h=Date:To:From:Subject:Message-Id; b=hH9M0IeSdXnRVUrt+wgH1HvseEJiz85HqOT2FlkydMcESuvvfVRpVi9SB5oQxYgD3AwTlzC6UGbg6hll98UoD+vcUy37xkAW9ymFloNu21UEQR8sNNzVHL0174f10nBaeK55phiSuKtRc8Iz2b60FEwInj7pi3MbAZAnpafQPHs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=pKwXpj0O; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="pKwXpj0O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E8AE1F000E9;
	Wed,  1 Jul 2026 23:28:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782948510;
	bh=sumKZxWHJ7sQWd5uil4wQDVaYf7Qn3J8H6yxnJJ/en4=;
	h=Date:To:From:Subject;
	b=pKwXpj0OnNhDzaTHsFpdC6K+Q0YeGa0nPAE49sSs2HK7HQMXDv5nR001tJksmxFl5
	 OjOTm2FwIWicjYmmfKlLlUkf2c5zt8V/wUf7npc5zsNIDCFdrMLc3LSo/zJ7X2F47D
	 9XoOZZ6dtO4qybsBB9VRzcrjdUflYhVCd1i1d95o=
Date: Wed, 01 Jul 2026 16:28:30 -0700
To: mm-commits@vger.kernel.org,lizhe.67@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-factor-zone-device-page-init-helpers-out-of-__init_zone_device_page.patch added to mm-new branch
Message-Id: <20260701232830.9E8AE1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: factor zone-device page init helpers out of __init_zone_device_page
has been added to the -mm mm-new branch.  Its filename is
     mm-factor-zone-device-page-init-helpers-out-of-__init_zone_device_page.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-factor-zone-device-page-init-helpers-out-of-__init_zone_device_page.patch

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
Subject: mm: factor zone-device page init helpers out of __init_zone_device_page
Date: Wed, 1 Jul 2026 17:05:47 +0800

memmap_init_zone_device() currently mixes refcount policy and core
ZONE_DEVICE page setup in a single helper.

Factor the refcount-reset predicate into pagemap_resets_refcount(), move
the common page initialization into __zone_device_page_init(), and wrap
the existing slow path in zone_device_page_init_slow().

This keeps the slow-path behaviour unchanged and gives later patches
reusable helper boundaries.

No functional change intended.

Link: https://lore.kernel.org/20260701090553.62691-3-lizhe.67@bytedance.com
Signed-off-by: Li Zhe <lizhe.67@bytedance.com>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Balbir Singh <balbirs@nvidia.com>
Cc: "Borislav Petkov (AMD)" <bp@alien8.de>
Cc: David Hildenbrand <david@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Kees Cook <kees@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mm_init.c |   57 ++++++++++++++++++++++++++++++++-----------------
 1 file changed, 38 insertions(+), 19 deletions(-)

--- a/mm/mm_init.c~mm-factor-zone-device-page-init-helpers-out-of-__init_zone_device_page
+++ a/mm/mm_init.c
@@ -995,11 +995,38 @@ static void __init memmap_init(void)
 }
 
 #ifdef CONFIG_ZONE_DEVICE
-static void __ref __init_zone_device_page(struct page *page, unsigned long pfn,
+/*
+ * Return true when the free path for this pagemap type restores the page
+ * refcount to 1, so memmap_init_zone_device() can keep the count set by
+ * __init_single_page(). Otherwise initialize the refcount to 0 and leave
+ * it to the allocator or pgmap callbacks to raise it when the page is
+ * handed out again.
+ */
+static inline bool pagemap_resets_refcount(const struct dev_pagemap *pgmap)
+{
+	/*
+	 * MEMORY_DEVICE_GENERIC pages regain a refcount of 1 in the free
+	 * path. The remaining ZONE_DEVICE types start from 0 here and raise
+	 * the count again when the allocator or driver hands the page out.
+	 */
+	switch (pgmap->type) {
+	case MEMORY_DEVICE_FS_DAX:
+	case MEMORY_DEVICE_PRIVATE:
+	case MEMORY_DEVICE_COHERENT:
+	case MEMORY_DEVICE_PCI_P2PDMA:
+		return false;
+	case MEMORY_DEVICE_GENERIC:
+		return true;
+	default:
+		WARN_ONCE(1, "Unknown memory type!");
+		return true;
+	}
+}
+
+static void __ref __zone_device_page_init(struct page *page, unsigned long pfn,
 					  unsigned long zone_idx, int nid,
 					  struct dev_pagemap *pgmap)
 {
-
 	__init_single_page(page, pfn, zone_idx, nid);
 
 	/*
@@ -1018,23 +1045,15 @@ static void __ref __init_zone_device_pag
 	 */
 	page_folio(page)->pgmap = pgmap;
 	page->zone_device_data = NULL;
+}
 
-	/*
-	 * MEMORY_DEVICE_GENERIC pages regain a refcount of 1 in the free
-	 * path. The remaining ZONE_DEVICE types start from 0 here and raise
-	 * the count again when the allocator or driver hands the page out.
-	 */
-	switch (pgmap->type) {
-	case MEMORY_DEVICE_FS_DAX:
-	case MEMORY_DEVICE_PRIVATE:
-	case MEMORY_DEVICE_COHERENT:
-	case MEMORY_DEVICE_PCI_P2PDMA:
+static void __ref zone_device_page_init_slow(struct page *page,
+		unsigned long pfn, unsigned long zone_idx, int nid,
+		struct dev_pagemap *pgmap)
+{
+	__zone_device_page_init(page, pfn, zone_idx, nid, pgmap);
+	if (!pagemap_resets_refcount(pgmap))
 		set_page_count(page, 0);
-		break;
-
-	case MEMORY_DEVICE_GENERIC:
-		break;
-	}
 }
 
 /*
@@ -1080,7 +1099,7 @@ static void __ref memmap_init_compound(s
 	for (pfn = head_pfn + 1; pfn < end_pfn; pfn++) {
 		struct page *page = pfn_to_page(pfn);
 
-		__init_zone_device_page(page, pfn, zone_idx, nid, pgmap);
+		zone_device_page_init_slow(page, pfn, zone_idx, nid, pgmap);
 		prep_compound_tail(page, head, order);
 		set_page_count(page, 0);
 	}
@@ -1116,7 +1135,7 @@ void __ref memmap_init_zone_device(struc
 	for (pfn = start_pfn; pfn < end_pfn; pfn += pfns_per_compound) {
 		struct page *page = pfn_to_page(pfn);
 
-		__init_zone_device_page(page, pfn, zone_idx, nid, pgmap);
+		zone_device_page_init_slow(page, pfn, zone_idx, nid, pgmap);
 
 		if (IS_ALIGNED(pfn, PAGES_PER_SECTION))
 			cond_resched();
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

