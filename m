Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22524C6FD1D
	for <mm-commits@archiver.kernel.org>; Tue, 21 Mar 2023 21:48:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229484AbjCUVsi (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 21 Mar 2023 17:48:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229692AbjCUVsh (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 21 Mar 2023 17:48:37 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06FED5249
        for <mm-commits@vger.kernel.org>; Tue, 21 Mar 2023 14:48:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9379361E78
        for <mm-commits@vger.kernel.org>; Tue, 21 Mar 2023 21:48:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02504C433A1
        for <mm-commits@vger.kernel.org>; Tue, 21 Mar 2023 21:48:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679435313;
        bh=1BJBNFWSd9KQq1yf8ohkXwd7LaQR+pUz10pHApSB4iw=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=qH81C1DOOIaJh3YRyShFwz8mAeSoEhNqBPzMWKjydAlg6Y6+qGrq7m7AM+tGtyb2x
         ZyPhQCm7R4ciYGhk2t6J7VjnaNVbyM93R6J4qu25ly2uej1bihdsawJ09p4SWi2OqQ
         XTRneNupZziSJJhqhshjpU5WdkfUHW5OJgQq3cLD023RtbpMCqwNRn3EimPdiqMBFK
         tAjknCLIdd98F/5LT64iwPhwm/eM7zA95j8cY4MpTkcvLx7F4sFxv8GgC3jh1BQN2K
         nDPXcjZ4RfUHCO6bvEKWd5peRO/2+5VDQZOl9i7fKMKfF57z7RwqQKI23eydYQXmUk
         kyGFGVTSAiOxw==
Received: by mail-yb1-f178.google.com with SMTP id j7so18970434ybg.4
        for <mm-commits@vger.kernel.org>; Tue, 21 Mar 2023 14:48:32 -0700 (PDT)
X-Gm-Message-State: AAQBX9di++uFxYgeNz2W3behpHQAZXG5zGV6QBNoBlQJIGxUZWJqyUxk
        BNVAzCJAdBrOw0esxdG6NdpDDT71d8JU38UmAg==
X-Google-Smtp-Source: AKy350Ynb240443KbYjtdnpdLbX0LcQDKfQ/iXJMWPzsnfZaesFSsulgOGKqyDwJNfysg/o/YJY0CpJoN2uw1Rb7VJE=
X-Received: by 2002:a05:6902:150c:b0:b6c:f26c:e5b0 with SMTP id
 q12-20020a056902150c00b00b6cf26ce5b0mr2713907ybu.1.1679435312026; Tue, 21 Mar
 2023 14:48:32 -0700 (PDT)
MIME-Version: 1.0
References: <20230321212913.79232C4339B@smtp.kernel.org> <CAL_JsqJ2mibR5EKjk494V1T9GsSCwF+5yVB9A3nEntgcrmoTkA@mail.gmail.com>
 <20230321144456.a70b235ca64424d3f73a1ac7@linux-foundation.org>
In-Reply-To: <20230321144456.a70b235ca64424d3f73a1ac7@linux-foundation.org>
From:   Rob Herring <robh@kernel.org>
Date:   Tue, 21 Mar 2023 16:48:21 -0500
X-Gmail-Original-Message-ID: <CAL_Jsq+2ir9y1E++62rO-3jz_=Vwxus7ezKywqyyhG15W5W5zQ@mail.gmail.com>
Message-ID: <CAL_Jsq+2ir9y1E++62rO-3jz_=Vwxus7ezKywqyyhG15W5W5zQ@mail.gmail.com>
Subject: Re: + checkpatch-add-missing-bindings-license-check.patch added to
 mm-nonmm-unstable branch
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     mm-commits@vger.kernel.org, lukas.bulwahn@gmail.com,
        krzysztof.kozlowski@linaro.org, joe@perches.com,
        dwaipayanray1@gmail.com, apw@canonical.com,
        ddrokosov@sberdevices.ru
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Tue, Mar 21, 2023 at 4:44=E2=80=AFPM Andrew Morton <akpm@linux-foundatio=
n.org> wrote:
>
> On Tue, 21 Mar 2023 16:40:29 -0500 Rob Herring <robh@kernel.org> wrote:
>
> > > Link: https://lkml.kernel.org/r/20230320203350.13696-1-ddrokosov@sber=
devices.ru
> >
> > Not a correct link.
>
> Not a helpful comment.
>
> What's wrong with it?

NM, it seems to be Gmail doing something weird. It sends me to:

https://lore.kernel.org/all/20230320203350.13696-1-ddrokosov@sberdevices.ru=
Signed-off-by/T/#u

In any case, this patch is wrong. I'll comment on it directly.

Rob
