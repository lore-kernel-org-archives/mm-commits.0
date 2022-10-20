Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 980D8C433FE
	for <mm-commits@archiver.kernel.org>; Thu, 20 Oct 2022 21:13:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229645AbiJTVNu (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 20 Oct 2022 17:13:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229552AbiJTVNt (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 20 Oct 2022 17:13:49 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF34A21CD71
        for <mm-commits@vger.kernel.org>; Thu, 20 Oct 2022 14:13:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 87D07B8283C
        for <mm-commits@vger.kernel.org>; Thu, 20 Oct 2022 21:13:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BF8CC433D6
        for <mm-commits@vger.kernel.org>; Thu, 20 Oct 2022 21:13:45 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="guZik7H1"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1666300424;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=qfRm8/QDLiWP3SVqA5FZBGT0eXOUchVPysmZMRXTdtk=;
        b=guZik7H14uzhOxrq34fr+bAvzVLW2Tfnp9VHgUNOhkYZkstvdWnYxUAI8S1qgxWyPLm58k
        yOQBZMnYKX+Xd68Alzred2F/qMOVUDIEV0+IgQyC3vpL7nx99BqzgD2L4l8EiYW3os3m9b
        G1krhvabVEdRkWS3/hsmXpHPCSjGR2c=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 49fb1a27 (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO)
        for <mm-commits@vger.kernel.org>;
        Thu, 20 Oct 2022 21:13:44 +0000 (UTC)
Received: by mail-vk1-f173.google.com with SMTP id h25so468271vkc.6
        for <mm-commits@vger.kernel.org>; Thu, 20 Oct 2022 14:13:43 -0700 (PDT)
X-Gm-Message-State: ACrzQf2vKZVLWtshxpu6YYgJyUIbKTloWokGc5GsPcF23OWq6YvqePUI
        zIkFgfJJvTxsKErkHgLUdiAte9b7Z/Puixoqjyc=
X-Google-Smtp-Source: AMsMyM6E03FeFm2dx1iCowHo0tqofzL0x1lt9+1yFvGdBTnNxJabMBiSYekZpayA+mA0cvjF0XxoN++MbErEopDdujQ=
X-Received: by 2002:a1f:7843:0:b0:3ab:9727:3f14 with SMTP id
 t64-20020a1f7843000000b003ab97273f14mr9139828vkc.3.1666300423049; Thu, 20 Oct
 2022 14:13:43 -0700 (PDT)
MIME-Version: 1.0
References: <20221020000356.177CDC433C1@smtp.kernel.org> <CAHmME9oGZMN14qnbyGBGDp2EQg7y1rR8yYVuAtAyn2cjFC6NwQ@mail.gmail.com>
 <20221020141258.e80e605508d2adaf08ede9d2@linux-foundation.org>
In-Reply-To: <20221020141258.e80e605508d2adaf08ede9d2@linux-foundation.org>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Thu, 20 Oct 2022 15:13:32 -0600
X-Gmail-Original-Message-ID: <CAHmME9qFK8hRUAbPiDLAfQOg=ewzYZH3W0O1diAD7ssR37ELmw@mail.gmail.com>
Message-ID: <CAHmME9qFK8hRUAbPiDLAfQOg=ewzYZH3W0O1diAD7ssR37ELmw@mail.gmail.com>
Subject: Re: + kbuild-treat-char-as-always-unsigned.patch added to
 mm-nonmm-unstable branch
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     mm-commits@vger.kernel.org, torvalds@linux-foundation.org,
        masahiroy@kernel.org, keescook@chromium.org,
        gregkh@linuxfoundation.org, andriy.shevchenko@linux.intel.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Thu, Oct 20, 2022 at 3:13 PM Andrew Morton <akpm@linux-foundation.org> wrote:
>
> On Thu, 20 Oct 2022 10:24:51 -0600 "Jason A. Donenfeld" <Jason@zx2c4.com> wrote:
>
> > Hi Andrew,
> >
> > On Wed, Oct 19, 2022 at 6:03 PM Andrew Morton <akpm@linux-foundation.org> wrote:
> > > The patch titled
> > >      Subject: kbuild: treat char as always unsigned
> > > has been added to the -mm mm-nonmm-unstable branch.  Its filename is
> > >      kbuild-treat-char-as-always-unsigned.patch
> > >
> > > This patch will shortly appear at
> > >      https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kbuild-treat-char-as-always-unsigned.patch
> > >
> > > This patch will later appear in the mm-nonmm-unstable branch at
> > >     git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
> >
> > Looks like you missed this email -
> > https://lore.kernel.org/lkml/Y1CP%2FuJb1SQjyS0n@zx2c4.com/
>
> I saw that email after I'd merged it.
>
> > didn't communicate about your intention to take this. Kind of
> > annoying, but oh well. Either way, I'll drop it from my tree, so that
> > -next has a clear path with it. Just please don't drop it from your
> > tree without appropriate discussion first. As mentioned in the thread,
> > there inevitably will be a few dragons with this patch, and the whole
> > idea of putting this in -next a whopping 4.5 months before 6.2 is
> > released is so that we can actually have time to chip away at those
> > issues as they come up. So please don't drop this at the very first
> > sign of trouble; just plan for some trouble.
>
> No, please go ahead and merge it in your tree (I didn't actually know
> you ran a tree).  Once it appears in -next, Stephen will tell us and
> I'll drop my copy.  This happens fairly commonly.

Okay, will do.

Jason
