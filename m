Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6748C54EAA
	for <mm-commits@archiver.kernel.org>; Fri, 27 Jan 2023 11:51:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231281AbjA0LvJ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 27 Jan 2023 06:51:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234586AbjA0LuZ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 27 Jan 2023 06:50:25 -0500
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D0B97DBE1
        for <mm-commits@vger.kernel.org>; Fri, 27 Jan 2023 03:48:09 -0800 (PST)
Received: by mail-pj1-x102c.google.com with SMTP id rm7-20020a17090b3ec700b0022c05558d22so4634969pjb.5
        for <mm-commits@vger.kernel.org>; Fri, 27 Jan 2023 03:48:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=7ekFupAx/rgQwGcC8wmJmUvOoHvwc/Ug/K9ZhGt1OAA=;
        b=WLeamMNi7rq26V+42sjKoYte8in5kPg6jS/xHTDkVv2NpnUqGP5JsoL5iOQT3nperD
         fa7AptX/DDGDf7hCEAh+ubGUcTf4MOlsg6rPXJASYuNMPIDqhtD96Z9qoEOPaB4V+zF4
         azJsT+MLEgUYbwM3Xwwkm5PHlZj0FnLUS9b+zwEKK3ek6BaN5y6ApuUgWhyZ86eaiK/P
         3MQ1EqBTnCesh3OyKzeZKekHi8YocasAoxPf6/l7xHd+VbtcVvbpXpxcdscjd/lRi2a3
         ksoWktcSFWhqnWHaBMkcMaHaDOsNloCOZ/zGtePxCnS5r2MCMe930q5ziHAgjSOWvDMg
         ZJzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7ekFupAx/rgQwGcC8wmJmUvOoHvwc/Ug/K9ZhGt1OAA=;
        b=7VLTE7TR1AA79Kse7ggcpp4OpmqXQjj28yZnDMcOOHmF9ZMGkesT0Mg1Q9lJ6WNkPC
         QjqXQnPnz5e6/Nf/HdP9vNdrpHyttLNjIYqdfz9iouBQs/sLjD83PrtV7CmdbG5LpJSp
         /uYRDO1+SlQ7VHF2yXHO7InCl0ARChzMzZCZOB1rLVJYHQaNTXhFg00+SGLC/IU8mGdv
         lvuf9+06CjWD//axgp9ZgVso6d2z9BBHZZpkeMOicbGAgpWY7bY6IoIZ8byo7D/3/MH1
         XJjP8htcUM6LYMMrmzz+whEnZBT88fLEofJ415NTgiFAXJx9DledyS7ztC11jt0rUFKY
         a1DA==
X-Gm-Message-State: AO0yUKXKsvhWcwwnYVpginGazh4gHsIRmdB7sTNfdgp1LYiACUuVYrV/
        yh838wMC5AYIf4ePfm5SwUc=
X-Google-Smtp-Source: AK7set8GaXLgk2O9ZBWIHYhMTmhkgif723ytimZ9cyR64lWveEZ3tDO4fVTF9rifM4DS2R5MZ7y7tw==
X-Received: by 2002:a17:90a:1dd:b0:22b:eedb:649a with SMTP id 29-20020a17090a01dd00b0022beedb649amr14108578pjd.20.1674820008268;
        Fri, 27 Jan 2023 03:46:48 -0800 (PST)
Received: from hyeyoo ([114.29.91.56])
        by smtp.gmail.com with ESMTPSA id s6-20020a17090a13c600b00228eea35201sm4895400pjf.12.2023.01.27.03.46.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Jan 2023 03:46:47 -0800 (PST)
Date:   Fri, 27 Jan 2023 20:46:39 +0900
From:   Hyeonggon Yoo <42.hyeyoo@gmail.com>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     mm-commits@vger.kernel.org, willy@infradead.org,
        vschneid@redhat.com, vincent.guittot@linaro.org, vbabka@suse.cz,
        tj@kernel.org, shakeelb@google.com, rostedt@goodmis.org,
        roman.gushchin@linux.dev, rientjes@google.com,
        peterz@infradead.org, penberg@kernel.org, muchun.song@linux.dev,
        mingo@redhat.com, mgorman@techsingularity.net,
        juri.lelli@redhat.com, iamjoonsoo.kim@lge.com, hannes@cmpxchg.org,
        dietmar.eggemann@arm.com, dennis@kernel.org, cl@linux.com,
        bsegall@google.com, bristot@redhat.com
Subject: Re: + lib-kconfigdebug-do-not-enable-debug_preempt-by-default.patch
 added to mm-nonmm-unstable branch
Message-ID: <Y9O5n9b7MO3xSyio@hyeyoo>
References: <20230126232340.4A5E2C433D2@smtp.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230126232340.4A5E2C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Thu, Jan 26, 2023 at 03:23:39PM -0800, Andrew Morton wrote:
> 
> The patch titled
>      Subject: lib/Kconfig.debug: do not enable DEBUG_PREEMPT by default
> has been added to the -mm mm-nonmm-unstable branch.  Its filename is
>      lib-kconfigdebug-do-not-enable-debug_preempt-by-default.patch
> 
> This patch will shortly appear at
>      https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-kconfigdebug-do-not-enable-debug_preempt-by-default.patch
> 
> This patch will later appear in the mm-nonmm-unstable branch at
>     git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
> 
> Before you just go and hit "reply", please:
>    a) Consider who else should be cc'ed
>    b) Prefer to cc a suitable mailing list as well
>    c) Ideally: find the original patch on the mailing list and do a
>       reply-to-all to that, adding suitable additional cc's
> 
> *** Remember to use Documentation/process/submit-checklist.rst when testing your code ***
> 
> The -mm tree is included into linux-next via the mm-everything
> branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
> and is updated there every 2-3 working days
> 
> ------------------------------------------------------
> From: Hyeonggon Yoo <42.hyeyoo@gmail.com>
> Subject: lib/Kconfig.debug: do not enable DEBUG_PREEMPT by default
> Date: Sat, 21 Jan 2023 12:39:42 +0900
> 
> In workloads where this_cpu operations are frequently performed,
> enabling DEBUG_PREEMPT may result in significant increase in
> runtime overhead due to frequent invocation of
> __this_cpu_preempt_check() function.
> 
> This can be demonstrated through benchmarks such as hackbench where this
> configuration results in a 10% reduction in performance, primarily due to
> the added overhead within memcg charging path.
> 
> Therefore, do not to enable DEBUG_PREEMPT by default and make users aware
> of its potential impact on performance in some workloads.
> 
> hackbench-process-sockets
> 		      debug_preempt	 no_debug_preempt
> Amean     1       0.4743 (   0.00%)      0.4295 *   9.45%*
> Amean     4       1.4191 (   0.00%)      1.2650 *  10.86%*
> Amean     7       2.2677 (   0.00%)      2.0094 *  11.39%*
> Amean     12      3.6821 (   0.00%)      3.2115 *  12.78%*
> Amean     21      6.6752 (   0.00%)      5.7956 *  13.18%*
> Amean     30      9.6646 (   0.00%)      8.5197 *  11.85%*
> Amean     48     15.3363 (   0.00%)     13.5559 *  11.61%*
> Amean     79     24.8603 (   0.00%)     22.0597 *  11.27%*
> Amean     96     30.1240 (   0.00%)     26.8073 *  11.01%*
> 
> Link: https://lkml.kernel.org/r/20230121033942.350387-1-42.hyeyoo@gmail.com
> Signed-off-by: Hyeonggon Yoo <42.hyeyoo@gmail.com>
> Acked-by: Roman Gushchin <roman.gushchin@linux.dev>
> Cc: Ben Segall <bsegall@google.com>
> Cc: Christoph Lameter <cl@linux.com>
> Cc: Daniel Bristot de Oliveira <bristot@redhat.com>
> Cc: David Rientjes <rientjes@google.com>
> Cc: Dennis Zhou <dennis@kernel.org>
> Cc: Dietmar Eggemann <dietmar.eggemann@arm.com>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: Johannes Weiner <hannes@cmpxchg.org>
> Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
> Cc: Juri Lelli <juri.lelli@redhat.com>
> Cc: Matthew Wilcox <willy@infradead.org>
> Cc: Mel Gorman <mgorman@techsingularity.net>

Thanks for picking this up!

but looks like missing Mel's Acked-by. could you add that please?

> Cc: Muchun Song <muchun.song@linux.dev>
> Cc: Pekka Enberg <penberg@kernel.org>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Shakeel Butt <shakeelb@google.com>
> Cc: Steven Rostedt (Google) <rostedt@goodmis.org>
> Cc: Tejun Heo <tj@kernel.org>
> Cc: Valentin Schneider <vschneid@redhat.com>
> Cc: Vincent Guittot <vincent.guittot@linaro.org>
> Cc: Vlastimil Babka <vbabka@suse.cz>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>  lib/Kconfig.debug |    5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> --- a/lib/Kconfig.debug~lib-kconfigdebug-do-not-enable-debug_preempt-by-default
> +++ a/lib/Kconfig.debug
> @@ -1176,13 +1176,16 @@ config DEBUG_TIMEKEEPING
>  config DEBUG_PREEMPT
>  	bool "Debug preemptible kernel"
>  	depends on DEBUG_KERNEL && PREEMPTION && TRACE_IRQFLAGS_SUPPORT
> -	default y
>  	help
>  	  If you say Y here then the kernel will use a debug variant of the
>  	  commonly used smp_processor_id() function and will print warnings
>  	  if kernel code uses it in a preemption-unsafe way. Also, the kernel
>  	  will detect preemption count underflows.
>  
> +	  This option has potential to introduce high runtime overhead,
> +	  depending on workload as it triggers debugging routines for each
> +	  this_cpu operation. It should only be used for debugging purposes.
> +
>  menu "Lock Debugging (spinlocks, mutexes, etc...)"
>  
>  config LOCK_DEBUGGING_SUPPORT
> _
> 
> Patches currently in -mm which might be from 42.hyeyoo@gmail.com are
> 
> mm-page_owner-record-single-timestamp-value-for-high-order-allocations.patch
> lib-kconfigdebug-do-not-enable-debug_preempt-by-default.patch
> 
