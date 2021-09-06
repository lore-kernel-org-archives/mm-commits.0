Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8EB2EC433EF
	for <mm-commits@archiver.kernel.org>; Mon,  6 Sep 2021 06:09:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 72D6660F92
	for <mm-commits@archiver.kernel.org>; Mon,  6 Sep 2021 06:09:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237920AbhIFGK1 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 6 Sep 2021 02:10:27 -0400
Received: from mga11.intel.com ([192.55.52.93]:60154 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229792AbhIFGK1 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 6 Sep 2021 02:10:27 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10098"; a="216735016"
X-IronPort-AV: E=Sophos;i="5.85,271,1624345200"; 
   d="scan'208";a="216735016"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Sep 2021 23:09:22 -0700
X-IronPort-AV: E=Sophos;i="5.85,271,1624345200"; 
   d="scan'208";a="536498601"
Received: from jzhan31-mobl1.ccr.corp.intel.com (HELO chenyu5-mobl1) ([10.249.173.11])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Sep 2021 23:09:13 -0700
Date:   Mon, 6 Sep 2021 14:09:08 +0800
From:   Chen Yu <yu.c.chen@intel.com>
To:     "Huang, Ying" <ying.huang@intel.com>
Cc:     Dave Hansen <dave.hansen@intel.com>,
        kernel test robot <oliver.sang@intel.com>,
        Rui Zhang <rui.zhang@intel.com>,
        Len Brown <len.brown@intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        0day robot <lkp@intel.com>, Yang Shi <shy828301@gmail.com>,
        Zi Yan <ziy@nvidia.com>, Michal Hocko <mhocko@suse.com>,
        Wei Xu <weixugc@google.com>,
        Oscar Salvador <osalvador@suse.de>,
        David Rientjes <rientjes@google.com>,
        Dan Williams <dan.j.williams@intel.com>,
        David Hildenbrand <david@redhat.com>,
        Greg Thelen <gthelen@google.com>,
        Keith Busch <kbusch@kernel.org>,
        Yang Shi <yang.shi@linux.alibaba.com>,
        LKML <linux-kernel@vger.kernel.org>, lkp@lists.01.org,
        feng.tang@intel.com, zhengjun.xing@linux.intel.com,
        dave.hansen@linux.intel.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org
Subject: Re: [mm/migrate] 9eeb73028c: stress-ng.memhotplug.ops_per_sec -53.8%
 regression
Message-ID: <20210906060908.GA17483@chenyu5-mobl1>
References: <20210905135932.GE15026@xsang-OptiPlex-9020>
 <87y28aii58.fsf@yhuang6-desk2.ccr.corp.intel.com>
 <ee55e83e-d8bd-2888-3159-154706aa5173@intel.com>
 <87lf4ai6u3.fsf@yhuang6-desk2.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87lf4ai6u3.fsf@yhuang6-desk2.ccr.corp.intel.com>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Mon, Sep 06, 2021 at 01:57:56PM +0800, Huang, Ying wrote:
> Dave Hansen <dave.hansen@intel.com> writes:
> 
> > On 9/5/21 6:53 PM, Huang, Ying wrote:
> >>> in testcase: stress-ng
> >>> on test machine: 96 threads 2 sockets Intel(R) Xeon(R) Gold 6252 CPU @ 2.10GHz with 192G memory
> >>> with following parameters:
> >>>
> >>> 	nr_threads: 10%
> >>> 	disk: 1HDD
> >>> 	testtime: 60s
> >>> 	fs: ext4
> >>> 	class: os
> >>> 	test: memhotplug
> >>> 	cpufreq_governor: performance
> >>> 	ucode: 0x5003006
> >>>
> >> Because we added some operations during online/offline CPU, it's
> >> expected that the performance of online/offline CPU will decrease.  In
> >> most cases, the performance of CPU hotplug isn't a big problem.  But
> >> then I remembers that the performance of the CPU hotplug may influence
> >> suspend/resume performance :-(
> >> 
> >> It appears that it is easy and reasonable to enclose the added
> >> operations inside #ifdef CONFIG_NUMA.  Is this sufficient to restore the
> >> performance of suspend/resume?
> >
> > It's "memhotplug", not CPUs, right?
> 
> Yes.  Thanks for pointing that out!
> 
> We will update node_demotion[] in CPU hotplug too.  Because the status
> that whether a node has CPU may change after CPU hotplug.  And CPU
> online/offline performance may be relevant for suspend/resume.
>
Rui and I took a look at the default kernel config, it seems that CONFIG_NUMA is
enabled on laptops on some distributions. Maybe a runtime detecting flag indicating
that whether this system has enabled NUMA (static key eg) would be an option too, so as
not to enable node_demotion[] on non-NUMA laptops/desktops.

thanks,
Chenyu
