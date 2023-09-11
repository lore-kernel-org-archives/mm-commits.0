Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 884F9CA0EC3
	for <mm-commits@archiver.kernel.org>; Tue, 12 Sep 2023 02:14:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234671AbjILCOW (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 11 Sep 2023 22:14:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236412AbjILCOL (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 11 Sep 2023 22:14:11 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 270904E22A
        for <mm-commits@vger.kernel.org>; Mon, 11 Sep 2023 15:26:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1694471213; x=1726007213;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=ZqHnCjnY4GuZY/IAhV0xNkztUDIIcoowEAHP6m/ipaU=;
  b=cAU7NZAP2hfaJDsokdmWmCSVcG4elS5qwOFT+2ODXeOJV2l0EXGI8+Ua
   K5aVo4KN43XCcVLj1+465YxPLHRqyn1gW5w/UxBBcuMP/tFLyEjWj+SrL
   cGOP9dkDFQujbuzls8ovW2eEX21enatHCIcmIbxrKhhRhfpGemN09CUnw
   UMYMv0WRUFBR2bSVeqyfhDhLTXmZObfsL8ZponltSdPU4Yz4PQS1PZqs0
   FuPO0FICfJZaryMeJzcenjRVmyqKw3FWtxHrZ0Lh0XXEfHOYMwyJF0pzB
   u/38a68a5q+eEdX+GnRNVXKKtbWRfp7KPnmMj6jJ1yW+r3wpT4jEVSxAc
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10830"; a="380921452"
X-IronPort-AV: E=Sophos;i="6.02,244,1688454000"; 
   d="scan'208";a="380921452"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Sep 2023 15:23:16 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10830"; a="813562994"
X-IronPort-AV: E=Sophos;i="6.02,244,1688454000"; 
   d="scan'208";a="813562994"
Received: from smile.fi.intel.com ([10.237.72.54])
  by fmsmga004.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Sep 2023 15:23:14 -0700
Received: from andy by smile.fi.intel.com with local (Exim 4.96)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1qfpJI-008R9f-0x;
        Tue, 12 Sep 2023 01:23:12 +0300
Date:   Tue, 12 Sep 2023 01:23:12 +0300
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     mm-commits@vger.kernel.org, herve.codina@bootlin.com
Subject: Re: + minmax-deduplicate-__unconst_integer_typeof.patch added to
 mm-nonmm-unstable branch
Message-ID: <ZP+TUDTPpsJbdaio@smile.fi.intel.com>
References: <20230911182556.ED7D7C433C7@smtp.kernel.org>
 <ZP+K/zh7zVATnrTE@smile.fi.intel.com>
 <20230911145956.7b36e463d16583cede78b2b6@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230911145956.7b36e463d16583cede78b2b6@linux-foundation.org>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Mon, Sep 11, 2023 at 02:59:56PM -0700, Andrew Morton wrote:
> On Tue, 12 Sep 2023 00:47:43 +0300 Andy Shevchenko <andriy.shevchenko@linux.intel.com> wrote:

...

> > > -/*
> > >   * Do not check the array parameter using __must_be_array().
> > >   * In the following legit use-case where the "array" passed is a simple pointer,
> > >   * __must_be_array() will return a failure.
> > 
> > A side note: If you look at the original email and patch you will see a subtle
> > difference that makes patch better looking. It's because I started using
> > --patience when formatting them. Perhaps you can enable it in your scripts.
> 
> Interesting, thanks.
> 
> I use plain old diff :(.  A while back I had everything working (I
> thought) using `git diff' instead but found that it was producing diffs that
> gave git-quiltimport a heart attack.  Ran out of time, didn't debug,
> disabled it.  I'll revisit at some point.

Ah, I see. I don't know good implementation of patience diff outside of
the Git, not sure then if you can enable it easily.

-- 
With Best Regards,
Andy Shevchenko


