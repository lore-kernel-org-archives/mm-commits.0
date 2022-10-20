Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0BBE3C433FE
	for <mm-commits@archiver.kernel.org>; Thu, 20 Oct 2022 21:13:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229588AbiJTVNF (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 20 Oct 2022 17:13:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229552AbiJTVNE (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 20 Oct 2022 17:13:04 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 019DC21CD72
        for <mm-commits@vger.kernel.org>; Thu, 20 Oct 2022 14:13:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8D283B82928
        for <mm-commits@vger.kernel.org>; Thu, 20 Oct 2022 21:13:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE0B1C433C1;
        Thu, 20 Oct 2022 21:12:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1666300379;
        bh=Gaw88xe20iRX6yhK9e8fel3xwansbTa/ElQ2asuLv0g=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=tCNiUSXeBcknekiTDQ+3l80X8Fwm5rmjEYjBt1454qOorNuYZwsv29Jek+RfH/x+j
         jo83M7XTMCVlt7TtUwggji83RJ3aeZJsmJ8LdpSlkg88PkYQPneBY8EFXKvO2Tpj58
         E3sYkpXyf/GVkap4z7YeBM8380Zr35DLQnG5E3NY=
Date:   Thu, 20 Oct 2022 14:12:58 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     mm-commits@vger.kernel.org, torvalds@linux-foundation.org,
        masahiroy@kernel.org, keescook@chromium.org,
        gregkh@linuxfoundation.org, andriy.shevchenko@linux.intel.com
Subject: Re: + kbuild-treat-char-as-always-unsigned.patch added to
 mm-nonmm-unstable branch
Message-Id: <20221020141258.e80e605508d2adaf08ede9d2@linux-foundation.org>
In-Reply-To: <CAHmME9oGZMN14qnbyGBGDp2EQg7y1rR8yYVuAtAyn2cjFC6NwQ@mail.gmail.com>
References: <20221020000356.177CDC433C1@smtp.kernel.org>
        <CAHmME9oGZMN14qnbyGBGDp2EQg7y1rR8yYVuAtAyn2cjFC6NwQ@mail.gmail.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Thu, 20 Oct 2022 10:24:51 -0600 "Jason A. Donenfeld" <Jason@zx2c4.com> wrote:

> Hi Andrew,
> 
> On Wed, Oct 19, 2022 at 6:03 PM Andrew Morton <akpm@linux-foundation.org> wrote:
> > The patch titled
> >      Subject: kbuild: treat char as always unsigned
> > has been added to the -mm mm-nonmm-unstable branch.  Its filename is
> >      kbuild-treat-char-as-always-unsigned.patch
> >
> > This patch will shortly appear at
> >      https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kbuild-treat-char-as-always-unsigned.patch
> >
> > This patch will later appear in the mm-nonmm-unstable branch at
> >     git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
> 
> Looks like you missed this email -
> https://lore.kernel.org/lkml/Y1CP%2FuJb1SQjyS0n@zx2c4.com/

I saw that email after I'd merged it.

> didn't communicate about your intention to take this. Kind of
> annoying, but oh well. Either way, I'll drop it from my tree, so that
> -next has a clear path with it. Just please don't drop it from your
> tree without appropriate discussion first. As mentioned in the thread,
> there inevitably will be a few dragons with this patch, and the whole
> idea of putting this in -next a whopping 4.5 months before 6.2 is
> released is so that we can actually have time to chip away at those
> issues as they come up. So please don't drop this at the very first
> sign of trouble; just plan for some trouble.

No, please go ahead and merge it in your tree (I didn't actually know
you ran a tree).  Once it appears in -next, Stephen will tell us and
I'll drop my copy.  This happens fairly commonly.


