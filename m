Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4F75C43219
	for <mm-commits@archiver.kernel.org>; Thu, 20 Oct 2022 22:46:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230143AbiJTWql (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 20 Oct 2022 18:46:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229894AbiJTWqb (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 20 Oct 2022 18:46:31 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E52D9164BD6;
        Thu, 20 Oct 2022 15:46:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2162EB821C7;
        Thu, 20 Oct 2022 22:46:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD6EFC433D6;
        Thu, 20 Oct 2022 22:46:25 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="AILrQt0B"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1666305983;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=bW21QW3lsybJpbLWWG+fLJUAamVkFsJreOYqtoP32IU=;
        b=AILrQt0BuZWta+vQbL0pfBAe4R0Mx11zmVNFwJidURlA7Qjy7lTlGKnhTu0F+c1LZm8IjW
        uk5f707N0Suk2CBYUfqr/k0pMr9QMaP9ifp2d1BEuatOgZu2UbkMopY2wqxzGkbqgvG6tD
        sojNkk+Iz84EGWdD60DtXMeEcBKPevE=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id ca4689d4 (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
        Thu, 20 Oct 2022 22:46:21 +0000 (UTC)
Date:   Thu, 20 Oct 2022 16:46:01 -0600
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Kees Cook <keescook@chromium.org>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        mm-commits@vger.kernel.org, masahiroy@kernel.org,
        gregkh@linuxfoundation.org, Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [PATCH -mm] -funsigned-char, x86: make struct
 p4_event_bind::cntr signed array
Message-ID: <Y1HPqdBbv83VqCvp@zx2c4.com>
References: <20221020000356.177CDC433C1@smtp.kernel.org>
 <Y1EZuQcO8UoN91cX@localhost.localdomain>
 <CAHmME9prEhkHqQmtDGCSFunNnxiKdE_8FHKiksyqebUN63U81Q@mail.gmail.com>
 <CAHk-=whFow9Wd6C8htoRUt5wXbwf1i_qbuArBbhXOPqYsTFvtw@mail.gmail.com>
 <CAHmME9qBZqTd0D_gr8nE+DUzCrC0fxZNZK=7u+21jbgtFgAJBg@mail.gmail.com>
 <CAHk-=wjZDC9o8iwF+bU91Hx40HjGOpMui+VoFCDJkaGCu=rG4A@mail.gmail.com>
 <202210201151.ECC19BC97A@keescook>
 <CAHk-=wgdXRZy0-3v+vLZdDfRFKFXZLehgmR2QUKSemBA99sfmg@mail.gmail.com>
 <CAHk-=wjvp=ys2adnWwc1PNt3OrZ_0EkFaUcvjiVuOoVNjX_+AA@mail.gmail.com>
 <Y1G+7e7l5dpHhCyP@smile.fi.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Y1G+7e7l5dpHhCyP@smile.fi.intel.com>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Fri, Oct 21, 2022 at 12:34:37AM +0300, Andy Shevchenko wrote:
> On Thu, Oct 20, 2022 at 01:17:33PM -0700, Linus Torvalds wrote:
> > On Thu, Oct 20, 2022 at 12:39 PM Linus Torvalds
> > <torvalds@linux-foundation.org> wrote:
> 
> ...
> 
> > And in some cases the differences are enormous:
> > 
> >  - drivers/net/wireless/ralink/rt2x00/rt2800lib.c generates a 220kB diff
> > 
> > which seems to be due to entirely different inlining decisions or
> > something, and the differences are so enormous that I didn't even
> > start looking at the cause.
> 
> This one is what we start the epopee from. I think Jason handled it in his last
> patch against this certain driver.

Right, and Kale is taking it for 6.1, because it fixes existing breakage
on ARM. But it's not broken on x86 with -funsigned-char.

Jason
