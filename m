Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD59C30EF99
	for <mm-commits@vger.kernel.org>; Wed, 15 Oct 2025 22:29:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760567372; cv=none; b=bU7Xn421BjPBJVySKfu1WHMhIUBDNt+2rT+OFeWVwkVdDM9Tr1tuD5Vit3IZ9NTZVCD03KBOOpzM2CZNM65IxdsUj4LTOz5U/N213DHsa62UvOzIf+Ih3SyPvYHQIaspb8dm/t0JjRuA5oL6szn3VFg7tXWL+1nXc64jYZmADOA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760567372; c=relaxed/simple;
	bh=ECUcePGQDSB4JFVHjwAGqA5L2TLfK0Z5XCMr6dHYTj4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XJlBd5EpmlKUb68l6NvEUsM6Vk1tnpEYzmMzjvfnGX2vIzY+PGGg2cU0en4KgxxtfjAm11kyNMzusMptzXDQaXnZY6rwPYkktlfOhFI3B0ZTOCF5T2NHDyvwtWp3scC8DYENaOVVQfPP4lz4wHZkF+ZJZplPtzCk/AkKQmDOBso=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=lUNodC1L; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="lUNodC1L"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Transfer-Encoding:
	Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
	Sender:Reply-To:Content-ID:Content-Description;
	bh=IObETHLfJJIUjRhXs7buUeYE+jhpocJOLq1p6X2Ju/c=; b=lUNodC1LsXQz7GvRLEn6lZZnka
	zXVk0CahUvLGwCW9RffYLwARw8972YdmvkqEfjVCLCtcTNGQs/X0u2gLRzhK0kOeUF9Y5gjpfA4JP
	riQAnYAEdlJA0hGTgKujsagkJviGM3cwm3s0QKi0dppfyK5ZHt5DCg1YNBJOumOiNB7IBwCR3NTpE
	fq+8Sc6E4zNLlPis6wEBys5YxvvgeSR5cTvXQ7EbVzlNUKaIFCOMAg975bwAi1DI6m1FwYD27CUM3
	mWHaieYafXRYI6a/82ekXPmwonUmePMao7c4+4qAR32+ZNI3s75BVCh/oHWBKPfBlc9WLh26JeUm+
	cHJUxIHw==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1v99zs-00000007ukS-0fnv;
	Wed, 15 Oct 2025 22:29:28 +0000
Date: Wed, 15 Oct 2025 23:29:27 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: mm-commits@vger.kernel.org, guoren@kernel.org, rppt@kernel.org,
	Thomas =?iso-8859-1?Q?Wei=DFschuh?= <thomas.weissschuh@linutronix.de>
Subject: Re: + csky-mm-fix-build-errors-cause-by-folio-flags-changes.patch
 added to mm-hotfixes-unstable branch
Message-ID: <aPAgR6FNizJTKGJu@casper.infradead.org>
References: <20251015215059.D610BC4CEFB@smtp.kernel.org>
 <aPAZAVMunRWb-QHk@casper.infradead.org>
 <20251015151016.bf3f31797dea74558dc00c67@linux-foundation.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20251015151016.bf3f31797dea74558dc00c67@linux-foundation.org>

On Wed, Oct 15, 2025 at 03:10:16PM -0700, Andrew Morton wrote:
> On Wed, 15 Oct 2025 22:58:25 +0100 Matthew Wilcox <willy@infradead.org> wrote:
> 
> > On Wed, Oct 15, 2025 at 02:50:59PM -0700, Andrew Morton wrote:
> > > 
> > > The patch titled
> > >      Subject: csky/mm: fix build errors cause by folio flags changes
> > > has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
> > >      csky-mm-fix-build-errors-cause-by-folio-flags-changes.patch
> > 
> > Again, it seems churlish to merge Mike's patch insteaad of Thomas' that
> > was sent two weeks ago.
> 
> I can't find such a patch from Thomas and the message-id you sent
> didn't work for me  - what was the Subject:?

Date: Mon, 06 Oct 2025 14:13:37 +0200
From: Thomas Weiﬂschuh <thomas.weissschuh@linutronix.de>
To: Guo Ren <guoren@kernel.org>, "Matthew Wilcox (Oracle)"
        <willy@infradead.org>, Zi Yan <ziy@nvidia.com>, Andrew Morton
        <akpm@linux-foundation.org>
Cc: linux-csky@vger.kernel.org, linux-kernel@vger.kernel.org, Thomas Weiﬂschuh
        <thomas.weissschuh@linutronix.de>
Subject: [PATCH] csky: abiv2: Adapt to new folio flags field

