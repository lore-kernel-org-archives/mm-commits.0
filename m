Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793894090;
	b=s4ydd/kmkt2nomvLEYDsIGy4/Ukd0Np986VlZ5kc5YxzNYoBw0CSV2wL4Kay0jhsieRA
	 bfgXANTo2qHRXxiic4+Cxz2Ptceqz8bImf1kehvSJUxnje3DxdpAp+kAakgyCjIMjcROk
	 Y/AMnQiMS3XCT0id7h2V+zbRK3NqbAgV8YQPKvDcNTXMzSSqSRunU3NhKmZvO27aytecO
	 /Zjkz+kfHfutB9wZb4de+fFwsTQ7Snd4LSUcTGlmlJXR8eIRIjmr8ko4Tx/HimS81PIdI
	 +LTTxMm5Yavurqk06wFgSacagGKIyaEuE6oqtV83WEX74onkQKGOC/hOrx2Z8qsHaSw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793894090;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=64YMqBz7chW961kql7jvvOGlVAONZ8VVY6pRuAySItQ=;
	b=oCDrFOKpFA5j5Ik0exfgHxUO1svlBUdFt/sD9JhquTq6gmPKUVb3h0XL8sSG+wagP9/B
	 DOpaCboYYudszzDD3N8MNMN5u5MvigBzSk21HrqtLWSqER4a4KmWgKSYkk+1rr89xZh43
	 TOUF1P1ju9yRz/f2FvdUx1c/1CzXz7nr8GYMQCgyFmPxMKxgLQHq3N6tTBr9FA3a3MKNA
	 JK7Rt+MUnfB1GG82egRmma7JUace3PhPFcTG9yBWY7FRkrpdk8oiZiDfBXiV6N7qCOb+v
	 4NEsQucJaMzPbq9pI1pMijXq/m4/z0WhZeOU55AG8m7Xh+PH/+a6KQKSVS70YxVjo/Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=LoMvHbZb;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8C26606CF9E
	for <mm-commits@vger.kernel.org>; Thu,  5 Nov 2026 15:54:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=LoMvHbZb
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70E2D1F00A17;
	Thu,  5 Nov 2026 15:54:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793894089;
	bh=64YMqBz7chW961kql7jvvOGlVAONZ8VVY6pRuAySItQ=;
	h=Date:To:From:Subject;
	b=LoMvHbZb6GEuOTGm1JL1Ra0F3jfe2db+2qZ4WK9K6yGJPH5uAVA0VtanJHTAhappC
	 AAnPo/mfn9D38GyqljiO6V3P/ITjoKx15W58d9SCQ8YgMlToatYS8yGs4kohaR7Jwy
	 Nup3TqlHNuhdnIuNMiFYHkJsi7ZTkz2I+jGXEoPM=
Date: Thu, 05 Nov 2026 07:54:49 -0800
To: mm-commits@vger.kernel.org,tz2294@columbia.edu,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-remove-read_cache_page_gfp.patch removed from -mm tree
Message-Id: <20261105155449.70E2D1F00A17@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: mm: remove read_cache_page_gfp()
has been removed from the -mm tree.  Its filename was
     mm-remove-read_cache_page_gfp.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Tal Zussman <tz2294@columbia.edu>
Subject: mm: remove read_cache_page_gfp()
Date: Mon, 02 Nov 2026 17:54:12 -0500

There are no callers left. Point the comment on shmem_read_folio_gfp()
at mapping_read_folio_gfp() instead.

Link: https://lore.kernel.org/20261102-page-wrappers-v1-7-e7280bdb31f6@columbia.edu
Signed-off-by: Tal Zussman <tz2294@columbia.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: SJ Park <sj@kernel.org>
Acked-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Reviewed-by: Vishal Moola (Fractile) <vishal.moola@gmail.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Jan Kara <jack@suse.cz>
Cc: David Hildenbrand <david@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Byungchul Park <byungchul@sk.com>
Cc: Gregory Price <gourry@gourry.net>
Cc: Ying Huang <ying.huang@linux.alibaba.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
---

 include/linux/pagemap.h |    2 --
 mm/filemap.c            |   23 -----------------------
 mm/shmem.c              |    4 ++--
 3 files changed, 2 insertions(+), 27 deletions(-)

--- a/include/linux/pagemap.h~mm-remove-read_cache_page_gfp
+++ a/include/linux/pagemap.h
@@ -962,8 +962,6 @@ struct folio *mapping_read_folio_gfp(str
 		gfp_t flags);
 struct page *read_cache_page(struct address_space *, pgoff_t index,
 		filler_t *filler, struct file *file);
-extern struct page * read_cache_page_gfp(struct address_space *mapping,
-				pgoff_t index, gfp_t gfp_mask);
 
 static inline struct page *read_mapping_page(struct address_space *mapping,
 				pgoff_t index, struct file *file)
--- a/mm/filemap.c~mm-remove-read_cache_page_gfp
+++ a/mm/filemap.c
@@ -4260,29 +4260,6 @@ struct page *read_cache_page(struct addr
 }
 EXPORT_SYMBOL(read_cache_page);
 
-/**
- * read_cache_page_gfp - read into page cache, using specified page allocation flags.
- * @mapping:	the page's address_space
- * @index:	the page index
- * @gfp:	the page allocator flags to use if allocating
- *
- * This is the same as "read_mapping_page(mapping, index, NULL)", but with
- * any new page allocations done using the specified allocation flags.
- *
- * If the page does not get brought uptodate, return -EIO.
- *
- * The function expects mapping->invalidate_lock to be already held.
- *
- * Return: up to date page on success, ERR_PTR() on failure.
- */
-struct page *read_cache_page_gfp(struct address_space *mapping,
-				pgoff_t index,
-				gfp_t gfp)
-{
-	return do_read_cache_page(mapping, index, NULL, NULL, gfp);
-}
-EXPORT_SYMBOL(read_cache_page_gfp);
-
 /*
  * Warn about a page cache invalidation failure during a direct I/O write.
  */
--- a/mm/shmem.c~mm-remove-read_cache_page_gfp
+++ a/mm/shmem.c
@@ -6190,9 +6190,9 @@ int shmem_zero_setup_desc(struct vm_area
  * @index:	the folio index
  * @gfp:	the page allocator flags to use if allocating
  *
- * This behaves as a tmpfs "read_cache_page_gfp(mapping, index, gfp)",
+ * This behaves as a tmpfs "mapping_read_folio_gfp(mapping, index, gfp)",
  * with any new page allocations done using the specified allocation flags.
- * But read_cache_page_gfp() uses the ->read_folio() method: which does not
+ * But mapping_read_folio_gfp() uses the ->read_folio() method: which does not
  * suit tmpfs, since it may have pages in swapcache, and needs to find those
  * for itself; although drivers/gpu/drm i915 and ttm rely upon this support.
  *
_

Patches currently in -mm which might be from tz2294@columbia.edu are

mm-memcontrol-remove-mod_memcg_page_state.patch
mm-memcontrol-remove-page_memcg_check.patch
mm-userfaultfd-store-the-childs-new-uffd-context-in-the-wait-queue-entry.patch
mm-remove-thp_size-and-thp_order.patch

