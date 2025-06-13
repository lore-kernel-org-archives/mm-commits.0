Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 738481DF258
	for <mm-commits@vger.kernel.org>; Fri, 13 Jun 2025 23:36:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749857761; cv=none; b=dVUONqo0QdP3KdZKEIqMATP27YVkvELh5i/fwTMaZO49ad+0gJxlz1k8YkygJbdnK64bonwFlJFcO4pqxhFIMy2CG+rpOqyRxX7B+rnfKhaCMbj4JBdBnIunyeKEProhXYc+kLoQOVX07Q60AvfG3IRaN/aGjPdTqDwCrbOu0YY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749857761; c=relaxed/simple;
	bh=PHlANqExt6tYyZtMD1CJVWX7Z0qoF92dWfKTfcG/qdg=;
	h=Date:To:From:Subject:Message-Id; b=fKPtMsDTfRlxuhdyVMGyKAMBEZkTLPvs6htJHy1pK1WTN9IVN4b3mf31fgv9seHwPg2xlO43ZJmf6icgvalzEaMKld2i44ZKthBXxUKmgTK5iHKZgLb+ZUK93xgul7YKfif5d7hi8/3DoxpgpM2X0UBizVNWa5quLgjv1doEmH4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=uqgcX8FK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="uqgcX8FK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C59F0C4CEE3;
	Fri, 13 Jun 2025 23:36:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1749857760;
	bh=PHlANqExt6tYyZtMD1CJVWX7Z0qoF92dWfKTfcG/qdg=;
	h=Date:To:From:Subject:From;
	b=uqgcX8FKLuLw/nqqmIsG3KUIw+dV5yVT5ue2cidIEjKUmHj1KYthFZozpanqt4653
	 tyeoCwGwbLeHL9s0jmmKohhUtLSzAXarU/UIkc3MkFym6I8+uS7dqM3oqsUOAXeqoh
	 dMXFC758mhYZZVy59jkQ3EmOK5+avvkPQ51/pbFk=
Date: Fri, 13 Jun 2025 16:36:00 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + secretmem-remove-uses-of-struct-page.patch added to mm-new branch
Message-Id: <20250613233600.C59F0C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: secretmem: remove uses of struct page
has been added to the -mm mm-new branch.  Its filename is
     secretmem-remove-uses-of-struct-page.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/secretmem-remove-uses-of-struct-page.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: secretmem: remove uses of struct page
Date: Fri, 13 Jun 2025 20:47:43 +0100

Use filemap_lock_folio() instead of find_lock_page() to retrieve
a folio from the page cache.

Link: https://lkml.kernel.org/r/20250613194744.3175157-1-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
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
+	if (!folio) {
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

mm-restore-documentation-for-__free_pages.patch
bio-use-memzero_page-in-bio_truncate.patch
null_blk-use-memzero_page.patch
direct-io-use-memzero_page.patch
ceph-convert-ceph_zero_partial_page-to-use-a-folio.patch
mm-remove-zero_user.patch
secretmem-remove-uses-of-struct-page.patch
highmem-remove-a-use-of-folio-page.patch
squashfs-pass-the-inode-to-squashfs_readahead_fragment.patch
squashfs-use-folios-in-squashfs_bio_read_cached.patch

