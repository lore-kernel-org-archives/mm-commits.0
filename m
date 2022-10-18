Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 377CBC4332F
	for <mm-commits@archiver.kernel.org>; Tue, 18 Oct 2022 14:29:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229657AbiJRO3e (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 18 Oct 2022 10:29:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231467AbiJRO33 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 18 Oct 2022 10:29:29 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B539BDF73
        for <mm-commits@vger.kernel.org>; Tue, 18 Oct 2022 07:29:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1666103365; x=1697639365;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=uVR5F6YAwNqvqMC+2HyyTVN+iMEK6/blQaNJBJ/ZdEQ=;
  b=b569aJDnTFzKRQMs8pS/k7FocFjfG1LOl4MF8CqSMJolEt3597eSJeZ/
   3j7f37HGlgN8MDLEUAbfAONrnAqCKCZLYn8tmtUPoKTxCH1Vuddgz95Iq
   25kP5/vreRy2v9xa89QUUCjI4oNhIB9k24o1V2MfkZk31aeBrb9p3m4nm
   aCcr+jBvyLF8YmoIV8xp2HdjoYwkGxsG+TFbw1fPyf5RLjU1wnCCB5goB
   1jF33VknqCgIz+yvE8Kn8wlysYqx+YWPHkdDxHadDR7UWHm/DSB2/3UAl
   wXVQHjW1dtTTAlBXRFGn82Q4QSlXyOOQCm8Xmj7c3lqGKOsAA2zYFdfn2
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10504"; a="332664524"
X-IronPort-AV: E=Sophos;i="5.95,193,1661842800"; 
   d="scan'208";a="332664524"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Oct 2022 07:29:13 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10504"; a="957797404"
X-IronPort-AV: E=Sophos;i="5.95,193,1661842800"; 
   d="scan'208";a="957797404"
Received: from smile.fi.intel.com ([10.237.72.54])
  by fmsmga005.fm.intel.com with ESMTP; 18 Oct 2022 07:29:12 -0700
Received: from andy by smile.fi.intel.com with local (Exim 4.96)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1oknag-009QAu-2w;
        Tue, 18 Oct 2022 17:29:10 +0300
Date:   Tue, 18 Oct 2022 17:29:10 +0300
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     mm-commits@vger.kernel.org, keescook@chromium.org, Jason@zx2c4.com
Subject: Re: +
 minmax-sanity-check-constant-bounds-when-clamping-checkpatch-fixes.patch
 added to mm-nonmm-unstable branch
Message-ID: <Y064NuczHx/QEmm/@smile.fi.intel.com>
References: <20221018011800.3857BC433C1@smtp.kernel.org>
 <Y06bv9ZKBUXkI35x@smile.fi.intel.com>
 <20221018071547.b22698983af2a2e43d7ba76b@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221018071547.b22698983af2a2e43d7ba76b@linux-foundation.org>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Tue, Oct 18, 2022 at 07:15:47AM -0700, Andrew Morton wrote:
> On Tue, 18 Oct 2022 15:27:43 +0300 Andy Shevchenko <andriy.shevchenko@linux.intel.com> wrote:
> 
> > On Mon, Oct 17, 2022 at 06:17:59PM -0700, Andrew Morton wrote:

...

> > > +	__builtin_choose_expr(__typecheck(val, lo) && __typecheck(val, hi) &&\
> > > +			      __typecheck(hi, lo) && __is_constexpr(val) &&\
> > > +			      __is_constexpr(lo) && __is_constexpr(hi),	\
> > > +		__clamp(val, lo, hi),					\
> > > +		__clamp_once(val, lo, hi, __UNIQUE_ID(__val),		\
> > >  			     __UNIQUE_ID(__lo), __UNIQUE_ID(__hi))); })
> > 
> > ...but this one becomes less readable. I think checkpatch is always a
> > recommendation than requirement. I would leave at least the last as is, but
> > formally I think the entire patch is a churn to satisfy controversial
> > recommendation.
> 
> This wasn't really a checkpatch thing.  I looked at the code in an
> 80-col window and nearly died.  It wasn't *necessary* to make it look
> so bad in 80 cols, so why do it?

That's exactly my point, the parts ' &&\' in the proposed patch looks not good
to me.

-- 
With Best Regards,
Andy Shevchenko


