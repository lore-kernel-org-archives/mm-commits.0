Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3DA5FC77B60
	for <mm-commits@archiver.kernel.org>; Fri, 28 Apr 2023 16:14:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229930AbjD1QOn (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 28 Apr 2023 12:14:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229868AbjD1QOm (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 28 Apr 2023 12:14:42 -0400
Received: from mail-yw1-x1136.google.com (mail-yw1-x1136.google.com [IPv6:2607:f8b0:4864:20::1136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAB5C5BBB
        for <mm-commits@vger.kernel.org>; Fri, 28 Apr 2023 09:14:25 -0700 (PDT)
Received: by mail-yw1-x1136.google.com with SMTP id 00721157ae682-54fe25c2765so604587b3.3
        for <mm-commits@vger.kernel.org>; Fri, 28 Apr 2023 09:14:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1682698465; x=1685290465;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=axDcQNZMvJsKHBiCAAzhuv582JF3voCqRrx5KkPxnoQ=;
        b=1qDtZ9jfsjlLRCkDplTL5k3lJjnHCf8Y/QvahkgPTrs9Dpn9f6eNSf/92sQW8S38Vg
         /WsulBhqIlAIYCnXG6fbQEFScQxLrMRvxGSIw7jyZIBWcHFxyaCve/nFQHIsAkptr+mK
         bfKcmSiUcl91blNx7C0+we0365FN3agRjFBAN3xIjwlD9yItC5Ya3IP20qSN1yVUN3Cy
         Xou+VCM29XuR/rzgVNa+pOpEDuDj4ZWtfgQkDSHLF5ItmMpdLBmUYre1El+T75OqosIu
         98zjbgNgftVVrZFRPtIN+i0E0SOy4BeDy3tmifAbo2OQBOOXo89KNpAXWm9/O9YHNszn
         qLEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682698465; x=1685290465;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=axDcQNZMvJsKHBiCAAzhuv582JF3voCqRrx5KkPxnoQ=;
        b=WwABrvltk5DiYEJsnQjZFgV7ktxkatgpmMHSO+WbilS+9T4tucCHfj8BkowexbU/Gw
         kowDq+XuN6nlCBiLb3QlCCmJdHGS5MI7NhncZ5L8WJMVUrYZ5IP7EaQK8LSlPjYdBzlG
         N26kdT25WfAqGu6tuvPs575r9k/KAAfA2nxFtVokii50GktRWRC7lvl2VTNGILt4II/U
         uiidXi4OdAEPGGSUilKRXF3let3N0khV5IfTmvMnsGXl2JF4ANuChHbEoqMKosAmMOJw
         MSycWajioIW/qFWkucbQ1GuExOis7Fsch0fuj0kisRvCVgMVTiEIsQpQ6xlo+/hEqJoJ
         Mr1g==
X-Gm-Message-State: AC+VfDxJDnyFLV9Qc0zSaQ42UkXeTlPe4bxYx/e6142iMnejRMRGyPy7
        v4/6iuZkiJmagEt4LyOiDLOB8L3z13HXUclSZfVJtg==
X-Google-Smtp-Source: ACHHUZ747uDADHs0471eSxm2y6tXS1WXzFvXRhTIIg40+BC7sxaY0BAgVlKoBTt4FUcRNqXswIzwGLLD7G+UfSPtzAk=
X-Received: by 2002:a81:87c4:0:b0:556:e3eb:de38 with SMTP id
 x187-20020a8187c4000000b00556e3ebde38mr4406863ywf.0.1682698464703; Fri, 28
 Apr 2023 09:14:24 -0700 (PDT)
MIME-Version: 1.0
References: <20230427153345.451d86681f9c6775ea579e5a@linux-foundation.org>
 <CAHk-=wi5=LfeCMv5ZPAtzWhJyW=y1rVJFTRBfgcqzoUNk5NRDA@mail.gmail.com>
 <CAJuCfpHZSEjG2nti5iWbPQjWgXcHZ95hFS2FKwaPC-sZPdSznw@mail.gmail.com> <CAHk-=wg0SyFDp_sdcEH-D+LNxuzL_dWA1vZEowUN16n_+yRHPQ@mail.gmail.com>
In-Reply-To: <CAHk-=wg0SyFDp_sdcEH-D+LNxuzL_dWA1vZEowUN16n_+yRHPQ@mail.gmail.com>
From:   Suren Baghdasaryan <surenb@google.com>
Date:   Fri, 28 Apr 2023 09:14:12 -0700
Message-ID: <CAJuCfpHouhrEtomhPe2sf+p0oG4pGFKb3xidhOXP6BN-PydY-Q@mail.gmail.com>
Subject: Re: [GIT PULL] MM updates for 6.4-rc1
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        mm-commits@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Lorenzo Stoakes <lstoakes@gmail.com>,
        Vlastimil Babka <vbabka@suse.cz>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Fri, Apr 28, 2023 at 9:08=E2=80=AFAM Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> On Fri, Apr 28, 2023 at 9:03=E2=80=AFAM Suren Baghdasaryan <surenb@google=
.com> wrote:
> >
> > I wanted these stats enabled by default to be able to identify
> > possible pathological cases and to also let users disable them if they
> > can't tolerate even a small overhead in the pagefault path. Should I
> > document this reasoning for the config option?
>
> You should document what the stats actually count (at a high enough
> level for a user to understand), and why anybody would want to keep
> them on.
>
> Honestly, 99% of the time, these are things that *developers* think
> they might want, but that nobody else will ever ever use.
>
> Really, ask yourself if a normal user would ever look at them?
>
> Now, ask yourself whether this might be something that a cloud
> provider would want to look at to gather statistics.
>
> And if it's the latter case, then it should be "default n", because
> the default should be for the people who DO NOT KNOW, AND DO NOT CARE.
>
> The cloud provider will be using a custom config anyway. The default
> is irrelevant for that use. The use that *matters* is literally the
> clueless end user who I bet will never look at these numbers, and will
> never be asked for them.

Ok, sounds like this should be 'default n'. I'll prepare a patch. Thanks!

>
>                Linus
