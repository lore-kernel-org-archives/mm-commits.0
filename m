Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2D68CA0EC8
	for <mm-commits@archiver.kernel.org>; Tue, 12 Sep 2023 02:51:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240618AbjILCvx (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 11 Sep 2023 22:51:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240870AbjILCvl (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 11 Sep 2023 22:51:41 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC06922600
        for <mm-commits@vger.kernel.org>; Mon, 11 Sep 2023 14:50:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1694469056; x=1726005056;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=3GVIbrX+4/hTCqSuiP+FMdmjmP3fJLVPX99xGSaNHt0=;
  b=GYsUPlhGSm8PxKseQwN3hexZcKuJO3hSvPYsu5+0v25nG3fzCumy0mPb
   qpx/kv1clHrkEi9hDOfvyR9+Sf3rEctLSLsj5GbiqBy0P2LzzCV0Oc1cd
   3DsGIT/UluoSOHcRpijC+akuOPbvmtpeyHVdgIWlbsGYAXbaWbquFxTTw
   5hROGn+/dJt65AVr/Yjpw/CMTUB8k4It3XOZhCpdjYnGxHbleF+Lawcy4
   9LusrJzoifkTKPQO+ANsuxjxPu9nKA+I3LqLev5B5KFCpygtgk4C1J9nK
   KFwqEF1HzLoHDaxS0J3Z3fpecLO1o06p+KL70Ug1ZKzLyhSBtf8SwV58f
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10830"; a="377129554"
X-IronPort-AV: E=Sophos;i="6.02,244,1688454000"; 
   d="scan'208";a="377129554"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Sep 2023 14:47:47 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10830"; a="772743562"
X-IronPort-AV: E=Sophos;i="6.02,244,1688454000"; 
   d="scan'208";a="772743562"
Received: from smile.fi.intel.com ([10.237.72.54])
  by orsmga008.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Sep 2023 14:47:46 -0700
Received: from andy by smile.fi.intel.com with local (Exim 4.96)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1qfokx-008Qnc-2v;
        Tue, 12 Sep 2023 00:47:43 +0300
Date:   Tue, 12 Sep 2023 00:47:43 +0300
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     mm-commits@vger.kernel.org, herve.codina@bootlin.com
Subject: Re: + minmax-deduplicate-__unconst_integer_typeof.patch added to
 mm-nonmm-unstable branch
Message-ID: <ZP+K/zh7zVATnrTE@smile.fi.intel.com>
References: <20230911182556.ED7D7C433C7@smtp.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230911182556.ED7D7C433C7@smtp.kernel.org>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Mon, Sep 11, 2023 at 11:25:56AM -0700, Andrew Morton wrote:
> 
> The patch titled
>      Subject: minmax: deduplicate __unconst_integer_typeof()
> has been added to the -mm mm-nonmm-unstable branch.  Its filename is
>      minmax-deduplicate-__unconst_integer_typeof.patch
> 
> This patch will shortly appear at
>      https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/minmax-deduplicate-__unconst_integer_typeof.patch
> 
> This patch will later appear in the mm-nonmm-unstable branch at
>     git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
> 
> Before you just go and hit "reply", please:
>    a) Consider who else should be cc'ed
>    b) Prefer to cc a suitable mailing list as well
>    c) Ideally: find the original patch on the mailing list and do a
>       reply-to-all to that, adding suitable additional cc's
> 
> *** Remember to use Documentation/process/submit-checklist.rst when testing your code ***
> 
> The -mm tree is included into linux-next via the mm-everything
> branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
> and is updated there every 2-3 working days

...

>  /*

> -/*
>   * Do not check the array parameter using __must_be_array().
>   * In the following legit use-case where the "array" passed is a simple pointer,
>   * __must_be_array() will return a failure.

A side note: If you look at the original email and patch you will see a subtle
difference that makes patch better looking. It's because I started using
--patience when formatting them. Perhaps you can enable it in your scripts.

-- 
With Best Regards,
Andy Shevchenko


