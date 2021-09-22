Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0E0EC433F5
	for <mm-commits@archiver.kernel.org>; Wed, 22 Sep 2021 21:15:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C13CD61168
	for <mm-commits@archiver.kernel.org>; Wed, 22 Sep 2021 21:15:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237840AbhIVVR3 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 22 Sep 2021 17:17:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237964AbhIVVRZ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 22 Sep 2021 17:17:25 -0400
Received: from mail-lf1-x12f.google.com (mail-lf1-x12f.google.com [IPv6:2a00:1450:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D160FC061757
        for <mm-commits@vger.kernel.org>; Wed, 22 Sep 2021 14:15:54 -0700 (PDT)
Received: by mail-lf1-x12f.google.com with SMTP id p29so17068505lfa.11
        for <mm-commits@vger.kernel.org>; Wed, 22 Sep 2021 14:15:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=7XJav0dfWNxK79pvtGX/UV/+fzNxl315YNj5Lb0kUtk=;
        b=QA/EzrWbAIrSwOaNV4uqMw33DYIddOpz6ZYLeSLgSw/6W5sXis/SfJPUXmmq3UhODG
         6HTHGK+Pi7RNxhY6fHDq1cECQSdwskC8x9GDOcCAMch8XMogspIaioLO3jy91LAe9v+p
         zPQysb2+nkIu4xF1pvfTRTKDEaNJCficfXCxw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7XJav0dfWNxK79pvtGX/UV/+fzNxl315YNj5Lb0kUtk=;
        b=Yld+5mFLtDrvLV1FrI1stSaKQCf1UAkneDd+zszO/T9/ZsvYhNwGRAKVXViDuHuhps
         HB5dBl+MajJrq0Cyz+z/X8t96X9HgTUVz5BaDAv4J5ifxRG0KKAKyXnwQYZA98+BSYsj
         dzFU9JuEN1nzc+ReBfkIhdVo+9BNlR5Mav64JJpRLmQ7Mk5PSCIFSkjhSxJlkJ1QjA+b
         lkgF+diRbWym4tyez19c02SalMaKTSLzakx7BVbhAjliE++nmL1vk25o+L06Gji0igxi
         BaRygA42lKDDv0jOtEoysGOzSGU5oLH2re2ZLYCejU2MRsIa9QZqV2Lk/aQmPP3zvUSW
         4LUw==
X-Gm-Message-State: AOAM532y4CVT/sPXS/SixhP4M7dniX7GmeQ+7bkNfdjt1HRDA4uzlq79
        LtqeOP45b6GG75jO/mFHOkHs9cWoHmCxNoEEuHo=
X-Google-Smtp-Source: ABdhPJzO71CcYclPiBwODohaOEsc1KWUeEO44xJRGW8rsE9XPPCxko8FHyxc9lRO2VznShp8iboxIw==
X-Received: by 2002:a19:490d:: with SMTP id w13mr1008970lfa.30.1632345352889;
        Wed, 22 Sep 2021 14:15:52 -0700 (PDT)
Received: from mail-lf1-f50.google.com (mail-lf1-f50.google.com. [209.85.167.50])
        by smtp.gmail.com with ESMTPSA id c17sm287347lfp.290.2021.09.22.14.15.49
        for <mm-commits@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 Sep 2021 14:15:50 -0700 (PDT)
Received: by mail-lf1-f50.google.com with SMTP id m3so17585874lfu.2
        for <mm-commits@vger.kernel.org>; Wed, 22 Sep 2021 14:15:49 -0700 (PDT)
X-Received: by 2002:a05:6512:12c4:: with SMTP id p4mr1044332lfg.280.1632345349597;
 Wed, 22 Sep 2021 14:15:49 -0700 (PDT)
MIME-Version: 1.0
References: <20210909200948.090d4e213ca34b5ad1325a7e@linux-foundation.org>
 <20210910031046.G76dQvPhV%akpm@linux-foundation.org> <CAHk-=wgfbSyW6QYd5rmhSHRoOQ=ZvV+jLn1U8U4nBDgBuaOAjQ@mail.gmail.com>
 <202109211630.2D00627@keescook> <af3c775a1515f97c8dbe6a6651bd6e4b6986e8cd.camel@perches.com>
 <202109211757.F38DF644@keescook> <YUraGKetS+Tgc7y9@localhost.localdomain>
In-Reply-To: <YUraGKetS+Tgc7y9@localhost.localdomain>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Wed, 22 Sep 2021 14:15:33 -0700
X-Gmail-Original-Message-ID: <CAHk-=wjS-Jg7sGMwUPpDsjv392nDOOs0CtUtVkp=S6Q7JzFJRw@mail.gmail.com>
Message-ID: <CAHk-=wjS-Jg7sGMwUPpDsjv392nDOOs0CtUtVkp=S6Q7JzFJRw@mail.gmail.com>
Subject: Re: function prototype element ordering
To:     Alexey Dobriyan <adobriyan@gmail.com>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Joe Perches <joe@perches.com>,
        Andrew Morton <akpm@linux-foundation.org>, apw@canonical.com,
        Christoph Lameter <cl@linux.com>,
        Daniel Micay <danielmicay@gmail.com>,
        Dennis Zhou <dennis@kernel.org>, dwaipayanray1@gmail.com,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Linux-MM <linux-mm@kvack.org>,
        Lukas Bulwahn <lukas.bulwahn@gmail.com>,
        mm-commits@vger.kernel.org, Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Miguel Ojeda <ojeda@kernel.org>,
        Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Tejun Heo <tj@kernel.org>, Vlastimil Babka <vbabka@suse.cz>,
        "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Wed, Sep 22, 2021 at 12:24 AM Alexey Dobriyan <adobriyan@gmail.com> wrote:
>
> Attributes should be on their own line, they can be quite lengthy.

No, no no. They really shouldn't.

First off, no normal code should use that "__attribute__(())" syntax
anyway. It's ugly and big, and many of the attributes are
compiler-specific anyway.

So the "quite lengthy" argument is bogus, because the actual names you
should use are things like "__packed" or "__pure" or "__user" etc.

But the "on their own line" is complete garbage to begin with. That
will NEVER be a kernel rule. We should never have a rule that assumes
things are so long that they need to be on multiple lines.

We don't put function return types on their own lines either, even if
some other projects have that rule (just to get function names at the
beginning of lines or some other odd reason).

So no, attributes do not go on their own lines, and they also
generally don't go before the thing they describe.  Your examples are
wrong, and explicitly against kernel rules.

           Linus
