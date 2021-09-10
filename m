Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0471BC433F5
	for <mm-commits@archiver.kernel.org>; Fri, 10 Sep 2021 01:22:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E365F6113A
	for <mm-commits@archiver.kernel.org>; Fri, 10 Sep 2021 01:22:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239049AbhIJBXx (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 9 Sep 2021 21:23:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238993AbhIJBXq (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 9 Sep 2021 21:23:46 -0400
Received: from mail-lj1-x22a.google.com (mail-lj1-x22a.google.com [IPv6:2a00:1450:4864:20::22a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18AA0C061153
        for <mm-commits@vger.kernel.org>; Thu,  9 Sep 2021 18:19:20 -0700 (PDT)
Received: by mail-lj1-x22a.google.com with SMTP id g14so526808ljk.5
        for <mm-commits@vger.kernel.org>; Thu, 09 Sep 2021 18:19:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=fFtcZqqQNlz6Fo1j4RT+wXd6hyzZuXZbR1hNqy5igjU=;
        b=hSRL+WyUJXwUcnrNYMNnEI15VJGfds+1s1dPvNus6FbCMsiOovqAZAZXi5JWAJIABQ
         7r5S0cGi+wc4+f/6yCU3ReOpb1EqhwMWWjSn6WNb5Cphsb74F/lMDCVHVQ6kw7vlHst7
         Lp8QkTTHnevTzIo/hhIWlt7GGNiHHkBDXaCZ3YXotxGb1uGOrwZpxo+WWvaU7KICXprz
         NtzDx5s8FA6PJDIiTxTdHExWXrnchcMuyHkrzUTqcsNRdbTbM3kkluQ6I2VBD95QsmV7
         o7NbATkRtuCMYnaEiStX9scb8/ZNHqIgXKd+WuySR0Yet5cKm0/qB7quBPU4R/+vde2w
         V6HQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=fFtcZqqQNlz6Fo1j4RT+wXd6hyzZuXZbR1hNqy5igjU=;
        b=mUR+0mMa0Ho6sD3beRNrxqfosJ8Zyp0+4SaR/eNsq1Ys397Rhlai/JC154hKD+jF8H
         bMYudxCfM70e4vXq3/A1IGIy5l1scWFL2xRxxm+wi3nOvbuspTJMwg0o8t1c6K2OuE+j
         HwXxPTuv6+b3xbQnoQ45Pk2EtbGvIBH5I488WYeiaBCbkB57Pwx4o0t1kk3Wt48TL/HI
         kfe8YJ7b2X71zwnhzJwdofMP+KLvNMwdrjPYRHpUq7dCO5iUobqmbdFsHLtOmrfwhE2M
         AWICzHUS6Js6LnHm9cGI7DnI9oo9diGqGHO4IC8LBMAO8DwvilYbO6PRHCkg3T0tnWfD
         usbQ==
X-Gm-Message-State: AOAM531FHkNDkQrewptWxzrLkl9D1dTFU0x/6wVdsOTkGwwc9LcQvZnI
        MNNznc4h8KW+KD2xDctwcPMxGLDUNl4CxvVwXT/hJw==
X-Google-Smtp-Source: ABdhPJx0EHLqcZYEMME+jzHmD+0Avn+MXVsNojtjDl7JoLwOqEcfuh3FmEWGaZm5g9a/nos0JiO3xDsUyMNrRUFGRHg=
X-Received: by 2002:a2e:a363:: with SMTP id i3mr2267599ljn.86.1631236758167;
 Thu, 09 Sep 2021 18:19:18 -0700 (PDT)
MIME-Version: 1.0
References: <20210902215504.dSSfDKJZu%akpm@linux-foundation.org>
 <20210905124439.GA15026@xsang-OptiPlex-9020> <CALvZod77aP7qdwc5FkaZJf4FikeD0NwSuoJB4N94Uf0yqZFQpQ@mail.gmail.com>
 <20210907033000.GA88160@shbuild999.sh.intel.com> <CALvZod6M_sySPM1KaWzb=tkLxXJksVDrSheckXaiBpMC3cNeqw@mail.gmail.com>
 <20210910010842.GA94434@shbuild999.sh.intel.com>
In-Reply-To: <20210910010842.GA94434@shbuild999.sh.intel.com>
From:   Shakeel Butt <shakeelb@google.com>
Date:   Thu, 9 Sep 2021 18:19:06 -0700
Message-ID: <CALvZod5_L55RLzwOXh_5C+v9rjVQ4_FEaEB2QYS5+6kuHpHpQg@mail.gmail.com>
Subject: Re: [memcg] 45208c9105: aim7.jobs-per-min -14.0% regression
To:     Feng Tang <feng.tang@intel.com>
Cc:     kernel test robot <oliver.sang@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        0day robot <lkp@intel.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Hillf Danton <hdanton@sina.com>,
        Huang Ying <ying.huang@intel.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Michal Hocko <mhocko@kernel.org>,
        "Michal Koutn??" <mkoutny@suse.com>,
        Muchun Song <songmuchun@bytedance.com>,
        Roman Gushchin <guro@fb.com>, Tejun Heo <tj@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, lkp@lists.01.org,
        Xing Zhengjun <zhengjun.xing@linux.intel.com>,
        Linux MM <linux-mm@kvack.org>, mm-commits@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Thu, Sep 9, 2021 at 6:08 PM Feng Tang <feng.tang@intel.com> wrote:
>
> On Thu, Sep 09, 2021 at 05:43:40PM -0700, Shakeel Butt wrote:
> > On Mon, Sep 6, 2021 at 8:30 PM Feng Tang <feng.tang@intel.com> wrote:
> > >
> > > Hi Shakeel,
> > >
> > > On Sun, Sep 05, 2021 at 03:15:46PM -0700, Shakeel Butt wrote:
> > > > On Sun, Sep 5, 2021 at 5:27 AM kernel test robot <oliver.sang@intel.com> wrote:
> > > [...]
> > > > > =========================================================================================
> > > > > compiler/cpufreq_governor/disk/fs/kconfig/load/rootfs/tbox_group/test/testcase/ucode:
> > > > >   gcc-9/performance/1BRD_48G/xfs/x86_64-rhel-8.3/3000/debian-10.4-x86_64-20200603.cgz/lkp-icl-2sp2/disk_rr/aim7/0xd000280
> > > > >
> > > > > commit:
> > > > >   3c28c7680e ("memcg: switch lruvec stats to rstat")
> > > > >   45208c9105 ("memcg: infrastructure to flush memcg stats")
> > > >
> > > > I am looking into this. I was hoping we have resolution for [1] as
> > > > these patches touch similar data structures.
> > > >
> > > > [1] https://lore.kernel.org/all/20210811031734.GA5193@xsang-OptiPlex-9020/T/#u
> > >
> > > I tried 2 debug methods for that 36.4% vm-scalability regression:
> > >
> > > 1. Disable the HW cache prefetcher, no effect on this case
> > > 2. relayout and add padding to 'struct cgroup_subsys_state', reduce
> > >    the regression to 3.1%
> > >
> >
> > Thanks Feng but it seems like the issue for this commit is different.
> > Rearranging the layout didn't help. Actually the cause of slowdown is
> > the call to queue_work() inside __mod_memcg_lruvec_state().
> >
> > At the moment, queue_work() is called after 32 updates. I changed it
> > to 128 and the slowdown of will-it-scale:page_fault[1|2|3] halved
> > (from around 10% to 5%). I am unable to run reaim or
> > will-it-scale:fallocate2 as I was getting weird errors.
> >
> > Feng, is it possible for you to run these benchmarks with the change
> > (basically changing MEMCG_CHARGE_BATCH to 128 in the if condition
> > before queue_work() inside __mod_memcg_lruvec_state())?
>
> When I checked this, I tried different changes, including this batch
> number change :), but it didn't recover the regression (the regression
> is slightly reduced to about 12%)
>
> Please check if my patch is what you want to test:

Yes, the following patch is what I want to test.

>
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 4d8c9af..a50a69a 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -682,7 +682,8 @@ void __mod_memcg_lruvec_state(struct lruvec *lruvec, enum node_stat_item idx,
>
>         /* Update lruvec */
>         __this_cpu_add(pn->lruvec_stats_percpu->state[idx], val);
> -       if (!(__this_cpu_inc_return(stats_flush_threshold) % MEMCG_CHARGE_BATCH))
> +//     if (!(__this_cpu_inc_return(stats_flush_threshold) % MEMCG_CHARGE_BATCH))
> +       if (!(__this_cpu_inc_return(stats_flush_threshold) % 128))
>                 queue_work(system_unbound_wq, &stats_flush_work);
>  }
>

Another change we can try is to remove this specific queue_work()
altogether because this is the only significant change for the
workload. That will give us the base performance number. If that also
has regression then there are more issues to debug. Thanks a lot for
your help.
