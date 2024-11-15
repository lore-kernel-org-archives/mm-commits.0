Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 398A51D47B6
	for <mm-commits@vger.kernel.org>; Fri, 15 Nov 2024 15:42:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731685351; cv=none; b=jEdAsvgMXVfSIqMnlHHMPR7pFvk2zAW2SIiUFhO7UtMDpEew5y2JGiKfM4A1hwlMwYq/i2eaXPxNBvbyXG/NxuuI8I8SqvBDgaCJhxKdP5MaIb5cieHIoKKEX392c3cgux4u4CBFdbWYda0p0tBvuaudt74dtRzyj++txkgdoxg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731685351; c=relaxed/simple;
	bh=tDmmGIKykwPCCuKXNf6rXN5xeKy1cdpJlFiL+VT3tTA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RUhPyfO3hKL7Vfx1tseHZGQPRpHzEhmqWEEEWKW6HUQ3HmsKEf3rgce75naW0TeWgvzt8kB3XpiwxicTrYN3lV4lEIPuKsaH55I6EeHCklVTIG7OLs65CXmMHQJq+AKlWSPP2dQEkt0hBnJvsDdzoP/pHF6i4wrd/cuwt80SZsw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=B9M+ak3+; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="B9M+ak3+"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7XDkHn9pPQGtWzaV3yS8fl9im6iIDTJ6uLGHvdARC0=; b=B9M+ak3+1sI2hf81uaCQX1wD0F
	dl1rFhuEzoZhZqnlz2dtCZ3Zlb/PkxG8K8pHrwQ/mWFmMEHiJYmds8wB3yFZ8NamDfqNYhXks6PnV
	bgdr5ycS7Qgw/YjwkCKDsWs20P5taTYHTG0keg4r93x6Ln/IBM1TnGBoCQq+5wYEQgxzi9Rathu8f
	avpLF0nBhUOy9Tv+vMGuJZ4f4mFXErgDj53GEMKKbhc3qSLiN/Myd++RIJLsWPcqjEmaIYs65H30d
	Exe4uULMI//fIrrF8QDG786CqZgj4i97ttIvUuha+i9PUp8NnUNUx5G6DDsticbt8fdfGhWmpG3nN
	F2pU/tig==;
Received: from willy by casper.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tBySo-000000003PJ-0DKC;
	Fri, 15 Nov 2024 15:42:26 +0000
Date: Fri, 15 Nov 2024 15:42:25 +0000
From: Matthew Wilcox <willy@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: mm-commits@vger.kernel.org, david@redhat.com, alexs@kernel.org,
	cuigaosheng1@huawei.com
Subject: Re: + ksm-convert-cmp_and_merge_page-to-use-a-folio-fix.patch added
 to mm-unstable branch
Message-ID: <Zzdr4ePQx-Dqub6N@casper.infradead.org>
References: <20241024032946.9061AC4CEC7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241024032946.9061AC4CEC7@smtp.kernel.org>

On Wed, Oct 23, 2024 at 08:29:46PM -0700, Andrew Morton wrote:
> 
> The patch titled
>      Subject: mm/ksm: add missing IS_ERR_OR_NULL check for stable_tree_search()
> has been added to the -mm mm-unstable branch.  Its filename is
>      ksm-convert-cmp_and_merge_page-to-use-a-folio-fix.patch

NAK.  Patch is garbage.
