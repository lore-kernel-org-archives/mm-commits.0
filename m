Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4612928540F;
	Thu, 24 Jul 2025 11:43:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753357393; cv=none; b=F3MonqdKxwF2qQk7BxRj6dE1JwPN2RwdqtK119vSTfSP1TlmpgJyFhTW9jgA6r3qNBMXtj2A7prKi4q6VbdWKII23dLPE69HeMyb2Qu1g5LdpW5eYmX43xlQ21gxx5W/Pnzo/GGwIZu4l303WYE8dhX4LKYdFg7DH7tQRqZjkGI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753357393; c=relaxed/simple;
	bh=Pvohvv1QHNzbejr5xmkd8GWHpndcwCkqruwu46mGWeo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZJg6rsEd6265HVOCT86v0SGwKd2PrGYZFUyW0bBt+gMVnYEklR2VSD9h5oW2gInue5Yr7IBndjcYMdEzm43lt/z8PV8+p4ZTiT/vX+vHeM+LujMOKNoRaxppGPGHvzlysvhKpTY5n61o0EmRTSuzlQoVJjd0hNdfPPofyw2E7po=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=bC+DkLpM; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="bC+DkLpM"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1753357391; x=1784893391;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=Pvohvv1QHNzbejr5xmkd8GWHpndcwCkqruwu46mGWeo=;
  b=bC+DkLpMvKqevmyTAk5tF2zosCj9dgHdO+F6gtQruiiu1SyHNJy7qf2+
   t4svz5l/RNFMC4CZSr0wHLl7Mztdn8aPPHfEJG2+pBPKz09GpwYep7WZs
   sI9IMusjmRtBEEBEew3lXD/O8F3imdTvqtDyqYnhGQ/0NjJMdrZQtaMSo
   4Es5FQGCk4ARJqa/GceyQlUFGfcjcIAFhET5B53nMmQAqupsGd3DGSQxr
   S0GIseDKS5OuMLIBDmrW0swmnczbEfc3MT/m69cCfe9UD5MOqobBnx1qf
   wsDEQbewPEbdLkwL7D+VEl96/PKbjBFAAetC19Zj5xwhbZ9QvMTi/bziR
   Q==;
X-CSE-ConnectionGUID: qBQ9NxfVQQ6H7+H1aCsSKQ==
X-CSE-MsgGUID: uviYnItdRDOE0ssqTkSXjg==
X-IronPort-AV: E=McAfee;i="6800,10657,11501"; a="66232552"
X-IronPort-AV: E=Sophos;i="6.16,337,1744095600"; 
   d="scan'208";a="66232552"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jul 2025 04:43:10 -0700
X-CSE-ConnectionGUID: +5uwzGTPTb6k3cREUtTLwA==
X-CSE-MsgGUID: R+PPhbiITqSm4xwCaipkAw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,337,1744095600"; 
   d="scan'208";a="164377079"
Received: from smile.fi.intel.com ([10.237.72.52])
  by orviesa003.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jul 2025 04:42:22 -0700
Received: from andy by smile.fi.intel.com with local (Exim 4.98.2)
	(envelope-from <andriy.shevchenko@linux.intel.com>)
	id 1ueuL4-00000000Ycf-3K7p;
	Thu, 24 Jul 2025 14:42:18 +0300
Date: Thu, 24 Jul 2025 14:42:18 +0300
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Andrew Morton <akpm@linux-foundation.org>, mm-commits@vger.kernel.org,
	stable@vger.kernel.org, senozhatsky@chromium.org,
	rostedt@goodmis.org, pmladek@suse.com, linux@rasmusvillemoes.dk,
	herbert@gondor.apana.org.au
Subject: Re: + sprintfh-requires-stdargh.patch added to mm-hotfixes-unstable
 branch
Message-ID: <aIIcGulQp7MOsYtP@smile.fi.intel.com>
References: <20250721211353.41334C4CEED@smtp.kernel.org>
 <aID_3hHxWXd1LC5F@smile.fi.intel.com>
 <20250724084012.5d7bbc47@canb.auug.org.au>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250724084012.5d7bbc47@canb.auug.org.au>
Organization: Intel Finland Oy - BIC 0357606-4 - c/o Alberga Business Park, 6
 krs, Bertel Jungin Aukio 5, 02600 Espoo

On Thu, Jul 24, 2025 at 08:40:12AM +1000, Stephen Rothwell wrote:
> On Wed, 23 Jul 2025 18:29:34 +0300 Andy Shevchenko <andriy.shevchenko@linux.intel.com> wrote:
> > On Mon, Jul 21, 2025 at 02:13:52PM -0700, Andrew Morton wrote:
> > 
> > > ------------------------------------------------------
> > > From: Stephen Rothwell <sfr@canb.auug.org.au>
> > > Subject: sprintf.h requires stdarg.h
> > > Date: Mon, 21 Jul 2025 16:15:57 +1000
> > > 
> > > In file included from drivers/crypto/intel/qat/qat_common/adf_pm_dbgfs_utils.c:4:
> > > include/linux/sprintf.h:11:54: error: unknown type name 'va_list'
> > >    11 | __printf(2, 0) int vsprintf(char *buf, const char *, va_list);
> > >       |                                                      ^~~~~~~
> > > include/linux/sprintf.h:1:1: note: 'va_list' is defined in header '<stdarg.h>'; this is probably fixable by adding '#include <stdarg.h>'  

...

> > >  #include <linux/compiler_attributes.h>
> > >  #include <linux/types.h>
> > > +#include <linux/stdarg.h>  
> > 
> > Can we prevent the ordering?
> 
> I am not sure what you mean by this.  Do you want alphabetical, reverse
> christmas tree, or something else?  Or are you concerned with something
> completely different?

Alphabetical

#include <linux/compiler_attributes.h>
#include <linux/stdarg.h>  
#include <linux/types.h>

-- 
With Best Regards,
Andy Shevchenko


