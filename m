Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1279CC433F5
	for <mm-commits@archiver.kernel.org>; Tue, 19 Oct 2021 18:39:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E6B7C6128B
	for <mm-commits@archiver.kernel.org>; Tue, 19 Oct 2021 18:39:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234738AbhJSSlT (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 19 Oct 2021 14:41:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:52254 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234665AbhJSSlS (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 19 Oct 2021 14:41:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A26A96115B;
        Tue, 19 Oct 2021 18:39:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1634668745;
        bh=nHE5PL+ue9G9qALkpfJlkY4CSqoTslOfUiNdWmEyjMc=;
        h=Date:From:To:Subject:From;
        b=PPBE3sRqvGuEsZUvE1FJg63egpWYkqlFuvbAmfydan1rnTDA7HbRShYcOta3M51zL
         fARN1/fBmy6jEtg2c1lXtDqBh6MzUHq6OIfcVsC2ibcW3tisQsLcvX76GQNMfgM8CB
         sQYWIrV7ozDoBPAZqA3c/uBKotZMTKH1CuUgtiLE=
Date:   Tue, 19 Oct 2021 11:39:04 -0700
From:   akpm@linux-foundation.org
To:     arnd@arndb.de, dan.j.williams@intel.com,
        dave.hansen@linux.intel.com, david@redhat.com, gthelen@google.com,
        mhocko@suse.com, mm-commits@vger.kernel.org, osalvador@suse.de,
        rientjes@google.com, weixugc@google.com,
        yang.shi@linux.alibaba.com, ying.huang@intel.com
Subject:  [merged]
 mm-migrate-add-cpu-hotplug-to-demotion-ifdef.patch removed from -mm tree
Message-ID: <20211019183904.PSlDFdW_J%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/migrate: add CPU hotplug to demotion #ifdef
has been removed from the -mm tree.  Its filename was
     mm-migrate-add-cpu-hotplug-to-demotion-ifdef.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

[arnd@arndb.de: rework hotplug_memory_notifier() stub]
  Link: https://lkml.kernel.org/r/20211013144029.2154629-1-arnd@kernel.org
Link: https://lkml.kernel.org/r/20210924161255.E5FE8F7E@davehans-spike.ostc.intel.com
Fixes: 884a6e5d1f93 ("mm/migrate: update node demotion order on hotplug events")
Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
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

 include/linux/memory.h |    5 +++-
 mm/migrate.c           |   42 +++++++++++++++++++--------------------
 mm/page_ext.c          |    4 ---
 mm/slab.c              |    4 +--
 4 files changed, 28 insertions(+), 27 deletions(-)

--- a/include/linux/memory.h~mm-migrate-add-cpu-hotplug-to-demotion-ifdef
+++ a/include/linux/memory.h
@@ -160,7 +160,10 @@ int walk_dynamic_memory_groups(int nid,
 #define register_hotmemory_notifier(nb)		register_memory_notifier(nb)
 #define unregister_hotmemory_notifier(nb) 	unregister_memory_notifier(nb)
 #else
-#define hotplug_memory_notifier(fn, pri)	({ 0; })
+static inline int hotplug_memory_notifier(notifier_fn_t fn, int pri)
+{
+	return 0;
+}
 /* These aren't inline functions due to a GCC bug. */
 #define register_hotmemory_notifier(nb)    ({ (void)(nb); 0; })
 #define unregister_hotmemory_notifier(nb)  ({ (void)(nb); })
--- a/mm/migrate.c~mm-migrate-add-cpu-hotplug-to-demotion-ifdef
+++ a/mm/migrate.c
@@ -3066,7 +3066,7 @@ void migrate_vma_finalize(struct migrate
 EXPORT_SYMBOL(migrate_vma_finalize);
 #endif /* CONFIG_DEVICE_PRIVATE */
 
-#if defined(CONFIG_MEMORY_HOTPLUG)
+#if defined(CONFIG_HOTPLUG_CPU)
 /* Disable reclaim-based migration. */
 static void __disable_all_migrate_targets(void)
 {
@@ -3209,25 +3209,6 @@ static void set_migration_target_nodes(v
 }
 
 /*
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
-/*
  * This leaves migrate-on-reclaim transiently disabled between
  * the MEM_GOING_OFFLINE and MEM_OFFLINE events.  This runs
  * whether reclaim-based migration is enabled or not, which
@@ -3284,6 +3265,25 @@ static int __meminit migrate_on_reclaim_
 	return notifier_from_errno(0);
 }
 
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
 static int __init migrate_on_reclaim_init(void)
 {
 	int ret;
@@ -3303,4 +3303,4 @@ static int __init migrate_on_reclaim_ini
 	return 0;
 }
 late_initcall(migrate_on_reclaim_init);
-#endif /* CONFIG_MEMORY_HOTPLUG */
+#endif /* CONFIG_HOTPLUG_CPU */
--- a/mm/page_ext.c~mm-migrate-add-cpu-hotplug-to-demotion-ifdef
+++ a/mm/page_ext.c
@@ -269,7 +269,7 @@ static int __meminit init_section_page_e
 	total_usage += table_size;
 	return 0;
 }
-#ifdef CONFIG_MEMORY_HOTPLUG
+
 static void free_page_ext(void *addr)
 {
 	if (is_vmalloc_addr(addr)) {
@@ -374,8 +374,6 @@ static int __meminit page_ext_callback(s
 	return notifier_from_errno(ret);
 }
 
-#endif
-
 void __init page_ext_init(void)
 {
 	unsigned long pfn;
--- a/mm/slab.c~mm-migrate-add-cpu-hotplug-to-demotion-ifdef
+++ a/mm/slab.c
@@ -1095,7 +1095,7 @@ static int slab_offline_cpu(unsigned int
 	return 0;
 }
 
-#if defined(CONFIG_NUMA) && defined(CONFIG_MEMORY_HOTPLUG)
+#if defined(CONFIG_NUMA)
 /*
  * Drains freelist for a node on each slab cache, used for memory hot-remove.
  * Returns -EBUSY if all objects cannot be drained so that the node is not
@@ -1157,7 +1157,7 @@ static int __meminit slab_memory_callbac
 out:
 	return notifier_from_errno(ret);
 }
-#endif /* CONFIG_NUMA && CONFIG_MEMORY_HOTPLUG */
+#endif /* CONFIG_NUMA */
 
 /*
  * swap the static kmem_cache_node with kmalloced memory
_

Patches currently in -mm which might be from dave.hansen@linux.intel.com are


