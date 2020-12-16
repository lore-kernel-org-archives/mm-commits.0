Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3DB9C4361B
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 06:03:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9AB782333E
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 06:03:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725901AbgLPGD6 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 16 Dec 2020 01:03:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725813AbgLPGD6 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 16 Dec 2020 01:03:58 -0500
Received: from mail-lf1-x132.google.com (mail-lf1-x132.google.com [IPv6:2a00:1450:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF783C0617A7
        for <mm-commits@vger.kernel.org>; Tue, 15 Dec 2020 22:02:56 -0800 (PST)
Received: by mail-lf1-x132.google.com with SMTP id u18so45426622lfd.9
        for <mm-commits@vger.kernel.org>; Tue, 15 Dec 2020 22:02:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=4s4I0wawt+cNwoyrp/O3PVPPJ/CJpTwamZoPgPLOzKQ=;
        b=BAK0BiELB3aZRERB/BG4Vt3fmL1ydZs/PZ7FR2zYMjoPi5c5Ref/CNuy5exRu3nf7a
         oKEaoDLD1KfhhmHc3SEHODz1vqWW9jsBuY3MvUS8ufSL2yIlhRqHRIRx/kdy4VTg8WPj
         SvudJRpkLVJKfJikJMDygsLhVOycqIYBhiIC4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4s4I0wawt+cNwoyrp/O3PVPPJ/CJpTwamZoPgPLOzKQ=;
        b=NqXiHUPunyyPssPRZ1U/jj7VscJYivgipqhP83wgcr42wJ8adweYwZwh1WWRQ2WhPh
         emzVDO1vCEz6ZGmtWxDDwIJRdhs1VGaQYJ+ZWoI2o3Xnf0Fr3M2vAxZmr2t0ANeUFral
         ey7gD3Ck31vvOTu5Z9QYfPoFEs0BDzRJkQ3FtcaXVTMTZslrD2PTNrKNjppi9jMCRhfF
         SyaEH7Fw+hrS8TrVDoxloRBYki069W5HQ3JrOvJcdXlXrQmr3yBG2IoiKIB4Bg8t+Fat
         W/o2iWlujU4xhqVlob++9U1s5jBTd5VozVgvodc0wuafO6c8/PM3ZP3tGgSMI4eazVvn
         W55A==
X-Gm-Message-State: AOAM5314u4EiFc6gRdrrbKvqiqC6ABZCeT4cW7k3viQkCWW+JeE91huB
        1v3MY76WmLF5BAbaSi60nxgGv1vfruqLuQ==
X-Google-Smtp-Source: ABdhPJz6wqyQfixxvmuTw7mkb4Q6ZakJc/1N5wdCCuCaMQaLEg1GB9D8iNWTdMJP2zqCmHt+/MVX7Q==
X-Received: by 2002:a19:c8cd:: with SMTP id y196mr7048679lff.400.1608098574934;
        Tue, 15 Dec 2020 22:02:54 -0800 (PST)
Received: from mail-lf1-f54.google.com (mail-lf1-f54.google.com. [209.85.167.54])
        by smtp.gmail.com with ESMTPSA id m13sm150946ljo.121.2020.12.15.22.02.53
        for <mm-commits@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 15 Dec 2020 22:02:53 -0800 (PST)
Received: by mail-lf1-f54.google.com with SMTP id h205so1923613lfd.5
        for <mm-commits@vger.kernel.org>; Tue, 15 Dec 2020 22:02:53 -0800 (PST)
X-Received: by 2002:ac2:41d9:: with SMTP id d25mr11636171lfi.377.1608098573164;
 Tue, 15 Dec 2020 22:02:53 -0800 (PST)
MIME-Version: 1.0
References: <20201215204156.f05ec694b907845bcfab5c44@linux-foundation.org> <20201216044316.LYocMD9yH%akpm@linux-foundation.org>
In-Reply-To: <20201216044316.LYocMD9yH%akpm@linux-foundation.org>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Tue, 15 Dec 2020 22:02:37 -0800
X-Gmail-Original-Message-ID: <CAHk-=wgkA+jbWhDTdOTYAjhYZgBt1jZmxtAMrQUFHmaZGMOV+Q@mail.gmail.com>
Message-ID: <CAHk-=wgkA+jbWhDTdOTYAjhYZgBt1jZmxtAMrQUFHmaZGMOV+Q@mail.gmail.com>
Subject: Re: [patch 18/95] lib/list_kunit: follow new file name convention for
 KUnit tests
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Brendan Higgins <brendanhiggins@google.com>,
        Mark Brown <broonie@kernel.org>, davidgow@google.com,
        Linux-MM <linux-mm@kvack.org>, matti.vaittinen@fi.rohmeurope.com,
        mm-commits@vger.kernel.org, Shuah Khan <skhan@linuxfoundation.org>,
        vitor@massaru.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

This is complete garbage, Andrew.

In this patch, you change the name in the Makefile:

On Tue, Dec 15, 2020 at 8:43 PM Andrew Morton <akpm@linux-foundation.org> wrote:
>
> From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> Subject: lib/list_kunit: follow new file name convention for KUnit tests
>
> Follow new file name convention for the KUnit tests.  Since we have
> lib/*test*.c in a few variations, use 'kunit' suffix to distinguish usual
> test cases with KUnit-based ones.
...
> --- a/lib/Makefile~lib-list_kunit-follow-new-file-name-convention-for-kunit-tests
> +++ a/lib/Makefile
> @@ -350,6 +350,6 @@ obj-$(CONFIG_PLDMFW) += pldmfw/
>
>  # KUnit tests
>  obj-$(CONFIG_BITFIELD_KUNIT) += bitfield_kunit.o
> -obj-$(CONFIG_LIST_KUNIT_TEST) += list-test.o
> +obj-$(CONFIG_LIST_KUNIT_TEST) += list_kunit.o
>  obj-$(CONFIG_LINEAR_RANGES_TEST) += test_linear_ranges.o
>  obj-$(CONFIG_BITS_TEST) += test_bits.o

but the actual *file* isn't changed.

So there is no way in hell this will build.

The file is _actually_ renamed in patch [20/95], which claims to do
the lib/bits_kunit stuff, but actually does both the bits _and_ the
list_kunit stuff.

Making things worse, your use of substandard tools means that this
garbage shows up as a patch that is over sixteen *hundred* lines long,
when proper tooling would hav eactually shown it as a rename.

It _should_ have been about 10 lines total.  Not 1600 lines that hide
the problem and make it really nasty to see.

That 1600 lines of noise is ignoring patch [19/95], which does the
"linear_ranges_kunit" renaming, adding another ~500 lines of illegible
garbage to my mailbox.

At least that one got the Makefile right, although it was really hard
to actually see that, considering how nasty and illegible the patch
was due to renaming.

Basically, I'm going to throw all these rename patches away. Not only
were they were completely buggy, but they were also illegible because
of your inferior tools.

Don't send me any more rename patches until your tools can actually do renames.

            Linus
