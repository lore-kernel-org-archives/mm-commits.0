Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCD0428DB3
	for <mm-commits@vger.kernel.org>; Sun, 21 Sep 2025 21:23:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758489822; cv=none; b=FuIlmSJU05hHlmDQcq/t49FVknmJZ3ugvSHnEBBYdRfEIgHbbqb26KVlYbE11jNnJp3tjPSdkcc2k1CpXgObfZDUJmmr6FrQfbXjg2/06MNUJcYxTSGkvmBDcUf2zp79BptL+db8UCpQ5j1cJuUFc3p0jwVmljnRIoRFcZIKyPM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758489822; c=relaxed/simple;
	bh=eh14pwGWEddgiSrWdgjecPoKwKxTdATFyyWoedTbLMs=;
	h=Date:To:From:Subject:Message-Id; b=kMvqzg59hikOXGTN2nh9F/I1gXxBVDqO8+qkH8EEDiAbSKWswoEIo2xGSBSjTX931KJgo2NStC0avJDjKDUnv5VlTTnL3NDKtZ7ky8dKpBEEcUpFr7FbDJNCmW9qH04yEzM42bb0RbF1xd6rUa7sbMQPY6FUIsbPWRTOqunO7H4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=IlZBOkc4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="IlZBOkc4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 936D5C4CEE7;
	Sun, 21 Sep 2025 21:23:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1758489822;
	bh=eh14pwGWEddgiSrWdgjecPoKwKxTdATFyyWoedTbLMs=;
	h=Date:To:From:Subject:From;
	b=IlZBOkc4qu7WI07+7Xv2KrDD9HSrvU3fB9VjW4WPiTPU2sGCw7Fv16Vaj5A4y/slT
	 6Vl2qfrY7IeLfBD3b3UvDmav1AvFqF4Axmd/mCGiNJWbRCPu1mbMteVeZdBgPQwFP/
	 xDpLNXTUhyTAAIlC8FxX1olYOJQCvsjhdKMt4kxA=
Date: Sun, 21 Sep 2025 14:23:42 -0700
To: mm-commits@vger.kernel.org,rppt@kernel.org,lorenzo.stoakes@oracle.com,Liam.Howlett@oracle.com,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-hugetlb-cleanup-hugetlb_folio_init_tail_vmemmap.patch removed from -mm tree
Message-Id: <20250921212342.936D5C4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/hugetlb: cleanup hugetlb_folio_init_tail_vmemmap()
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-cleanup-hugetlb_folio_init_tail_vmemmap.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: mm/hugetlb: cleanup hugetlb_folio_init_tail_vmemmap()
Date: Mon, 1 Sep 2025 17:03:34 +0200

We can now safely iterate over all pages in a folio, so no need for the
pfn_to_page().

Also, as we already force the refcount in __init_single_page() to 1
through init_page_count(), we can just set the refcount to 0 and avoid
page_ref_freeze() + VM_BUG_ON.  Likely, in the future, we would just want
to tell __init_single_page() to which value to initialize the refcount.

Further, adjust the comments to highlight that we are dealing with an
open-coded prep_compound_page() variant, and add another comment
explaining why we really need the __init_single_page() only on the tail
pages.

Note that the current code was likely problematic, but we never ran into
it: prep_compound_tail() would have been called with an offset that might
exceed a memory section, and prep_compound_tail() would have simply added
that offset to the page pointer -- which would not have done the right
thing on sparsemem without vmemmap.

Link: https://lkml.kernel.org/r/20250901150359.867252-14-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Acked-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |   20 ++++++++++++--------
 1 file changed, 12 insertions(+), 8 deletions(-)

--- a/mm/hugetlb.c~mm-hugetlb-cleanup-hugetlb_folio_init_tail_vmemmap
+++ a/mm/hugetlb.c
@@ -3237,17 +3237,18 @@ static void __init hugetlb_folio_init_ta
 {
 	enum zone_type zone = zone_idx(folio_zone(folio));
 	int nid = folio_nid(folio);
+	struct page *page = folio_page(folio, start_page_number);
 	unsigned long head_pfn = folio_pfn(folio);
 	unsigned long pfn, end_pfn = head_pfn + end_page_number;
-	int ret;
-
-	for (pfn = head_pfn + start_page_number; pfn < end_pfn; pfn++) {
-		struct page *page = pfn_to_page(pfn);
 
+	/*
+	 * As we marked all tail pages with memblock_reserved_mark_noinit(),
+	 * we must initialize them ourselves here.
+	 */
+	for (pfn = head_pfn + start_page_number; pfn < end_pfn; page++, pfn++) {
 		__init_single_page(page, pfn, zone, nid);
 		prep_compound_tail((struct page *)folio, pfn - head_pfn);
-		ret = page_ref_freeze(page, 1);
-		VM_BUG_ON(!ret);
+		set_page_count(page, 0);
 	}
 }
 
@@ -3257,12 +3258,15 @@ static void __init hugetlb_folio_init_vm
 {
 	int ret;
 
-	/* Prepare folio head */
+	/*
+	 * This is an open-coded prep_compound_page() whereby we avoid
+	 * walking pages twice by initializing/preparing+freezing them in the
+	 * same go.
+	 */
 	__folio_clear_reserved(folio);
 	__folio_set_head(folio);
 	ret = folio_ref_freeze(folio, 1);
 	VM_BUG_ON(!ret);
-	/* Initialize the necessary tail struct pages */
 	hugetlb_folio_init_tail_vmemmap(folio, 1, nr_pages);
 	prep_compound_head((struct page *)folio, huge_page_order(h));
 }
_

Patches currently in -mm which might be from david@redhat.com are


