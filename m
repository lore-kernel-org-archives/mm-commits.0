Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E62A3C38A2D
	for <mm-commits@archiver.kernel.org>; Fri, 21 Oct 2022 19:40:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230083AbiJUTkl (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 21 Oct 2022 15:40:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230131AbiJUTkk (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 21 Oct 2022 15:40:40 -0400
Received: from mail-qt1-x82a.google.com (mail-qt1-x82a.google.com [IPv6:2607:f8b0:4864:20::82a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E4351989B8
        for <mm-commits@vger.kernel.org>; Fri, 21 Oct 2022 12:40:30 -0700 (PDT)
Received: by mail-qt1-x82a.google.com with SMTP id h24so2321297qta.7
        for <mm-commits@vger.kernel.org>; Fri, 21 Oct 2022 12:40:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=8cEcPE5eJxdhlD5IGo/M7P7SxrnCieMphXj8buQz48I=;
        b=T9l49X7m6bFvcPcqrTkzRupPSD0TaxDVlJn97Z7GBec0F5nMJUH2zckYJQilD6S+4I
         v3LjPCvtVo603tLjPTPha5JL3M+0gdgQXKkipkYn/djWgwydEi2FEI1B8X1oN02ql5SO
         3wYl0+PPOXb8PbGPo/JBnAEn7meQ0mzKUgPFQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=8cEcPE5eJxdhlD5IGo/M7P7SxrnCieMphXj8buQz48I=;
        b=Luh7iYItfZIwboU9bXL2wK4FZ8Li3XZ1KPCBTI3XvYfjGTbZDUryxnCFfTIDfdNg1U
         igKmQ+J/tSFwYVDLFztsn/hOh5SoKo1ZbNYIlovp56Ju9Bo1maSr/CIPYoD29o/tURgu
         0mJtPacfB4rDKw4laS+fbnU3wjqFUk234M+wgfMf7XHhTWUrxOa+rREsJ13++vbOIYGN
         XtCs16a6tNAf5gxByPbdANVLGqqTQoXxuwmrRjStpXiaCmDZh4H0vruiNJBYG/78+Oto
         LZM2XGvHXPhUrU1mEKOTpVaARMIh/diFDrb9FPG3ehnlHQHchIgXEd5gKSD5zpFl7jMn
         1KQw==
X-Gm-Message-State: ACrzQf31WnJOvAWKVOxsmXzXitdLPuQde1a5qo5nYKP+yIdPexrfxRkK
        NkhkyH309d9E0ObeZfJGHHNwfhKGnYoyKQ==
X-Google-Smtp-Source: AMsMyM5W7LPH4VxpGAqmVY9AVia1phK/ZV+Iv38GY68vQsnUu5nHkMRl4UVOfEsyPwfHjjVmczBknA==
X-Received: by 2002:ac8:5b15:0:b0:39c:d63a:d82 with SMTP id m21-20020ac85b15000000b0039cd63a0d82mr17964454qtw.8.1666381229750;
        Fri, 21 Oct 2022 12:40:29 -0700 (PDT)
Received: from mail-yb1-f180.google.com (mail-yb1-f180.google.com. [209.85.219.180])
        by smtp.gmail.com with ESMTPSA id s7-20020a05620a254700b006af0ce13499sm10287408qko.115.2022.10.21.12.40.28
        for <mm-commits@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 21 Oct 2022 12:40:29 -0700 (PDT)
Received: by mail-yb1-f180.google.com with SMTP id t186so4452976yba.12
        for <mm-commits@vger.kernel.org>; Fri, 21 Oct 2022 12:40:28 -0700 (PDT)
X-Received: by 2002:a25:84cf:0:b0:6b3:c0c3:19d8 with SMTP id
 x15-20020a2584cf000000b006b3c0c319d8mr17385388ybm.349.1666381228574; Fri, 21
 Oct 2022 12:40:28 -0700 (PDT)
MIME-Version: 1.0
References: <20221020213327.2c284af5925b6a8ed915fe9e@linux-foundation.org>
In-Reply-To: <20221020213327.2c284af5925b6a8ed915fe9e@linux-foundation.org>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Fri, 21 Oct 2022 12:40:12 -0700
X-Gmail-Original-Message-ID: <CAHk-=wgb42XG1c_rtwupJMD9QXbJsE6k_TBKYC4YvZ8bkATcVg@mail.gmail.com>
Message-ID: <CAHk-=wgb42XG1c_rtwupJMD9QXbJsE6k_TBKYC4YvZ8bkATcVg@mail.gmail.com>
Subject: Re: [GIT PULL] hotfixes for 6.1-rc2
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        mm-commits@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Thu, Oct 20, 2022 at 9:33 PM Andrew Morton <akpm@linux-foundation.org> wrote:
>
> Andrew Morton (3):
>       Merge branch 'master' into mm-hotfixes-stable
>       Merge branch 'master' into mm-hotfixes-stable

I've pulled this, but both of these merges look entirely invalid.

First off, one of them is most definitely pointless - there's no
activity between the first and the second merge, so that first merge
shouldn't have been done in the first place.

But the second merge is bad by definition too, in that it doesn't have
any explanation for it.

I've said this before - and I hope that some day I just won't have to
say it again - if you cannot explain a merge, you shouldn't be *doing*
a merge.

It really is that simple. If you have no clear explanation for why you
need to do that merge, then you simply shouldn't have done it.

For example, that first merge clearly CANNOT have a valid reason for
existing. There's simply no valid explanation for doing it,
considering that there was no work on top of it that could possibly be
a cause tor that merge.

So that whole "if you cannot explain why you do a merge, don't do the
merge" rule should have been a hard "NO" on it, and should have made
it obvious that it shouldn't have happened.

Please don't do pointless merges.

            Linus
