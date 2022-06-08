Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4226DC433EF
	for <mm-commits@archiver.kernel.org>; Wed,  8 Jun 2022 19:00:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233625AbiFHS7z (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 8 Jun 2022 14:59:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233196AbiFHS7x (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 8 Jun 2022 14:59:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E47D3C73C
        for <mm-commits@vger.kernel.org>; Wed,  8 Jun 2022 11:59:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EB38B61C2E
        for <mm-commits@vger.kernel.org>; Wed,  8 Jun 2022 18:59:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E9B7C34116;
        Wed,  8 Jun 2022 18:59:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1654714773;
        bh=a+rNBS+qjDFo4tQH1PRM61MJwf6OXFJj3AvoKjC72G4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=w/12s+n58aQhyYQkpYrf7mOkMcO4liu0dJqbUOAMJhP104nWgpLZ0kKOHPm/Y5MRK
         DOS5U3z0tyESnDKVg4JXggB5Q6D87ohbW2dhj662dCT4Px09Zj9IMjA46kn3ZtC0Ws
         V1b3sEt3W8pVJ2u0hF0nEe0x5MXrO9HM6GWaGykc=
Date:   Wed, 8 Jun 2022 11:59:32 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     Matthew Wilcox <willy@infradead.org>
Cc:     mm-commits@vger.kernel.org, andriy.shevchenko@linux.intel.com
Subject: Re: + xarray-replace-kernelh-with-the-necessary-inclusions.patch
 added to mm-nonmm-unstable branch
Message-Id: <20220608115932.f1a5c3353eaee8778cc7a4e1@linux-foundation.org>
In-Reply-To: <YqDokVn0dSEbfSLE@casper.infradead.org>
References: <20220603183231.15159C385A9@smtp.kernel.org>
        <YppWoUnSxCUljVpS@casper.infradead.org>
        <20220603114712.da849292ea89f5c956967c54@linux-foundation.org>
        <YppXmagvcR7Cioug@casper.infradead.org>
        <20220603124205.28b5d1b1ab3e91568faa1022@linux-foundation.org>
        <YqDokVn0dSEbfSLE@casper.infradead.org>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Wed, 8 Jun 2022 19:21:05 +0100 Matthew Wilcox <willy@infradead.org> wrote:

> > Perhaps some magic happened with cpp's recognition of include guards?
> 
> I had some time to look at this now.  It's picking up
> /usr/include/linux/limits.h on my machine which is provided by
> linux-libc-dev.  That's a rather different set of constants from the ones
> the kernel provides internally, which might cause problems later.  But I'm
> not in a mood to go poking around the different locations that different
> environments provide things in, so I think this patch is OK.

Thanks.

I don't think it's good to be replacing our limits.h with some random
system-provided one.  I'll drop the patch.

