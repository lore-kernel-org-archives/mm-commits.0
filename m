Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF13A3624AE;
	Sun, 13 Sep 2026 02:30:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789266624; cv=none; b=CHrOGTYjAI4yQi886RJiKIFXpNSBr/thApBbJTackNPp4ln3quAejtKmW01YcySHoCNbYgwbF56rWCCgWmaHrk8xViVFYEUqZu75WelODs27/RWH89HvDMPYGnOVzegMXWTX2lLucIr08nd2rSdvnI23m44HsFyVCpc1loYhEG8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789266624; c=relaxed/simple;
	bh=ffrHo7KBlcbUcbaxpYn2M3wwjPBUNVivSsESVeyPPQo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LvmBpbk5obp9f9y9LKsLuR+Y5EqqHU+Krse3knL164tqKm4ZSTuC16sFdBqk864EO005iUw8m5vVs275+9Qt5ZVewhC2+jqMXhYoXOS6xompxGb+whVOrvA03a57N9ZM/Y9NixAlW326UKbLuvJEVL847w2M9QbfThCiTakjNAY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=pass smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=L5C+khZ0; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="L5C+khZ0"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=9dTBsiwJfktNL2QsBuec8A3PSDJVNgal1A3WSKl12Yo=; b=L5C+khZ08uNISAzw9Q0NecT8GL
	wHfFOe16HB2b54Dta8Jp06P46HzMyjLNZRbAk3auDIaSA2WSGPHR/8lWh+9UkC0VI8nh5JEiokNFh
	ZL+NPkf34hL09xtWoyLQyBAxrcKLD+W38ag25levzioLEVrteT0VW9bab26nVeCU8dZg2sd2y6DW+
	mYiSiEgrFVQmQaljYqi4WRRbj1egnnbBIycHJI+pkxQhUbztV/3HlEP4AFgMCo157HSPklEVPYLZd
	QiYbJVY8Mvvh+pyCsUJogtKV8UtDBU1CU/rbqTC0rzk4gd/zj+2FJBflQgrUFAjE7DKD6P02WVziK
	E7rr3PkA==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x5Zyr-00000003Fml-1gT2;
	Sun, 13 Sep 2026 02:30:09 +0000
Date: Sun, 13 Sep 2026 03:30:09 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: mm-commits@vger.kernel.org, ziy@nvidia.com, vbabka@suse.cz,
	stable@vger.kernel.org, ritesh.list@gmail.com, mhocko@suse.com,
	hch@lst.de, hannes@cmpxchg.org, dgc@kernel.org, david@redhat.com,
	dipiets@amazon.it
Subject: Re: +
 mm-page_alloc-avoid-direct-compaction-for-costly-__gfp_noretry-allocations.patch
 added to mm-hotfixes-unstable branch
Message-ID: <aqYKsTHkyJXCyh_-@casper.infradead.org>
References: <20260911163243.808DF1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260911163243.808DF1F000FF@smtp.kernel.org>

On Fri, Sep 11, 2026 at 09:32:43AM -0700, Andrew Morton wrote:
> From: Salvatore Dipietro <dipiets@amazon.it>
> Subject: mm/page_alloc: avoid direct compaction for costly __GFP_NORETRY allocations
> Date: Fri, 11 Sep 2026 14:21:02 +0000
> 
> Commit 5d8edfb900d5 ("iomap: Copy larger chunks from userspace")
> introduced high-order folio allocations in the iomap buffered write path. 
> When memory is fragmented, each failed costly-order allocation enters
> __alloc_pages_slowpath() which runs direct compaction and
> drain_all_pages(), causing a 0.38x throughput drop on PostgreSQL pgbench
> (simple-update) with 1024 clients on a 96-vCPU arm64 system.
> 
> The root issue is that direct compaction is too expensive for hot
> allocation paths that have fallbacks to smaller allocations. 
> __filemap_get_folio_mpol() already marks higher-order allocations with
> __GFP_NORETRY | __GFP_NOWARN, signalling that the caller can handle
> failure.  However, the page allocator still attempts full direct
> compaction for costly orders with __GFP_NORETRY, which is unnecessarily
> aggressive when the caller will simply retry at a lower order.
> 
> For costly-order allocations with __GFP_NORETRY, suppress direct reclaim
> for the whole slowpath by computing can_direct_reclaim (and hence
> can_compact) as false.  The !can_direct_reclaim check near the top of the
> slowpath then short-circuits to nopage: no direct reclaim, no direct
> compaction and no drain_all_pages() IPI across every CPU.  kswapd (and in
> turn kcompactd) is still woken further down for background
> defragmentation, so compaction keeps working for long-term system health
> while being removed from the latency-critical direct allocation path.
> 
> Allocations that also request __GFP_THISNODE are exempted.  That flag
> pairing identifies the local-node-first THP attempt issued by
> alloc_pages_mpol() (mempolicy.c), which relies on direct compaction to
> form transparent huge pages.  __GFP_NOFAIL is exempted as well, so a
> must-not-fail allocation is never made to fail.
> 
> Test environment:
>   Hardware:  AWS EC2 m8g.24xlarge (96 vCPU, arm64)
>              12x 1TB IO2 32000 IOPS RAID0 XFS
>   OS:        AL2023
>   Kernel:    v7.3-rc1
>   Database:  PostgreSQL 18.4
>   Workload:  pgbench simple-update, 1024 clients, 96 threads, 1200s
> 
> Results (average of 3 runs, TPS):
>   Config                                       Avg TPS   % vs baseline
>   AL2023 stock 6.1 kernel (pre-5d8edfb900d5)   136,942           n/a
>   v7.3-rc1 baseline (no patch)                  59,408             -
>   v7.3-rc1 + this patch                        161,994       +172.7%
> 
> The patch fully recovers the pre-5d8edfb900d5 performance, bringing
> throughput back above the pre-regression level and well clear of the ~59k
> baseline.  The AL2023 6.1 row runs a kernel that predates commit
> 5d8edfb900d5 ("iomap: Copy larger chunks from userspace"), so it is not
> directly comparable, but it shows the pre-regression level and confirms
> that the ~59k baseline is the anomaly and not the norm.
> 
> Link: https://lore.kernel.org/all/20260403193535.9970-1-dipiets@amazon.it/T/#t [v1]
> Link: https://lore.kernel.org/linux-mm/20260420161404.642-1-dipiets@amazon.it/T/#u [v2]
> Link: https://lore.kernel.org/all/20260710143437.12379-1-dipiets@amazon.it/T/#u [v3]
> Link: https://lore.kernel.org/all/20260904115629.3993331-1-dipiets@amazon.it/T/#u [v4]
> Link: https://lore.kernel.org/20260911142102.2294202-1-dipiets@amazon.it
> Fixes: 5d8edfb900d5 ("iomap: Copy larger chunks from userspace")
> Signed-off-by: Salvatore Dipietro <dipiets@amazon.it>
> Acked-by: Zi Yan <ziy@nvidia.com>
> Cc: Vlastimil Babka <vbabka@suse.cz>
> Cc: David Hildenbrand <david@redhat.com>
> Cc: Michal Hocko <mhocko@suse.com>
> Cc: Johannes Weiner <hannes@cmpxchg.org>
> Cc: Matthew Wilcox <willy@infradead.org>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Dave Chinner <dgc@kernel.org>
> Cc: Ritesh Harjani <ritesh.list@gmail.com>
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

i'm just back from vacation, but i think the patch i posted was the
better way to fic this.  at this point i'm confused why this one is
being considered, but i'll review all the email from the last two weeks
and see what's happened to cause this one to be included.
