Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90825322B
	for <mm-commits@vger.kernel.org>; Wed, 28 May 2025 02:39:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748399956; cv=none; b=dvgzkWV0Al6Dh/DOdSM96EBXqgwgbIfiIHOyxHG3Bf6yCtw9JOWRgKNOzwbnJ4BpuQVffzKXGk/FYgUHju15K+sgv50AcZtWWdeNwUeK5pNOOLWrerjgDtHmZ8uuXiDPEEiq0hpnTRYw5ALyXtlY4Pqx1+spIitWRxwB9Mnl8aI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748399956; c=relaxed/simple;
	bh=laK3mfWN0jpjr+UxV2ygvBDEOw9P5/lqxgcbxsBcSvE=;
	h=Date:To:From:Subject:Message-Id; b=lthoHejLf8aEau+qqt3uiL86x1hfX+oJ7IYHKkQyXQsgIeZILsGZ+hE5BynRF7Dv/fZ5NOSzDBmYva7yro7ea76lIc4BeVMH1nm+aA9XzvIjthP1Yt0U4z/or4JEwu13Pgk7HawdfQj1FTLy6+OpTFzuul/ym14pRI88uvcWjm8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=FFWT5et3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="FFWT5et3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50C71C4CEE9;
	Wed, 28 May 2025 02:39:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1748399954;
	bh=laK3mfWN0jpjr+UxV2ygvBDEOw9P5/lqxgcbxsBcSvE=;
	h=Date:To:From:Subject:From;
	b=FFWT5et3W1ZzNp7dvJpye8+YcJSt5Eez6lkxiF8f7c3TkCTqQYVQvhI6KFEWblQW4
	 BxKDGXDOOvUQGhyUN0UmkI3SRWCA0Ihmb5QRu6ssdlgadrqxh9SI/i/saFul9qEwC8
	 Jn98OUQBHXTVf38C4bVPUtKmZ7xTyRS3kwNNcM/U=
Date: Tue, 27 May 2025 19:39:13 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,vishal.moola@gmail.com,sidhartha.kumar@oracle.com,osalvador@suse.de,muchun.song@linux.dev,david@redhat.com,fan.ni@samsung.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-hugetlb-pass-folio-instead-of-page-to-unmap_ref_private.patch removed from -mm tree
Message-Id: <20250528023914.50C71C4CEE9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/hugetlb: pass folio instead of page to unmap_ref_private()
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-pass-folio-instead-of-page-to-unmap_ref_private.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Fan Ni <fan.ni@samsung.com>
Subject: mm/hugetlb: pass folio instead of page to unmap_ref_private()
Date: Mon, 5 May 2025 11:22:41 -0700

Patch series "Let unmap_hugepage_range() and several related functions
take folio instead of page", v4.


This patch (of 4):

unmap_ref_private() has only a single user, which passes in &folio->page. 
Let it take the folio directly.

Link: https://lkml.kernel.org/r/20250505182345.506888-2-nifan.cxl@gmail.com
Link: https://lkml.kernel.org/r/20250505182345.506888-3-nifan.cxl@gmail.com
Signed-off-by: Fan Ni <fan.ni@samsung.com>
Reviewed-by: Muchun Song <muchun.song@linux.dev>
Reviewed-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/mm/hugetlb.c~mm-hugetlb-pass-folio-instead-of-page-to-unmap_ref_private
+++ a/mm/hugetlb.c
@@ -6071,7 +6071,7 @@ void unmap_hugepage_range(struct vm_area
  * same region.
  */
 static void unmap_ref_private(struct mm_struct *mm, struct vm_area_struct *vma,
-			      struct page *page, unsigned long address)
+			      struct folio *folio, unsigned long address)
 {
 	struct hstate *h = hstate_vma(vma);
 	struct vm_area_struct *iter_vma;
@@ -6115,7 +6115,8 @@ static void unmap_ref_private(struct mm_
 		 */
 		if (!is_vma_resv_set(iter_vma, HPAGE_RESV_OWNER))
 			unmap_hugepage_range(iter_vma, address,
-					     address + huge_page_size(h), page, 0);
+					     address + huge_page_size(h),
+					     &folio->page, 0);
 	}
 	i_mmap_unlock_write(mapping);
 }
@@ -6238,8 +6239,7 @@ retry_avoidcopy:
 			hugetlb_vma_unlock_read(vma);
 			mutex_unlock(&hugetlb_fault_mutex_table[hash]);
 
-			unmap_ref_private(mm, vma, &old_folio->page,
-					vmf->address);
+			unmap_ref_private(mm, vma, old_folio, vmf->address);
 
 			mutex_lock(&hugetlb_fault_mutex_table[hash]);
 			hugetlb_vma_lock_read(vma);
_

Patches currently in -mm which might be from fan.ni@samsung.com are


