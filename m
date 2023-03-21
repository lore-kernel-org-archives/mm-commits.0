Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E70BC6FD20
	for <mm-commits@archiver.kernel.org>; Tue, 21 Mar 2023 21:40:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229555AbjCUVkq (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 21 Mar 2023 17:40:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229694AbjCUVkn (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 21 Mar 2023 17:40:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FE3426C0D
        for <mm-commits@vger.kernel.org>; Tue, 21 Mar 2023 14:40:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0CA3D61E76
        for <mm-commits@vger.kernel.org>; Tue, 21 Mar 2023 21:40:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71EA5C4339C
        for <mm-commits@vger.kernel.org>; Tue, 21 Mar 2023 21:40:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679434841;
        bh=vuQW1XYzaSJ0OdN4sHf581hCEp7wXjE7/eO+gtiX68U=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=hGPo6hesAsFq8ZhGvpM5rSyGHSAro0hZJAjlCTawekxJQJlmz6tFszgf8Vzwc6IF/
         qhw/gM19ueKlkP7eKo4V17K4KgoTg4PkZdScnUgNVGVqZp3Ye+a4VM0+h9hSoKesrE
         NzQNjmxT51ZN5rJo7mVQeS/joeMat3HyFQQSb9S1u/YBrozDfNdaNdkqJwVqrNaqFY
         aRdphmGvSnnfPrRiA+oXeO1pb16eg1Ah1JQKmgzuWmIy6JxAtHIrMXHBqejUWl/wTz
         OK6v9ESE5pgpP4QlXPoABz+xRkA8gxKHlTeC5IkfUlS5Tbj/+SnhG/dKo7xHILjAIS
         pkyWbZsQbZMIQ==
Received: by mail-yw1-f172.google.com with SMTP id 00721157ae682-536af432ee5so305162217b3.0
        for <mm-commits@vger.kernel.org>; Tue, 21 Mar 2023 14:40:41 -0700 (PDT)
X-Gm-Message-State: AAQBX9eaoIxR7T1gIu5KbYpsM3YwO3YV59poF82blpaPdheUbsHNAD4a
        0JC7AD0yHecaiN22FZ6XPw0PfMHus49KA77AFA==
X-Google-Smtp-Source: AKy350YY0vTCPM5PR0bEIhOqHXV3km6B8iNQlRLMRReBUDoQ9mei6f2XEb99mZ8+KeLnfZo/7vTt7fDCwLUeab7cJCY=
X-Received: by 2002:a81:af48:0:b0:541:6aa7:f889 with SMTP id
 x8-20020a81af48000000b005416aa7f889mr1850438ywj.5.1679434840397; Tue, 21 Mar
 2023 14:40:40 -0700 (PDT)
MIME-Version: 1.0
References: <20230321212913.79232C4339B@smtp.kernel.org>
In-Reply-To: <20230321212913.79232C4339B@smtp.kernel.org>
From:   Rob Herring <robh@kernel.org>
Date:   Tue, 21 Mar 2023 16:40:29 -0500
X-Gmail-Original-Message-ID: <CAL_JsqJ2mibR5EKjk494V1T9GsSCwF+5yVB9A3nEntgcrmoTkA@mail.gmail.com>
Message-ID: <CAL_JsqJ2mibR5EKjk494V1T9GsSCwF+5yVB9A3nEntgcrmoTkA@mail.gmail.com>
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

On Tue, Mar 21, 2023 at 4:29=E2=80=AFPM Andrew Morton <akpm@linux-foundatio=
n.org> wrote:
>
>
> The patch titled
>      Subject: checkpatch: add missing bindings license check
> has been added to the -mm mm-nonmm-unstable branch.  Its filename is
>      checkpatch-add-missing-bindings-license-check.patch
>
> This patch will shortly appear at
>      https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree=
/patches/checkpatch-add-missing-bindings-license-check.patch
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
> From: Dmitry Rokosov <ddrokosov@sberdevices.ru>
> Subject: checkpatch: add missing bindings license check
> Date: Mon, 20 Mar 2023 23:33:50 +0300
>
> All headers from 'include/dt-bindings/' must be verified by checkpatch
> together with Documentation bindings, because all of them are part of the
> whole DT bindings system.
>
> The requirement is dual licensed and matching pattern:
>     /GPL-2\.0(?:-only|-or-later|\+)? (?:OR|or) BSD-2-Clause/
>
> The issue was found during patch review:
> https://lore.kernel.org/all/20230313201259.19998-4-ddrokosov@sberdevices.=
ru/
>
> Link: https://lkml.kernel.org/r/20230320203350.13696-1-ddrokosov@sberdevi=
ces.ru

Not a correct link.

> Signed-off-by: Dmitry Rokosov <ddrokosov@sberdevices.ru>
> Acked-by: Joe Perches <joe@perches.com>
> Cc: Andy Whitcroft <apw@canonical.com>
> Cc: Dwaipayan Ray <dwaipayanray1@gmail.com>
> Cc: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
> Cc: Lukas Bulwahn <lukas.bulwahn@gmail.com>
> Cc: Rob Herring <robh@kernel.org>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
>
>  scripts/checkpatch.pl |    5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
>
> --- a/scripts/checkpatch.pl~checkpatch-add-missing-bindings-license-check
> +++ a/scripts/checkpatch.pl
> @@ -3735,8 +3735,9 @@ sub process {
>                                                 WARN("SPDX_LICENSE_TAG",
>                                                      "'$spdx_license' is =
not supported in LICENSES/...\n" . $herecurr);
>                                         }
> -                                       if ($realfile =3D~ m@^Documentati=
on/devicetree/bindings/@ &&
> -                                           not $spdx_license =3D~ /GPL-2=
\.0.*BSD-2-Clause/) {
> +                                       if (($realfile =3D~ m@^Documentat=
ion/devicetree/bindings/@ ||
> +                                            $realfile =3D~ m@^include/dt=
-bindings/@) &&
> +                                           $spdx_license !~ /GPL-2\.0(?:=
-only|-or-later|\+)? (?:OR|or) BSD-2-Clause/) {
>                                                 my $msg_level =3D \&WARN;
>                                                 $msg_level =3D \&CHK if (=
$file);
>                                                 if (&{$msg_level}("SPDX_L=
ICENSE_TAG",
> _
>
> Patches currently in -mm which might be from ddrokosov@sberdevices.ru are
>
> checkpatch-add-missing-bindings-license-check.patch
>
