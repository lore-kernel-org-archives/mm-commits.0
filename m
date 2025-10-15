Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B4C624BBEC
	for <mm-commits@vger.kernel.org>; Wed, 15 Oct 2025 21:58:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760565512; cv=none; b=fuGjb+XmeRbBYGa4SidjsVmpUYVxPt8dr+UiTbb2Ctxo1GHt15bOQFx2BJGEhtPJGuhlSkuQuNi6VJJ/9ldTzvv5G+6hwfGFuKvsgAMDX56pTXOoNoMQOT5KM7LrWLf+gJD5C1zNRf7pSkp/89+2KMSHcjnyNAkejFmndUMjHCY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760565512; c=relaxed/simple;
	bh=2i0/Oqd0xA/wctqdGDoHocT7dt+AYvcSIsolq8d1/8E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Uq8xRcQB/o4e71Oy1zQHB9c/VwX6rWk5kUHpDJpMPFCXgbgGp9/ornu4h0vUpbtpB8Yv3M0dlQfKFuqO1lFZEtDTto9IXejEHMPhWKPI1+O6Cu7SjPdmqhUQML/ki/pGjRtqGNFcdf/dvwOgDzWjOKkK3EO98ANiDe72QKjsDMY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=dTKp297p; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="dTKp297p"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=yS0F862C7TIRvhn5CXBGniS6Pg3oin29LISAx+1qmHA=; b=dTKp297pJe1EJP1NkMuhncUdfr
	iTP7N6TOtDCOoMjwqhg/XikDEFsacsr5SexapJ9YwTIA8aAnDNvac+yhjT/fSTOYaBf3PSXlGcBFM
	PkS/wU9Si9Spq3trYBPX8yLixEdvM4wpXZ5t+i0wKqsTDi602n6FqnjN2qQl9rUGOojEXgKh/crKG
	puQ4uJqu5dzLgAq8eN6TLa2YZTk1iPY7LTUBtSz+DcgGPrhg3p8/J047BBApuMwm3CfYojAC26NBt
	PTkzqiIYelqnp8f3MGPc0m0mNV+xCaypHz00DqY8GPzLibGBzKMYHuPd5cB6x/BCfi2Fy/dDf6TFt
	PWzFjjOw==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1v99Vp-00000007TXc-1HLY;
	Wed, 15 Oct 2025 21:58:26 +0000
Date: Wed, 15 Oct 2025 22:58:25 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: mm-commits@vger.kernel.org, guoren@kernel.org, rppt@kernel.org,
	Thomas =?iso-8859-1?Q?Wei=DFschuh?= <thomas.weissschuh@linutronix.de>
Subject: Re: + csky-mm-fix-build-errors-cause-by-folio-flags-changes.patch
 added to mm-hotfixes-unstable branch
Message-ID: <aPAZAVMunRWb-QHk@casper.infradead.org>
References: <20251015215059.D610BC4CEFB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251015215059.D610BC4CEFB@smtp.kernel.org>

On Wed, Oct 15, 2025 at 02:50:59PM -0700, Andrew Morton wrote:
> 
> The patch titled
>      Subject: csky/mm: fix build errors cause by folio flags changes
> has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
>      csky-mm-fix-build-errors-cause-by-folio-flags-changes.patch

Again, it seems churlish to merge Mike's patch insteaad of Thomas' that
was sent two weeks ago.
