Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C09FC77B7E
	for <mm-commits@archiver.kernel.org>; Thu,  1 Jun 2023 20:27:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232441AbjFAU1q (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 1 Jun 2023 16:27:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229899AbjFAU1p (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 1 Jun 2023 16:27:45 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74B8C128
        for <mm-commits@vger.kernel.org>; Thu,  1 Jun 2023 13:27:43 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id a640c23a62f3a-96f50e26b8bso194020066b.2
        for <mm-commits@vger.kernel.org>; Thu, 01 Jun 2023 13:27:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1685651261; x=1688243261;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fKRfw0lWfkZ4Rw+QIglDGbIdZDYKwbBCbvLy+wInXqI=;
        b=W5GeRdc8J/pTdkeeZjfFiUu/Gr1hlAAdA6n6aMw17jFAc3ZxpOeRzXq5yBj8t7mR2O
         +XdE4GunzctS/hXOLtrQroO6cEt903s7h4PTX5eYAWWnPOK+egXZ8MIoKEaYX0GgQ/U7
         xhhWHhR0nYWNlD8I92ad9efCHrexmcEE6J3el+Nv6bHYzeIQL5Rc8fUv7Rr2yBpmb4np
         qfXY7JUDUVsyh012krSwXZZUSHPHZMtchMFirEFcnFw1knTer6iKmsBHYG7Xgxd/9GeE
         07t8qIdBSEAqxvdEYtyP2NePf0HFjsZFla4In6USbNdfQXAoNnfpaZn3bCIc+hXb5eQZ
         fiIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685651261; x=1688243261;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fKRfw0lWfkZ4Rw+QIglDGbIdZDYKwbBCbvLy+wInXqI=;
        b=Q33Cf4AAndnhd71OCjO2wtXDpfJHwJT2vkYAzv93Qdt0GYyKjf1HSORqm/gikscNzJ
         6qW+K9nkzQ14qVIHA0JhhA8WcSmPUiQM+n/P6R4blaCJduktDtEgdEK+pZAPmqBs45aj
         hDl4ZrhKm1V+2tvynY17h2RbfkkJaXNS4gVYAyfoauI3RRcR+cWn1Q2HWsfacc362dJf
         F0Mjs4KrONrrQboFQ9YCdq4vRd7lB7cN3/JzkKUEHbxqIlsuhNBe1hKQqedwP2jvIDD3
         pUrVEMpOcoNxQ8OQYISOURvVmJ1B5bY140OjjzmbuHGUa8a02JcqOIH65ShZ2/GzjNLW
         0Fdg==
X-Gm-Message-State: AC+VfDw7Fuo7xh4+72j3KcB8uxR/3axYxpKjc277r25GcHX6kvvDzfzk
        zyxoqB02OIY7YX1SpznRC6ulRpFA79mgRoxgbpleFg==
X-Google-Smtp-Source: ACHHUZ6Htsi9CClWKmGzSbDNJYEXc2xCK4kIadkIsnEQlTIA3eoslUj68hE1F8bFca9G4itQyC7kueBW4mxfOizYZS8=
X-Received: by 2002:a17:907:72d6:b0:96f:45cd:6c21 with SMTP id
 du22-20020a17090772d600b0096f45cd6c21mr3880335ejc.30.1685651261347; Thu, 01
 Jun 2023 13:27:41 -0700 (PDT)
MIME-Version: 1.0
References: <20230601202028.EA4B6C433EF@smtp.kernel.org> <CAJD7tkZqVwumkMf30T4qed-x1OxDWF4LTYY=LjOzXbX0MMOB4Q@mail.gmail.com>
In-Reply-To: <CAJD7tkZqVwumkMf30T4qed-x1OxDWF4LTYY=LjOzXbX0MMOB4Q@mail.gmail.com>
From:   Yosry Ahmed <yosryahmed@google.com>
Date:   Thu, 1 Jun 2023 13:27:05 -0700
Message-ID: <CAJD7tkZGYj2yiwk5qd=_bqqnxT-Zd+BtFdqRV_xHk2iX+2Rh_g@mail.gmail.com>
Subject: Re: + zswap-do-not-shrink-if-cgroup-may-not-zswap-fix.patch added to
 mm-hotfixes-unstable branch
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     mm-commits@vger.kernel.org, vitaly.wool@konsulko.com,
        sjenning@redhat.com, nphamcs@gmail.com, lkp@intel.com,
        hannes@cmpxchg.org, ddstreet@ieee.org, cerasuolodomenico@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Thu, Jun 1, 2023 at 1:25=E2=80=AFPM Yosry Ahmed <yosryahmed@google.com> =
wrote:
>
> On Thu, Jun 1, 2023 at 1:20=E2=80=AFPM Andrew Morton <akpm@linux-foundati=
on.org> wrote:
> >
> >
> > The patch titled
> >      Subject: zswap-do-not-shrink-if-cgroup-may-not-zswap-fix
> > has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
> >      zswap-do-not-shrink-if-cgroup-may-not-zswap-fix.patch
> >
> > This patch will shortly appear at
> >      https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tr=
ee/patches/zswap-do-not-shrink-if-cgroup-may-not-zswap-fix.patch
> >
> > This patch will later appear in the mm-hotfixes-unstable branch at
> >     git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
> >
> > Before you just go and hit "reply", please:
> >    a) Consider who else should be cc'ed
> >    b) Prefer to cc a suitable mailing list as well
> >    c) Ideally: find the original patch on the mailing list and do a
> >       reply-to-all to that, adding suitable additional cc's
> >
> > *** Remember to use Documentation/process/submit-checklist.rst when tes=
ting your code ***
> >
> > The -mm tree is included into linux-next via the mm-everything
> > branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
> > and is updated there every 2-3 working days
> >
> > ------------------------------------------------------
> > From: Andrew Morton <akpm@linux-foundation.org>
> > Subject: zswap-do-not-shrink-if-cgroup-may-not-zswap-fix
> > Date: Thu Jun  1 01:17:06 PM PDT 2023
> >
> > fix return of unintialized value
> >
> > Reported-by: kernel test robot <lkp@intel.com>
> > Closes: https://lore.kernel.org/oe-kbuild-all/202306011435.2BxsHFUE-lkp=
@intel.com/
> > Cc: Dan Streetman <ddstreet@ieee.org>
> > Cc: Domenico Cerasuolo <cerasuolodomenico@gmail.com>
> > Cc: Johannes Weiner <hannes@cmpxchg.org>
> > Cc: Nhat Pham <nphamcs@gmail.com>
> > Cc: Seth Jennings <sjenning@redhat.com>
> > Cc: Vitaly Wool <vitaly.wool@konsulko.com>
> > Cc: Yosry Ahmed <yosryahmed@google.com>
> > Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> > ---
> >
> >  mm/zswap.c |    4 +++-
> >  1 file changed, 3 insertions(+), 1 deletion(-)
> >
> > --- a/mm/zswap.c~zswap-do-not-shrink-if-cgroup-may-not-zswap-fix
> > +++ a/mm/zswap.c
> > @@ -1180,8 +1180,10 @@ static int zswap_frontswap_store(unsigne
> >          * local cgroup limits.
> >          */
> >         objcg =3D get_obj_cgroup_from_page(page);
> > -       if (objcg && !obj_cgroup_may_zswap(objcg))
> > +       if (objcg && !obj_cgroup_may_zswap(objcg)) {
> > +               ret =3D -ENOSPC;
>
> Hey Andrew,
>
> I thought we agreed this should be -ENOMEM (as in Nathan's patch). Am
> I missing something?

Oh I just realized what happened. You got a separate report about
this, independent from Nathan's patch. Here is the patch I am
referring to:
https://lore.kernel.org/llvm/20230601-zswap-cgroup-wsometimes-uninitialized=
-v2-1-84912684ac35@kernel.org/

>
>
> >                 goto reject;
> > +       }
> >
> >         /* reclaim space if needed */
> >         if (zswap_is_full()) {
> > _
> >
> > Patches currently in -mm which might be from akpm@linux-foundation.org =
are
> >
> > zswap-do-not-shrink-if-cgroup-may-not-zswap-fix.patch
> > mm-compaction-optimize-compact_memory-to-comply-with-the-admin-guide-fi=
x.patch
> > mm-page_owner-add-page_owner_stacks-file-to-print-out-only-stacks-and-t=
heir-counte-fix.patch
> > mm-page_owner-add-page_owner_stacks-file-to-print-out-only-stacks-and-t=
heir-counte-fix-fix.patch
> > mmpage_owner-filter-out-stacks-by-a-threshold-counter-fix.patch
> > mm-mlock-rename-mlock_future_check-to-mlock_future_ok.patch
> > mm-zswap-multiple-zpools-support-fix.patch
> > fork-optimize-memcg_charge_kernel_stack-a-bit-fix.patch
> > squashfs-cache-partial-compressed-blocks-fix.patch
> > squashfs-cache-partial-compressed-blocks-fix-3-fix.patch
> > init-add-bdev-fs-printk-if-mount_block_root-failed-fix.patch
> > kexec-add-helper-__crash_shrink_memory-fix.patch
> >
