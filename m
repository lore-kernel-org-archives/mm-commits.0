Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC28AC4332F
	for <mm-commits@archiver.kernel.org>; Mon,  6 Nov 2023 16:35:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231830AbjKFQfo (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 6 Nov 2023 11:35:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231785AbjKFQfn (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 6 Nov 2023 11:35:43 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1BB31BF
        for <mm-commits@vger.kernel.org>; Mon,  6 Nov 2023 08:35:40 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EE1CC433C9;
        Mon,  6 Nov 2023 16:35:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1699288540;
        bh=ojyOQ2aCpBwooBuVtD70Gdx3Cz7CY5VX8Ydul9Ad6Sc=;
        h=Date:To:From:Subject:From;
        b=jgKaCW1H3yx72DaYVbrj5VnuVMnQvx3kbn2oJFmJ/RBZXJAjZFGMHhlfLMTTTMJr2
         qIKKtDKE0ye4iCnsmFW3tL+R6uxgVP9z0/AV6jOGK7gaIi1Dcss/nHNSHH2EKvhc/V
         YkiPqsiLos4PXy3ceMhiIBQJQC+rR2Bh1OqmqaaU=
Date:   Mon, 06 Nov 2023 08:35:39 -0800
To:     mm-commits@vger.kernel.org, ying.huang@intel.com,
        rafael@kernel.org, gregkh@linuxfoundation.org,
        lizhijian@fujitsu.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmstat-move-pgdemote_-to-per-node-stats.patch added to mm-unstable branch
Message-Id: <20231106163540.6EE1CC433C9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/vmstat: move pgdemote_* to per-node stats
has been added to the -mm mm-unstable branch.  Its filename is
     mm-vmstat-move-pgdemote_-to-per-node-stats.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vmstat-move-pgdemote_-to-per-node-stats.patch

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
From: Li Zhijian <lizhijian@fujitsu.com>
Subject: mm/vmstat: move pgdemote_* to per-node stats
Date: Fri, 3 Nov 2023 11:14:50 +0800

Demotion will migrate pages across nodes.  Previously, only the global
demotion statistics were accounted for.  Changed them to per-node
statistics, making it easier to observe where demotion occurs on each
node.

This will help to identify which nodes are under pressure.

This patch also make pgdemote_* behind CONFIG_NUMA_BALANCING, since
demotion is not available for !CONFIG_NUMA_BALANCING

With this patch, here is a sample where node0 node1 are DRAM,
node3 is PMEM:
Global stats:
$ grep demote /proc/vmstat
pgdemote_kswapd 254288
pgdemote_direct 113497
pgdemote_khugepaged 0

Per-node stats:
$ grep demote /sys/devices/system/node/node0/vmstat # demotion source
pgdemote_kswapd 68454
pgdemote_direct 83431
pgdemote_khugepaged 0
$ grep demote /sys/devices/system/node/node1/vmstat # demotion source
pgdemote_kswapd 185834
pgdemote_direct 30066
pgdemote_khugepaged 0
$ grep demote /sys/devices/system/node/node3/vmstat # demotion target
pgdemote_kswapd 0
pgdemote_direct 0
pgdemote_khugepaged 0

Link: https://lkml.kernel.org/r/20231103031450.1456523-1-lizhijian@fujitsu.com
Signed-off-by: Li Zhijian <lizhijian@fujitsu.com>
Acked-by: "Huang, Ying" <ying.huang@intel.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "Rafael J. Wysocki" <rafael@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h        |    4 ++++
 include/linux/vm_event_item.h |    3 ---
 mm/vmscan.c                   |   12 ++++++++----
 mm/vmstat.c                   |    6 +++---
 4 files changed, 15 insertions(+), 10 deletions(-)

--- a/include/linux/mmzone.h~mm-vmstat-move-pgdemote_-to-per-node-stats
+++ a/include/linux/mmzone.h
@@ -206,6 +206,10 @@ enum node_stat_item {
 #ifdef CONFIG_NUMA_BALANCING
 	PGPROMOTE_SUCCESS,	/* promote successfully */
 	PGPROMOTE_CANDIDATE,	/* candidate pages to promote */
+	/* PGDEMOTE_*: pages demoted */
+	PGDEMOTE_KSWAPD,
+	PGDEMOTE_DIRECT,
+	PGDEMOTE_KHUGEPAGED,
 #endif
 	NR_VM_NODE_STAT_ITEMS
 };
--- a/include/linux/vm_event_item.h~mm-vmstat-move-pgdemote_-to-per-node-stats
+++ a/include/linux/vm_event_item.h
@@ -41,9 +41,6 @@ enum vm_event_item { PGPGIN, PGPGOUT, PS
 		PGSTEAL_KSWAPD,
 		PGSTEAL_DIRECT,
 		PGSTEAL_KHUGEPAGED,
-		PGDEMOTE_KSWAPD,
-		PGDEMOTE_DIRECT,
-		PGDEMOTE_KHUGEPAGED,
 		PGSCAN_KSWAPD,
 		PGSCAN_DIRECT,
 		PGSCAN_KHUGEPAGED,
--- a/mm/vmscan.c~mm-vmstat-move-pgdemote_-to-per-node-stats
+++ a/mm/vmscan.c
@@ -409,12 +409,14 @@ void drop_slab(void)
 
 static int reclaimer_offset(void)
 {
+#ifdef CONFIG_NUMA_BALANCING
 	BUILD_BUG_ON(PGSTEAL_DIRECT - PGSTEAL_KSWAPD !=
 			PGDEMOTE_DIRECT - PGDEMOTE_KSWAPD);
-	BUILD_BUG_ON(PGSTEAL_DIRECT - PGSTEAL_KSWAPD !=
-			PGSCAN_DIRECT - PGSCAN_KSWAPD);
 	BUILD_BUG_ON(PGSTEAL_KHUGEPAGED - PGSTEAL_KSWAPD !=
 			PGDEMOTE_KHUGEPAGED - PGDEMOTE_KSWAPD);
+#endif
+	BUILD_BUG_ON(PGSTEAL_DIRECT - PGSTEAL_KSWAPD !=
+			PGSCAN_DIRECT - PGSCAN_KSWAPD);
 	BUILD_BUG_ON(PGSTEAL_KHUGEPAGED - PGSTEAL_KSWAPD !=
 			PGSCAN_KHUGEPAGED - PGSCAN_KSWAPD);
 
@@ -976,8 +978,10 @@ static unsigned int demote_folio_list(st
 	migrate_pages(demote_folios, alloc_demote_folio, NULL,
 		      (unsigned long)&mtc, MIGRATE_ASYNC, MR_DEMOTION,
 		      &nr_succeeded);
-
-	__count_vm_events(PGDEMOTE_KSWAPD + reclaimer_offset(), nr_succeeded);
+#ifdef CONFIG_NUMA_BALANCING
+	mod_node_page_state(pgdat, PGDEMOTE_KSWAPD + reclaimer_offset(),
+			    nr_succeeded);
+#endif
 
 	return nr_succeeded;
 }
--- a/mm/vmstat.c~mm-vmstat-move-pgdemote_-to-per-node-stats
+++ a/mm/vmstat.c
@@ -1248,6 +1248,9 @@ const char * const vmstat_text[] = {
 #ifdef CONFIG_NUMA_BALANCING
 	"pgpromote_success",
 	"pgpromote_candidate",
+	"pgdemote_kswapd",
+	"pgdemote_direct",
+	"pgdemote_khugepaged",
 #endif
 
 	/* enum writeback_stat_item counters */
@@ -1279,9 +1282,6 @@ const char * const vmstat_text[] = {
 	"pgsteal_kswapd",
 	"pgsteal_direct",
 	"pgsteal_khugepaged",
-	"pgdemote_kswapd",
-	"pgdemote_direct",
-	"pgdemote_khugepaged",
 	"pgscan_kswapd",
 	"pgscan_direct",
 	"pgscan_khugepaged",
_

Patches currently in -mm which might be from lizhijian@fujitsu.com are

mm-vmstat-move-pgdemote_-to-per-node-stats.patch

