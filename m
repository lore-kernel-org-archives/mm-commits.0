Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8FC50C25B6E
	for <mm-commits@archiver.kernel.org>; Wed, 25 Oct 2023 23:49:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234971AbjJYXtc (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 25 Oct 2023 19:49:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234602AbjJYXsr (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 25 Oct 2023 19:48:47 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 784BCD4F
        for <mm-commits@vger.kernel.org>; Wed, 25 Oct 2023 16:48:40 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10959C433CA;
        Wed, 25 Oct 2023 23:48:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1698277720;
        bh=IdiLIp4JwWW7Klg2EkQuKHWWOC3psq90xKX8jGbMd1I=;
        h=Date:To:From:Subject:From;
        b=DGvMcCzRMV5gbGxWAMsJueH3Rikzep92EfHRu64CCkCtXIQC3xoA4olp6Fe4CxUPV
         Qt7KMibSBNho+i5OxagCyk0Y2jG/oBjoUm2TLN50qY7d5reqZQdC6Rw5ansG9WzC6d
         VbpC/zXESo17VCwM1QMC5EN6LA46zhKPaQpwLnW0=
Date:   Wed, 25 Oct 2023 16:48:39 -0700
To:     mm-commits@vger.kernel.org, ziy@nvidia.com, ying.huang@intel.com,
        willy@infradead.org, vincent.guittot@linaro.org,
        peterz@infradead.org, mingo@redhat.com, juri.lelli@redhat.com,
        david@redhat.com, wangkefeng.wang@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] sched-fair-use-folio_xchg_access_time-in-numa_hint_fault_latency.patch removed from -mm tree
Message-Id: <20231025234840.10959C433CA@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: sched/fair: use folio_xchg_access_time() in numa_hint_fault_latency()
has been removed from the -mm tree.  Its filename was
     sched-fair-use-folio_xchg_access_time-in-numa_hint_fault_latency.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: sched/fair: use folio_xchg_access_time() in numa_hint_fault_latency()
Date: Wed, 18 Oct 2023 22:07:55 +0800

Convert to use folio_xchg_access_time() in numa_hint_fault_latency().

Link: https://lkml.kernel.org/r/20231018140806.2783514-9-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Huang Ying <ying.huang@intel.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Juri Lelli <juri.lelli@redhat.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Vincent Guittot <vincent.guittot@linaro.org>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sched/fair.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/sched/fair.c~sched-fair-use-folio_xchg_access_time-in-numa_hint_fault_latency
+++ a/kernel/sched/fair.c
@@ -1727,7 +1727,7 @@ static int numa_hint_fault_latency(struc
 	int last_time, time;
 
 	time = jiffies_to_msecs(jiffies);
-	last_time = xchg_page_access_time(&folio->page, time);
+	last_time = folio_xchg_access_time(folio, time);
 
 	return (time - last_time) & PAGE_ACCESS_TIME_MASK;
 }
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are


