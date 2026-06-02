Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DE803C7689;
	Tue,  2 Jun 2026 08:36:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780389398; cv=none; b=PaC7JVAftCe+JZwbdOlW0t/oqvrJXtb2j8tV/D3J9E7ErH/UZzQdx/b/fpqwC40BANb7EjHR5Q/BgGNxnDEJpEMKzOcGYgGmCPzxHMyzXEcu4HrBaHH2c03XUT1jDmVpWLgfdXe1VzysQ2ynxfHJkjzYPHBUK04eHL032a8nLo8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780389398; c=relaxed/simple;
	bh=/ycaRdp0w1dKC9Xn2Ox7dM3FTWAslJDeqtt17t5IV+Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=D6uf8y9e+E3vhRRUWC6Owos3zZrSSeoFPFjqzi/PYaGhAzaOz50HK2m+6tp9Ghsn3Yl9R567kqYEmsrVLPpTxC3c8H3+Safl2d1xi9wTYNNbkNiwSIi15jr0MVwbvoobbNB/KcV5LXisEV5HWNsiNau3m4kq53JrxUGiuqDri1A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=nyTTw8ho; arc=none smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="nyTTw8ho"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1780389396; x=1811925396;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=/ycaRdp0w1dKC9Xn2Ox7dM3FTWAslJDeqtt17t5IV+Y=;
  b=nyTTw8hogyyTIhWwTI6JQOPpotZj6cWRtQA/UrLRH2ChWjJcw7RWuKv8
   VBk8xfGyO4SNS5iSbWP07QG4FL2KfU+ggeZwPMd/vtCpwxWUOVCmk6Cok
   xMhBdPjebo+Wq+j+/DQwD4nVY02jc6zMD9MuOTDAfoIcWN9SjeIuxeH2B
   a7Pk4pbQodVIh0ZGTUNKRHaqIR/XABvyR6ckFMpO9I51Q3F3GFRldZH3N
   DZI6Bh/iKfgTPYhyNej0TPJoGBg0ofJMBxR4h5se9ZK8GMSU6Xjjjs9QN
   eyMm48rL0XdkLb2VE+/icaQNryEHx3iC2pffwPNRuy/p9i3DJ8NA+pnPI
   Q==;
X-CSE-ConnectionGUID: kxwed6JiSviIcgxdVgOUEA==
X-CSE-MsgGUID: 3Rcrm2wURgGEN/ARLdRXWA==
X-IronPort-AV: E=McAfee;i="6800,10657,11804"; a="80199130"
X-IronPort-AV: E=Sophos;i="6.24,182,1774335600"; 
   d="scan'208";a="80199130"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jun 2026 01:36:36 -0700
X-CSE-ConnectionGUID: 8U6esbO5Rwy9OeDpX5V5+A==
X-CSE-MsgGUID: EPDa07z1RAikHivF+udnfw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,182,1774335600"; 
   d="scan'208";a="248928089"
Received: from mkosciow-mobl1.ger.corp.intel.com (HELO localhost) ([10.245.245.229])
  by fmviesa005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jun 2026 01:36:33 -0700
Date: Tue, 2 Jun 2026 11:36:30 +0300
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Petr Mladek <pmladek@suse.com>
Cc: mm-commits@vger.kernel.org, stable@vger.kernel.org, nathan@kernel.org,
	hca@linux.ibm.com, gor@linux.ibm.com, ansuelsmth@gmail.com,
	andersson@kernel.org, aleksander.lobakin@intel.com,
	agordeev@linux.ibm.com, arnd@arndb.de
Subject: Re: + errh-use-__always_inline-on-all-error-pointer-helpers.patch
 added to mm-nonmm-unstable branch
Message-ID: <ah6WDkwO8eYY5f2a@ashevche-desk.local>
References: <20260526184100.3BA431F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260526184100.3BA431F000E9@smtp.kernel.org>
Organization: Intel Finland Oy - BIC 0357606-4 - c/o Alberga Business Park, 6
 krs, Bertel Jungin Aukio 5, 02600 Espoo

On Tue, May 26, 2026 at 11:40:59AM -0700, Andrew Morton wrote:

> The patch titled
>      Subject: err.h: use __always_inline on all error pointer helpers
> has been added to the -mm mm-nonmm-unstable branch.  Its filename is
>      errh-use-__always_inline-on-all-error-pointer-helpers.patch
> 
> This patch will shortly appear at
>      https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/errh-use-__always_inline-on-all-error-pointer-helpers.patch

Petr, shouldn't this also fix the problem with old (buggy) GCC for xtensa
(IIRC) that we encountered in some tests a couple of months ago?

> ------------------------------------------------------
> From: Arnd Bergmann <arnd@arndb.de>
> Subject: err.h: use __always_inline on all error pointer helpers
> Date: Tue, 26 May 2026 12:18:41 +0200
> 
> While testing randconfig builds on s390, I came across a link failure with
> CONFIG_DMA_SHARED_BUFFER disabled:
> 
> ERROR: modpost: "dma_buf_put" [drivers/iommu/iommufd/iommufd.ko] undefined!
> 
> The problem here is that IS_ERR() is not inlined and dead code elimination
> fails as a consequence.
> 
> The err.h helpers all turn into a trivial assignment of a bit mask and
> should never result in a function call, so force them to always be inline.
> This should generally result in better object code aside from avoiding
> the link failure above.
> 
> Link: https://lore.kernel.org/20260526101851.2495110-1-arnd@kernel.org
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Reviewed-by: Alexander Lobakin <aleksander.lobakin@intel.com>
> Cc: Alexander Gordeev <agordeev@linux.ibm.com>
> Cc: Andriy Shevchenko <andriy.shevchenko@linux.intel.com>
> Cc: Ansuel Smith <ansuelsmth@gmail.com>
> Cc: Bjorn Andersson <andersson@kernel.org>
> Cc: Heiko Carstens <hca@linux.ibm.com>
> Cc: Nathan Chancellor <nathan@kernel.org>
> Cc: Vasily Gorbik <gor@linux.ibm.com>
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>  include/linux/err.h |   12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)
> 
> --- a/include/linux/err.h~errh-use-__always_inline-on-all-error-pointer-helpers
> +++ a/include/linux/err.h
> @@ -36,7 +36,7 @@
>   *
>   * Return: A pointer with @error encoded within its value.
>   */
> -static inline void * __must_check ERR_PTR(long error)
> +static __always_inline void * __must_check ERR_PTR(long error)
>  {
>  	return (void *) error;
>  }
> @@ -60,7 +60,7 @@ static inline void * __must_check ERR_PT
>   * @ptr: An error pointer.
>   * Return: The error code within @ptr.
>   */
> -static inline long __must_check PTR_ERR(__force const void *ptr)
> +static __always_inline long __must_check PTR_ERR(__force const void *ptr)
>  {
>  	return (long) ptr;
>  }
> @@ -73,7 +73,7 @@ static inline long __must_check PTR_ERR(
>   * @ptr: The pointer to check.
>   * Return: true if @ptr is an error pointer, false otherwise.
>   */
> -static inline bool __must_check IS_ERR(__force const void *ptr)
> +static __always_inline bool __must_check IS_ERR(__force const void *ptr)
>  {
>  	return IS_ERR_VALUE((unsigned long)ptr);
>  }
> @@ -87,7 +87,7 @@ static inline bool __must_check IS_ERR(_
>   *
>   * Like IS_ERR(), but also returns true for a null pointer.
>   */
> -static inline bool __must_check IS_ERR_OR_NULL(__force const void *ptr)
> +static __always_inline bool __must_check IS_ERR_OR_NULL(__force const void *ptr)
>  {
>  	return unlikely(!ptr) || IS_ERR_VALUE((unsigned long)ptr);
>  }
> @@ -99,7 +99,7 @@ static inline bool __must_check IS_ERR_O
>   * Explicitly cast an error-valued pointer to another pointer type in such a
>   * way as to make it clear that's what's going on.
>   */
> -static inline void * __must_check ERR_CAST(__force const void *ptr)
> +static __always_inline void * __must_check ERR_CAST(__force const void *ptr)
>  {
>  	/* cast away the const */
>  	return (void *) ptr;
> @@ -122,7 +122,7 @@ static inline void * __must_check ERR_CA
>   *
>   * Return: The error code within @ptr if it is an error pointer; 0 otherwise.
>   */
> -static inline int __must_check PTR_ERR_OR_ZERO(__force const void *ptr)
> +static __always_inline int __must_check PTR_ERR_OR_ZERO(__force const void *ptr)
>  {
>  	if (IS_ERR(ptr))
>  		return PTR_ERR(ptr);

-- 
With Best Regards,
Andy Shevchenko


