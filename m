Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B87114B815
	for <mm-commits@vger.kernel.org>; Thu, 22 Feb 2024 21:43:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708638217; cv=none; b=e9a9jKoeG2hAwDBSH0HzNruYor/xEhF7WIsVlqJRK+6d81hSgDHm+7tvF8eh0YAV3GUFn0Ivbwkw6EC3aOzMp1fu26EdfgH032mYmPx0le+XvVnUghUbAgICepWgpHGyBkwTHjsGu0nayGQoCovNSUqYbJA1C+VmlXG3SAUHsM8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708638217; c=relaxed/simple;
	bh=6Rh8YPcbHP2qBIBJsc+6oCCajXrHuAREeIeOhF4KUow=;
	h=Date:To:From:Subject:Message-Id; b=a+DOHnKPESifHeOYVUEXFSu47X6MgYFaMvxFwozY0a1kEEnhg/1pbyiu7E5o/QrPo1r2xzjb/JYbREJapdlZzZObAR2QsF7ZK3ud/BkXPg6lPynr4/ZO9Fdcqe0CL7WtP1w3gYP59lvgmy9C71/a0a1Vus+vw4N9zAGDnf2KeLA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=K5InEUHt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="K5InEUHt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1710C433C7;
	Thu, 22 Feb 2024 21:43:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708638216;
	bh=6Rh8YPcbHP2qBIBJsc+6oCCajXrHuAREeIeOhF4KUow=;
	h=Date:To:From:Subject:From;
	b=K5InEUHtsGMr175w38b2ZkhQ8HUkRfBzeP3IZNuaYx4E6aRjxQXkrygtDmFhc2ZTt
	 fw8DExtxCM2oKPMkIzE4qu9iBWBgIHHh7uRbO3XaoQc0K2X2y4hp31EsyK4hxfgr2r
	 TFlRXC5Pxs0cyUnPgyhLoqMuR8OwGmLyrFKml/Ik=
Date: Thu, 22 Feb 2024 13:43:36 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,muchun.song@linux.dev,vishal.moola@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + hugetlb-move-vm_struct-declaration-to-the-top-of-hugetlb_fault.patch added to mm-unstable branch
Message-Id: <20240222214336.A1710C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: hugetlb: move vm_fault declaration to the top of hugetlb_fault()
has been added to the -mm mm-unstable branch.  Its filename is
     hugetlb-move-vm_struct-declaration-to-the-top-of-hugetlb_fault.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/hugetlb-move-vm_struct-declaration-to-the-top-of-hugetlb_fault.patch

This patch will later appear in the mm-unstable branch at
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
From: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
Subject: hugetlb: move vm_fault declaration to the top of hugetlb_fault()
Date: Wed, 21 Feb 2024 15:47:29 -0800

hugetlb_fault() currently defines a vm_fault to pass to the generic
handle_userfault() function.  We can move this definition to the top of
hugetlb_fault() so that it can be used throughout the rest of the hugetlb
fault path.

This will help cleanup a number of excess variables and function arguments
throughout the stack.  Also, since vm_fault already has space to store the
page offset, use that instead and get rid of idx.

Link: https://lkml.kernel.org/r/20240221234732.187629-3-vishal.moola@gmail.com
Signed-off-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Muchun Song <muchun.song@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |   32 +++++++++++++++++++-------------
 1 file changed, 19 insertions(+), 13 deletions(-)

--- a/mm/hugetlb.c~hugetlb-move-vm_struct-declaration-to-the-top-of-hugetlb_fault
+++ a/mm/hugetlb.c
@@ -6465,13 +6465,25 @@ vm_fault_t hugetlb_fault(struct mm_struc
 	spinlock_t *ptl;
 	vm_fault_t ret;
 	u32 hash;
-	pgoff_t idx;
 	struct folio *folio = NULL;
 	struct folio *pagecache_folio = NULL;
 	struct hstate *h = hstate_vma(vma);
 	struct address_space *mapping;
 	int need_wait_lock = 0;
 	unsigned long haddr = address & huge_page_mask(h);
+	struct vm_fault vmf = {
+		.vma = vma,
+		.address = haddr,
+		.real_address = address,
+		.flags = flags,
+		.pgoff = vma_hugecache_offset(h, vma, haddr),
+		/* TODO: Track hugetlb faults using vm_fault */
+
+		/*
+		 * Some fields may not be initialized, be careful as it may
+		 * be hard to debug if called functions make assumptions
+		 */
+	};
 
 	/* TODO: Handle faults under the VMA lock */
 	if (flags & FAULT_FLAG_VMA_LOCK) {
@@ -6485,8 +6497,7 @@ vm_fault_t hugetlb_fault(struct mm_struc
 	 * the same page in the page cache.
 	 */
 	mapping = vma->vm_file->f_mapping;
-	idx = vma_hugecache_offset(h, vma, haddr);
-	hash = hugetlb_fault_mutex_hash(mapping, idx);
+	hash = hugetlb_fault_mutex_hash(mapping, vmf.pgoff);
 	mutex_lock(&hugetlb_fault_mutex_table[hash]);
 
 	/*
@@ -6520,8 +6531,9 @@ vm_fault_t hugetlb_fault(struct mm_struc
 		 * hugetlb_no_page will drop vma lock and hugetlb fault
 		 * mutex internally, which make us return immediately.
 		 */
-		return hugetlb_no_page(mm, vma, mapping, idx, address, ptep,
-				      entry, flags);
+
+		return hugetlb_no_page(mm, vma, mapping, vmf.pgoff, address,
+					ptep, entry, flags);
 	}
 
 	ret = 0;
@@ -6567,7 +6579,8 @@ vm_fault_t hugetlb_fault(struct mm_struc
 		/* Just decrements count, does not deallocate */
 		vma_end_reservation(h, vma, haddr);
 
-		pagecache_folio = filemap_lock_hugetlb_folio(h, mapping, idx);
+		pagecache_folio = filemap_lock_hugetlb_folio(h, mapping,
+							     vmf.pgoff);
 		if (IS_ERR(pagecache_folio))
 			pagecache_folio = NULL;
 	}
@@ -6582,13 +6595,6 @@ vm_fault_t hugetlb_fault(struct mm_struc
 	if (userfaultfd_wp(vma) && huge_pte_uffd_wp(huge_ptep_get(ptep)) &&
 	    (flags & FAULT_FLAG_WRITE) && !huge_pte_write(entry)) {
 		if (!userfaultfd_wp_async(vma)) {
-			struct vm_fault vmf = {
-				.vma = vma,
-				.address = haddr,
-				.real_address = address,
-				.flags = flags,
-			};
-
 			spin_unlock(ptl);
 			if (pagecache_folio) {
 				folio_unlock(pagecache_folio);
_

Patches currently in -mm which might be from vishal.moola@gmail.com are

mm-memory-change-vmf_anon_prepare-to-be-non-static.patch
hugetlb-move-vm_struct-declaration-to-the-top-of-hugetlb_fault.patch
hugetlb-pass-struct-vm_fault-through-to-hugetlb_handle_userfault.patch
hugetlb-use-vmf_anon_prepare-instead-of-anon_vma_prepare.patch
hugetlb-allow-faults-to-be-handled-under-the-vma-lock.patch

