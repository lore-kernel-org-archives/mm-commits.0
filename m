Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2175139B
	for <mm-commits@vger.kernel.org>; Wed, 26 Feb 2025 04:33:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740544423; cv=none; b=Lbo+E4JO8sZ60v8YUab71FT4v/rizj53Ys8IZOfMgoE6qk/LtVubffSwwSRK5HJFAP5TfqKXxGqxzu/mPp5HGjdV7ocQsXGxbiaif4l8MMI/hmzNl8oRzPuDO5ZP5Xn5fwDawjxUFTWoqDxtoazxeqXyufpWgQuWvH/JhMpKkB4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740544423; c=relaxed/simple;
	bh=IDapue4rgTIHsJRfPyjp6GQOVZoayFSYUIy5uwkhrmA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Hg+fF++UG/hFFBZCkjVe5HFDkV76kiVRIiSK7PjOpU+2gPZqXZfuHCGkgUpdC+ZufhboymYN1g6FBFO2Co2RJXyX6A1T5jR7mFZRjZGRfnTpIu+7zvVaj46Niv7X+mSQ5D5Z35fRYxpaEq+NcnXZ4i11+4+9hchqI5ep54dpm6c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=UWD2XSlX; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="UWD2XSlX"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=+KLbcYrvhMSN5Ij7Rj7RwdB9a/HcqptQek/8PecY/CU=; b=UWD2XSlXXTxTwiElr3KhS8H3jo
	MyytzWebjkStTuSb+vINfEBKphabHnmbKjfexxnqfCNowfYORn4xrMIJ4SBo9Z+YWWTXYpNHVfI1i
	KoHE1oAMmXC8M9dDbXzJs7FgUHKTC5bxDkMkcj25p1zDI9fXOjaoGpJAqHPUEJuAWJJG/FgBX3YTg
	9PdfdceGa2dOzjdVhVwlvHa6zN2tAcxuBpJ+qD0nwAfvNH10wH41lsfvnq2HMJPfVWa1VMAtoGl9g
	ilzvgfFHwY1Rlr+rMC076WNKVaJaJk/7qv4I5bogopG6TTk3otPRP6lWXegWL+A+K7WyZb1EWM960
	FTMSpQjA==;
Received: from willy by casper.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tn975-0000000Ds4Z-2Paq;
	Wed, 26 Feb 2025 04:33:39 +0000
Date: Wed, 26 Feb 2025 04:33:39 +0000
From: Matthew Wilcox <willy@infradead.org>
To: Wei Yang <richard.weiyang@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, mm-commits@vger.kernel.org,
	michel@lespinasse.org
Subject: Re: +
 lib-interval_tree-skip-the-check-before-go-to-the-right-subtree.patch added
 to mm-nonmm-unstable branch
Message-ID: <Z76ZoxcFUIBSu63a@casper.infradead.org>
References: <20250225042234.AC256C4CEDD@smtp.kernel.org>
 <Z725ERN5KDAANgD6@casper.infradead.org>
 <20250226022233.wjvxv2o6672vhkky@master>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250226022233.wjvxv2o6672vhkky@master>

On Wed, Feb 26, 2025 at 02:22:33AM +0000, Wei Yang wrote:
> On Tue, Feb 25, 2025 at 12:35:29PM +0000, Matthew Wilcox wrote:
> >On Mon, Feb 24, 2025 at 08:22:34PM -0800, Andrew Morton wrote:
> >> The patch titled
> >>      Subject: lib/interval_tree: skip the check before go to the right subtree
> >> has been added to the -mm mm-nonmm-unstable branch.  Its filename is
> >>      lib-interval_tree-skip-the-check-before-go-to-the-right-subtree.patch
> >
> >I don't think this patch should be added.  There's no claim of any
> >performance win.  Wei has a long history of tweaky little patches that
> >may or may not be buggy.  The interval tree has been around a long time
> >and doesn't have a test suite.  This feels like unnecessary risk.
> 
> Your concern is understandable. A change in fundamental data structure should
> be very careful. But I thought we don't take things personal.

This isn't personal.  It's noting your history.

If you want to add a test suite for the interval tree to the kernel,
that would be a useful set of patches.  And it would remove my concern
if we can demonstrate that we've exercised the code paths that you're
modifying and everything is fine.
