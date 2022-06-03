Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B76C0C43334
	for <mm-commits@archiver.kernel.org>; Fri,  3 Jun 2022 19:42:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243751AbiFCTmK (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Jun 2022 15:42:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243277AbiFCTmJ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 3 Jun 2022 15:42:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90EC811470
        for <mm-commits@vger.kernel.org>; Fri,  3 Jun 2022 12:42:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 28A05619F3
        for <mm-commits@vger.kernel.org>; Fri,  3 Jun 2022 19:42:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60FD9C385A9;
        Fri,  3 Jun 2022 19:42:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1654285326;
        bh=X8D60mTYO1O1uqpeTZju2P3RKSJIgh0BEdYb6S8r56U=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=TotTbn7ccmvcpwM0jcxalJrNrDZK+orqinkhA0wqkdY4xPEKjsPwhglqe8Vadjw2x
         HvwBuT6S/rOY1tPHJtbsO0iZHWLMwv+7D8H245nAoO1I9y/C2vjqkauBMyqYUWDtnH
         fPLv6lacToB2viUJipy2RvO+pRbhAPNtaeXsr0MA=
Date:   Fri, 3 Jun 2022 12:42:05 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     Matthew Wilcox <willy@infradead.org>
Cc:     mm-commits@vger.kernel.org, andriy.shevchenko@linux.intel.com
Subject: Re: + xarray-replace-kernelh-with-the-necessary-inclusions.patch
 added to mm-nonmm-unstable branch
Message-Id: <20220603124205.28b5d1b1ab3e91568faa1022@linux-foundation.org>
In-Reply-To: <YppXmagvcR7Cioug@casper.infradead.org>
References: <20220603183231.15159C385A9@smtp.kernel.org>
        <YppWoUnSxCUljVpS@casper.infradead.org>
        <20220603114712.da849292ea89f5c956967c54@linux-foundation.org>
        <YppXmagvcR7Cioug@casper.infradead.org>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Fri, 3 Jun 2022 19:48:57 +0100 Matthew Wilcox <willy@infradead.org> wrote:

> On Fri, Jun 03, 2022 at 11:47:12AM -0700, Andrew Morton wrote:
> > On Fri, 3 Jun 2022 19:44:49 +0100 Matthew Wilcox <willy@infradead.org> wrote:
> > 
> > > On Fri, Jun 03, 2022 at 11:32:30AM -0700, Andrew Morton wrote:
> > > > ------------------------------------------------------
> > > > From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> > > > Subject: include/linux/xarray.h: replace kernel.h with the necessary inclusions
> > > > Date: Fri, 3 Jun 2022 20:11:53 +0300
> > > > 
> > > > When kernel.h is used in the headers it adds a lot into dependency hell,
> > > > especially when there are circular dependencies are involved.
> > > > 
> > > > Replace kernel.h inclusion with the list of what is really being used.
> > > > 
> > > > Link: https://lkml.kernel.org/r/20220603171153.48928-1-andriy.shevchenko@linux.intel.com
> > > > Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> > > > Cc: Matthew Wilcox <willy@infradead.org>
> > > > Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> > > 
> > > NAK, breaks the test suite.
> > 
> > The test suite compiled OK for me?
> 
> I don't see a limits.h in tools/ ?

It works, but I'm not sure why.

cc -H says:

.... ./linux/xarray.h
..... ./generated/map-shift.h
..... ./linux/../../../../include/linux/xarray.h
...... ../../include/linux/bitmap.h
....... ../../include/linux/find.h
...... ./linux/bug.h
....... ../../include/asm/bug.h
...... ./linux/kconfig.h
....... ./linux/../../../../include/linux/kconfig.h
........ ./generated/autoconf.h
.... ./linux/local_lock.h
. ../../../lib/xarray.c
.. ../../include/linux/export.h
.. ../../include/linux/slab.h
.. ./linux/xarray.h

xarray.h has

#include <linux/bitmap.h>
#include <linux/bug.h>
#include <linux/compiler.h>
#include <linux/err.h>
#include <linux/gfp.h>
#include <linux/kconfig.h>
#include <linux/limits.h>
#include <linux/lockdep.h>
#include <linux/math.h>
#include <linux/rcupdate.h>
#include <linux/spinlock.h>
#include <linux/types.h>

Perhaps some magic happened with cpp's recognition of include guards?
