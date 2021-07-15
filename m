Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 269DFC636C9
	for <mm-commits@archiver.kernel.org>; Thu, 15 Jul 2021 21:27:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 10B67613AB
	for <mm-commits@archiver.kernel.org>; Thu, 15 Jul 2021 21:27:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229603AbhGOVau (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 15 Jul 2021 17:30:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:41076 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229472AbhGOVat (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 15 Jul 2021 17:30:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F247C6128D;
        Thu, 15 Jul 2021 21:27:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1626384475;
        bh=DZx/o4ZOpCtBOkxxR0E2QTy1raW8sfsbH383zu52W/M=;
        h=Date:From:To:Subject:From;
        b=tIdejR26n6XBDzXtyJOXVf95iMnNeeIB4xTSqqjQeLwUJ1z5WKhcGOj0/vYREwek8
         WUIEugLyEcWcUFh26LH998VbGQLUDW93ciS2sLTRIhj08uw3NoJG94gGzzlmFq4t9Y
         lDJ+SwTJ5MaacJAdtED0z0mqD5QDNoi85fGMgWII=
Date:   Thu, 15 Jul 2021 14:27:54 -0700
From:   akpm@linux-foundation.org
To:     dan.j.williams@intel.com, dave.hansen@linux.intel.com,
        david@redhat.com, gthelen@google.com, kbusch@kernel.org,
        mhocko@suse.com, mm-commits@vger.kernel.org, osalvador@suse.de,
        rientjes@google.com, shy828301@gmail.com, weixugc@google.com,
        yang.shi@linux.alibaba.com, ying.huang@intel.com, ziy@nvidia.com
Subject:  +
 mm-migrate-update-node-demotion-order-on-hotplug-events.patch added to -mm
 tree
Message-ID: <20210715212754.r8ToEoQRD%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/migrate: update node demotion order on hotplug events
has been added to the -mm tree.  Its filename is
     mm-migrate-update-node-demotion-order-on-hotplug-events.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-migrate-update-node-demotion-order-on-hotplug-events.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-migrate-update-node-demotion-order-on-hotplug-events.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Dave Hansen <dave.hansen@linux.intel.com>
Subject: mm/migrate: update node demotion order on hotplug events

Reclaim-based migration is attempting to optimize data placement in memory
based on the system topology.  If the system changes, so must the
migration ordering.

The implementation is conceptually simple and entirely unoptimized.  On
any memory or CPU hotplug events, assume that a node was added or removed
and recalculate all migration targets.  This ensures that the
node_demotion[] array is always ready to be used in case the new reclaim
mode is enabled.

This recalculation is far from optimal, most glaringly that it does not
even attempt to figure out the hotplug event would have some *actual*
effect on the demotion order.  But, given the expected paucity of hotplug
events, this should be fine.

Link: https://lkml.kernel.org/r/20210715055145.195411-3-ying.huang@intel.com
Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Signed-off-by: "Huang, Ying" <ying.huang@intel.com>
Reviewed-by: Yang Shi <shy828301@gmail.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Wei Xu <weixugc@google.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: David Rientjes <rientjes@google.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Greg Thelen <gthelen@google.com>
Cc: Keith Busch <kbusch@kernel.org>
Cc: Yang Shi <yang.shi@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |   90 ++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 89 insertions(+), 1 deletion(-)

--- a/mm/migrate.c~mm-migrate-update-node-demotion-order-on-hotplug-events
+++ a/mm/migrate.c
@@ -49,6 +49,7 @@
 #include <linux/sched/mm.h>
 #include <linux/ptrace.h>
 #include <linux/oom.h>
+#include <linux/memory.h>
 
 #include <asm/tlbflush.h>
 
@@ -3057,6 +3058,7 @@ void migrate_vma_finalize(struct migrate
 EXPORT_SYMBOL(migrate_vma_finalize);
 #endif /* CONFIG_DEVICE_PRIVATE */
 
+#if defined(CONFIG_MEMORY_HOTPLUG)
 /* Disable reclaim-based migration. */
 static void __disable_all_migrate_targets(void)
 {
@@ -3191,10 +3193,96 @@ again:
 /*
  * For callers that do not hold get_online_mems() already.
  */
-__maybe_unused // <- temporay to prevent warnings during bisects
 static void set_migration_target_nodes(void)
 {
 	get_online_mems();
 	__set_migration_target_nodes();
 	put_online_mems();
 }
+
+/*
+ * React to hotplug events that might affect the migration targets
+ * like events that online or offline NUMA nodes.
+ *
+ * The ordering is also currently dependent on which nodes have
+ * CPUs.  That means we need CPU on/offline notification too.
+ */
+static int migration_online_cpu(unsigned int cpu)
+{
+	set_migration_target_nodes();
+	return 0;
+}
+
+static int migration_offline_cpu(unsigned int cpu)
+{
+	set_migration_target_nodes();
+	return 0;
+}
+
+/*
+ * This leaves migrate-on-reclaim transiently disabled between
+ * the MEM_GOING_OFFLINE and MEM_OFFLINE events.  This runs
+ * whether reclaim-based migration is enabled or not, which
+ * ensures that the user can turn reclaim-based migration at
+ * any time without needing to recalculate migration targets.
+ *
+ * These callbacks already hold get_online_mems().  That is why
+ * __set_migration_target_nodes() can be used as opposed to
+ * set_migration_target_nodes().
+ */
+static int __meminit migrate_on_reclaim_callback(struct notifier_block *self,
+						 unsigned long action, void *arg)
+{
+	switch (action) {
+	case MEM_GOING_OFFLINE:
+		/*
+		 * Make sure there are not transient states where
+		 * an offline node is a migration target.  This
+		 * will leave migration disabled until the offline
+		 * completes and the MEM_OFFLINE case below runs.
+		 */
+		disable_all_migrate_targets();
+		break;
+	case MEM_OFFLINE:
+	case MEM_ONLINE:
+		/*
+		 * Recalculate the target nodes once the node
+		 * reaches its final state (online or offline).
+		 */
+		__set_migration_target_nodes();
+		break;
+	case MEM_CANCEL_OFFLINE:
+		/*
+		 * MEM_GOING_OFFLINE disabled all the migration
+		 * targets.  Reenable them.
+		 */
+		__set_migration_target_nodes();
+		break;
+	case MEM_GOING_ONLINE:
+	case MEM_CANCEL_ONLINE:
+		break;
+	}
+
+	return notifier_from_errno(0);
+}
+
+static int __init migrate_on_reclaim_init(void)
+{
+	int ret;
+
+	ret = cpuhp_setup_state(CPUHP_AP_ONLINE_DYN, "migrate on reclaim",
+				migration_online_cpu,
+				migration_offline_cpu);
+	/*
+	 * In the unlikely case that this fails, the automatic
+	 * migration targets may become suboptimal for nodes
+	 * where N_CPU changes.  With such a small impact in a
+	 * rare case, do not bother trying to do anything special.
+	 */
+	WARN_ON(ret < 0);
+
+	hotplug_memory_notifier(migrate_on_reclaim_callback, 100);
+	return 0;
+}
+late_initcall(migrate_on_reclaim_init);
+#endif /* CONFIG_MEMORY_HOTPLUG */
_

Patches currently in -mm which might be from dave.hansen@linux.intel.com are

mm-numa-automatically-generate-node-migration-order.patch
mm-migrate-update-node-demotion-order-on-hotplug-events.patch
mm-migrate-demote-pages-during-reclaim.patch
mm-vmscan-add-helper-for-querying-ability-to-age-anonymous-pages.patch
mm-vmscan-never-demote-for-memcg-reclaim.patch
mm-mempolicy-add-mpol_preferred_many-for-multiple-preferred-nodes.patch

