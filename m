Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34CFBC433F5
	for <mm-commits@archiver.kernel.org>; Fri, 24 Sep 2021 19:42:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 11FD761107
	for <mm-commits@archiver.kernel.org>; Fri, 24 Sep 2021 19:42:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346174AbhIXTnh (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 24 Sep 2021 15:43:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:36752 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231756AbhIXTnh (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 24 Sep 2021 15:43:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C46AD60EE9;
        Fri, 24 Sep 2021 19:42:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1632512524;
        bh=d96bLsnsoJXLpaG5z8MUAwKmQEdsryeHIBxgb2xeHcA=;
        h=Date:From:To:Subject:From;
        b=kGDb9ySSp8nBUnCedRy8RVT9fpNJI7xeI7BJuzfJUOrFcwO41VCEt3hg3lHwN29j/
         uap6xEc/p6cfmvjw4ULvpDXpl4NQJ4c92zKGEmZg1/O1RtmJPqgm/rt0JoZTh8CvY1
         urXvsN1/f+uOoUYRYYVcMYnCrlLbICDWnDbX/tiA=
Date:   Fri, 24 Sep 2021 12:42:03 -0700
From:   akpm@linux-foundation.org
To:     dan.j.williams@intel.com, dave.hansen@linux.intel.com,
        david@redhat.com, gthelen@google.com, mhocko@suse.com,
        mm-commits@vger.kernel.org, osalvador@suse.de, rientjes@google.com,
        weixugc@google.com, yang.shi@linux.alibaba.com,
        ying.huang@intel.com
Subject:  + mm-migrate-add-cpu-hotplug-to-demotion-ifdef.patch
 added to -mm tree
Message-ID: <20210924194203.LmujkhbiQ%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/migrate: add CPU hotplug to demotion #ifdef
has been added to the -mm tree.  Its filename is
     mm-migrate-add-cpu-hotplug-to-demotion-ifdef.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-migrate-add-cpu-hotplug-to-demotion-ifdef.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-migrate-add-cpu-hotplug-to-demotion-ifdef.patch

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
Subject: mm/migrate: add CPU hotplug to demotion #ifdef

Once upon a time, the node demotion updates were driven solely by memory
hotplug events.  But now, there are handlers for both CPU and memory
hotplug.

However, the #ifdef around the code checks only memory hotplug.  A system
that has HOTPLUG_CPU=y but MEMORY_HOTPLUG=n would miss CPU hotplug events.

Update the #ifdef around the common code.  Add memory and CPU-specific
#ifdefs for their handlers.  These memory/CPU #ifdefs avoid unused
function warnings when their Kconfig option is off.

Link: https://lkml.kernel.org/r/20210924161255.E5FE8F7E@davehans-spike.ostc.intel.com
Fixes: 884a6e5d1f93 ("mm/migrate: update node demotion order on hotplug events")
Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Cc: "Huang, Ying" <ying.huang@intel.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Wei Xu <weixugc@google.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: David Rientjes <rientjes@google.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Greg Thelen <gthelen@google.com>
Cc: Yang Shi <yang.shi@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |   46 +++++++++++++++++++++++++---------------------
 1 file changed, 25 insertions(+), 21 deletions(-)

--- a/mm/migrate.c~mm-migrate-add-cpu-hotplug-to-demotion-ifdef
+++ a/mm/migrate.c
@@ -3066,7 +3066,7 @@ void migrate_vma_finalize(struct migrate
 EXPORT_SYMBOL(migrate_vma_finalize);
 #endif /* CONFIG_DEVICE_PRIVATE */
 
-#if defined(CONFIG_MEMORY_HOTPLUG)
+#if defined(CONFIG_MEMORY_HOTPLUG) || defined(CONFIG_HOTPLUG_CPU)
 /* Disable reclaim-based migration. */
 static void __disable_all_migrate_targets(void)
 {
@@ -3208,25 +3208,7 @@ static void set_migration_target_nodes(v
 	put_online_mems();
 }
 
-/*
- * React to hotplug events that might affect the migration targets
- * like events that online or offline NUMA nodes.
- *
- * The ordering is also currently dependent on which nodes have
- * CPUs.  That means we need CPU on/offline notification too.
- */
-static int migration_online_cpu(unsigned int cpu)
-{
-	set_migration_target_nodes();
-	return 0;
-}
-
-static int migration_offline_cpu(unsigned int cpu)
-{
-	set_migration_target_nodes();
-	return 0;
-}
-
+#if defined(CONFIG_MEMORY_HOTPLUG)
 /*
  * This leaves migrate-on-reclaim transiently disabled between
  * the MEM_GOING_OFFLINE and MEM_OFFLINE events.  This runs
@@ -3283,6 +3265,27 @@ static int __meminit migrate_on_reclaim_
 
 	return notifier_from_errno(0);
 }
+#endif /* CONFIG_MEMORY_HOTPLUG */
+
+#ifdef CONFIG_HOTPLUG_CPU
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
 
 static int __init migrate_on_reclaim_init(void)
 {
@@ -3303,4 +3306,5 @@ static int __init migrate_on_reclaim_ini
 	return 0;
 }
 late_initcall(migrate_on_reclaim_init);
-#endif /* CONFIG_MEMORY_HOTPLUG */
+#endif /* CONFIG_HOTPLUG_CPU */
+#endif /* CONFIG_MEMORY_HOTPLUG || CONFIG_HOTPLUG_CPU */
_

Patches currently in -mm which might be from dave.hansen@linux.intel.com are

mm-migrate-optimize-hotplug-time-demotion-order-updates.patch
mm-migrate-add-cpu-hotplug-to-demotion-ifdef.patch

