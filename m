Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35E9D2853ED
	for <mm-commits@vger.kernel.org>; Thu, 10 Jul 2025 05:45:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752126302; cv=none; b=RRbXAQELno3mMTKPo1agaMaxBiXwzEUl2d/AnascJYjakymc4hByytrDci/tfv1vmvFJeEssy6C7ibsPjCruOHyEK4xrfapkpueGMnrsNUtbvWp3c9V/vsB/wOGDNDm4bjjzt8Iu8G88ZPRKr2Uz+CNxSjVwZLFFMq2b2deabwc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752126302; c=relaxed/simple;
	bh=24pDoxrcZwY4NG/sXNkw7LKVysl72Gb5/s8sZ/kCddg=;
	h=Date:To:From:Subject:Message-Id; b=DOLvEoGKZsaTOCuyBJ/HV6lWTWijHT9d2ATqPIH5VtrbiDuSr3+lbOspWBJ51IG+olAzeOU3hYdCIGeopp5xCg7LYsUO5LwypAPqTYEwRFFQtadPNNU0cazP04z+4pVNmgTpMO6aEvRSM/kQb29lJIlb9sS6YBzbVdAQTCSjdpc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=nH9uuaIM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="nH9uuaIM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01F69C4CEE3;
	Thu, 10 Jul 2025 05:45:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752126302;
	bh=24pDoxrcZwY4NG/sXNkw7LKVysl72Gb5/s8sZ/kCddg=;
	h=Date:To:From:Subject:From;
	b=nH9uuaIMVNp2B6eSnZfW/p7aEsI0U+OdtHYZdvYHr7jewT3WWC8WwMtHs8O7hYCX8
	 0OQ9rK2dLDDnBY47gmG0zZ5n+h7XUqMof1PfIwcw27jK/2D3j/ZDSW00mthFHXhcVW
	 9Ul+rhYn1posFYA4dt4yLifSjANj8Os+RfxgOHSc=
Date: Wed, 09 Jul 2025 22:45:01 -0700
To: mm-commits@vger.kernel.org,rppt@kernel.org,lorenzo.stoakes@oracle.com,david@redhat.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] secretmem-remove-uses-of-struct-page.patch removed from -mm tree
Message-Id: <20250710054502.01F69C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: secretmem: remove uses of struct page
has been removed from the -mm tree.  Its filename was
     secretmem-remove-uses-of-struct-page.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: secretmem: remove uses of struct page
Date: Fri, 13 Jun 2025 20:47:43 +0100

Use filemap_lock_folio() instead of find_lock_page() to retrieve
a folio from the page cache.

[lorenzo.stoakes@oracle.com: fix check of filemap_lock_folio() return value]
  Link: https://lkml.kernel.org/r/fdbca1d0-01a3-4653-85ed-cf257bb848be@lucifer.local
Link: https://lkml.kernel.org/r/20250613194744.3175157-1-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Acked-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/secretmem.c |   16 +++++++---------
 1 file changed, 7 insertions(+), 9 deletions(-)

--- a/mm/secretmem.c~secretmem-remove-uses-of-struct-page
+++ a/mm/secretmem.c
@@ -54,7 +54,6 @@ static vm_fault_t secretmem_fault(struct
 	pgoff_t offset = vmf->pgoff;
 	gfp_t gfp = vmf->gfp_mask;
 	unsigned long addr;
-	struct page *page;
 	struct folio *folio;
 	vm_fault_t ret;
 	int err;
@@ -65,16 +64,15 @@ static vm_fault_t secretmem_fault(struct
 	filemap_invalidate_lock_shared(mapping);
 
 retry:
-	page = find_lock_page(mapping, offset);
-	if (!page) {
+	folio = filemap_lock_folio(mapping, offset);
+	if (IS_ERR(folio)) {
 		folio = folio_alloc(gfp | __GFP_ZERO, 0);
 		if (!folio) {
 			ret = VM_FAULT_OOM;
 			goto out;
 		}
 
-		page = &folio->page;
-		err = set_direct_map_invalid_noflush(page);
+		err = set_direct_map_invalid_noflush(folio_page(folio, 0));
 		if (err) {
 			folio_put(folio);
 			ret = vmf_error(err);
@@ -90,7 +88,7 @@ retry:
 			 * already happened when we marked the page invalid
 			 * which guarantees that this call won't fail
 			 */
-			set_direct_map_default_noflush(page);
+			set_direct_map_default_noflush(folio_page(folio, 0));
 			if (err == -EEXIST)
 				goto retry;
 
@@ -98,11 +96,11 @@ retry:
 			goto out;
 		}
 
-		addr = (unsigned long)page_address(page);
+		addr = (unsigned long)folio_address(folio);
 		flush_tlb_kernel_range(addr, addr + PAGE_SIZE);
 	}
 
-	vmf->page = page;
+	vmf->page = folio_file_page(folio, vmf->pgoff);
 	ret = VM_FAULT_LOCKED;
 
 out:
@@ -154,7 +152,7 @@ static int secretmem_migrate_folio(struc
 
 static void secretmem_free_folio(struct folio *folio)
 {
-	set_direct_map_default_noflush(&folio->page);
+	set_direct_map_default_noflush(folio_page(folio, 0));
 	folio_zero_segment(folio, 0, folio_size(folio));
 }
 
_

Patches currently in -mm which might be from willy@infradead.org are

squashfs-pass-the-inode-to-squashfs_readahead_fragment.patch
squashfs-use-folios-in-squashfs_bio_read_cached.patch

