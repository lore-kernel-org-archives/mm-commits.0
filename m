Return-Path: <SRS0=ZqYO=EI=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02DECC388F9
	for <mm-commits@archiver.kernel.org>; Mon,  2 Nov 2020 20:14:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A1F5022268
	for <mm-commits@archiver.kernel.org>; Mon,  2 Nov 2020 20:13:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1604348039;
	bh=pJtmrMQLvkc7x1FBKzUdjauh9XyW1o3Raf0/V4RBZ5Q=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:Reply-To:List-ID:
	 From;
	b=0/lIbNjQ3hsLrp3hfSr77oEwMxO9pOfJsoBUsNMIy1ie9g9iknPJzJMh2FuYIhRRK
	 hiMdsLib7ftYNny6U0yfb4vsFJdT+7Tqu3Pl8lyC9tjzpLvNlI38lsuY/YTK1DaV7B
	 3G6WeuIGjK4zjQetWSWhFSEkAkkAQBWP81KKhEBs=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726720AbgKBUNy (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 2 Nov 2020 15:13:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726744AbgKBUNA (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 2 Nov 2020 15:13:00 -0500
Received: from mail-lf1-x143.google.com (mail-lf1-x143.google.com [IPv6:2a00:1450:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD20AC0617A6
        for <mm-commits@vger.kernel.org>; Mon,  2 Nov 2020 12:12:59 -0800 (PST)
Received: by mail-lf1-x143.google.com with SMTP id f9so19098790lfq.2
        for <mm-commits@vger.kernel.org>; Mon, 02 Nov 2020 12:12:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=BfkxRNzQnOQz526t0caSAxJWJI9EB2Dn3+3X+59nRvY=;
        b=BTHdDe/ZjX/qC5aHm0OqZtcdBHrIGftnZZmWgsu9gn7lwARE/V9mxpUy4noxzFLfCe
         VtAvMiSfaYzK07I8XXQO84s0N8BKOLOzGK3P+lDwyoFffEGHOeZCAnjI4H8LMg6c7Z3K
         5bimHK+ZzJxg27Fb4MsOQgQn69x9LJtupIADc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=BfkxRNzQnOQz526t0caSAxJWJI9EB2Dn3+3X+59nRvY=;
        b=mzsvbg1y9uDoBcVUIcRyrLWtBGVznAmi8IUsbKeqUDzhD9tbNEQneIvvi0/wL27b7p
         0Jx1PLLEbUKO+ds+oyk8dxe1MZYnVpgAOjZfEYuYfIuM+d9I0P7FoFMmWXRprHL6jTor
         OiXhGLtRMB3DvXPWyo9ro2NRyU/pC3vd2XCd+3f3vh0zQbJdxdut9ozkfXcvGqw+FtQL
         nb1R8Yb3CekbLeAWHFlR0Kxr1xIaFFk+L05QFBEn0UwtVKUKLYcly2xjjDHMRzltXDNT
         KSYZDNXUY1IjBqc5kBZLvWm83+OuWnkukOjc6z1qXOt3FcoUNJN1uHBZ/ssQKdDVs9fk
         aKzg==
X-Gm-Message-State: AOAM531y3zXQWkfxhHfbWftOQjK/EQQOAhZTrraeXrSnh41LefUDib6m
        9dPE/5BFRKXgH3zHsuUX+/dHA1niCOqaZg==
X-Google-Smtp-Source: ABdhPJxJMoQakFxpaqu9nn/yYbVbURTecVfmHjWV1XeowE88EDOwbuEj4H2JCq9HGgwEpJIu4v7dYg==
X-Received: by 2002:ac2:5ecc:: with SMTP id d12mr6707354lfq.487.1604347977768;
        Mon, 02 Nov 2020 12:12:57 -0800 (PST)
Received: from mail-lf1-f49.google.com (mail-lf1-f49.google.com. [209.85.167.49])
        by smtp.gmail.com with ESMTPSA id a77sm2655743lfd.77.2020.11.02.12.12.53
        for <mm-commits@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 02 Nov 2020 12:12:53 -0800 (PST)
Received: by mail-lf1-f49.google.com with SMTP id 184so19066436lfd.6
        for <mm-commits@vger.kernel.org>; Mon, 02 Nov 2020 12:12:53 -0800 (PST)
X-Received: by 2002:ac2:5f48:: with SMTP id 8mr6842069lfz.344.1604347973214;
 Mon, 02 Nov 2020 12:12:53 -0800 (PST)
MIME-Version: 1.0
References: <20201101170656.48abbd5e88375219f868af5e@linux-foundation.org>
 <20201102010804.uENOQsZO9%akpm@linux-foundation.org> <CAHk-=wjweewYgnT2MX2iqbj2+7QamHH+pdMQGvr3duPL5a_dvA@mail.gmail.com>
 <CACSApvZmNAOCUEEs051G7bc9-JbSv1auh+xUvuitP6LkWfn-5w@mail.gmail.com>
 <CAHk-=wh3FcWMRAt-WGYcKP-YxLDBkpbNtVzLrm+=t6xixV+A9w@mail.gmail.com> <CACSApvZiWLAzSpkkBSo9=U_Fpx85_xCryaDh+sFsr7Uw8-RjUg@mail.gmail.com>
In-Reply-To: <CACSApvZiWLAzSpkkBSo9=U_Fpx85_xCryaDh+sFsr7Uw8-RjUg@mail.gmail.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Mon, 2 Nov 2020 12:12:37 -0800
X-Gmail-Original-Message-ID: <CAHk-=wh826P9cz0g_FGRCbz1ZE4pfhCHuQBQ-J_BBxeo5x94vQ@mail.gmail.com>
Message-ID: <CAHk-=wh826P9cz0g_FGRCbz1ZE4pfhCHuQBQ-J_BBxeo5x94vQ@mail.gmail.com>
Subject: Re: [patch 13/15] epoll: check ep_events_available() upon timeout
To:     Soheil Hassas Yeganeh <soheil@google.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Davidlohr Bueso <dave@stgolabs.net>,
        Eric Dumazet <edumazet@google.com>,
        Guantao Liu <guantaol@google.com>,
        Khazhismel Kumykov <khazhy@google.com>,
        Linux-MM <linux-mm@kvack.org>, mm-commits@vger.kernel.org,
        Al Viro <viro@zeniv.linux.org.uk>,
        Willem de Bruijn <willemb@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Mon, Nov 2, 2020 at 11:55 AM Soheil Hassas Yeganeh <soheil@google.com> wrote:
>
> Given that you're calling ep_events_available() under lock, I think
> this should address the inefficiency for the non-racy timeout case,  I
> mentioned above. The remaining races are preexisting and all result in
> spurious events, which should be fine.

Well, they might result in not seeing events that are there, but for
that case we end up going the logn way around and doing the "wait for
events" code, and that should take care of it, I guess.

So it's racy, but it gets fixed up later regardless of which way it
races, I think.

It might be worth a comment or two.

And that "goto fetch_events" thing might be worth writing as an actual
loop, rather than the pointless one I removed.

I suspect that old pointless loop might have been historical (some
kind of "loop waiting for event"), since that's how those things are
usually written. I didn't go and look at the history.

Anyway, I've dropped the original 13/15 patch, buit I'll apply the
test-case one (14/15) even if it might now fail in the current state.

I hope that you will end up submitting some cleaned-up (and tested!)
version of that patch I cobbled together - I'll archive this thread
for now on the assumption that the resolution of all this will come
back to me later...

                     Linus
