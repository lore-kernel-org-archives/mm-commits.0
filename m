Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E781C433F5
	for <mm-commits@archiver.kernel.org>; Mon,  8 Nov 2021 17:15:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DEA896108E
	for <mm-commits@archiver.kernel.org>; Mon,  8 Nov 2021 17:15:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231512AbhKHRSI (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 8 Nov 2021 12:18:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231129AbhKHRSI (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 8 Nov 2021 12:18:08 -0500
Received: from mail-lj1-x234.google.com (mail-lj1-x234.google.com [IPv6:2a00:1450:4864:20::234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8584DC061570
        for <mm-commits@vger.kernel.org>; Mon,  8 Nov 2021 09:15:23 -0800 (PST)
Received: by mail-lj1-x234.google.com with SMTP id e11so11621594ljo.13
        for <mm-commits@vger.kernel.org>; Mon, 08 Nov 2021 09:15:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=rbpdyFuvgnoYbw1vZgGRR04p1YqU09F597l56zKmF5w=;
        b=FdCbgZN5IkZRTACGx4tQGD9MUZfbCwA5BvyKga8l1/thVsThgJm6EHhUaGhiLre9b8
         VZqn5LxxZNoX8nRPRMtTCXeT0KGbklOBxHqTo0FHM8VpeG/2skIx/R+GTTYKp1Vgm57h
         12Orvhq0BPMVrQzkqorerKNGwUAS3ZkCBn1+4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=rbpdyFuvgnoYbw1vZgGRR04p1YqU09F597l56zKmF5w=;
        b=E8A1W+gULH1uqvWBUuICVlTw08yH260nYFSP3aTYrOcev2mUfoMRJybZFpdoz31O3J
         dPlf6xm32NL/8dlwDnWByPOMc8zAjfWe8itgvycumTHzD1wCXvzGKH+fj9GYdFHSksWv
         Ud5BXZO3XoUgGaMZHhUg1pAeEGLHcglfs0ny4pafuMKtH+5hr3kuNwIHvqbAMPitVWnx
         Y3K5aKyC1ngodZRvMEuo/odGSpzY/9+dPzJ5LYhSB7o2xuj0q16Qi6gDCswC00SEzOPI
         OcFIlzOMUyJCuo0FU+IsqUkPsFHkYxlw4fAtY3s3iLLn0Y1Rkq10DnFgWVQp3YDZJuKs
         7FoA==
X-Gm-Message-State: AOAM530dU0ML4J1B7sQ3x/ubXk6A0xG7uxqeDB5sQz32ldzeE4Zfscts
        KPylNrGooJaWS8Bsip2LnuGIYhNxuaSrw+GN
X-Google-Smtp-Source: ABdhPJzghp3YLew9RScVKLjqcdG1P6z/tW+AoSDuI0iegsjJ64eI3pIkRMwimXk+NIwc3Qtw6/8a1w==
X-Received: by 2002:a2e:a7c6:: with SMTP id x6mr607279ljp.328.1636391721750;
        Mon, 08 Nov 2021 09:15:21 -0800 (PST)
Received: from mail-lf1-f54.google.com (mail-lf1-f54.google.com. [209.85.167.54])
        by smtp.gmail.com with ESMTPSA id b17sm1537947ljd.68.2021.11.08.09.15.20
        for <mm-commits@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 08 Nov 2021 09:15:20 -0800 (PST)
Received: by mail-lf1-f54.google.com with SMTP id p16so37840698lfa.2
        for <mm-commits@vger.kernel.org>; Mon, 08 Nov 2021 09:15:20 -0800 (PST)
X-Received: by 2002:ac2:57d3:: with SMTP id k19mr843202lfo.150.1636391719818;
 Mon, 08 Nov 2021 09:15:19 -0800 (PST)
MIME-Version: 1.0
References: <20211105133408.cccbb98b71a77d5e8430aba1@linux-foundation.org>
 <20211105203950.AJ1Cnteeh%akpm@linux-foundation.org> <YYjs7UT15WIF23DJ@dhcp22.suse.cz>
In-Reply-To: <YYjs7UT15WIF23DJ@dhcp22.suse.cz>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Mon, 8 Nov 2021 09:15:04 -0800
X-Gmail-Original-Message-ID: <CAHk-=wjov5-baOgf+r7bOh=P_YCHuxBcyf_b=or990RTxz5QAw@mail.gmail.com>
Message-ID: <CAHk-=wjov5-baOgf+r7bOh=P_YCHuxBcyf_b=or990RTxz5QAw@mail.gmail.com>
Subject: Re: [patch 099/262] mm/vmalloc: be more explicit about supported gfp flags
To:     Michal Hocko <mhocko@suse.com>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@infradead.org>,
        Ilya Dryomov <idryomov@gmail.com>,
        Jeff Layton <jlayton@kernel.org>,
        Linux-MM <linux-mm@kvack.org>, mm-commits@vger.kernel.org,
        Neil Brown <neilb@suse.de>, Uladzislau Rezki <urezki@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Mon, Nov 8, 2021 at 1:25 AM Michal Hocko <mhocko@suse.com> wrote:
>
> As already pointed out
> http://lkml.kernel.org/r/YXE+hcodJ7zxeYA7@dhcp22.suse.cz this patch
> cannot be applied without other patches from the same series.

Hmm. I've taken it already.

Not a huge deal, since it's a comment change - and the code will
presumably eventually match the updated comment.

I guess it's a new thing that instead of stale comments, we have
future-proof ones ;)

              Linus
