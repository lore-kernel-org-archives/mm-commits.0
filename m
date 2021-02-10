Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 788B8C433E0
	for <mm-commits@archiver.kernel.org>; Wed, 10 Feb 2021 19:31:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 49B3E64D87
	for <mm-commits@archiver.kernel.org>; Wed, 10 Feb 2021 19:31:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234615AbhBJTbj (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 10 Feb 2021 14:31:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234242AbhBJTbg (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 10 Feb 2021 14:31:36 -0500
Received: from mail-io1-xd35.google.com (mail-io1-xd35.google.com [IPv6:2607:f8b0:4864:20::d35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93EE8C061756
        for <mm-commits@vger.kernel.org>; Wed, 10 Feb 2021 11:30:56 -0800 (PST)
Received: by mail-io1-xd35.google.com with SMTP id f20so3121471ioo.10
        for <mm-commits@vger.kernel.org>; Wed, 10 Feb 2021 11:30:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=XR3GJYIrFqVh/P4AaYfLRSkAEDtaWqwqBD1TKpNkqZA=;
        b=bxN2BwNs3tdQqP3WHeziz9Kyj02bvgwpyBZJJqV9quH5IrMHzseF6fX5i/QqhEOIDU
         N/cnJlpbCMzDI9KItYP08h/4UB7dz/x0mvQeZNBGkXhQdJ+l0aREjeuzOBS8e/IfljwD
         yl1fV6QBd4hslnuvA6/4n/isUDgsTwPmE47k4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=XR3GJYIrFqVh/P4AaYfLRSkAEDtaWqwqBD1TKpNkqZA=;
        b=k3nwYjPxVMdWLtJbihXYcmP14TuvcoFX099M9iAS5mjDva0+NbW6ybTctZ5OzIj3C4
         wd4PAdw7LrbsGEk9oEkhKFpctI9Zrh80D2Jp+8SrGxgoWrmI3RQ35YDtr91f8/aYG1ZB
         IqtjHkTls8RUdAZWokY0H/FCQFywTHusbr8ZjLCSZLgd689+zmIkDcIpa5Dj6TNSYicS
         7AxhPvDIhQLPYc5zrTxgstvRpdq7zdHPfMEaP8PkwkaInC9iJ6mleQjyRdlsW+KuEATZ
         I+Y51q6zkyH7ObOyrETeCHSaaT80dVzMJyBDDiyQdKGHlSsc86mfTovB4Ie+HI9Xfm3C
         urBg==
X-Gm-Message-State: AOAM5317zFnSx17osddvmdCCQRhq01wfF5u+GjeufsBdn0myaO3UskE+
        Puw27ACl0B2953WZ9E/S5fK3vdDx0N35GQ==
X-Google-Smtp-Source: ABdhPJyDYWke1rrjBy+fGfW6ugSaAkj/5KtqzuK1K7SIcWl8oxReVrVYW3cAkyIqglKcQ4dtFHpO+g==
X-Received: by 2002:a02:6208:: with SMTP id d8mr4941471jac.56.1612985455284;
        Wed, 10 Feb 2021 11:30:55 -0800 (PST)
Received: from mail-io1-f52.google.com (mail-io1-f52.google.com. [209.85.166.52])
        by smtp.gmail.com with ESMTPSA id n7sm1376394ili.79.2021.02.10.11.30.55
        for <mm-commits@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 10 Feb 2021 11:30:55 -0800 (PST)
Received: by mail-io1-f52.google.com with SMTP id e133so3130613iof.8
        for <mm-commits@vger.kernel.org>; Wed, 10 Feb 2021 11:30:55 -0800 (PST)
X-Received: by 2002:a92:c26a:: with SMTP id h10mr2537425ild.234.1612984986592;
 Wed, 10 Feb 2021 11:23:06 -0800 (PST)
MIME-Version: 1.0
References: <20210209214232.hlVJaEmRu%akpm@linux-foundation.org> <4d33f14e-93ba-76ec-a82e-168ee2f25fe6@suse.cz>
In-Reply-To: <4d33f14e-93ba-76ec-a82e-168ee2f25fe6@suse.cz>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Wed, 10 Feb 2021 11:22:50 -0800
X-Gmail-Original-Message-ID: <CAHk-=wgMASx-nw8L_pYGktuVQH6msBnm718e9=JW+MCA8PSweg@mail.gmail.com>
Message-ID: <CAHk-=wgMASx-nw8L_pYGktuVQH6msBnm718e9=JW+MCA8PSweg@mail.gmail.com>
Subject: Re: [patch 13/14] mm, slub: better heuristic for number of cpus when
 calculating slab order
To:     Vlastimil Babka <vbabka@suse.cz>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>,
        bharata@linux.ibm.com, Catalin Marinas <catalin.marinas@arm.com>,
        Christoph Lameter <cl@linux.com>, Roman Gushchin <guro@fb.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Jann Horn <jannh@google.com>, Linux-MM <linux-mm@kvack.org>,
        Mel Gorman <mgorman@techsingularity.net>,
        Michal Hocko <mhocko@kernel.org>, mm-commits@vger.kernel.org,
        David Rientjes <rientjes@google.com>,
        Shakeel Butt <shakeelb@google.com>,
        stable <stable@vger.kernel.org>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Will Deacon <will@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Wed, Feb 10, 2021 at 6:34 AM Vlastimil Babka <vbabka@suse.cz> wrote:
>
> As Andrew's incoming series might have been not merged yet, I will point to
> Mel's Tested-by:

Thanks, added.


           Linus
