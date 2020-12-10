Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 618FCC433FE
	for <mm-commits@archiver.kernel.org>; Thu, 10 Dec 2020 07:51:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0DD1823B97
	for <mm-commits@archiver.kernel.org>; Thu, 10 Dec 2020 07:51:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727034AbgLJHvm (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 10 Dec 2020 02:51:42 -0500
Received: from condef-01.nifty.com ([202.248.20.66]:22592 "EHLO
        condef-01.nifty.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726107AbgLJHvm (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 10 Dec 2020 02:51:42 -0500
X-Greylist: delayed 514 seconds by postgrey-1.27 at vger.kernel.org; Thu, 10 Dec 2020 02:51:41 EST
Received: from conssluserg-04.nifty.com ([10.126.8.83])by condef-01.nifty.com with ESMTP id 0BA7cdvT015200
        for <mm-commits@vger.kernel.org>; Thu, 10 Dec 2020 16:38:39 +0900
Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181]) (authenticated)
        by conssluserg-04.nifty.com with ESMTP id 0BA7bgmY031426
        for <mm-commits@vger.kernel.org>; Thu, 10 Dec 2020 16:37:43 +0900
DKIM-Filter: OpenDKIM Filter v2.10.3 conssluserg-04.nifty.com 0BA7bgmY031426
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nifty.com;
        s=dec2015msa; t=1607585863;
        bh=47Ms2NZcPAO2iGbl2wmXwjhs1cenZ5a6h2ETk0RyCS4=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=cGq0+PhFUH5XuFoFpYlxu2O4Dq4z6IBLTjdtny7s1y6FJYMoqzYtrWrdTZtQjNZ1A
         aNuItwPaz9FPluQ19K4P/mZgLk9dAhLC9YrCGFqXklTpN0mTUwTuy9VfDCS6VzlEkW
         ANmXrAZyPtFIHEu2KAuU4dm7joiji5w2KcxJGvF800bmVreLr59QvJxl0L2Frj2whF
         UPnlfkKGqENzMOmWwmikGTRp78w/RPLJZnMkSpEVXwJe937vckGspu/Gkf6+tz079B
         AmpHEAYmAGN+SZVx5GZTTfnVPOi6S+W3UrZVAe/rnra6u8iEGdOcBcbGOU/BNDtHW3
         YqmuQoTfFQdbw==
X-Nifty-SrcIP: [209.85.210.181]
Received: by mail-pf1-f181.google.com with SMTP id 11so3242548pfu.4
        for <mm-commits@vger.kernel.org>; Wed, 09 Dec 2020 23:37:43 -0800 (PST)
X-Gm-Message-State: AOAM530tvS7EwJTIFPqx4TGeH5pnT/LjDXQPgBg0Vbrw8xv3Z0jqaN8k
        oWYxw+hHy9M1KDXlDrtBxxDfvhaqr/u6EuEfSp8=
X-Google-Smtp-Source: ABdhPJzacveqnnM/vYHo/Bsuv0KG1SBLu3V6D2yit4qQApVzZg4L+FeRrEpww48sKeIosKjtO664VTPpZKyUspLifvA=
X-Received: by 2002:a17:90a:c910:: with SMTP id v16mr6182646pjt.198.1607585862314;
 Wed, 09 Dec 2020 23:37:42 -0800 (PST)
MIME-Version: 1.0
References: <20201210003853.J33XN%akpm@linux-foundation.org> <20201209184021.13c340d5b8e15b415f43b521@linux-foundation.org>
In-Reply-To: <20201209184021.13c340d5b8e15b415f43b521@linux-foundation.org>
From:   Masahiro Yamada <masahiroy@kernel.org>
Date:   Thu, 10 Dec 2020 16:37:05 +0900
X-Gmail-Original-Message-ID: <CAK7LNAQXy8fdhQTCqe-S2Zs17HnHSKcKm6=v_hMzAXKqV7619g@mail.gmail.com>
Message-ID: <CAK7LNAQXy8fdhQTCqe-S2Zs17HnHSKcKm6=v_hMzAXKqV7619g@mail.gmail.com>
Subject: Re: + scripts-ld-versionsh-fix-build.patch added to -mm tree
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     mm-commits@vger.kernel.org,
        Dominique Martinet <asmadeus@codewreck.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Thu, Dec 10, 2020 at 11:40 AM Andrew Morton
<akpm@linux-foundation.org> wrote:
>
> On Wed, 09 Dec 2020 16:38:53 -0800 akpm@linux-foundation.org wrote:
>
> > i386:
> >
> > X1:/usr/src/25> make allmodconfig
> > /usr/bin/env: invalid option -- 'S'
> > Try '/usr/bin/env --help' for more information.
> > init/Kconfig:39: syntax error
> > init/Kconfig:38: invalid statement
> >
> > ...
> >
> > --- a/scripts/ld-version.sh~scripts-ld-versionsh-fix-build
> > +++ a/scripts/ld-version.sh
> > @@ -1,4 +1,4 @@
> > -#!/usr/bin/env -S awk -f
> > +#!/usr/bin/awk -f
> >  # SPDX-License-Identifier: GPL-2.0
> >  # extract linker version number from stdin and turn into single number
> >       {
>
> My /usr/bin/env is from coreutils-8.28-1ubuntu2


I dropped the offending patch.



--
Best Regards
Masahiro Yamada
