Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23DA4C77B61
	for <mm-commits@archiver.kernel.org>; Sun, 16 Apr 2023 13:19:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230323AbjDPNTr (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 16 Apr 2023 09:19:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229458AbjDPNTq (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 16 Apr 2023 09:19:46 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FAB112B
        for <mm-commits@vger.kernel.org>; Sun, 16 Apr 2023 06:19:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 09F8861083
        for <mm-commits@vger.kernel.org>; Sun, 16 Apr 2023 13:19:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73C9DC4339E
        for <mm-commits@vger.kernel.org>; Sun, 16 Apr 2023 13:19:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681651184;
        bh=qbxn5rsplr0xuc0AAxuN2pxowTx2U4KWs7LILRNt+Hg=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=HOH7acY42xrG2xdPVAgYqXwUDmy2hUGZNMfZjzus6/MoN65hzPhQGGxzvk51mW7jc
         hTX2ncqFatMe19Q+9SqFB1AXB9Wc34tXUmXweW+J+yrrZg4C7CcRaFBz8VhRuxbtP2
         C6xUbcMbKh2BYHgJmE1XiwXx5/sl28/yvrzd4zZQauSde5SmjX8DEhWrUKSlWyX1C3
         p5HLCdxDkGihb7De9k+g4g6lYIr6WtOm7ggc+neolNm6HZdMWH2X3osI97H69L6k2R
         vQXfugZiE9KJ6MDbh1Fy00jYEnu7wkD70fCPW0AOYXmvOM0KPBUYlkwidJoSLCugjR
         y/bwqEuJpNRCA==
Received: by mail-oa1-f50.google.com with SMTP id 586e51a60fabf-1879edfeff5so10432375fac.4
        for <mm-commits@vger.kernel.org>; Sun, 16 Apr 2023 06:19:44 -0700 (PDT)
X-Gm-Message-State: AAQBX9d9E4ug+xU133lE5iuBw8WJ44v/co74s0LWUvnNFhQYC+11oNOv
        POLKR6kB4ThRLqI2piEwgkSJ9Nl79uahmi/tXGM=
X-Google-Smtp-Source: AKy350aOEPaJ7btOdOeAwVeHbdmgXZ6EIHOTOy7Iroe4dKSUVX/K/uOuM/ReEzhAIWbasPMPmoBnlDLTvqynK4BgOCs=
X-Received: by 2002:a05:6871:5d1:b0:179:c3d1:42d0 with SMTP id
 v17-20020a05687105d100b00179c3d142d0mr5382047oan.11.1681651183698; Sun, 16
 Apr 2023 06:19:43 -0700 (PDT)
MIME-Version: 1.0
References: <20230412002416.ED32CC433EF@smtp.kernel.org> <CAK7LNATXj+xV3Q_qeO_aO-fBhNif7i7sYQAo0oLVW=M1pGmHEA@mail.gmail.com>
 <20230412053439.GA1949572@pevik>
In-Reply-To: <20230412053439.GA1949572@pevik>
From:   Masahiro Yamada <masahiroy@kernel.org>
Date:   Sun, 16 Apr 2023 22:19:07 +0900
X-Gmail-Original-Message-ID: <CAK7LNARLMmtHFwzwpg9ys+D6+7jonV8g+PCR9QeXiQTukb8VrQ@mail.gmail.com>
Message-ID: <CAK7LNARLMmtHFwzwpg9ys+D6+7jonV8g+PCR9QeXiQTukb8VrQ@mail.gmail.com>
Subject: Re: + uapi-linux-consth-prefer-iso-friendly-__typeof__.patch added to
 mm-nonmm-unstable branch
To:     Petr Vorel <pvorel@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>
Cc:     mm-commits@vger.kernel.org, sam@ravnborg.org,
        ruben.ayrapetyan@arm.com, kevin.brodsky@arm.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

Hi Andrew,



On Wed, Apr 12, 2023 at 2:34=E2=80=AFPM Petr Vorel <pvorel@suse.cz> wrote:
>
> > On Wed, Apr 12, 2023 at 9:24=E2=80=AFAM Andrew Morton <akpm@linux-found=
ation.org> wrote:
>
>
> > > The patch titled
> > >      Subject: uapi/linux/const.h: prefer ISO-friendly __typeof__
> > > has been added to the -mm mm-nonmm-unstable branch.  Its filename is
> > >      uapi-linux-consth-prefer-iso-friendly-__typeof__.patch
>
> > > This patch will shortly appear at
> > >      https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/=
tree/patches/uapi-linux-consth-prefer-iso-friendly-__typeof__.patch
>
> > > This patch will later appear in the mm-nonmm-unstable branch at
> > >     git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
>
> > > Before you just go and hit "reply", please:
> > >    a) Consider who else should be cc'ed
> > >    b) Prefer to cc a suitable mailing list as well
> > >    c) Ideally: find the original patch on the mailing list and do a
> > >       reply-to-all to that, adding suitable additional cc's
>
> > > *** Remember to use Documentation/process/submit-checklist.rst when t=
esting your code ***
>
> > > The -mm tree is included into linux-next via the mm-everything
> > > branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
> > > and is updated there every 2-3 working days
>
> > > ------------------------------------------------------
> > > From: Kevin Brodsky <kevin.brodsky@arm.com>
> > > Subject: uapi/linux/const.h: prefer ISO-friendly __typeof__
> > > Date: Tue, 11 Apr 2023 10:27:47 +0100
>
> > > typeof is (still) a GNU extension, which means that it cannot be used=
 when
> > > building ISO C (e.g.  -std=3Dc99).  It should therefore be avoided in=
 uapi
> > > headers in favour of the ISO-friendly __typeof__.
>
> > > Unfortunately this issue could not be detected by
> > > CONFIG_UAPI_HEADER_TEST=3Dy as the __ALIGN_KERNEL() macro is not expa=
nded in
> > > any uapi header.
>
> > > Link: https://lkml.kernel.org/r/20230411092747.3759032-1-kevin.brodsk=
y@arm.com
> > > Fixes: d6fc9fcbaa65 ("kbuild: compile-test exported headers to ensure=
 they are self-contained")
>
>
> > This tag is wrong.
>
> > The correct one is:
>
> > Fixes: a85cbe6159ff ("uapi: move constants from <linux/kernel.h> to
> > <linux/const.h>")
>
> I'm sorry if I misinterpreted the history. The reason why I think it was
> d6fc9fcbaa65 (which introduced -std=3Dc90) is because there was already s=
ome
> typeof() uses before this commit (uapi/linux/kernel.h and
> uapi/linux/netfilter/x_tables.h).



Sorry, I wrongly read the code.


Fixes: a85cbe6159ff ("uapi: move constants from <linux/kernel.h> to
<linux/const.h>")

was also wrong.


Before a85cbe6159ff, 'typeof' existed in include/uapi/linux/kernel.h.
So, it was exported to userspace.


Kevin suspects 607ca46e97a1 ("UAPI: (Scripted) Disintegrate
include/linux"), but I think the issue goes back more.




I think the following is the first commit that exported it.

Fixes: a79ff731a1b2 ("netfilter: xtables: make XT_ALIGN() usable in
exported headers by exporting __ALIGN_KERNEL()")







--=20
Best Regards
Masahiro Yamada
