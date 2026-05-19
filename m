Received: from invmail4.hynix.com (exvmail4.skhynix.com [166.125.252.92])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EE6CD399363
	for <mm-commits@vger.kernel.org>; Tue, 19 May 2026 06:43:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=166.125.252.92
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779172993; cv=none; b=pgNe/pUUcA+nwAvYhyLShTGTHp2cnXKLjII1KlW8LS+9a42ia9wFvIQ6dF3x+utc9k8dOUKlugYueQMmYFXyHPKAOJgyIId8Pev2a/hemR63Qdyg3aNrwwuq8zT1rcgN2hMbd4Hi0zpXzmkRov/BfdD1aYekNL+3UXBqKB+5JLg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779172993; c=relaxed/simple;
	bh=luV0/9osoMhhlUhEW2/1jVEgPwW3lcobEL37MySQM4g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XIisb4Tg9DTpJDN5C8V9lZq9r12MTEeumPQXi8+JkX5z75A/Jf0YdEFsp9ed+A4qpKYCDsILf+jJ+Che2RAKY4jHLVRo4MAcdeHDNf8hw7fTu3O7pZ5OPe5hhe+ZDhbpKRpWxlXtveUcBL+Bh0zTjeeh6O4Os7M0VoilI8s/koo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=sk.com; spf=pass smtp.mailfrom=sk.com; arc=none smtp.client-ip=166.125.252.92
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=sk.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sk.com
X-AuditID: a67dfc5b-c45ff70000001609-6d-6a0c067895a3
Date: Tue, 19 May 2026 15:42:59 +0900
From: Byungchul Park <byungchul@sk.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: mm-commits@vger.kernel.org, ziy@nvidia.com, willy@infradead.org,
	vbabka@kernel.org, toke@redhat.com, tariqt@nvidia.com,
	surenb@google.com, sdf@fomichev.me, saeedm@nvidia.com,
	rppt@kernel.org, pabeni@redhat.com, mhocko@suse.com,
	mbloch@nvidia.com, ljs@kernel.org, liam@infradead.org,
	leon@kernel.org, kuba@kernel.org, john.fastabend@gmail.com,
	jackmanb@google.com, ilias.apalodimas@linaro.org, horms@kernel.org,
	hawk@kernel.org, harry@kernel.org, hannes@cmpxchg.org,
	edumazet@google.com, dtatulea@nvidia.com, david@kernel.org,
	davem@davemloft.net, baolin.wang@linux.alibaba.com, ast@kernel.org,
	asml.silence@gmail.com, kernel_team@skhynix.com
Subject: Re: +
 revert-mm-introduce-a-new-page-type-for-page-pool-in-page-type.patch added
 to mm-hotfixes-unstable branch
Message-ID: <20260519064259.GA57974@system.software.com>
References: <20260519003125.5006AC2BCB7@smtp.kernel.org>
 <20260519051002.GA16061@system.software.com>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260519051002.GA16061@system.software.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Brightmail-Tracker: H4sIAAAAAAAAA02Se0hTcRTH+d17vbubW9yW0a8HEQsJLO0lcXqvArkUkj0oyiBH3nI2p21l
	rjI0hV5q1pJ0aZhlqZXWfI9mNc2mgZmgLWdJ62GmpVNbqWG5ReR/H77ny/d8DxyGlI5QMxil
	+jCvUStUMlpEib6K8/zjaHHkoobyFZBdcpeG7KIKBEPDdgH8NtcjyH6RTEFX+QiCalMXgo/1
	DgHcMQbDq/ZCBA9PV5LguGClITV5lATz8DcBnKoqIKC5Is0LLo/kk1DcaKGh930Q9GfUkdCZ
	Joeei81e4Hrei6CupJIAV0oODa1ZJgL0Lbk0vE/uRNBS66DgTHcnBaM/s2m4+vStQD6Hq+3t
	I7mywtcEZ6tpJLhqwxsBl2s8wpUW+HHGorM019H2kOasmaMUV/1uOZea9I3m+mpaaa6krJXi
	Bo2zQybtFq0K51XKWF6zcE2YKOKxq5aOMZyM6yg20Qno2p5ziGEwG4gznTvOIaEHnSM/kJsp
	1hdXutopN9PsPGyzDZNu9mH9cVGXaZxFDMlmeeHPxeke0xT2BK5uyPewhAWcUOj0sJQ9gO1t
	n4i/+mTckPXBo5OsH7aNdRPuDiQ7E98eY9yykF2Ou3sueCxT2bn4ccUzwr0LsxkMfnWlBv0t
	Oh0/KbBR6Yg1TIg1TIg1/I/NRWQRkirVsVEKpSowIEKnVsYF7IuOMqLxj7gV/yu0Cg00b7Mg
	lkEysUT+WxQp9VLEanVRFoQZUuYjGSsRRkol4QrdMV4TvVdzRMVrLWgmQ8mmSZa4joaPX6g4
	zB/k+Rhe829KMMIZCWhd3qXv1ndi+UaTebCY9l67cXPOx4wT9pCqpSlNln1DvU6pY5Z4b0qQ
	PWy+N282Ju5aef/8lyRRq3nX6XuhvwTxA003c8gts5ct6Ntf8bZHrzzUv9Ue7KvWb/qiy++/
	4a0vXb/zwYbE7S+v7+DFxw/ef7TU6pNu6HsT5qyxr0407hfLKG2EYrEfqdEq/gAeJrvzDQMA
	AA==
X-Brightmail-Tracker: H4sIAAAAAAAAA02Ra0hTcRjG+Z9zdnY2XJ7M8p9G0boIRlZQ8IpWfikPgeW3qIwaecipm7J5
	x8pU0qKmloGuVVJZbobGNC/DjdCyVCqZWWaZtfKWw0styxmzbRH57cfvfZ4PDy9D+tmoQEau
	TOVVSlmSlBZT4v3h+ZszaZ+ErUWmjaCru0+DztCIwDH3TggL5g4EupcFFIw+dCJoMY0iGO6w
	CaHGGA1vBvQIWgubSLAVP6PhUsE8Cea5SSHkNVcT0H69UwA9jRoBlDmrSKjtaqPB/nkvTF99
	TMKQJhImSnsEMNttR/C4romA2YvXaeirMBFwxVpJw+eCIQTWdhsFReNDFMz/0tFw7ckHYeRa
	rt0+RXIN+rcE12/pIrgW7aCQqzSmcfXVIZzRcJ7m3r9upbln5fMU1/IpjLuUP0lzU5Y+mrs9
	Nk1wdQ19FPfduDrG97A4Io5Pkqfzqi27jovjH8220yna05nva010LroRewGJGMxuxzPOn8jD
	FLsBN80OUB6m2WDc3z9Hetif3YwNoyY3ixmSrRDgsdoSb2gZm4NbOqu8LGEB5+pnvOzHnsTv
	Xo8Qf/1S3FnxxetJNgT3u8bdnnFzEL7nYjxaxIbh8Ylib2Q5uw4/anxKlCCJdlFbu6it/d+u
	RKQB+cuV6QqZPGlHqDoxPkspzww9kawwIvfn7576XdqMHL1RbYhlkNRHErkgTvATyNLVWYo2
	hBlS6i9x1YkS/CRxsqxsXpV8TJWWxKvbUBBDSQMk+w7yx91TZKl8Is+n8Kp/V4IRBeainCjd
	CvHO+aiYFysL8x6czHaVKu6YtUetmm32OOycOvA1dc/YqcE3ZzQjIxllS2zHDgXzXeruBL2v
	pXz9YMQROZhjLEEa5eUi3e67jqlbGSscaWdrwnujf6za9Oo5fBP4HM4ujcc3hq0fz6WYc1w+
	UTFsT6wlK3bNpnpZwM3hBimljpdtCyFVatkfdU6syPUCAAA=
X-CFilter-Loop: Reflected

On Tue, May 19, 2026 at 02:10:02PM +0900, Byungchul Park wrote:
> On Mon, May 18, 2026 at 05:31:24PM -0700, Andrew Morton wrote:
> > The patch titled
> >      Subject: Revert "mm: introduce a new page type for page pool in page type"
> > has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
> >      revert-mm-introduce-a-new-page-type-for-page-pool-in-page-type.patch
> > 
> > This patch will shortly appear at
> >      https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/revert-mm-introduce-a-new-page-type-for-page-pool-in-page-type.patch
> > 
> > This patch will later appear in the mm-hotfixes-unstable branch at
> >     git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
> > 
> > Before you just go and hit "reply", please:
> >    a) Consider who else should be cc'ed
> >    b) Prefer to cc a suitable mailing list as well
> >    c) Ideally: find the original patch on the mailing list and do a
> >       reply-to-all to that, adding suitable additional cc's
> > 
> > *** Remember to use Documentation/process/submit-checklist.rst when testing your code ***
> > 
> > The -mm tree is included into linux-next via various
> > branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
> > and is updated there most days
> > 
> > ------------------------------------------------------
> > From: Byungchul Park <byungchul@sk.com>
> > Subject: Revert "mm: introduce a new page type for page pool in page type"
> > Date: Fri, 15 May 2026 12:47:01 +0900
> > 
> > This reverts commit db359fccf212 ("mm: introduce a new page type for page
> > pool in page type") and a part of 735a309b4bfb9e ("net: add net_iov_init()
> > and use it > to initialize ->page_type").
>              ^
> 	     Check this out, Andrew.

Hm.. I might have expressed that incorrectly in English. I just wanted
you to check the '>' wrongly added :)

	Byungchul
> 
> 	Byungchul
> 
> > Netpp page_type'ed pages might be used in mapping so as to use @_mapcount.
> > However, since @page_type and @_mapcount are union'ed in struct page,
> > these two can't be used at the same time.  Revert the commit introducing
> > page_type for Netpp for now.
> > 
> > The patch will be retried once @page_type and @_mapcount get allowed to be
> > used at the same time.
> > 
> > The revert also includes removal of @page_type initialization part
> > introduced by commit 735a309b4bfb9e ("net: add net_iov_init() and use it
> > to initialize ->page_type"), which will be restored on the retry.
> > 
> > Link: https://lore.kernel.org/20260515034701.17027-1-byungchul@sk.com
> > Fixes: db359fccf212 ("mm: introduce a new page type for page pool in page type")
> > Signed-off-by: Byungchul Park <byungchul@sk.com>
> > Reported-by: Dragos Tatulea <dtatulea@nvidia.com>
> > Closes: https://lore.kernel.org/all/982b9bc1-0a0a-4fc5-8e3a-3672db2b29a1@nvidia.com
> > Acked-by: Jakub Kicinski <kuba@kernel.org>
> > Acked-by: David Hildenbrand (Arm) <david@kernel.org>
> > Acked-by: Harry Yoo (Oracle) <harry@kernel.org>
> > Reviewed-by: Lorenzo Stoakes <ljs@kernel.org>
> > Cc: Alexei Starovoitov <ast@kernel.org>
> > Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
> > Cc: Brendan Jackman <jackmanb@google.com>
> > Cc: David S. Miller <davem@davemloft.net>
> > Cc: Eric Dumazet <edumazet@google.com>
> > Cc: Ilias Apalodimas <ilias.apalodimas@linaro.org>
> > Cc: Jesper Dangaard Brouer <hawk@kernel.org>
> > Cc: Johannes Weiner <hannes@cmpxchg.org>
> > Cc: John Fastabend <john.fastabend@gmail.com>
> > Cc: Leon Romanovsky <leon@kernel.org>
> > Cc: Liam R. Howlett <liam@infradead.org>
> > Cc: Mark Bloch <mbloch@nvidia.com>
> > Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
> > Cc: Michal Hocko <mhocko@suse.com>
> > Cc: Mike Rapoport <rppt@kernel.org>
> > Cc: Paolo Abeni <pabeni@redhat.com>
> > Cc: Pavel Begunkov <asml.silence@gmail.com>
> > Cc: Saeed Mahameed <saeedm@nvidia.com>
> > Cc: Simon Horman <horms@kernel.org>
> > Cc: Stanislav Fomichev <sdf@fomichev.me>
> > Cc: Suren Baghdasaryan <surenb@google.com>
> > Cc: Tariq Toukan <tariqt@nvidia.com>
> > Cc: Toke Hoiland-Jorgensen <toke@redhat.com>
> > Cc: Vlastimil Babka <vbabka@kernel.org>
> > Cc: Zi Yan <ziy@nvidia.com>
> > Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> > ---
> > 
> >  drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c |    2
> >  include/linux/mm.h                               |   27 +++++++++++--
> >  include/linux/page-flags.h                       |    6 --
> >  include/net/netmem.h                             |   19 ---------
> >  mm/page_alloc.c                                  |   13 +-----
> >  net/core/netmem_priv.h                           |   23 ++++++-----
> >  net/core/page_pool.c                             |   24 -----------
> >  7 files changed, 46 insertions(+), 68 deletions(-)
> > 
> > --- a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c~revert-mm-introduce-a-new-page-type-for-page-pool-in-page-type
> > +++ a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
> > @@ -708,7 +708,7 @@ static void mlx5e_free_xdpsq_desc(struct
> >                                 xdpi = mlx5e_xdpi_fifo_pop(xdpi_fifo);
> >                                 page = xdpi.page.page;
> > 
> > -                               /* No need to check PageNetpp() as we
> > +                               /* No need to check page_pool_page_is_pp() as we
> >                                  * know this is a page_pool page.
> >                                  */
> >                                 page_pool_recycle_direct(pp_page_to_nmdesc(page)->pp,
> > --- a/include/linux/mm.h~revert-mm-introduce-a-new-page-type-for-page-pool-in-page-type
> > +++ a/include/linux/mm.h
> > @@ -5174,9 +5174,10 @@ int arch_lock_shadow_stack_status(struct
> >   * DMA mapping IDs for page_pool
> >   *
> >   * When DMA-mapping a page, page_pool allocates an ID (from an xarray) and
> > - * stashes it in the upper bits of page->pp_magic. Non-PP pages can have
> > - * arbitrary kernel pointers stored in the same field as pp_magic (since
> > - * it overlaps with page->lru.next), so we must ensure that we cannot
> > + * stashes it in the upper bits of page->pp_magic. We always want to be able to
> > + * unambiguously identify page pool pages (using page_pool_page_is_pp()). Non-PP
> > + * pages can have arbitrary kernel pointers stored in the same field as pp_magic
> > + * (since it overlaps with page->lru.next), so we must ensure that we cannot
> >   * mistake a valid kernel pointer with any of the values we write into this
> >   * field.
> >   *
> > @@ -5211,6 +5212,26 @@ int arch_lock_shadow_stack_status(struct
> >  #define PP_DMA_INDEX_MASK GENMASK(PP_DMA_INDEX_BITS + PP_DMA_INDEX_SHIFT - 1, \
> >                                   PP_DMA_INDEX_SHIFT)
> > 
> > +/* Mask used for checking in page_pool_page_is_pp() below. page->pp_magic is
> > + * OR'ed with PP_SIGNATURE after the allocation in order to preserve bit 0 for
> > + * the head page of compound page and bit 1 for pfmemalloc page, as well as the
> > + * bits used for the DMA index. page_is_pfmemalloc() is checked in
> > + * __page_pool_put_page() to avoid recycling the pfmemalloc page.
> > + */
> > +#define PP_MAGIC_MASK ~(PP_DMA_INDEX_MASK | 0x3UL)
> > +
> > +#ifdef CONFIG_PAGE_POOL
> > +static inline bool page_pool_page_is_pp(const struct page *page)
> > +{
> > +       return (page->pp_magic & PP_MAGIC_MASK) == PP_SIGNATURE;
> > +}
> > +#else
> > +static inline bool page_pool_page_is_pp(const struct page *page)
> > +{
> > +       return false;
> > +}
> > +#endif
> > +
> >  #define PAGE_SNAPSHOT_FAITHFUL (1 << 0)
> >  #define PAGE_SNAPSHOT_PG_BUDDY (1 << 1)
> >  #define PAGE_SNAPSHOT_PG_IDLE  (1 << 2)
> > --- a/include/linux/page-flags.h~revert-mm-introduce-a-new-page-type-for-page-pool-in-page-type
> > +++ a/include/linux/page-flags.h
> > @@ -923,7 +923,6 @@ enum pagetype {
> >         PGTY_zsmalloc           = 0xf6,
> >         PGTY_unaccepted         = 0xf7,
> >         PGTY_large_kmalloc      = 0xf8,
> > -       PGTY_netpp              = 0xf9,
> > 
> >         PGTY_mapcount_underflow = 0xff
> >  };
> > @@ -1056,11 +1055,6 @@ PAGE_TYPE_OPS(Zsmalloc, zsmalloc, zsmall
> >  PAGE_TYPE_OPS(Unaccepted, unaccepted, unaccepted)
> >  PAGE_TYPE_OPS(LargeKmalloc, large_kmalloc, large_kmalloc)
> > 
> > -/*
> > - * Marks page_pool allocated pages.
> > - */
> > -PAGE_TYPE_OPS(Netpp, netpp, netpp)
> > -
> >  /**
> >   * PageHuge - Determine if the page belongs to hugetlbfs
> >   * @page: The page to test.
> > --- a/include/net/netmem.h~revert-mm-introduce-a-new-page-type-for-page-pool-in-page-type
> > +++ a/include/net/netmem.h
> > @@ -94,20 +94,10 @@ enum net_iov_type {
> >   */
> >  struct net_iov {
> >         struct netmem_desc desc;
> > -       unsigned int page_type;
> >         enum net_iov_type type;
> >         struct net_iov_area *owner;
> >  };
> > 
> > -/* Make sure 'the offset of page_type in struct page == the offset of
> > - * type in struct net_iov'.
> > - */
> > -#define NET_IOV_ASSERT_OFFSET(pg, iov)                 \
> > -       static_assert(offsetof(struct page, pg) ==      \
> > -                     offsetof(struct net_iov, iov))
> > -NET_IOV_ASSERT_OFFSET(page_type, page_type);
> > -#undef NET_IOV_ASSERT_OFFSET
> > -
> >  struct net_iov_area {
> >         /* Array of net_iovs for this area. */
> >         struct net_iov *niovs;
> > @@ -127,11 +117,7 @@ static inline unsigned int net_iov_idx(c
> >         return niov - net_iov_owner(niov)->niovs;
> >  }
> > 
> > -/* Initialize a niov: stamp the owning area, the memory provider type,
> > - * and the page_type "no type" sentinel expected by the page-type API
> > - * (see PAGE_TYPE_OPS in <linux/page-flags.h>) so that
> > - * page_pool_set_pp_info() can later call __SetPageNetpp() on a niov
> > - * cast to struct page.
> > +/* Initialize a niov: stamp the owning area, the memory provider type.
> >   */
> >  static inline void net_iov_init(struct net_iov *niov,
> >                                 struct net_iov_area *owner,
> > @@ -139,7 +125,6 @@ static inline void net_iov_init(struct n
> >  {
> >         niov->owner = owner;
> >         niov->type = type;
> > -       niov->page_type = UINT_MAX;
> >  }
> > 
> >  /* netmem */
> > @@ -245,7 +230,7 @@ static inline unsigned long netmem_pfn_t
> >   */
> >  #define pp_page_to_nmdesc(p)                                           \
> >  ({                                                                     \
> > -       DEBUG_NET_WARN_ON_ONCE(!PageNetpp(p));                          \
> > +       DEBUG_NET_WARN_ON_ONCE(!page_pool_page_is_pp(p));               \
> >         __pp_page_to_nmdesc(p);                                         \
> >  })
> > 
> > --- a/mm/page_alloc.c~revert-mm-introduce-a-new-page-type-for-page-pool-in-page-type
> > +++ a/mm/page_alloc.c
> > @@ -1035,6 +1035,7 @@ static inline bool page_expected_state(s
> >  #ifdef CONFIG_MEMCG
> >                         page->memcg_data |
> >  #endif
> > +                       page_pool_page_is_pp(page) |
> >                         (page->flags.f & check_flags)))
> >                 return false;
> > 
> > @@ -1061,6 +1062,8 @@ static const char *page_bad_reason(struc
> >         if (unlikely(page->memcg_data))
> >                 bad_reason = "page still charged to cgroup";
> >  #endif
> > +       if (unlikely(page_pool_page_is_pp(page)))
> > +               bad_reason = "page_pool leak";
> >         return bad_reason;
> >  }
> > 
> > @@ -1377,17 +1380,9 @@ __always_inline bool __free_pages_prepar
> >                 mod_mthp_stat(order, MTHP_STAT_NR_ANON, -1);
> >                 folio->mapping = NULL;
> >         }
> > -       if (unlikely(page_has_type(page))) {
> > -               /* networking expects to clear its page type before releasing */
> > -               if (is_check_pages_enabled()) {
> > -                       if (unlikely(PageNetpp(page))) {
> > -                               bad_page(page, "page_pool leak");
> > -                               return false;
> > -                       }
> > -               }
> > +       if (unlikely(page_has_type(page)))
> >                 /* Reset the page_type (which overlays _mapcount) */
> >                 page->page_type = UINT_MAX;
> > -       }
> > 
> >         if (is_check_pages_enabled()) {
> >                 if (free_page_is_bad(page))
> > --- a/net/core/netmem_priv.h~revert-mm-introduce-a-new-page-type-for-page-pool-in-page-type
> > +++ a/net/core/netmem_priv.h
> > @@ -8,18 +8,21 @@ static inline unsigned long netmem_get_p
> >         return netmem_to_nmdesc(netmem)->pp_magic & ~PP_DMA_INDEX_MASK;
> >  }
> > 
> > -static inline bool netmem_is_pp(netmem_ref netmem)
> > +static inline void netmem_or_pp_magic(netmem_ref netmem, unsigned long pp_magic)
> > +{
> > +       netmem_to_nmdesc(netmem)->pp_magic |= pp_magic;
> > +}
> > +
> > +static inline void netmem_clear_pp_magic(netmem_ref netmem)
> >  {
> > -       struct page *page;
> > +       WARN_ON_ONCE(netmem_to_nmdesc(netmem)->pp_magic & PP_DMA_INDEX_MASK);
> > 
> > -       /* XXX: Now that the offset of page_type is shared between
> > -        * struct page and net_iov, just cast the netmem to struct page
> > -        * unconditionally by clearing NET_IOV if any, no matter whether
> > -        * it comes from struct net_iov or struct page.  This should be
> > -        * adjusted once the offset is no longer shared.
> > -        */
> > -       page = (struct page *)((__force unsigned long)netmem & ~NET_IOV);
> > -       return PageNetpp(page);
> > +       netmem_to_nmdesc(netmem)->pp_magic = 0;
> > +}
> > +
> > +static inline bool netmem_is_pp(netmem_ref netmem)
> > +{
> > +       return (netmem_get_pp_magic(netmem) & PP_MAGIC_MASK) == PP_SIGNATURE;
> >  }
> > 
> >  static inline void netmem_set_pp(netmem_ref netmem, struct page_pool *pool)
> > --- a/net/core/page_pool.c~revert-mm-introduce-a-new-page-type-for-page-pool-in-page-type
> > +++ a/net/core/page_pool.c
> > @@ -707,18 +707,8 @@ s32 page_pool_inflight(const struct page
> > 
> >  void page_pool_set_pp_info(struct page_pool *pool, netmem_ref netmem)
> >  {
> > -       struct page *page;
> > -
> >         netmem_set_pp(netmem, pool);
> > -
> > -       /* XXX: Now that the offset of page_type is shared between
> > -        * struct page and net_iov, just cast the netmem to struct page
> > -        * unconditionally by clearing NET_IOV if any, no matter whether
> > -        * it comes from struct net_iov or struct page.  This should be
> > -        * adjusted once the offset is no longer shared.
> > -        */
> > -       page = (struct page *)((__force unsigned long)netmem & ~NET_IOV);
> > -       __SetPageNetpp(page);
> > +       netmem_or_pp_magic(netmem, PP_SIGNATURE);
> > 
> >         /* Ensuring all pages have been split into one fragment initially:
> >          * page_pool_set_pp_info() is only called once for every page when it
> > @@ -733,17 +723,7 @@ void page_pool_set_pp_info(struct page_p
> > 
> >  void page_pool_clear_pp_info(netmem_ref netmem)
> >  {
> > -       struct page *page;
> > -
> > -       /* XXX: Now that the offset of page_type is shared between
> > -        * struct page and net_iov, just cast the netmem to struct page
> > -        * unconditionally by clearing NET_IOV if any, no matter whether
> > -        * it comes from struct net_iov or struct page.  This should be
> > -        * adjusted once the offset is no longer shared.
> > -        */
> > -       page = (struct page *)((__force unsigned long)netmem & ~NET_IOV);
> > -       __ClearPageNetpp(page);
> > -
> > +       netmem_clear_pp_magic(netmem);
> >         netmem_set_pp(netmem, NULL);
> >  }
> > 
> > _
> > 
> > Patches currently in -mm which might be from byungchul@sk.com are
> > 
> > revert-mm-introduce-a-new-page-type-for-page-pool-in-page-type.patch
