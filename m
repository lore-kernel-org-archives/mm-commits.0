Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3EC21C7EE25
	for <mm-commits@archiver.kernel.org>; Thu,  8 Jun 2023 12:50:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233668AbjFHMuo (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 8 Jun 2023 08:50:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233733AbjFHMuo (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 8 Jun 2023 08:50:44 -0400
Received: from mail-yw1-x112e.google.com (mail-yw1-x112e.google.com [IPv6:2607:f8b0:4864:20::112e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58CDE198C
        for <mm-commits@vger.kernel.org>; Thu,  8 Jun 2023 05:50:42 -0700 (PDT)
Received: by mail-yw1-x112e.google.com with SMTP id 00721157ae682-569386b7861so25194797b3.0
        for <mm-commits@vger.kernel.org>; Thu, 08 Jun 2023 05:50:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686228641; x=1688820641;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kSd8yshx04SY5XSEjmE8duBGyIDpNJtX3flJ/fUTJPY=;
        b=fi8JukCUTHAPRZ7MBLUQn5K9pvGmRva0WsSmnLwhvB6iRW1F3EMhkWFWlvVSJKy8ZG
         jeTBjfudxvl/2j7atMhtb87TEe9DXQ8+N4J8/y8l7IJJdRUj96pU0jjy8OiC0kUkk7vS
         PgEuJT+dGPeW/OMmqhZ+JFMymO7KpW51oVhtqA0VjsAfGdKrOj+XRfbFdn5DCp/Ihxvr
         +IwkWKZV5XklBs23bbc5h1XgshCsPYdx7v9dfpou7ox0FMaexsgm8J6K3tORQDaQYEwN
         osy44AKep5FRJ0fDin9+j16npnv9ZhqvibcE5XRjh9kOXMd4Flu0lkHqjFnK/wFw+zmE
         W6CQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686228641; x=1688820641;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=kSd8yshx04SY5XSEjmE8duBGyIDpNJtX3flJ/fUTJPY=;
        b=E1MAdFryy74w7URg4oy+aNd3ZdBCgrAyZSIh9LvxL244EtzBNwbvQHOMIKQRwhYzTZ
         llG9NLDSr0GtVPXiLi3e2K8dKn020P5eVmSVMr7ATRwBlaG6eXSg6PRkI3PFTEHZbuoc
         rbZOM8xNnMjf1gBeRjPycM63K1dU/FbVutnX77/zLozP1BOg8VBT2Daka6LkXHsaKt+4
         XVVkqbnCWgYCWF9uTXYQNOFHfKFxaeEHzNkzgQ/nJKjudYy/xTAfJnIvTWdYy3Ozzaej
         9bh0lVgu2U5ie17O3yICVsFadQmQD0xpFSlgTlRwMKn3n+InOBGBZxzppPpVPR5eJl0N
         yerw==
X-Gm-Message-State: AC+VfDxcI5SSAXJP0uw20CjhckCwJ2ybHfuqWPhP/3E5nZP/oyhrhN+e
        +4y9t6BnhmQ1l/OBTPDeodygq9YK8x884PqcPlmhKXJMlBo=
X-Google-Smtp-Source: ACHHUZ5yNxwdBzMRwLKYUjx5Gnua6oqufbStEvX/NL8G4zALhmmPqu8zrFFTcwCms/5bIds8fsjR486EMkRyanHvjYQ=
X-Received: by 2002:a81:844a:0:b0:569:43f4:1568 with SMTP id
 u71-20020a81844a000000b0056943f41568mr2417101ywf.7.1686228641068; Thu, 08 Jun
 2023 05:50:41 -0700 (PDT)
MIME-Version: 1.0
References: <20230605215632.4DC83C433D2@smtp.kernel.org>
In-Reply-To: <20230605215632.4DC83C433D2@smtp.kernel.org>
From:   Liam Ni <zhiguangni01@gmail.com>
Date:   Thu, 8 Jun 2023 20:50:30 +0800
Message-ID: <CACZJ9cUPJVKsWynmiFVjVKOgJ2HFM=w26wN+g75-R8ftVJDpHA@mail.gmail.com>
Subject: Re: + mm-improve-the-execution-efficiency-of-early_ioremap_setup.patch
 added to mm-unstable branch
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     mm-commits@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

Hi Andrew,

i am a new developer=EF=BC=8CI have some questions to ask
On Tue, 6 Jun 2023 at 05:56, Andrew Morton <akpm@linux-foundation.org> wrot=
e:
>
>
> The patch titled
>      Subject: mm/early_ioremap.c: improve the execution efficiency of ear=
ly_ioremap_setup()
> has been added to the -mm mm-unstable branch.  Its filename is
>      mm-improve-the-execution-efficiency-of-early_ioremap_setup.patch
>
> This patch will shortly appear at
>      https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree=
/patches/mm-improve-the-execution-efficiency-of-early_ioremap_setup.patch
>
> This patch will later appear in the mm-unstable branch at
>     git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

=EF=BC=8C does this mean that  patch will upcoming mainline?

>
> Before you just go and hit "reply", please:
>    a) Consider who else should be cc'ed
>    b) Prefer to cc a suitable mailing list as well

I get mailing list by script "./scripts/checkpatch.pl",Do you mean my
mailing list is wrong?

>    c) Ideally: find the original patch on the mailing list and do a
>       reply-to-all to that, adding suitable additional cc's

=E2=80=9C original patch=E2=80=9D means reply to all with the link below ?
   [PATCH] mm:Improve the execution efficiency of
early_ioremap_setup() - Liam Ni (kernel.org)

>
> *** Remember to use Documentation/process/submit-checklist.rst when testi=
ng your code ***
>
> The -mm tree is included into linux-next via the mm-everything
> branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
> and is updated there every 2-3 working days
>
> ------------------------------------------------------
> From: Liam Ni <zhiguangni01@gmail.com>
> Subject: mm/early_ioremap.c: improve the execution efficiency of early_io=
remap_setup()
> Date: Sat, 3 Jun 2023 10:31:16 +0800
>
> Reduce the number of invalid loops of the function early_ioremap_setup()
> to improve the efficiency of function execution
>
> Link: https://lkml.kernel.org/r/CACZJ9cU6t5sLoDwE6_XOg+UJLpZt4+qHfjYN2bA0=
s+3y9y6pQQ@mail.gmail.com
> Signed-off-by: LiamNi <zhiguangni01@gmail.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
>
>  mm/early_ioremap.c |    8 +++-----
>  1 file changed, 3 insertions(+), 5 deletions(-)
>
> --- a/mm/early_ioremap.c~mm-improve-the-execution-efficiency-of-early_ior=
emap_setup
> +++ a/mm/early_ioremap.c
> @@ -72,12 +72,10 @@ void __init early_ioremap_setup(void)
>  {
>         int i;
>
> -       for (i =3D 0; i < FIX_BTMAPS_SLOTS; i++)
> -               if (WARN_ON(prev_map[i]))
> -                       break;
> -
> -       for (i =3D 0; i < FIX_BTMAPS_SLOTS; i++)
> +       for (i =3D 0; i < FIX_BTMAPS_SLOTS; i++) {
> +               WARN_ON_ONCE(prev_map[i]);
>                 slot_virt[i] =3D __fix_to_virt(FIX_BTMAP_BEGIN - NR_FIX_B=
TMAPS*i);
> +       }
>  }
>
>  static int __init check_early_ioremap_leak(void)
> _
>
> Patches currently in -mm which might be from zhiguangni01@gmail.com are
>
> mm-improve-the-execution-efficiency-of-early_ioremap_setup.patch
>
