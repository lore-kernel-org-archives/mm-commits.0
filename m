Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B066C19F28
	for <mm-commits@archiver.kernel.org>; Wed, 27 Jul 2022 02:44:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230123AbiG0Cor (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 26 Jul 2022 22:44:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229906AbiG0Coq (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 26 Jul 2022 22:44:46 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5B0B1D0F9
        for <mm-commits@vger.kernel.org>; Tue, 26 Jul 2022 19:44:45 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id bp15so29226272ejb.6
        for <mm-commits@vger.kernel.org>; Tue, 26 Jul 2022 19:44:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=A4L32VE6kvKti3KKhEb9lK8EMur2ZOwPaypSWd8gNXI=;
        b=TRDG4vw7oes6o7i3NTIYJXaz/zQxayVyuCpdM4e/fCENWhjHC98nv2MEC0Qjg4wXVO
         cRDJJA5bn8isarocXIldSW3+e8p0+/75cYlWWGm3aOp1FoKRBtxCplVb9elJAINL2a7S
         gcGqUcxCxAhoRwZac+faXGqBnVKOyrujLhgE8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=A4L32VE6kvKti3KKhEb9lK8EMur2ZOwPaypSWd8gNXI=;
        b=AYASasxAp89AagPa5pnsruy8OeK6dnYZor3Qj7C9YpZ1oj36TE3+DNvvuh9WY7I4Qp
         8MIO2iDVifsI7LxKwoxZEsV0YkDIJp4DZkteIVtTVMtHmoUXSo0d52BIL8Haw/xh6bMM
         OLWyot/7fp008zDMPKrh80g6+rge3TLp1+kxR7Ie1MwdSjcl1nKNuxGDoLIFDsEBVMDX
         +l2NcTUIW3VjzVS1ccr2krOcWhefbWwSJylfzjAlS4AosSqp0gVNlOvA2sSzDZah3TGz
         oP5CxGiNeXphE9PO8vRXgygjurZdHIQndYsuRv1uVWXFcU4a80cRayWGXMHDf0slXQyw
         7fEA==
X-Gm-Message-State: AJIora+e/hamVgyXMAHUMDPvCTehxAd2wz1yhikpVJh2eY6T5DZpK0cK
        em8P43TxjWkn78qkFAzICjf34YVenP2NeCTm
X-Google-Smtp-Source: AGRyM1sJlAzTrWabj4AdTpO0HdQXHtEyYguy0xlz6GMJxINSoxP6Ax56ylrUqQN8indOjPJoUelvKw==
X-Received: by 2002:a17:906:5d16:b0:72f:248d:525a with SMTP id g22-20020a1709065d1600b0072f248d525amr16673212ejt.441.1658889883730;
        Tue, 26 Jul 2022 19:44:43 -0700 (PDT)
Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com. [209.85.221.43])
        by smtp.gmail.com with ESMTPSA id sd31-20020a1709076e1f00b00711edab7622sm7003042ejc.40.2022.07.26.19.44.43
        for <mm-commits@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 26 Jul 2022 19:44:43 -0700 (PDT)
Received: by mail-wr1-f43.google.com with SMTP id v17so3470343wrr.10
        for <mm-commits@vger.kernel.org>; Tue, 26 Jul 2022 19:44:43 -0700 (PDT)
X-Received: by 2002:a5d:59a4:0:b0:21e:8704:ea35 with SMTP id
 p4-20020a5d59a4000000b0021e8704ea35mr8166161wrr.442.1658889882784; Tue, 26
 Jul 2022 19:44:42 -0700 (PDT)
MIME-Version: 1.0
References: <20220726184208.db1dc1adf4f59b86f0e5099a@linux-foundation.org>
In-Reply-To: <20220726184208.db1dc1adf4f59b86f0e5099a@linux-foundation.org>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Tue, 26 Jul 2022 19:44:26 -0700
X-Gmail-Original-Message-ID: <CAHk-=wiWJgQ1hU2XXeg-Qt8GEReJEqvrKWPezg-gcX58-SLHjQ@mail.gmail.com>
Message-ID: <CAHk-=wiWJgQ1hU2XXeg-Qt8GEReJEqvrKWPezg-gcX58-SLHjQ@mail.gmail.com>
Subject: Re: [GIT PULL] hotfixes for 5.19
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     linux-mm@kvack.org, mm-commits@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Tue, Jul 26, 2022 at 6:42 PM Andrew Morton <akpm@linux-foundation.org> wrote:
>
> Linus,  please merge this bunch of hotfixes for the 5.19 release.

You've screwed up your git committer name again.

I thought you fixed it, but maybe you had another machine with that
bogus GIT_COMMITTER_NAME environment variable set?

So all your committer info looks like "akpm <akpm@linux-foundation.org>"

I've pulled this, since it's clearly not fatal, but please go back and
look at your broken environment variables..

               Linus
