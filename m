Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC0DBC433EF
	for <mm-commits@archiver.kernel.org>; Fri, 27 May 2022 18:45:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353052AbiE0SpK (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 27 May 2022 14:45:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349993AbiE0SpJ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 27 May 2022 14:45:09 -0400
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF93E106376
        for <mm-commits@vger.kernel.org>; Fri, 27 May 2022 11:45:07 -0700 (PDT)
Received: by mail-ed1-x52d.google.com with SMTP id j28so6437534eda.13
        for <mm-commits@vger.kernel.org>; Fri, 27 May 2022 11:45:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=52zOsCc6qEBLSd0EvVPsjC9FUkx7ysoIDr7i7kJhu7I=;
        b=eViVbPMW3o5xWiLGbwthVcpGNrkna0bmofKE98fV4grdZ6eH74UtthI/lzXo3RPIjz
         RwnfnWgzerkx2YzKRb/M9ndnInTc35IAUyAVqW91mVF2CtO8uqf6h5cuCiAiSN2JPaGP
         jC2VXu6WQjuai5tXQAtG6xajiwkx+dnQ+3/T0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=52zOsCc6qEBLSd0EvVPsjC9FUkx7ysoIDr7i7kJhu7I=;
        b=DM3B6hcf8WTLHID01aLXYZsDswlk7rpgU1vZnpkGDjCxdnwBi4KGShLW91aTj8iOoL
         BlaAeKbSkmONEc5C9xZobM/ojN5oa9lepNODny1ctYLvgHaMSIWCUCI5G2VydHAapgoB
         XiFzCkMVy6H/kj8TEHvp7JZ+MYlMpCI+ZKoNfda11ZlZVSfSpyQe9YnBlQwCY3iRq/t+
         fJ02p17b6cLXi+3RlbkSdZURC7x8K4K91f/F3kSpVPKDMnjEumvrKYC/AJ8y/rehoigX
         sqGjeTF9yv0Bga/b3Ya/qy6QBP9pJUPPSIIj00+wGITKwhW0aoq/v9mzSGcUGhCZzERK
         QL+A==
X-Gm-Message-State: AOAM5329MtLUo4UnM8roSE/ts4zKBQqhO69xQ2TMYncAuAsOFyMsfFwp
        dD2fkdVXqw+zdGXWZharnLj5OCVlzK8cZQUQ
X-Google-Smtp-Source: ABdhPJyrKNTMQQmK0j3MInFbwdy/N+CRYXEEFWwhTfIAAdMvs/9g1tNHARWsx5SehgMevTDCpP/b1Q==
X-Received: by 2002:a05:6402:27c9:b0:42a:d367:fdb9 with SMTP id c9-20020a05640227c900b0042ad367fdb9mr46761526ede.47.1653677106247;
        Fri, 27 May 2022 11:45:06 -0700 (PDT)
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com. [209.85.128.41])
        by smtp.gmail.com with ESMTPSA id wn18-20020a170907069200b006fec56c57f3sm1713270ejb.178.2022.05.27.11.45.04
        for <mm-commits@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 27 May 2022 11:45:05 -0700 (PDT)
Received: by mail-wm1-f41.google.com with SMTP id n124-20020a1c2782000000b003972dfca96cso3183555wmn.4
        for <mm-commits@vger.kernel.org>; Fri, 27 May 2022 11:45:04 -0700 (PDT)
X-Received: by 2002:a05:600c:4f0e:b0:397:6b94:7469 with SMTP id
 l14-20020a05600c4f0e00b003976b947469mr8216306wmq.145.1653677104449; Fri, 27
 May 2022 11:45:04 -0700 (PDT)
MIME-Version: 1.0
References: <20220527103014.517818624f9f6d4f0ba0b523@linux-foundation.org>
In-Reply-To: <20220527103014.517818624f9f6d4f0ba0b523@linux-foundation.org>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Fri, 27 May 2022 11:44:47 -0700
X-Gmail-Original-Message-ID: <CAHk-=wi72yLMW6vrnCpGJCO8Sj35miJMH74dWu2kJ0bYD1P42w@mail.gmail.com>
Message-ID: <CAHk-=wi72yLMW6vrnCpGJCO8Sj35miJMH74dWu2kJ0bYD1P42w@mail.gmail.com>
Subject: Re: [GIT PULL] additional MM updates for 5.19-rc1
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     Linux-MM <linux-mm@kvack.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        mm-commits@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Fri, May 27, 2022 at 10:30 AM Andrew Morton
<akpm@linux-foundation.org> wrote:
>
> There's a merge conflict in init/Kconfig.  We resolved that by removing
> the VM_EVENT_COUNTERS..MMAP_ALLOW_UNINITIALIZED entries.
>
> And another in lib/Kconfig.debug.  Similarly resolved by removing the
> DEBUG_SLAB..SLUB_STATS entries.

Both of those also needed fixups for the new mm/Kconfig.debug thing to
enable the proper STACKDEPOT things.

               Linus
