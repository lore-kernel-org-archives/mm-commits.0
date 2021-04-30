Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35A39C43460
	for <mm-commits@archiver.kernel.org>; Fri, 30 Apr 2021 16:32:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0FB606146D
	for <mm-commits@archiver.kernel.org>; Fri, 30 Apr 2021 16:32:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230331AbhD3Qcu (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 30 Apr 2021 12:32:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229720AbhD3Qct (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 30 Apr 2021 12:32:49 -0400
Received: from mail-lj1-x22a.google.com (mail-lj1-x22a.google.com [IPv6:2a00:1450:4864:20::22a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C855FC06174A
        for <mm-commits@vger.kernel.org>; Fri, 30 Apr 2021 09:31:59 -0700 (PDT)
Received: by mail-lj1-x22a.google.com with SMTP id o16so81519106ljp.3
        for <mm-commits@vger.kernel.org>; Fri, 30 Apr 2021 09:31:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=F8v+HHXbjl0aRx+srFPe53CclqNI7DAhH0N8QQsA8Lw=;
        b=B7bKcjbrRTZhgdTtCvlTiUk1WdGQherh0Mmc11ZSTTyN6h/ihUK+x7gawKbOvc05+0
         UHA+KICT8A3M7D1COJUntw+wVyCiR+SfNXfOMnIoqnfAjje5li82NU2RjExsufGjxuRG
         FPSphBrQCXtSZaAg0mwSvj9E0f7SrgUf5bDlk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=F8v+HHXbjl0aRx+srFPe53CclqNI7DAhH0N8QQsA8Lw=;
        b=NtBqd2dOs1qCJmBCNl6t+OhpYaKyyVb/4jhfaS4hDWLyExIncFqM7fnB+6IE3eXiQR
         TwshGcr/+Tfx+25q/bhg25tPZf6FrgbUgElqgnA9Pgj6Rwg33gzVTrQHoCsFbISUThBU
         Fhl/lOsKONvXR5+wdORs6LSyc7hA+46iaOplwoSRy3xdflHthKNlUMTfJQxxlEKCCM8M
         5DPw7Tn8YDSp+E1xuZMdphnNpmPkc5irJOfiSwrg9QiJj6d6J7V0g2Km7Em4+yHB5Xhe
         B/l17tD245wypbPpu2LxCBYeHRcYlmHB5NzvWmIn4H4OXZZ4azFAJTWkMj7a3zP+uk0q
         jB6w==
X-Gm-Message-State: AOAM5331UL52M/Yfj9vDgwVvf3Cg9G6Guvko6IlJvOKst+hWkAbk4rPK
        dhZ5EzAmCcE4zuKd/5nzGpccp40u8/8PCHON
X-Google-Smtp-Source: ABdhPJxV1UQw0XEyKytSWfKYy/3r4JOas3Lx8LaHhrAj8nlszbKevzLwu56afjvRQiXARJjId76iLg==
X-Received: by 2002:a2e:b4b4:: with SMTP id q20mr4354704ljm.327.1619800317679;
        Fri, 30 Apr 2021 09:31:57 -0700 (PDT)
Received: from mail-lf1-f42.google.com (mail-lf1-f42.google.com. [209.85.167.42])
        by smtp.gmail.com with ESMTPSA id d30sm328027lfv.198.2021.04.30.09.31.56
        for <mm-commits@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 30 Apr 2021 09:31:56 -0700 (PDT)
Received: by mail-lf1-f42.google.com with SMTP id x20so80722019lfu.6
        for <mm-commits@vger.kernel.org>; Fri, 30 Apr 2021 09:31:56 -0700 (PDT)
X-Received: by 2002:a05:6512:1095:: with SMTP id j21mr3707653lfg.40.1619800316007;
 Fri, 30 Apr 2021 09:31:56 -0700 (PDT)
MIME-Version: 1.0
References: <20210430055445.hpofzhr9G%akpm@linux-foundation.org> <dbbb7b43-37fa-b026-45af-b10cc0672ccb@suse.cz>
In-Reply-To: <dbbb7b43-37fa-b026-45af-b10cc0672ccb@suse.cz>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Fri, 30 Apr 2021 09:31:39 -0700
X-Gmail-Original-Message-ID: <CAHk-=wjSg6EPqKTM9_cGzVLZXhy9SMDYwcvF3tu+xNq9EQD1oA@mail.gmail.com>
Message-ID: <CAHk-=wjSg6EPqKTM9_cGzVLZXhy9SMDYwcvF3tu+xNq9EQD1oA@mail.gmail.com>
Subject: Re: [patch 030/178] kunit: add a KUnit test for SLUB debugging functionality
To:     Vlastimil Babka <vbabka@suse.cz>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Christoph Lameter <cl@linux.com>, glittao@gmail.com,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Linux-MM <linux-mm@kvack.org>, mm-commits@vger.kernel.org,
        Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Fri, Apr 30, 2021 at 1:50 AM Vlastimil Babka <vbabka@suse.cz> wrote:
>
> Hi, but this is v3 [1]. Then there was v4 [2] (with a prerequisity [3]) with
> many changes after feedback with kunit folks, which would be better. We could
> apply v4 as improvement later but there would be extra churn (even the test .c
> file is named differently). Merging v4 directly would make more sense.
>
> Anyway "[patch 031/178] slub: remove resiliency_test() function" (which the
> kunit test replaces) can go either way as that code is dead and broken.

I've removed patches 30 and 31 from the queue.

                 Linus
