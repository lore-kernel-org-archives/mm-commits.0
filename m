Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91640C54EE9
	for <mm-commits@archiver.kernel.org>; Wed,  7 Sep 2022 22:51:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229436AbiIGWv0 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 7 Sep 2022 18:51:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229734AbiIGWvX (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 7 Sep 2022 18:51:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6ABB1B1BB4
        for <mm-commits@vger.kernel.org>; Wed,  7 Sep 2022 15:51:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 775BF61A85
        for <mm-commits@vger.kernel.org>; Wed,  7 Sep 2022 22:51:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C831EC433C1;
        Wed,  7 Sep 2022 22:51:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1662591080;
        bh=TSPww+XDqLDiq7/MnrUhNw4eKyOtlSx0OvkF1x5hdt8=;
        h=Date:To:From:Subject:From;
        b=B4sTpCOy/FOZKEVwnfOOpH3gE9brLCZwEOJu1JTXJlUmuglcaqfcVpJB0UjUnNAVE
         iD3uq21+YuBfhR1NOEUsFbGNykqufN0io1kc94imeBTpqV1TjMF06xUvMRzW/jN34b
         +1O6ZH771TD6cfJist9bJWcQc8vM52+gVa/t4BlU=
Date:   Wed, 07 Sep 2022 15:51:20 -0700
To:     mm-commits@vger.kernel.org, songmuchun@bytedance.com,
        roman.gushchin@linux.dev, mhocko@kernel.org, hannes@cmpxchg.org,
        shakeelb@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + memcg-rearrange-code.patch added to mm-unstable branch
Message-Id: <20220907225120.C831EC433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: memcg: rearrange code
has been added to the -mm mm-unstable branch.  Its filename is
     memcg-rearrange-code.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/memcg-rearrange-code.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Shakeel Butt <shakeelb@google.com>
Subject: memcg: rearrange code
Date: Wed, 7 Sep 2022 04:35:36 +0000

This is a preparatory patch for easing the review of the follow up patch
which will reduce the memory overhead of memory cgroups.

Link: https://lkml.kernel.org/r/20220907043537.3457014-3-shakeelb@google.com
Signed-off-by: Shakeel Butt <shakeelb@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   46 +++++++++++++++++++++++-----------------------
 1 file changed, 23 insertions(+), 23 deletions(-)

--- a/mm/memcontrol.c~memcg-rearrange-code
+++ a/mm/memcontrol.c
@@ -669,6 +669,29 @@ static void flush_memcg_stats_dwork(stru
 	queue_delayed_work(system_unbound_wq, &stats_flush_dwork, FLUSH_TIME);
 }
 
+/* Subset of vm_event_item to report for memcg event stats */
+static const unsigned int memcg_vm_event_stat[] = {
+	PGSCAN_KSWAPD,
+	PGSCAN_DIRECT,
+	PGSTEAL_KSWAPD,
+	PGSTEAL_DIRECT,
+	PGFAULT,
+	PGMAJFAULT,
+	PGREFILL,
+	PGACTIVATE,
+	PGDEACTIVATE,
+	PGLAZYFREE,
+	PGLAZYFREED,
+#if defined(CONFIG_MEMCG_KMEM) && defined(CONFIG_ZSWAP)
+	ZSWPIN,
+	ZSWPOUT,
+#endif
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
+	THP_FAULT_ALLOC,
+	THP_COLLAPSE_ALLOC,
+#endif
+};
+
 struct memcg_vmstats_percpu {
 	/* Local (CPU and cgroup) page state & events */
 	long			state[MEMCG_NR_STAT];
@@ -1501,29 +1524,6 @@ static inline unsigned long memcg_page_s
 	return memcg_page_state(memcg, item) * memcg_page_state_unit(item);
 }
 
-/* Subset of vm_event_item to report for memcg event stats */
-static const unsigned int memcg_vm_event_stat[] = {
-	PGSCAN_KSWAPD,
-	PGSCAN_DIRECT,
-	PGSTEAL_KSWAPD,
-	PGSTEAL_DIRECT,
-	PGFAULT,
-	PGMAJFAULT,
-	PGREFILL,
-	PGACTIVATE,
-	PGDEACTIVATE,
-	PGLAZYFREE,
-	PGLAZYFREED,
-#if defined(CONFIG_MEMCG_KMEM) && defined(CONFIG_ZSWAP)
-	ZSWPIN,
-	ZSWPOUT,
-#endif
-#ifdef CONFIG_TRANSPARENT_HUGEPAGE
-	THP_FAULT_ALLOC,
-	THP_COLLAPSE_ALLOC,
-#endif
-};
-
 static void memory_stat_format(struct mem_cgroup *memcg, char *buf, int bufsize)
 {
 	struct seq_buf s;
_

Patches currently in -mm which might be from shakeelb@google.com are

mm-page_counter-remove-unneeded-atomic-ops-for-low-min.patch
mm-page_counter-rearrange-struct-page_counter-fields.patch
memcg-increase-memcg_charge_batch-to-64.patch
mm-deduplicate-cacheline-padding-code.patch
memcg-extract-memcg_vmstats-from-struct-mem_cgroup.patch
memcg-rearrange-code.patch
memcg-reduce-size-of-memcg-vmstats-structures.patch

