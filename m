Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 589091922D4
	for <mm-commits@vger.kernel.org>; Tue, 18 Mar 2025 05:07:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742274475; cv=none; b=SWBXy9W/LGFf4vM4XxAMxMu7q0a2gJfoskCWVIv5wTE6g8cbHVB1339VUvVtT/NG7Afrjxcde+2dyQ+6eECRWgK8re3ARZzQxPDEAZTo9HzEeDxUiRNDg6hCdiXY7N6n7iaR1Y5kMKmf2Fnx0NNTeywUaw6l/+D8k4+/azy1GHc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742274475; c=relaxed/simple;
	bh=sXRWv/u2sj3cKtrAiZEqPyW43SKn+q9iNkQuvVJT0P8=;
	h=Date:To:From:Subject:Message-Id; b=oCzkR5q8X93/cqZHESyeRB+lynlC7wsToEuHuH3B7qoFLzOy/1+/mQr3lW1NMGG2h2TrrPfWvT+BpZRr0iLxdBtpqE4ZDdkklQuSTfV06MjVt9PLOvZnHzYJU6ZdJEWeEpvvbQ8hHaIm+7JeySWDhZf1zueqzLXWe6aDl5W+ock=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=YX5E48Vp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="YX5E48Vp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC629C4CEDD;
	Tue, 18 Mar 2025 05:07:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742274474;
	bh=sXRWv/u2sj3cKtrAiZEqPyW43SKn+q9iNkQuvVJT0P8=;
	h=Date:To:From:Subject:From;
	b=YX5E48Vp75abfdnW1eoqqiof9OxqNoj+ZuGZCQlbc4mGDPnvuRs1ZRFYtdkdiWfoK
	 GVJeHEKYEZVDWlZjMUfAQG11/J6SA7DCfLFNkLJfF2Nkw1b4I8wC05tJ5ZLfpTiWcy
	 d8fFhLh5k3lrcSoJBk9Gth9Mppa1dm/fl+2nV3QA=
Date: Mon, 17 Mar 2025 22:07:54 -0700
To: mm-commits@vger.kernel.org,vishal.l.verma@intel.com,jane.chu@oracle.com,dave.jiang@intel.com,dan.j.williams@intel.com,apopple@nvidia.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] dax-remove-access-to-page-index.patch removed from -mm tree
Message-Id: <20250318050754.BC629C4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: dax: remove access to page->index
has been removed from the -mm tree.  Its filename was
     dax-remove-access-to-page-index.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: dax: remove access to page->index
Date: Mon, 16 Dec 2024 15:53:55 +0000

This looks like a complete mess (why are we setting page->index at page
fault time?), but I no longer care about DAX, and there's no reason to let
DAX hold us back from removing page->index.

Link: https://lkml.kernel.org/r/20241216155408.8102-1-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Jane Chu <jane.chu@oracle.com>
Reviewed-by: Dan Williams <dan.j.williams@intel.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Dave Jiang <dave.jiang@intel.com>
Cc: Vishal Verma <vishal.l.verma@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/dax/device.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

--- a/drivers/dax/device.c~dax-remove-access-to-page-index
+++ a/drivers/dax/device.c
@@ -89,14 +89,13 @@ static void dax_set_mapping(struct vm_fa
 			ALIGN_DOWN(vmf->address, fault_size));
 
 	for (i = 0; i < nr_pages; i++) {
-		struct page *page = pfn_to_page(pfn_t_to_pfn(pfn) + i);
+		struct folio *folio = pfn_folio(pfn_t_to_pfn(pfn) + i);
 
-		page = compound_head(page);
-		if (page->mapping)
+		if (folio->mapping)
 			continue;
 
-		page->mapping = filp->f_mapping;
-		page->index = pgoff + i;
+		folio->mapping = filp->f_mapping;
+		folio->index = pgoff + i;
 	}
 }
 
_

Patches currently in -mm which might be from willy@infradead.org are

mm-separate-folio_split_memcg_refs-from-split_page_memcg.patch
mm-simplify-split_page_memcg.patch
mm-remove-references-to-folio-in-split_page_memcg.patch
mm-simplify-folio_memcg_charged.patch
mm-remove-references-to-folio-in-__memcg_kmem_uncharge_page.patch

