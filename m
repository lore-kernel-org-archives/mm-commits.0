Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76231C433EF
	for <mm-commits@archiver.kernel.org>; Thu, 30 Sep 2021 22:37:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5C12E61A51
	for <mm-commits@archiver.kernel.org>; Thu, 30 Sep 2021 22:37:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240574AbhI3WjU (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 30 Sep 2021 18:39:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:41716 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229759AbhI3WjU (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 30 Sep 2021 18:39:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D2F9461882;
        Thu, 30 Sep 2021 22:37:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1633041457;
        bh=NnF9DroFTDITyBc/BzCKIOxlQKvmJ0hv4SkSyvrmS28=;
        h=Date:From:To:Subject:From;
        b=pOoytRTWmc0eSjq2GiTOtWtud299ni4rQeYJNY1fV05ujYlD34vcrTNpUrLxdwy8q
         DUDp6CNrwrbfp1H/5zJduMrqxgJqaxMgFXRtDNCdcW6ZBwi1zi23zvmM0YSgvq1x8y
         33ETZ3ElFk0/h7x4PE5lnyhw5Wg+a18UZc7qYMNY=
Date:   Thu, 30 Sep 2021 15:37:36 -0700
From:   akpm@linux-foundation.org
To:     dan.j.williams@intel.com, dave.hansen@linux.intel.com,
        david@redhat.com, gthelen@google.com, kbusch@kernel.org,
        mhocko@suse.com, mm-commits@vger.kernel.org, osalvador@suse.de,
        rientjes@google.com, shy828301@gmail.com, tglx@linutronix.de,
        weixugc@google.com, ying.huang@intel.com, ziy@nvidia.com
Subject:  +
 mm-migrate-fix-cpuhp-state-to-update-node-demotion-order.patch added to -mm
 tree
Message-ID: <20210930223736.pIKngk3hC%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/migrate: fix CPUHP state to update node demotion order
has been added to the -mm tree.  Its filename is
     mm-migrate-fix-cpuhp-state-to-update-node-demotion-order.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-migrate-fix-cpuhp-state-to-update-node-demotion-order.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-migrate-fix-cpuhp-state-to-update-node-demotion-order.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -3291,9 +3291,8 @@ static int __init migrate_on_reclaim_ini
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
@@ -3301,6 +3300,9 @@ static int __init migrate_on_reclaim_ini
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

mm-migrate-fix-cpuhp-state-to-update-node-demotion-order.patch

