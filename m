Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99681185952;
	Thu, 26 Sep 2024 21:04:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727384654; cv=none; b=qS847EvDFm/+Susglwd5LQHgTHEG2bcgVu1cdAz7F9cK/fg4a3O2oeNrjp1REk+8vepKs7d6776B/EwlSB8QIZW6x0IpKJqDm/TmJG/YtdlLBFZcnW4IDKhDB+xHj82ZhAYVsGw6dVZLZbjmwudobTp1TKH9kyNbasB2N6VH46M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727384654; c=relaxed/simple;
	bh=fG+RtLB4VoErJ+XdJ69nxyx6JG99W+412a8uvb/ojzw=;
	h=Date:To:From:Subject:Message-Id; b=CvrhOvtTgR7pt1wO9CisSV07XXuA9xi82R1JknyZLat2/omfoAVWVqU55I/9mh9Jrlc6Kku/VZSaYs3gCuuvtFapHOgPN27L4HN97JlBnnVsx0LsGzAZs5C3ebdhsJJu7C146tbIV97M7CmH8Y/ikBf9DywDK7u8vDkMGmluSxs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=bciMY2Ym; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="bciMY2Ym"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B852C4CEC7;
	Thu, 26 Sep 2024 21:04:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1727384654;
	bh=fG+RtLB4VoErJ+XdJ69nxyx6JG99W+412a8uvb/ojzw=;
	h=Date:To:From:Subject:From;
	b=bciMY2YmoKHbzcx0G8ksfgYFRmtz+dAjYDFGcJ/yWbDLsFqnHOZHI1ugjsVL6huEA
	 wkYRO/ibiKMDeOBUOQ6qoTFSMjRzFO9Fzz0mnLxAknLPisIZHbdT7vyM5JuR5SBXgY
	 ekbaF9Agq8oGhUZVHL3qCeZLremNmk/xzXm3LPs0=
Date: Thu, 26 Sep 2024 14:04:13 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,vivek.kasireddy@intel.com,stable@vger.kernel.org,peterx@redhat.com,muchun.song@linux.dev,jgg@nvidia.com,david@redhat.com,steven.sistare@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-hugetlb-simplify-refs-in-memfd_alloc_folio.patch removed from -mm tree
Message-Id: <20240926210414.6B852C4CEC7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/hugetlb: simplify refs in memfd_alloc_folio
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-simplify-refs-in-memfd_alloc_folio.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Steve Sistare <steven.sistare@oracle.com>
Subject: mm/hugetlb: simplify refs in memfd_alloc_folio
Date: Wed, 4 Sep 2024 12:41:08 -0700

The folio_try_get in memfd_alloc_folio is not necessary.  Delete it, and
delete the matching folio_put in memfd_pin_folios.  This also avoids
leaking a ref if the memfd_alloc_folio call to hugetlb_add_to_page_cache
fails.  That error path is also broken in a second way -- when its
folio_put causes the ref to become 0, it will implicitly call
free_huge_folio, but then the path *explicitly* calls free_huge_folio. 
Delete the latter.

This is a continuation of the fix
  "mm/hugetlb: fix memfd_pin_folios free_huge_pages leak"

[steven.sistare@oracle.com: remove explicit call to free_huge_folio(), per Matthew]
  Link: https://lkml.kernel.org/r/Zti-7nPVMcGgpcbi@casper.infradead.org
  Link: https://lkml.kernel.org/r/1725481920-82506-1-git-send-email-steven.sistare@oracle.com
Link: https://lkml.kernel.org/r/1725478868-61732-1-git-send-email-steven.sistare@oracle.com
Fixes: 89c1905d9c14 ("mm/gup: introduce memfd_pin_folios() for pinning memfd folios")
Signed-off-by: Steve Sistare <steven.sistare@oracle.com>
Suggested-by: Vivek Kasireddy <vivek.kasireddy@intel.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Peter Xu <peterx@redhat.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/gup.c   |    4 +---
 mm/memfd.c |    3 +--
 2 files changed, 2 insertions(+), 5 deletions(-)

--- a/mm/gup.c~mm-hugetlb-simplify-refs-in-memfd_alloc_folio
+++ a/mm/gup.c
@@ -3615,7 +3615,7 @@ long memfd_pin_folios(struct file *memfd
 	pgoff_t start_idx, end_idx, next_idx;
 	struct folio *folio = NULL;
 	struct folio_batch fbatch;
-	struct hstate *h = NULL;
+	struct hstate *h;
 	long ret = -EINVAL;
 
 	if (start < 0 || start > end || !max_folios)
@@ -3659,8 +3659,6 @@ long memfd_pin_folios(struct file *memfd
 							     &fbatch);
 			if (folio) {
 				folio_put(folio);
-				if (h)
-					folio_put(folio);
 				folio = NULL;
 			}
 
--- a/mm/memfd.c~mm-hugetlb-simplify-refs-in-memfd_alloc_folio
+++ a/mm/memfd.c
@@ -89,13 +89,12 @@ struct folio *memfd_alloc_folio(struct f
 						    numa_node_id(),
 						    NULL,
 						    gfp_mask);
-		if (folio && folio_try_get(folio)) {
+		if (folio) {
 			err = hugetlb_add_to_page_cache(folio,
 							memfd->f_mapping,
 							idx);
 			if (err) {
 				folio_put(folio);
-				free_huge_folio(folio);
 				return ERR_PTR(err);
 			}
 			folio_unlock(folio);
_

Patches currently in -mm which might be from steven.sistare@oracle.com are


