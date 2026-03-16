Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03C413E3C48
	for <mm-commits@vger.kernel.org>; Mon, 16 Mar 2026 18:43:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773686632; cv=none; b=py14NlvcndiizemedBa+KN4EODCEvzAh4nHlI+8E9iR+zHVNPsPQblWPUC3v7EEe67dSl3NB8Xar2GRaXqDgHmZKzc5jQFSHjpVG7vkYqbrZqs/u2sibOgB2tacOtT1JBLLbt93I9kfKBpb9GlGymU+/06EYQ6dBrnMu85VOZ2I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773686632; c=relaxed/simple;
	bh=nYzkOww3Z5I1UO1LFtfHrI0Vb7v+nGziw2wWtlZrddE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hstH8bbTXJguWrx/sQ2SDtczfA7o9FQbN5BGzQwuiYgA73HDeFueNcTECRDj/IffGKf+5ahcqcOaBsSjEgeDIXmHSRiXS5wtY77pLWDVuMs+DVfLsAmUMd0wIfeLXZZakvZVbPI4UadBEme7KKO5vI/OKIE2+pi+6e2PVzbG6m8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=VmAZ/wYz; arc=none smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="VmAZ/wYz"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1773686631; x=1805222631;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=nYzkOww3Z5I1UO1LFtfHrI0Vb7v+nGziw2wWtlZrddE=;
  b=VmAZ/wYzbiEllVPkykBAQSGu4IvwQb5qMrCUQAHMCPqBQPdYeAOzdemP
   xe/1GySOCbZ5eAZi0Qs4FOrESiD9q6y/N9XtxweYIU7ZPCZ8H6Vw8CpLJ
   bWRjbHaH91oAfS5ksYUj7jMq0CJCaJOjocYOHuDCyDBenQTeqvlWiPkec
   +mdx4KB+NBo/S4WAIAwAW1xMMIuUmkzP3iek2fJQqucOH2O7AittKZ9dT
   y0/0PIP4NgIqDgZyTJnt+wkqU5nxi3Fc2uRwrdqQHSP1bc2PuRhBvvSS4
   HRuKk64l8u6kUbW1KnLMIix6U59AADcn2jyFl0m5baH92FVaELDG6y7FZ
   g==;
X-CSE-ConnectionGUID: 1FHzx8tXS3CUnx9wDzOFwQ==
X-CSE-MsgGUID: buKSitHUQRmH0VeV5uJJLg==
X-IronPort-AV: E=McAfee;i="6800,10657,11731"; a="74601446"
X-IronPort-AV: E=Sophos;i="6.23,124,1770624000"; 
   d="scan'208";a="74601446"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Mar 2026 11:43:50 -0700
X-CSE-ConnectionGUID: XZEAw4cOQLSZTtVAm8n8tg==
X-CSE-MsgGUID: S8wHI2akRKuuP66a1I0TCw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,124,1770624000"; 
   d="scan'208";a="218226402"
Received: from vpanait-mobl.ger.corp.intel.com (HELO localhost) ([10.245.244.237])
  by fmviesa010-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Mar 2026 11:43:48 -0700
Date: Mon, 16 Mar 2026 20:43:46 +0200
From: Andy Shevchenko <andriy.shevchenko@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: mm-commits@vger.kernel.org, neelnatu@google.com, kees@kernel.org,
	dmantipov@yandex.ru, djwong@kernel.org, shuvampandey1@gmail.com
Subject: Re: + lib-tests-extend-cmdline-kunit-with-next_arg-tests.patch added
 to mm-nonmm-unstable branch
Message-ID: <abhPYqSXicZ2d92c@ashevche-desk.local>
References: <20260316165530.3E248C19421@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260316165530.3E248C19421@smtp.kernel.org>
Organization: Intel Finland Oy - BIC 0357606-4 - c/o Alberga Business Park, 6
 krs, Bertel Jungin Aukio 5, 02600 Espoo

On Mon, Mar 16, 2026 at 09:55:29AM -0700, Andrew Morton wrote:

> +static void cmdline_test_next_arg_quoted_value(struct kunit *test)
> +{
> +	char in[] = "foo=\"bar baz\" qux=1";

Consider also adding cases for parameters like

	"bbb= jjj kkk=\"a=b\""


(perhaps in the same string).

> +	char *next, *param, *val;
> +
> +	next = next_arg(in, &param, &val);
> +	KUNIT_EXPECT_STREQ(test, param, "foo");
> +	KUNIT_ASSERT_NOT_NULL(test, val);
> +	KUNIT_EXPECT_STREQ(test, val, "bar baz");
> +	KUNIT_EXPECT_STREQ(test, next, "qux=1");
> +
> +	next = next_arg(next, &param, &val);
> +	KUNIT_EXPECT_STREQ(test, param, "qux");
> +	KUNIT_ASSERT_NOT_NULL(test, val);
> +	KUNIT_EXPECT_STREQ(test, val, "1");
> +	KUNIT_EXPECT_STREQ(test, next, "");
> +}

-- 
With Best Regards,
Andy Shevchenko


