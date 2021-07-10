Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.0 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_IN_DEF_DKIM_WL
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0ECD5C07E99
	for <mm-commits@archiver.kernel.org>; Sat, 10 Jul 2021 00:24:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DE7AE613C9
	for <mm-commits@archiver.kernel.org>; Sat, 10 Jul 2021 00:24:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230409AbhGJA1F (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 9 Jul 2021 20:27:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229854AbhGJA1E (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 9 Jul 2021 20:27:04 -0400
Received: from mail-yb1-xb34.google.com (mail-yb1-xb34.google.com [IPv6:2607:f8b0:4864:20::b34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7E15C0613DD
        for <mm-commits@vger.kernel.org>; Fri,  9 Jul 2021 17:24:19 -0700 (PDT)
Received: by mail-yb1-xb34.google.com with SMTP id v189so8687914ybg.3
        for <mm-commits@vger.kernel.org>; Fri, 09 Jul 2021 17:24:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=d4YX3tXy0ox9X+6HhMlyx+3RosAvsz5dV6seeJG5ijo=;
        b=M5OPnJHcRxcqEUkFLBGA7IyfGQ7J2oS+MHDJNPBO/uQU8e8orEiqxahy9yMofOl9Ir
         J+e0yB6X9o1zfM64GotQOUyR7sRCqXJVCQydKM0LEiyKe4dpyv0xwvw1LAzcAMcQ7yDz
         OIPT/qcS3nku+uI9CQH8mggegn+bHIageEeUu0Rvq6WpDVNJC/htBKtCUgDyrY9iDTK9
         SzuBznr0h971Yz/DkFomNGzcj+OZ/NvWEubxXGlCL6iLAxYU49gHMIg4DH8KTlUjrK2R
         qhZ+DVNR6uvfKeWRJoWKyHVvipK7b+oO+SQXbR/21QgunGyQoZ+TnMLXJ41wUdI3Qrfh
         dfHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=d4YX3tXy0ox9X+6HhMlyx+3RosAvsz5dV6seeJG5ijo=;
        b=WwBHmEM2TquuOkTmm1Y/jzZoTTHiJ9zI6zw0mU1wnKi03b3jSr3ZfOqpMHjlNmJT3x
         fCflZ12tj3xeARPYcvQW+TJXGJrveoERMZaeUEnDADrhD7XWb5bv2QOCEkiHG7vuVrF+
         /c1DVMAaTlAsI8Mnh9TU/rd4eX6i9vnre+w7pY01jPaKQSTEwmPQ/Xamvzhbmz7WVg5j
         3pyH36FTca9UAxg1vGFcJvBE75YFL49Mw0efvhM4WQ/p03Dn2VFjtkSDt5gGh1rDAFAZ
         hupid3B2qbbO4Tc62aGaX8s2XjORouJP1sAGW7yhf9OS8om0F5OGXGPOJPEhjlW4rCIu
         t8ZA==
X-Gm-Message-State: AOAM533/MTc3NpGCwGKKhy5hWWWHUvo0vGeC9N6QgGCNFQjwZRpORkjt
        dKiaSNR7qJMDViRBtkh7wH+SmDrUhjfvMvi8Gau0TQ==
X-Google-Smtp-Source: ABdhPJyXUhNX9gBf0AoDkd+uA2DgJzDWSEnAfDdlLg0+C3ma7ucwwqVCBljqSaW2OVd4xDBoqzC7C/QHkJu9PRWGFAM=
X-Received: by 2002:a25:9945:: with SMTP id n5mr46806018ybo.294.1625876657850;
 Fri, 09 Jul 2021 17:24:17 -0700 (PDT)
MIME-Version: 1.0
References: <20210709222253.W41zC%akpm@linux-foundation.org>
 <CAJuCfpG4JenxJX+-QpHBNkX=MY9hGhh1gTHp5z8vumeZNrCCdQ@mail.gmail.com> <20210709170108.70a09b28e74ca0c3795c9117@linux-foundation.org>
In-Reply-To: <20210709170108.70a09b28e74ca0c3795c9117@linux-foundation.org>
From:   Suren Baghdasaryan <surenb@google.com>
Date:   Fri, 9 Jul 2021 17:24:06 -0700
Message-ID: <CAJuCfpER47fhswssT=Lg0dpXtc0=waoaYcReyCUGOqJ8=k8_9g@mail.gmail.com>
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

On Fri, Jul 9, 2021 at 5:01 PM Andrew Morton <akpm@linux-foundation.org> wrote:
>
> On Fri, 9 Jul 2021 16:35:18 -0700 Suren Baghdasaryan <surenb@google.com> wrote:
>
> > On Fri, Jul 9, 2021 at 3:22 PM <akpm@linux-foundation.org> wrote:
> > >
> > >
> > > The patch titled
> > >      Subject: mm, memcg: inline mem_cgroup_{charge/uncharge} to improve disabled memcg config
> > > has been added to the -mm tree.  Its filename is
> > >      mm-memcg-inline-mem_cgroup_charge-uncharge-to-improve-disabled-memcg-config.patch
> > >
> > > This patch should soon appear at
> > >     https://ozlabs.org/~akpm/mmots/broken-out/mm-memcg-inline-mem_cgroup_charge-uncharge-to-improve-disabled-memcg-config.patch
> > > and later at
> > >     https://ozlabs.org/~akpm/mmotm/broken-out/mm-memcg-inline-mem_cgroup_charge-uncharge-to-improve-disabled-memcg-config.patch
> >
> > Hi Andrew,
> > Please note that this patch is the second in the series of 3 here:
>
> This patch had "[PATCH v2 1/1]" in the title.  Poor me.

Oops! My bad, sorry.

>
> > https://lore.kernel.org/patchwork/project/lkml/list/?series=507567 and
> > the only one that needed a v2 (others seem to be fine and are Ack'ed).
> > If you would like me to respin the whole series please let me know.
>
> Yes please.

Coming right up!

>
>
