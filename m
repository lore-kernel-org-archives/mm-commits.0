Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45F3353C3CC
	for <mm-commits@vger.kernel.org>; Tue, 13 Oct 2026 19:17:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791919077; cv=none; b=Llz/JmQ/6vdqhgyHuhhpyy9W49Hgl0FcjP39xot1Rzu8ZP0gznCRrCa0yaBRxwOyHVAdJO/WqYs7xCZZ07suVGmSa/mYkXQ9SXkv1AdwykP7p62cZGSjbssFk0aliLtvCX8ilOGtaEIVN+K9b3lnQ2t2CkZr04u7M1tt78Ukoio=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791919077; c=relaxed/simple;
	bh=qHyTz6RuPakAqc/Zebd8QJuZhnOZIORZp6jNItBdjyY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ddPgwNHlwDipav5La91umPAacxxPzK0byM7Rjuj539f50C5AON1b+ZyDjIkkUqCpogn3rjpVm92RjE8cQEbh7xtCJpQ8Cs4TAg3/TOlutjf6XosRFap7y2qmqnuKAIRZJiHVgKIaLZSBdzT8xNKyrE9DS6LHOau3E8wTiktbNbk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=jf/Fu/RG; arc=none smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="jf/Fu/RG"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1791919075; x=1823455075;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=qHyTz6RuPakAqc/Zebd8QJuZhnOZIORZp6jNItBdjyY=;
  b=jf/Fu/RGtkSjR10hxzPgJ90469VDA6eItoGzflLfWL6LfUBRCO/Xkv5d
   aJ1LKESLbGwzrpv2nxn6+WjfV+RLpoFc3IRCDNyFtNcbRp1Q4X31mNM6a
   XBaxR0rVZbfeVS8XoyscScI3MCLg5lk9u6cNROy5uKSCuJ68HYKuEX1NK
   Beq7a70gZ+inYqzrn2PbHcPH5yDy8AgdjZdf/yPZcN7DxlYFN06VlcnRV
   bDLv8bla3hLfdYOJ6jmvfhvqZ/ahiMhIxKEHYV7o3L7uF/gAuvcFFHhru
   QMTMIzDFM6qLu/IP53/EgBP18gl48ylRUVrL1AQWJld/EIKUrM7GDjhza
   g==;
X-CSE-ConnectionGUID: spR6/IYFQyybMT4gpvd5sg==
X-CSE-MsgGUID: eNOCgFD8QvqSPhExaB7eMw==
X-IronPort-AV: E=McAfee;i="6800,10657,11934"; a="552723"
X-IronPort-AV: E=Sophos;i="6.27,156,1787036400"; 
   d="scan'208";a="552723"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Oct 2026 12:17:54 -0700
X-CSE-ConnectionGUID: XPPkE58CSPSGca/wORSTDA==
X-CSE-MsgGUID: Y8vNwj7ZTISc9kFK+ZEsnQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,156,1787036400"; 
   d="scan'208";a="1319076"
Received: from ncintean-mobl1.ger.corp.intel.com (HELO localhost) ([10.245.245.48])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Oct 2026 12:17:53 -0700
Date: Tue, 13 Oct 2026 22:17:46 +0300
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: mm-commits@vger.kernel.org
Subject: Re: [merged mm-nonmm-stable]
 resource-kunit-stop-selecting-get_free_region.patch removed from -mm tree
Message-ID: <as6D2iE5F0RVcbXa@ashevche-desk.local>
References: <20261011222005.847FB1F0089C@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261011222005.847FB1F0089C@smtp.kernel.org>
Organization: Intel Finland Oy - BIC 0357606-4 - c/o Alberga Business Park, 6
 krs, Bertel Jungin Aukio 5, 02600 Espoo

On Sun, Oct 11, 2026 at 03:20:05PM -0700, Andrew Morton wrote:

...

> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> Reviewed-by: Bradley Morgan <brads@mainlining.org>
> Tested-by: Bradley Morgan <brads@mainlining.org> # Power10
> Assisted-by: LLM

I'm wondering if it will be a big deal to you to add to your scripts something
that will emit a '---' line here (before Cc list). This will reduce a lot of
noise in the commit messages, especially when the Cc list is hypothetically 20
lines while commit message hypothetically only 3. Note, that emails will be still
send as usual (in case you use some kind of `git send-email` or `b4`.

> Cc: Ying Huang <huang.ying.caritas@gmail.com>
> Cc: Geert Uytterhoeven <geert@linux-m68k.org>
> Cc: Brendan Higgins <brendan.higgins@linux.dev>
> Cc: David Gow <david@davidgow.net>
> Cc: Rae Moar <raemoar63@gmail.com>
> Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> 
> ---

-- 
With Best Regards,
Andy Shevchenko


