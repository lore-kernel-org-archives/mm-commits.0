Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7FB41C433EF
	for <mm-commits@archiver.kernel.org>; Fri, 15 Apr 2022 22:11:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356305AbiDOWNk (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 15 Apr 2022 18:13:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233585AbiDOWNj (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 15 Apr 2022 18:13:39 -0400
Received: from mail-lf1-x130.google.com (mail-lf1-x130.google.com [IPv6:2a00:1450:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BB1443386
        for <mm-commits@vger.kernel.org>; Fri, 15 Apr 2022 15:11:10 -0700 (PDT)
Received: by mail-lf1-x130.google.com with SMTP id x33so15865056lfu.1
        for <mm-commits@vger.kernel.org>; Fri, 15 Apr 2022 15:11:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=2QtVXGfSn2N0rkhidefIOm+8RgDS4TB5h/qBI4Eiy4c=;
        b=QrGEuSyR0q+jdL2W8Yhgv/l15leR2PlJ+RE69Nk92ZEWjEl8top7q6+TqI0Qpj6GaE
         U9roWFN8VsX0OCnyj8L6IV78ggtpLzOOecvtS+46P4uqkAm4b5Zn2f4Ld/hwOYNyPxl3
         +GyIq814tNewte+DEdt9Cb/wYaupvpSLtaywU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=2QtVXGfSn2N0rkhidefIOm+8RgDS4TB5h/qBI4Eiy4c=;
        b=6YEEh00KumiXdMj3mOnQjwF6NJI8kesdfCi1kfndZOJyU6uejSVqPM4YHEZPkqEJRZ
         ZjXWOHNaE2F7LuZt0RKuzNWYOtfbXZ0+bAvC4yRJJb53QbNbZy8YMiNzP8SG3CaDGluO
         CqLnyHLhFRLyohFq4R/Rw0wxcbymmZP32DMztJSgSKWs8jDU5WmYiJCjbK0LxQCqCjBT
         QSttAtXaBXyXwd3GmhMpf304kdgZjYcFLTAYMFdQ9P+s3Ps5Y5QImvanu6ZVF4W0Jbva
         xpvXAcek9q9SJWg8bW+l+eVv/EDrlocrElexQ395wBw+ajZ3bmtYwO2E/nO0LNMCfRp4
         8akQ==
X-Gm-Message-State: AOAM531d8/bfkWqDMCOl8rnT+nre+aWh9y7zpOWgOZN9IFI0VJoGzc2k
        MYruajESKLeNt1yLBdnKTFEsYCaLCvRkgVxvvx4=
X-Google-Smtp-Source: ABdhPJwq6L9urCWMDrofMQ8u4FG7QPK2oJk+jJ+wn0KPlmkcEjoQ00WOb00KPGKyOhBbvHtFL/jMqQ==
X-Received: by 2002:a05:6512:ad6:b0:46b:8490:76ab with SMTP id n22-20020a0565120ad600b0046b849076abmr616103lfu.355.1650060668362;
        Fri, 15 Apr 2022 15:11:08 -0700 (PDT)
Received: from mail-lf1-f43.google.com (mail-lf1-f43.google.com. [209.85.167.43])
        by smtp.gmail.com with ESMTPSA id b19-20020a056512305300b0044a9638b343sm464333lfb.303.2022.04.15.15.11.07
        for <mm-commits@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 15 Apr 2022 15:11:08 -0700 (PDT)
Received: by mail-lf1-f43.google.com with SMTP id g19so1961666lfv.2
        for <mm-commits@vger.kernel.org>; Fri, 15 Apr 2022 15:11:07 -0700 (PDT)
X-Received: by 2002:a05:6512:3c83:b0:46d:452:5096 with SMTP id
 h3-20020a0565123c8300b0046d04525096mr653490lfv.542.1650060667675; Fri, 15 Apr
 2022 15:11:07 -0700 (PDT)
MIME-Version: 1.0
References: <20220414191240.9f86d15a3e3afd848a9839a6@linux-foundation.org> <20220415021328.7D31EC385A1@smtp.kernel.org>
In-Reply-To: <20220415021328.7D31EC385A1@smtp.kernel.org>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Fri, 15 Apr 2022 15:10:51 -0700
X-Gmail-Original-Message-ID: <CAHk-=wh=Mu_EYhtOmPn6AxoQZyEh-4fo2Zx3G7rBv1g7vwoKiw@mail.gmail.com>
Message-ID: <CAHk-=wh=Mu_EYhtOmPn6AxoQZyEh-4fo2Zx3G7rBv1g7vwoKiw@mail.gmail.com>
Subject: Re: [patch 02/14] tmpfs: fix regressions from wider use of ZERO_PAGE
To:     Andrew Morton <akpm@linux-foundation.org>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Borislav Petkov <bp@suse.de>
Cc:     patrice.chotard@foss.st.com, Mikulas Patocka <mpatocka@redhat.com>,
        markhemm@googlemail.com, Lukas Czerner <lczerner@redhat.com>,
        Christoph Hellwig <hch@lst.de>,
        "Darrick J. Wong" <djwong@kernel.org>,
        Chuck Lever <chuck.lever@oracle.com>,
        Hugh Dickins <hughd@google.com>, patches@lists.linux.dev,
        Linux-MM <linux-mm@kvack.org>, mm-commits@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Thu, Apr 14, 2022 at 7:13 PM Andrew Morton <akpm@linux-foundation.org> wrote:
>
> Revert shmem_file_read_iter() to using ZERO_PAGE for holes only when
> iter_is_iovec(); in other cases, use the more natural iov_iter_zero()
> instead of copy_page_to_iter().  We would use iov_iter_zero() throughout,
> but the x86 clear_user() is not nearly so well optimized as copy to user
> (dd of 1T sparse tmpfs file takes 57 seconds rather than 44 seconds).

Ugh.

I've applied this patch, but honestly, the proper course of action
should just be to improve on clear_user().

If it really is important enough that we should care about that
performance, then we just should fix clear_user().

It's a very odd special thing right now (at least on x86-64) using
some strange handcrafted inline asm code.

I assume that 'rep stosb' is the fastest way to clear things on modern
CPU's that have FSRM, and then we have the usual fallbacks (ie ERMS ->
"rep stos" except for small areas, and probably that "store zeros by
hand" for older CPUs).

Adding PeterZ and Borislav (who seem to be the last ones to have
worked on the copy and clear_page stuff respectively) and the x86
maintainers in case somebody gets the urge to just fix this.

Because memory clearing should be faster than copying, and the thing
that makes copying fast is that FSRM and ERMS logic (the whole
"manually unrolled copy" is hopefully mostly a thing of the past and
we can consider it legacy)

             Linus
