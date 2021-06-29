Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D8CDC11F64
	for <mm-commits@archiver.kernel.org>; Tue, 29 Jun 2021 02:41:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 199C561D0C
	for <mm-commits@archiver.kernel.org>; Tue, 29 Jun 2021 02:41:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231883AbhF2CoP (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 28 Jun 2021 22:44:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:36510 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231741AbhF2CoP (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 28 Jun 2021 22:44:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 08022611AE;
        Tue, 29 Jun 2021 02:41:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1624934508;
        bh=tlC5aCGBxxFk07nrtJdkJkMZPwtVdMMQKzSvpnniP9M=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=z4Yjlpfg/g1gHIjtA5U8lcqZ+UxMgO/BKNrFwTJxhRjxvA1shGeXMdyqJSiz5kY9c
         VZ5XQYlXIRFMKFQxrUejgdHHMCdH6/2LYLpima2oXCSXMxtcBYbUM/Kbn6F2helk/D
         9SIorBE2FWI68pLRIrHYzdyfLgXTX3Qy2tgT/s5o=
Date:   Mon, 28 Jun 2021 19:41:47 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, bigeasy@linutronix.de,
        brouer@redhat.com, chuck.lever@oracle.com, linux-mm@kvack.org,
        mgorman@techsingularity.net, mhocko@kernel.org, mingo@kernel.org,
        mm-commits@vger.kernel.org, peterz@infradead.org,
        tglx@linutronix.de, torvalds@linux-foundation.org, vbabka@suse.cz
Subject:  [patch 163/192] mm/vmstat: inline NUMA event counter
 updates
Message-ID: <20210629024147.88b0jKs_t%akpm@linux-foundation.org>
In-Reply-To: <20210628193256.008961950a714730751c1423@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Mel Gorman <mgorman@techsingularity.net>
Subject: mm/vmstat: inline NUMA event counter updates

__count_numa_event is small enough to be treated similarly to
__count_vm_event so inline it.

Link: https://lkml.kernel.org/r/20210512095458.30632-5-mgorman@techsingularity.net
Signed-off-by: Mel Gorman <mgorman@techsingularity.net>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Chuck Lever <chuck.lever@oracle.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jesper Dangaard Brouer <brouer@redhat.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/vmstat.h |   10 +++++++++-
 mm/vmstat.c            |    9 ---------
 2 files changed, 9 insertions(+), 10 deletions(-)

--- a/include/linux/vmstat.h~mm-vmstat-inline-numa-event-counter-updates
+++ a/include/linux/vmstat.h
@@ -238,7 +238,15 @@ static inline unsigned long zone_page_st
 }
 
 #ifdef CONFIG_NUMA
-extern void __count_numa_event(struct zone *zone, enum numa_stat_item item);
+/* See __count_vm_event comment on why raw_cpu_inc is used. */
+static inline void
+__count_numa_event(struct zone *zone, enum numa_stat_item item)
+{
+	struct per_cpu_zonestat __percpu *pzstats = zone->per_cpu_zonestats;
+
+	raw_cpu_inc(pzstats->vm_numa_event[item]);
+}
+
 extern unsigned long sum_zone_node_page_state(int node,
 					      enum zone_stat_item item);
 extern unsigned long sum_zone_numa_event_state(int node, enum numa_stat_item item);
--- a/mm/vmstat.c~mm-vmstat-inline-numa-event-counter-updates
+++ a/mm/vmstat.c
@@ -938,15 +938,6 @@ void drain_zonestat(struct zone *zone, s
 #endif
 
 #ifdef CONFIG_NUMA
-/* See __count_vm_event comment on why raw_cpu_inc is used. */
-void __count_numa_event(struct zone *zone,
-				 enum numa_stat_item item)
-{
-	struct per_cpu_zonestat __percpu *pzstats = zone->per_cpu_zonestats;
-
-	raw_cpu_inc(pzstats->vm_numa_event[item]);
-}
-
 /*
  * Determine the per node value of a stat item. This function
  * is called frequently in a NUMA machine, so try to be as
_
