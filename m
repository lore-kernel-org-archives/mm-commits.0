Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9DC04C433F5
	for <mm-commits@archiver.kernel.org>; Tue, 22 Mar 2022 22:13:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229572AbiCVWO7 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 22 Mar 2022 18:14:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229532AbiCVWO6 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 22 Mar 2022 18:14:58 -0400
Received: from mail-lf1-x131.google.com (mail-lf1-x131.google.com [IPv6:2a00:1450:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A061127B10
        for <mm-commits@vger.kernel.org>; Tue, 22 Mar 2022 15:13:29 -0700 (PDT)
Received: by mail-lf1-x131.google.com with SMTP id l20so32042733lfg.12
        for <mm-commits@vger.kernel.org>; Tue, 22 Mar 2022 15:13:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/JqUw7N0pQiYUGggfB1gLbjw37OlSObKornAcIsuE/w=;
        b=Pew1K7y3CpT1ghIeP6zNXgjqkgvlgq8GZ1eq5rwdB0TuKxLXxor0+ZVnKofKj/65cq
         oPtdFrkuNCC3crgTsACxwEy5zACBzm/eMnJg9RR8mpjJEzWJ3Ga1YUdGzrlkeM8D/fX7
         Fig4PvN6JpjdY+i/+N2spp17GKwsylL5WTl0Y=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/JqUw7N0pQiYUGggfB1gLbjw37OlSObKornAcIsuE/w=;
        b=CJY524Mj9/90c46FNuZXUDOSyMGqXSt9L9J3nXgcZqys4QZZzAAJa6u93r7gTvIwfh
         c7dGv4Gv2mF2/u3tjCebOZa0F5YDjwSBMCRXAxV183fVFox4xIQPPYLSCoRkaBEmPh34
         E9d79/GBQwCs48gxCHycqweQ1ghHjm3xM++JFpsoGl2yPdNMFhTzD62ozfyCEbR/1DdJ
         NXFcFYW4oSTjHe76WcBWEkZVGL/X7lmDqGIcnxGi2sKeQSbJCVZNInq9gqdjx6SpSnuv
         pFx+kq94O4ftnpLvB5dJ3OLXy4zQlz9T06TTHUQHzILy4RdIkW0V4JWIlUwMZmd3u2zv
         OaUA==
X-Gm-Message-State: AOAM530msX/NGrtpgpKRZjFZRld7l89OhHqIYOCfApgl/pFeBdvGmkej
        nAzdOAGmD6Kcv3s2ZZNe6JuQFLC2qnZpgpx5/Pk=
X-Google-Smtp-Source: ABdhPJxcCIdKKZi4emmPs8oGBi0omg2hi81rgfCxwFgS+Ew5R4PPihATir84+tjQq9jBpq8QQ96oPw==
X-Received: by 2002:a05:6512:2243:b0:448:6830:ee82 with SMTP id i3-20020a056512224300b004486830ee82mr19082061lfu.262.1647987207665;
        Tue, 22 Mar 2022 15:13:27 -0700 (PDT)
Received: from mail-lf1-f54.google.com (mail-lf1-f54.google.com. [209.85.167.54])
        by smtp.gmail.com with ESMTPSA id bj15-20020a2eaa8f000000b00246233c02a5sm2586653ljb.44.2022.03.22.15.13.26
        for <mm-commits@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 22 Mar 2022 15:13:26 -0700 (PDT)
Received: by mail-lf1-f54.google.com with SMTP id bt26so32118548lfb.3
        for <mm-commits@vger.kernel.org>; Tue, 22 Mar 2022 15:13:26 -0700 (PDT)
X-Received: by 2002:a19:e048:0:b0:448:2caa:7ed2 with SMTP id
 g8-20020a19e048000000b004482caa7ed2mr20018350lfj.449.1647987206418; Tue, 22
 Mar 2022 15:13:26 -0700 (PDT)
MIME-Version: 1.0
References: <20220322143803.04a5e59a07e48284f196a2f9@linux-foundation.org> <20220322213840.3117DC340F4@smtp.kernel.org>
In-Reply-To: <20220322213840.3117DC340F4@smtp.kernel.org>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Tue, 22 Mar 2022 15:13:10 -0700
X-Gmail-Original-Message-ID: <CAHk-=wjn_YUDEhaSdNdU2nBJowDT3enKYR1w+HiAy_srvJN1nw@mail.gmail.com>
Message-ID: <CAHk-=wjn_YUDEhaSdNdU2nBJowDT3enKYR1w+HiAy_srvJN1nw@mail.gmail.com>
Subject: Re: [patch 003/227] ntfs: add sanity check on allocation size
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     Anton Altaparmakov <anton@tuxera.com>, mudongliangabcd@gmail.com,
        patches@lists.linux.dev, Linux-MM <linux-mm@kvack.org>,
        mm-commits@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Tue, Mar 22, 2022 at 2:38 PM Andrew Morton <akpm@linux-foundation.org> wrote:
>
> From: Dongliang Mu <mudongliangabcd@gmail.com>
> Subject: ntfs: add sanity check on allocation size
>
> ntfs_read_inode_mount invokes ntfs_malloc_nofs with zero allocation size.
> It triggers one BUG in the __ntfs_malloc function.

Hmm. A more serious issue seems to be that cast to (u32).

ntfs_attr_size(a) returns a 's64', so it just randomly truncates a
possibly bad value..

               Linus
