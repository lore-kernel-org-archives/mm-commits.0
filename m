Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F77BC433B4
	for <mm-commits@archiver.kernel.org>; Sun,  2 May 2021 19:08:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E7501611B0
	for <mm-commits@archiver.kernel.org>; Sun,  2 May 2021 19:08:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231801AbhEBTJ2 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 2 May 2021 15:09:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230036AbhEBTJ2 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 2 May 2021 15:09:28 -0400
Received: from mail-lf1-x131.google.com (mail-lf1-x131.google.com [IPv6:2a00:1450:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A8F1C06174A
        for <mm-commits@vger.kernel.org>; Sun,  2 May 2021 12:08:36 -0700 (PDT)
Received: by mail-lf1-x131.google.com with SMTP id 12so4899551lfq.13
        for <mm-commits@vger.kernel.org>; Sun, 02 May 2021 12:08:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=SIs9uTe9Pw65Rwj0eFe9uFITbVZp4r3OPiPsuStR0zA=;
        b=DBntENK19cpxww5h8xxfI8MfV8WB71ErCTIAjsOnRpaW2naaVUeUZMiWGsmYwX7cH5
         /02ZG8rLNdhQLgReU+yilgFxjYzB8ahoePiXlz3Our0MdM/GS8Ky6PknExmkSn2iKiOB
         biDw34jXDHHJINRLF40lu+9EnLbmpvAYraAUc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=SIs9uTe9Pw65Rwj0eFe9uFITbVZp4r3OPiPsuStR0zA=;
        b=N6fJRb7Rq3E7L7kBEn/vLEYYbAexXfOL+TlfgSXj7UPNxByNxurLzNJ8slnyJV72QR
         d6Dt7i34B262Xy0Vpg3wZpZ55ZtU/TfR/HhzSzaVWfIO8hUhRDpbqsobfoFpA6s88sDB
         dLGZ0W8QQqxXF161E56HXct9jRZ1fTZIzAdS0EQhnXgU8y23LET26BUm5ja3Y4KLs3oK
         I3b2DFNi9BGzpUTMsp2Jxdl9R6GHqtxSKY9XgOAD/+Z+Ng4BY/wnHLP6DbENbQm5C7V9
         VvcLdH61+G1dE279TSOq+3oZP6prUJw6Xeipa3pnEtanUeug4hzSbUQjTD3ySHdNCIzd
         5nww==
X-Gm-Message-State: AOAM531HtENFgJKdTtenFDAIuul0mAOiqJdwCyjQTqHHQMYTf2Z9zh9j
        EiKT2xgwJQQL9sJv9U+A5cRQoZarvPviQHPP
X-Google-Smtp-Source: ABdhPJyGZ9OBGUpIj3RLYdzCz8gJq+eo9sQXDq928pjPac9a8wU/iMQ/dLSsO1hi6ZX/mLk/OzyUZQ==
X-Received: by 2002:ac2:5098:: with SMTP id f24mr7232362lfm.243.1619982514657;
        Sun, 02 May 2021 12:08:34 -0700 (PDT)
Received: from mail-lf1-f41.google.com (mail-lf1-f41.google.com. [209.85.167.41])
        by smtp.gmail.com with ESMTPSA id t30sm793616ljd.98.2021.05.02.12.08.33
        for <mm-commits@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 02 May 2021 12:08:33 -0700 (PDT)
Received: by mail-lf1-f41.google.com with SMTP id 2so4953089lft.4
        for <mm-commits@vger.kernel.org>; Sun, 02 May 2021 12:08:33 -0700 (PDT)
X-Received: by 2002:ac2:5f92:: with SMTP id r18mr10964654lfe.253.1619982513635;
 Sun, 02 May 2021 12:08:33 -0700 (PDT)
MIME-Version: 1.0
References: <20210429225251.02b6386d21b69255b4f6c163@linux-foundation.org>
 <20210430060049.FrKVS3ZER%akpm@linux-foundation.org> <CAHk-=whhOEXyFGV7CfwB44etgYsb1vAkLhRrWb-mxjeUcqWu=g@mail.gmail.com>
 <20210502110456.238c3e175d35e4a6ce8a6088@linux-foundation.org>
In-Reply-To: <20210502110456.238c3e175d35e4a6ce8a6088@linux-foundation.org>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Sun, 2 May 2021 12:08:17 -0700
X-Gmail-Original-Message-ID: <CAHk-=wjLz7HtquTYwDkGegnOmeM=wXp-XC4sRM8d47K2YScJXw@mail.gmail.com>
Message-ID: <CAHk-=wjLz7HtquTYwDkGegnOmeM=wXp-XC4sRM8d47K2YScJXw@mail.gmail.com>
Subject: Re: [patch 148/178] kasan: detect false-positives in tests
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     Stephen Rothwell <sfr@canb.auug.org.au>,
        Andrey Konovalov <andreyknvl@google.com>,
        Andrey Ryabinin <aryabinin@virtuozzo.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        Marco Elver <elver@google.com>,
        Alexander Potapenko <glider@google.com>,
        Linux-MM <linux-mm@kvack.org>, mm-commits@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Sun, May 2, 2021 at 11:04 AM Andrew Morton <akpm@linux-foundation.org> w=
rote:
>
> Sorry, I fat-fingered a thing and used gcc-9, which disables CONFIG_KASAN=
.

My point is that linux-next would have caught it.

And that commit _was_ in linux-next.

But it was rebased literally just hours before being sent to me, and
thus all the testing that it got was thrown away.

> > Use the previous release as a base (ie in this case 5.12)
>
> Not a problem for the first batch of patches, but what base do I use for
> the second and succeeding batches?

Well, the first batch is usually the biggest and most core one, and in
many ways the most important that it would have been a branch of its
own, and be something that has actually been tested as-is in
linux-next.

Ad to succeeding batches.. Optimally if they don't have any
dependencies on other trees or the first batch, they'd actually
entirely independent of the first batch, and just a separate patch
queue entirely, and tested as such in linux-next (and again on top of
some previous base).

But that kind of workflow would require you literally have multiple
separate patch-queues that you test independently. That does sound
like a good idea, but it also sounds very much like a "git topic
branch" model, and I think quilt basically is a "single series" tool,
not able to handle multiple independent series?

I don't know quilt, and a quick google of "multiple independent quilt
patch series" ended up at a web page by Andreas Gr=C3=BCnbacher that was so
old that it was in Latin1 and doesn't even display properly on any
modern browser.

Which is a statement in itself, but whatever.

I'd actually be perfectly ok with being told that subsequent patches
be based on top of your previous patch series: I already create a
branch called "akpm" for applying all your patches, and while right
now it's a temporary branch that gets removed after I merge it, I
could easily just keep it around - and then apply your next series on
top of it.

So the only issues would be the things that actually end up being
dependent on other branches in linux-next:

> Maybe 10% of the patches I carry are based on changes which are in
> linux-next.

These are the ones that you'd have to keep separate, in order to not
rebase the patches that _aren't_ based on linux-next changes..

Again, I don't know how to do that with quilt (and iirc, you aren't
actually using quilt, you're using your own extended version?)

The quilt man-page does have some signs that there can be multiple
series of patches (wording like "current series" vs "another series",
and "Different series files can be used.."), but the actual quilt
commands don't really show much sign of switching between different
patch series. So I get the feeling that it's more of a "theoretically
possible" thing rather than something that is actually supported by
the tooling natively.

                Linus
