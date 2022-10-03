Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5BDEC4332F
	for <mm-commits@archiver.kernel.org>; Mon,  3 Oct 2022 21:11:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229896AbiJCVLl (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 3 Oct 2022 17:11:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229919AbiJCVJe (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 3 Oct 2022 17:09:34 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7709750184
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 14:06:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E31936118C
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 21:06:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 466E6C433D6;
        Mon,  3 Oct 2022 21:06:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664831201;
        bh=AYrDMxZZow/1TVNVLC96w1bJnAQXQUM2W12P1Ez1JDk=;
        h=Date:To:From:Subject:From;
        b=oE7jkw6T636V6s1zMNheiiNP6teOKu/55S0egM/WKkKQQnL6H8sDu7pPnwJCp/OQQ
         nK4JBXQbglrBCO9c3PFy844DA70ZgjvZoeOm/KwIvZw937ZqsIBhm6eBwpTUN7yXhH
         Pp6X3E8aJLXlOKPFwan5Yq8X2KdMv/Io6Pk1POGk=
Date:   Mon, 03 Oct 2022 14:06:40 -0700
To:     mm-commits@vger.kernel.org, songmuchun@bytedance.com,
        roman.gushchin@linux.dev, mhocko@kernel.org, hannes@cmpxchg.org,
        shakeelb@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] memcg-rearrange-code.patch removed from -mm tree
Message-Id: <20221003210641.466E6C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: memcg: rearrange code
has been removed from the -mm tree.  Its filename was
     memcg-rearrange-code.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Shakeel Butt <shakeelb@google.com>
Subject: memcg: rearrange code
Date: Wed, 7 Sep 2022 04:35:36 +0000

This is a preparatory patch for easing the review of the follow up patch
which will reduce the memory overhead of memory cgroups.

Link: https://lkml.kernel.org/r/20220907043537.3457014-3-shakeelb@google.com
Signed-off-by: Shakeel Butt <shakeelb@google.com>
Acked-by: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <songmuchun@bytedance.com>
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


