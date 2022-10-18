Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AEEBFC4332F
	for <mm-commits@archiver.kernel.org>; Tue, 18 Oct 2022 12:27:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230077AbiJRM1t (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 18 Oct 2022 08:27:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229698AbiJRM1s (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 18 Oct 2022 08:27:48 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1C51B7F48
        for <mm-commits@vger.kernel.org>; Tue, 18 Oct 2022 05:27:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1666096067; x=1697632067;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=++PczzFxVdnu/rt6Q8e6I8tzTORra3OTwB00bewnRuw=;
  b=QMXmjHPGaPWWV7EMLQmoCZYth6E1NFn+/iH1DROJLa7uwKh1mrFdbw3m
   xPNBFGPxUp/X5OOUfCZllRsEp25YJ8HonATzGd2Lut+VnO0RPjcuWHlpT
   S+x9B+iM7ylusS1Zi4+GdY7E5FRazNOkuBEc5gMTwmbGMAYy0Bb427J+K
   LcCVlW3QLQ0OsC13PV4JywaKPCj/87oAIK/vBTJQURGi+Q2ATb39i+z69
   n5Vq9djxaNPQaoVipui9tHDURMwD5x7dq0RDgJ6+dt+c4jsFzXxfTdxsv
   3bku2lP8WiRuuKUcryetx+trm3+08yHOr1FfvLOFqYlIoH4ttwxGXaD4K
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10503"; a="370286730"
X-IronPort-AV: E=Sophos;i="5.95,193,1661842800"; 
   d="scan'208";a="370286730"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Oct 2022 05:27:47 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10503"; a="873871702"
X-IronPort-AV: E=Sophos;i="5.95,193,1661842800"; 
   d="scan'208";a="873871702"
Received: from smile.fi.intel.com ([10.237.72.54])
  by fmsmga006.fm.intel.com with ESMTP; 18 Oct 2022 05:27:45 -0700
Received: from andy by smile.fi.intel.com with local (Exim 4.96)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1oklh9-009M3P-38;
        Tue, 18 Oct 2022 15:27:43 +0300
Date:   Tue, 18 Oct 2022 15:27:43 +0300
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     mm-commits@vger.kernel.org, keescook@chromium.org, Jason@zx2c4.com
Subject: Re: +
 minmax-sanity-check-constant-bounds-when-clamping-checkpatch-fixes.patch
 added to mm-nonmm-unstable branch
Message-ID: <Y06bv9ZKBUXkI35x@smile.fi.intel.com>
References: <20221018011800.3857BC433C1@smtp.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221018011800.3857BC433C1@smtp.kernel.org>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Mon, Oct 17, 2022 at 06:17:59PM -0700, Andrew Morton wrote:

...

> -#define __clamp(val, lo, hi)							\
> +#define __clamp(val, lo, hi)	\
>  	__cmp(__cmp(val, lo, >), hi, <)
>  
> -#define __clamp_once(val, lo, hi, unique_val, unique_lo, unique_hi) ({		\
> -		typeof(val) unique_val = (val);					\
> -		typeof(lo) unique_lo = (lo);					\
> -		typeof(hi) unique_hi = (hi);					\
> +#define __clamp_once(val, lo, hi, unique_val, unique_lo, unique_hi) ({	\
> +		typeof(val) unique_val = (val);				\
> +		typeof(lo) unique_lo = (lo);				\
> +		typeof(hi) unique_hi = (hi);				\
>  		__clamp(unique_val, unique_lo, unique_hi); })
>  
> -#define __clamp_input_check(lo, hi)						\
> -        (BUILD_BUG_ON_ZERO(__builtin_choose_expr(				\
> +#define __clamp_input_check(lo, hi)					\
> +        (BUILD_BUG_ON_ZERO(__builtin_choose_expr(			\
>                  __is_constexpr((lo) > (hi)), (lo) > (hi), false)))

These are good...

> -#define __careful_clamp(val, lo, hi) ({						\
> -	__clamp_input_check(lo, hi) + 						\
> -	__builtin_choose_expr(__typecheck(val, lo) && __typecheck(val, hi) &&	\
> -			      __typecheck(hi, lo) && __is_constexpr(val) && 	\
> -			      __is_constexpr(lo) && __is_constexpr(hi),		\
> -		__clamp(val, lo, hi),						\
> -		__clamp_once(val, lo, hi, __UNIQUE_ID(__val),			\
> +#define __careful_clamp(val, lo, hi) ({					\
> +	__clamp_input_check(lo, hi) +					\
> +	__builtin_choose_expr(__typecheck(val, lo) && __typecheck(val, hi) &&\
> +			      __typecheck(hi, lo) && __is_constexpr(val) &&\
> +			      __is_constexpr(lo) && __is_constexpr(hi),	\
> +		__clamp(val, lo, hi),					\
> +		__clamp_once(val, lo, hi, __UNIQUE_ID(__val),		\
>  			     __UNIQUE_ID(__lo), __UNIQUE_ID(__hi))); })

...but this one becomes less readable. I think checkpatch is always a
recommendation than requirement. I would leave at least the last as is, but
formally I think the entire patch is a churn to satisfy controversial
recommendation.

-- 
With Best Regards,
Andy Shevchenko


