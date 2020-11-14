Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33530C63697
	for <mm-commits@archiver.kernel.org>; Sat, 14 Nov 2020 21:40:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CF3CF222B9
	for <mm-commits@archiver.kernel.org>; Sat, 14 Nov 2020 21:40:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="dFQVkF5J"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726227AbgKNVkJ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 14 Nov 2020 16:40:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726112AbgKNVkI (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 14 Nov 2020 16:40:08 -0500
Received: from mail-lj1-x244.google.com (mail-lj1-x244.google.com [IPv6:2a00:1450:4864:20::244])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 268A6C0613D2
        for <mm-commits@vger.kernel.org>; Sat, 14 Nov 2020 13:40:08 -0800 (PST)
Received: by mail-lj1-x244.google.com with SMTP id 142so1590148ljj.10
        for <mm-commits@vger.kernel.org>; Sat, 14 Nov 2020 13:40:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=mtgfuBsKaXsJcS3VyrNrM24pb1hiSB38AWDX8iQwSqE=;
        b=dFQVkF5J20UTcZKIYlhNZbgab9w4q1RcvptVBtINtyF82vwmBfx1T9f/azNWYB6EZh
         XmnkVIUzGmkCZffGvucZuE+9ulu5ppneeHnhjhHthgMJtOwaxHxrzwcQXyfJs6hN+iCh
         NVUOoYL3P2oE0Paguwenw23w/O2UKvOuPJgFg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=mtgfuBsKaXsJcS3VyrNrM24pb1hiSB38AWDX8iQwSqE=;
        b=Fxe0+Pm9N//AjEs20a13KnEBMz3Hkx8GFEKXjhkZSZ8K2OTtUOTKd9tgWb0wL2afW4
         tW+dasa+Dm5yZ5OGLoaUIBYTBALER35+IoC2T61a5kkpngbMIJEeOiWYdQycyO5pTQIV
         MibV48KpvIbiNtC+fLW8n0VE2dt6YjiaNXce9cBfKp1GA/7abgxIz1xwtvNer44hZTRX
         aLKO04Ex8z6Hg+1Xx3sX/ZXKOW+vljYWcsayDvKTHm9fil5CH49aHUk7WI5y6CSXfMl7
         sSA9qyT+hqynRnCTfa+DpoIQ9mvp8i1t8AHSitAc336VyPQUi3T2LWaLvOyUvo33aiuB
         BeLg==
X-Gm-Message-State: AOAM531RMJTy6uThtD3mAb3KbUgbVbXQC72+tNNd99xaC8VyTQ5vYNeV
        uJIb19V/ZYuejqiAgR3BbCkFEM8uEfxfyA==
X-Google-Smtp-Source: ABdhPJxk02uG0hjzo5b1LI8J3lm+l/tNF8Yd7odY3HSDHQr1Kgjjyj0lkZHpDq4URg06G/THS8+JgA==
X-Received: by 2002:a2e:90c5:: with SMTP id o5mr3204614ljg.136.1605390005497;
        Sat, 14 Nov 2020 13:40:05 -0800 (PST)
Received: from mail-lj1-f179.google.com (mail-lj1-f179.google.com. [209.85.208.179])
        by smtp.gmail.com with ESMTPSA id f18sm1858544lfc.198.2020.11.14.13.40.04
        for <mm-commits@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 14 Nov 2020 13:40:04 -0800 (PST)
Received: by mail-lj1-f179.google.com with SMTP id b17so15196465ljf.12
        for <mm-commits@vger.kernel.org>; Sat, 14 Nov 2020 13:40:04 -0800 (PST)
X-Received: by 2002:a2e:a375:: with SMTP id i21mr3137262ljn.421.1605390003621;
 Sat, 14 Nov 2020 13:40:03 -0800 (PST)
MIME-Version: 1.0
References: <20201113225115.b24faebc85f710d5aff55aa7@linux-foundation.org> <20201114065146.3H6OX7gIF%akpm@linux-foundation.org>
In-Reply-To: <20201114065146.3H6OX7gIF%akpm@linux-foundation.org>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Sat, 14 Nov 2020 13:39:47 -0800
X-Gmail-Original-Message-ID: <CAHk-=wj847SudR-kt+46fT3+xFFgiwpgThvm7DJWGdi4cVrbnQ@mail.gmail.com>
Message-ID: <CAHk-=wj847SudR-kt+46fT3+xFFgiwpgThvm7DJWGdi4cVrbnQ@mail.gmail.com>
Subject: Re: [patch 03/14] mm/vmscan: fix NR_ISOLATED_FILE corruption on 64-bit
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     a.sahrawat@samsung.com, Linux-MM <linux-mm@kvack.org>,
        maninder1.s@samsung.com, Mel Gorman <mgorman@suse.de>,
        Michal Hocko <mhocko@suse.com>, mm-commits@vger.kernel.org,
        Nick Piggin <npiggin@gmail.com>,
        stable <stable@vger.kernel.org>, v.narang@samsung.com,
        Vlastimil Babka <vbabka@suse.cz>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

I've applied this patch, but I have to say that I absolutely detest it.

This is very fragile, and I think the problem is the nasty interface.

Why don't we have simple wrappers that internally do that "mod", but
actually expose "inc" and "dec" instead, and make it much harder to
have these kinds of problems?

The function name is horrible too: "mod_node_page_state()"?  It's not
like that really even describes what it does. It doesn't modify any
page state what-so-ever, what it does is to update some node counters.

Did somebody mis-understand what "stat" stands for? It's not some odd
shortening of "state" (like "creat"). It's shorthand for "statistics".
Because that completely nonsensical "state" naming shows up in all of
those helper functions too.

And the "page" part of the name is misleading too, since it's not even
about page statistics, and the people who have a page need to
literally do "page_pgdat()" on that page in order to pass in the
"struct pglist_data" that the function wants.

To make matters worse, we have the double underscore versions too,
which have that magical "we know interrupts are disabled"
optimization, so we duplicate all of this horror.

So I really think this whole area would be ripe for some major
interface cleanups, both in naming and in interfaces.

A _small_ step would have been to avoid the "mod" thing.

            Linus

On Fri, Nov 13, 2020 at 10:51 PM Andrew Morton
<akpm@linux-foundation.org> wrote:
>
> From: Nicholas Piggin <npiggin@gmail.com>
> Subject: mm/vmscan: fix NR_ISOLATED_FILE corruption on 64-bit
>
> -       mod_node_page_state(zone->zone_pgdat, NR_ISOLATED_FILE, -nr_reclaimed);
> +       mod_node_page_state(zone->zone_pgdat, NR_ISOLATED_FILE,
> +                           -(long)nr_reclaimed);
...
>         mod_node_page_state(zone->zone_pgdat, NR_ISOLATED_FILE,
> -                           -stat.nr_lazyfree_fail);
> +                           -(long)stat.nr_lazyfree_fail);
