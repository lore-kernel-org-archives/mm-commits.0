Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4DA71C4361B
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 21:02:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 13A6522CB8
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 21:02:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727319AbgLOVBg (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 15 Dec 2020 16:01:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729408AbgLOVBX (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 15 Dec 2020 16:01:23 -0500
Received: from mail-lf1-x142.google.com (mail-lf1-x142.google.com [IPv6:2a00:1450:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08F79C0617A6
        for <mm-commits@vger.kernel.org>; Tue, 15 Dec 2020 13:00:43 -0800 (PST)
Received: by mail-lf1-x142.google.com with SMTP id m12so43021070lfo.7
        for <mm-commits@vger.kernel.org>; Tue, 15 Dec 2020 13:00:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=fSQeAg6tPJzLcK3KXcAXOVuPMc1zzbRR6apn0TkHgTA=;
        b=YW0QYN26q9GJARgroFU11PlfsfFIp7M3tozgzf56Acpv6qZEkYlxXuEhzIH5wc34AN
         x9PTeKKRqzTqVup/H+SGBNx2+Fy8g1vk9W/sMfGHyH/LL/zC5CFnbmaXYPY8PYoOClAH
         0yAQ989bUuVMMSpr3JsD/MRbEIVpdZCSXLyjk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=fSQeAg6tPJzLcK3KXcAXOVuPMc1zzbRR6apn0TkHgTA=;
        b=gvhCOufk8/OPZAjB9FP11q2F0WaaCJjbAX4FbFMKT/vD3CCasHOidpZYAHNeUlGuuT
         kD0dMZbaIUBZ/rWBI9pj0Fkb6PJ5GQu5J9Ib+wP6Vu3B18hGCxZv58FuTgjeF6XZEjmv
         IIV4+6/Vf0YtG6gnmUYVTri5eAwgDicA1RTpDemyd9/KE+oni0Zqq+rjmSUV/Cxy3ZI8
         0A1Y/MU4GcxHDvATjuXfimm0u8oaKqWYxpPVQBm/wq9I+oM17VvDyAqxxgiz6ZVI6olL
         zkls4f9YCuTvpsrejFvY1i0t+M8kp/j2LHI0+cjVfg8nF/1sXzfSiVDTOmGSg+KDeiB5
         O8zg==
X-Gm-Message-State: AOAM530DnoIu2vp6n44WsJ00Cc0m2I/YZCr9uu8rkAxdXsekEPpXshq7
        cTcvmVnP1H+7dmvuhnMaH9L2Ga9mlhYxxA==
X-Google-Smtp-Source: ABdhPJwhkYp+ogBtCSyC64f4XKNWTBayHhDVJyAcn6VqZSxiX7r9Md8Ka/PaKtypR2cSZa+2ZZaidg==
X-Received: by 2002:ac2:4bc1:: with SMTP id o1mr11852344lfq.232.1608066041170;
        Tue, 15 Dec 2020 13:00:41 -0800 (PST)
Received: from mail-lf1-f43.google.com (mail-lf1-f43.google.com. [209.85.167.43])
        by smtp.gmail.com with ESMTPSA id u8sm2921988ljj.1.2020.12.15.13.00.40
        for <mm-commits@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 15 Dec 2020 13:00:40 -0800 (PST)
Received: by mail-lf1-f43.google.com with SMTP id m25so42954454lfc.11
        for <mm-commits@vger.kernel.org>; Tue, 15 Dec 2020 13:00:40 -0800 (PST)
X-Received: by 2002:a2e:6f17:: with SMTP id k23mr13544003ljc.411.1608066039888;
 Tue, 15 Dec 2020 13:00:39 -0800 (PST)
MIME-Version: 1.0
References: <20201215123253.954eca9a5ef4c0d52fd381fa@linux-foundation.org>
In-Reply-To: <20201215123253.954eca9a5ef4c0d52fd381fa@linux-foundation.org>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Tue, 15 Dec 2020 13:00:23 -0800
X-Gmail-Original-Message-ID: <CAHk-=wjOFSGh-pa3Q2YOpvczOvLFW06nfmEYswO0=dFuOaQ=NA@mail.gmail.com>
Message-ID: <CAHk-=wjOFSGh-pa3Q2YOpvczOvLFW06nfmEYswO0=dFuOaQ=NA@mail.gmail.com>
Subject: Re: incoming
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     Linux-MM <linux-mm@kvack.org>, mm-commits@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Tue, Dec 15, 2020 at 12:32 PM Andrew Morton
<akpm@linux-foundation.org> wrote:
>
> - more MM work: a memcg scalability improvememt
>
> 19 patches, based on 148842c98a24e508aecb929718818fbf4c2a6ff3.

I'm not seeing patch 10/19 at all.

And patch 19/19 is corrupted and has an attachment with a '^P'
character in it. I could fix it up, but with the missing patch in the
middle I'm not going to even try. 'b4' is also very unhappy about that
patch 19/19.

I don't know what went wrong, but I'll ignore this send - please
re-send the series at your leisure, ok?

            Linus
