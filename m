Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 501C6C77B7E
	for <mm-commits@archiver.kernel.org>; Thu,  1 Jun 2023 20:26:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231890AbjFAU0S (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 1 Jun 2023 16:26:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231698AbjFAU0R (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 1 Jun 2023 16:26:17 -0400
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C9A8128
        for <mm-commits@vger.kernel.org>; Thu,  1 Jun 2023 13:26:16 -0700 (PDT)
Received: by mail-ej1-x632.google.com with SMTP id a640c23a62f3a-974265a1a40so557934966b.0
        for <mm-commits@vger.kernel.org>; Thu, 01 Jun 2023 13:26:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1685651175; x=1688243175;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Hm8TNRGvNAlqpoAxxOWBvDmeCMyV+GXPfkVfEovPu+w=;
        b=1x4HFtZ1HZpG8KaXfy+/5Dtrf00tg4LH0mZsDuE/SMlTiFObkU8B/jWY1Xu6a4UwmZ
         O3WDKUfA2vHwSoXfT+PfmSKssZhgPy2ny3JQ6NXQ8xhuts9Z30CzHGz2nSRXkhCAntyP
         6OCvW5cwcK3/uVnTFQnAh8mv2TRXRDtCIXQL+K9VknDMupsNq4ChpbBFagfa8gYDYFBf
         3L5k04Rdfy7YGdp6dPsbYkwKI6ZugnBYxt3bxtTUlweCKQowpEJkU+UMszAwaUO0DZaC
         ukCgUxe7h+F9HyRiEsYpampE1yLPcLLoTUkGb6hUthn3Ed/nQvmCML+w7EAklcfGFBV/
         om8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685651175; x=1688243175;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Hm8TNRGvNAlqpoAxxOWBvDmeCMyV+GXPfkVfEovPu+w=;
        b=Bnu2h5MTXIy9YhQI1jwwqXp67aLBp768vrETXcTD9tZ1UBrgBgUW1FgX8d2o7FpKoE
         Em5XGLT27SzpGpOzAniKX8Ewi+rGOdlxwgX3CfxV4fwd0XokRh6n9LwH0gnwQ9MRA+Y4
         2Lj0/Hu7Dwb9asZIDYG8WaAfqPB+s4RpCaLlRmdLWjeEl2BBOMWVsri4/Q4TOwLaeGCJ
         BlUwlNJ2sfFzYGoxmgJPZn39onbxPQUsQ5QKy1PNtR9HI4Y69m486pBJwaFGHhbRopHJ
         QoBr+ptCbM6RhdIIkU6OBfjw8shErtKCHPb11yQvqkILmJiMxHm3cDEYSum5H4FOR+9S
         ckEA==
X-Gm-Message-State: AC+VfDyNGiWUe6MATpBWc9oi00OhWJewktfJqzv6ywmvMio9didtxEon
        Q2o1k+5fqXiBV50Fv3REphsTl2+7wgtrBG5aPIF6fA==
X-Google-Smtp-Source: ACHHUZ6xYi93cw/jNOQHtvTrU/m3S5jDtjVt5LulaGl4Ms1zOcHP4YhrtXi/yn4bdTD+nD7H0Qe/GHRNy55Vxf5kLJQ=
X-Received: by 2002:a17:907:86a3:b0:968:892b:1902 with SMTP id
 qa35-20020a17090786a300b00968892b1902mr2660093ejc.6.1685651174607; Thu, 01
 Jun 2023 13:26:14 -0700 (PDT)
MIME-Version: 1.0
References: <20230601202028.EA4B6C433EF@smtp.kernel.org>
In-Reply-To: <20230601202028.EA4B6C433EF@smtp.kernel.org>
From:   Yosry Ahmed <yosryahmed@google.com>
Date:   Thu, 1 Jun 2023 13:25:37 -0700
Message-ID: <CAJD7tkZqVwumkMf30T4qed-x1OxDWF4LTYY=LjOzXbX0MMOB4Q@mail.gmail.com>
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

On Thu, Jun 1, 2023 at 1:20=E2=80=AFPM Andrew Morton <akpm@linux-foundation=
.org> wrote:
>
>
> The patch titled
>      Subject: zswap-do-not-shrink-if-cgroup-may-not-zswap-fix
> has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
>      zswap-do-not-shrink-if-cgroup-may-not-zswap-fix.patch
>
> This patch will shortly appear at
>      https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree=
/patches/zswap-do-not-shrink-if-cgroup-may-not-zswap-fix.patch
>
> This patch will later appear in the mm-hotfixes-unstable branch at
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
> From: Andrew Morton <akpm@linux-foundation.org>
> Subject: zswap-do-not-shrink-if-cgroup-may-not-zswap-fix
> Date: Thu Jun  1 01:17:06 PM PDT 2023
>
> fix return of unintialized value
>
> Reported-by: kernel test robot <lkp@intel.com>
> Closes: https://lore.kernel.org/oe-kbuild-all/202306011435.2BxsHFUE-lkp@i=
ntel.com/
> Cc: Dan Streetman <ddstreet@ieee.org>
> Cc: Domenico Cerasuolo <cerasuolodomenico@gmail.com>
> Cc: Johannes Weiner <hannes@cmpxchg.org>
> Cc: Nhat Pham <nphamcs@gmail.com>
> Cc: Seth Jennings <sjenning@redhat.com>
> Cc: Vitaly Wool <vitaly.wool@konsulko.com>
> Cc: Yosry Ahmed <yosryahmed@google.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
>
>  mm/zswap.c |    4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
>
> --- a/mm/zswap.c~zswap-do-not-shrink-if-cgroup-may-not-zswap-fix
> +++ a/mm/zswap.c
> @@ -1180,8 +1180,10 @@ static int zswap_frontswap_store(unsigne
>          * local cgroup limits.
>          */
>         objcg =3D get_obj_cgroup_from_page(page);
> -       if (objcg && !obj_cgroup_may_zswap(objcg))
> +       if (objcg && !obj_cgroup_may_zswap(objcg)) {
> +               ret =3D -ENOSPC;

Hey Andrew,

I thought we agreed this should be -ENOMEM (as in Nathan's patch). Am
I missing something?


>                 goto reject;
> +       }
>
>         /* reclaim space if needed */
>         if (zswap_is_full()) {
> _
>
> Patches currently in -mm which might be from akpm@linux-foundation.org ar=
e
>
> zswap-do-not-shrink-if-cgroup-may-not-zswap-fix.patch
> mm-compaction-optimize-compact_memory-to-comply-with-the-admin-guide-fix.=
patch
> mm-page_owner-add-page_owner_stacks-file-to-print-out-only-stacks-and-the=
ir-counte-fix.patch
> mm-page_owner-add-page_owner_stacks-file-to-print-out-only-stacks-and-the=
ir-counte-fix-fix.patch
> mmpage_owner-filter-out-stacks-by-a-threshold-counter-fix.patch
> mm-mlock-rename-mlock_future_check-to-mlock_future_ok.patch
> mm-zswap-multiple-zpools-support-fix.patch
> fork-optimize-memcg_charge_kernel_stack-a-bit-fix.patch
> squashfs-cache-partial-compressed-blocks-fix.patch
> squashfs-cache-partial-compressed-blocks-fix-3-fix.patch
> init-add-bdev-fs-printk-if-mount_block_root-failed-fix.patch
> kexec-add-helper-__crash_shrink_memory-fix.patch
>
