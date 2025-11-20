Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35CE5348457
	for <mm-commits@vger.kernel.org>; Thu, 20 Nov 2025 21:44:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763675075; cv=none; b=CUUZJ4v6CTdp/teJ922uy8zcOqxy+XkXbD5LnFJtN2cV8O7EtQpLa6LJPvPJouGGbyC/VnlL1N+41fCZZZ/G5IGZwKdgP8uc9dkF2I1RhL0gJx9onFQzv4nPqiDmAuU96rNXCneJ1DvyByUC85w9xFSllqaGACryFOf5Zyn73kY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763675075; c=relaxed/simple;
	bh=BtslTS7xHKPD7ipOMLr+Aba9sqAeVjKEmK1zX2ZuWNQ=;
	h=Date:To:From:Subject:Message-Id; b=CCWyy1/w3BapNNkAONnwhjG7zC2uQ0xAmZoha1A3oTqrFWlW3oZftXNjoBrMrvEYrl4ouS+Do2+3+2yg7yo1HYt7skcL0y8PzkRy1HbDp2jqb+HSyCwJWGj+H/ZistSlyoskW9KZXyXeaDpvKmglMgnY13k0rJLuhJ2f2d2IqmY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=kqwl4Pjl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="kqwl4Pjl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1DE8C116C6;
	Thu, 20 Nov 2025 21:44:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763675074;
	bh=BtslTS7xHKPD7ipOMLr+Aba9sqAeVjKEmK1zX2ZuWNQ=;
	h=Date:To:From:Subject:From;
	b=kqwl4PjlsxKePQXmFuPdSboNZ+tCVGS+oCINgZ+eeXCwchkzYhu7u5jFHXwhuoAAu
	 t7C7ZZLTRSfAALTLiZTLqUfvP4vUV60TdO0Zidu7K7dBpFCnmfieIqkTRC1A7/drvX
	 +b9fygGI+zb0jR6Baym5aJN/PWUSAi/AbOjgTSnM=
Date: Thu, 20 Nov 2025 13:44:34 -0800
To: mm-commits@vger.kernel.org,zhengqi.arch@bytedance.com,willy@infradead.org,shakeel.butt@linux.dev,mhocko@kernel.org,lorenzo.stoakes@oracle.com,hughd@google.com,hannes@cmpxchg.org,david@redhat.com,baolin.wang@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-vmscan-simplify-the-folio-refcount-check-in-pageout.patch removed from -mm tree
Message-Id: <20251120214434.D1DE8C116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: vmscan: simplify the folio refcount check in pageout()
has been removed from the -mm tree.  Its filename was
     mm-vmscan-simplify-the-folio-refcount-check-in-pageout.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Baolin Wang <baolin.wang@linux.alibaba.com>
Subject: mm: vmscan: simplify the folio refcount check in pageout()
Date: Thu, 18 Sep 2025 11:46:54 +0800

Since we no longer attempt to write back filesystem folios in pageout()
(they will be filtered out by the following check in pageout()), and only
tmpfs/shmem folios and anonymous swapcache folios can be written back, we
can remove the redundant folio_test_private() when checking the folio's
refcount, as tmpfs/shmem and swapcache folios do not use the PG_private
flag.

While we're at it, we can open-code the folio refcount check instead of
adding a simple helper that has only one user.

Link: https://lkml.kernel.org/r/4cbbec5bb92397aa4597105f1f499aabf7a1901c.1758166683.git.baolin.wang@linux.alibaba.com
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Acked-by: David Hildenbrand <david@redhat.com>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Hugh Dickins <hughd@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Qi Zheng <zhengqi.arch@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   16 ++++------------
 1 file changed, 4 insertions(+), 12 deletions(-)

--- a/mm/vmscan.c~mm-vmscan-simplify-the-folio-refcount-check-in-pageout
+++ a/mm/vmscan.c
@@ -477,17 +477,6 @@ static int reclaimer_offset(struct scan_
 	return PGSTEAL_DIRECT - PGSTEAL_KSWAPD;
 }
 
-static inline int is_page_cache_freeable(struct folio *folio)
-{
-	/*
-	 * A freeable page cache folio is referenced only by the caller
-	 * that isolated the folio, the page cache and optional filesystem
-	 * private data at folio->private.
-	 */
-	return folio_ref_count(folio) - folio_test_private(folio) ==
-		1 + folio_nr_pages(folio);
-}
-
 /*
  * We detected a synchronous write error writing a folio out.  Probably
  * -ENOSPC.  We need to propagate that into the address_space for a subsequent
@@ -696,8 +685,11 @@ static pageout_t pageout(struct folio *f
 	 * block, for some throttling. This happens by accident, because
 	 * swap_backing_dev_info is bust: it doesn't reflect the
 	 * congestion state of the swapdevs.  Easy to fix, if needed.
+	 *
+	 * A freeable shmem or swapcache folio is referenced only by the
+	 * caller that isolated the folio and the page cache.
 	 */
-	if (!is_page_cache_freeable(folio) || !mapping)
+	if (folio_ref_count(folio) != 1 + folio_nr_pages(folio) || !mapping)
 		return PAGE_KEEP;
 	if (!shmem_mapping(mapping) && !folio_test_anon(folio))
 		return PAGE_ACTIVATE;
_

Patches currently in -mm which might be from baolin.wang@linux.alibaba.com are

mm-shmem-allow-fallback-to-smaller-large-orders-for-tmpfs-mmap-access.patch

