Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1ED6DC25B72
	for <mm-commits@archiver.kernel.org>; Wed, 25 Oct 2023 23:49:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233051AbjJYXtf (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 25 Oct 2023 19:49:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234833AbjJYXsr (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 25 Oct 2023 19:48:47 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1B781A2
        for <mm-commits@vger.kernel.org>; Wed, 25 Oct 2023 16:48:44 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 806ECC433C7;
        Wed, 25 Oct 2023 23:48:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1698277724;
        bh=IlX1hjIuk7DR9TMMBziof6ToZI269enoro22lC14UNo=;
        h=Date:To:From:Subject:From;
        b=FV6U/jyncJpw1k0frZHTEPJuNFhZIeHNyuuhLE/YuyTUAwxvDK61OFBGqALQTINR3
         XDlWVSclQsL+ODe1H5n1gBRXEebD4ATkuhNL3YRq2yikqnhHoQHS3RsvgMZme9nDMk
         zo03Jx7xQzERLUBqIY7hXXSNPsCfWefSvdJsxBvE=
Date:   Wed, 25 Oct 2023 16:48:43 -0700
To:     mm-commits@vger.kernel.org, ziy@nvidia.com, ying.huang@intel.com,
        willy@infradead.org, vincent.guittot@linaro.org,
        peterz@infradead.org, mingo@redhat.com, juri.lelli@redhat.com,
        david@redhat.com, wangkefeng.wang@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] sched-fair-use-folio_xchg_last_cpupid-in-should_numa_migrate_memory.patch removed from -mm tree
Message-Id: <20231025234844.806ECC433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: sched/fair: use folio_xchg_last_cpupid() in should_numa_migrate_memory()
has been removed from the -mm tree.  Its filename was
     sched-fair-use-folio_xchg_last_cpupid-in-should_numa_migrate_memory.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: sched/fair: use folio_xchg_last_cpupid() in should_numa_migrate_memory()
Date: Wed, 18 Oct 2023 22:08:00 +0800

Convert to use folio_xchg_last_cpupid() in should_numa_migrate_memory().

Link: https://lkml.kernel.org/r/20231018140806.2783514-14-wangkefeng.wang@huawei.com
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

--- a/kernel/sched/fair.c~sched-fair-use-folio_xchg_last_cpupid-in-should_numa_migrate_memory
+++ a/kernel/sched/fair.c
@@ -1823,7 +1823,7 @@ bool should_numa_migrate_memory(struct t
 	}
 
 	this_cpupid = cpu_pid_to_cpupid(dst_cpu, current->pid);
-	last_cpupid = page_cpupid_xchg_last(&folio->page, this_cpupid);
+	last_cpupid = folio_xchg_last_cpupid(folio, this_cpupid);
 
 	if (!(sysctl_numa_balancing_mode & NUMA_BALANCING_MEMORY_TIERING) &&
 	    !node_is_toptier(src_nid) && !cpupid_valid(last_cpupid))
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are


