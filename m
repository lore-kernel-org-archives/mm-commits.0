Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C42F9C433EF
	for <mm-commits@archiver.kernel.org>; Sat, 15 Jan 2022 14:16:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232636AbiAOOQ1 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 15 Jan 2022 09:16:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231782AbiAOOQ1 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 15 Jan 2022 09:16:27 -0500
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88AFAC061574
        for <mm-commits@vger.kernel.org>; Sat, 15 Jan 2022 06:16:26 -0800 (PST)
Received: by mail-ed1-x536.google.com with SMTP id b13so45464725edn.0
        for <mm-commits@vger.kernel.org>; Sat, 15 Jan 2022 06:16:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=PrScd+2vEKmTKdZUNmTxKOvgm1+0xKJIeja/bnueszw=;
        b=YlB4c1nLOqoZL2Mm2zoMpK5xCrGq9d8w7qMCs4z22tdKBE2qKctOl3nRho2tjQus3i
         kEvJiuUJrnbiOHbNpSofWq1L834Q2GaM3cKNKT86xPDuvkXsui1gGILbnxkd7NYNE5eu
         P2iPVfd0h4tn+hiz7GzD7f1vX6WMWhKm4OqmU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=PrScd+2vEKmTKdZUNmTxKOvgm1+0xKJIeja/bnueszw=;
        b=cDm3yofqkuJzJcE9SFaT2KxJBlpik+BK21LDbeaQlPo/5EJqcpuE+lretx+wlIiRsR
         rd6Q/U/68bx4A8vGN1vt55BnfY1EIHyhu6d4tcBy6Cx7bPRBWpf+b2T91FESRs9dP89t
         VzfLWhVyNt8SQae5b916qx6OpIHGRtA/Js9NKz8p9X2AOtA2QH6qMZhBzqew/pZekKob
         +g6SdsWKs+4FTstMRrujqQSj/5lXwkAV2a+LpNWBg3Yl846e1bgVt8sd1Vb8NIJejA6A
         NL2jgkwrPRYriwNTHwcSTsV7mwPx2EVByI5Z1CJzTvXKux27LhZAlK5tEvJuE2xTnsRT
         Y4Rw==
X-Gm-Message-State: AOAM531F+WY34/IBh5gjfRc7k5TMY8xoZfWlLEpya0rX3B3CTCAPr+Su
        JzeMtkjxNoOUK6Z9QMfHX+WnxCGYg3W2tKFx2ek=
X-Google-Smtp-Source: ABdhPJxUFpvLrqVYxtNuBhxs6yIqiTfglLQJT2AZqMuCdvafJQxSEKuEM/dLL9+7a3JdX7SgDujFyw==
X-Received: by 2002:aa7:d507:: with SMTP id y7mr11180341edq.298.1642256185002;
        Sat, 15 Jan 2022 06:16:25 -0800 (PST)
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com. [209.85.128.49])
        by smtp.gmail.com with ESMTPSA id k16sm2654952ejk.172.2022.01.15.06.16.23
        for <mm-commits@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 15 Jan 2022 06:16:24 -0800 (PST)
Received: by mail-wm1-f49.google.com with SMTP id v123so11353946wme.2
        for <mm-commits@vger.kernel.org>; Sat, 15 Jan 2022 06:16:23 -0800 (PST)
X-Received: by 2002:a5d:4575:: with SMTP id a21mr12016883wrc.281.1642256183429;
 Sat, 15 Jan 2022 06:16:23 -0800 (PST)
MIME-Version: 1.0
References: <20220114140222.6b14f0061194d3200000c52d@linux-foundation.org> <20220114220555.kAbhSEmus%akpm@linux-foundation.org>
In-Reply-To: <20220114220555.kAbhSEmus%akpm@linux-foundation.org>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Sat, 15 Jan 2022 16:16:07 +0200
X-Gmail-Original-Message-ID: <CAHk-=wgH6jmhs=wtv8eEWcfw1NVvxwdt2h6fMKhRf75fiTW1Hw@mail.gmail.com>
Message-ID: <CAHk-=wgH6jmhs=wtv8eEWcfw1NVvxwdt2h6fMKhRf75fiTW1Hw@mail.gmail.com>
Subject: Re: [patch 056/146] mm: rearrange madvise code to allow for reuse
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     ccross@google.com, Dave Hansen <dave.hansen@intel.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>, gorcunov@openvz.org,
        Johannes Weiner <hannes@cmpxchg.org>,
        Hugh Dickins <hughd@google.com>, jan.glauber@gmail.com,
        John Stultz <john.stultz@linaro.org>,
        Kees Cook <keescook@chromium.org>,
        Linux-MM <linux-mm@kvack.org>, Mel Gorman <mgorman@suse.de>,
        Minchan Kim <minchan@kernel.org>,
        Ingo Molnar <mingo@kernel.org>, mm-commits@vger.kernel.org,
        Oleg Nesterov <oleg@redhat.com>,
        Pekka Enberg <penberg@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        David Rientjes <rientjes@google.com>,
        Rob Landley <rob@landley.net>, serge.hallyn@ubuntu.com,
        shli@fusionio.com, Suren Baghdasaryan <surenb@google.com>,
        Al Viro <viro@zeniv.linux.org.uk>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Sat, Jan 15, 2022 at 12:06 AM Andrew Morton
<akpm@linux-foundation.org> wrote:
>
> Speed up fork() by up to 40% by refcounting the anon vma name field.

What?

No.

This doesn't speed up anything at all.

The refcounting of the anon-vma name field avoids a 40% regression
that comes from adding the field in the first place, but this commit
message makes it sound like this series is speeding up fork() by 40%.

I don't mind the series, but I absolutely mind these kinds of horribly
misleading commit messages.

This is literally the first commit in the series - and the series in
no way improves performance by 40% in the end, it just first makes it
worse, and then fixes the regression.

I can speed up any function by a thousand percent - if I'm just
allowed to make it horribly slow first, and only count the final
speedup win when I remove the overhead of the garbage I added.

               Linus
