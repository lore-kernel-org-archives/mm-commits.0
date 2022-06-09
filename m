Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0FBE0C43334
	for <mm-commits@archiver.kernel.org>; Thu,  9 Jun 2022 16:02:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237194AbiFIQCi (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 9 Jun 2022 12:02:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231679AbiFIQCh (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 9 Jun 2022 12:02:37 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A95EA33EA9
        for <mm-commits@vger.kernel.org>; Thu,  9 Jun 2022 09:02:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1654790556; x=1686326556;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=dde3YtrmwcD0TxgSyt6/xvc2t4Nz6hN7c7JbOBgP7c8=;
  b=nELSZrzrCNGQm3of4F/nSFIQk7czck8UyQu7GRwyE7nkHsTVPtN7ls/+
   uwvbuaO+RWa5EMbICeYC2g99OcajczqgNLACXqeXschWv6eYxdTHADWGX
   cFtaDCmcqgmFAdshOpv/cP/9ow8bDAQ29d+0pzRmoUpqwQSUnF7706uIE
   LZ+vJtZ0wJBgR1wRA2kWpBt0w1FoEp2GpPs5H01ykNl99sM6gPAKqp9qg
   iajGy0/qxYM868MytTSAk7JagsxCP42zgS2oV1kIglvTrnxFSrxrzt9aV
   IT3yDaKpkTc/HQn7ECkxbunrtkjuvvJoSOL4Kp+btlthyltl0VxTL0Ent
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10373"; a="341403760"
X-IronPort-AV: E=Sophos;i="5.91,287,1647327600"; 
   d="scan'208";a="341403760"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jun 2022 09:01:50 -0700
X-IronPort-AV: E=Sophos;i="5.91,287,1647327600"; 
   d="scan'208";a="649335653"
Received: from smile.fi.intel.com ([10.237.72.54])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jun 2022 09:01:46 -0700
Received: from andy by smile.fi.intel.com with local (Exim 4.95)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1nzKbP-000Y1c-5Z;
        Thu, 09 Jun 2022 19:01:43 +0300
Date:   Thu, 9 Jun 2022 19:01:42 +0300
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     Matthew Wilcox <willy@infradead.org>, mm-commits@vger.kernel.org
Subject: Re: + xarray-replace-kernelh-with-the-necessary-inclusions.patch
 added to mm-nonmm-unstable branch
Message-ID: <YqIZZj0+D/2VE8Bb@smile.fi.intel.com>
References: <20220603183231.15159C385A9@smtp.kernel.org>
 <YppWoUnSxCUljVpS@casper.infradead.org>
 <20220603114712.da849292ea89f5c956967c54@linux-foundation.org>
 <YppXmagvcR7Cioug@casper.infradead.org>
 <20220603124205.28b5d1b1ab3e91568faa1022@linux-foundation.org>
 <YqDokVn0dSEbfSLE@casper.infradead.org>
 <20220608115932.f1a5c3353eaee8778cc7a4e1@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220608115932.f1a5c3353eaee8778cc7a4e1@linux-foundation.org>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Wed, Jun 08, 2022 at 11:59:32AM -0700, Andrew Morton wrote:
> On Wed, 8 Jun 2022 19:21:05 +0100 Matthew Wilcox <willy@infradead.org> wrote:
> 
> > > Perhaps some magic happened with cpp's recognition of include guards?
> > 
> > I had some time to look at this now.  It's picking up
> > /usr/include/linux/limits.h on my machine which is provided by
> > linux-libc-dev.  That's a rather different set of constants from the ones
> > the kernel provides internally, which might cause problems later.  But I'm
> > not in a mood to go poking around the different locations that different
> > environments provide things in, so I think this patch is OK.
> 
> Thanks.
> 
> I don't think it's good to be replacing our limits.h with some random
> system-provided one.  I'll drop the patch.

It's fine. Perhaps we will add a limits.h to the tools. I have to remember this
somewhere.

Thanks, Matthew, for the investigation and finding a root cause.

-- 
With Best Regards,
Andy Shevchenko


