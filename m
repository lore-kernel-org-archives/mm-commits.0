Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1BB1C433F5
	for <mm-commits@archiver.kernel.org>; Fri, 13 May 2022 17:27:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232145AbiEMR1f (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 13 May 2022 13:27:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349632AbiEMR1b (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 13 May 2022 13:27:31 -0400
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C2F06FD1B
        for <mm-commits@vger.kernel.org>; Fri, 13 May 2022 10:27:30 -0700 (PDT)
Received: by mail-ej1-x634.google.com with SMTP id m20so17499849ejj.10
        for <mm-commits@vger.kernel.org>; Fri, 13 May 2022 10:27:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Zf0rn8yLC7yAPUBUazTnzPwSa/C/YmybSq+uQGiI6lg=;
        b=hEx1V12/qwOL04uY2qlbamcUTkaJNL+QbeX8z8ioN0zwzxI3yvuyYZU9wKfrQZj0rP
         BD3iFFZQqBbFu0y9i/4PgH4y7TmRpccgEcWf9c35EPwQhAndt8h72QTY8lvv6FJF/3iI
         1t1xWtbl3fEaJaHwVj2kxyuQr0niC5M7SSqyo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Zf0rn8yLC7yAPUBUazTnzPwSa/C/YmybSq+uQGiI6lg=;
        b=Gh8QzqzJVS45y+NCJfoEbR7V2Na4QA8MfpW8GNKW4JhKk0o6kbo/hLReVKKlKU/qNY
         bLv6iUNTyw3y/iATPcFiPpOeWVkb+ZPbSptoysBiVfTBJajOVHsbc48sI4OIb7+Noxgv
         ybEMn2AbBf+QAM7vFoAEW4GSKUGjkPLdGB95fpUghx4t/thV0o13bhu2XYjFCjDJhKWk
         EyTVwfRHlNezuW4TZdFxArSMv1c+HkdNSXxkwGT/ado6poD1CiFNqjHkn+qOvAXOeTdr
         8QfONkep/xhrXzF8Sr2lALuGKx1HoEoN9fA7MwyVvI+tXtrddsSk8Zy+kClvqTEmqMJJ
         Ns4g==
X-Gm-Message-State: AOAM531k8JnH12n09WaDwpHyUSiKGTikms+WjkIi6Z24NV0jzgKaFOZ8
        +1OlwNEEIt89IjQlcedyeolDjs8RXyvQhU6WbS0=
X-Google-Smtp-Source: ABdhPJwEIyVaL9m6Gvyr1Ff6s19AWZK/FLdHpQ1G5afDHpY9FttE3WGzh151p/LMsPXgBaaY0oYcfQ==
X-Received: by 2002:a17:906:ce44:b0:6f4:2c9d:2d42 with SMTP id se4-20020a170906ce4400b006f42c9d2d42mr5237230ejb.503.1652462848564;
        Fri, 13 May 2022 10:27:28 -0700 (PDT)
Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com. [209.85.221.51])
        by smtp.gmail.com with ESMTPSA id p7-20020a17090664c700b006f3ef214de3sm982403ejn.73.2022.05.13.10.27.27
        for <mm-commits@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 13 May 2022 10:27:27 -0700 (PDT)
Received: by mail-wr1-f51.google.com with SMTP id a5so8504851wrp.7
        for <mm-commits@vger.kernel.org>; Fri, 13 May 2022 10:27:27 -0700 (PDT)
X-Received: by 2002:adf:ec08:0:b0:20a:d39d:6ab6 with SMTP id
 x8-20020adfec08000000b0020ad39d6ab6mr4855652wrn.442.1652462846758; Fri, 13
 May 2022 10:27:26 -0700 (PDT)
MIME-Version: 1.0
References: <20220513100825.701c0801de7f18168c4d838c@linux-foundation.org>
In-Reply-To: <20220513100825.701c0801de7f18168c4d838c@linux-foundation.org>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Fri, 13 May 2022 10:27:10 -0700
X-Gmail-Original-Message-ID: <CAHk-=wgz2FG+OxdR9KCWO=pPoWezScYx+rLUjHdeL4y9oJJvCg@mail.gmail.com>
Message-ID: <CAHk-=wgz2FG+OxdR9KCWO=pPoWezScYx+rLUjHdeL4y9oJJvCg@mail.gmail.com>
Subject: Re: [GIT PULL] hotfixes for 5.18-rc7
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     Linux-MM <linux-mm@kvack.org>, mm-commits@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Fri, May 13, 2022 at 10:08 AM Andrew Morton
<akpm@linux-foundation.org> wrote:
>
> Please pull a bunch of hotfixes for 5.18-rc7.

W00t. Pulled.

One day your workflow will also keep patch dates intact.

That day is not today, but it was still really nice to just pull from you.

Thanks,
                Linus
