Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D87AF7DA9E
	for <mm-commits@vger.kernel.org>; Wed,  6 Nov 2024 00:59:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730854762; cv=none; b=ZijIjQd7LJRqMFoUzhaJdYVDWSXpXEKw3fF4UgUQO0ae8DPe7YLzCrpAusrrm/5LNThigrdgjetGC+ghoe2sSY2cVht8zA51Ak0DXU0TYE9maobUklBeH30Xrx7At6UNxC1sK9ZwXDV9/CkPquVcb+slhC2GxQWD5rvWBpIcKKw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730854762; c=relaxed/simple;
	bh=9bS3aLDSc9zIFBQBWB5l+n4K4MQ/oeagbsAKTpi3N0A=;
	h=Date:To:From:Subject:Message-Id; b=PvXGyvD8P+t56wxxdVdn5wPHK8jOfGoDmipaEnqdbqj/996eMOd8nNgLYVgXTe8G3X/sOYhalVBxs3q5bRlSBNUN3KD5aJ1vkH15xrT37aPN5e19Yh2mdvkNmfYl3yw6oBT/kAmLsl9xgYWvRVNBShWDhOE2Qp5DDICBXuJ7yGo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=axQ93hOt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="axQ93hOt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF1C7C4CED3;
	Wed,  6 Nov 2024 00:59:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1730854762;
	bh=9bS3aLDSc9zIFBQBWB5l+n4K4MQ/oeagbsAKTpi3N0A=;
	h=Date:To:From:Subject:From;
	b=axQ93hOt7tiVZdP0IGmh6cKu62ADrcYEk15rEfvnwSaBNQ+wMdI40HHHjmSZZG9FK
	 HFcYy7alfogn/gSqkFB3VnB5ysMDXBYZsZv9FN4KHPHuaiquBgFjgDBcJJfGw2rGaW
	 lC8uZkhkN+OW16XAV3IiDhJFZOwWaVcAeDYnvMyA=
Date: Tue, 05 Nov 2024 16:59:22 -0800
To: mm-commits@vger.kernel.org,david@redhat.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] gup-convert-foll_touch-case-in-follow_page_pte-to-folio.patch removed from -mm tree
Message-Id: <20241106005922.AF1C7C4CED3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: gup: convert FOLL_TOUCH case in follow_page_pte() to folio
has been removed from the -mm tree.  Its filename was
     gup-convert-foll_touch-case-in-follow_page_pte-to-folio.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: gup: convert FOLL_TOUCH case in follow_page_pte() to folio
Date: Wed, 2 Oct 2024 16:13:27 +0100

We already have the folio here, so just use it, removing three hidden
calls to compound_head().

Link: https://lkml.kernel.org/r/20241002151403.1345296-1-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Acked-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/gup.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/mm/gup.c~gup-convert-foll_touch-case-in-follow_page_pte-to-folio
+++ a/mm/gup.c
@@ -922,14 +922,14 @@ static struct page *follow_page_pte(stru
 	}
 	if (flags & FOLL_TOUCH) {
 		if ((flags & FOLL_WRITE) &&
-		    !pte_dirty(pte) && !PageDirty(page))
-			set_page_dirty(page);
+		    !pte_dirty(pte) && !folio_test_dirty(folio))
+			folio_mark_dirty(folio);
 		/*
 		 * pte_mkyoung() would be more correct here, but atomic care
 		 * is needed to avoid losing the dirty bit: it is easier to use
-		 * mark_page_accessed().
+		 * folio_mark_accessed().
 		 */
-		mark_page_accessed(page);
+		folio_mark_accessed(folio);
 	}
 out:
 	pte_unmap_unlock(ptep, ptl);
_

Patches currently in -mm which might be from willy@infradead.org are

mm-convert-page_to_pgoff-to-page_pgoff.patch
mm-use-page_pgoff-in-more-places.patch
mm-renovate-page_address_in_vma.patch
mm-mass-constification-of-folio-page-pointers.patch
bootmem-stop-using-page-index.patch
mm-remove-references-to-page-index-in-huge_memoryc.patch
mm-use-page-private-instead-of-page-index-in-percpu.patch
nilfs2-remove-nilfs_writepage.patch
nilfs2-convert-nilfs_page_count_clean_buffers-to-take-a-folio.patch
nilfs2-convert-nilfs_recovery_copy_block-to-take-a-folio.patch
nilfs2-convert-metadata-aops-from-writepage-to-writepages.patch

