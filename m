Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0D02C77B61
	for <mm-commits@archiver.kernel.org>; Fri, 28 Apr 2023 03:25:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345044AbjD1DZR (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 27 Apr 2023 23:25:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344815AbjD1DZP (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 27 Apr 2023 23:25:15 -0400
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15E6B2116
        for <mm-commits@vger.kernel.org>; Thu, 27 Apr 2023 20:25:13 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id 4fb4d7f45d1cf-506b20efd4cso15768615a12.3
        for <mm-commits@vger.kernel.org>; Thu, 27 Apr 2023 20:25:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1682652311; x=1685244311;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XtcfavXCgC97sXeM2tBhYDMeAO+0wKfV/28poedCpKI=;
        b=eGvbuwPngN5eh8s2qx04NIVRYGePJ2BrMcx8RZMZyG30Qana2OUuckQhxzKhr3UTSO
         5LoxVeOCIQLPiEyqi84VGNaqjaYIa3ciHotnSHjOSeQkCLRX78rq0onFe7Gx0kyiVwDc
         V/wscIV+WgGwx0NlyGNLfpg39xBgAIMR3eXjk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682652311; x=1685244311;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XtcfavXCgC97sXeM2tBhYDMeAO+0wKfV/28poedCpKI=;
        b=ECCfWkPUomAmMcYkhNrEQwXtyRpAPc0aui6j/TD0EvyrlVKAuxRD4wF0KhhQmbMe0l
         z1JHK4aY6P1nni0sVfe7j5ZnNKIO4ua6fumbi05qWAmB7+6bBgsnSmpOU7Gtcikj8Www
         egWegXopSPo+hOh+ob5l+ERAt3RrPWtjI0s2AE9nqNLFWsM/+aEF/Cr9LXbthG6QvZMS
         jJjw9D3rxG+hrFy5Jw0Xdv0BcNquX8jsZlZauigqKa4DzHY3dGEiPxoRPwUPvaACF58P
         QQVkY8ni3rJB3LRMlGtg1woRSpNcvc7Ww24LeyAJFt7g2jovxCpbb4PyklY8+m+gAOnK
         fmWA==
X-Gm-Message-State: AC+VfDyVwmpVzWwZIR1rLYZsBjbAwObV+ltS/vmA5hLq9ttPvE2ll6wl
        yph+7pppPqlsueTIHEgJUW1OYiQRAtVx3VvJ30rwcw==
X-Google-Smtp-Source: ACHHUZ5UhQEbR+ywA7t6TivVZuze/3HlmCdM9wP9855fpGmALZYyTnMGnDlSIWIEhw2pZ6L/LNS3yA==
X-Received: by 2002:a17:906:58cf:b0:953:3e29:f35c with SMTP id e15-20020a17090658cf00b009533e29f35cmr4222045ejs.45.1682652311270;
        Thu, 27 Apr 2023 20:25:11 -0700 (PDT)
Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com. [209.85.218.52])
        by smtp.gmail.com with ESMTPSA id qw16-20020a1709066a1000b00959b3c30f2csm5867379ejc.222.2023.04.27.20.25.10
        for <mm-commits@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 27 Apr 2023 20:25:10 -0700 (PDT)
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-94f7a7a3351so1782995266b.2
        for <mm-commits@vger.kernel.org>; Thu, 27 Apr 2023 20:25:10 -0700 (PDT)
X-Received: by 2002:a17:907:2d8f:b0:957:278c:fb27 with SMTP id
 gt15-20020a1709072d8f00b00957278cfb27mr4205144ejc.21.1682652309848; Thu, 27
 Apr 2023 20:25:09 -0700 (PDT)
MIME-Version: 1.0
References: <20230427153345.451d86681f9c6775ea579e5a@linux-foundation.org> <CAHk-=wjaYXeWKsyifQCS=gJf4mxav-b6cdf5boKpMO6M1C-2LQ@mail.gmail.com>
In-Reply-To: <CAHk-=wjaYXeWKsyifQCS=gJf4mxav-b6cdf5boKpMO6M1C-2LQ@mail.gmail.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Thu, 27 Apr 2023 20:24:53 -0700
X-Gmail-Original-Message-ID: <CAHk-=wicaWSn3JLwpexH=gu1HoHWpecyWoLYBwD3qPd0-t9aJA@mail.gmail.com>
Message-ID: <CAHk-=wicaWSn3JLwpexH=gu1HoHWpecyWoLYBwD3qPd0-t9aJA@mail.gmail.com>
Subject: Re: [GIT PULL] MM updates for 6.4-rc1
To:     Andrew Morton <akpm@linux-foundation.org>,
        Christoph Hellwig <hch@lst.de>,
        Matthew Wilcox <willy@infradead.org>
Cc:     mm-commits@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Lorenzo Stoakes <lstoakes@gmail.com>,
        Vlastimil Babka <vbabka@suse.cz>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Thu, Apr 27, 2023 at 8:15=E2=80=AFPM Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> Most of the bulk of the conflicts were around __filemap_get_folio()
> now returning an ERR_PTR, particularly then with Willy doing the ext4
> folio conversion.
>
> So Christoph, Willy, mind just double-checking me?

Just to clarify: I do take a look at linux-next, but I do it as an
after-the-fact "let's double-check my resolution", and some of my
resolutions don't end up being identical because I end up doing things
differently.

For example, I found the linux-next resolution in
ext4_read_merkle_tree_page() to be nonsensical. I think it probably
generates the same code as my resolution, but doing "&folio->page" on
an ERR_PTR folio is some funky funky sh*t.

Only after looking at the linux-next resolution did I grep around and
notice that that kind of funky struff had already made it into
mainline in non-conflicting places. Willy - it seems to be you
spreading that crazy pattern. Please stop.

Anyway.

I did some things differently, and while I think my resolution is the
right one, the fact that it is different could also just mean that I'm
confused.

                   Linus
