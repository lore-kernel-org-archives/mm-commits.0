Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 603A1C433F5
	for <mm-commits@archiver.kernel.org>; Wed, 23 Mar 2022 02:08:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240963AbiCWCKC (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 22 Mar 2022 22:10:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231596AbiCWCJ7 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 22 Mar 2022 22:09:59 -0400
Received: from mail-lj1-x236.google.com (mail-lj1-x236.google.com [IPv6:2a00:1450:4864:20::236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BC9826AD5
        for <mm-commits@vger.kernel.org>; Tue, 22 Mar 2022 19:08:30 -0700 (PDT)
Received: by mail-lj1-x236.google.com with SMTP id u3so114179ljd.0
        for <mm-commits@vger.kernel.org>; Tue, 22 Mar 2022 19:08:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=J8R5fIKIW6T8IIqFMnxqRAyAbWLACxuZ0qCUQR/pgGY=;
        b=Eq6BQka4f8LYxS/Tno67bSzUoi2mPqlP+glM7TxOjfAPhoCdKuboSnQmWForCK/G5Q
         uvSWbW9LGbfwRAbIk2bphRZ9Qq8tpiA45DZWZTzPG6mPJUagHr2/7r5uPM6LolhND+kx
         ws/mB3u/w9v98tgrtujz3csM3dx0hX8Bmi0fQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=J8R5fIKIW6T8IIqFMnxqRAyAbWLACxuZ0qCUQR/pgGY=;
        b=5y0VqbqN3EGKjvoWq6r/ABDRHqeHTiyFTsFmTUMFdcepQ5vN1rFk+1nqNg6KGP8KSk
         SDqEjJybj7h2ApCCMgoj+m7UN2Ov0DLQ2rrcF3m/CMj8prmagImyRmIkQcLuRJXK/boU
         2D7X24p8MF8U1kPTgnwSIqrb3dcW9F+yDPYKGvJ2ipAlRagF+X2SoJ+g6Ahu4IaHH3uA
         bIlyAMrOM//bXq3CeQwZvmvRGfRSkBxtHNa2JAoP1OvfDlejse4C8dH20/Oa88x5tbRz
         4FG/CuRa3c63OObJyU9llC9nI74TZRMaOJhrk1idSruGW/R9RbvPaf8KwH9FBjqlHvFz
         74GQ==
X-Gm-Message-State: AOAM533VBX+xEFkn+48sP8X11ehlvA+xzPcKPXAnFFErdA2Pq0FweQ+s
        JA34Hc64vX0zWYZUpu/AUixT92zEB9DIyT0dFh4=
X-Google-Smtp-Source: ABdhPJzEmZhtwEygkDgq9XkctSMRkTfeT2FzJTQsFNhB/AV67dsT31mDmm1ni3oacq0ZU1h7+FAN/g==
X-Received: by 2002:a05:651c:179c:b0:247:e1b4:92aa with SMTP id bn28-20020a05651c179c00b00247e1b492aamr21759648ljb.55.1648001308275;
        Tue, 22 Mar 2022 19:08:28 -0700 (PDT)
Received: from mail-lj1-f177.google.com (mail-lj1-f177.google.com. [209.85.208.177])
        by smtp.gmail.com with ESMTPSA id l10-20020a056512110a00b0044a50ffb05esm32315lfg.122.2022.03.22.19.08.24
        for <mm-commits@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 22 Mar 2022 19:08:25 -0700 (PDT)
Received: by mail-lj1-f177.google.com with SMTP id u3so114064ljd.0
        for <mm-commits@vger.kernel.org>; Tue, 22 Mar 2022 19:08:24 -0700 (PDT)
X-Received: by 2002:a2e:9794:0:b0:249:8488:7dbd with SMTP id
 y20-20020a2e9794000000b0024984887dbdmr9591965lji.176.1648001304369; Tue, 22
 Mar 2022 19:08:24 -0700 (PDT)
MIME-Version: 1.0
References: <20220322143803.04a5e59a07e48284f196a2f9@linux-foundation.org>
 <20220322214648.AB7A1C340EC@smtp.kernel.org> <Yjpo2jnp5pkJr+XI@google.com>
In-Reply-To: <Yjpo2jnp5pkJr+XI@google.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Tue, 22 Mar 2022 19:08:08 -0700
X-Gmail-Original-Message-ID: <CAHk-=wiLMM1QJfmosoY3+Ah79_Oga8=EzUZnR8AoTRBUZGSfoA@mail.gmail.com>
Message-ID: <CAHk-=wiLMM1QJfmosoY3+Ah79_Oga8=EzUZnR8AoTRBUZGSfoA@mail.gmail.com>
Subject: Re: [patch 163/227] mm: madvise: skip unmapped vma holes passed to process_madvise
To:     Minchan Kim <minchan@kernel.org>,
        Charan Teja Kalla <quic_charante@quicinc.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Vlastimil Babka <vbabka@suse.cz>,
        Suren Baghdasaryan <surenb@google.com>,
        stable <stable@vger.kernel.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        David Rientjes <rientjes@google.com>,
        Nadav Amit <nadav.amit@gmail.com>,
        Michal Hocko <mhocko@suse.com>, patches@lists.linux.dev,
        Linux-MM <linux-mm@kvack.org>, mm-commits@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Tue, Mar 22, 2022 at 5:25 PM Minchan Kim <minchan@kernel.org> wrote:
>
> I thought it was still under discussion and Charan will post next
> version along with previous patch
> "mm: madvise: return correct bytes advised with process_madvise"
>
> https://lore.kernel.org/linux-mm/7207b2f5-6b3e-aea4-aa1b-9c6d849abe34@quicinc.com/

Hmm. It's merged now, as commit 08095d6310a7.

So any fixes please do it on top of that existing state ;(

            Linus
