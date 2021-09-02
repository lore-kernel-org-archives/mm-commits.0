Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 927BAC433FE
	for <mm-commits@archiver.kernel.org>; Thu,  2 Sep 2021 23:34:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 72B5161051
	for <mm-commits@archiver.kernel.org>; Thu,  2 Sep 2021 23:34:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345429AbhIBXfZ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 2 Sep 2021 19:35:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235909AbhIBXfZ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 2 Sep 2021 19:35:25 -0400
Received: from mail-lf1-x135.google.com (mail-lf1-x135.google.com [IPv6:2a00:1450:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EA17C061575
        for <mm-commits@vger.kernel.org>; Thu,  2 Sep 2021 16:34:26 -0700 (PDT)
Received: by mail-lf1-x135.google.com with SMTP id s10so7880887lfr.11
        for <mm-commits@vger.kernel.org>; Thu, 02 Sep 2021 16:34:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=FhHbT0k3VC2tPvsRChNb1C001MACcH/2A6uABZ9AEMA=;
        b=eLOhRSEZxRSXfBVtB0sVn7xKo2ulhfYQsNLW2u7WcRa4+H0OLpTitXi64KTxUQS3zn
         +EetTfv2b1U9zUDa7vdfZ1E2pzMQNjj5Gqf3/Ku+TxzD1tbjNmYH6aaKkGK96kaUmnjc
         tlpCJMrDRHbWUM6HVlBQ7fn3UQOXfVH6ZQAy0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=FhHbT0k3VC2tPvsRChNb1C001MACcH/2A6uABZ9AEMA=;
        b=k+CMvhXPb3Vz568SlDMvwAP+EAyG+nm5DkxKlj+TQ3h5+yKOmaCN0smQ35F7ptPaCD
         GENTzCCt3r0yQzUVPVCrm5m+trYpwLp+x2iEzHWl5Dd2UynQV3QsTqdjuQc6QcnkNSkx
         eQk+lc6C1qdPie4FYnv3eM4pCBHfe90g7PcWXCfMvnA1CFyDpBA+/JrhLMgDdTjvWwul
         0bGSrcFWrW13vt5WSzM7oHB66qQS/VFjVq+/zxk+mueUV84HicOk20FY8VHDsCrnqVdq
         NWehfrLaLT7OeLI1dAq++rhNxH7WPrZblv6Bao6A5NiVLf7XYqtP9IxuZuH8CgwOru4K
         4OvA==
X-Gm-Message-State: AOAM5331utFE/2vHP7RWHru8rrWZW7jTFTD2AGudckVijt6QGEzz56eC
        N/GQX7m8C/ldaxh3MukRvMb9qUZI550+Bs6qwPg=
X-Google-Smtp-Source: ABdhPJwvCDioVJniHfnOKAtTqcJ4VT0/8VCHXruhLjttQbYNR43mLG+OVdd8RamUppusR6YpTLZuWg==
X-Received: by 2002:a05:6512:1150:: with SMTP id m16mr465657lfg.382.1630625664191;
        Thu, 02 Sep 2021 16:34:24 -0700 (PDT)
Received: from mail-lj1-f181.google.com (mail-lj1-f181.google.com. [209.85.208.181])
        by smtp.gmail.com with ESMTPSA id j12sm375097ljc.121.2021.09.02.16.34.22
        for <mm-commits@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 02 Sep 2021 16:34:22 -0700 (PDT)
Received: by mail-lj1-f181.google.com with SMTP id s3so6604461ljp.11
        for <mm-commits@vger.kernel.org>; Thu, 02 Sep 2021 16:34:22 -0700 (PDT)
X-Received: by 2002:a2e:8808:: with SMTP id x8mr653887ljh.220.1630625662403;
 Thu, 02 Sep 2021 16:34:22 -0700 (PDT)
MIME-Version: 1.0
References: <20210902144820.78957dff93d7bea620d55a89@linux-foundation.org>
 <20210902215152.ibWfL_bvd%akpm@linux-foundation.org> <CAHk-=wiJLqL2cUhJbvpyPQpkbVOu1rVSzgO2=S2jC55hneLtfQ@mail.gmail.com>
In-Reply-To: <CAHk-=wiJLqL2cUhJbvpyPQpkbVOu1rVSzgO2=S2jC55hneLtfQ@mail.gmail.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Thu, 2 Sep 2021 16:34:06 -0700
X-Gmail-Original-Message-ID: <CAHk-=wiz+vp1k1Ag+fD57P4ehOpTAc=A9zT7YbGENUu57azeuQ@mail.gmail.com>
Message-ID: <CAHk-=wiz+vp1k1Ag+fD57P4ehOpTAc=A9zT7YbGENUu57azeuQ@mail.gmail.com>
Subject: Re: [patch 036/212] mm, slab: make flush_slab() possible to call with
 irqs enabled
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Christoph Lameter <cl@linux.com>,
        Mike Galbraith <efault@gmx.de>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Jann Horn <jannh@google.com>, Linux-MM <linux-mm@kvack.org>,
        Mel Gorman <mgorman@techsingularity.net>,
        mm-commits@vger.kernel.org, Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vlastimil Babka <vbabka@suse.cz>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Thu, Sep 2, 2021 at 4:15 PM Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> ....
> > +       if (lock)
> > +               local_irq_save(flags);
>
> with actively misleading names ("lock"? WTF? There's no lock there!)
> and just disgusting semantics with conditionals etc.

.. and I see that "mm, slub: convert kmem_cpu_slab protection to
local_lock" makes that local_irq_save() make it use a local_lock,
which may have been the cause of the naming.

But that doesn't make my other objections about this go away.

Instead of having it lock/unlock halfway through the function (and
have magic "Oh, the caller already holds the lock, so don't lock"
semantics except with misleading names) I really think that function
should just have been split in two, and then the locked region can be
minimized in the caller only taking it for the first part.

           Linus
