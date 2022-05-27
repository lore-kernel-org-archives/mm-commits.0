Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30212C433F5
	for <mm-commits@archiver.kernel.org>; Fri, 27 May 2022 11:11:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236418AbiE0LLA (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 27 May 2022 07:11:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232837AbiE0LK4 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 27 May 2022 07:10:56 -0400
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87984106559
        for <mm-commits@vger.kernel.org>; Fri, 27 May 2022 04:10:55 -0700 (PDT)
Received: by mail-ej1-x630.google.com with SMTP id rs12so7990430ejb.13
        for <mm-commits@vger.kernel.org>; Fri, 27 May 2022 04:10:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Y/yYABB2EYFHVYhMuXL8uyg5yxUhxv3v1f/iKgX0Uo0=;
        b=ARv0Ez801kf6Fz7lMyFwudsnZj8GJzrPXKJExMmus6hvHfDEYk97RH7spyMZPggEfC
         19SSA3T3vPRzj/DjEHQwmhfKi4dthUoh67qWCehqXS/f+mL/PMXyGlnA5KLyuYxU/Hw4
         rYSTWnsua6u2xrawO3HM7j10YB9S1N/j3juS0icZC+P6Y1moJizQKhjlFIHtqjIB8vJu
         q7M2lLjJvMGbIYT62ZXe9NBv/DhDuwm0SaYm5ab2Ljcd4066BEmAI4eEh6Rs1/SOQQ8q
         afaEHmFZSo45xQbk06DllGgMMs1UbvyvAGbFtbam+ku2rvBVNBVJoWM5kO+AZi50YeG+
         mDLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=Y/yYABB2EYFHVYhMuXL8uyg5yxUhxv3v1f/iKgX0Uo0=;
        b=te/L61wxURLwYK7LdWb4/7UD+QWDZqvphIGGiI98m0LlKz9BVhUoHVg3gS2DOR4+hZ
         ndLXjOpqS8jrqS32Q76jeyXKiqKCxXHmsJoYBIwG64ir/hqP9SQt2syAxHejtY0tK9r1
         OzS7ifFMDsj4z69+tnUcF8wS9fuyjlmJZ1sWBYJHWMtLuiTcGfvhthOlp+qHGkYUH9K/
         HGH/W19F2ZGdlpCfgFQ0boMMxkMpLkluqAUhUHsUfLjKVtn2kMx0BPUc1cd1AI6i5tka
         E8C5CzxES+OED5+kVMD7X59HF+xbAI9YbrlPSXrIu/wYWDszAnWLfwxNt+iPQrIRTNWS
         vgxg==
X-Gm-Message-State: AOAM532UXPAmS/xPj0i8BBV5K6JDSaFYEGYPEmt9//zmzQhzf5DO6447
        lpNnVJG5PRhliO4RD/4p6EE=
X-Google-Smtp-Source: ABdhPJx9DMPAlTtO3ZNPdgCErwsi8H/vDqMTHJDpSyQpO2RMH7ou8LqnFzPgca+FJVAYrJ1jDhKbSg==
X-Received: by 2002:a17:907:7245:b0:6ff:38d0:9708 with SMTP id ds5-20020a170907724500b006ff38d09708mr2354344ejc.172.1653649854061;
        Fri, 27 May 2022 04:10:54 -0700 (PDT)
Received: from gmail.com (563BA179.dsl.pool.telekom.hu. [86.59.161.121])
        by smtp.gmail.com with ESMTPSA id pg7-20020a170907204700b006f3ef214dfdsm1344578ejb.99.2022.05.27.04.10.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 May 2022 04:10:53 -0700 (PDT)
Sender: Ingo Molnar <mingo.kernel.org@gmail.com>
Date:   Fri, 27 May 2022 13:10:47 +0200
From:   Ingo Molnar <mingo@kernel.org>
To:     Borislav Petkov <bp@alien8.de>,
        Arnaldo Carvalho de Melo <acme@infradead.org>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Mark Hemment <markhemm@googlemail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        the arch/x86 maintainers <x86@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        patrice.chotard@foss.st.com, Mikulas Patocka <mpatocka@redhat.com>,
        Lukas Czerner <lczerner@redhat.com>,
        Christoph Hellwig <hch@lst.de>,
        "Darrick J. Wong" <djwong@kernel.org>,
        Chuck Lever <chuck.lever@oracle.com>,
        Hugh Dickins <hughd@google.com>, patches@lists.linux.dev,
        Linux-MM <linux-mm@kvack.org>, mm-commits@vger.kernel.org,
        Mel Gorman <mgorman@suse.de>
Subject: Re: [PATCH] x86/clear_user: Make it faster
Message-ID: <YpCxt31TKxV5zS3l@gmail.com>
References: <CAHk-=wh_62HBCz1g_6mKP71XOvJAs3JwBz0=jve2mg1DGWPq5g@mail.gmail.com>
 <YnLfl6lupN2nq7+t@zn.tnic>
 <CAHk-=wiGbrJMim6EWncZUQBzguqy-vtNd+grfNizm5L8Vcmu+w@mail.gmail.com>
 <YnLplKy0Y66SsvQw@zn.tnic>
 <CAHk-=wjUX5DGNSiBYvPC8fQJGRe5_RWR8NW=gYF4=UpPiwCE8A@mail.gmail.com>
 <Ynow8F3G8Kl6V3gu@zn.tnic>
 <CAHk-=whCmmipbBDips0OJ=UiBUjZfgBGYruoOsqcq2TVd5kBSA@mail.gmail.com>
 <YnqqhmYv75p+xl73@zn.tnic>
 <Ynq1nVpu1xCpjnXm@zn.tnic>
 <YozQZMyQ0NDdD8cH@zn.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YozQZMyQ0NDdD8cH@zn.tnic>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


* Borislav Petkov <bp@alien8.de> wrote:

> Ok,
> 
> finally a somewhat final version, lightly tested.
> 
> I still need to run it on production Icelake and that is kinda being
> delayed due to server room cooling issues (don't ask ;-\).

> So Mel gave me the idea to simply measure how fast the function becomes.
> I.e.:
> 
>   start = rdtsc_ordered();
>   ret = __clear_user(to, n);
>   end = rdtsc_ordered();
> 
> Computing the mean average of all the samples collected during the test
> suite run then shows some improvement:
> 
>   clear_user_original:
>   Amean: 9219.71 (Sum: 6340154910, samples: 687674)
> 
>   fsrm:
>   Amean: 8030.63 (Sum: 5522277720, samples: 687652)
> 
> That's on Zen3.

As a side note, there's some rudimentary perf tooling that allows the 
user-space testing of kernel-space x86 memcpy and memset implementations:

 $ perf bench mem memcpy
 # Running 'mem/memcpy' benchmark:
 # function 'default' (Default memcpy() provided by glibc)
 # Copying 1MB bytes ...

       42.459239 GB/sec
 # function 'x86-64-unrolled' (unrolled memcpy() in arch/x86/lib/memcpy_64.S)
 # Copying 1MB bytes ...

       23.818598 GB/sec
 # function 'x86-64-movsq' (movsq-based memcpy() in arch/x86/lib/memcpy_64.S)
 # Copying 1MB bytes ...

       10.172526 GB/sec
 # function 'x86-64-movsb' (movsb-based memcpy() in arch/x86/lib/memcpy_64.S)
 # Copying 1MB bytes ...

       10.614810 GB/sec

Note how the actual implementation in arch/x86/lib/memcpy_64.S was used to 
build a user-space test into 'perf bench'.

For copy_user() & clear_user() some additional wrappery would be needed I 
guess, to wrap away stac()/clac()/might_sleep(), etc. ...

[ Plus it could all be improved to measure cache hot & cache cold 
  performance, to use different sizes, etc. ]

Even with the limitation that it's not 100% equivalent to the kernel-space 
thing, especially for very short buffers, having the whole perf side 
benchmarking, profiling & statistics machinery available is a plus I think.

Thanks,

	Ingo
