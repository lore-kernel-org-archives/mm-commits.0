Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C1A825B0BC
	for <mm-commits@vger.kernel.org>; Sun,  5 Jul 2026 10:45:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783248313; cv=none; b=Sb9CfODmNs3EIbldXpYeq/lpwEIgZsnBxvPwEMRCs5UTIrspJdpEhFOFL7dUp++NMk5gDDot6NFOlxWEZu6qFyReRf19ta+6VTzhMH//gHqoNA3j8wAW3HQyCnrK+Ap/MRSWv+TP7o7phLA2Bw1wpRPgMGMvso3R0UQtYI6tG9o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783248313; c=relaxed/simple;
	bh=CFgFFnJiFfFOKLnQQkwc3vs9vMYeeAx7u53A2XFk2rU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mPv8xUStVPnWQvbCUrmz91ftVKyQMi5hiQgem7XU/xBh6ZMrkOMTRodNFh/aZzZTBTzGCUQI+DiPFrLgO6kAdp1VLkYmeFFYbILbDHoTzLrqFd45Cx7f6B7o4+t7DlKXxVtpOZN3Mp+OiLd4Ywd/1YaQmU/g75vnN00xSAySfnM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=pass smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=kSPtggAS; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="kSPtggAS"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=5ZlsrhQnOVhAeS4Soen8cEaUaVEsFOaO+mrHymTaE1o=; b=kSPtggAS47qvPConlXdYEDwzAX
	EoXTOkWt4WhkzBGtUwvH36640NushvRs29pzZBxIV1ZiLXw8U2r7Upy295JVJFs913g7P6D03PXSm
	kmXYTJ6zzHrv7NFjusjlpe8vn9kZUOEmn337PzX85PQxER2B9J4aM4uNhs2bHXG6v1J0U/VYwJePd
	FEnCKoS1cmzhNMaAr1m2cOt8aBk4K30SIfuYNevjrll23luYnlzVqJeIgwKJF/0UgKfjk/p42aICT
	027Njq/bDCUIZ9vWb5Ym2BVU2hVM3WWYxtEqBRtY4czqipixk6aRsBBGVqZSqOcj+qHXqITbmLW21
	lfMGxWFg==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wgKLQ-0000000DkyD-4BGS;
	Sun, 05 Jul 2026 10:45:05 +0000
Date: Sun, 5 Jul 2026 11:45:04 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: mm-commits@vger.kernel.org, kent.overstreet@linux.dev,
	catalin.marinas@arm.com, bigeasy@linutronix.de, arnd@arndb.de,
	leitao@debian.org
Subject: Re: +
 radix-tree-fix-kmemleak-false-positives-on-tree-head-reassignment.patch
 added to mm-new branch
Message-ID: <ako1sMPVu4dfQR4K@casper.infradead.org>
References: <20260705021240.79E101F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260705021240.79E101F000E9@smtp.kernel.org>

On Sat, Jul 04, 2026 at 07:12:40PM -0700, Andrew Morton wrote:
> The patch titled
>      Subject: radix-tree: fix kmemleak false positives on tree head reassignment
> has been added to the -mm mm-new branch.  Its filename is
>      radix-tree-fix-kmemleak-false-positives-on-tree-head-reassignment.patch

Umm.  I don't see this patch in my inbox anywhere else.  Is email broken
again?

> From: Breno Leitao <leitao@debian.org>
> Subject: radix-tree: fix kmemleak false positives on tree head reassignment
> Date: Fri, 03 Jul 2026 08:22:03 -0700
> 
> Kmemleak periodically reports transient false positives for radix tree
> nodes allocated through the IDR, for example:
> 
>   unreferenced object 0xffff0004d6ac4200 (size 576):
>     comm "tcpeventd", pid 6412
>     backtrace (crc 335d668a):
>       kmem_cache_alloc_noprof
>       radix_tree_node_alloc
>       radix_tree_extend
>       idr_get_free
>       idr_alloc_cyclic
>       map_create
>       __sys_bpf
> 
> radix_tree_extend() (grow) and radix_tree_shrink() (shrink) repoint
> root->xa_head to a new node.  If a kmemleak scan has already walked past
> root->xa_head, the new head is not reachable from any scanned pointer
> until the following scan, so kmemleak reports it as leaked even though it
> is live.
> 
> This is the same race fixed for the XArray API in commit a1a029bcea59

This commit ID doesn't exist in any tree I have.

> ("XArray: fix kmemleak false positive in xas_shrink()").  The IDR uses the
> radix tree API directly and hits it on both the grow and the shrink path,
> so mark the new head as a transient leak in both.
> 
> Add a matching kmemleak_transient_leak() stub to the radix tree test
> harness so the userspace lib/radix-tree.c build keeps building.

Last time this was proposed, the suggestion was that kmemleak needed to
be fixed.

https://lore.kernel.org/all/aCyI8T2sWlPLEYZ_@arm.com/
