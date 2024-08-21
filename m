Received: from out-178.mta0.migadu.com (out-178.mta0.migadu.com [91.218.175.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6E191B2EC7
	for <mm-commits@vger.kernel.org>; Wed, 21 Aug 2024 17:09:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724260197; cv=none; b=MwHUErEvru2llyxBrLdIfMvUgsbapiAItLoEdfD/aP6liVvuvHrFjd259EJDQctstXr+NCAN8kAaA8hfsCdirHaTcUjx1RPHIn6MIgXvrmAxCsXhwCV4pf0CXCXsoqpKLEsACXwCzV1JKYIBXfGXikKwGn3Su8s/17QOZx1CPK4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724260197; c=relaxed/simple;
	bh=8BctZKKU9VY9+VL81OQQ/Q3uMP71A2ZaIoqntViiZ2w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qtGVsLf4imCAz7I2AECuFLWaJpAT8PvOSlCgj1Ha+s8oqLubz9yuUIZRR86kN/khvTDKjqiyjFi6DtOPJki/5cq3aYa+pHiPAX6E6GwXPgFsqYnUG1C/E3Zx6SYPAiC6IDMOJICEsTJ4YqiGJmXpzxC3OW6AQsJClUJEk0in950=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Px19iIR8; arc=none smtp.client-ip=91.218.175.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Px19iIR8"
Date: Wed, 21 Aug 2024 10:09:45 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1724260192;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=RD+7X9DsFt9EJpWPeAxNhAONRA71+Xwa+bDnMps6miA=;
	b=Px19iIR8IlR7yXkX1EpaC4MNpp7fsrQsoPdb6lcueewhvV/SQrRksn1X62AYOJq4p4imFM
	IBP+W9r756NwI2LixTaJJo52N0KnF+nW7CWgS6drt98BXdn+wi1R9IU6Io4TU1ptM1nWF1
	coOKpkohAG6oyEryceLkQHE2ZylZnCo=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: mm-commits@vger.kernel.org, zhouchengming@bytedance.com, 
	yosryahmed@google.com, ying.huang@intel.com, willy@infradead.org, 
	roman.gushchin@linux.dev, nphamcs@gmail.com, muchun.song@linux.dev, mhocko@suse.com, 
	hannes@cmpxchg.org, chrisl@kernel.org, kasong@tencent.com
Subject: Re: + mm-swap-workingset-make-anon-shadow-nodes-memcg-aware.patch
 added to mm-unstable branch
Message-ID: <f6j7xr6lb3udzdofd3myqkbiivgil57ud6v27h3b2ujs5mczuj@b5vdhtmqcxne>
References: <20240821004816.5BBB3C4AF09@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240821004816.5BBB3C4AF09@smtp.kernel.org>
X-Migadu-Flow: FLOW_OUT

Hi Andrew,

I want to request to drop this patch from the mm-tree. At the moment we
have no evidence that it is solving a real problem but we know that it
will cause unexpected charging of the xarray nodes.

thanks,
Shakeel

On Tue, Aug 20, 2024 at 05:48:15PM GMT, Andrew Morton wrote:
> 
> The patch titled
>      Subject: mm/swap, workingset: make anon shadow nodes memcg aware
> has been added to the -mm mm-unstable branch.  Its filename is
>      mm-swap-workingset-make-anon-shadow-nodes-memcg-aware.patch
> 
> This patch will shortly appear at
>      https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-swap-workingset-make-anon-shadow-nodes-memcg-aware.patch
> 
> This patch will later appear in the mm-unstable branch at
>     git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
> 
> Before you just go and hit "reply", please:
>    a) Consider who else should be cc'ed
>    b) Prefer to cc a suitable mailing list as well
>    c) Ideally: find the original patch on the mailing list and do a
>       reply-to-all to that, adding suitable additional cc's
> 
> *** Remember to use Documentation/process/submit-checklist.rst when testing your code ***
> 
> The -mm tree is included into linux-next via the mm-everything
> branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
> and is updated there every 2-3 working days
> 
> ------------------------------------------------------
> From: Kairui Song <kasong@tencent.com>
> Subject: mm/swap, workingset: make anon shadow nodes memcg aware
> Date: Tue, 20 Aug 2024 17:23:59 +0800
> 
> Currently, the workingset (shadow) nodes of the swap cache are not
> accounted to their corresponding memory cgroup, instead, they are all
> accounted to the root cgroup.  This leads to inaccurate accounting and
> ineffective reclaiming.  One cgroup could swap out a large amount of
> memory, take up a large amount of memory with shadow nodes without being
> accounted.
> 
> This issue is similar to commit 7b785645e8f1 ("mm: fix page cache
> convergence regression"), where page cache shadow nodes were incorrectly
> accounted.  That was due to the accidental dropping of the accounting flag
> during the XArray conversion in commit a28334862993 ("page cache: Finish
> XArray conversion").
> 
> However, this fix has a different cause.  Swap cache shadow nodes were
> never accounted even before the XArray conversion, since they did not
> exist until commit 3852f6768ede ("mm/swapcache: support to handle the
> shadow entries"), which was years after the XArray conversion.
> 
> It's worth noting that one anon shadow Xarray node may contain different
> entries from different cgroup, and it gets accounted at reclaim time, so
> it's arguable which cgroup it should be accounted to (as Shakeal Butt
> pointed out [1]).  File pages may suffer similar issue but less common. 
> Things like proactive memory reclaim could make thing more complex.
> 
> So this commit still can't provide a 100% accurate accounting of anon
> shadows, but it covers the cases when one memory cgroup uses significant
> amount of swap, and in most cases memory pressure in one cgroup only
> suppose to reclaim this cgroup and children.  Besides, this fix is clean
> and easy enough.
> 
> Link: https://lore.kernel.org/all/7gzevefivueqtebzvikzbucnrnpurmh3scmfuiuo2tnrs37xso@haj7gzepjur2/ [1]
> Link: https://lkml.kernel.org/r/20240820092359.97782-1-ryncsn@gmail.com
> Signed-off-by: Kairui Song <kasong@tencent.com>
> Cc: Chengming Zhou <zhouchengming@bytedance.com>
> Cc: Chris Li <chrisl@kernel.org>
> Cc: "Huang, Ying" <ying.huang@intel.com>
> Cc: Johannes Weiner <hannes@cmpxchg.org>
> Cc: Matthew Wilcox <willy@infradead.org>
> Cc: Michal Hocko <mhocko@suse.com>
> Cc: Muchun Song <muchun.song@linux.dev>
> Cc: Nhat Pham <nphamcs@gmail.com>
> Cc: Roman Gushchin <roman.gushchin@linux.dev>
> Cc: Shakeel Butt <shakeel.butt@linux.dev>
> Cc: Yosry Ahmed <yosryahmed@google.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>  mm/swap_state.c |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> --- a/mm/swap_state.c~mm-swap-workingset-make-anon-shadow-nodes-memcg-aware
> +++ a/mm/swap_state.c
> @@ -97,6 +97,7 @@ int add_to_swap_cache(struct folio *foli
>  	void *old;
>  
>  	xas_set_update(&xas, workingset_update_node);
> +	xas_set_lru(&xas, &shadow_nodes);
>  
>  	VM_BUG_ON_FOLIO(!folio_test_locked(folio), folio);
>  	VM_BUG_ON_FOLIO(folio_test_swapcache(folio), folio);
> @@ -718,7 +719,7 @@ int init_swap_address_space(unsigned int
>  		return -ENOMEM;
>  	for (i = 0; i < nr; i++) {
>  		space = spaces + i;
> -		xa_init_flags(&space->i_pages, XA_FLAGS_LOCK_IRQ);
> +		xa_init_flags(&space->i_pages, XA_FLAGS_LOCK_IRQ | XA_FLAGS_ACCOUNT);
>  		atomic_set(&space->i_mmap_writable, 0);
>  		space->a_ops = &swap_aops;
>  		/* swap cache doesn't use writeback related tags */
> _
> 
> Patches currently in -mm which might be from kasong@tencent.com are
> 
> mm-swap-clean-up-initialization-helper.patch
> mm-swap-skip-slot-cache-on-freeing-for-mthp.patch
> mm-swap-allow-cache-reclaim-to-skip-slot-cache.patch
> mm-swap-add-a-fragment-cluster-list.patch
> mm-swap-relaim-the-cached-parts-that-got-scanned.patch
> mm-swap-add-a-adaptive-full-cluster-cache-reclaim.patch
> mm-swap-workingset-make-anon-shadow-nodes-memcg-aware.patch
> 
