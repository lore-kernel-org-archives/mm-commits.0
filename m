Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B48C12C324E;
	Mon,  2 Jun 2025 19:20:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748892041; cv=none; b=QaadN8nZ9JjnpyYtX1YRCLJxmN0Ro/oiHWrQClm0k2QS7SZeJdOVYRDPpUbr8i5pdxrI9XxX2dW6EoFSQInM1CuZ26TvdV50va7Wo2eC8SKqp8G5o23SmT5xaUETS2pEi8CUAvupoFru4i0COPuutDjcanLbN6uHEsMUSSRLaCw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748892041; c=relaxed/simple;
	bh=5uhXrocylBQdGBan0QqjAPQ5k009DNU1Z8mQ+OjLuBo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jQ4hlVT+fJEP6V3GQruRv0aXuboTwPEpHYlut0ijEvS8KUocd+77+BLrTqCxHM/IxRMXcAr4u0xoUYsp0sXSvrHaln25jCujL/6AM06NUQpEsXVAQ2dCATA3huAbNtuGfXfBQM9w6EXfZPNb+HVWSDpNPVXLYv8UBQMoI+WJecE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=bURaxLVJ; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="bURaxLVJ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=v0JOHp1Sk8wZLXiW77XvXNKnCz2rxKUiMhwBWqUIHew=; b=bURaxLVJAmyVpHPBIb19lm59cU
	rZP9W8HemkuDXsIreFITIpBEv/DxtNb9SNpWVNOVlpWFl/suDq6SRbL1wKLeXZKXmq8jcQRSLUxyS
	DnHfoRUDVJSN3YCVV+6XVcwestxHw7p1B0jDYmxFXj5g6A7DBiIr2s8nmxrTmKEZ/balxdeC1epJ5
	g2unXJkTZtmIOe0t+W+HOO9xWaY6YDAzpw0tmDA1S1hgWyI33e/40kZTF/tb3t5spNwp4cIt/N4lj
	jCMeL67EcMHk4fwNJmCmHL/oMkd3Ev9t7jygrLBY/a359tcZ08drJ4533UoIe62nyd02KdVJ/DJF+
	FvdMY86A==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uMAi5-00000001FuO-3FZs;
	Mon, 02 Jun 2025 19:20:37 +0000
Date: Mon, 2 Jun 2025 20:20:37 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-mm@kvack.org,
	mm-commits@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] Additional MM updates for 6.16-rc1
Message-ID: <aD35hVObSEuPmHDg@casper.infradead.org>
References: <20250601151222.60ead71e7d8492a18c711a05@linux-foundation.org>
 <aD29wnb5zR-afWpM@casper.infradead.org>
 <20250602121751.53ee502779a2f746404a3548@linux-foundation.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250602121751.53ee502779a2f746404a3548@linux-foundation.org>

On Mon, Jun 02, 2025 at 12:17:51PM -0700, Andrew Morton wrote:
> On Mon, 2 Jun 2025 16:05:38 +0100 Matthew Wilcox <willy@infradead.org> wrote:
> 
> > On Sun, Jun 01, 2025 at 03:12:22PM -0700, Andrew Morton wrote:
> > > Linus, please merge this second batch of MM updates for the 6.16-rcX cycle.
> > 
> > A word of warning for Linus since he wouldn't've been cc'd on the
> > earlier email.  This branch is based on v6.15-rc6 but contains a
> > commit which depends on 97dfbbd135cb which was merged during the
> > current merge window.  You might want to do a rebase or ask Andrew to
> > do it in order to prevent a bisection hazard.
> > 
> > 0day-ci found the problem here:
> > https://lore.kernel.org/linux-mm/202506022027.IYQzZghL-lkp@intel.com/
> 
> I think it's OK?  I did the merge and 
> 
> 	d9736929445e iov: remove copy_page_from_iter_atomic()
> 
> lands later than
> 
> 	97dfbbd135cb highmem: add folio_test_partial_kmap()

Yes, but if 'git bisect' lands you on there being a problem in 0b43b8bc8ef8
you won't be able to build it because 0b43b8bc8ef8 has d9736929445e as
an ancestor but not 97dfbbd135cb .  You'll need to add a cherry-pick of
97dfbbd135cb which is aggravating and we try to avoid this.
