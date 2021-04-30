Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E751C433ED
	for <mm-commits@archiver.kernel.org>; Fri, 30 Apr 2021 18:33:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 24774613F7
	for <mm-commits@archiver.kernel.org>; Fri, 30 Apr 2021 18:33:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230329AbhD3Sd5 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 30 Apr 2021 14:33:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229750AbhD3Sdw (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 30 Apr 2021 14:33:52 -0400
Received: from mail-lf1-x129.google.com (mail-lf1-x129.google.com [IPv6:2a00:1450:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8F51C06174A
        for <mm-commits@vger.kernel.org>; Fri, 30 Apr 2021 11:33:02 -0700 (PDT)
Received: by mail-lf1-x129.google.com with SMTP id j10so18369620lfb.12
        for <mm-commits@vger.kernel.org>; Fri, 30 Apr 2021 11:33:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=P1Q7BrgOtfscywkg5hVce2+3guXdura6NsxZgt2BXPQ=;
        b=ghUSTWnV/xszGi51+GjhZMwQjv3qdRdMqSYN9LIkqgLV5KPrG+VjnGtbADfK1LmrIp
         YRwqJBjUp/Uy5HhEoka+hBk5fKZ+mSgxT3bexDrNzdicKrv/nhGO/Nj+ZNYu52WV0KQM
         TvoSIw5LXjBTwfmuto3eXFfjthwjQMW9AxyII=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=P1Q7BrgOtfscywkg5hVce2+3guXdura6NsxZgt2BXPQ=;
        b=nivAV0OU+Nqt7DaTOnEUhPLobkEaXULfCk7kog/cqWjxA54QCf0k9xy3TUvLGyOGWJ
         JVPqUqrYsPskUP03mKY+GCbZLD7maHr3evtIMb8P5KPKJOwNoKbBg+FmLbjIJdBCnVMl
         /2gV7tUBHB11MTgtieHzOb6ato5qVnqp89BnIOfTyKi/uQyTNo0/DvYm3sx1Z9/5i7c9
         idJkU09563sh0ejUmRMfUYaOXTEFKw8WffjAJwd8+GKaqL5K89/cGlLHaW7d3tI+539r
         1WNSrvlKh0CJcZN0JOzMG06GEW+Onmx34sDvBfQNcI+iX0Px8C16Es7zvFnkPqQrDYUK
         v8jA==
X-Gm-Message-State: AOAM531Vk3FnaY34D0PXW15u6rTdolSvyigc6dJuXXmHjoRUTelWDD3C
        BHJeXUp55V7LI7ojtqF9gjit6O5WRS7WJQPp
X-Google-Smtp-Source: ABdhPJwKFKG79OK/+BhBlKQL1nUI9Hpo1G+c5/bQeae9/+dHmqN51BwnmZJqaAhqMXVKC2Osr2PTbA==
X-Received: by 2002:a05:6512:108a:: with SMTP id j10mr4198470lfg.559.1619807581071;
        Fri, 30 Apr 2021 11:33:01 -0700 (PDT)
Received: from mail-lf1-f53.google.com (mail-lf1-f53.google.com. [209.85.167.53])
        by smtp.gmail.com with ESMTPSA id q2sm327148ljc.130.2021.04.30.11.33.00
        for <mm-commits@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 30 Apr 2021 11:33:00 -0700 (PDT)
Received: by mail-lf1-f53.google.com with SMTP id j10so18369536lfb.12
        for <mm-commits@vger.kernel.org>; Fri, 30 Apr 2021 11:33:00 -0700 (PDT)
X-Received: by 2002:a19:7504:: with SMTP id y4mr4054152lfe.41.1619807579878;
 Fri, 30 Apr 2021 11:32:59 -0700 (PDT)
MIME-Version: 1.0
References: <20210429225251.02b6386d21b69255b4f6c163@linux-foundation.org> <20210430060049.FrKVS3ZER%akpm@linux-foundation.org>
In-Reply-To: <20210430060049.FrKVS3ZER%akpm@linux-foundation.org>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Fri, 30 Apr 2021 11:32:43 -0700
X-Gmail-Original-Message-ID: <CAHk-=whhOEXyFGV7CfwB44etgYsb1vAkLhRrWb-mxjeUcqWu=g@mail.gmail.com>
Message-ID: <CAHk-=whhOEXyFGV7CfwB44etgYsb1vAkLhRrWb-mxjeUcqWu=g@mail.gmail.com>
Subject: Re: [patch 148/178] kasan: detect false-positives in tests
To:     Andrew Morton <akpm@linux-foundation.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Cc:     Andrey Konovalov <andreyknvl@google.com>,
        Andrey Ryabinin <aryabinin@virtuozzo.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        Marco Elver <elver@google.com>,
        Alexander Potapenko <glider@google.com>,
        Linux-MM <linux-mm@kvack.org>, mm-commits@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Thu, Apr 29, 2021 at 11:00 PM Andrew Morton
<akpm@linux-foundation.org> wrote:
>
> From: Andrey Konovalov <andreyknvl@google.com>
> Subject: kasan: detect false-positives in tests
>
> Currently, KASAN-KUnit tests can check that a particular annotated part of
> code causes a KASAN report.  However, they do not check that no unwanted
> reports happen between the annotated parts.
>
> This patch implements these checks.

No.

This patch does no such thing.

This patch is untested garbage that doesn't even compile.

> +       if (IS_ENABLED(CONFIG_KASAN_HW_TAGS)) {                         \
> +               if (READ_ONCE(fail_data.report_found))                  \
> +                       kasan_enable_tagging();                         \
> +               migrate_enable();                                       \

kasan_enable_tagging() was renamed to kasan_enable_tagging_sync() in commit

    2603f8a78dfb ("kasan: Add KASAN mode kernel parameter")

and this patch was clearly rebased onto current -git without any testing at all.

You can even see the effects of the rename in the patch itself, in
that the code it removes has the new name:

-       if (IS_ENABLED(CONFIG_KASAN_HW_TAGS) &&                 \
-           !kasan_async_mode_enabled()) {                      \
-               if (READ_ONCE(fail_data.report_found))          \
-                       kasan_enable_tagging_sync();            \

but then the patch re-introduces the old name in the new version of that code.

Andrew, you really need to stop using your garbage workflow of
randomly rebasing patches at the last minute.

In the cover letter, you clearly say:

  "178 patches, based on 8ca5297e7e38f2dc8c753d33a5092e7be181fff0."

where that commit was basically my top commit as of yesterday
afternoon - and that base very much has that rename in place.

So you rebased your patch series - apparently without any testing at
all - since that afternoon commit.

This *HAS* to stop.

If you use your old legacy "patch series" model, then dammit, stop
sending those patches on top of random commits. Pick a base, and
*STICK* to it. Make sure your patch series is actually *tested*.

Because I'd much rather handle conflicts and blame myself if I screw
something up during the merge, than get something from you that is
untested and may be subtly - or as in this case, very much not-subtly
- broken.

Right now, the way you work, all the work that Stephen Rothwell has
done to merge your patch series and have it tested in linux-next is
basically made almost entirely worthless, because you end up changing
your patches and rebasing it all the last minute, and all the testing
it got earlier is now thrown right out the window.

What used to be a perfectly cromulent patch is now garbage that
doesn't even compile.

I'm going to fix this one patch up by hand, but I really need you to
stop doing this. Use the previous release as a base (ie in this case
5.12), and don't do any last-minute rebasing. If you have patches in
your patch-series that depend on stuff that comes in this merge
window, just drop them - or at least don't send them to me.

Or better yet, base it on something even older than the release that
opens the merge window, so that you don't have to rebase anything
*during* the merge window, and so that your patch series actually gets
tested as-is in the real format in linux-next even before the merge
window opens. If you had created this series two weeks ago, marked it
as "ready for the 5.13 merge window", and it had been tested as such
in linux-next, we would have known about the conflict from linux-next,
and I'd have seen it as something that was trivial to fix when I did
the merge.

And that would catch all the cases that I can't catch, because
linux-next actually does a whole lot more build-testing than I do.
Different architectures, lots of different configs etc.

Instead, I applied a series of 178 patches (ok, 175 after I had
dropped a couple), saw nothing wrong, and did my (very basic and
minimal) build testing, and saw that the patches you sent to me didn't
even compile.

I bet a fixed workflow will make it easier for Stephen too, to not
continually have to rebase your series, and have a separate queue for
patch-series that get randomly updated.

I'm perfectly happy with you not using git - I apply patches from
others too. But I don't want to see this broken "rebase with no
testing" model. A patch queue that has its base changed has all the
same issues that a blind "git rebase" has, and is wrong for all the
same reasons - all whether you use git or not.

                 Linus
