Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B656FC4332F
	for <mm-commits@archiver.kernel.org>; Thu, 20 Oct 2022 16:28:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229576AbiJTQ20 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 20 Oct 2022 12:28:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229494AbiJTQ2Z (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 20 Oct 2022 12:28:25 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDBC62E9D6;
        Thu, 20 Oct 2022 09:28:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 1FA1DCE26F9;
        Thu, 20 Oct 2022 16:28:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DEFFCC433B5;
        Thu, 20 Oct 2022 16:28:20 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="bHnUKadW"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1666283298;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=6c56fZ5kerOQ5aIM75vB4dMcPlUkfVpQAx4Ufxtjbdk=;
        b=bHnUKadWsAUlF5xfxV4eJ7eZeUVZuzHbvjXnv8KT1YFZWheHixIoOHRqDj2dXiKv1ZfhtE
        rWnMSwzb4Rl5GOjvYp1Z+Oe8RqGPVPijCuWtPNwERamJKyG1MaLXSQlAHuf3Wjc+lOZoBK
        S5+FEFBAf/vloGUaKYuXzbHoRjiMq7A=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id d41a3611 (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
        Thu, 20 Oct 2022 16:28:18 +0000 (UTC)
Received: by mail-ua1-f49.google.com with SMTP id h25so9959512uao.13;
        Thu, 20 Oct 2022 09:28:17 -0700 (PDT)
X-Gm-Message-State: ACrzQf1kcoYSL0Tlbchk3/rY1JIE/wtGlZhyMLtJupM1Jb9Iby5xvxXw
        fcYATk9Pz+ZShih3Dgi3FetbUeSc8NSENnuQfcM=
X-Google-Smtp-Source: AMsMyM73A4O7b+F/R0fell/X1cFuk98lyms+Gw6tPxMTTI1kYRmUpaee7D31c9lshQYfXDjtKpk1jik3WRwXkJ254bA=
X-Received: by 2002:a67:ec47:0:b0:3a9:682c:bc5c with SMTP id
 z7-20020a67ec47000000b003a9682cbc5cmr7410097vso.70.1666283296983; Thu, 20 Oct
 2022 09:28:16 -0700 (PDT)
MIME-Version: 1.0
References: <20221020000356.177CDC433C1@smtp.kernel.org> <Y1EZuQcO8UoN91cX@localhost.localdomain>
In-Reply-To: <Y1EZuQcO8UoN91cX@localhost.localdomain>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Thu, 20 Oct 2022 10:28:06 -0600
X-Gmail-Original-Message-ID: <CAHmME9prEhkHqQmtDGCSFunNnxiKdE_8FHKiksyqebUN63U81Q@mail.gmail.com>
Message-ID: <CAHmME9prEhkHqQmtDGCSFunNnxiKdE_8FHKiksyqebUN63U81Q@mail.gmail.com>
Subject: Re: [PATCH -mm] -funsigned-char, x86: make struct p4_event_bind::cntr
 signed array
To:     Alexey Dobriyan <adobriyan@gmail.com>
Cc:     akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org,
        masahiroy@kernel.org, keescook@chromium.org,
        gregkh@linuxfoundation.org, andriy.shevchenko@linux.intel.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Thu, Oct 20, 2022 at 3:49 AM Alexey Dobriyan <adobriyan@gmail.com> wrote:
>
> struct p4_event_bind::cntr[][] should be signed because of
> the following code:
>
>         int i, j;
>         for (i = 0; i < P4_CNTR_LIMIT; i++) {
>           ===>  j = bind->cntr[thread][i];
>                 if (j != -1 && !test_bit(j, used_mask))
>                         return j;
>         }
>
> Making this member unsigned will make "j" 255 and fail "j != -1"
> comparison.
>
> Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>

Nice catch.

Reviewed-by: Jason A. Donenfeld <Jason@zx2c4.com>

>  arch/x86/events/intel/p4.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> --- a/arch/x86/events/intel/p4.c
> +++ b/arch/x86/events/intel/p4.c
> @@ -24,7 +24,7 @@ struct p4_event_bind {
>         unsigned int escr_msr[2];               /* ESCR MSR for this event */
>         unsigned int escr_emask;                /* valid ESCR EventMask bits */
>         unsigned int shared;                    /* event is shared across threads */
> -       char cntr[2][P4_CNTR_LIMIT];            /* counter index (offset), -1 on absence */
> +       signed char cntr[2][P4_CNTR_LIMIT];     /* counter index (offset), -1 on absence */
>  };

This is fine, but I wonder if this is a good occasion to use `s8` instead?

Jason
