Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	URIBL_RED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E18CBC433ED
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:39:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C46E8613EA
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:39:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229644AbhEHWkE (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 8 May 2021 18:40:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:42816 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229620AbhEHWkD (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 8 May 2021 18:40:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B1AF9613E8;
        Sat,  8 May 2021 22:39:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620513541;
        bh=8deeL2wkyHFChcHb05T3LfjuHiA/DHR+uddVg+h3Hhc=;
        h=Date:From:To:Subject:From;
        b=GKfOYlQZcUG49fZhx940Kxi/pHOG0jQmZwFBgSKYY9kEP0t42ArO2Zr+a0efwrFFL
         7M/NCc4gqEWw4Vexu0nCI8yoCXn21LMfIt1Gr9YrJ6gQy9RYhe8H/mIggI+/1vr2Cv
         L8Hd/0cK4g8UssugdAPZgsrLJnV33T57GKKVrdME=
Date:   Sat, 08 May 2021 15:39:00 -0700
From:   akpm@linux-foundation.org
To:     dietmar.eggemann@arm.com, glaubitz@physik.fu-berlin.de,
        matorola@gmail.com, mingo@kernel.org, mm-commits@vger.kernel.org,
        peterz@infradead.org, slyfox@gentoo.org,
        valentin.schneider@arm.com, vincent.guittot@linaro.org
Subject:  [merged]
 ia64-ensure-proper-numa-distance-and-possible-map-initialization.patch
 removed from -mm tree
Message-ID: <20210508223900.uxJ3fYh9B%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: ia64: ensure proper NUMA distance and possible map initialization
has been removed from the -mm tree.  Its filename was
     ia64-ensure-proper-numa-distance-and-possible-map-initialization.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Valentin Schneider <valentin.schneider@arm.com>
Subject: ia64: ensure proper NUMA distance and possible map initialization

John Paul reported a warning about bogus NUMA distance values spurred by
commit:

  620a6dc40754 ("sched/topology: Make sched_init_numa() use a set for the deduplicating sort")

In this case, the afflicted machine comes up with a reported 256 possible
nodes, all of which are 0 distance away from one another.  This was
previously silently ignored, but is now caught by the aforementioned
commit.

The culprit is ia64's node_possible_map which remains unchanged from its
initialization value of NODE_MASK_ALL.  In John's case, the machine
doesn't have any SRAT nor SLIT table, but AIUI the possible map remains
untouched regardless of what ACPI tables end up being parsed.  Thus,
!online && possible nodes remain with a bogus distance of 0 (distances \in
[0, 9] are "reserved and have no meaning" as per the ACPI spec).

Follow x86 / drivers/base/arch_numa's example and set the possible map to
the parsed map, which in this case seems to be the online map.

Link: http://lore.kernel.org/r/255d6b5d-194e-eb0e-ecdd-97477a534441@physik.fu-berlin.de
Link: https://lkml.kernel.org/r/20210318130617.896309-1-valentin.schneider@arm.com
Fixes: 620a6dc40754 ("sched/topology: Make sched_init_numa() use a set for the deduplicating sort")
Signed-off-by: Valentin Schneider <valentin.schneider@arm.com>
Reported-by: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Tested-by: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Tested-by: Sergei Trofimovich <slyfox@gentoo.org>
Cc: "Peter Zijlstra (Intel)" <peterz@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Vincent Guittot <vincent.guittot@linaro.org>
Cc: Dietmar Eggemann <dietmar.eggemann@arm.com>
Cc: Anatoly Pugachev <matorola@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/kernel/acpi.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/arch/ia64/kernel/acpi.c~ia64-ensure-proper-numa-distance-and-possible-map-initialization
+++ a/arch/ia64/kernel/acpi.c
@@ -446,7 +446,8 @@ void __init acpi_numa_fixup(void)
 	if (srat_num_cpus == 0) {
 		node_set_online(0);
 		node_cpuid[0].phys_id = hard_smp_processor_id();
-		return;
+		slit_distance(0, 0) = LOCAL_DISTANCE;
+		goto out;
 	}
 
 	/*
@@ -489,7 +490,7 @@ void __init acpi_numa_fixup(void)
 			for (j = 0; j < MAX_NUMNODES; j++)
 				slit_distance(i, j) = i == j ?
 					LOCAL_DISTANCE : REMOTE_DISTANCE;
-		return;
+		goto out;
 	}
 
 	memset(numa_slit, -1, sizeof(numa_slit));
@@ -514,6 +515,8 @@ void __init acpi_numa_fixup(void)
 		printk("\n");
 	}
 #endif
+out:
+	node_possible_map = node_online_map;
 }
 #endif				/* CONFIG_ACPI_NUMA */
 
_

Patches currently in -mm which might be from valentin.schneider@arm.com are


