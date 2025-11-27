Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 315551FBEA2
	for <mm-commits@vger.kernel.org>; Thu, 27 Nov 2025 22:27:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764282443; cv=none; b=BcjrpLdPX9UEUOHGwEXHb7mVGCL64K5e6F+E8AXzpxQ7Tcvfpbh6AaFUkOJM0m2kj+CtL6pk+evHthIrivZ00mNZbq5B2hkeeqhPJekwMOcKuqyZ44C+HBM7qBdeB6bCgcoPTSdeTNcnyWA43dYbSRUXPlXisjnem5iakExsB80=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764282443; c=relaxed/simple;
	bh=jOzT5y8mrKYXQmZ2mHO7MzJ7Qm63cGrNJ1OqiqPUo9o=;
	h=Date:To:From:Subject:Message-Id; b=gu8gZjrXMxNhil47hn49QzrS1z5ak4qc+771QcC5VPtZPKjRTLpma+UuoKm1MVt+AR7OLRsSpUOLYtl5pqr9gY5PXIE2TvN3Gps6DaJJsHu3XEjfjgpicxUtqrt+O0BeAhQCu6wHyje8WP5O2S985Cqj9pCQgg7hqV7Stw42BOw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=1aQ+qy5B; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="1aQ+qy5B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06391C4CEF8;
	Thu, 27 Nov 2025 22:27:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1764282443;
	bh=jOzT5y8mrKYXQmZ2mHO7MzJ7Qm63cGrNJ1OqiqPUo9o=;
	h=Date:To:From:Subject:From;
	b=1aQ+qy5BmwkGuYk1BMvo8Xi/pNeAgGa+ahVfLVbrlqJKuDbilFxaqUdGC8J0p0HVx
	 CHyvuXd/c4obuh0xmmMFLuAWSEirH+CTZTWXAcBRIqP3YA6gQvDBxdKzXxVwcrrrBg
	 jSrjwEnfuL3/vQ+YHum7estKB2Ebq5+wM8ZuE/k8=
Date: Thu, 27 Nov 2025 14:27:22 -0800
To: mm-commits@vger.kernel.org,pratyush@kernel.org,pasha.tatashin@soleen.com,graf@amazon.com,rppt@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] kho-fix-restoring-of-contiguous-ranges-of-order-0-pages.patch removed from -mm tree
Message-Id: <20251127222723.06391C4CEF8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kho: fix restoring of contiguous ranges of order-0 pages
has been removed from the -mm tree.  Its filename was
     kho-fix-restoring-of-contiguous-ranges-of-order-0-pages.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Subject: kho: fix restoring of contiguous ranges of order-0 pages
Date: Tue, 25 Nov 2025 13:09:17 +0200

When contiguous ranges of order-0 pages are restored, kho_restore_page()
calls prep_compound_page() with the first page in the range and order as
parameters and then kho_restore_pages() calls split_page() to make sure
all pages in the range are order-0.

However, since split_page() is not intended to split compound pages and
with VM_DEBUG enabled it will trigger a VM_BUG_ON_PAGE().

Update kho_restore_page() so that it will use prep_compound_page() when it
restores a folio and make sure it properly sets page count for both large
folios and ranges of order-0 pages.

Link: https://lkml.kernel.org/r/20251125110917.843744-3-rppt@kernel.org
Fixes: a667300bd53f ("kho: add support for preserving vmalloc allocations")
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Reported-by: Pratyush Yadav <pratyush@kernel.org>
Cc: Alexander Graf <graf@amazon.com>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/liveupdate/kexec_handover.c |   20 ++++++++++++--------
 1 file changed, 12 insertions(+), 8 deletions(-)

--- a/kernel/liveupdate/kexec_handover.c~kho-fix-restoring-of-contiguous-ranges-of-order-0-pages
+++ a/kernel/liveupdate/kexec_handover.c
@@ -219,11 +219,11 @@ static int __kho_preserve_order(struct k
 	return 0;
 }
 
-static struct page *kho_restore_page(phys_addr_t phys)
+static struct page *kho_restore_page(phys_addr_t phys, bool is_folio)
 {
 	struct page *page = pfn_to_online_page(PHYS_PFN(phys));
+	unsigned int nr_pages, ref_cnt;
 	union kho_page_info info;
-	unsigned int nr_pages;
 
 	if (!page)
 		return NULL;
@@ -243,11 +243,16 @@ static struct page *kho_restore_page(phy
 	/* Head page gets refcount of 1. */
 	set_page_count(page, 1);
 
-	/* For higher order folios, tail pages get a page count of zero. */
+	/*
+	 * For higher order folios, tail pages get a page count of zero.
+	 * For physically contiguous order-0 pages every pages gets a page
+	 * count of 1
+	 */
+	ref_cnt = is_folio ? 0 : 1;
 	for (unsigned int i = 1; i < nr_pages; i++)
-		set_page_count(page + i, 0);
+		set_page_count(page + i, ref_cnt);
 
-	if (info.order > 0)
+	if (is_folio && info.order)
 		prep_compound_page(page, info.order);
 
 	adjust_managed_page_count(page, nr_pages);
@@ -262,7 +267,7 @@ static struct page *kho_restore_page(phy
  */
 struct folio *kho_restore_folio(phys_addr_t phys)
 {
-	struct page *page = kho_restore_page(phys);
+	struct page *page = kho_restore_page(phys, true);
 
 	return page ? page_folio(page) : NULL;
 }
@@ -287,11 +292,10 @@ struct page *kho_restore_pages(phys_addr
 	while (pfn < end_pfn) {
 		const unsigned int order =
 			min(count_trailing_zeros(pfn), ilog2(end_pfn - pfn));
-		struct page *page = kho_restore_page(PFN_PHYS(pfn));
+		struct page *page = kho_restore_page(PFN_PHYS(pfn), false);
 
 		if (!page)
 			return NULL;
-		split_page(page, order);
 		pfn += 1 << order;
 	}
 
_

Patches currently in -mm which might be from rppt@kernel.org are

maintainers-add-mike-rapoport-as-maintainer-for-userfaultfd.patch

