Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9E8EC4361B
	for <mm-commits@archiver.kernel.org>; Sat, 19 Dec 2020 19:18:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A680B23406
	for <mm-commits@archiver.kernel.org>; Sat, 19 Dec 2020 19:18:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727375AbgLSTSh (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 19 Dec 2020 14:18:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727305AbgLSTSg (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 19 Dec 2020 14:18:36 -0500
Received: from mail-lf1-x131.google.com (mail-lf1-x131.google.com [IPv6:2a00:1450:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6781CC0613CF
        for <mm-commits@vger.kernel.org>; Sat, 19 Dec 2020 11:17:56 -0800 (PST)
Received: by mail-lf1-x131.google.com with SMTP id l11so14192854lfg.0
        for <mm-commits@vger.kernel.org>; Sat, 19 Dec 2020 11:17:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=gcAhDuZrKnZqDHtczSiTXKhkaKN6g1/mcTOt8pUC1rM=;
        b=hWJHNKVhGJIn0+K3SDKjiJJtSxeZQf9utCIzXVaUnuCKA655fWbguJ1ZS5VNqWvOZU
         RNZPPQCATeZDkcCaC6qC+8oNWe6Tbdp34BECIQCPBvJh+VntnrJy2iXLNCGRqZJPuN24
         HwsWsJlXknT4bMxc16FmyGPQDxfLURc61rDFI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=gcAhDuZrKnZqDHtczSiTXKhkaKN6g1/mcTOt8pUC1rM=;
        b=FwcbW8Pd20QvcdN6zc2uXYQWWig5kbSFXSPeA6WCrmyDAlOg/VuWlTjn1CmY/TeciS
         2jFPoUVRjsanOIOCeWwQR82FNzo2q72muE/CDxIQmMI4w8dRYwL56vn64QZLcuC6g2pm
         ElVciKl8O2b82/WXepRwBzQdko4bKFUbJxStnK9D2nhew/rwBnhj4fiLVHzFPnbAWw03
         pAaRX+HTUKq1O6ILOdA705nbv4JL0CfYNY61e21vMhDdOLpyzOe6OH3OACxTTE6ebTeU
         H+tioErnJRGRVDudS6MKwOD6GSYzIzFGs2NPNe/tgMbkN+zhOIkjzJoypTRWQlb4aQXj
         SYRA==
X-Gm-Message-State: AOAM532o0m+QKtSgl2tA9JYX9TgPxk34euzU+ip545x2JeOdKUwY2SmU
        sLzOgAF/gID8kM3ytzMTHSPn2N1v2h82rA==
X-Google-Smtp-Source: ABdhPJww7rK5xNtRsaGG+Cu2W0WLa/p+INFYhKx7sfxt6ni1G+WTvoaCvnjjHauAX6EyumTQJEftyw==
X-Received: by 2002:a2e:b4ba:: with SMTP id q26mr4285717ljm.117.1608405474423;
        Sat, 19 Dec 2020 11:17:54 -0800 (PST)
Received: from mail-lf1-f45.google.com (mail-lf1-f45.google.com. [209.85.167.45])
        by smtp.gmail.com with ESMTPSA id b141sm1389604lfg.123.2020.12.19.11.17.52
        for <mm-commits@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 19 Dec 2020 11:17:53 -0800 (PST)
Received: by mail-lf1-f45.google.com with SMTP id o17so14143472lfg.4
        for <mm-commits@vger.kernel.org>; Sat, 19 Dec 2020 11:17:52 -0800 (PST)
X-Received: by 2002:a2e:6f17:: with SMTP id k23mr4271822ljc.411.1608405472606;
 Sat, 19 Dec 2020 11:17:52 -0800 (PST)
MIME-Version: 1.0
References: <20201218140046.497484741326828e5b5d46ec@linux-foundation.org>
 <20201218220233.pgX0nYYVt%akpm@linux-foundation.org> <X91JLZhrXYaLzoB8@elver.google.com>
 <20201218171327.180140338d183b41a962742d@linux-foundation.org>
In-Reply-To: <20201218171327.180140338d183b41a962742d@linux-foundation.org>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Sat, 19 Dec 2020 11:17:36 -0800
X-Gmail-Original-Message-ID: <CAHk-=whK70LHzMw5SxUu_1NHkWtZc-o1PHyotkmwR49e2Jh6rw@mail.gmail.com>
Message-ID: <CAHk-=whK70LHzMw5SxUu_1NHkWtZc-o1PHyotkmwR49e2Jh6rw@mail.gmail.com>
Subject: Re: [patch 21/78] kasan: split out shadow.c from common.c
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     Marco Elver <elver@google.com>,
        Andrey Konovalov <andreyknvl@google.com>,
        Andrey Ryabinin <aryabinin@virtuozzo.com>,
        Branislav.Rankov@arm.com,
        Catalin Marinas <catalin.marinas@arm.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        Evgeniy Stepanov <eugenis@google.com>,
        Alexander Potapenko <glider@google.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Kevin Brodsky <kevin.brodsky@arm.com>,
        Linux-MM <linux-mm@kvack.org>, mm-commits@vger.kernel.org,
        Vincenzo Frascino <vincenzo.frascino@arm.com>,
        Will Deacon <will.deacon@arm.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Fri, Dec 18, 2020 at 5:13 PM Andrew Morton <akpm@linux-foundation.org> wrote:
>
> Sigh.  I don't have access to my capable-of-compiling-KASAN machine at
> present :(  We'll need this, yes?

Four of the patches in this patch-bomb mention the not-yet-existing
kfence.h header. This plus two others have it in the actual patch. The
fourth has it only as context.

Two others mention kfence in some form or another.

I think I'll drop all the kasan-related patches (and that's most of
it), and basically only keep the memcg and epoll ones from this
series.

(That cuts the series of 78 down to 17 - and I haven't actually
verified that even that smaller subset is entirely independent of the
dropped patches yet).

            Linus
