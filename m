Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABD1421FF57
	for <mm-commits@vger.kernel.org>; Wed,  6 Aug 2025 23:41:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754523716; cv=none; b=lYeQPgmjXNivX5Hb0odqAdhCxJ1x7VPXEUq5H47anCXds2KJT9IJg/xymXyOWllHGbvxJpgybyuao/0M3lYF+laHzBUL0rckasCDpKoby6m/SAlPqfnbCE9kqGwVfuPFLfk7+NvTEtdlBrJUBX03yYfkKEIOpjGplTduxB4J8iU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754523716; c=relaxed/simple;
	bh=iBh+pxmoEN2ORMRFYYHdua9evKXUKRS9aQPmKpMsmDg=;
	h=Date:To:From:Subject:Message-Id; b=PyRqmU1GAStwaWT5j9leOvrSM3OegkaxuUIir6xfbObfDbz+EeB9OtymQYxjjF/mxTj2PN3962rpeMiDAblKIWeaSfH0iPCXdpmJWn0FvWXo9IgUn/K8f9XA7L3Hlrm7bvwTVWZPDOVo+zfreNFocCJNaiB08vSJquQLuQcN1TQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=abywMGdB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="abywMGdB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28E77C4CEE7;
	Wed,  6 Aug 2025 23:41:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1754523716;
	bh=iBh+pxmoEN2ORMRFYYHdua9evKXUKRS9aQPmKpMsmDg=;
	h=Date:To:From:Subject:From;
	b=abywMGdBWS6c8Ty1qQi56jNGw3VtKAZhpNAe+EgZb58sKrMR5OHurffUVwTvwRHvs
	 PG+5AeXHrvTr8mte3tD/SEWxEIcLb+wtk7+O6uzeR0b3sFpPAMMjLPfoMDxBgVM7tm
	 UIppA8dtoQimU9cZS5anEFSvlx94KuLfaGsNN1n8=
Date: Wed, 06 Aug 2025 16:41:55 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,vbabka@suse.cz,sj@kernel.org,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,jannh@google.com,sidhartha.kumar@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-nommu-convert-kobjsize-to-folios.patch added to mm-new branch
Message-Id: <20250806234156.28E77C4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/nommu: convert kobjsize() to folios
has been added to the -mm mm-new branch.  Its filename is
     mm-nommu-convert-kobjsize-to-folios.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-nommu-convert-kobjsize-to-folios.patch

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
From: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Subject: mm/nommu: convert kobjsize() to folios
Date: Mon, 4 Aug 2025 14:51:17 +0000

Simple folio conversion to remove a user of PageSlab() and PageCompound().

Link: https://lkml.kernel.org/r/20250804145117.3857308-1-sidhartha.kumar@oracle.com
Signed-off-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Reviewed-by: SeongJae Park <sj@kernel.org>
Cc: Jann Horn <jannh@google.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/nommu.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

--- a/mm/nommu.c~mm-nommu-convert-kobjsize-to-folios
+++ a/mm/nommu.c
@@ -64,7 +64,7 @@ const struct vm_operations_struct generi
  */
 unsigned int kobjsize(const void *objp)
 {
-	struct page *page;
+	struct folio *folio;
 
 	/*
 	 * If the object we have should not have ksize performed on it,
@@ -73,22 +73,22 @@ unsigned int kobjsize(const void *objp)
 	if (!objp || !virt_addr_valid(objp))
 		return 0;
 
-	page = virt_to_head_page(objp);
+	folio = virt_to_folio(objp);
 
 	/*
 	 * If the allocator sets PageSlab, we know the pointer came from
 	 * kmalloc().
 	 */
-	if (PageSlab(page))
+	if (folio_test_slab(folio))
 		return ksize(objp);
 
 	/*
-	 * If it's not a compound page, see if we have a matching VMA
+	 * If it's not a large folio, see if we have a matching VMA
 	 * region. This test is intentionally done in reverse order,
 	 * so if there's no VMA, we still fall through and hand back
-	 * PAGE_SIZE for 0-order pages.
+	 * PAGE_SIZE for 0-order folios.
 	 */
-	if (!PageCompound(page)) {
+	if (!folio_test_large(folio)) {
 		struct vm_area_struct *vma;
 
 		vma = find_vma(current->mm, (unsigned long)objp);
@@ -100,7 +100,7 @@ unsigned int kobjsize(const void *objp)
 	 * The ksize() function is only guaranteed to work for pointers
 	 * returned by kmalloc(). So handle arbitrary pointers here.
 	 */
-	return page_size(page);
+	return folio_size(folio);
 }
 
 void vfree(const void *addr)
_

Patches currently in -mm which might be from sidhartha.kumar@oracle.com are

mm-nommu-convert-kobjsize-to-folios.patch

