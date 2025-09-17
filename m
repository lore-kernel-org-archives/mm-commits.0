Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07BFD1C07C3
	for <mm-commits@vger.kernel.org>; Wed, 17 Sep 2025 08:14:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758096893; cv=none; b=Li+IgMndEKVLWif8Urc2KTIM31WBQ0oeZzmd9ZLutPCWd05E2RiA1L+c47LzTPcuO0h69X3dw2lNZ3o2Ud/xhdo3+4LO0/uckx0zAAsroGJMTI3CvA2ucjGgixdYb7Hsz4s8YBcqKGeCCMdbrjVKGsKxVhw9cIX6Ay7KfEuOjd4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758096893; c=relaxed/simple;
	bh=cJ+1fSy41vePjvLQAYrTWohCgbsDhvPbTa9NifdB7b0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BCmomfJ1qUsUJ4J2ih/SAvop28wV4oG0k8PNK5oZyBVCO48SnZ061r9HJCiWvkEHn5JPJybRevNIDz75KUTm6MjZU4ELgUYIauzEspvkqN9lKvicXndH3ys5UyY7cMF+C6UttBK37rJnQtxcz3nqM588uUYgpfhKvE028lS78No=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=mQz31tVf; arc=none smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="mQz31tVf"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1758096892; x=1789632892;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=cJ+1fSy41vePjvLQAYrTWohCgbsDhvPbTa9NifdB7b0=;
  b=mQz31tVfuM9EAg4vvl1zCP7lr8hQ9YzwaHW0MTgLNpPTqjL6qSTxbNVg
   qK/vrwwYB90WID1NaWz+6jcOvRGuw99bkW/6tR7PMTzG21DF95+F1+Ejb
   mAw1tfmmF1k6a2o25hYjpjRCy8lJcbYDJ0MTxov1kUl7HXliHcJL8sp2r
   DV2hDEV7aKw2q8ZrlfJo8b8/xVcliVElN1ckwlfsPgRg820PLEXh92tOx
   qRVbiLcSrcEfmlK0efuFaRTbNJcTdWhio82TDTy6+23/vEXMG1Vbl2RJc
   ALKoDOzc1D9Z5AvJGNZ0YiA7VhQwzSHgwW9jAHWcQW9Vrd7O8gNiLG+gc
   Q==;
X-CSE-ConnectionGUID: riavlAbSSWO1UmpySiYtaA==
X-CSE-MsgGUID: nfIba7KnS6asIFOd/Avu6Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11531"; a="60343093"
X-IronPort-AV: E=Sophos;i="6.17,312,1747724400"; 
   d="scan'208";a="60343093"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Sep 2025 01:14:51 -0700
X-CSE-ConnectionGUID: rHN3yPYdQq+oe/R0CQQfbg==
X-CSE-MsgGUID: kEWBd+GaTrWq1j0BN2ny+g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,271,1751266800"; 
   d="scan'208";a="179184612"
Received: from smile.fi.intel.com ([10.237.72.51])
  by orviesa003.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Sep 2025 01:14:48 -0700
Received: from andy by smile.fi.intel.com with local (Exim 4.98.2)
	(envelope-from <andriy.shevchenko@linux.intel.com>)
	id 1uynJN-00000003kVF-092y;
	Wed, 17 Sep 2025 11:14:45 +0300
Date: Wed, 17 Sep 2025 11:14:44 +0300
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: mm-commits@vger.kernel.org, yan.y.zhao@intel.com, pmladek@suse.com,
	nathan@kernel.org, mpdesouza@suse.com, morbo@google.com,
	mario.limonciello@amd.com, justinstitt@google.com,
	jbouron@amazon.com, gunnarku@amazon.com, graf@amazon.com,
	bhe@redhat.com
Subject: Re: +
 kexec_core-remove-superfluous-page-offset-handling-in-segment-loading-fix.patch
 added to mm-nonmm-unstable branch
Message-ID: <aMpt9MEqS2jkyUnY@smile.fi.intel.com>
References: <20250917014237.3A9A7C4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250917014237.3A9A7C4CEEB@smtp.kernel.org>
Organization: Intel Finland Oy - BIC 0357606-4 - c/o Alberga Business Park, 6
 krs, Bertel Jungin Aukio 5, 02600 Espoo

On Tue, Sep 16, 2025 at 06:42:36PM -0700, Andrew Morton wrote:
> 
> The patch titled
>      Subject: kexec: remove unused code in kimage_load_cma_segment()
> has been added to the -mm mm-nonmm-unstable branch.  Its filename is
>      kexec_core-remove-superfluous-page-offset-handling-in-segment-loading-fix.patch
> 
> This patch will shortly appear at
>      https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kexec_core-remove-superfluous-page-offset-handling-in-segment-loading-fix.patch
> 
> This patch will later appear in the mm-nonmm-unstable branch at
>     git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
> 
> Before you just go and hit "reply", please:
>    a) Consider who else should be cc'ed
>    b) Prefer to cc a suitable mailing list as well
>    c) Ideally: find the original patch on the mailing list and do a
>       reply-to-all to that, adding suitable additional cc's

Thanks for taking this!
I;m just wonder if you can also take this one
https://lore.kernel.org/r/20250904225010.1804783-1-dan.j.williams@intel.com
Yeah, it wasn't Cc'ed to you.

-- 
With Best Regards,
Andy Shevchenko


