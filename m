Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE0B3C433B4
	for <mm-commits@archiver.kernel.org>; Thu, 13 May 2021 00:30:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8B30C613CA
	for <mm-commits@archiver.kernel.org>; Thu, 13 May 2021 00:30:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231480AbhEMAbH (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 12 May 2021 20:31:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:41950 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237543AbhEMAam (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 12 May 2021 20:30:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1992261405;
        Thu, 13 May 2021 00:29:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620865772;
        bh=p5mTcyGMUkBYFd7U6JjhMZJ8NqmemI+FxZXa9qiD8w8=;
        h=Date:From:To:Subject:From;
        b=SIQopCovVJfUIM6ZOHvsVpzq5h5PHePup4fVlfn9cu0hg+UoHkTnaOpokXbHUOXZb
         KQ62T1bcHezE73ZQfBp4jO3ci4sxpbY+ujYtMg5WssSbr7HLUvAq+ium78qYxYqZ1E
         GzNE4VYoqET6U6G34Mbm3xz0Go2/X9bQ/9EoJQB4=
Date:   Wed, 12 May 2021 17:29:31 -0700
From:   akpm@linux-foundation.org
To:     bigeasy@linutronix.de, brouer@redhat.com, chuck.lever@oracle.com,
        mgorman@techsingularity.net, mhocko@kernel.org, mingo@kernel.org,
        mm-commits@vger.kernel.org, peterz@infradead.org,
        tglx@linutronix.de, vbabka@suse.cz
Subject:  + mm-vmstat-inline-numa-event-counter-updates.patch added
 to -mm tree
Message-ID: <20210513002931.3baCOO2kJ%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/vmstat: inline NUMA event counter updates
has been added to the -mm tree.  Its filename is
     mm-vmstat-inline-numa-event-counter-updates.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-vmstat-inline-numa-event-counter-updates.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-vmstat-inline-numa-event-counter-updates.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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

Patches currently in -mm which might be from mgorman@techsingularity.net are

mm-page_alloc-split-per-cpu-page-lists-and-zone-stats.patch
mm-page_alloc-convert-per-cpu-list-protection-to-local_lock.patch
mm-vmstat-convert-numa-statistics-to-basic-numa-counters.patch
mm-vmstat-inline-numa-event-counter-updates.patch
mm-page_alloc-batch-the-accounting-updates-in-the-bulk-allocator.patch
mm-page_alloc-reduce-duration-that-irqs-are-disabled-for-vm-counters.patch
mm-page_alloc-explicitly-acquire-the-zone-lock-in-__free_pages_ok.patch
mm-page_alloc-avoid-conflating-irqs-disabled-with-zone-lock.patch
mm-page_alloc-update-pgfree-outside-the-zone-lock-in-__free_pages_ok.patch

