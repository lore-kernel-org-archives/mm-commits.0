Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8307C433EF
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 20:40:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B413361279
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 20:40:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233197AbhKEUnG (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 5 Nov 2021 16:43:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:37782 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232468AbhKEUnF (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 5 Nov 2021 16:43:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2744A6126A;
        Fri,  5 Nov 2021 20:40:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636144825;
        bh=P0QIEuxGBYHx79EtCWiPsmTJpCCbBMmKsyWIt75zDBw=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=uL37d0FQNyr4n0/ZBjjuoTmeEgW6KOpJtQi7pclLf4qJrD5saD9WmhfXXwsFYIIzo
         KNyuGXYyNUKEU9tA84ycwqGUKJDrMZJyYI604TdL/jZ+vAZMx4jyajbY1FKtpYmq6p
         QYwh5GBtp5UwqmIhnzApvVbiInoAmiZEZf/lnpZY=
Date:   Fri, 05 Nov 2021 13:40:24 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, dalias@libc.org,
        geert+renesas@glider.be, gonsolo@gmail.com, juri.lelli@redhat.com,
        linux-mm@kvack.org, matt@codeblueprint.co.uk, mgorman@suse.de,
        mingo@redhat.com, mm-commits@vger.kernel.org, peterz@infradead.org,
        torvalds@linux-foundation.org, vbabka@suse.cz,
        vincent.guittot@linaro.org, ysato@users.osdn.me
Subject:  [patch 110/262] mm: move node_reclaim_distance to fix
 NUMA without SMP
Message-ID: <20211105204024.xjOD4DN7W%akpm@linux-foundation.org>
In-Reply-To: <20211105133408.cccbb98b71a77d5e8430aba1@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Geert Uytterhoeven <geert+renesas@glider.be>
Subject: mm: move node_reclaim_distance to fix NUMA without SMP

Patch series "Fix NUMA without SMP".

SuperH is the only architecture which still supports NUMA without SMP, for
good reasons (various memories scattered around the address space, each
with varying latencies).  This series fixes two build errors due to
variables and functions used by the NUMA code being provided by SMP-only
source files or sections.


This patch (of 2):

If CONFIG_NUMA=y, but CONFIG_SMP=n (e.g. sh/migor_defconfig):

    sh4-linux-gnu-ld: mm/page_alloc.o: in function `get_page_from_freelist':
    page_alloc.c:(.text+0x2c24): undefined reference to `node_reclaim_distance'

Fix this by moving the declaration of node_reclaim_distance from an
SMP-only to a generic file.

Link: https://lkml.kernel.org/r/cover.1631781495.git.geert+renesas@glider.be
Link: https://lkml.kernel.org/r/6432666a648dde85635341e6c918cee97c97d264.1631781495.git.geert+renesas@glider.be
Fixes: a55c7454a8c887b2 ("sched/topology: Improve load balancing on AMD EPYC systems")
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Suggested-by: Matt Fleming <matt@codeblueprint.co.uk>
Acked-by: Mel Gorman <mgorman@suse.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Juri Lelli <juri.lelli@redhat.com>
Cc: Vincent Guittot <vincent.guittot@linaro.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Yoshinori Sato <ysato@users.osdn.me>
Cc: Rich Felker <dalias@libc.org>
Cc: Gon Solo <gonsolo@gmail.com>
Cc: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sched/topology.c |    1 -
 mm/page_alloc.c         |    2 ++
 2 files changed, 2 insertions(+), 1 deletion(-)

--- a/kernel/sched/topology.c~mm-move-node_reclaim_distance-to-fix-numa-without-smp
+++ a/kernel/sched/topology.c
@@ -1481,7 +1481,6 @@ static int			sched_domains_curr_level;
 int				sched_max_numa_distance;
 static int			*sched_domains_numa_distance;
 static struct cpumask		***sched_domains_numa_masks;
-int __read_mostly		node_reclaim_distance = RECLAIM_DISTANCE;
 
 static unsigned long __read_mostly *sched_numa_onlined_nodes;
 #endif
--- a/mm/page_alloc.c~mm-move-node_reclaim_distance-to-fix-numa-without-smp
+++ a/mm/page_alloc.c
@@ -3960,6 +3960,8 @@ bool zone_watermark_ok_safe(struct zone
 }
 
 #ifdef CONFIG_NUMA
+int __read_mostly node_reclaim_distance = RECLAIM_DISTANCE;
+
 static bool zone_allows_reclaim(struct zone *local_zone, struct zone *zone)
 {
 	return node_distance(zone_to_nid(local_zone), zone_to_nid(zone)) <=
_
