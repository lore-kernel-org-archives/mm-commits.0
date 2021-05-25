Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9BA42C4707F
	for <mm-commits@archiver.kernel.org>; Tue, 25 May 2021 21:34:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 65D28613AD
	for <mm-commits@archiver.kernel.org>; Tue, 25 May 2021 21:34:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230518AbhEYVfc (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 25 May 2021 17:35:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230426AbhEYVfc (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 25 May 2021 17:35:32 -0400
Received: from mail-oo1-xc2c.google.com (mail-oo1-xc2c.google.com [IPv6:2607:f8b0:4864:20::c2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B5B9C061574
        for <mm-commits@vger.kernel.org>; Tue, 25 May 2021 14:34:02 -0700 (PDT)
Received: by mail-oo1-xc2c.google.com with SMTP id q17-20020a4a33110000b029020ebab0e615so5602854ooq.8
        for <mm-commits@vger.kernel.org>; Tue, 25 May 2021 14:34:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:in-reply-to:references:from:user-agent:date:message-id
         :subject:to;
        bh=j3pMN0FtRI3l0pBckD1bdEma7PVy9cFyrV333OpGkLs=;
        b=FomUG11zdZEzJ6qk6ztntIkRnHeLe8ecm35O9RQ5sfAxQxZ4HK5F9L+eMaXW5D03jH
         5eJHdZc8KSQx0Aj0iwGiR+0fOwkt+2kWu5FHkJf4EOLx1IfGlYkbOwxv/SDVScQl7gfD
         px8SazhMUVH+IZvfx+rjZQyhsnIc5Z/uXVQaw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:in-reply-to:references:from
         :user-agent:date:message-id:subject:to;
        bh=j3pMN0FtRI3l0pBckD1bdEma7PVy9cFyrV333OpGkLs=;
        b=M+cgpgqtX8ntC3+f95EbPEIN92S2FryUgVRPQy+HFQg2vAaHg+uUapuduO+v/c1yMu
         cw85CXa+5oGwAeYkPVlriGiYfsVfFxSBOIO9okxQg5amcQ/RbkHPsZ8ZaWan25zA/cog
         jwKq4O8MjnldVOB6IRW5HMW8WWIM/GcGt1WbvAxtg6ETfi9ebX/Cyr/2uNsZcxgDE1Ug
         PdFe0H1CT53lG0TsOJ8aDfGRhKHYN17oOA+bRbWEnz9RFbb14Iydte9Phl9fVh3bMC1O
         ChvBld3fZD7efVr/jKn1Zg4bifOME1k79j/u5W3eAePuPSru/jyZ1yl9DsXdMOfxnEDu
         1kgw==
X-Gm-Message-State: AOAM531JjwEDvg7Re1wBBfivWeJ29ffPDSOpMNK9BLPRgahazaNEpMBj
        YwsA4aziWJENYCfGsAdmyJTheFqyw6KRApXN76NxGp7Z6YI=
X-Google-Smtp-Source: ABdhPJxDJ2wia5Ld3SS1RVKqGnzNpL32dVA9TaMVuioW46D0b9AV+1jDy7xnkOWcyNlc4b9qtT+3lNA7X/jCoaC9iao=
X-Received: by 2002:a05:6820:169:: with SMTP id k9mr9426126ood.92.1621978441768;
 Tue, 25 May 2021 14:34:01 -0700 (PDT)
Received: from 753933720722 named unknown by gmailapi.google.com with
 HTTPREST; Tue, 25 May 2021 17:34:01 -0400
MIME-Version: 1.0
In-Reply-To: <20210525201158.81ehBoGJL%akpm@linux-foundation.org>
References: <20210525201158.81ehBoGJL%akpm@linux-foundation.org>
From:   Stephen Boyd <swboyd@chromium.org>
User-Agent: alot/0.9.1
Date:   Tue, 25 May 2021 17:34:01 -0400
Message-ID: <CAE-0n50Fz=s--=5HkViL6rJD0bT=3ZT8yr=9RWfk8LDNubr2pA@mail.gmail.com>
Subject: Re: + module-add-printk-formats-to-add-module-build-id-to-stacktraces-fix-fix.patch
 added to -mm tree
To:     akpm@linux-foundation.org, mm-commits@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

Quoting akpm@linux-foundation.org (2021-05-25 13:11:58)
>
> The patch titled
>      Subject: module-add-printk-formats-to-add-module-build-id-to-stacktraces-fix-fix
> has been added to the -mm tree.  Its filename is
>      module-add-printk-formats-to-add-module-build-id-to-stacktraces-fix-fix.patch
>
> This patch should soon appear at
>     https://ozlabs.org/~akpm/mmots/broken-out/module-add-printk-formats-to-add-module-build-id-to-stacktraces-fix-fix.patch
> and later at
>     https://ozlabs.org/~akpm/mmotm/broken-out/module-add-printk-formats-to-add-module-build-id-to-stacktraces-fix-fix.patch
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
> Subject: module-add-printk-formats-to-add-module-build-id-to-stacktraces-fix-fix
>
> make kallsyms_lookup_buildid() static
>
> warning: no previous prototype for 'kallsyms_lookup_buildid' [-Wmissing-prototypes]
>
> Cc: Stephen Boyd <swboyd@chromium.org>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---

Reviewed-by: Stephen Boyd <swboyd@chromium.org>
