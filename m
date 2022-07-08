Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E23E9C433EF
	for <mm-commits@archiver.kernel.org>; Fri,  8 Jul 2022 00:59:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236675AbiGHA7Z (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 7 Jul 2022 20:59:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236431AbiGHA7Y (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 7 Jul 2022 20:59:24 -0400
Received: from mail-ua1-x934.google.com (mail-ua1-x934.google.com [IPv6:2607:f8b0:4864:20::934])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB245183A3
        for <mm-commits@vger.kernel.org>; Thu,  7 Jul 2022 17:59:23 -0700 (PDT)
Received: by mail-ua1-x934.google.com with SMTP id y19so4383593ual.12
        for <mm-commits@vger.kernel.org>; Thu, 07 Jul 2022 17:59:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=2iYdoaPsI9CHf/LKhPtig+5mghaiYkch5HiqoZBTg7g=;
        b=LeCrk8+umADERgZSiLxcsgTVyf+Gvqv6fL6UqFnkVhTBnuG5TmJrhQl70X3TNfVtDe
         lK3bdUO+8zk8ZtAgDbHBZr3iJSlXKSJpRwqJCc/8bR7NO2OU/JEO4V+njTWYWCztrxaJ
         YY5XUITQ2yeOEfaj8UGMmj/i0mjvPogAqB8EdFlYXH47uk0exKl5Io1IX9HgJ7fK4fK/
         UIDgFClIiKGmDXLQdVhOglM2tBT1NL4JBGI4YnXYqtmjdPMxprT8+PswOPBrOz/qD6mR
         x8AncqXj4yjKETbG2tDGGVmJgjYe91mIxxtMUJQcDJf20IWSeQSVvfmbv+xtBYpO1KiK
         FlHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=2iYdoaPsI9CHf/LKhPtig+5mghaiYkch5HiqoZBTg7g=;
        b=PWXk0rLM4YphflT2v5YVXG71hSDNqfGptTsB/vcTbEG+Vggn8bG5FJ00d230Z48Hj4
         rqhY37xx7QePQhA9g5N6bH3MDalxIyw7Gp1AAoJDIOog7gVj8FIg0uPFTIbT1iY88li4
         P6Gu4UDTQF6RMw4zFWd3xmgk2Cjicxk1AhGNmc6T5xj98XPPo3apdingabFcUsJasy44
         GvgeeeTfO8lAz066bq6S0QtwjRFv5ZJaGE58CPsxx8ebMvVdgmSP4WmQ1Oh4i3L3YtgJ
         oRDraoX7skn/gjacNBEcqH21wxQvGpkA7J+SyiOqoW+hTh81m9eJLe1A9RFi4xHCPMeL
         Na9Q==
X-Gm-Message-State: AJIora+ZARbUUcccaZJvnbboB8fLYDB8lJ0VXGnYFtIFzV8qBrxiJmWM
        i5R7XrrE4zS0uQmw6XHAx1HI7b8P1cslfT5Jc5Wbbg==
X-Google-Smtp-Source: AGRyM1uIxD5lxuXaKg2VmSEAWpT7xZ4brIeqDe1f2NfBZIzIrCS+1bcNN+wnHwvFnP37Q6iBLsWC7AuQEQjK6Hm4Nbw=
X-Received: by 2002:ab0:3f0b:0:b0:37f:7238:a90c with SMTP id
 bt11-20020ab03f0b000000b0037f7238a90cmr318268uab.11.1657241962933; Thu, 07
 Jul 2022 17:59:22 -0700 (PDT)
MIME-Version: 1.0
References: <20220707200919.90C41C3411E@smtp.kernel.org> <fc7101bb-b9b9-4444-1d8b-4a28ce13f333@suse.cz>
 <CAOUHufZEwtvOhKQZqBp7Lg41eC9tK7hyL_UOUb2RdLKva8U02g@mail.gmail.com>
 <44ae6dd9-c290-ae4a-15e8-593a9cb587ad@suse.cz> <2030965f-5f68-c5ea-80a0-34be503de47f@google.com>
 <CAOUHufZXmSfM78+uLhifozOQacbZX0xM9fjc52Bw5zi+nm8FgQ@mail.gmail.com> <20220707175202.19c28f0f711f025c1dc233b6@linux-foundation.org>
In-Reply-To: <20220707175202.19c28f0f711f025c1dc233b6@linux-foundation.org>
From:   Yu Zhao <yuzhao@google.com>
Date:   Thu, 7 Jul 2022 18:58:46 -0600
Message-ID: <CAOUHufa7SuKCZXKeLUkGFTohaoVcLvmpjXED-Wk1iam9BAY3XA@mail.gmail.com>
Subject: Re: + mm-page_alloc-protect-pcp-lists-with-a-spinlock-fix.patch added
 to mm-unstable branch
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     Hugh Dickins <hughd@google.com>, Vlastimil Babka <vbabka@suse.cz>,
        mm-commits@vger.kernel.org,
        Nicolas Saenz Julienne <nsaenzju@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Minchan Kim <minchan@kernel.org>,
        Michal Hocko <mhocko@kernel.org>,
        Mel Gorman <mgorman@techsingularity.net>,
        kernel test robot <lkp@intel.com>, dan.carpenter@oracle.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Thu, Jul 7, 2022 at 6:52 PM Andrew Morton <akpm@linux-foundation.org> wrote:
>
> On Thu, 7 Jul 2022 18:35:12 -0600 Yu Zhao <yuzhao@google.com> wrote:
>
> > > This relentless drive towards mm-stable: I for one cannot keep up.
> > > I'd like to ask for slowing down a bit - my intention had been to
> > > reach testing maple tree again (it's not yet what I'd call stable),
> > > but this and a couple of other issues got in the way.  More mails
> > > to write.
> >
> > Sorry for not being clear (it doesn't seem confusing to me because I
> > don't trust the bot):
> >
> > There were two reports, the first one [1] tested v4 without the fix
> > [2]; the second one [3] tested v5 at patch 5/7 (not the whole series).
> >
> > v4 + the fix is good; v5 the whole series is good.
> >
> > Please do not drop patch 7/7 and do not add this fix.
>
> As Vlastimil has sleuthed out that the
> "BUG:sleeping_function_called_from_invalid_context_at_mm/gup.c"
> reporter was using the v4 series, I've restored 7/7 ("mm/page_alloc:
> replace local_lock with normal spinlock") for tomorrow's linux-next.

Yes, the bot initially tried v4 without the fix and reported the
problem. And Oliver manually tried again under the impression he had
the fix [1]. But that's the real fix [2]; it's just a cleanup.

[1] https://lore.kernel.org/r/YsRB3fZHAfik0M%2Fq@xsang-OptiPlex-9020/
[2] https://lore.kernel.org/r/20220615160446.be1f75fd256d67e57b27a9fc@linux-foundation.org/

> I retained this fix against 2/7 and reworked 7/7 appropriately.  So it
> is now

Awesome.
