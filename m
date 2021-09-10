Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5E9DC433EF
	for <mm-commits@archiver.kernel.org>; Fri, 10 Sep 2021 02:34:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C505261153
	for <mm-commits@archiver.kernel.org>; Fri, 10 Sep 2021 02:34:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229611AbhIJCfb (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 9 Sep 2021 22:35:31 -0400
Received: from mga11.intel.com ([192.55.52.93]:31844 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229461AbhIJCfa (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 9 Sep 2021 22:35:30 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10102"; a="217806030"
X-IronPort-AV: E=Sophos;i="5.85,282,1624345200"; 
   d="scan'208";a="217806030"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Sep 2021 19:34:20 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,282,1624345200"; 
   d="scan'208";a="540095773"
Received: from shbuild999.sh.intel.com (HELO localhost) ([10.239.146.151])
  by FMSMGA003.fm.intel.com with ESMTP; 09 Sep 2021 19:34:16 -0700
Date:   Fri, 10 Sep 2021 10:34:15 +0800
From:   Feng Tang <feng.tang@intel.com>
To:     Shakeel Butt <shakeelb@google.com>
Cc:     kernel test robot <oliver.sang@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        0day robot <lkp@intel.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Hillf Danton <hdanton@sina.com>,
        Huang Ying <ying.huang@intel.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Michal Hocko <mhocko@kernel.org>,
        Michal Koutn?? <mkoutny@suse.com>,
        Muchun Song <songmuchun@bytedance.com>,
        Roman Gushchin <guro@fb.com>, Tejun Heo <tj@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, lkp@lists.01.org,
        Xing Zhengjun <zhengjun.xing@linux.intel.com>,
        Linux MM <linux-mm@kvack.org>, mm-commits@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [memcg] 45208c9105: aim7.jobs-per-min -14.0% regression
Message-ID: <20210910023415.GB94434@shbuild999.sh.intel.com>
References: <20210902215504.dSSfDKJZu%akpm@linux-foundation.org>
 <20210905124439.GA15026@xsang-OptiPlex-9020>
 <CALvZod77aP7qdwc5FkaZJf4FikeD0NwSuoJB4N94Uf0yqZFQpQ@mail.gmail.com>
 <20210907033000.GA88160@shbuild999.sh.intel.com>
 <CALvZod6M_sySPM1KaWzb=tkLxXJksVDrSheckXaiBpMC3cNeqw@mail.gmail.com>
 <20210910010842.GA94434@shbuild999.sh.intel.com>
 <CALvZod5_L55RLzwOXh_5C+v9rjVQ4_FEaEB2QYS5+6kuHpHpQg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALvZod5_L55RLzwOXh_5C+v9rjVQ4_FEaEB2QYS5+6kuHpHpQg@mail.gmail.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Thu, Sep 09, 2021 at 06:19:06PM -0700, Shakeel Butt wrote:
[...]
> > > > > I am looking into this. I was hoping we have resolution for [1] as
> > > > > these patches touch similar data structures.
> > > > >
> > > > > [1] https://lore.kernel.org/all/20210811031734.GA5193@xsang-OptiPlex-9020/T/#u
> > > >
> > > > I tried 2 debug methods for that 36.4% vm-scalability regression:
> > > >
> > > > 1. Disable the HW cache prefetcher, no effect on this case
> > > > 2. relayout and add padding to 'struct cgroup_subsys_state', reduce
> > > >    the regression to 3.1%
> > > >
> > >
> > > Thanks Feng but it seems like the issue for this commit is different.
> > > Rearranging the layout didn't help. Actually the cause of slowdown is
> > > the call to queue_work() inside __mod_memcg_lruvec_state().
> > >
> > > At the moment, queue_work() is called after 32 updates. I changed it
> > > to 128 and the slowdown of will-it-scale:page_fault[1|2|3] halved
> > > (from around 10% to 5%). I am unable to run reaim or
> > > will-it-scale:fallocate2 as I was getting weird errors.
> > >
> > > Feng, is it possible for you to run these benchmarks with the change
> > > (basically changing MEMCG_CHARGE_BATCH to 128 in the if condition
> > > before queue_work() inside __mod_memcg_lruvec_state())?
> >
> > When I checked this, I tried different changes, including this batch
> > number change :), but it didn't recover the regression (the regression
> > is slightly reduced to about 12%)
[...]
> 
> Another change we can try is to remove this specific queue_work()
> altogether because this is the only significant change for the
> workload. That will give us the base performance number. If that also
> has regression then there are more issues to debug. Thanks a lot for
> your help.

I just tested with patch removing the queue_work() in __mod_memcg_lruvec_state(),
and the regression is gone.

Also to avoid some duplication of debugging, here are some other tries
I did:
* add padding in 'struct lruvec' for 'lru_lock', no effect
* add padding in 'mem_cgroup_per_node' between 'lruvec_stats_percpu' and
  'lruvec_stats', no effect.

Thanks,
Feng

