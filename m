Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88B5B8C07
	for <mm-commits@vger.kernel.org>; Tue,  5 Mar 2024 01:02:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709600525; cv=none; b=mjll6ntFOQJippvscl7zcLFfo+j8/7n6ztHhZ81ytD117TXEv8b9w0vBKMcRrmADnHM4wPorQ17wG3R8RwvqZVTcJY889fIzFU+wO+z8I2bUZAQIm+lN4RLx2at5FptN77Z5thvl3cboIlgE3d9Jrc1vPVj0YWrkNXtM1GWVYzE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709600525; c=relaxed/simple;
	bh=X+1d4mxmQ0HVN8JgpkMs38lgHDmU9MCWzkHTu0hTRXQ=;
	h=Date:To:From:Subject:Message-Id; b=omLYPAAOnhiN0f1HqF07OFHy8pC8+QWAfutw6DdtdlZBTWR3w/n0qOssnT89rSPdSmQ7LeEMLwQHJPiUfM6xgDzlXzZSFbyaA7e8Gbd2fMthybGVkFXBtlc4nnyjqzr4qyArdtaJVPrtiE3RaZ+UT9Zb33O7piAN+4jyi8xfvzQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=U7iQtD5f; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="U7iQtD5f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B6D5C43390;
	Tue,  5 Mar 2024 01:02:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1709600525;
	bh=X+1d4mxmQ0HVN8JgpkMs38lgHDmU9MCWzkHTu0hTRXQ=;
	h=Date:To:From:Subject:From;
	b=U7iQtD5fVlhqkkubqm42Zc4DOU7r/aOVI4IQwJ75Rb8vemVRHxMf9I/OzLXFlnYdJ
	 UbevsfUKx3bbexVJCFbxfIkHCAfZzXvj6/agG8+hZY9pQ7oXhZ5KaUy+N8u6l2VB5s
	 I0iu4FVt2SavNP64cYKl6jc6VTmfrr8UfQ1jmIjs=
Date: Mon, 04 Mar 2024 17:02:04 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,muchun.song@linux.dev,vishal.moola@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] hugetlb-move-vm_struct-declaration-to-the-top-of-hugetlb_fault.patch removed from -mm tree
Message-Id: <20240305010205.5B6D5C43390@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: hugetlb: move vm_fault declaration to the top of hugetlb_fault()
has been removed from the -mm tree.  Its filename was
     hugetlb-move-vm_struct-declaration-to-the-top-of-hugetlb_fault.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
@@ -6378,13 +6378,25 @@ vm_fault_t hugetlb_fault(struct mm_struc
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
@@ -6398,8 +6410,7 @@ vm_fault_t hugetlb_fault(struct mm_struc
 	 * the same page in the page cache.
 	 */
 	mapping = vma->vm_file->f_mapping;
-	idx = vma_hugecache_offset(h, vma, haddr);
-	hash = hugetlb_fault_mutex_hash(mapping, idx);
+	hash = hugetlb_fault_mutex_hash(mapping, vmf.pgoff);
 	mutex_lock(&hugetlb_fault_mutex_table[hash]);
 
 	/*
@@ -6433,8 +6444,9 @@ vm_fault_t hugetlb_fault(struct mm_struc
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
@@ -6480,7 +6492,8 @@ vm_fault_t hugetlb_fault(struct mm_struc
 		/* Just decrements count, does not deallocate */
 		vma_end_reservation(h, vma, haddr);
 
-		pagecache_folio = filemap_lock_hugetlb_folio(h, mapping, idx);
+		pagecache_folio = filemap_lock_hugetlb_folio(h, mapping,
+							     vmf.pgoff);
 		if (IS_ERR(pagecache_folio))
 			pagecache_folio = NULL;
 	}
@@ -6495,13 +6508,6 @@ vm_fault_t hugetlb_fault(struct mm_struc
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


