Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56F57C433EF
	for <mm-commits@archiver.kernel.org>; Tue,  1 Mar 2022 06:51:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231891AbiCAGvp (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 1 Mar 2022 01:51:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229814AbiCAGvp (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 1 Mar 2022 01:51:45 -0500
Received: from mail-yw1-x112b.google.com (mail-yw1-x112b.google.com [IPv6:2607:f8b0:4864:20::112b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8BF370307
        for <mm-commits@vger.kernel.org>; Mon, 28 Feb 2022 22:51:04 -0800 (PST)
Received: by mail-yw1-x112b.google.com with SMTP id 00721157ae682-2d646fffcc2so134304027b3.4
        for <mm-commits@vger.kernel.org>; Mon, 28 Feb 2022 22:51:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=FT76j6FUrMCsY4j9IMdfKYv80vV3rKi8E4It1d9+A+s=;
        b=ckl+zGQVtVO94BtIaZjYBJZVpt3eWdttPOlFoKn+yndZ+ZPbJUKu61o6PiLKOIsfUZ
         FgvG6u7jb+4ZgtZadpIyujFo3SG8g33BBCkSr/EA3sNxD1jLK7TkdUvKJ7/CIfoK5bxc
         jHHd0a2/felFsHLdHc77YNiv5q+yGcEPpD4kKWBw5uTLs+jH1obaLOprmb0weaZUb8Pv
         KB8k7y+8ROFUt5EwXo2kXHaeAcz/ZpDMMWw+4/tvkWJLHDmeew5QYP2RfaaQbh+66BXo
         WwGnwrD5RQXy7abq7Dd3e4XjHSsVuVnHWb//pGb2uw+IzoLXrg/dvmPoMWnltHY4tAV0
         /gdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=FT76j6FUrMCsY4j9IMdfKYv80vV3rKi8E4It1d9+A+s=;
        b=ypJ7zz0Hi2vQ2bDC9aMBIOFbgKWglMgxjQyOarcWHXnPDjYuAHKak8xcWf0XMXWRY3
         mSG5LGVVAE6UCghqDiTBDn3xMMzm8Y+N6/ya+mbOIpX+fg680lEOcNQ+NcSTBPMbMEzL
         D8EK94u0ihNspk5juolNj277TNeICfOKQk05rA1ZE6xWObMTlVr0R3DH9COvEyCCpjyL
         5b7iewgcB5adzl01chan7LQ4bRviHw8XbF5+IftOuTt3Z0Nt35e4miVp/1oFezEeOQdE
         RYawC3vafK7x7Q1yHcdsG8kHypn/iye+JYc6PiCG9P3dmpdUgfwBI0OI+eVAUHxssrmR
         tkKQ==
X-Gm-Message-State: AOAM533+k+iGDvTxdvCBVBg40o3I7ihwq20X2d9F4JIWul9eoTyz3ngH
        7BuskRhGfcrYBjnUVtIxi47QvAgV0SO8yMV1AWJEafoILdJUBhpz
X-Google-Smtp-Source: ABdhPJzxXnbkgW4lK7l8JeZggxWwL1+fDk7/0TvMSn5U8MX3t3pl98v7iWcmqbtqReWS1MCRawgyEZDabigfZnlP+TE=
X-Received: by 2002:a81:5dd6:0:b0:2d6:3041:12e0 with SMTP id
 r205-20020a815dd6000000b002d6304112e0mr23855261ywb.331.1646117463975; Mon, 28
 Feb 2022 22:51:03 -0800 (PST)
MIME-Version: 1.0
References: <20220228211325.40845C340F1@smtp.kernel.org>
In-Reply-To: <20220228211325.40845C340F1@smtp.kernel.org>
From:   Muchun Song <songmuchun@bytedance.com>
Date:   Tue, 1 Mar 2022 14:50:24 +0800
Message-ID: <CAMZfGtVaQNqeNRi9u6khkgYTW=qPDLxkeodGWriB7p1vy2msNA@mail.gmail.com>
Subject: Re: + mm-list_lru-replace-linear-array-with-xarray-fix.patch added to
 -mm tree
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     mm-commits@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Tue, Mar 1, 2022 at 5:13 AM Andrew Morton <akpm@linux-foundation.org> wrote:

[...]

> From: Andrew Morton <akpm@linux-foundation.org>
> Subject: mm-list_lru-replace-linear-array-with-xarray-fix
>
> remove unused local
>
> mm/list_lru.c: In function 'memcg_list_lru_alloc':
> mm/list_lru.c:477:32: error: unused variable 'mlrus' [-Werror=unused-variable]
>   477 |         struct list_lru_memcg *mlrus;
>       |                                ^~~~~
>
> Cc: Muchun Song <songmuchun@bytedance.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
>
>  mm/list_lru.c |    1 -
>  1 file changed, 1 deletion(-)
>
> --- a/mm/list_lru.c~mm-list_lru-replace-linear-array-with-xarray-fix
> +++ a/mm/list_lru.c
> @@ -474,7 +474,6 @@ int memcg_list_lru_alloc(struct mem_cgro
>  {
>         int i;
>         unsigned long flags;
> -       struct list_lru_memcg *mlrus;
>         struct list_lru_memcg_table {
>                 struct list_lru_per_memcg *mlru;
>                 struct mem_cgroup *memcg;
> _
>

Thanks Andrew. I'll fix it in the next version.
