Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 151FA215F43
	for <mm-commits@vger.kernel.org>; Mon, 17 Mar 2025 05:12:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742188345; cv=none; b=RBk1EFF1CTKaKF2pim8MiUKxDq7CF//4DNTHHXV45HKCsq6vc8wxjrtCVwVHoHyiRwXJlkkZXeETjRvTyreze7hDPCzH3jsjTceN0EctQLC066ZJdIAsyD/5ZzyoAHsDyGzvnLQJqp1RtNUkxjvuzQAKjn35mh4+tZx7P2Kbczw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742188345; c=relaxed/simple;
	bh=kOyaIsKhJE2dJzMcqLczxnKpgr1ZG7zGkgtEuUJrwRU=;
	h=Date:To:From:Subject:Message-Id; b=ia9FOz9MassaQFF2Ez2Q295PByVOgYiXpiHwO3ol42bwWJAoDBuQdKY1dHnyU4A48e2bK0Jw5zwJLHU17DURiW1uZotq/OM+l/v1kOG1VDnWB2hTmAn5FVM9YYRWRAEIwWrJtjYMs/B+Su0w49Q48VEzmjuMrjyuzlzWyDsDMe8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=j39ZrV8V; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="j39ZrV8V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBE97C4CEEC;
	Mon, 17 Mar 2025 05:12:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742188344;
	bh=kOyaIsKhJE2dJzMcqLczxnKpgr1ZG7zGkgtEuUJrwRU=;
	h=Date:To:From:Subject:From;
	b=j39ZrV8V9w9I6L+nxgVI5V6fIs3HsdmmkeIC9zS4s2aHWaVKoyw6BkyZEokx1ShzS
	 PxFkJZchngFpWwuH2QP1oNqprMLhiM9za4wobxSmZX9vSnNONNsyzjvfxNyqhIwwsB
	 L/NFScnesCm017nA4VoEHjxMQeHW4BSwVRfcXl7Y=
Date: Sun, 16 Mar 2025 22:12:24 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] fs-remove-page_file_mapping.patch removed from -mm tree
Message-Id: <20250317051224.DBE97C4CEEC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: fs: remove page_file_mapping()
has been removed from the -mm tree.  Its filename was
     fs-remove-page_file_mapping.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: fs: remove page_file_mapping()
Date: Mon, 17 Feb 2025 19:20:07 +0000

This wrapper has no more callers.  Delete it.

Link: https://lkml.kernel.org/r/20250217192009.437916-2-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pagemap.h |    5 -----
 1 file changed, 5 deletions(-)

--- a/include/linux/pagemap.h~fs-remove-page_file_mapping
+++ a/include/linux/pagemap.h
@@ -575,11 +575,6 @@ static inline struct address_space *foli
 	return folio_mapping(folio);
 }
 
-static inline struct address_space *page_file_mapping(struct page *page)
-{
-	return folio_file_mapping(page_folio(page));
-}
-
 /**
  * folio_inode - Get the host inode for this folio.
  * @folio: The folio.
_

Patches currently in -mm which might be from willy@infradead.org are

dax-remove-access-to-page-index.patch
dax-use-folios-more-widely-within-dax.patch
hugetlb-convert-hugetlb_vma_maps_page-to-hugetlb_vma_maps_pfn.patch
hugetlb-convert-adjust_range_hwpoison-to-take-a-folio.patch
mm-convert-lru_add_page_tail-to-lru_add_split_folio.patch
mm-separate-folio_split_memcg_refs-from-split_page_memcg.patch
mm-simplify-split_page_memcg.patch
mm-remove-references-to-folio-in-split_page_memcg.patch
mm-simplify-folio_memcg_charged.patch
mm-remove-references-to-folio-in-__memcg_kmem_uncharge_page.patch
ocfs2-use-memcpy_to_folio-in-ocfs2_symlink_get_block.patch
ocfs2-remove-reference-to-bh-b_page.patch

