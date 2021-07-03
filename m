Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_RED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19FCAC07E96
	for <mm-commits@archiver.kernel.org>; Sat,  3 Jul 2021 00:28:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ECFE961427
	for <mm-commits@archiver.kernel.org>; Sat,  3 Jul 2021 00:28:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230037AbhGCAbH (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 2 Jul 2021 20:31:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230017AbhGCAbH (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 2 Jul 2021 20:31:07 -0400
Received: from mail-lj1-x22a.google.com (mail-lj1-x22a.google.com [IPv6:2a00:1450:4864:20::22a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB736C061762
        for <mm-commits@vger.kernel.org>; Fri,  2 Jul 2021 17:28:33 -0700 (PDT)
Received: by mail-lj1-x22a.google.com with SMTP id e3so7196418ljo.6
        for <mm-commits@vger.kernel.org>; Fri, 02 Jul 2021 17:28:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=eZi2fG4xvxGM+PF+5YbM/QZZR4RGtZj2SWD8vT7jnr8=;
        b=MebRkDZnkxhGjqV5tKbt949YMnofF0K9+ewpJE8FnCtsmuqMXDm6whUd5+FbpXmbt5
         CYK/wQsWlpf8bgNXzMbiK8s5hyvaE2Ilrz5GSrcscZrjMwRXDQNllCYygxEgL30lr3Cm
         55wHw7Dz6R6+ELQJZ1Wq3WEqw/n3lxMT3dCkM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=eZi2fG4xvxGM+PF+5YbM/QZZR4RGtZj2SWD8vT7jnr8=;
        b=izEPDo7tfelwRHy3DCNu6A3lwYF3wOsVMMs8hYHkncg1vrjInhi1nLme6Rt1RLAX4V
         sX1YvchnvX3QdhzqvJ31/8YHGY8V9NOzpFCO9d1wT9Xq2qPgNPmhMR30+6VH8U4GjJ2r
         v+6pkIwhdxcdE0Lf/UX1BT7u53EH6z6xc4XZzmRt49SMk3/ETXUwS3eDc588gXsp0DXL
         6UjBc3HHvKvv28zy4eONAoWfVXKNo2YLHW8xUNY+Va/edDPwn/K/d5U1zUXGYvaaDmIb
         1elsBnEADu1FdGf7LcMNXupuyvHmIVCBq1Hrsu8zK4SiQ1dzUyfGxoVVay8fwJEwO1GC
         /1/w==
X-Gm-Message-State: AOAM531KjMrsncIIiQ7ipnDs3id18UAxtI2Z1KhezwNn5icxdHgQMgah
        5yDtzdP0ljVZSjB2LvcTNhHgHsSQIG8pTR8XwBQ=
X-Google-Smtp-Source: ABdhPJzJa2vB8Rb8bywgpFtguGPrVSSvACUMeQ6X4Jgsp51+UoQ26o2/te2M5gfLq81NzxwcXl3nqg==
X-Received: by 2002:a2e:7412:: with SMTP id p18mr1568431ljc.428.1625272111845;
        Fri, 02 Jul 2021 17:28:31 -0700 (PDT)
Received: from mail-lf1-f53.google.com (mail-lf1-f53.google.com. [209.85.167.53])
        by smtp.gmail.com with ESMTPSA id z21sm518240ljm.52.2021.07.02.17.28.31
        for <mm-commits@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 02 Jul 2021 17:28:31 -0700 (PDT)
Received: by mail-lf1-f53.google.com with SMTP id a18so21101834lfs.10
        for <mm-commits@vger.kernel.org>; Fri, 02 Jul 2021 17:28:31 -0700 (PDT)
X-Received: by 2002:a05:6512:3585:: with SMTP id m5mr920647lfr.253.1625272111199;
 Fri, 02 Jul 2021 17:28:31 -0700 (PDT)
MIME-Version: 1.0
References: <20210630184624.9ca1937310b0dd5ce66b30e7@linux-foundation.org>
In-Reply-To: <20210630184624.9ca1937310b0dd5ce66b30e7@linux-foundation.org>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Fri, 2 Jul 2021 17:28:15 -0700
X-Gmail-Original-Message-ID: <CAHk-=wjrb-3drQQYYGxUxzbJhWog2JA9JZuYMXW=rhe-DY9rxA@mail.gmail.com>
Message-ID: <CAHk-=wjrb-3drQQYYGxUxzbJhWog2JA9JZuYMXW=rhe-DY9rxA@mail.gmail.com>
Subject: Re: incoming
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     Linux-MM <linux-mm@kvack.org>, mm-commits@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Wed, Jun 30, 2021 at 6:46 PM Andrew Morton <akpm@linux-foundation.org> wrote:
>
> This is the rest of the -mm tree, less 66 patches which are dependent on
> things which are (or were recently) in linux-next.  I'll trickle that
> material over next week.

I haven't bisected this yet, but with the current -git I'm getting

   watchdog: BUG: soft lockup - CPU#41 stuck for 49s!

and the common call chain seems to be in flush_tlb_mm_range ->
on_each_cpu_cond_mask.

Commit e058a84bfddc42ba356a2316f2cf1141974625c9 is good, and looking
at the pulls and merges I've done since, this -mm series looks like
the obvious culprit.

I'll go start bisection, but I thought I'd give a heads-up in case
somebody else has seen TLB-flush-related lockups and already figured
out the guilty party..

                 Linus
