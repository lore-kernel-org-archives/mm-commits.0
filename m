Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A964DC433FE
	for <mm-commits@archiver.kernel.org>; Mon, 28 Nov 2022 19:23:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233665AbiK1TXl (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 28 Nov 2022 14:23:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233785AbiK1TXZ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 28 Nov 2022 14:23:25 -0500
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F6B026AFC
        for <mm-commits@vger.kernel.org>; Mon, 28 Nov 2022 11:23:21 -0800 (PST)
Received: by mail-pj1-x1030.google.com with SMTP id q17-20020a17090aa01100b002194cba32e9so154636pjp.1
        for <mm-commits@vger.kernel.org>; Mon, 28 Nov 2022 11:23:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=+uPnI6SvHardgeS1yLt8wexlDvDxU3XZfd2Nj2RkSbA=;
        b=miQ3TE9zJeFSPd/S7U/Xh0eCrpYb2SsSkVrZeyG1+rp0MpuuQrwjqsHllWDR5lzvwn
         sKTQXqbHnsr4QNRyLJP89DcM3ReZ7gwQzYOTCKSU84vPFce0u21rEIbEhB6KhEvibbe0
         /4+3Uv9P4pnpp2RxaA+K/93iwkgkttl2gyAGFkeY32tDya2sKg6OstJO0ckAJ0b64VDW
         SvjHaN3JPlOMGDQdRWggK4PQcdlC31O7x4Xenoexg2eYhyrrk/wRLX3jl2c08eKQTbU9
         jJM1yCM59+A7KYvrkcvRDIkESwdxYzGTWlFfztcqh+UNYDLn3HUFkoNYowijLX47dIgX
         I+hQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+uPnI6SvHardgeS1yLt8wexlDvDxU3XZfd2Nj2RkSbA=;
        b=sJssZ6UPSFQacrSVDCI9xDN0HcFIxO6BAXd8j4Dp2Zp2UM8yV6GwOdSr6hmSTpXqz/
         7sacQAy0zgvHhCdBRVagcKf2at3qU/UN/B3SprCF6c4zvoZ7G+nAs9tolDYWhDVTDnry
         6b7YYmqgfqnogRu5PD29YYREF3WgLNNh/DeIFy0GIctiopafmcNqmmvtWt3ZrpzFUP1p
         4DPxD3ebECB2h1Ul4CgpgYY0L8G6LvkwsIPIi29/gEt2/OF5B+hT6dsei9Mp5VupHdDD
         nWCEWAzpDqmifyfE74NYu3bSNA+GTA1Mbb0yT+3VWkt18luaPLx2CZiq+42U0FcuQ+pZ
         RrLw==
X-Gm-Message-State: ANoB5pn6Ycdv84zVZiI1xi2wC73XTM8hhN6sYbLFv2vr3sQ3tFYqS0y8
        l0fGHF1Bp+6+DTNHdY5h8tCaqajRvVvjjaC9WZ8ZMaeX
X-Google-Smtp-Source: AA0mqf4rHJFELS59J6CPuPDnlOCtPWeEyUYlR/CdIEh6zftMxDiv1t0Sotqwwqc58BcvpiF/6L3S8AzYtP8gnWNQMjQ=
X-Received: by 2002:a17:90a:4889:b0:20d:d531:97cc with SMTP id
 b9-20020a17090a488900b0020dd53197ccmr57076991pjh.164.1669663400550; Mon, 28
 Nov 2022 11:23:20 -0800 (PST)
MIME-Version: 1.0
References: <20221123195755.F2521C433C1@smtp.kernel.org> <Y38adlO8/Gky/3Z5@dhcp22.suse.cz>
In-Reply-To: <Y38adlO8/Gky/3Z5@dhcp22.suse.cz>
From:   Yang Shi <shy828301@gmail.com>
Date:   Mon, 28 Nov 2022 11:23:08 -0800
Message-ID: <CAHbLzkp9msdR6Lv2b1SCh0+t-i3HUOfgi7dhaBESH9Lqs4FGng@mail.gmail.com>
Subject: Re: + mm-replace-vm_warn_on-to-pr_warn-if-the-node-is-offline-with-__gfp_thisnode-v4.patch
 added to mm-hotfixes-unstable branch
To:     Michal Hocko <mhocko@suse.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        mm-commits@vger.kernel.org, zokeefe@google.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Wed, Nov 23, 2022 at 11:17 PM Michal Hocko <mhocko@suse.com> wrote:
>
> On Wed 23-11-22 11:57:55, Andrew Morton wrote:
> [...]
> > -static inline void warn_if_node_offline(int nid, gfp_t gfp_mask)
> > +static inline void warn_if_node_offline(int this_node, gfp_t gfp_mask)
> >  {
> > -     gfp_t gfp = gfp_mask & (__GFP_THISNODE|__GFP_NOWARN);
> > +     gfp_t warn_gfp = gfp_mask & (__GFP_THISNODE|__GFP_NOWARN);
> >
> > -     if ((gfp == (__GFP_THISNODE|__GFP_NOWARN)) && !node_online(nid)) {
> > -             pr_warn("%pGg allocation from offline node %d\n", &gfp, nid);
> > -             dump_stack();
> > -     }
> > +     if (warn_gfp != (__GFP_THISNODE|__GFP_NOWARN))
> > +             return;
> > +
> > +     if(node_online(this_node))
> > +             return;
> > +
> > +     pr_warn("%pGg allocation from offline node %d\n", &warn_gfp, this_node);
>
> This should be gfp_mask printed, not the filtered part of it.

Aha, thanks for catching this. A little bit of rush to send out the
patch before holiday.

>
> > +     dump_stack();
> >  }
> >
> >  /*
> > _
> >
> > Patches currently in -mm which might be from shy828301@gmail.com are
> >
> > mm-replace-vm_warn_on-to-pr_warn-if-the-node-is-offline-with-__gfp_thisnode.patch
> > mm-replace-vm_warn_on-to-pr_warn-if-the-node-is-offline-with-__gfp_thisnode-v4.patch
>
> --
> Michal Hocko
> SUSE Labs
