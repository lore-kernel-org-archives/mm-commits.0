Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B46692040A8
	for <mm-commits@vger.kernel.org>; Thu,  8 May 2025 22:28:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746743286; cv=none; b=AQr07OQ9ZtNB8K+oAwUIq5ukKAE77TPh3/qW0KOqGCIU6io3okVqq9WAxNmaP8nByoUcx2o8BXTAxisqSd7qdu5u1a9e0GjjqP6NJ35vSsZsCZH3Rd0qMIU0GcHtVAaWSkdJtznNQTPQv8MuXjqP+1H5lB+B8jhYTV4TSpB/t8Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746743286; c=relaxed/simple;
	bh=CeF6XjzGb6lpT3CPVG5CJ2kUme/Ryf74LMS7rs7oTO4=;
	h=Date:To:From:Subject:Message-Id; b=h7A5p/3EmvkChxAC1wLuHUDAnCGm7c6ut4v9yWOZs8hZnyxHW6qTmpqqfxYhqt7XpnjHtm6cqLdQ2262dIT3I+/f2ITAKQR3gQczNKrij0p3Yf2yzS+789sIlSspT8CXhKr7ALPVQ9pcvGWnmCn5NPbZvrUpXiy3Th6guZwJkWM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=bwCcSkwQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="bwCcSkwQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E73BC4CEE7;
	Thu,  8 May 2025 22:28:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1746743286;
	bh=CeF6XjzGb6lpT3CPVG5CJ2kUme/Ryf74LMS7rs7oTO4=;
	h=Date:To:From:Subject:From;
	b=bwCcSkwQFdn7S51EWLdiobgW+YJvt+gDWhi+HUDnH1scpUZDqEVIrbMK0mCcNwCQx
	 wsjpVxSoz2C4d/jvq1hclCs+RuW7K98heaI6R2ojxPNfaFQlUbJ+zL2PhKBAP7e0GW
	 azLVxlZKkhmlrgBLRR1XC3M06LJlA2p+9qbwNdaU=
Date: Thu, 08 May 2025 15:28:05 -0700
To: mm-commits@vger.kernel.org,wade.farnsworth@siemens.com,peterx@redhat.com,jhubbard@nvidia.com,jgg@ziepe.ca,david@redhat.com,c.briere@samsung.com,artem.k@samsung.com,p.antoniou@partner.samsung.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] fix-zero-copy-i-o-on-__get_user_pages-allocated-pages.patch removed from -mm tree
Message-Id: <20250508222806.0E73BC4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: Fix zero copy I/O on __get_user_pages allocated pages
has been removed from the -mm tree.  Its filename was
     fix-zero-copy-i-o-on-__get_user_pages-allocated-pages.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Pantelis Antoniou <p.antoniou@partner.samsung.com>
Subject: Fix zero copy I/O on __get_user_pages allocated pages
Date: Wed, 7 May 2025 10:41:05 -0500

Recent updates to net filesystems enabled zero copy operations, which
require getting a user space page pinned.

This does not work for pages that were allocated via __get_user_pages and
then mapped to user-space via remap_pfn_rage.

remap_pfn_range_internal() will turn on VM_IO | VM_PFNMAP vma bits. 
VM_PFNMAP in particular mark the pages as not having struct_page
associated with them, which is not the case for __get_user_pages()

This in turn makes any attempt to lock a page fail, and breaking I/O from
that address range.

This patch address it by special casing pages in those VMAs and not
calling vm_normal_page() for them.

Link: https://lkml.kernel.org/r/20250507154105.763088-2-p.antoniou@partner.samsung.com
Signed-off-by: Pantelis Antoniou <p.antoniou@partner.samsung.com>
Cc: Artem Krupotkin <artem.k@samsung.com>
Cc: Charles Briere <c.briere@samsung.com>
Cc: Wade Farnsworth <wade.farnsworth@siemens.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Peter Xu <peterx@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/gup.c |   22 ++++++++++++++++++----
 1 file changed, 18 insertions(+), 4 deletions(-)

--- a/mm/gup.c~fix-zero-copy-i-o-on-__get_user_pages-allocated-pages
+++ a/mm/gup.c
@@ -833,6 +833,20 @@ static inline bool can_follow_write_pte(
 	return !userfaultfd_pte_wp(vma, pte);
 }
 
+static struct page *gup_normal_page(struct vm_area_struct *vma,
+		unsigned long address, pte_t pte)
+{
+	unsigned long pfn;
+
+	if (vma->vm_flags & (VM_MIXEDMAP | VM_PFNMAP)) {
+		pfn = pte_pfn(pte);
+		if (!pfn_valid(pfn) || is_zero_pfn(pfn) || pfn > highest_memmap_pfn)
+			return NULL;
+		return pfn_to_page(pfn);
+	}
+	return vm_normal_page(vma, address, pte);
+}
+
 static struct page *follow_page_pte(struct vm_area_struct *vma,
 		unsigned long address, pmd_t *pmd, unsigned int flags,
 		struct dev_pagemap **pgmap)
@@ -858,7 +872,9 @@ static struct page *follow_page_pte(stru
 	if (pte_protnone(pte) && !gup_can_follow_protnone(vma, flags))
 		goto no_page;
 
-	page = vm_normal_page(vma, address, pte);
+	page = gup_normal_page(vma, address, pte);
+	if (page && (vma->vm_flags & (VM_MIXEDMAP | VM_PFNMAP)))
+		(void)follow_pfn_pte(vma, address, ptep, flags);
 
 	/*
 	 * We only care about anon pages in can_follow_write_pte() and don't
@@ -1130,7 +1146,7 @@ static int get_gate_page(struct mm_struc
 	*vma = get_gate_vma(mm);
 	if (!page)
 		goto out;
-	*page = vm_normal_page(*vma, address, entry);
+	*page = gup_normal_page(*vma, address, entry);
 	if (!*page) {
 		if ((gup_flags & FOLL_DUMP) || !is_zero_pfn(pte_pfn(entry)))
 			goto unmap;
@@ -1271,8 +1287,6 @@ static int check_vma_flags(struct vm_are
 	int foreign = (gup_flags & FOLL_REMOTE);
 	bool vma_anon = vma_is_anonymous(vma);
 
-	if (vm_flags & (VM_IO | VM_PFNMAP))
-		return -EFAULT;
 
 	if ((gup_flags & FOLL_ANON) && !vma_anon)
 		return -EFAULT;
_

Patches currently in -mm which might be from p.antoniou@partner.samsung.com are


