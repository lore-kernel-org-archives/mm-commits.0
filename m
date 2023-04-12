Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29E07C7619A
	for <mm-commits@archiver.kernel.org>; Wed, 12 Apr 2023 01:33:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229452AbjDLBdt (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 11 Apr 2023 21:33:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229498AbjDLBds (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 11 Apr 2023 21:33:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F0FD4C24
        for <mm-commits@vger.kernel.org>; Tue, 11 Apr 2023 18:33:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E0AE062821
        for <mm-commits@vger.kernel.org>; Wed, 12 Apr 2023 01:33:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D06DC433A0
        for <mm-commits@vger.kernel.org>; Wed, 12 Apr 2023 01:33:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681263219;
        bh=pfo9Q0+857fZadkfZqJb3ZHGUn57YRUkdu7dsT2iBFM=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=jDeScBRx3dAwdshYUqQ0GW56RiFsTv/Lqk0jfJGeccL3bibWcENL9LbzNH0CAiNMf
         tQRWCvai2Ypte7ypvC3Q4XnJIZpCTMoyt9lHIjhEXguffWrkiGGlU0W1toRmUl00lU
         VW4S/2P1F23XSJq2GbfY3+fpqo/od6t4/iiogKj4xYUQCPrrTX1ktN0v0Id+uRsLeP
         /9FNDOEwtuB/SI1Il9+LDHn5eOCOItHNUFyrmMeOTrWJwxh/vVlGFigydUMfI2MOvB
         5bsruv4Cwix8Cwisp8rcNtpKy58XXDiJnmTjrdB6krx4oniiGWQe1OSq71qP2Zn5gE
         zApZpm7pFPSqQ==
Received: by mail-ot1-f44.google.com with SMTP id q33-20020a056830442100b006a419d3fd20so331284otv.7
        for <mm-commits@vger.kernel.org>; Tue, 11 Apr 2023 18:33:39 -0700 (PDT)
X-Gm-Message-State: AAQBX9f7Lja7Pw6S56jnURx8CAEr3r217wivpK/7anJQIMcGoz2PkecM
        4tsIpL/33DT3askdxvTGoIbZBJU2IC+4BPb4xmE=
X-Google-Smtp-Source: AKy350YpUrxetLOGEjg4hEgQu+BqY9fS4fDkzaHV9cW8FgT2YqfSTloIiUmtPOrifP7APM9PZRNyzTP2bN+T4yNrJRU=
X-Received: by 2002:a05:6830:60c:b0:6a2:e6f6:b484 with SMTP id
 w12-20020a056830060c00b006a2e6f6b484mr290742oti.1.1681263218587; Tue, 11 Apr
 2023 18:33:38 -0700 (PDT)
MIME-Version: 1.0
References: <20230412002416.ED32CC433EF@smtp.kernel.org>
In-Reply-To: <20230412002416.ED32CC433EF@smtp.kernel.org>
From:   Masahiro Yamada <masahiroy@kernel.org>
Date:   Wed, 12 Apr 2023 10:33:02 +0900
X-Gmail-Original-Message-ID: <CAK7LNATXj+xV3Q_qeO_aO-fBhNif7i7sYQAo0oLVW=M1pGmHEA@mail.gmail.com>
Message-ID: <CAK7LNATXj+xV3Q_qeO_aO-fBhNif7i7sYQAo0oLVW=M1pGmHEA@mail.gmail.com>
Subject: Re: + uapi-linux-consth-prefer-iso-friendly-__typeof__.patch added to
 mm-nonmm-unstable branch
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     mm-commits@vger.kernel.org, sam@ravnborg.org,
        ruben.ayrapetyan@arm.com, pvorel@suse.cz, kevin.brodsky@arm.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Wed, Apr 12, 2023 at 9:24=E2=80=AFAM Andrew Morton <akpm@linux-foundatio=
n.org> wrote:
>
>
> The patch titled
>      Subject: uapi/linux/const.h: prefer ISO-friendly __typeof__
> has been added to the -mm mm-nonmm-unstable branch.  Its filename is
>      uapi-linux-consth-prefer-iso-friendly-__typeof__.patch
>
> This patch will shortly appear at
>      https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree=
/patches/uapi-linux-consth-prefer-iso-friendly-__typeof__.patch
>
> This patch will later appear in the mm-nonmm-unstable branch at
>     git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
>
> Before you just go and hit "reply", please:
>    a) Consider who else should be cc'ed
>    b) Prefer to cc a suitable mailing list as well
>    c) Ideally: find the original patch on the mailing list and do a
>       reply-to-all to that, adding suitable additional cc's
>
> *** Remember to use Documentation/process/submit-checklist.rst when testi=
ng your code ***
>
> The -mm tree is included into linux-next via the mm-everything
> branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
> and is updated there every 2-3 working days
>
> ------------------------------------------------------
> From: Kevin Brodsky <kevin.brodsky@arm.com>
> Subject: uapi/linux/const.h: prefer ISO-friendly __typeof__
> Date: Tue, 11 Apr 2023 10:27:47 +0100
>
> typeof is (still) a GNU extension, which means that it cannot be used whe=
n
> building ISO C (e.g.  -std=3Dc99).  It should therefore be avoided in uap=
i
> headers in favour of the ISO-friendly __typeof__.
>
> Unfortunately this issue could not be detected by
> CONFIG_UAPI_HEADER_TEST=3Dy as the __ALIGN_KERNEL() macro is not expanded=
 in
> any uapi header.
>
> Link: https://lkml.kernel.org/r/20230411092747.3759032-1-kevin.brodsky@ar=
m.com
> Fixes: d6fc9fcbaa65 ("kbuild: compile-test exported headers to ensure the=
y are self-contained")


This tag is wrong.

The correct one is:

Fixes: a85cbe6159ff ("uapi: move constants from <linux/kernel.h> to
<linux/const.h>")



Reviewed-by: Masahiro Yamada <masahiroy@kernel.org>




> Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
> Reported-by: Ruben Ayrapetyan <ruben.ayrapetyan@arm.com>
> Tested-by: Ruben Ayrapetyan <ruben.ayrapetyan@arm.com>
> Reviewed-by: Petr Vorel <pvorel@suse.cz>
> Tested-by: Petr Vorel <pvorel@suse.cz>
> Cc: Masahiro Yamada <masahiroy@kernel.org>
> Cc: Sam Ravnborg <sam@ravnborg.org>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
>
>  include/uapi/linux/const.h |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> --- a/include/uapi/linux/const.h~uapi-linux-consth-prefer-iso-friendly-__=
typeof__
> +++ a/include/uapi/linux/const.h
> @@ -28,7 +28,7 @@
>  #define _BITUL(x)      (_UL(1) << (x))
>  #define _BITULL(x)     (_ULL(1) << (x))
>
> -#define __ALIGN_KERNEL(x, a)           __ALIGN_KERNEL_MASK(x, (typeof(x)=
)(a) - 1)
> +#define __ALIGN_KERNEL(x, a)           __ALIGN_KERNEL_MASK(x, (__typeof_=
_(x))(a) - 1)
>  #define __ALIGN_KERNEL_MASK(x, mask)   (((x) + (mask)) & ~(mask))
>
>  #define __KERNEL_DIV_ROUND_UP(n, d) (((n) + (d) - 1) / (d))
> _
>
> Patches currently in -mm which might be from kevin.brodsky@arm.com are
>
> uapi-linux-consth-prefer-iso-friendly-__typeof__.patch
>


--=20
Best Regards
Masahiro Yamada
