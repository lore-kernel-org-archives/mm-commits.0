Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0E9CCCA480
	for <mm-commits@archiver.kernel.org>; Wed,  8 Jun 2022 18:21:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234197AbiFHSVM (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 8 Jun 2022 14:21:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234177AbiFHSVL (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 8 Jun 2022 14:21:11 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77E661C116
        for <mm-commits@vger.kernel.org>; Wed,  8 Jun 2022 11:21:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=1I40ACbP6tuF9313ZLK8pV3uI2qjk5InqJhqgRWTk1U=; b=JGLGrnHqDT0U8XETlh9p7midl5
        rCXL3KzybtsFYkgzFJOAEOXC5nqpl6+4NyL0aYTlYPp1dAAp4yz89XofYI4pqN0wtdkw2GRou4+1g
        eTavz30PXE4BXJxaJ/BFJ0e/SESJj4LMvHjIuSkAXA04yjYd7+ctuhwwsLBWWdqx6NZuPmxaJH9yG
        Zxpe/ok9T18oxoIC4zPV6AG5es+vKPqnbSf0vgxBDnOXGrXKKPtTrtN4ZU+517jZrHAe+KamBqfaF
        6oQ0Bnhn+6IljVud9woX6O3NRxEfR1OScChEzct8qNj6Pl1/proJeegh9FvDtD4DkWy9XKSK21TUT
        kCvazXtg==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nz0Ij-00CrcT-Au; Wed, 08 Jun 2022 18:21:05 +0000
Date:   Wed, 8 Jun 2022 19:21:05 +0100
From:   Matthew Wilcox <willy@infradead.org>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     mm-commits@vger.kernel.org, andriy.shevchenko@linux.intel.com
Subject: Re: + xarray-replace-kernelh-with-the-necessary-inclusions.patch
 added to mm-nonmm-unstable branch
Message-ID: <YqDokVn0dSEbfSLE@casper.infradead.org>
References: <20220603183231.15159C385A9@smtp.kernel.org>
 <YppWoUnSxCUljVpS@casper.infradead.org>
 <20220603114712.da849292ea89f5c956967c54@linux-foundation.org>
 <YppXmagvcR7Cioug@casper.infradead.org>
 <20220603124205.28b5d1b1ab3e91568faa1022@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220603124205.28b5d1b1ab3e91568faa1022@linux-foundation.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Fri, Jun 03, 2022 at 12:42:05PM -0700, Andrew Morton wrote:
> On Fri, 3 Jun 2022 19:48:57 +0100 Matthew Wilcox <willy@infradead.org> wrote:
> 
> > On Fri, Jun 03, 2022 at 11:47:12AM -0700, Andrew Morton wrote:
> > > On Fri, 3 Jun 2022 19:44:49 +0100 Matthew Wilcox <willy@infradead.org> wrote:
> > > 
> > > > On Fri, Jun 03, 2022 at 11:32:30AM -0700, Andrew Morton wrote:
> > > > > ------------------------------------------------------
> > > > > From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> > > > > Subject: include/linux/xarray.h: replace kernel.h with the necessary inclusions
> > > > > Date: Fri, 3 Jun 2022 20:11:53 +0300
> > > > > 
> > > > > When kernel.h is used in the headers it adds a lot into dependency hell,
> > > > > especially when there are circular dependencies are involved.
> > > > > 
> > > > > Replace kernel.h inclusion with the list of what is really being used.
> > > > > 
> > > > > Link: https://lkml.kernel.org/r/20220603171153.48928-1-andriy.shevchenko@linux.intel.com
> > > > > Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> > > > > Cc: Matthew Wilcox <willy@infradead.org>
> > > > > Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> > > > 
> > > > NAK, breaks the test suite.
> > > 
> > > The test suite compiled OK for me?
> > 
> > I don't see a limits.h in tools/ ?
> 
> It works, but I'm not sure why.
> 
> cc -H says:
> 
> .... ./linux/xarray.h
> ..... ./generated/map-shift.h
> ..... ./linux/../../../../include/linux/xarray.h
> ...... ../../include/linux/bitmap.h
> ....... ../../include/linux/find.h
> ...... ./linux/bug.h
> ....... ../../include/asm/bug.h
> ...... ./linux/kconfig.h
> ....... ./linux/../../../../include/linux/kconfig.h
> ........ ./generated/autoconf.h
> .... ./linux/local_lock.h
> . ../../../lib/xarray.c
> .. ../../include/linux/export.h
> .. ../../include/linux/slab.h
> .. ./linux/xarray.h
> 
> xarray.h has
> 
> #include <linux/bitmap.h>
> #include <linux/bug.h>
> #include <linux/compiler.h>
> #include <linux/err.h>
> #include <linux/gfp.h>
> #include <linux/kconfig.h>
> #include <linux/limits.h>
> #include <linux/lockdep.h>
> #include <linux/math.h>
> #include <linux/rcupdate.h>
> #include <linux/spinlock.h>
> #include <linux/types.h>
> 
> Perhaps some magic happened with cpp's recognition of include guards?

I had some time to look at this now.  It's picking up
/usr/include/linux/limits.h on my machine which is provided by
linux-libc-dev.  That's a rather different set of constants from the ones
the kernel provides internally, which might cause problems later.  But I'm
not in a mood to go poking around the different locations that different
environments provide things in, so I think this patch is OK.
