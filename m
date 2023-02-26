Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2982EC64ED6
	for <mm-commits@archiver.kernel.org>; Sun, 26 Feb 2023 09:48:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229557AbjBZJsR (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 26 Feb 2023 04:48:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229504AbjBZJsQ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 26 Feb 2023 04:48:16 -0500
Received: from mail-qv1-f53.google.com (mail-qv1-f53.google.com [209.85.219.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2973B9EF6
        for <mm-commits@vger.kernel.org>; Sun, 26 Feb 2023 01:48:15 -0800 (PST)
Received: by mail-qv1-f53.google.com with SMTP id y3so2592542qvn.4
        for <mm-commits@vger.kernel.org>; Sun, 26 Feb 2023 01:48:15 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+MK1j3q1bOYhRpebu3QPIHs0qCKQ/DP+aQ0wHhoarFc=;
        b=aJQK7O1opyBL0LJMQ2XTdVAv7rdD67qvfTqxuW2BQeGE1TPIVsogy5fTlW+IEl+IXF
         vrnTfwfFZ4MDDOs9bzxVYeQNTTQMHypawbhgJFbr4JVbhJ0MKSX4hYStx0qrOwOOM+tB
         nEbZctcPPybKYzYdrpqB+hEi7zaTGFeQHfjfeMUcEwfIrTKORSGmUxZ6Yq31pC8+eBGr
         5vlqvPxeB7hm3m0fYzoD2DfjaKY2d97Hty641IBKSqnaE99HblBnbVb3Hhio3NZsJ3xp
         ageOwiwTO6dLMNxx+zafFEj6anN/M0gFITvMJ/zZsKADcKVfptqpXAVc+U9tz1KiEVFi
         JZhg==
X-Gm-Message-State: AO0yUKVjodKHcoViY1w3ujkZYXWddU/M6DuUAH8WqGcH546talxXaLbR
        7hG+Qhnu4QrehtY8b65alOG1YAfinGq9zQ==
X-Google-Smtp-Source: AK7set8Zf3zB9rQUX35aOieb4IavhyN52qbiUSzlXCwB6yH+57DVYXP/QzIbS/yGkAbtfFN+5h+3lw==
X-Received: by 2002:ad4:4ea2:0:b0:56e:9551:197f with SMTP id ed2-20020ad44ea2000000b0056e9551197fmr39316742qvb.2.1677404894101;
        Sun, 26 Feb 2023 01:48:14 -0800 (PST)
Received: from mail-yw1-f169.google.com (mail-yw1-f169.google.com. [209.85.128.169])
        by smtp.gmail.com with ESMTPSA id c20-20020ac853d4000000b003b62bc6cd1csm2666297qtq.82.2023.02.26.01.48.13
        for <mm-commits@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 26 Feb 2023 01:48:13 -0800 (PST)
Received: by mail-yw1-f169.google.com with SMTP id 00721157ae682-536bbef1c5eso98734387b3.9
        for <mm-commits@vger.kernel.org>; Sun, 26 Feb 2023 01:48:13 -0800 (PST)
X-Received: by 2002:a81:ad43:0:b0:533:91d2:9d94 with SMTP id
 l3-20020a81ad43000000b0053391d29d94mr8322491ywk.5.1677404893299; Sun, 26 Feb
 2023 01:48:13 -0800 (PST)
MIME-Version: 1.0
References: <20230226043107.5E7FBC433D2@smtp.kernel.org>
In-Reply-To: <20230226043107.5E7FBC433D2@smtp.kernel.org>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Sun, 26 Feb 2023 10:48:00 +0100
X-Gmail-Original-Message-ID: <CAMuHMdV+hrdkDb38z+zTMxFbCbpwutBHdoFQhpA05=_1gmL7mw@mail.gmail.com>
Message-ID: <CAMuHMdV+hrdkDb38z+zTMxFbCbpwutBHdoFQhpA05=_1gmL7mw@mail.gmail.com>
Subject: Re: + zram-show-zsmalloc-objs_moved-stat-in-mm_stat-fix.patch added
 to mm-unstable branch
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     mm-commits@vger.kernel.org, senozhatsky@chromium.org,
        minchan@kernel.org, axboe@kernel.dk, geert+renesas@glider.be
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

Hi Andrew,

On Sun, Feb 26, 2023 at 5:31 AM Andrew Morton <akpm@linux-foundation.org> wrote:
> The patch titled
>      Subject: zram: use atomic_long_read() to read atomic_long_t
> has been added to the -mm mm-unstable branch.  Its filename is
>      zram-show-zsmalloc-objs_moved-stat-in-mm_stat-fix.patch
>
> This patch will shortly appear at
>      https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/zram-show-zsmalloc-objs_moved-stat-in-mm_stat-fix.patch
>
> This patch will later appear in the mm-unstable branch at
>     git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
>
> Before you just go and hit "reply", please:
>    a) Consider who else should be cc'ed
>    b) Prefer to cc a suitable mailing list as well
>    c) Ideally: find the original patch on the mailing list and do a
>       reply-to-all to that, adding suitable additional cc's
>
> *** Remember to use Documentation/process/submit-checklist.rst when testing your code ***
>
> The -mm tree is included into linux-next via the mm-everything
> branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
> and is updated there every 2-3 working days
>
> ------------------------------------------------------
> From: Geert Uytterhoeven <geert+renesas@glider.be>
> Subject: zram: use atomic_long_read() to read atomic_long_t
> Date: Sat, 25 Feb 2023 13:15:23 +0100
>
> On 32-bit:
>
>     drivers/block/zram/zram_drv.c: In function `mm_stat_show':
>     drivers/block/zram/zram_drv.c:1234:23: error: passing argument 1 of `atomic64_read' from incompatible pointer type [-Werror=incompatible-pointer-types]
>      1234 |    (u64)atomic64_read(&pool_stats.objs_moved));
>           |                       ^~~~~~~~~~~~~~~~~~~~~~
>           |                       |
>           |                       atomic_long_t * {aka struct <anonymous> *}
>     In file included from ./include/linux/atomic.h:82,
>                      from ./include/linux/mm_types_task.h:13,
>                      from ./include/linux/mm_types.h:5,
>                      from ./include/linux/buildid.h:5,
>                      from ./include/linux/module.h:14,
>                      from drivers/block/zram/zram_drv.c:18:
>     ./include/linux/atomic/atomic-instrumented.h:644:33: note: expected `const atomic64_t *' {aka `const struct <anonymous> *'} but argument is of type `atomic_long_t *' {aka `struct <anonymous> *'}
>       644 | atomic64_read(const atomic64_t *v)
>           |               ~~~~~~~~~~~~~~~~~~^
>
> Fix this by using atomic_long_read() instead.
>
> Link: https://lkml.kernel.org/r/20230225121523.3288544-1-geert+renesas@glider.be
> Fixes: b7d89654a988a2a4 ("zram: show zsmalloc objs_moved stat in mm_stat")
> Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
> Reported-by; <noreply@ellerman.id.au>

Oops, I accidentally typed a semicolon instead of a colon.
That's actually better, as the noreply address is a real noreply
address, and bounces ;-)

> Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
> Cc: Jens Axboe <axboe@kernel.dk>
> Cc: Minchan Kim <minchan@kernel.org>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
