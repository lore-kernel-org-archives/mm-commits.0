Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.0 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_IN_DEF_DKIM_WL
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD465C07E99
	for <mm-commits@archiver.kernel.org>; Sat, 10 Jul 2021 00:38:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AB1EF613C2
	for <mm-commits@archiver.kernel.org>; Sat, 10 Jul 2021 00:38:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231176AbhGJAlm (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 9 Jul 2021 20:41:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230428AbhGJAll (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 9 Jul 2021 20:41:41 -0400
Received: from mail-yb1-xb2f.google.com (mail-yb1-xb2f.google.com [IPv6:2607:f8b0:4864:20::b2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1957C0613DD
        for <mm-commits@vger.kernel.org>; Fri,  9 Jul 2021 17:38:57 -0700 (PDT)
Received: by mail-yb1-xb2f.google.com with SMTP id o139so17155448ybg.9
        for <mm-commits@vger.kernel.org>; Fri, 09 Jul 2021 17:38:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=vyFdGc55DL6K0OX2aUQDmVi9j1XjTMi0SM30A2bE1CM=;
        b=TGlBZdQnQqBwm55sh/NVe9kNT0ieMQZ8inPcr3V9UxH8bGN/cr+kxyIsymzbPIBvI5
         viu24pfWq5TI+qsaUjWcnxUR4jIlJJkKDK53eJzs9xVLVG2ashbfGUUfvqaD2dzgCXdO
         RzRGlv3Rvnu1avzqSkDTrBk/hK8BtQFgW38oaYPSLBDws9wYql9l3vE4DvUnXq2l3gM1
         Lodmrf/OvN1qaXRPEZr5YVIw229c8OFsVPrwdjXMBPWIrhdp0eMWxcs4wtFjZYnCFjg8
         b0ryymx0MK3r15Xf5uLOKtapukBVfTX4DDYrh0HgcISOiaCBWuq4nHiaeR8zcMQSveeU
         ctZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vyFdGc55DL6K0OX2aUQDmVi9j1XjTMi0SM30A2bE1CM=;
        b=pb7DcU7hOfP2zsOlp0aY+aRzCT+agkjuYbYvt+Ridwnr4qZ77QiifcWDv/rsSZn6MM
         q8yPbySz6Zx3BkY4XSfFftktpQl3Zoe0pQ1Q+NUELEJiECPh88T4d+CFmNLua9zdcP4p
         zBLxxOTZTM49HvnC4CCnXEyHOFAcgTDOd75wUNYfGNtaBO43Ni6GP/2kfzR8CR/SNTpj
         csbkDUk/+UjimtAT84sr7ABPGEmJZ6hGH2bHH/GgN/cSNx5JcnoXzh3Whl3dxEX90gzF
         K+aDHAbacJk/Km8whPMKNe1KwXhffNkmoz/4LEre3LXhnqbrp8dBi/jm97P1pdw3sSeT
         KkDQ==
X-Gm-Message-State: AOAM532XlXWQx9fi9/deg/jc4AYnAUoy/wLnkqez0pVEJyOvelZq1nrw
        Ok7SkugqXHwKqcERsSBuDAKK8Y+qhlROaCG/8kfCUQ==
X-Google-Smtp-Source: ABdhPJyXbT13RYyTzLeRHexBrbclXFIV+zH0rPbwz9GTiT7xQb+H2c1SX4eQCtsX/egIT9opyaFbrv1K/qIDiy+GkU8=
X-Received: by 2002:a25:7ec4:: with SMTP id z187mr49702938ybc.136.1625877536695;
 Fri, 09 Jul 2021 17:38:56 -0700 (PDT)
MIME-Version: 1.0
References: <20210709222253.W41zC%akpm@linux-foundation.org>
 <CAJuCfpG4JenxJX+-QpHBNkX=MY9hGhh1gTHp5z8vumeZNrCCdQ@mail.gmail.com>
 <20210709170108.70a09b28e74ca0c3795c9117@linux-foundation.org> <CAJuCfpER47fhswssT=Lg0dpXtc0=waoaYcReyCUGOqJ8=k8_9g@mail.gmail.com>
In-Reply-To: <CAJuCfpER47fhswssT=Lg0dpXtc0=waoaYcReyCUGOqJ8=k8_9g@mail.gmail.com>
From:   Suren Baghdasaryan <surenb@google.com>
Date:   Fri, 9 Jul 2021 17:38:45 -0700
Message-ID: <CAJuCfpG2mgg4JBGpAs6YmBsUSPwhkR+Bf7SXKG7H6uvtZi65nw@mail.gmail.com>
Subject: Re: + mm-memcg-inline-mem_cgroup_charge-uncharge-to-improve-disabled-memcg-config.patch
 added to -mm tree
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     mm-commits@vger.kernel.org, vdavydov.dev@gmail.com,
        Shakeel Butt <shakeelb@google.com>,
        Michal Hocko <mhocko@suse.com>,
        Johannes Weiner <hannes@cmpxchg.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Fri, Jul 9, 2021 at 5:24 PM Suren Baghdasaryan <surenb@google.com> wrote:
>
> On Fri, Jul 9, 2021 at 5:01 PM Andrew Morton <akpm@linux-foundation.org> wrote:
> >
> > On Fri, 9 Jul 2021 16:35:18 -0700 Suren Baghdasaryan <surenb@google.com> wrote:
> >
> > > On Fri, Jul 9, 2021 at 3:22 PM <akpm@linux-foundation.org> wrote:
> > > >
> > > >
> > > > The patch titled
> > > >      Subject: mm, memcg: inline mem_cgroup_{charge/uncharge} to improve disabled memcg config
> > > > has been added to the -mm tree.  Its filename is
> > > >      mm-memcg-inline-mem_cgroup_charge-uncharge-to-improve-disabled-memcg-config.patch
> > > >
> > > > This patch should soon appear at
> > > >     https://ozlabs.org/~akpm/mmots/broken-out/mm-memcg-inline-mem_cgroup_charge-uncharge-to-improve-disabled-memcg-config.patch
> > > > and later at
> > > >     https://ozlabs.org/~akpm/mmotm/broken-out/mm-memcg-inline-mem_cgroup_charge-uncharge-to-improve-disabled-memcg-config.patch
> > >
> > > Hi Andrew,
> > > Please note that this patch is the second in the series of 3 here:
> >
> > This patch had "[PATCH v2 1/1]" in the title.  Poor me.
>
> Oops! My bad, sorry.
>
> >
> > > https://lore.kernel.org/patchwork/project/lkml/list/?series=507567 and
> > > the only one that needed a v2 (others seem to be fine and are Ack'ed).
> > > If you would like me to respin the whole series please let me know.
> >
> > Yes please.
>
> Coming right up!

Posted v3 of the whole series here:
https://lore.kernel.org/patchwork/project/lkml/list/?series=507708
Sorry about the confusion.

>
> >
> >
