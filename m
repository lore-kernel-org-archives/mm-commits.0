Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 303F4C4361B
	for <mm-commits@archiver.kernel.org>; Tue,  8 Dec 2020 05:11:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D94A423A5E
	for <mm-commits@archiver.kernel.org>; Tue,  8 Dec 2020 05:11:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725906AbgLHFLh (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 8 Dec 2020 00:11:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725791AbgLHFLh (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 8 Dec 2020 00:11:37 -0500
Received: from mail-lf1-x12f.google.com (mail-lf1-x12f.google.com [IPv6:2a00:1450:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64585C061749
        for <mm-commits@vger.kernel.org>; Mon,  7 Dec 2020 21:10:56 -0800 (PST)
Received: by mail-lf1-x12f.google.com with SMTP id y19so9238662lfa.13
        for <mm-commits@vger.kernel.org>; Mon, 07 Dec 2020 21:10:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=D4NgStrwuYaxHF0il5RKENbbYOTbCI3yPJElcCQuQ+Q=;
        b=b5EJvm/I8BSphQoXP25dFf/Z9var1FDx3VmBFOVgdzmTBpc/pb9q3BG0bpfq+f4fPS
         LC1glLZnQ0kiOppx83mgJsGDMV31wv9nM1af6mXsuJNwcLGZq2lhtgZaw2vfyQS+XNT3
         qHS+UCXaT/Ih71HBF8TqnukB3T2gMZOOPvkgLX2izPncGkR3WJs6e62ItOm6NYF/SEib
         wnV7clFkNnPqCNVpSnPqPLjPS6fv2IOlPS6gQqyjbPs+0p6Om5xACgbysm6lRcvj+57l
         p9+ObXWEhizthQbq1F6BpU3AXX/rtunjE4kqE305puN/8BuuLsSme3o6WhpAz8+k7V8b
         Ieig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=D4NgStrwuYaxHF0il5RKENbbYOTbCI3yPJElcCQuQ+Q=;
        b=MqMP8DcYCJuoYrXdKYfJ/WXaDGSLR7+bg12GwU2YuXLec7FMWQ2IFUW0k8HF3fLnBG
         VQXCemM30c/FJjqoTEBLkeKJqFCJjZG0naQiV+FfQ7F6c59OmqMAFcx3/l0x4d/gjv8o
         2KnRzRJXGJL1kFDBgK4X+BJrejOdiUJ/z3AUs7j3TFVFRdUx0AA7CDn8WqhKjQeQwF3A
         5244U31SDcdunUKxCzHasCdRIYo9F2dInVH47xpCH43aqfHk/lBDqttDr+Dy9NDRuU/p
         5LNdPUoT+ERLM7ZlzDn5JvCVSt22d43aX0uJYY+VJefhCiYf72B+tA2IjHD1ptKQeidG
         Rp6Q==
X-Gm-Message-State: AOAM531lXZ9wb4gM0QqSW2ou95pp39z1EQHEWp90VrzqSzgoT+880yWn
        3r9sWcC8/x8MEQqzNkkrTpBWuHSAIzWPYbaDm7A=
X-Google-Smtp-Source: ABdhPJyoSkOG8ThsGcilW2VzPE600be3nOg4lm/lXBZg7yBvSvFM5FAqLcLYEBqUJ4+9I5V/5BDtruvcLFWUF8Addpg=
X-Received: by 2002:a19:cbc3:: with SMTP id b186mr4736955lfg.554.1607404254859;
 Mon, 07 Dec 2020 21:10:54 -0800 (PST)
MIME-Version: 1.0
References: <20201208034157.9KFja%akpm@linux-foundation.org>
In-Reply-To: <20201208034157.9KFja%akpm@linux-foundation.org>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Mon, 7 Dec 2020 21:10:43 -0800
Message-ID: <CAADnVQ+df8-oWdZi-uWUyjNZqFY9YdhRO9ipn7Rse80dH_HGQQ@mail.gmail.com>
Subject: Re: + revert-mm-filemap-add-static-for-function-__add_to_page_cache_locked.patch
 added to -mm tree
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     mm-commits@vger.kernel.org, Michal Kubecek <mkubecek@suse.cz>,
        jrdr.linux@gmail.com, Josef Bacik <josef@toxicpanda.com>,
        Justin Forbes <jmforbes@linuxtx.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>, alex.shi@linux.alibaba.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Mon, Dec 7, 2020 at 7:41 PM <akpm@linux-foundation.org> wrote:
>
>
> The patch titled
>      Subject: revert "mm/filemap: add static for function __add_to_page_cache_locked"
> has been added to the -mm tree.  Its filename is
>      revert-mm-filemap-add-static-for-function-__add_to_page_cache_locked.patch
>
> This patch should soon appear at
>     https://ozlabs.org/~akpm/mmots/broken-out/revert-mm-filemap-add-static-for-function-__add_to_page_cache_locked.patch
> and later at
>     https://ozlabs.org/~akpm/mmotm/broken-out/revert-mm-filemap-add-static-for-function-__add_to_page_cache_locked.patch
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
> From: Andrew Morton <akpm@linux-foundation.org>
> Subject: revert "mm/filemap: add static for function __add_to_page_cache_locked"
>
> Revert 3351b16af494 ("mm/filemap: add static for function
> __add_to_page_cache_locked") due to build issues with
> CONFIG_DEBUG_INFO_BTF=y.

I think it would be more accurate to say:
"due to incompatibility with ALLOW_ERROR_INJECTION".
btf build issue is a symptom.

Acked-by: Alexei Starovoitov <ast@kernel.org>
