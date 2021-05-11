Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 341E0C43600
	for <mm-commits@archiver.kernel.org>; Tue, 11 May 2021 05:01:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D88326192A
	for <mm-commits@archiver.kernel.org>; Tue, 11 May 2021 05:01:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230103AbhEKFCQ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 11 May 2021 01:02:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229954AbhEKFCQ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 11 May 2021 01:02:16 -0400
Received: from mail-ot1-x334.google.com (mail-ot1-x334.google.com [IPv6:2607:f8b0:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73FD7C061574
        for <mm-commits@vger.kernel.org>; Mon, 10 May 2021 22:01:10 -0700 (PDT)
Received: by mail-ot1-x334.google.com with SMTP id u25-20020a0568302319b02902ac3d54c25eso16529739ote.1
        for <mm-commits@vger.kernel.org>; Mon, 10 May 2021 22:01:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:in-reply-to:references:from:user-agent:date:message-id
         :subject:to;
        bh=UDgyzdZNkh/OViJ9GacX+Ayr5FPdUp34YMagudoWCUw=;
        b=G1z9TILc2qg8MpbZphYn25FJlbcSz7GbxYcPnIJfHTrUYDE+2GZagJQSyzurEMcJB1
         qO4an39koSMWKW8IyPBVT2Y536WXh0Wkwdyzxrjs6SbgK1j19+RZjuaTeGiIU8R2CO8+
         SLyjVg7RqBWCf9WRJZ5O0r2Dwr7bxZLRrpsgE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:in-reply-to:references:from
         :user-agent:date:message-id:subject:to;
        bh=UDgyzdZNkh/OViJ9GacX+Ayr5FPdUp34YMagudoWCUw=;
        b=gi6AuI0ExJTGDuCr78SWfS4MM9Io4MibON8op7zlErj/+YRGdXsSYhHgfT07yhjGfX
         AFTS9OrxhVXwLW63AhW4doqPiG/xlpcqnzkZZAREmT3wgA/VqVzzA3Hu/cBy21IT7Phc
         zskCqWZrhRKQ/MTr8rLm1+i5SQLO9NBTqBwT021dlwnu8eKBM/87gR89LbrkwhKkYa/K
         zfsel1He1D96bZlBNf7EazAKf7LGN8EUPbUQ2uusd72t7fAyVvbAVh4nGYdoJ645EYb4
         pjWR1D42yCxFNXDZqiJlsae2JBYuCKvIAJZcVxXSwM+gDhpsKUMCO7s0oiSxcvshJiJb
         2Fcw==
X-Gm-Message-State: AOAM530sUDn5O+bmkT8cqYxyxFxk0/Za3mlTAGxVs7V0/nPYRHbm+d/V
        trMZc/Gzio0V3t3W+ovco0K9WvWWRoWleA+OOQsRzSWbb2s=
X-Google-Smtp-Source: ABdhPJwkCi3nw/puL7jTPA4gSmJXbJRyZMrX4hu6xl/DiEKzWMnompb1R3zE2ftb4SDMh4YCIVeqJBPHD1fBgGYqHQU=
X-Received: by 2002:a9d:425:: with SMTP id 34mr24643710otc.25.1620709269930;
 Mon, 10 May 2021 22:01:09 -0700 (PDT)
Received: from 753933720722 named unknown by gmailapi.google.com with
 HTTPREST; Mon, 10 May 2021 22:01:09 -0700
MIME-Version: 1.0
In-Reply-To: <20210511015955.j3w372K37%akpm@linux-foundation.org>
References: <20210511015955.j3w372K37%akpm@linux-foundation.org>
From:   Stephen Boyd <swboyd@chromium.org>
User-Agent: alot/0.9.1
Date:   Mon, 10 May 2021 22:01:09 -0700
Message-ID: <CAE-0n51RLhb1a9RaBxM-Mj7fEGBAtyoSUF=0_eKi=nA=uakwNA@mail.gmail.com>
Subject: Re: + module-add-printk-formats-to-add-module-build-id-to-stacktraces-fix.patch
 added to -mm tree
To:     akpm@linux-foundation.org, mm-commits@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

Quoting akpm@linux-foundation.org (2021-05-10 18:59:55)
>
> The patch titled
>      Subject: module-add-printk-formats-to-add-module-build-id-to-stacktraces-fix
> has been added to the -mm tree.  Its filename is
>      module-add-printk-formats-to-add-module-build-id-to-stacktraces-fix.patch
>
> This patch should soon appear at
>     https://ozlabs.org/~akpm/mmots/broken-out/module-add-printk-formats-to-add-module-build-id-to-stacktraces-fix.patch
> and later at
>     https://ozlabs.org/~akpm/mmotm/broken-out/module-add-printk-formats-to-add-module-build-id-to-stacktraces-fix.patch
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
> Subject: module-add-printk-formats-to-add-module-build-id-to-stacktraces-fix
>
> fix build with CONFIG_MODULES=n, tweak code layout
>
> Cc: Stephen Boyd <swboyd@chromium.org>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---

Thanks for cleaning up that one.

Reviewed-by: Stephen Boyd <swboyd@chromium.org>
