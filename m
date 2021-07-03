Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_RED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22F9AC07E98
	for <mm-commits@archiver.kernel.org>; Sat,  3 Jul 2021 01:07:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 03C526142E
	for <mm-commits@archiver.kernel.org>; Sat,  3 Jul 2021 01:07:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230051AbhGCBJq (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 2 Jul 2021 21:09:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230017AbhGCBJq (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 2 Jul 2021 21:09:46 -0400
Received: from mail-lj1-x229.google.com (mail-lj1-x229.google.com [IPv6:2a00:1450:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47E8AC061762
        for <mm-commits@vger.kernel.org>; Fri,  2 Jul 2021 18:07:13 -0700 (PDT)
Received: by mail-lj1-x229.google.com with SMTP id u25so15710860ljj.11
        for <mm-commits@vger.kernel.org>; Fri, 02 Jul 2021 18:07:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=E/e3Y4rutbf4eikUgWY6redTpdXfCveoUGI5Eup8bhA=;
        b=TVbx0dDpXELx2Q987cjaXf7lOm1513VZXDayhwE7kBno5FwNNZyyKTOPlFXaMGSn8q
         JuFHm55Oc684FQbXGc7oh5LCth9WXbmWg8x557XQOm0pSQP8JVmpeP5KdPZgR3Uj5oS2
         FPUlG64oeS1PeqM4IyJM+wC0cbRt9ll0E5VLY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=E/e3Y4rutbf4eikUgWY6redTpdXfCveoUGI5Eup8bhA=;
        b=PuCOoKieBIMxWVfWCe09QzMImvl+ZnWb85hbZ9rIc4wbFy7EoWmShJK7GXgAmSLuW2
         +gOl5k2KYSHnWRtcPnzY0JVH0XNvb+K1dKArMPUQDbRnBguZ3/zXkLCUCeVS/ANVZ6cO
         70A7St1a00c03H7LNAn4s08rtSVEYLSucD+8bp2mwcqEABJrovVyXMpW2TeIE+ysgF+K
         PpNtna159QSkyXUjR/wELIZLtKfoQcjnmgjyJKue6jBCwdS3Jvh7KOC+qzUTI9vYZZTV
         o9SiPINhDhGV0KCEXD2KuZ1PoT2B3V4LaQLri6YN8d0Lgu4IlkzGKr5K2enzMVq49X5m
         tlYg==
X-Gm-Message-State: AOAM5304T+bP9sELfvLAQFrmv6BrxFcN7EJmnAEulJkvEDbbq6WrdCcq
        A7XR6gzPdK7GD4Nx6IxAbacGpyZY7yOs353wA+Q=
X-Google-Smtp-Source: ABdhPJx0D+/Cs79OKZk7np7rjUxcLS/bbmuyWutyp3yTbY+WYiaygm4XlXM5tXrezQ6a5VQbLznmVA==
X-Received: by 2002:a2e:97d6:: with SMTP id m22mr1650744ljj.15.1625274430927;
        Fri, 02 Jul 2021 18:07:10 -0700 (PDT)
Received: from mail-lf1-f42.google.com (mail-lf1-f42.google.com. [209.85.167.42])
        by smtp.gmail.com with ESMTPSA id w25sm25378lfq.306.2021.07.02.18.07.10
        for <mm-commits@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 02 Jul 2021 18:07:10 -0700 (PDT)
Received: by mail-lf1-f42.google.com with SMTP id t17so21370101lfq.0
        for <mm-commits@vger.kernel.org>; Fri, 02 Jul 2021 18:07:10 -0700 (PDT)
X-Received: by 2002:ac2:4903:: with SMTP id n3mr1662967lfi.487.1625274430267;
 Fri, 02 Jul 2021 18:07:10 -0700 (PDT)
MIME-Version: 1.0
References: <20210630184624.9ca1937310b0dd5ce66b30e7@linux-foundation.org> <CAHk-=wjrb-3drQQYYGxUxzbJhWog2JA9JZuYMXW=rhe-DY9rxA@mail.gmail.com>
In-Reply-To: <CAHk-=wjrb-3drQQYYGxUxzbJhWog2JA9JZuYMXW=rhe-DY9rxA@mail.gmail.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Fri, 2 Jul 2021 18:06:54 -0700
X-Gmail-Original-Message-ID: <CAHk-=wg=_30r2h2SiRRu2F6-_BE65fxahc+Ze4-=cEQ3hQjetg@mail.gmail.com>
Message-ID: <CAHk-=wg=_30r2h2SiRRu2F6-_BE65fxahc+Ze4-=cEQ3hQjetg@mail.gmail.com>
Subject: Re: incoming
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     Linux-MM <linux-mm@kvack.org>, mm-commits@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Fri, Jul 2, 2021 at 5:28 PM Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> Commit e058a84bfddc42ba356a2316f2cf1141974625c9 is good, and looking
> at the pulls and merges I've done since, this -mm series looks like
> the obvious culprit.

No, unless my bisection is wrong, the -mm branch is innocent, and was
discarded from the suspects on the very first bisection trial.

So never mind.

             Linus
