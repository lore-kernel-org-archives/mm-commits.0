Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7AAE0C433EF
	for <mm-commits@archiver.kernel.org>; Thu,  9 Jun 2022 17:29:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239064AbiFIR3H (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 9 Jun 2022 13:29:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239081AbiFIR3G (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 9 Jun 2022 13:29:06 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61138122971
        for <mm-commits@vger.kernel.org>; Thu,  9 Jun 2022 10:29:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 31E6DCE3067
        for <mm-commits@vger.kernel.org>; Thu,  9 Jun 2022 17:28:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D00EC3411F
        for <mm-commits@vger.kernel.org>; Thu,  9 Jun 2022 17:28:57 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="Y5Fr3wlV"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1654795734;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ydBJR/Ct5hnzG3jcnmSRmCA1PkkEhwCFb+H0OW1nuSA=;
        b=Y5Fr3wlVW/AG8sMSWwQLvERrkLmXZIE27fQoChBngv+kHXz+l5WDIy1j0KnHXlqpKjBOmp
        9PvnN5HIedcK18oRxlOGzCsPliQ6uc4zX6j5dsO45D7vRmZVqDkhlYIlhLZy2zg50j8ul/
        mVtQqyt2AREp7Ey7hjf79/DBiSEgwY0=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id d91fba2c (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO)
        for <mm-commits@vger.kernel.org>;
        Thu, 9 Jun 2022 17:28:54 +0000 (UTC)
Received: by mail-yb1-f176.google.com with SMTP id r3so8766047ybr.6
        for <mm-commits@vger.kernel.org>; Thu, 09 Jun 2022 10:28:53 -0700 (PDT)
X-Gm-Message-State: AOAM532M1XxxhU7CrUpWph/bmV6/VkwlGUc6QaQ0MPWWzle3yBY7+ITz
        EmbRcY9lpXCXSRf1XxTNIRfKejJ7VIbimxfii1s=
X-Google-Smtp-Source: ABdhPJw263L9DvTjEYSvAJw5wPhEXsoFyMtcvDt7Xav9ZLhlLIuJsMy00b1lkVYZVduZy010tajdKEunrdmZ0R9zArQ=
X-Received: by 2002:a5b:dcf:0:b0:64a:6923:bbba with SMTP id
 t15-20020a5b0dcf000000b0064a6923bbbamr43244058ybr.398.1654795732866; Thu, 09
 Jun 2022 10:28:52 -0700 (PDT)
MIME-Version: 1.0
References: <20220609165640.E538EC34114@smtp.kernel.org> <CAHmME9pgWOU1wg2s5r99DowFgKYHYn=uYPjOLzHf6HEWOcsqgw@mail.gmail.com>
 <20220609101738.393ace428296b78106525c13@linux-foundation.org>
In-Reply-To: <20220609101738.393ace428296b78106525c13@linux-foundation.org>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Thu, 9 Jun 2022 19:28:41 +0200
X-Gmail-Original-Message-ID: <CAHmME9qXXScRxrKv13NRbXwwfg49qkUx5ju_++ZLWNyEF4wBGQ@mail.gmail.com>
Message-ID: <CAHmME9qXXScRxrKv13NRbXwwfg49qkUx5ju_++ZLWNyEF4wBGQ@mail.gmail.com>
Subject: Re: + mm-kfence-select-random-number-before-taking-raw-lock.patch
 added to mm-unstable branch
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     mm-commits@vger.kernel.org, Petr Mladek <pmladek@suse.com>,
        John Ogness <john.ogness@linutronix.de>,
        Alexander Potapenko <glider@google.com>,
        geert+renesas@glider.be, Geert Uytterhoeven <geert@linux-m68k.org>,
        Marco Elver <elver@google.com>,
        Dmitry Vyukov <dvyukov@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

Hi Andrew,

On Thu, Jun 9, 2022 at 7:17 PM Andrew Morton <akpm@linux-foundation.org> wrote:
>
> On Thu, 9 Jun 2022 19:02:55 +0200 "Jason A. Donenfeld" <Jason@zx2c4.com> wrote:
>
> > Hi Andrew,
> >
> > On Thu, Jun 9, 2022 at 6:56 PM Andrew Morton <akpm@linux-foundation.org> wrote:
> > >      Subject: mm/kfence: select random number before taking raw lock
> > > has been added to the -mm mm-unstable branch.
> >
> > I believe this belongs in the hotfixes branch, actually. It's a
> > regression in 5.19.
> >
>
> Oh, OK.  Do we have a Fixes: tag?

Errr, I guess so technically.

Fixes: d4150779e60f ("random32: use real rng for non-deterministic randomness")

Jason
