Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58512C8CE
	for <mm-commits@vger.kernel.org>; Mon, 20 Jan 2025 01:39:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737337143; cv=none; b=WOOijGbh61yg1SoVjDjxOnVtM9ZHa3VNTj06RRlj0Z6PF0LPaTTNPcJeVii9ws3ZwSWqX5DCr/HrfB9Z/aokLKfNHd2U1PO70w4rr5pxCLL7SsvKKiQW08NRwOpM7D3nHGw9olMvtUT+WCV+zBhfS9EyWK0CsFgp69JwJ6CgTEo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737337143; c=relaxed/simple;
	bh=rlTumtGnMN4C/4TCp1hBCmoRg/URahlZY47RAR67pUc=;
	h=Date:To:From:Subject:Message-Id; b=VP2VNRH59ECDZixRQQcNy7NsTdAYEda05OTXuUFwp+Moj1I8aTfhyIvq3C7gVkNMrnTyWP8gwycjeAxBBWEXDUtlp9rSj+8OdzL3pO5vRr5KHbE+8ko8sVeiiOXjefrUwW3QXRk6fr6PE0BCF0rxZQi2cRjuHr6I5Pd1UKAfWLY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=l56Wskmr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="l56Wskmr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B36D9C4CED6;
	Mon, 20 Jan 2025 01:39:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1737337142;
	bh=rlTumtGnMN4C/4TCp1hBCmoRg/URahlZY47RAR67pUc=;
	h=Date:To:From:Subject:From;
	b=l56Wskmrk/ea/QzKdpW3vFssvt+H7IotCbK7hesku109X9DbwV7y/pXSusdLEHIWM
	 yqsAU3D/9GvVMhi9rsWp34ZaZyHSLDt4yrmt8qzH0azrUOzSL09dgZBrD2sI21Zz6n
	 MVfQXLZ8MfrOQJ3ou6V41UrZmUtsN7yM+wNS4kuw=
Date: Sun, 19 Jan 2025 17:39:02 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,kirill.shutemov@linux.intel.com,hch@lst.de,hannes@cmpxchg.org,clm@meta.com,bfoster@redhat.com,axboe@kernel.dk,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-readahead-add-folio-allocation-helper.patch removed from -mm tree
Message-Id: <20250120013902.B36D9C4CED6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/readahead: add folio allocation helper
has been removed from the -mm tree.  Its filename was
     mm-readahead-add-folio-allocation-helper.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Jens Axboe <axboe@kernel.dk>
Subject: mm/readahead: add folio allocation helper
Date: Fri, 20 Dec 2024 08:47:41 -0700

Just a wrapper around filemap_alloc_folio() for now, but add it in
preparation for modifying the folio based on the 'ractl' being passed in.

No functional changes in this patch.

Link: https://lkml.kernel.org/r/20241220154831.1086649-4-axboe@kernel.dk
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Reviewed-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Brian Foster <bfoster@redhat.com>
Cc: Chris Mason <clm@meta.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/readahead.c |   16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

--- a/mm/readahead.c~mm-readahead-add-folio-allocation-helper
+++ a/mm/readahead.c
@@ -178,6 +178,12 @@ static void read_pages(struct readahead_
 	BUG_ON(readahead_count(rac));
 }
 
+static struct folio *ractl_alloc_folio(struct readahead_control *ractl,
+				       gfp_t gfp_mask, unsigned int order)
+{
+	return filemap_alloc_folio(gfp_mask, order);
+}
+
 /**
  * page_cache_ra_unbounded - Start unchecked readahead.
  * @ractl: Readahead control.
@@ -255,8 +261,8 @@ void page_cache_ra_unbounded(struct read
 			continue;
 		}
 
-		folio = filemap_alloc_folio(gfp_mask,
-					    mapping_min_folio_order(mapping));
+		folio = ractl_alloc_folio(ractl, gfp_mask,
+					mapping_min_folio_order(mapping));
 		if (!folio)
 			break;
 
@@ -426,7 +432,7 @@ static inline int ra_alloc_folio(struct
 		pgoff_t mark, unsigned int order, gfp_t gfp)
 {
 	int err;
-	struct folio *folio = filemap_alloc_folio(gfp, order);
+	struct folio *folio = ractl_alloc_folio(ractl, gfp, order);
 
 	if (!folio)
 		return -ENOMEM;
@@ -751,7 +757,7 @@ void readahead_expand(struct readahead_c
 		if (folio && !xa_is_value(folio))
 			return; /* Folio apparently present */
 
-		folio = filemap_alloc_folio(gfp_mask, min_order);
+		folio = ractl_alloc_folio(ractl, gfp_mask, min_order);
 		if (!folio)
 			return;
 
@@ -780,7 +786,7 @@ void readahead_expand(struct readahead_c
 		if (folio && !xa_is_value(folio))
 			return; /* Folio apparently present */
 
-		folio = filemap_alloc_folio(gfp_mask, min_order);
+		folio = ractl_alloc_folio(ractl, gfp_mask, min_order);
 		if (!folio)
 			return;
 
_

Patches currently in -mm which might be from axboe@kernel.dk are


