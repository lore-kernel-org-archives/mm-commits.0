Received: from mail-qv2-f9.google.com (mail-qv2-f9.google.com [74.125.230.137])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D17002E7379
	for <mm-commits@vger.kernel.org>; Sun, 13 Sep 2026 16:51:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.230.137
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789318317; cv=none; b=PfldiPGbuqQjPGxd76qKulal8VuJn5AeMGlXJ6uyi4W36jXefd6Ap0uFSqaGnYGXwXVw5sT+/k5HJrNwnsdw5wmGVsBhUFvoXqZJHNx41hWYaitZ6hWkWqaD+/pwyPIlFe9wPwQHL/usHuZwyt/jBs/lvwEuqNlROofGSzOKexc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789318317; c=relaxed/simple;
	bh=E0AasrEnz6UNpYVgyLH7I4qkPIndff9cZpvpirWnO4E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=A8mNUp/HrW4IVn1CKI5P11I2zYxWTEJLZOVMEb4oJvqDCq/gk7zg6f4iEvu79dY9CP2vBGnXMhLmN9eeLNDsxV3KbrO76LbRQX30v8F3Pts8/IfSKAKjUQIrNeS+m3BJtTxPPl7D8DUQuT0lIwcUdKCmYc+P6PnpOktUdg0Qzc0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cmpxchg.org; spf=pass smtp.mailfrom=cmpxchg.org; dkim=pass (2048-bit key) header.d=cmpxchg.org header.i=@cmpxchg.org header.b=dzSOKvSF; arc=none smtp.client-ip=74.125.230.137
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cmpxchg.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cmpxchg.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cmpxchg.org header.i=@cmpxchg.org header.b="dzSOKvSF"
Received: by mail-qv2-f9.google.com with SMTP id 6a1803df08f44-91033ce28ceso13047056d6.1
        for <mm-commits@vger.kernel.org>; Sun, 13 Sep 2026 09:51:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1789318313; x=1789923113; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=R9M1uj4pUaKwiC9/+FnQyofG3DqOQ9lTmtW19DRrpaY=;
        b=dzSOKvSFn/WN4mcbNnsPS5CTbLrxZSt3IKFi/WYc7Tqbdod2yBSCWwpd+8RctKv8IN
         LJaNm6MDAOlQAw3HwNBP1f6bgm2AlKlaxSr5ZAKd6ZUOBV3SgA3Oj6fYlUDKqRg7AxOa
         8Ccy111QrrsTYGSF5hHQQgxwjpkvLyRBPM59NxwApzP68AHzfAlornPZLGM33Afj3pRE
         ZYNfeeppFFUB7euVVHNMRZ8p9ybdCvwHPmIhdVK65GxX4awkxzFYEe/rOzeSoV8HsMco
         wVfLmZOsIC3WUEvyU0BxM4DQMcCo6C9L6sBU9u0yuW6pCRbCCbM1TWXdBBZ/x5suFdCU
         sVeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789318313; x=1789923113;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=R9M1uj4pUaKwiC9/+FnQyofG3DqOQ9lTmtW19DRrpaY=;
        b=AWLiXxd2N2PI/m3hbMj3jnwoJx+4lLRA/0LwYIKvLzbTn5vpo7ygV/nUccI8Hn0gbK
         C6D4U4flq2B9sZOuxYEgkpfr4/oaBbUBFZilCs8lElKLLasQXH6LC9FUrMAO/tUJQ2ym
         05sa3hqyg4vhf4bhOJn4aCnvwKqCsZgL+KIrAbvpBwPMl+TrdYs5IPsbi9OAWvaLNoRD
         62jH1SLlc8w33eofPeqpQMkU8B8mvYcvAqjmsjgV6Qcn9TUv/Z/n7f7pX7NsTyS0c687
         Jgw19uzCqEG/eS90NHlA2ulc6tfwpyliq6gwF1ILMGnCwDvx/xmpvutKFZNPfe07sVYq
         sgyA==
X-Forwarded-Encrypted: i=1; AKwUvBx61FX4WS3feYfiD0WATmDA9emclN+0fP94wnMt21Lr5gfx7FmS4+82veUXoSpgBJug4nIV1+uRQC34@vger.kernel.org
X-Gm-Message-State: AFuF++na2/0DwF0P9VrWAdfldiQ7HxO94pVUmKWBN3giKq34+iJglTWI
	oM3B1NAGj5jhXCXUg+f96VrgmdmoViscdjQVWTUgA8BEs5egP9DZOwOELvO4DVFNp9I=
X-Gm-Gg: AYBFou0yqCTC0wqG+fgt6K6lIL5/2Ze5ncqYZAbB9lcC9jsS28rk/s3P9dFcrfKtCXA
	lxTkrukqQcItjZ2BFoeWY/CyQv1xmt40wn//F8hAePs3vEFav/WZavKByk1i3WPq6IwMfSS38hM
	xlU1jYBiOfVOSf5edXawB77SMbKwwY7HTpaGvzuMoN7Uzhe+HgTxcIV4YY6AUH/PrH7kouoGJOQ
	jX5Xdjqm0x5JPJxA+wk9Qh7yGArzcLXtPK5chpiJI71rNZCZzcSHxjiLC3JiG2dLOaqhFxKW/0S
	YifSSPeWerZwA/RiKwLpbOHtq9ypL6BiheR5TbvPKhrO1WWvXFhNDQ5kQLJbOZC0gRS3h8Ixub6
	noS0fci7lDWOCmSTI9bJtufeB0TvQDE4t6MuH8JiwZmvmDLkXqw0TOuC+MFBTGCDku/W+gL/diR
	THoUMCIQTjs4M/y7u7hbuwlPSwRmzBh1qivkAOny14AXbDve8WnUXfdh6yYhw/t/ezL2vD8Xo=
X-Received: by 2002:ad4:5ca3:0:b0:90e:94e5:79f8 with SMTP id 6a1803df08f44-912120f012dmr209740706d6.23.1789318313572;
        Sun, 13 Sep 2026 09:51:53 -0700 (PDT)
Received: from localhost ([2603:7001:f100:500:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-9120f4d35a9sm74175506d6.41.2026.09.13.09.51.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 13 Sep 2026 09:51:52 -0700 (PDT)
Date: Sun, 13 Sep 2026 12:51:50 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Matthew Wilcox <willy@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, mm-commits@vger.kernel.org,
	ziy@nvidia.com, vbabka@suse.cz, stable@vger.kernel.org,
	ritesh.list@gmail.com, mhocko@suse.com, hch@lst.de, dgc@kernel.org,
	david@redhat.com, dipiets@amazon.it
Subject: Re: +
 mm-page_alloc-avoid-direct-compaction-for-costly-__gfp_noretry-allocations.patch
 added to mm-hotfixes-unstable branch
Message-ID: <aqbUpoPSdoAlveeZ@cmpxchg.org>
References: <20260911163243.808DF1F000FF@smtp.kernel.org>
 <aqYKsTHkyJXCyh_-@casper.infradead.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aqYKsTHkyJXCyh_-@casper.infradead.org>

On Sun, Sep 13, 2026 at 03:30:09AM +0100, Matthew Wilcox wrote:
> On Fri, Sep 11, 2026 at 09:32:43AM -0700, Andrew Morton wrote:
> > From: Salvatore Dipietro <dipiets@amazon.it>
> > Subject: mm/page_alloc: avoid direct compaction for costly __GFP_NORETRY allocations
> > Date: Fri, 11 Sep 2026 14:21:02 +0000
> > 
> > Commit 5d8edfb900d5 ("iomap: Copy larger chunks from userspace")
> > introduced high-order folio allocations in the iomap buffered write path. 
> > When memory is fragmented, each failed costly-order allocation enters
> > __alloc_pages_slowpath() which runs direct compaction and
> > drain_all_pages(), causing a 0.38x throughput drop on PostgreSQL pgbench
> > (simple-update) with 1024 clients on a 96-vCPU arm64 system.
> > 
> > The root issue is that direct compaction is too expensive for hot
> > allocation paths that have fallbacks to smaller allocations. 
> > __filemap_get_folio_mpol() already marks higher-order allocations with
> > __GFP_NORETRY | __GFP_NOWARN, signalling that the caller can handle
> > failure.  However, the page allocator still attempts full direct
> > compaction for costly orders with __GFP_NORETRY, which is unnecessarily
> > aggressive when the caller will simply retry at a lower order.
> > 
> > For costly-order allocations with __GFP_NORETRY, suppress direct reclaim
> > for the whole slowpath by computing can_direct_reclaim (and hence
> > can_compact) as false.  The !can_direct_reclaim check near the top of the
> > slowpath then short-circuits to nopage: no direct reclaim, no direct
> > compaction and no drain_all_pages() IPI across every CPU.  kswapd (and in
> > turn kcompactd) is still woken further down for background
> > defragmentation, so compaction keeps working for long-term system health
> > while being removed from the latency-critical direct allocation path.
> > 
> > Allocations that also request __GFP_THISNODE are exempted.  That flag
> > pairing identifies the local-node-first THP attempt issued by
> > alloc_pages_mpol() (mempolicy.c), which relies on direct compaction to
> > form transparent huge pages.  __GFP_NOFAIL is exempted as well, so a
> > must-not-fail allocation is never made to fail.
> > 
> > Test environment:
> >   Hardware:  AWS EC2 m8g.24xlarge (96 vCPU, arm64)
> >              12x 1TB IO2 32000 IOPS RAID0 XFS
> >   OS:        AL2023
> >   Kernel:    v7.3-rc1
> >   Database:  PostgreSQL 18.4
> >   Workload:  pgbench simple-update, 1024 clients, 96 threads, 1200s
> > 
> > Results (average of 3 runs, TPS):
> >   Config                                       Avg TPS   % vs baseline
> >   AL2023 stock 6.1 kernel (pre-5d8edfb900d5)   136,942           n/a
> >   v7.3-rc1 baseline (no patch)                  59,408             -
> >   v7.3-rc1 + this patch                        161,994       +172.7%
> > 
> > The patch fully recovers the pre-5d8edfb900d5 performance, bringing
> > throughput back above the pre-regression level and well clear of the ~59k
> > baseline.  The AL2023 6.1 row runs a kernel that predates commit
> > 5d8edfb900d5 ("iomap: Copy larger chunks from userspace"), so it is not
> > directly comparable, but it shows the pre-regression level and confirms
> > that the ~59k baseline is the anomaly and not the norm.
> > 
> > Link: https://lore.kernel.org/all/20260403193535.9970-1-dipiets@amazon.it/T/#t [v1]
> > Link: https://lore.kernel.org/linux-mm/20260420161404.642-1-dipiets@amazon.it/T/#u [v2]
> > Link: https://lore.kernel.org/all/20260710143437.12379-1-dipiets@amazon.it/T/#u [v3]
> > Link: https://lore.kernel.org/all/20260904115629.3993331-1-dipiets@amazon.it/T/#u [v4]
> > Link: https://lore.kernel.org/20260911142102.2294202-1-dipiets@amazon.it
> > Fixes: 5d8edfb900d5 ("iomap: Copy larger chunks from userspace")
> > Signed-off-by: Salvatore Dipietro <dipiets@amazon.it>
> > Acked-by: Zi Yan <ziy@nvidia.com>
> > Cc: Vlastimil Babka <vbabka@suse.cz>
> > Cc: David Hildenbrand <david@redhat.com>
> > Cc: Michal Hocko <mhocko@suse.com>
> > Cc: Johannes Weiner <hannes@cmpxchg.org>
> > Cc: Matthew Wilcox <willy@infradead.org>
> > Cc: Christoph Hellwig <hch@lst.de>
> > Cc: Dave Chinner <dgc@kernel.org>
> > Cc: Ritesh Harjani <ritesh.list@gmail.com>
> > Cc: <stable@vger.kernel.org>
> > Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> 
> i'm just back from vacation, but i think the patch i posted was the
> better way to fic this.  at this point i'm confused why this one is
> being considered, but i'll review all the email from the last two weeks
> and see what's happened to cause this one to be included.

Welcome back, Willy.

The alternate proposal didn't seem to solve Salvatore's problem:
https://lore.kernel.org/all/20260714120204.542300-1-dipiets@amazon.it/

Apologize if you were referring to something more recent, this one was
from mid-July.
