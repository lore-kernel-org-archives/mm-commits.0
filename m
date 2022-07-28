Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7947C19F2B
	for <mm-commits@archiver.kernel.org>; Thu, 28 Jul 2022 16:08:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230029AbiG1QI5 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 28 Jul 2022 12:08:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229470AbiG1QI4 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 28 Jul 2022 12:08:56 -0400
Received: from mail-yb1-xb30.google.com (mail-yb1-xb30.google.com [IPv6:2607:f8b0:4864:20::b30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB7BC6E2D1
        for <mm-commits@vger.kernel.org>; Thu, 28 Jul 2022 09:08:55 -0700 (PDT)
Received: by mail-yb1-xb30.google.com with SMTP id o15so3957302yba.10
        for <mm-commits@vger.kernel.org>; Thu, 28 Jul 2022 09:08:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=BPkYTh35KDyIE13hO7Km0LL//NaxzsWGXXP2ojbgHww=;
        b=qXceHORRaYWbFqr1qyI6NSNpwivmuKKBl3ghRT7DzZhISstCkbSBcrJGaU9hTs7eOm
         fX0AZzm2si+XycMJHf1EveFHwlJg8qBU7M1XFME0/RRddmboiBbtFzWf9ly0F8rVkUUL
         jt25unQPgsKSPvUrGnAwkByD3TLRy5RwTD1MarkbucJI9/99yeADk2pQaYqwjHxW/A/E
         LZoFf3cLMozcDKjkhkOwmxVCC2ebC2udWx4Ngqh9zHX6LNjX3rfrDW5IBPajrg63r50O
         GmDtMxEQm02U50+7kboEg2QD4ZTY6tQDi6YJ4WASHtHFxxfJ6Jw6Ra8qrTwEa/S+Hq++
         DCVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=BPkYTh35KDyIE13hO7Km0LL//NaxzsWGXXP2ojbgHww=;
        b=LAT006dJl3+9xS3EzQl5w8daKC3kkCuU7j0jPGYUnJLfskWdM1cG9SLxE4tKfLIVsp
         66TqAu/qckjbhWSCEyyIPrCclfIzHjz5QfsRE0wJMsM7gbkGD+9DGW29Or+8cK6kFixy
         gacEDd9oNKgHZRTAfXormz+43oHdsA0FvZC7MwSkE1Zub+W9qjXHm2NIbKNUcgb6Ga10
         fIsO/VKRD4dKU1fly31Gq507sVBzTSlmeKpKZz1CIqJAacK3a+3vaEHEN0CiMHn681w6
         yMAXStgdH4vBZD3/oESgB1XIkpG3zSIeglUolbTxR/oFZK3HpdnuCwUqEp6mHFlx260p
         lpQg==
X-Gm-Message-State: AJIora8nSTtV6QcT24/5zqT86Xlgfi/n77sFJAoRh16diTNGNlCnANgc
        lx57M3l0Vu+kvPXI0Jsrn/RAfIAunxAM+up1Y3z8Sg==
X-Google-Smtp-Source: AGRyM1sUpg2di2l+mAY1YAyHJJE1md0H44p+f47u86mOAcCifZyZ81PR7k1fbmUs+9rL5VtiC2VuEn5xaFlLq9cWFd0=
X-Received: by 2002:a5b:c0c:0:b0:671:7fc5:cbae with SMTP id
 f12-20020a5b0c0c000000b006717fc5cbaemr7535793ybq.426.1659024534829; Thu, 28
 Jul 2022 09:08:54 -0700 (PDT)
MIME-Version: 1.0
References: <20220601213751.9305CC385A5@smtp.kernel.org> <CAJuCfpE3V6LzL+XW2mzLm-h1f9KVurp8v_cKNstR+dqmw1MYNw@mail.gmail.com>
 <20220727203405.aa0908390d905b1671772c0e@linux-foundation.org>
In-Reply-To: <20220727203405.aa0908390d905b1671772c0e@linux-foundation.org>
From:   Suren Baghdasaryan <surenb@google.com>
Date:   Thu, 28 Jul 2022 09:08:43 -0700
Message-ID: <CAJuCfpH5cMy-cD0VHpGVysiPhv=EPC=5qL7QfDh=0kTA5a63BA@mail.gmail.com>
Subject: Re: + mm-delete-unused-mmf_oom_victim-flag.patch added to mm-unstable branch
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     mm-commits@vger.kernel.org, Michal Hocko <mhocko@suse.com>,
        "Liam R. Howlett" <liam.howlett@oracle.com>,
        Matthew Wilcox <willy@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Wed, Jul 27, 2022 at 8:34 PM Andrew Morton <akpm@linux-foundation.org> wrote:
>
> On Wed, 27 Jul 2022 11:17:20 -0700 Suren Baghdasaryan <surenb@google.com> wrote:
>
> > > The patch titled
> > >      Subject: mm: delete unused MMF_OOM_VICTIM flag
> > > has been added to the -mm mm-unstable branch.  Its filename is
> > >      mm-delete-unused-mmf_oom_victim-flag.patch
> >
> > I can't find this and the accompanying patch
> > (https://lore.kernel.org/all/20220601213748.DAF1DC385A5@smtp.kernel.org/
> > and https://lore.kernel.org/all/20220601213751.9305CC385A5@smtp.kernel.org/)
> > in any tree now and can't find any notifications about them being
> > dropped. Could you please check what happened to them? I remember
> > there was a minor conflict with maple-tree patchset that we resolved,
> > so maybe they are queued together?
>
> Yesterday I removed the mapletree patchset from mm-unstable, as it
> isn't suitable for the next merge window.
>
> Three other series were significantly dependent on mapletree:
>
>         Refactor of vma_merge and new merge call
>
>         mm: drop oom code from exit_mmap
>         mm: delete unused MMF_OOM_VICTIM flag
>
>         Refactor of vma_merge and new merge call
>
> and the single patch
>
>         mm/mlock: drop dead code in count_mm_mlocked_page_nr()
>
> None of these are very urgent and I might hold them over until
> mapletree is reintroduced.  This is the lowest risk approach.

Got it. No problem, just wanted to make sure they are not abandoned.
Thanks!

>
> I need to revisit these patches to see if they can be reworked for a 5.20-rc1
> with acceptable risk at this late stage.
>
>
