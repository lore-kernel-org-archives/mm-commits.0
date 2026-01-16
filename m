Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D5DC54723
	for <mm-commits@vger.kernel.org>; Fri, 16 Jan 2026 23:15:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768605323; cv=none; b=upenc8sz8n+BwGWJTnlaN6hpVYYHvJ4fYmb47V9T7FlyDFqSTkzDqfckTiH06fBhUOX7KRoQw798E02WJC5CahnJwFbSpN2dC8AErG5OeAsbpbz9bUsZrKHzhpeY8lcUAudyq8WiQvwReqyWkVRBU/kz4fSfUg6CPHEtqYloLQU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768605323; c=relaxed/simple;
	bh=WG373QqU+IrpXyrYsZjKnErzzQOJHzMt4Qa+Qhc5lHc=;
	h=Date:To:From:Subject:Message-Id; b=bOrI/A8vTslmYf7ljcxzY3Cb/SnOtRYpqwILautzos22fTQFreV5wx4MQf7XJ82LQA+uZW2+UM3th5VcC4WjQUsWJSnxxO7LYqk0S6iPwHZZ5d/AOVSy4IaW1bT9zetLjXgISh1MF5hSgorrwr5ZLznqgtUmubudsmkVGV5X+ms=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=giyKmBpZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="giyKmBpZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C03DC116C6;
	Fri, 16 Jan 2026 23:15:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768605323;
	bh=WG373QqU+IrpXyrYsZjKnErzzQOJHzMt4Qa+Qhc5lHc=;
	h=Date:To:From:Subject:From;
	b=giyKmBpZCVIQtkH2mjcdhvqXZYZuBhuq0jb/pqE7Ul10kuvncwm5zj6ITGNyY8Byg
	 YLDHgWpTPMK0Efhmmx2rFR0RbRSWD5DMYcVu9/7uo/gy0vV6NQvjaal6MRFy87y5a5
	 DhUZSKERzDE6vxb/NblMJ1GYvV1pMRgVSLrCcM5Y=
Date: Fri, 16 Jan 2026 15:15:22 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,yuzhao@google.com,willy@infradead.org,vbabka@suse.cz,usamaarif642@gmail.com,toke@redhat.com,tariqt@nvidia.com,surenb@google.com,sfr@canb.auug.org.au,sdf@fomichev.me,saeedm@nvidia.com,rppt@kernel.org,pabeni@redhat.com,mhocko@suse.com,mbloch@nvidia.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,leon@kernel.org,kuba@kernel.org,john.fastabend@gmail.com,jackmanb@google.com,ilias.apalodimas@linaro.org,horms@kernel.org,hawk@kernel.org,hannes@cmpxchg.org,edumazet@google.com,dw@davidwei.uk,dtatulea@nvidia.com,david@redhat.com,davem@davemloft.net,daniel@iogearbox.net,brauner@kernel.org,baolin.wang@linux.alibaba.com,ast@kernel.org,asml.silence@gmail.com,ap420073@gmail.com,almasrymina@google.com,byungchul@sk.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [failures] mm-introduce-a-new-page-type-for-page-pool-in-page-type.patch removed from -mm tree
Message-Id: <20260116231523.0C03DC116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: introduce a new page type for page pool in page type
has been removed from the -mm tree.  Its filename was
     mm-introduce-a-new-page-type-for-page-pool-in-page-type.patch

This patch was dropped because it had testing failures

------------------------------------------------------
From: Byungchul Park <byungchul@sk.com>
Subject: mm: introduce a new page type for page pool in page type
Date: Tue, 16 Dec 2025 12:03:14 +0900

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

Link: https://lkml.kernel.org/r/20251216030314.29728-2-byungchul@sk.com
Co-developed-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Byungchul Park <byungchul@sk.com>
Suggested-by: David Hildenbrand <david@redhat.com>
Acked-by: David Hildenbrand <david@redhat.com>
Acked-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Toke Høiland-Jørgensen <toke@redhat.com>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Brendan Jackman <jackmanb@google.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Daniel Borkman <daniel@iogearbox.net>
Cc: David S. Miller <davem@davemloft.net>
Cc: David Wei <dw@davidwei.uk>
Cc: Dragos Tatulea <dtatulea@nvidia.com>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Ilias Apalodimas <ilias.apalodimas@linaro.org>
Cc: Jakub Kacinski <kuba@kernel.org>
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
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Yu Zhao <yuzhao@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c |    2 
 include/linux/mm.h                               |   27 +------------
 include/linux/page-flags.h                       |    6 ++
 include/net/netmem.h                             |   15 ++++++-
 mm/page_alloc.c                                  |   11 +++--
 net/core/netmem_priv.h                           |   20 +++------
 net/core/page_pool.c                             |   18 +++++++-
 7 files changed, 53 insertions(+), 46 deletions(-)

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
@@ -4624,10 +4624,9 @@ int arch_lock_shadow_stack_status(struct
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
@@ -4662,26 +4661,6 @@ int arch_lock_shadow_stack_status(struct
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
@@ -934,6 +934,7 @@ enum pagetype {
 	PGTY_zsmalloc		= 0xf6,
 	PGTY_unaccepted		= 0xf7,
 	PGTY_large_kmalloc	= 0xf8,
+	PGTY_netpp		= 0xf9,
 
 	PGTY_mapcount_underflow = 0xff
 };
@@ -1066,6 +1067,11 @@ PAGE_TYPE_OPS(Zsmalloc, zsmalloc, zsmall
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
@@ -1080,7 +1080,6 @@ static inline bool page_expected_state(s
 #ifdef CONFIG_MEMCG
 			page->memcg_data |
 #endif
-			page_pool_page_is_pp(page) |
 			(page->flags.f & check_flags)))
 		return false;
 
@@ -1107,8 +1106,6 @@ static const char *page_bad_reason(struc
 	if (unlikely(page->memcg_data))
 		bad_reason = "page still charged to cgroup";
 #endif
-	if (unlikely(page_pool_page_is_pp(page)))
-		bad_reason = "page_pool leak";
 	return bad_reason;
 }
 
@@ -1417,9 +1414,15 @@ __always_inline bool free_pages_prepare(
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
@@ -8,21 +8,15 @@ static inline unsigned long netmem_get_p
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
+	/* XXX: Now that the offset of page_type is shared between
+	 * struct page and net_iov, just cast the netmem to struct page
+	 * unconditionally by clearing NET_IOV if any, no matter whether
+	 * it comes from struct net_iov or struct page.  This should be
+	 * adjusted once the offset is no longer shared.
+	 */
+	return PageNetpp(__netmem_to_page((__force unsigned long)netmem & ~NET_IOV));
 }
 
 static inline void netmem_set_pp(netmem_ref netmem, struct page_pool *pool)
--- a/net/core/page_pool.c~mm-introduce-a-new-page-type-for-page-pool-in-page-type
+++ a/net/core/page_pool.c
@@ -703,7 +703,14 @@ s32 page_pool_inflight(const struct page
 void page_pool_set_pp_info(struct page_pool *pool, netmem_ref netmem)
 {
 	netmem_set_pp(netmem, pool);
-	netmem_or_pp_magic(netmem, PP_SIGNATURE);
+
+	/* XXX: Now that the offset of page_type is shared between
+	 * struct page and net_iov, just cast the netmem to struct page
+	 * unconditionally by clearing NET_IOV if any, no matter whether
+	 * it comes from struct net_iov or struct page.  This should be
+	 * adjusted once the offset is no longer shared.
+	 */
+	__SetPageNetpp(__netmem_to_page((__force unsigned long)netmem & ~NET_IOV));
 
 	/* Ensuring all pages have been split into one fragment initially:
 	 * page_pool_set_pp_info() is only called once for every page when it
@@ -718,7 +725,14 @@ void page_pool_set_pp_info(struct page_p
 
 void page_pool_clear_pp_info(netmem_ref netmem)
 {
-	netmem_clear_pp_magic(netmem);
+	/* XXX: Now that the offset of page_type is shared between
+	 * struct page and net_iov, just cast the netmem to struct page
+	 * unconditionally by clearing NET_IOV if any, no matter whether
+	 * it comes from struct net_iov or struct page.  This should be
+	 * adjusted once the offset is no longer shared.
+	 */
+	__ClearPageNetpp(__netmem_to_page((__force unsigned long)netmem & ~NET_IOV));
+
 	netmem_set_pp(netmem, NULL);
 }
 
_

Patches currently in -mm which might be from byungchul@sk.com are


