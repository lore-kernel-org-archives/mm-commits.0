Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3EB81C433EF
	for <mm-commits@archiver.kernel.org>; Wed, 24 Nov 2021 21:37:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352036AbhKXVku (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 24 Nov 2021 16:40:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352034AbhKXVki (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 24 Nov 2021 16:40:38 -0500
Received: from mail-oi1-x230.google.com (mail-oi1-x230.google.com [IPv6:2607:f8b0:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F9BDC06175D
        for <mm-commits@vger.kernel.org>; Wed, 24 Nov 2021 13:37:27 -0800 (PST)
Received: by mail-oi1-x230.google.com with SMTP id n66so8065771oia.9
        for <mm-commits@vger.kernel.org>; Wed, 24 Nov 2021 13:37:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=GmT72GG1kUilQF29pJLuOFWvP3uEpq4NuStRmi8ceuw=;
        b=KWMfu+n9FIQNscceD/1quJBgivLO1CppQ1vhhnu9AhmTj8Sk1ldM/MFdvfRLPtxn3C
         7trcoCifBC1Z0Yg+bDSdqkO8NYNEXnmltmbmKMvYST1Ojn9fWCLuCMCT0dYA348KcnfR
         405pckiPw5clKJbPZyccmB6y1fJZcco/41kojhOqk1qvDX9ql2m2AuhXZUl4Lp4RdYWj
         nMacmbWXp+6r/TeXszHoI+aEcNjNuQYUisc06OBzqmFuAd3XiIQxiHr0TTaIUn5Sj8Zf
         sYzaAQsTkiy2KY39qdnce397jNmB8jalModGSN706T2G4L+aKL+EpzIS9HDsktDcOXan
         UkBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=GmT72GG1kUilQF29pJLuOFWvP3uEpq4NuStRmi8ceuw=;
        b=jnRlFYCoNlcstheV/EO3aEPcQbG7iyC34s/4ddsWr2ab3TgjI6oysOJcRN7G3n2vRD
         LWlkXTmnvOja2P/8dUNlcvOsc07Hdj87iEcpf2BHt+PZweORCJSpIg5ZTknrOs7h0NWs
         cYhRcGr74TZDalqB14UcZyqKmQtjkijk/v1quiV9ZP7f4YQ4XwwH/vh1XN8kOaOW+glF
         uAmsfTSIWuecvgcQ88zHy7qeTxMcZ7whKw3lhrH505XKCoxanrUp6/eDXh5Ri8HHlPrL
         /bT69C/FztRI2gUO/ztzT5Az32JqOxYpejfaWRHtTidPNnAqkOq3RHPqbS5AalXHqtJN
         529A==
X-Gm-Message-State: AOAM530/xFH7krjm1bkmRE/kRFim2uEw8qxLHrBq8+oLNekMP/b2x65u
        3eJ69y5BBITvm6lwxvUxneuhF3lQdD1KwzF2bIk+zg==
X-Google-Smtp-Source: ABdhPJwqKPoOJeq27LRZ23g7UgBqFaa7SQHcF1JdUd35NaFIogRz9ZqWQp745qE8V7TyI+JP35xg5lYMU5Z3B6/AEEg=
X-Received: by 2002:a05:6808:1903:: with SMTP id bf3mr10113853oib.7.1637789846833;
 Wed, 24 Nov 2021 13:37:26 -0800 (PST)
MIME-Version: 1.0
References: <20211124212054.GQBSK_Ilb%akpm@linux-foundation.org>
In-Reply-To: <20211124212054.GQBSK_Ilb%akpm@linux-foundation.org>
From:   Marco Elver <elver@google.com>
Date:   Wed, 24 Nov 2021 22:37:15 +0100
Message-ID: <CANpmjNPnepsX=pt3FYkpUmSU3ZU2VSCraOyNKfUXveLhR+b15g@mail.gmail.com>
Subject: Re: + kasan-distinguish-kasan-report-from-generic-bug.patch added to
 -mm tree
To:     akpm@linux-foundation.org
Cc:     andreyknvl@gmail.com, dvyukov@google.com, glider@google.com,
        jirislaby@kernel.org, jkosina@suse.cz, mm-commits@vger.kernel.org,
        ryabinin.a.a@gmail.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Wed, 24 Nov 2021 at 22:20, <akpm@linux-foundation.org> wrote:
>
> The patch titled
>      Subject: kasan: distinguish kasan report from generic BUG()
> has been added to the -mm tree.  Its filename is
>      kasan-distinguish-kasan-report-from-generic-bug.patch
>
> This patch should soon appear at
>     https://ozlabs.org/~akpm/mmots/broken-out/kasan-distinguish-kasan-report-from-generic-bug.patch
> and later at
>     https://ozlabs.org/~akpm/mmotm/broken-out/kasan-distinguish-kasan-report-from-generic-bug.patch
>
> Before you just go and hit "reply", please:
>    a) Consider who else should be cc'ed
>    b) Prefer to cc a suitable mailing list as well
>    c) Ideally: find the original patch on the mailing list and do a
>       reply-to-all to that, adding suitable additional cc's
>
> *** Remember to use Documentation/process/submit-checklist.rst when testing your code ***
>
> The -mm tree is included into linux-next and is updated
> there every 3-4 working days
>
> ------------------------------------------------------
> From: Jiri Kosina <jkosina@suse.cz>
> Subject: kasan: distinguish kasan report from generic BUG()
>
> The typical KASAN report always begins with
>
>         BUG: KASAN: ....
>
> in kernel log.  That 'BUG:' prefix creates a false impression that it's an
> actual BUG() codepath being executed, and as such things like
> 'panic_on_oops' etc.  would work on it as expected; but that's obviously
> not the case.
>
> Switch the order of prefixes to make this distinction clear and avoid
> confusion.
>
> Link: https://lkml.kernel.org/r/nycvar.YFH.7.76.2111241839590.16505@cbobk.fhfr.pm
> Signed-off-by: Jiri Kosina <jkosina@suse.cz>
> Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
> Cc: Alexander Potapenko <glider@google.com>
> Cc: Andrey Konovalov <andreyknvl@gmail.com>
> Cc: Dmitry Vyukov <dvyukov@google.com>
> Cc: Jiri Slaby <jirislaby@kernel.org>
> Cc: Marco Elver <elver@google.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

Oh dear, I don't think we were ready -- this patch would cause all
kinds of issues:
https://lkml.kernel.org/r/CANpmjNOHN7SWu-pKGr9EBb3=in2AWiGmqNb6sYwhebGtRk+1uQ@mail.gmail.com

Apart from the high-level issues, it'd come with a long-tail of other
cleanups that are missing (docs, other tools, etc.) -- at the latest,
doing those would show that this change is a bad idea, and its
subjective improvements weighs against a real cost of long-tail
changes, changes that might mean tools, scripts, people, might miss
real bugs.

I would much rather see a central place in Documentation/
("error-reports.rst"?) list the various errors one could see, incl.
their panic behaviour and flags.

Thanks,
-- Marco
