Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57635C433EF
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 20:40:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 469876126A
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 20:40:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232468AbhKEUnJ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 5 Nov 2021 16:43:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:37836 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233000AbhKEUnI (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 5 Nov 2021 16:43:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 818D5611C0;
        Fri,  5 Nov 2021 20:40:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636144828;
        bh=vvUHKsxEpicZ251+SkDu9X2UOc8I4Uix0HUuSo0JoGo=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=pv9mhkGAGSDKHPHF6jPbmaoAZ489HrAAou1PAU+459ZseTAT6iXCQblck1fmD6Ndw
         lG6xy5XnwEsbKmwZwdBiJa/ITzrzYUxSkxFL8a8KIk2HB00aEY/HFdsd2yJQmR1O/a
         ftXZsGjC7CAKzH5gHw1ecbrWTPJAnLHjRVPpYYBE=
Date:   Fri, 05 Nov 2021 13:40:28 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, dalias@libc.org,
        geert+renesas@glider.be, gonsolo@gmail.com, juri.lelli@redhat.com,
        linux-mm@kvack.org, matt@codeblueprint.co.uk, mgorman@suse.de,
        mingo@redhat.com, mm-commits@vger.kernel.org, peterz@infradead.org,
        torvalds@linux-foundation.org, vbabka@suse.cz,
        vincent.guittot@linaro.org, ysato@users.osdn.me
Subject:  [patch 111/262] mm: move fold_vm_numa_events() to fix
 NUMA without SMP
Message-ID: <20211105204028.gK19bresm%akpm@linux-foundation.org>
In-Reply-To: <20211105133408.cccbb98b71a77d5e8430aba1@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Geert Uytterhoeven <geert+renesas@glider.be>
Subject: mm: move fold_vm_numa_events() to fix NUMA without SMP

If CONFIG_NUMA=y, but CONFIG_SMP=n (e.g. sh/migor_defconfig):

    sh4-linux-gnu-ld: mm/vmstat.o: in function `vmstat_start':
    vmstat.c:(.text+0x97c): undefined reference to `fold_vm_numa_events'
    sh4-linux-gnu-ld: drivers/base/node.o: in function `node_read_vmstat':
    node.c:(.text+0x140): undefined reference to `fold_vm_numa_events'
    sh4-linux-gnu-ld: drivers/base/node.o: in function `node_read_numastat':
    node.c:(.text+0x1d0): undefined reference to `fold_vm_numa_events'

Fix this by moving fold_vm_numa_events() outside the SMP-only section.

Link: https://lkml.kernel.org/r/9d16ccdd9ef32803d7100c84f737de6a749314fb.1631781495.git.geert+renesas@glider.be
Fixes: f19298b9516c1a03 ("mm/vmstat: convert NUMA statistics to basic NUMA counters")
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Acked-by: Mel Gorman <mgorman@suse.de>
Cc: Gon Solo <gonsolo@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Juri Lelli <juri.lelli@redhat.com>
Cc: Matt Fleming <matt@codeblueprint.co.uk>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Rich Felker <dalias@libc.org>
Cc: Vincent Guittot <vincent.guittot@linaro.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Yoshinori Sato <ysato@users.osdn.me>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmstat.c |   56 +++++++++++++++++++++++++-------------------------
 1 file changed, 28 insertions(+), 28 deletions(-)

--- a/mm/vmstat.c~mm-move-fold_vm_numa_events-to-fix-numa-without-smp
+++ a/mm/vmstat.c
@@ -165,6 +165,34 @@ atomic_long_t vm_numa_event[NR_VM_NUMA_E
 EXPORT_SYMBOL(vm_zone_stat);
 EXPORT_SYMBOL(vm_node_stat);
 
+#ifdef CONFIG_NUMA
+static void fold_vm_zone_numa_events(struct zone *zone)
+{
+	unsigned long zone_numa_events[NR_VM_NUMA_EVENT_ITEMS] = { 0, };
+	int cpu;
+	enum numa_stat_item item;
+
+	for_each_online_cpu(cpu) {
+		struct per_cpu_zonestat *pzstats;
+
+		pzstats = per_cpu_ptr(zone->per_cpu_zonestats, cpu);
+		for (item = 0; item < NR_VM_NUMA_EVENT_ITEMS; item++)
+			zone_numa_events[item] += xchg(&pzstats->vm_numa_event[item], 0);
+	}
+
+	for (item = 0; item < NR_VM_NUMA_EVENT_ITEMS; item++)
+		zone_numa_event_add(zone_numa_events[item], zone, item);
+}
+
+void fold_vm_numa_events(void)
+{
+	struct zone *zone;
+
+	for_each_populated_zone(zone)
+		fold_vm_zone_numa_events(zone);
+}
+#endif
+
 #ifdef CONFIG_SMP
 
 int calculate_pressure_threshold(struct zone *zone)
@@ -771,34 +799,6 @@ static int fold_diff(int *zone_diff, int
 	return changes;
 }
 
-#ifdef CONFIG_NUMA
-static void fold_vm_zone_numa_events(struct zone *zone)
-{
-	unsigned long zone_numa_events[NR_VM_NUMA_EVENT_ITEMS] = { 0, };
-	int cpu;
-	enum numa_stat_item item;
-
-	for_each_online_cpu(cpu) {
-		struct per_cpu_zonestat *pzstats;
-
-		pzstats = per_cpu_ptr(zone->per_cpu_zonestats, cpu);
-		for (item = 0; item < NR_VM_NUMA_EVENT_ITEMS; item++)
-			zone_numa_events[item] += xchg(&pzstats->vm_numa_event[item], 0);
-	}
-
-	for (item = 0; item < NR_VM_NUMA_EVENT_ITEMS; item++)
-		zone_numa_event_add(zone_numa_events[item], zone, item);
-}
-
-void fold_vm_numa_events(void)
-{
-	struct zone *zone;
-
-	for_each_populated_zone(zone)
-		fold_vm_zone_numa_events(zone);
-}
-#endif
-
 /*
  * Update the zone counters for the current cpu.
  *
_
