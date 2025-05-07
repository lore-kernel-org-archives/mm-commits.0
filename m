Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FF7322688B
	for <mm-commits@vger.kernel.org>; Wed,  7 May 2025 21:55:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746654956; cv=none; b=Z8fzcbUJaAOiy9xzrYHmjyaUo8XQSv1PeCUB/0IHg7us7HCGnE9cHE230d2k0tFNWTnAbYaXilRMbs45TholszCprKvc+k4WGtzlKIUEVn/tsCFxa3ANwBM+i62XIJ/IJ8WWU8TdmmjKg/Amc1Mk30bc1mv+/0eDt76DXbwFEtY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746654956; c=relaxed/simple;
	bh=/aPI31MeYhdVzKuGTf50QtL9yRLIpyW1dWIiiiCiC4U=;
	h=Date:To:From:Subject:Message-Id; b=LP9CzOVEMeE1WJmBixwQp7PRlq1i27l1HBmTcy+HiH/BqaC5tXqaUO9u7Q+bdoMNMdwVliP9TMdDIPbqKSeZ0q0cepYhcj1BR9J7t4gdRuJrCO2FfaeDHDu2bLNjZiYNvfvRxYmeCutofjtJDioMRvEjkoH7XW47h/6XlMAkZPM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=RLNkBcgk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="RLNkBcgk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81672C4CEE2;
	Wed,  7 May 2025 21:55:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1746654955;
	bh=/aPI31MeYhdVzKuGTf50QtL9yRLIpyW1dWIiiiCiC4U=;
	h=Date:To:From:Subject:From;
	b=RLNkBcgkmAaCp6IXgXYUkA3ehI/4gekUjz7k/QaOzcnRQfw5C01G4/XK0TWjEI+h9
	 6lv1Z7MDKgfJFTTl8H6cmdSfweyJc7Aqq6Tix+fr3sZH2WR31l0Mp4HyWonoxVmRrF
	 TIFFVW0r3OJgpLpMXEw/N3/vj4CajNccWlQJEmTo=
Date: Wed, 07 May 2025 14:55:54 -0700
To: mm-commits@vger.kernel.org,wade.farnsworth@siemens.com,peterx@redhat.com,jhubbard@nvidia.com,jgg@ziepe.ca,david@redhat.com,c.briere@samsung.com,artem.k@samsung.com,p.antoniou@partner.samsung.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + fix-zero-copy-i-o-on-__get_user_pages-allocated-pages.patch added to mm-hotfixes-unstable branch
Message-Id: <20250507215555.81672C4CEE2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: Fix zero copy I/O on __get_user_pages allocated pages
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     fix-zero-copy-i-o-on-__get_user_pages-allocated-pages.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/fix-zero-copy-i-o-on-__get_user_pages-allocated-pages.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

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

fix-zero-copy-i-o-on-__get_user_pages-allocated-pages.patch

