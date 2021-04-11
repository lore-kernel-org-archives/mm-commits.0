Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ECD70C433B4
	for <mm-commits@archiver.kernel.org>; Sun, 11 Apr 2021 23:45:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B417A61206
	for <mm-commits@archiver.kernel.org>; Sun, 11 Apr 2021 23:45:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235734AbhDKXpj (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 11 Apr 2021 19:45:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235229AbhDKXpj (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 11 Apr 2021 19:45:39 -0400
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8108EC061574
        for <mm-commits@vger.kernel.org>; Sun, 11 Apr 2021 16:45:22 -0700 (PDT)
Received: by mail-pg1-x529.google.com with SMTP id k8so7992844pgf.4
        for <mm-commits@vger.kernel.org>; Sun, 11 Apr 2021 16:45:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=R5u2f5PebNsSaqIwGcxtsweu1c8VugMj/UwuPpAg72o=;
        b=jqfRJvESLQdYMoz7ZY5702tNgRqFt14wVaV0Dn+t+jXvxS3rQtX6qfNF97rTdynEl7
         nxwhoJ+h9XdOYSEyEcNqCxhaohdHetDj1AaKn4bxOf2zxrtzFMbCQ4/ceM39B7GkqtmG
         kw57Vj+bZFlq89u62RhL4zbdCvLhYjx5ATCJeS0CPcLtSNZ8bhv4AtgnneYt80Y/OcJd
         7ueLeCfzKndf0iAlQ6hyyjNOp8Xk18ZJl6wjPb6ZRsszs30tEsQ1RenZ+uV8HJ14oiTM
         B6GAdiMpWhDFZJm/goYtxMTP+jAKcttXobW1rfBIUNEhzMmZFzsCgX9ynW5xEca7JM6b
         hCPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=R5u2f5PebNsSaqIwGcxtsweu1c8VugMj/UwuPpAg72o=;
        b=CmWZBwlhjXYHVtyTCP4Z7hKTa5fu+TAYePGwySdPBLyMaTjKACcGgn9CkVsj/5SK41
         75wOPaxpj2Y/MjxBgrJwkSgf/TaPfaVXQmj3rm7zGSkbN894g4ySCUaFdaHg05QGRs65
         Y8iVoj4eZSDbR5IGV7dfrIfontqBZUybtheGnc0xrIoVe+BFRTvWy3S6cM8CRStapCyw
         f6aaKECpHyIRUj0xd/eL/QvmhopRFbWlPC4iWFZBbTRk4ftu40WZwlS1r65RUHiNkT3g
         6EW4/WO6pYFV8gZ/2NI+PCXBriUSh0HZaUMA8fyWoGdTzmBDNrCFizwtXHicuPjCQP6T
         EwQQ==
X-Gm-Message-State: AOAM53224KZWK1pkuP4THkbbdzbanEiGKszTHbP99NDIUuZ8OpDDz9uT
        e9madXPzX93TovWGU7TkgZc0PVFEE5xtug==
X-Google-Smtp-Source: ABdhPJyBNd34AIXQMVjbT6Zyb3sSVpEqLkz/v/HYGmW+D9FFkrKextCB4mUdnTUsmSSpmwDlaojjKQ==
X-Received: by 2002:a63:c04d:: with SMTP id z13mr23867532pgi.155.1618184721545;
        Sun, 11 Apr 2021 16:45:21 -0700 (PDT)
Received: from [192.168.1.134] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id 144sm7984203pfy.75.2021.04.11.16.45.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 11 Apr 2021 16:45:21 -0700 (PDT)
Subject: Re: + fs-io_uringc-fix-build.patch added to -mm tree
To:     akpm@linux-foundation.org, mm-commits@vger.kernel.org
References: <20210411225455.KJefX_uKq%akpm@linux-foundation.org>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <a04c30c4-4f93-4024-ea49-5ef9b84877b9@kernel.dk>
Date:   Sun, 11 Apr 2021 17:45:19 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210411225455.KJefX_uKq%akpm@linux-foundation.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On 4/11/21 4:54 PM, akpm@linux-foundation.org wrote:
> The patch titled
>      Subject: fs/io_uring.c: fix build
> has been added to the -mm tree.  Its filename is
>      fs-io_uringc-fix-build.patch
> 
> This patch should soon appear at
>     https://ozlabs.org/~akpm/mmots/broken-out/fs-io_uringc-fix-build.patch
> and later at
>     https://ozlabs.org/~akpm/mmotm/broken-out/fs-io_uringc-fix-build.patch
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
> Subject: fs/io_uring.c: fix build
> 
> hoping this is correct...

That's pretty broken :-)

I just updated the branches (and my for-next), so you should be able to
drop that one again.

-- 
Jens Axboe

