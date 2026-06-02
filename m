Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0CF126D4C3
	for <mm-commits@vger.kernel.org>; Tue,  2 Jun 2026 12:41:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780404062; cv=none; b=vDaxBN2l1KXGR+/x2fBDpUMNg+zbpb7YMtxUY8HwmvVIjHcrWY2KUAnuzsff0uj3Sk9xpUC5CCnlSXnX+XNv4rc/dkQxX1GI61Mbb8YGWAUufewFPriLcukI3O1XcjJA00+/MU8yLP8lfE+XGe9p64+secR6mv0rG9hJ7MzMRAk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780404062; c=relaxed/simple;
	bh=lcXbnLDgLgVs2uXAQfjp2nc6EET+6EBNWhFE8+/l0xY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gQcMWV476l2DQ6loXb+PP88BC1TVY2Rtf15CInHeFl7/E9Ljve7lMwzVtp2JNpFDIAeatvkwqpM0aR6ibJKUZ1NaIODAGH7VRKaVVd2vgpoBn41ZBYJn8XXF8pUNz4RMmx3jLpQX+8kUyLakS0S1D17cbTjR4wAvgK+KAwbAhdo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=IW45O6Va; arc=none smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="IW45O6Va"
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-490b211ee6aso5832175e9.3
        for <mm-commits@vger.kernel.org>; Tue, 02 Jun 2026 05:41:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1780404059; x=1781008859; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=qSDM2Nyr7WYYlYXf1yBwq5GfCMjSOs4ctNyEmP6XpQA=;
        b=IW45O6VaRSkblMVsvJfCNyHg2woDizBEVSqXSFKF9GWHXDhMwxrR4n6wD/4430W96W
         ww6pa8LvU+lsoX8S9/O1YE3/oN/lBHog9MWlyifEFPlZKNLbd/+L6ipQKMToRONbwfVv
         z93iQsvup+wSCajULsETGntW836vgYJLGFem+CuCSuhTiYGfAwEPL8v2rzQIORrc4mUI
         EhW5pYCH2Nd/37lSh8o7NNYGIx6/1SHV5P/LpGdsd1Y0Qktp2LZkj/8nHdydufjZlVTW
         JKlA1WP1Ao02jsaMqnU2/o5G+k3RPKh5xpBD4yJqVvCs0SBdEVFq9QCshIWBJKKWa6Ry
         k+Lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780404059; x=1781008859;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qSDM2Nyr7WYYlYXf1yBwq5GfCMjSOs4ctNyEmP6XpQA=;
        b=AMMY5o6XrgfA+aaMxsctEDe9Zi/R3Y1HZQfxsjUmArQJ7772dhM+RwliEbf/DV2C7o
         mS3AFXfLMnxpnqI4rVnCFCgrTXrDFh8Dc9IVx0mMFjJenMGHA9AhK3qQnx4VcoJQvOVR
         yDwm2+PYVvFsQdYN2DKcCbbRnZwCEdogBofwZsWoXJfaXAPQ1MNVqRSac04K0fWG8lM8
         CJzNsLVlWoA8UMBO884Q0TYLG/yQN8HWUMFXU6GcdSeNqTesXOlfYUKsFkn2EQNILiQL
         i11/T4dVoTeuzKRPxP9qo4+b4O4JAqr0MauEKMo7iAA7yrRiQILi1v728BlNZ7p0JSGA
         VZUg==
X-Forwarded-Encrypted: i=1; AFNElJ+g0xLcrJxMoXccOFYaqSpL+eWssqbt7vLf7cB+plts9uNsA+e3NZS2biAgp6tIVneT2rIKlbAU9eGp@vger.kernel.org
X-Gm-Message-State: AOJu0YwUuaXXgDOQUDCTfpgWNK2CiRb7+4lKXLjCLX3lqKiZnEaL7weI
	CynbVgKReOXYmQUV57QRQWMc4RVzni2zdLkP5ymA3tMnSWStuZd43q2JzvC8bYoXIL8oYM2VIA7
	q8pbt
X-Gm-Gg: Acq92OHjk2pt/CK/78ObZ47JhftDBX6EkVUVRtpzE/71P2XDAYaJj2klFfYMLyN6kBp
	0WxyUZtcuwu1iD3DNA10FRHc6rrTs7skw4pyeUIDCFioiy+P9PQIKdBqk8HEcofQVIl+J+DS++b
	YpjM87hFnuvk8c4kUAQhWoICODglOowV/pXc+Gqy7zJ2ZW+TOcXap0lcEt0wI5OoXSePrj7wGsz
	VKEK8l8t0UlxKtHZX0iLLZogZmyKhEcniqE9YVdkZUe2GY3V1DZQQ3B+OgdrsbFm3ZqvJzyEtXk
	Di7BOCaVDCPz35RJYCVjGcCOR8bf2lpQ5HtfzTYDwl3/M57wppjL6+824CB6092SeKLfCJH3kfL
	5rbMX3M+PZuhaWnksWuXlGfuBy4Iej97z/1v3JaauNG0Tgnmv9UjlZe2rG8ZTIp7WgyDSsIKG2e
	+gtf8vL4kExzN3CoIvS36kFB+Cxw8xsetvmMMS
X-Received: by 2002:a05:600c:4e43:b0:490:ace2:f8f with SMTP id 5b1f17b1804b1-490ace2109bmr139640425e9.21.1780404059323;
        Tue, 02 Jun 2026 05:40:59 -0700 (PDT)
Received: from pathway ([176.114.240.130])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-490b0e38126sm55399785e9.14.2026.06.02.05.40.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Jun 2026 05:40:59 -0700 (PDT)
Date: Tue, 2 Jun 2026 14:40:56 +0200
From: Petr Mladek <pmladek@suse.com>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, mm-commits@vger.kernel.org,
	stable@vger.kernel.org, nathan@kernel.org, hca@linux.ibm.com,
	gor@linux.ibm.com, ansuelsmth@gmail.com, andersson@kernel.org,
	aleksander.lobakin@intel.com, agordeev@linux.ibm.com, arnd@arndb.de,
	Tamir Duberstein <tamird@kernel.org>
Subject: Re: + errh-use-__always_inline-on-all-error-pointer-helpers.patch
 added to mm-nonmm-unstable branch
Message-ID: <ah7PWK4gTdOYG1t_@pathway>
References: <20260526184100.3BA431F000E9@smtp.kernel.org>
 <ah6WDkwO8eYY5f2a@ashevche-desk.local>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ah6WDkwO8eYY5f2a@ashevche-desk.local>

Adding Tamir into Cc.

On Tue 2026-06-02 11:36:30, Andy Shevchenko wrote:
> On Tue, May 26, 2026 at 11:40:59AM -0700, Andrew Morton wrote:
> 
> > The patch titled
> >      Subject: err.h: use __always_inline on all error pointer helpers
> > has been added to the -mm mm-nonmm-unstable branch.  Its filename is
> >      errh-use-__always_inline-on-all-error-pointer-helpers.patch
> > 
> > This patch will shortly appear at
> >      https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/errh-use-__always_inline-on-all-error-pointer-helpers.patch
> 
> Petr, shouldn't this also fix the problem with old (buggy) GCC for xtensa
> (IIRC) that we encountered in some tests a couple of months ago?

It might here there as well. Unfortunately, I could not test it easily
because it required some old GCC.

I wonder if Tamir could try to revert the commit 8901ac9d2c7eb8ed
("printf: Compile the kunit test with DISABLE_BRANCH_PROFILING")
and try this patch instead.

Best Regards,
Petr

> > ------------------------------------------------------
> > From: Arnd Bergmann <arnd@arndb.de>
> > Subject: err.h: use __always_inline on all error pointer helpers
> > Date: Tue, 26 May 2026 12:18:41 +0200
> > 
> > While testing randconfig builds on s390, I came across a link failure with
> > CONFIG_DMA_SHARED_BUFFER disabled:
> > 
> > ERROR: modpost: "dma_buf_put" [drivers/iommu/iommufd/iommufd.ko] undefined!
> > 
> > The problem here is that IS_ERR() is not inlined and dead code elimination
> > fails as a consequence.
> > 
> > The err.h helpers all turn into a trivial assignment of a bit mask and
> > should never result in a function call, so force them to always be inline.
> > This should generally result in better object code aside from avoiding
> > the link failure above.
> > 
> > Link: https://lore.kernel.org/20260526101851.2495110-1-arnd@kernel.org
> > Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> > Reviewed-by: Alexander Lobakin <aleksander.lobakin@intel.com>
> > Cc: Alexander Gordeev <agordeev@linux.ibm.com>
> > Cc: Andriy Shevchenko <andriy.shevchenko@linux.intel.com>
> > Cc: Ansuel Smith <ansuelsmth@gmail.com>
> > Cc: Bjorn Andersson <andersson@kernel.org>
> > Cc: Heiko Carstens <hca@linux.ibm.com>
> > Cc: Nathan Chancellor <nathan@kernel.org>
> > Cc: Vasily Gorbik <gor@linux.ibm.com>
> > Cc: <stable@vger.kernel.org>
> > Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> > ---
> > 
> >  include/linux/err.h |   12 ++++++------
> >  1 file changed, 6 insertions(+), 6 deletions(-)
> > 
> > --- a/include/linux/err.h~errh-use-__always_inline-on-all-error-pointer-helpers
> > +++ a/include/linux/err.h
> > @@ -36,7 +36,7 @@
> >   *
> >   * Return: A pointer with @error encoded within its value.
> >   */
> > -static inline void * __must_check ERR_PTR(long error)
> > +static __always_inline void * __must_check ERR_PTR(long error)
> >  {
> >  	return (void *) error;
> >  }
> > @@ -60,7 +60,7 @@ static inline void * __must_check ERR_PT
> >   * @ptr: An error pointer.
> >   * Return: The error code within @ptr.
> >   */
> > -static inline long __must_check PTR_ERR(__force const void *ptr)
> > +static __always_inline long __must_check PTR_ERR(__force const void *ptr)
> >  {
> >  	return (long) ptr;
> >  }
> > @@ -73,7 +73,7 @@ static inline long __must_check PTR_ERR(
> >   * @ptr: The pointer to check.
> >   * Return: true if @ptr is an error pointer, false otherwise.
> >   */
> > -static inline bool __must_check IS_ERR(__force const void *ptr)
> > +static __always_inline bool __must_check IS_ERR(__force const void *ptr)
> >  {
> >  	return IS_ERR_VALUE((unsigned long)ptr);
> >  }
> > @@ -87,7 +87,7 @@ static inline bool __must_check IS_ERR(_
> >   *
> >   * Like IS_ERR(), but also returns true for a null pointer.
> >   */
> > -static inline bool __must_check IS_ERR_OR_NULL(__force const void *ptr)
> > +static __always_inline bool __must_check IS_ERR_OR_NULL(__force const void *ptr)
> >  {
> >  	return unlikely(!ptr) || IS_ERR_VALUE((unsigned long)ptr);
> >  }
> > @@ -99,7 +99,7 @@ static inline bool __must_check IS_ERR_O
> >   * Explicitly cast an error-valued pointer to another pointer type in such a
> >   * way as to make it clear that's what's going on.
> >   */
> > -static inline void * __must_check ERR_CAST(__force const void *ptr)
> > +static __always_inline void * __must_check ERR_CAST(__force const void *ptr)
> >  {
> >  	/* cast away the const */
> >  	return (void *) ptr;
> > @@ -122,7 +122,7 @@ static inline void * __must_check ERR_CA
> >   *
> >   * Return: The error code within @ptr if it is an error pointer; 0 otherwise.
> >   */
> > -static inline int __must_check PTR_ERR_OR_ZERO(__force const void *ptr)
> > +static __always_inline int __must_check PTR_ERR_OR_ZERO(__force const void *ptr)
> >  {
> >  	if (IS_ERR(ptr))
> >  		return PTR_ERR(ptr);
> 
> -- 
> With Best Regards,
> Andy Shevchenko
> 
