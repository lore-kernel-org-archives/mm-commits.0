Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD7CEC433E0
	for <mm-commits@archiver.kernel.org>; Mon, 21 Dec 2020 18:08:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AE5AB22C9C
	for <mm-commits@archiver.kernel.org>; Mon, 21 Dec 2020 18:08:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726089AbgLUSI0 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 21 Dec 2020 13:08:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726068AbgLUSIZ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 21 Dec 2020 13:08:25 -0500
Received: from mail-lf1-x129.google.com (mail-lf1-x129.google.com [IPv6:2a00:1450:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 331BAC061793
        for <mm-commits@vger.kernel.org>; Mon, 21 Dec 2020 10:07:45 -0800 (PST)
Received: by mail-lf1-x129.google.com with SMTP id 23so25772035lfg.10
        for <mm-commits@vger.kernel.org>; Mon, 21 Dec 2020 10:07:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=KSdljTjymKKnTapVF+sKk87RkP5UuD4TaIfVlLb14fo=;
        b=IFzCv67rRRZ13xDAW6tqEP/ajJ26VSEHf66aLpo1faY4UItdMHIzoBge/RfVinANCx
         d9TGpyWVGDg4ncah8idFM1nrNHO2LRDqGavIqHOVe7QzVEPwWahUSTwKcMMVWB7PISdc
         bf1BQINgBeRZnvEvdhLuucOzZFGA3YEZjBGok=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=KSdljTjymKKnTapVF+sKk87RkP5UuD4TaIfVlLb14fo=;
        b=A/zjyNcjcUCCKYojtRgwUutryNgGTuWOgyAFOP7rMI9dQ4LYfqUTh+VhwvJ0U9/9gt
         Qww3UH0G0EH/rmwes9r+OCDHQbN1UPxTsAl9wPSbsZOyrnNZPBj/Z5GLUq23SxGjBmsT
         DAQCGwi/MTVnORHA0ZtOkIZOItygTMT1GCEIkHSKaEgaqyZ+aiDCE1jz41njM0HG6k7s
         lBGTBgDxYhcDCPup6DNCE6y8Kwlfdr1E7rUVqCTol+FxKxhxI6baq9lbT3fQzqm6/6N2
         DLz1OJtjaB2YZs9nhMqWUiKEACOD3nlMZ9Gktf5Dy9UONt+9eBjS8JbdGvPVV6kUjcjK
         ojNA==
X-Gm-Message-State: AOAM5328vZ+cn+5Cf8Cecq17abMdu4EtpDua8tsNHZTih7hL/rM58x1b
        NEfWl+F0LJtR4vzldVgzGN0HhwpdbZvJjg==
X-Google-Smtp-Source: ABdhPJwb3GT1webryuPRupeH5wNj9KNooXdz1OUQoXocOUIz0F6CiRkUZFvrt/8aNNOciezboJ693A==
X-Received: by 2002:a19:4a13:: with SMTP id x19mr6704756lfa.648.1608572515087;
        Mon, 21 Dec 2020 09:41:55 -0800 (PST)
Received: from mail-lf1-f45.google.com (mail-lf1-f45.google.com. [209.85.167.45])
        by smtp.gmail.com with ESMTPSA id y3sm2151296lfy.73.2020.12.21.09.41.53
        for <mm-commits@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 21 Dec 2020 09:41:53 -0800 (PST)
Received: by mail-lf1-f45.google.com with SMTP id o13so25663152lfr.3
        for <mm-commits@vger.kernel.org>; Mon, 21 Dec 2020 09:41:53 -0800 (PST)
X-Received: by 2002:a19:8557:: with SMTP id h84mr6835799lfd.201.1608572513193;
 Mon, 21 Dec 2020 09:41:53 -0800 (PST)
MIME-Version: 1.0
References: <20201218140046.497484741326828e5b5d46ec@linux-foundation.org>
 <20201218220233.pgX0nYYVt%akpm@linux-foundation.org> <X91JLZhrXYaLzoB8@elver.google.com>
 <20201218171327.180140338d183b41a962742d@linux-foundation.org>
 <CAHk-=whK70LHzMw5SxUu_1NHkWtZc-o1PHyotkmwR49e2Jh6rw@mail.gmail.com> <CAG_fn=UuweEsetS8o-wwrke=9JQOxFvDvjRjG9Y8YG+5bLpfOA@mail.gmail.com>
In-Reply-To: <CAG_fn=UuweEsetS8o-wwrke=9JQOxFvDvjRjG9Y8YG+5bLpfOA@mail.gmail.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Mon, 21 Dec 2020 09:41:37 -0800
X-Gmail-Original-Message-ID: <CAHk-=whJodNM=W7xWNKQFofsV5pXbozaAwrs2hGa=Bi=8n18ZQ@mail.gmail.com>
Message-ID: <CAHk-=whJodNM=W7xWNKQFofsV5pXbozaAwrs2hGa=Bi=8n18ZQ@mail.gmail.com>
Subject: Re: [patch 21/78] kasan: split out shadow.c from common.c
To:     Alexander Potapenko <glider@google.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Marco Elver <elver@google.com>,
        Andrey Konovalov <andreyknvl@google.com>,
        Andrey Ryabinin <aryabinin@virtuozzo.com>,
        Branislav Rankov <Branislav.Rankov@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        Evgeniy Stepanov <eugenis@google.com>,
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

On Mon, Dec 21, 2020 at 1:46 AM Alexander Potapenko <glider@google.com> wrote:
>
> It would be a pity to punt that big chunk of MTE-related work the
> folks did just because of the leftover KFENCE bits, we didn't mean to.

Note that it wasn't just the kfence bits - that was only a symptom of
the problem.

The real problem is that Andrew apparently doesn't have a
KASAN-capable setup right now, so he isn't building what he sends me.

linux-next ends up building the end result, of course, but that's the
full series, and the smaller sequences don't get any build testing.

              Linus
