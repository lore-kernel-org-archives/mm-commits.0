Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F5D3C433EF
	for <mm-commits@archiver.kernel.org>; Fri, 17 Sep 2021 03:15:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 233AC61019
	for <mm-commits@archiver.kernel.org>; Fri, 17 Sep 2021 03:15:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243342AbhIQDQ2 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 16 Sep 2021 23:16:28 -0400
Received: from mga05.intel.com ([192.55.52.43]:16061 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232364AbhIQDQ2 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 16 Sep 2021 23:16:28 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10109"; a="308256659"
X-IronPort-AV: E=Sophos;i="5.85,299,1624345200"; 
   d="scan'208";a="308256659"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Sep 2021 20:15:06 -0700
X-IronPort-AV: E=Sophos;i="5.85,299,1624345200"; 
   d="scan'208";a="546111841"
Received: from yhuang6-desk2.sh.intel.com (HELO yhuang6-desk2.ccr.corp.intel.com) ([10.239.159.119])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Sep 2021 20:15:01 -0700
From:   "Huang, Ying" <ying.huang@intel.com>
To:     kernel test robot <oliver.sang@intel.com>
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
Date:   Fri, 17 Sep 2021 11:14:59 +0800
In-Reply-To: <20210905135932.GE15026@xsang-OptiPlex-9020> (kernel test robot's
        message of "Sun, 5 Sep 2021 21:59:33 +0800")
Message-ID: <87a6kbq4ek.fsf@yhuang6-desk2.ccr.corp.intel.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=ascii
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

Hi, Oliver,

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

Can you help to test whether the following patch can recover the
regression?

Best Regards,
Huang, Ying

----------------------------8<--------------------------------------
From 5d3e18a9f083954584932a20233ef489d9398342 Mon Sep 17 00:00:00 2001
From: Huang Ying <ying.huang@intel.com>
Date: Thu, 16 Sep 2021 16:51:44 +0800
Subject: [PATCH] mm/migrate: recover hotplug performance regression

0-Day kernel test robot reported a -53.8% performance regression for
stress-ng memhotplug test case.  This patch is to recover the
regression via avoid updating the demotion order if not necessary.

Refer: https://lore.kernel.org/lkml/20210905135932.GE15026@xsang-OptiPlex-9020/
Fixes: 884a6e5d1f93 ("mm/migrate: update node demotion order on hotplug events")
Signed-off-by: "Huang, Ying" <ying.huang@intel.com>
Suggested-by: Dave Hansen <dave.hansen@linux.intel.com>
Reported-by: kernel test robot <oliver.sang@intel.com>
Cc: Yang Shi <shy828301@gmail.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Wei Xu <weixugc@google.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: David Rientjes <rientjes@google.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Greg Thelen <gthelen@google.com>
Cc: Keith Busch <kbusch@kernel.org>
---
 mm/migrate.c | 26 ++++++++++++++++++++++----
 1 file changed, 22 insertions(+), 4 deletions(-)

diff --git a/mm/migrate.c b/mm/migrate.c
index 77d107a4577f..20d803707497 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -1145,6 +1145,8 @@ static int __unmap_and_move(struct page *page, struct page *newpage,
 static int node_demotion[MAX_NUMNODES] __read_mostly =
 	{[0 ...  MAX_NUMNODES - 1] = NUMA_NO_NODE};
 
+static bool node_demotion_disabled __read_mostly;
+
 /**
  * next_demotion_node() - Get the next node in the demotion path
  * @node: The starting node to lookup the next node
@@ -1158,6 +1160,8 @@ int next_demotion_node(int node)
 {
 	int target;
 
+	if (node_demotion_disabled)
+		return NUMA_NO_NODE;
 	/*
 	 * node_demotion[] is updated without excluding this
 	 * function from running.  RCU doesn't provide any
@@ -3198,13 +3202,26 @@ static void __set_migration_target_nodes(void)
 		goto again;
 }
 
+static int nr_node_has_cpu;
+static int nr_node_has_mem;
+
+static void check_set_migration_target_nodes(void)
+{
+	if (num_node_state(N_MEMORY) != nr_node_has_mem ||
+	    num_node_state(N_CPU) != nr_node_has_cpu) {
+		__set_migration_target_nodes();
+		nr_node_has_mem = num_node_state(N_MEMORY);
+		nr_node_has_cpu = num_node_state(N_CPU);
+	}
+}
+
 /*
  * For callers that do not hold get_online_mems() already.
  */
 static void set_migration_target_nodes(void)
 {
 	get_online_mems();
-	__set_migration_target_nodes();
+	check_set_migration_target_nodes();
 	put_online_mems();
 }
 
@@ -3249,7 +3266,7 @@ static int __meminit migrate_on_reclaim_callback(struct notifier_block *self,
 		 * will leave migration disabled until the offline
 		 * completes and the MEM_OFFLINE case below runs.
 		 */
-		disable_all_migrate_targets();
+		node_demotion_disabled = true;
 		break;
 	case MEM_OFFLINE:
 	case MEM_ONLINE:
@@ -3257,14 +3274,15 @@ static int __meminit migrate_on_reclaim_callback(struct notifier_block *self,
 		 * Recalculate the target nodes once the node
 		 * reaches its final state (online or offline).
 		 */
-		__set_migration_target_nodes();
+		check_set_migration_target_nodes();
+		node_demotion_disabled = false;
 		break;
 	case MEM_CANCEL_OFFLINE:
 		/*
 		 * MEM_GOING_OFFLINE disabled all the migration
 		 * targets.  Reenable them.
 		 */
-		__set_migration_target_nodes();
+		node_demotion_disabled = false;
 		break;
 	case MEM_GOING_ONLINE:
 	case MEM_CANCEL_ONLINE:
-- 
2.30.2

