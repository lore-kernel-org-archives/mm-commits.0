Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4EE62C433F5
	for <mm-commits@archiver.kernel.org>; Fri, 10 Sep 2021 20:13:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 30038611F0
	for <mm-commits@archiver.kernel.org>; Fri, 10 Sep 2021 20:13:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233348AbhIJUOm (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 10 Sep 2021 16:14:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232310AbhIJUOm (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 10 Sep 2021 16:14:42 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15FBBC061574
        for <mm-commits@vger.kernel.org>; Fri, 10 Sep 2021 13:13:31 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id f11-20020a17090aa78b00b0018e98a7cddaso2214570pjq.4
        for <mm-commits@vger.kernel.org>; Fri, 10 Sep 2021 13:13:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=iePa+QJwyypIcxS3XgZtAGnALz0TqV4Q+j6tPAq5kjc=;
        b=IsHb274uPH9FPLgOtvnWx7raGr0U3XdM/HtccgychtOnJvhTAta6jhijpXFohaIsQW
         bZoWz/q4e0kzF75ln08/dBHmi8xsIkXqp6BWQJq0MhM9s5K07fWEdQ2Tpe09rK7FumiM
         YzHzB3Wl3E4BacbtocMVpqC70kN/f262nczy8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=iePa+QJwyypIcxS3XgZtAGnALz0TqV4Q+j6tPAq5kjc=;
        b=Z00Ryq5DqPKlbWuMSiqoC+t+f4CBV/tJ2xUqzhMoDxrcoHwyKsWwVNR/2aPNeNoKRR
         msEH5ZV81ZmXySdKOARlE+Vd1DRFvKtJW1YuCr5uPlDUClGBuwCkfvusukdZBiRpGSv7
         amYcEXAFVECUjsDs8e1Wg+lUxcuFxnm0wGtAtNj/nnlL2WX/LbvZ8CA7wI3lq7e1OICv
         YBbaQsV+ZCwVZJY5S0zAFCWxl+sNkXeWcY5bkhxK+Ga/GtoIFcR1d6adXRVLjv+u4fpT
         LuaQRB9lttxy2QVeEG92QtnNNcP73lHKoQxKBQ8tDuu4kKR/vMCVs/2CmdPN+o2Q7a/I
         sCdw==
X-Gm-Message-State: AOAM530ry/6DP74+QqUwPSQY9FRFlyukbp/FuC2j+d7ETJMb8xKgtUl8
        veEZ1LdE+mi/2uR0Abq7aB4E6A==
X-Google-Smtp-Source: ABdhPJzIXuCxHsDcf3kB/8sJIGUFvSUANIwT7WrHR5D8g478XSdun3ts3kErWKLttx0O/HnwKe3dtQ==
X-Received: by 2002:a17:90b:4a8e:: with SMTP id lp14mr11619185pjb.79.1631304810547;
        Fri, 10 Sep 2021 13:13:30 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id s5sm6614726pgp.81.2021.09.10.13.13.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Sep 2021 13:13:30 -0700 (PDT)
Date:   Fri, 10 Sep 2021 13:13:29 -0700
From:   Kees Cook <keescook@chromium.org>
To:     linux-kernel@vger.kernel.org
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        mm-commits@vger.kernel.org
Subject: Re: incoming
Message-ID: <202109101312.C145D4F@keescook>
References: <20210909200948.090d4e213ca34b5ad1325a7e@linux-foundation.org>
 <202109101009.13A90EBB6@keescook>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202109101009.13A90EBB6@keescook>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Fri, Sep 10, 2021 at 10:11:53AM -0700, Kees Cook wrote:
> On Thu, Sep 09, 2021 at 08:09:48PM -0700, Andrew Morton wrote:
> > 
> > More post linux-next material.
> > 
> > 9 patches, based on f154c806676ad7153c6e161f30c53a44855329d6.
> > 
> > Subsystems affected by this patch series:
> > 
> >   mm/slab-generic
> >   rapidio
> >   mm/debug
> > 
> > Subsystem: mm/slab-generic
> > 
> >     "Matthew Wilcox (Oracle)" <willy@infradead.org>:
> >       mm: move kvmalloc-related functions to slab.h
> > 
> > Subsystem: rapidio
> > 
> >     Kees Cook <keescook@chromium.org>:
> >       rapidio: avoid bogus __alloc_size warning
> > 
> > Subsystem: mm/debug
> > 
> >     Kees Cook <keescook@chromium.org>:
> >     Patch series "Add __alloc_size() for better bounds checking", v2:
> >       Compiler Attributes: add __alloc_size() for better bounds checking
> >       checkpatch: add __alloc_size() to known $Attribute
> >       slab: clean up function declarations
> >       slab: add __alloc_size attributes for better bounds checking
> >       mm/page_alloc: add __alloc_size attributes for better bounds checking
> >       percpu: add __alloc_size attributes for better bounds checking
> >       mm/vmalloc: add __alloc_size attributes for better bounds checking
> 
> Hi,
> 
> FYI, in overnight build testing I found yet another corner case in
> GCC's handling of the __alloc_size attribute. It's the gift that keeps
> on giving. The fix is here:
> 
> https://lore.kernel.org/lkml/20210910165851.3296624-1-keescook@chromium.org/

I'm so glad it's Friday. Here's the v2 fix... *sigh*

https://lore.kernel.org/lkml/20210910201132.3809437-1-keescook@chromium.org/

-Kees

> 
> > 
> >  Makefile                                 |   15 +++
> >  drivers/of/kexec.c                       |    1 
> >  drivers/rapidio/devices/rio_mport_cdev.c |    9 +-
> >  include/linux/compiler_attributes.h      |    6 +
> >  include/linux/gfp.h                      |    2 
> >  include/linux/mm.h                       |   34 --------
> >  include/linux/percpu.h                   |    3 
> >  include/linux/slab.h                     |  122 ++++++++++++++++++++++---------
> >  include/linux/vmalloc.h                  |   11 ++
> >  scripts/checkpatch.pl                    |    3 
> >  10 files changed, 132 insertions(+), 74 deletions(-)
> > 
> 
> -- 
> Kees Cook

-- 
Kees Cook
