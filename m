Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EA8C3A9D82
	for <mm-commits@vger.kernel.org>; Tue, 24 Feb 2026 17:55:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771955757; cv=none; b=QStT2wI2jnqU36BddymuuRROLH9nOKJIVB/Us055IvAN73N/ujNG6S8DImDq3JM8dGp1+l4dt9qfyzqU8jsRkCaF8uTDfvtmCFhm5L2CGHZv1HBHciSPTsJ0kfcB4V4w/BaC9wuDre9wlqeS+Tvth71ou2RROw7qGHCuUhA3GpY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771955757; c=relaxed/simple;
	bh=h7muWKh+RdhKFKWIv4RPl0fk72BvxWw1/9zvvNHrqtM=;
	h=Date:To:From:Subject:Message-Id; b=Tu5wdmqMGjLKcPY/XVXWO/B2OMulgjPA8WFFXTsQKwNftdoen0IEqVdyTmZOBOgKJyES5RsRzdLi4U/lhYyE5yOCNyZw772p8Ph0kMosmvTGll4tR349Jt/4Iy1MkRuBYoRVksqq9UYntJWVZjBIee3YQzRpLkZi2iqX7clpIwM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=RAsztMXs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="RAsztMXs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D075CC19422;
	Tue, 24 Feb 2026 17:55:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1771955756;
	bh=h7muWKh+RdhKFKWIv4RPl0fk72BvxWw1/9zvvNHrqtM=;
	h=Date:To:From:Subject:From;
	b=RAsztMXsY9ywiavto9+zTHnPxnqJptPPBelEbw8tyrqDPZOytNeeuXPHnH7pnQPPD
	 MPM384uvE3mxZ2AcC8lzjHUcCgXhLoauZSFmLFaiPXPmKA74FugNsV3MVgmSTltIzt
	 J9Uju6beQ0/viON8aEbpGM/4NeUbSCX++h9qUWUk=
Date: Tue, 24 Feb 2026 09:55:56 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,yuzhao@google.com,willy@infradead.org,vbabka@suse.cz,usamaarif642@gmail.com,toke@redhat.com,tariqt@nvidia.com,surenb@google.com,sfr@canb.auug.org.au,sdf@fomichev.me,saeedm@nvidia.com,rppt@kernel.org,pabeni@redhat.com,mhocko@suse.com,mbloch@nvidia.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,leon@kernel.org,kuba@kernel.org,john.fastabend@gmail.com,jackmanb@google.com,ilias.apalodimas@linaro.org,horms@kernel.org,hawk@kernel.org,hannes@cmpxchg.org,edumazet@google.com,dw@davidwei.uk,dtatulea@nvidia.com,david@redhat.com,davem@davemloft.net,daniel@iogearbox.net,brauner@kernel.org,baolin.wang@linux.alibaba.com,ast@kernel.org,asml.silence@gmail.com,ap420073@gmail.com,andrew+netdev@lunn.ch,almasrymina@google.com,byungchul@sk.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-introduce-a-new-page-type-for-page-pool-in-page-type.patch added to mm-new branch
Message-Id: <20260224175556.D075CC19422@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: introduce a new page type for page pool in page type
has been added to the -mm mm-new branch.  Its filename is
     mm-introduce-a-new-page-type-for-page-pool-in-page-type.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-introduce-a-new-page-type-for-page-pool-in-page-type.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Byungchul Park <byungchul@sk.com>
Subject: mm: introduce a new page type for page pool in page type
Date: Tue, 24 Feb 2026 14:13:47 +0900

Currently, the condition 'page->pp_magic == PP_SIGNATURE' is used to
determine if a page belongs to a page pool.  However, with the planned
removal of @pp_magic, we should instead leverage the page_type in struct
page, such as PGTY_netpp, for this purpose.

Introduce and use the page type APIs e.g.  PageNetpp(), __SetPageNetpp(),
and __ClearPageNetpp() instead, and remove the existing APIs accessing
@pp_magic e.g.  page_pool_page_is_pp(), netmem_or_pp_magic(), and
netmem_clear_pp_magic().

Plus, add @page_type to struct net_iov at the same offset as struct page
so as to use the page_type APIs for struct net_iov as well.  While at it,
reorder @type and @owner in struct net_iov to avoid a hole and increasing
the struct size.

This work was inspired by the following link:

  https://lore.kernel.org/all/582f41c0-2742-4400-9c81-0d46bf4e8314@gmail.com/

While at it, move the sanity check for page pool to on the free path.

Link: https://lkml.kernel.org/r/20260224051347.19621-1-byungchul@sk.com
Co-developed-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Byungchul Park <byungchul@sk.com>
Suggested-by: David Hildenbrand <david@redhat.com>
Acked-by: David Hildenbrand <david@redhat.com>
Acked-by: Zi Yan <ziy@nvidia.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: Toke Høiland-Jørgensen <toke@redhat.com>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Andrew Lunn <andrew+netdev@lunn.ch>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Brendan Jackman <jackmanb@google.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Daniel Borkman <daniel@iogearbox.net>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: David S. Miller <davem@davemloft.net>
Cc: David Wei <dw@davidwei.uk>
Cc: Dragos Tatulea <dtatulea@nvidia.com>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Ilias Apalodimas <ilias.apalodimas@linaro.org>
Cc: Jakub Kacinski <kuba@kernel.org>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Jesper Dangaard Brouer <hawk@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: John Fastabend <john.fastabend@gmail.com>
Cc: Leon Romanovsky <leon@kernel.org>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Mark Bloch <mbloch@nvidia.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Mina Almasry <almasrymina@google.com>
Cc: Paolo Abeni <pabeni@redhat.com>
Cc: Saeed Mahameed <saeedm@nvidia.com>
Cc: Simon Horman <horms@kernel.org>
Cc: Stanislav Fomichev <sdf@fomichev.me>
Cc: Stehen Rothwell <sfr@canb.auug.org.au>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Taehee Yoo <ap420073@gmail.com>
Cc: Tariq Toukan <tariqt@nvidia.com>
Cc: Usama Arif <usamaarif642@gmail.com>
Cc: Yu Zhao <yuzhao@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c |    2 
 include/linux/mm.h                               |   27 +------------
 include/linux/page-flags.h                       |    6 ++
 include/net/netmem.h                             |   15 ++++++-
 mm/page_alloc.c                                  |   11 +++--
 net/core/netmem_priv.h                           |   23 ++++-------
 net/core/page_pool.c                             |   24 ++++++++++-
 7 files changed, 62 insertions(+), 46 deletions(-)

--- a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c~mm-introduce-a-new-page-type-for-page-pool-in-page-type
+++ a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
@@ -707,7 +707,7 @@ static void mlx5e_free_xdpsq_desc(struct
 				xdpi = mlx5e_xdpi_fifo_pop(xdpi_fifo);
 				page = xdpi.page.page;
 
-				/* No need to check page_pool_page_is_pp() as we
+				/* No need to check PageNetpp() as we
 				 * know this is a page_pool page.
 				 */
 				page_pool_recycle_direct(pp_page_to_nmdesc(page)->pp,
--- a/include/linux/mm.h~mm-introduce-a-new-page-type-for-page-pool-in-page-type
+++ a/include/linux/mm.h
@@ -4824,10 +4824,9 @@ int arch_lock_shadow_stack_status(struct
  * DMA mapping IDs for page_pool
  *
  * When DMA-mapping a page, page_pool allocates an ID (from an xarray) and
- * stashes it in the upper bits of page->pp_magic. We always want to be able to
- * unambiguously identify page pool pages (using page_pool_page_is_pp()). Non-PP
- * pages can have arbitrary kernel pointers stored in the same field as pp_magic
- * (since it overlaps with page->lru.next), so we must ensure that we cannot
+ * stashes it in the upper bits of page->pp_magic. Non-PP pages can have
+ * arbitrary kernel pointers stored in the same field as pp_magic (since
+ * it overlaps with page->lru.next), so we must ensure that we cannot
  * mistake a valid kernel pointer with any of the values we write into this
  * field.
  *
@@ -4862,26 +4861,6 @@ int arch_lock_shadow_stack_status(struct
 #define PP_DMA_INDEX_MASK GENMASK(PP_DMA_INDEX_BITS + PP_DMA_INDEX_SHIFT - 1, \
 				  PP_DMA_INDEX_SHIFT)
 
-/* Mask used for checking in page_pool_page_is_pp() below. page->pp_magic is
- * OR'ed with PP_SIGNATURE after the allocation in order to preserve bit 0 for
- * the head page of compound page and bit 1 for pfmemalloc page, as well as the
- * bits used for the DMA index. page_is_pfmemalloc() is checked in
- * __page_pool_put_page() to avoid recycling the pfmemalloc page.
- */
-#define PP_MAGIC_MASK ~(PP_DMA_INDEX_MASK | 0x3UL)
-
-#ifdef CONFIG_PAGE_POOL
-static inline bool page_pool_page_is_pp(const struct page *page)
-{
-	return (page->pp_magic & PP_MAGIC_MASK) == PP_SIGNATURE;
-}
-#else
-static inline bool page_pool_page_is_pp(const struct page *page)
-{
-	return false;
-}
-#endif
-
 #define PAGE_SNAPSHOT_FAITHFUL (1 << 0)
 #define PAGE_SNAPSHOT_PG_BUDDY (1 << 1)
 #define PAGE_SNAPSHOT_PG_IDLE  (1 << 2)
--- a/include/linux/page-flags.h~mm-introduce-a-new-page-type-for-page-pool-in-page-type
+++ a/include/linux/page-flags.h
@@ -939,6 +939,7 @@ enum pagetype {
 	PGTY_zsmalloc		= 0xf6,
 	PGTY_unaccepted		= 0xf7,
 	PGTY_large_kmalloc	= 0xf8,
+	PGTY_netpp		= 0xf9,
 
 	PGTY_mapcount_underflow = 0xff
 };
@@ -1071,6 +1072,11 @@ PAGE_TYPE_OPS(Zsmalloc, zsmalloc, zsmall
 PAGE_TYPE_OPS(Unaccepted, unaccepted, unaccepted)
 PAGE_TYPE_OPS(LargeKmalloc, large_kmalloc, large_kmalloc)
 
+/*
+ * Marks page_pool allocated pages.
+ */
+PAGE_TYPE_OPS(Netpp, netpp, netpp)
+
 /**
  * PageHuge - Determine if the page belongs to hugetlbfs
  * @page: The page to test.
--- a/include/net/netmem.h~mm-introduce-a-new-page-type-for-page-pool-in-page-type
+++ a/include/net/netmem.h
@@ -110,10 +110,21 @@ struct net_iov {
 			atomic_long_t pp_ref_count;
 		};
 	};
-	struct net_iov_area *owner;
+
+	unsigned int page_type;
 	enum net_iov_type type;
+	struct net_iov_area *owner;
 };
 
+/* Make sure 'the offset of page_type in struct page == the offset of
+ * type in struct net_iov'.
+ */
+#define NET_IOV_ASSERT_OFFSET(pg, iov)			\
+	static_assert(offsetof(struct page, pg) ==	\
+		      offsetof(struct net_iov, iov))
+NET_IOV_ASSERT_OFFSET(page_type, page_type);
+#undef NET_IOV_ASSERT_OFFSET
+
 struct net_iov_area {
 	/* Array of net_iovs for this area. */
 	struct net_iov *niovs;
@@ -256,7 +267,7 @@ static inline unsigned long netmem_pfn_t
  */
 #define pp_page_to_nmdesc(p)						\
 ({									\
-	DEBUG_NET_WARN_ON_ONCE(!page_pool_page_is_pp(p));		\
+	DEBUG_NET_WARN_ON_ONCE(!PageNetpp(p));				\
 	__pp_page_to_nmdesc(p);						\
 })
 
--- a/mm/page_alloc.c~mm-introduce-a-new-page-type-for-page-pool-in-page-type
+++ a/mm/page_alloc.c
@@ -1079,7 +1079,6 @@ static inline bool page_expected_state(s
 #ifdef CONFIG_MEMCG
 			page->memcg_data |
 #endif
-			page_pool_page_is_pp(page) |
 			(page->flags.f & check_flags)))
 		return false;
 
@@ -1106,8 +1105,6 @@ static const char *page_bad_reason(struc
 	if (unlikely(page->memcg_data))
 		bad_reason = "page still charged to cgroup";
 #endif
-	if (unlikely(page_pool_page_is_pp(page)))
-		bad_reason = "page_pool leak";
 	return bad_reason;
 }
 
@@ -1416,9 +1413,15 @@ __always_inline bool __free_pages_prepar
 		mod_mthp_stat(order, MTHP_STAT_NR_ANON, -1);
 		folio->mapping = NULL;
 	}
-	if (unlikely(page_has_type(page)))
+	if (unlikely(page_has_type(page))) {
+		/* networking expects to clear its page type before releasing */
+		if (unlikely(PageNetpp(page))) {
+			bad_page(page, "page_pool leak");
+			return false;
+		}
 		/* Reset the page_type (which overlays _mapcount) */
 		page->page_type = UINT_MAX;
+	}
 
 	if (is_check_pages_enabled()) {
 		if (free_page_is_bad(page))
--- a/net/core/netmem_priv.h~mm-introduce-a-new-page-type-for-page-pool-in-page-type
+++ a/net/core/netmem_priv.h
@@ -8,21 +8,18 @@ static inline unsigned long netmem_get_p
 	return netmem_to_nmdesc(netmem)->pp_magic & ~PP_DMA_INDEX_MASK;
 }
 
-static inline void netmem_or_pp_magic(netmem_ref netmem, unsigned long pp_magic)
-{
-	netmem_to_nmdesc(netmem)->pp_magic |= pp_magic;
-}
-
-static inline void netmem_clear_pp_magic(netmem_ref netmem)
-{
-	WARN_ON_ONCE(netmem_to_nmdesc(netmem)->pp_magic & PP_DMA_INDEX_MASK);
-
-	netmem_to_nmdesc(netmem)->pp_magic = 0;
-}
-
 static inline bool netmem_is_pp(netmem_ref netmem)
 {
-	return (netmem_get_pp_magic(netmem) & PP_MAGIC_MASK) == PP_SIGNATURE;
+	struct page *page;
+
+	/* XXX: Now that the offset of page_type is shared between
+	 * struct page and net_iov, just cast the netmem to struct page
+	 * unconditionally by clearing NET_IOV if any, no matter whether
+	 * it comes from struct net_iov or struct page.  This should be
+	 * adjusted once the offset is no longer shared.
+	 */
+	page = (struct page *)((__force unsigned long)netmem & ~NET_IOV);
+	return PageNetpp(page);
 }
 
 static inline void netmem_set_pp(netmem_ref netmem, struct page_pool *pool)
--- a/net/core/page_pool.c~mm-introduce-a-new-page-type-for-page-pool-in-page-type
+++ a/net/core/page_pool.c
@@ -702,8 +702,18 @@ s32 page_pool_inflight(const struct page
 
 void page_pool_set_pp_info(struct page_pool *pool, netmem_ref netmem)
 {
+	struct page *page;
+
 	netmem_set_pp(netmem, pool);
-	netmem_or_pp_magic(netmem, PP_SIGNATURE);
+
+	/* XXX: Now that the offset of page_type is shared between
+	 * struct page and net_iov, just cast the netmem to struct page
+	 * unconditionally by clearing NET_IOV if any, no matter whether
+	 * it comes from struct net_iov or struct page.  This should be
+	 * adjusted once the offset is no longer shared.
+	 */
+	page = (struct page *)((__force unsigned long)netmem & ~NET_IOV);
+	__SetPageNetpp(page);
 
 	/* Ensuring all pages have been split into one fragment initially:
 	 * page_pool_set_pp_info() is only called once for every page when it
@@ -718,7 +728,17 @@ void page_pool_set_pp_info(struct page_p
 
 void page_pool_clear_pp_info(netmem_ref netmem)
 {
-	netmem_clear_pp_magic(netmem);
+	struct page *page;
+
+	/* XXX: Now that the offset of page_type is shared between
+	 * struct page and net_iov, just cast the netmem to struct page
+	 * unconditionally by clearing NET_IOV if any, no matter whether
+	 * it comes from struct net_iov or struct page.  This should be
+	 * adjusted once the offset is no longer shared.
+	 */
+	page = (struct page *)((__force unsigned long)netmem & ~NET_IOV);
+	__ClearPageNetpp(page);
+
 	netmem_set_pp(netmem, NULL);
 }
 
_

Patches currently in -mm which might be from byungchul@sk.com are

mm-introduce-a-new-page-type-for-page-pool-in-page-type.patch

