Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68137C43334
	for <mm-commits@archiver.kernel.org>; Fri,  3 Jun 2022 18:49:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347876AbiFCStB (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Jun 2022 14:49:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348733AbiFCStB (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 3 Jun 2022 14:49:01 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E2DF27FDE
        for <mm-commits@vger.kernel.org>; Fri,  3 Jun 2022 11:48:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=YzreMqgxFpeaTz2h4uc255X03Xv4qwS+ZcZSN3L6/P4=; b=Sv59bEdfmMUGP5Bh0IKSWglXR0
        ra9IkQkgSmj/MT+5jGPbQLU44mx6jP0hiuiuhQzdU0VdmoAtXXLyEBSC96R931VVkBGbAMTy+fUHe
        3ETShy6idpAwkSa+XxPRSM1kILBNJrPq0MQMGdAqm2nMq7yaRlaXsbH0fC8F2jK0oQYgc+C3morm/
        D/zY6Rcn38kAfub+fas94x8MxzDhGScHdvIBWdeV0PUzg2uPrjQXR1aqoO+5SsqLTVftrQ5i9UT79
        yePg/vLGT+juESqaC+HTa/J0pGKysOQb/81MlakMh4a6VyBqLDhl8nw8SmqdGvqhlURlzHaBtsihR
        BA3prZgg==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nxCLx-0085Cp-S8; Fri, 03 Jun 2022 18:48:57 +0000
Date:   Fri, 3 Jun 2022 19:48:57 +0100
From:   Matthew Wilcox <willy@infradead.org>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     mm-commits@vger.kernel.org, andriy.shevchenko@linux.intel.com
Subject: Re: + xarray-replace-kernelh-with-the-necessary-inclusions.patch
 added to mm-nonmm-unstable branch
Message-ID: <YppXmagvcR7Cioug@casper.infradead.org>
References: <20220603183231.15159C385A9@smtp.kernel.org>
 <YppWoUnSxCUljVpS@casper.infradead.org>
 <20220603114712.da849292ea89f5c956967c54@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220603114712.da849292ea89f5c956967c54@linux-foundation.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Fri, Jun 03, 2022 at 11:47:12AM -0700, Andrew Morton wrote:
> On Fri, 3 Jun 2022 19:44:49 +0100 Matthew Wilcox <willy@infradead.org> wrote:
> 
> > On Fri, Jun 03, 2022 at 11:32:30AM -0700, Andrew Morton wrote:
> > > ------------------------------------------------------
> > > From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> > > Subject: include/linux/xarray.h: replace kernel.h with the necessary inclusions
> > > Date: Fri, 3 Jun 2022 20:11:53 +0300
> > > 
> > > When kernel.h is used in the headers it adds a lot into dependency hell,
> > > especially when there are circular dependencies are involved.
> > > 
> > > Replace kernel.h inclusion with the list of what is really being used.
> > > 
> > > Link: https://lkml.kernel.org/r/20220603171153.48928-1-andriy.shevchenko@linux.intel.com
> > > Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> > > Cc: Matthew Wilcox <willy@infradead.org>
> > > Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> > 
> > NAK, breaks the test suite.
> 
> The test suite compiled OK for me?

I don't see a limits.h in tools/ ?
