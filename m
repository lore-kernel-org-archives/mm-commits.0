Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96141C433F5
	for <mm-commits@archiver.kernel.org>; Fri, 10 Sep 2021 01:10:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6A19860F45
	for <mm-commits@archiver.kernel.org>; Fri, 10 Sep 2021 01:10:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234402AbhIJBLc (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 9 Sep 2021 21:11:32 -0400
Received: from mga09.intel.com ([134.134.136.24]:23407 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344139AbhIJBKC (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 9 Sep 2021 21:10:02 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10102"; a="220989279"
X-IronPort-AV: E=Sophos;i="5.85,282,1624345200"; 
   d="scan'208";a="220989279"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Sep 2021 18:08:47 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,282,1624345200"; 
   d="scan'208";a="466839734"
Received: from shbuild999.sh.intel.com (HELO localhost) ([10.239.146.151])
  by fmsmga007.fm.intel.com with ESMTP; 09 Sep 2021 18:08:42 -0700
Date:   Fri, 10 Sep 2021 09:08:42 +0800
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
Message-ID: <20210910010842.GA94434@shbuild999.sh.intel.com>
References: <20210902215504.dSSfDKJZu%akpm@linux-foundation.org>
 <20210905124439.GA15026@xsang-OptiPlex-9020>
 <CALvZod77aP7qdwc5FkaZJf4FikeD0NwSuoJB4N94Uf0yqZFQpQ@mail.gmail.com>
 <20210907033000.GA88160@shbuild999.sh.intel.com>
 <CALvZod6M_sySPM1KaWzb=tkLxXJksVDrSheckXaiBpMC3cNeqw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALvZod6M_sySPM1KaWzb=tkLxXJksVDrSheckXaiBpMC3cNeqw@mail.gmail.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Thu, Sep 09, 2021 at 05:43:40PM -0700, Shakeel Butt wrote:
> On Mon, Sep 6, 2021 at 8:30 PM Feng Tang <feng.tang@intel.com> wrote:
> >
> > Hi Shakeel,
> >
> > On Sun, Sep 05, 2021 at 03:15:46PM -0700, Shakeel Butt wrote:
> > > On Sun, Sep 5, 2021 at 5:27 AM kernel test robot <oliver.sang@intel.com> wrote:
> > [...]
> > > > =========================================================================================
> > > > compiler/cpufreq_governor/disk/fs/kconfig/load/rootfs/tbox_group/test/testcase/ucode:
> > > >   gcc-9/performance/1BRD_48G/xfs/x86_64-rhel-8.3/3000/debian-10.4-x86_64-20200603.cgz/lkp-icl-2sp2/disk_rr/aim7/0xd000280
> > > >
> > > > commit:
> > > >   3c28c7680e ("memcg: switch lruvec stats to rstat")
> > > >   45208c9105 ("memcg: infrastructure to flush memcg stats")
> > >
> > > I am looking into this. I was hoping we have resolution for [1] as
> > > these patches touch similar data structures.
> > >
> > > [1] https://lore.kernel.org/all/20210811031734.GA5193@xsang-OptiPlex-9020/T/#u
> >
> > I tried 2 debug methods for that 36.4% vm-scalability regression:
> >
> > 1. Disable the HW cache prefetcher, no effect on this case
> > 2. relayout and add padding to 'struct cgroup_subsys_state', reduce
> >    the regression to 3.1%
> >
> 
> Thanks Feng but it seems like the issue for this commit is different.
> Rearranging the layout didn't help. Actually the cause of slowdown is
> the call to queue_work() inside __mod_memcg_lruvec_state().
> 
> At the moment, queue_work() is called after 32 updates. I changed it
> to 128 and the slowdown of will-it-scale:page_fault[1|2|3] halved
> (from around 10% to 5%). I am unable to run reaim or
> will-it-scale:fallocate2 as I was getting weird errors.
> 
> Feng, is it possible for you to run these benchmarks with the change
> (basically changing MEMCG_CHARGE_BATCH to 128 in the if condition
> before queue_work() inside __mod_memcg_lruvec_state())?

When I checked this, I tried different changes, including this batch
number change :), but it didn't recover the regression (the regression
is slightly reduced to about 12%)

Please check if my patch is what you want to test:

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 4d8c9af..a50a69a 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -682,7 +682,8 @@ void __mod_memcg_lruvec_state(struct lruvec *lruvec, enum node_stat_item idx,
 
 	/* Update lruvec */
 	__this_cpu_add(pn->lruvec_stats_percpu->state[idx], val);
-	if (!(__this_cpu_inc_return(stats_flush_threshold) % MEMCG_CHARGE_BATCH))
+//	if (!(__this_cpu_inc_return(stats_flush_threshold) % MEMCG_CHARGE_BATCH))
+	if (!(__this_cpu_inc_return(stats_flush_threshold) % 128))
 		queue_work(system_unbound_wq, &stats_flush_work);
 }

Thanks,
Feng

 

> For the formal patch/fix, I will write down a better explanation on
> what should be the batch size.
> 
> thanks,
> Shakeel
