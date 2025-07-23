Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C34CF2F5489;
	Wed, 23 Jul 2025 15:29:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753284601; cv=none; b=DcVlbpsEMQUKevgD5PT6NDoeS7g5HH1HsLtp0AeZChv/q08oFZe6yhpNoFeYjv7ZhOlfa3RhfVz7DCFGfnnJEzi5sfAFg8o+ih9ESoQkPKEA998Ka6mlHPzqslM01Ev75BSlZ2TLqH+ASu/WAmRXvQy+GWsSQVBO+zzQLpsGYVI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753284601; c=relaxed/simple;
	bh=ZuSatsKI4Rx94XwYYxkfMq6Qhs4pQX2KC5850F7oxqA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OtcE6dlj7Si7YveAW8W8pG2MsAp0po4d2J4/3sBhvzahb+8y69z6yULfFhky8xpwmsNt4OzOP6lq7tHNhlnELlnNclqTaOBLZYOMI1JEj66sv+MQFbNZ8RBfkV5XNzMDyfMFsQP5asV6XCGpbZHcyOI6EuHMz0Dj6sIGXkaUm+M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=IzC83CWb; arc=none smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="IzC83CWb"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1753284600; x=1784820600;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=ZuSatsKI4Rx94XwYYxkfMq6Qhs4pQX2KC5850F7oxqA=;
  b=IzC83CWbHjp6fWuOikPF/N2w5pqk1ScOfuv7zXBto420LvwiYy6yGJ+2
   xe2Aj88kdtLVihuSY41v7przkokoM+1CvKSE7m/+XdKUi88JNYU3S5Vbq
   1+A1f34xqD+gsqJhSXVpPcyYOIjx+4ymtHkays9Qt2VT7wlaaDUo2yGrw
   rT8IFdSa2BmGEqEYvfEHWIB1+tskMirqpfbPzu6+ErJzR34UfBMAlqIGl
   fn/MZaAt6CxQvQ0LDtjb1lKkqE9ZOddyA7iY6GHS2ShFtnIBX1CO+xg6j
   El2AEUQJhwLt7/BXwWJI6Qb15C5HYqWbNA1h7Nc/rsiUcDhXoulUfq8T0
   g==;
X-CSE-ConnectionGUID: bKLGpR/3RmaDPmFu1GIJGw==
X-CSE-MsgGUID: BNX4dwnBTXinxaC8qb/rNA==
X-IronPort-AV: E=McAfee;i="6800,10657,11501"; a="55278128"
X-IronPort-AV: E=Sophos;i="6.16,333,1744095600"; 
   d="scan'208";a="55278128"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jul 2025 08:29:41 -0700
X-CSE-ConnectionGUID: pXyfxTAcSAGDtanLRNiTFg==
X-CSE-MsgGUID: wDW645APReOQL84DRNbFxg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,333,1744095600"; 
   d="scan'208";a="163824350"
Received: from smile.fi.intel.com ([10.237.72.52])
  by fmviesa005.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jul 2025 08:29:38 -0700
Received: from andy by smile.fi.intel.com with local (Exim 4.98.2)
	(envelope-from <andriy.shevchenko@linux.intel.com>)
	id 1uebPT-00000000KIF-0htP;
	Wed, 23 Jul 2025 18:29:35 +0300
Date: Wed, 23 Jul 2025 18:29:34 +0300
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: mm-commits@vger.kernel.org, stable@vger.kernel.org,
	senozhatsky@chromium.org, rostedt@goodmis.org, pmladek@suse.com,
	linux@rasmusvillemoes.dk, herbert@gondor.apana.org.au,
	sfr@canb.auug.org.au
Subject: Re: + sprintfh-requires-stdargh.patch added to mm-hotfixes-unstable
 branch
Message-ID: <aID_3hHxWXd1LC5F@smile.fi.intel.com>
References: <20250721211353.41334C4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250721211353.41334C4CEED@smtp.kernel.org>
Organization: Intel Finland Oy - BIC 0357606-4 - c/o Alberga Business Park, 6
 krs, Bertel Jungin Aukio 5, 02600 Espoo

On Mon, Jul 21, 2025 at 02:13:52PM -0700, Andrew Morton wrote:

> ------------------------------------------------------
> From: Stephen Rothwell <sfr@canb.auug.org.au>
> Subject: sprintf.h requires stdarg.h
> Date: Mon, 21 Jul 2025 16:15:57 +1000
> 
> In file included from drivers/crypto/intel/qat/qat_common/adf_pm_dbgfs_utils.c:4:
> include/linux/sprintf.h:11:54: error: unknown type name 'va_list'
>    11 | __printf(2, 0) int vsprintf(char *buf, const char *, va_list);
>       |                                                      ^~~~~~~
> include/linux/sprintf.h:1:1: note: 'va_list' is defined in header '<stdarg.h>'; this is probably fixable by adding '#include <stdarg.h>'

...

>  #include <linux/compiler_attributes.h>
>  #include <linux/types.h>
> +#include <linux/stdarg.h>

Can we prevent the ordering?

-- 
With Best Regards,
Andy Shevchenko


