Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 710C0C433F5
	for <mm-commits@archiver.kernel.org>; Tue, 19 Oct 2021 18:39:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 59BE86115B
	for <mm-commits@archiver.kernel.org>; Tue, 19 Oct 2021 18:39:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234665AbhJSSlX (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 19 Oct 2021 14:41:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:52304 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234124AbhJSSlV (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 19 Oct 2021 14:41:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D2094611AD;
        Tue, 19 Oct 2021 18:39:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1634668748;
        bh=2fnz1eAkQ3T2s4cBZnxzwntxe7xDl1c1UaapDzEEPqs=;
        h=Date:From:To:Subject:From;
        b=fDl8/yjDiClwruwk4n71o+9wSG1x+VzVVR0NhkgiFf55bmN0cnXTasFhwilqJFOSl
         93AxtG3m1fl3p9O93cV3jOrLSQLqWouL4jAVongS1BtZsGLHOryRhHsOiOH1CHMOyM
         PtcSZKC6vHQZrKbwwNcNkf7IJ66+OH9xs6ZXFhkI=
Date:   Tue, 19 Oct 2021 11:39:07 -0700
From:   akpm@linux-foundation.org
To:     dan.j.williams@intel.com, dave.hansen@linux.intel.com,
        david@redhat.com, gthelen@google.com, kbusch@kernel.org,
        mhocko@suse.com, mm-commits@vger.kernel.org, osalvador@suse.de,
        rientjes@google.com, shy828301@gmail.com, tglx@linutronix.de,
        weixugc@google.com, ying.huang@intel.com, ziy@nvidia.com
Subject:  [merged]
 mm-migrate-fix-cpuhp-state-to-update-node-demotion-order.patch removed from
 -mm tree
Message-ID: <20211019183907.0T0rsLA01%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/migrate: fix CPUHP state to update node demotion order
has been removed from the -mm tree.  Its filename was
     mm-migrate-fix-cpuhp-state-to-update-node-demotion-order.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Huang Ying <ying.huang@intel.com>
Subject: mm/migrate: fix CPUHP state to update node demotion order

The node demotion order needs to be updated during CPU hotplug.  Because
whether a NUMA node has CPU may influence the demotion order.  The update
function should be called during CPU online/offline after the
node_states[N_CPU] has been updated.  That is done in CPUHP_AP_ONLINE_DYN
during CPU online and in CPUHP_MM_VMSTAT_DEAD during CPU offline.  But in
commit 884a6e5d1f93 ("mm/migrate: update node demotion order on hotplug
events"), the function to update node demotion order is called in
CPUHP_AP_ONLINE_DYN during CPU online/offline.  This doesn't satisfy the
order requirement.

For example, there are 4 CPUs (P0, P1, P2, P3) in 2 sockets (P0, P1 in S0
and P2, P3 in S1), the demotion order is

- S0 -> NUMA_NO_NODE
- S1 -> NUMA_NO_NODE

After P2 and P3 is offlined, because S1 has no CPU now, the demotion
order should have been changed to

- S0 -> S1
- S1 -> NO_NODE

but it isn't changed, because the order updating callback for CPU hotplug
doesn't see the new nodemask.  After that, if P1 is offlined, the demotion
order is changed to the expected order as above.

So in this patch, we added CPUHP_AP_MM_DEMOTION_ONLINE and
CPUHP_MM_DEMOTION_DEAD to be called after CPUHP_AP_ONLINE_DYN and
CPUHP_MM_VMSTAT_DEAD during CPU online and offline, and register the
update function on them.

Link: https://lkml.kernel.org/r/20210929060351.7293-1-ying.huang@intel.com
Fixes: 884a6e5d1f93 ("mm/migrate: update node demotion order on hotplug events")
Signed-off-by: "Huang, Ying" <ying.huang@intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
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
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/cpuhotplug.h |    4 ++++
 mm/migrate.c               |    8 +++++---
 2 files changed, 9 insertions(+), 3 deletions(-)

--- a/include/linux/cpuhotplug.h~mm-migrate-fix-cpuhp-state-to-update-node-demotion-order
+++ a/include/linux/cpuhotplug.h
@@ -72,6 +72,8 @@ enum cpuhp_state {
 	CPUHP_SLUB_DEAD,
 	CPUHP_DEBUG_OBJ_DEAD,
 	CPUHP_MM_WRITEBACK_DEAD,
+	/* Must be after CPUHP_MM_VMSTAT_DEAD */
+	CPUHP_MM_DEMOTION_DEAD,
 	CPUHP_MM_VMSTAT_DEAD,
 	CPUHP_SOFTIRQ_DEAD,
 	CPUHP_NET_MVNETA_DEAD,
@@ -240,6 +242,8 @@ enum cpuhp_state {
 	CPUHP_AP_BASE_CACHEINFO_ONLINE,
 	CPUHP_AP_ONLINE_DYN,
 	CPUHP_AP_ONLINE_DYN_END		= CPUHP_AP_ONLINE_DYN + 30,
+	/* Must be after CPUHP_AP_ONLINE_DYN for node_states[N_CPU] update */
+	CPUHP_AP_MM_DEMOTION_ONLINE,
 	CPUHP_AP_X86_HPET_ONLINE,
 	CPUHP_AP_X86_KVM_CLK_ONLINE,
 	CPUHP_AP_DTPM_CPU_ONLINE,
--- a/mm/migrate.c~mm-migrate-fix-cpuhp-state-to-update-node-demotion-order
+++ a/mm/migrate.c
@@ -3288,9 +3288,8 @@ static int __init migrate_on_reclaim_ini
 {
 	int ret;
 
-	ret = cpuhp_setup_state(CPUHP_AP_ONLINE_DYN, "migrate on reclaim",
-				migration_online_cpu,
-				migration_offline_cpu);
+	ret = cpuhp_setup_state_nocalls(CPUHP_MM_DEMOTION_DEAD, "mm/demotion:offline",
+					NULL, migration_offline_cpu);
 	/*
 	 * In the unlikely case that this fails, the automatic
 	 * migration targets may become suboptimal for nodes
@@ -3298,6 +3297,9 @@ static int __init migrate_on_reclaim_ini
 	 * rare case, do not bother trying to do anything special.
 	 */
 	WARN_ON(ret < 0);
+	ret = cpuhp_setup_state(CPUHP_AP_MM_DEMOTION_ONLINE, "mm/demotion:online",
+				migration_online_cpu, NULL);
+	WARN_ON(ret < 0);
 
 	hotplug_memory_notifier(migrate_on_reclaim_callback, 100);
 	return 0;
_

Patches currently in -mm which might be from ying.huang@intel.com are


