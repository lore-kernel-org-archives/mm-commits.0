Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DAF43C433F5
	for <mm-commits@archiver.kernel.org>; Mon,  6 Sep 2021 01:53:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BE8AD60F3A
	for <mm-commits@archiver.kernel.org>; Mon,  6 Sep 2021 01:53:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232115AbhIFByv (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 5 Sep 2021 21:54:51 -0400
Received: from mga03.intel.com ([134.134.136.65]:63775 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238511AbhIFByv (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 5 Sep 2021 21:54:51 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10098"; a="219916175"
X-IronPort-AV: E=Sophos;i="5.85,271,1624345200"; 
   d="scan'208";a="219916175"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Sep 2021 18:53:47 -0700
X-IronPort-AV: E=Sophos;i="5.85,271,1624345200"; 
   d="scan'208";a="536346047"
Received: from yhuang6-desk2.sh.intel.com (HELO yhuang6-desk2.ccr.corp.intel.com) ([10.239.159.119])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Sep 2021 18:53:41 -0700
From:   "Huang, Ying" <ying.huang@intel.com>
To:     kernel test robot <oliver.sang@intel.com>,
        Rui Zhang <rui.zhang@intel.com>, Chen Yu <yu.c.chen@intel.com>,
        Len Brown <len.brown@intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
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
        LKML <linux-kernel@vger.kernel.org>, <lkp@lists.01.org>,
        <feng.tang@intel.com>, <zhengjun.xing@linux.intel.com>,
        <dave.hansen@linux.intel.com>, <linux-mm@kvack.org>,
        <mm-commits@vger.kernel.org>, <torvalds@linux-foundation.org>
Subject: Re: [mm/migrate]  9eeb73028c:  stress-ng.memhotplug.ops_per_sec
 -53.8% regression
References: <20210905135932.GE15026@xsang-OptiPlex-9020>
Date:   Mon, 06 Sep 2021 09:53:39 +0800
In-Reply-To: <20210905135932.GE15026@xsang-OptiPlex-9020> (kernel test robot's
        message of "Sun, 5 Sep 2021 21:59:33 +0800")
Message-ID: <87y28aii58.fsf@yhuang6-desk2.ccr.corp.intel.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=ascii
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

kernel test robot <oliver.sang@intel.com> writes:

> Greeting,
>
> FYI, we noticed a -53.8% regression of stress-ng.memhotplug.ops_per_sec due to commit:
>
>
> commit: 9eeb73028cfb54eb06efe87c50cc014d3f1ff43e ("[patch 174/212] mm/migrate: update node demotion order on hotplug events")
> url: https://github.com/0day-ci/linux/commits/Andrew-Morton/ia64-fix-typo-in-a-comment/20210903-065028
>
>
> in testcase: stress-ng
> on test machine: 96 threads 2 sockets Intel(R) Xeon(R) Gold 6252 CPU @ 2.10GHz with 192G memory
> with following parameters:
>
> 	nr_threads: 10%
> 	disk: 1HDD
> 	testtime: 60s
> 	fs: ext4
> 	class: os
> 	test: memhotplug
> 	cpufreq_governor: performance
> 	ucode: 0x5003006
>

Because we added some operations during online/offline CPU, it's
expected that the performance of online/offline CPU will decrease.  In
most cases, the performance of CPU hotplug isn't a big problem.  But
then I remembers that the performance of the CPU hotplug may influence
suspend/resume performance :-(

It appears that it is easy and reasonable to enclose the added
operations inside #ifdef CONFIG_NUMA.  Is this sufficient to restore the
performance of suspend/resume?

Best Regards,
Huang, Ying
