Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E3EEC433F5
	for <mm-commits@archiver.kernel.org>; Tue, 10 May 2022 04:12:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235987AbiEJEQp (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 10 May 2022 00:16:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235983AbiEJEPs (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 10 May 2022 00:15:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7AF3FD368
        for <mm-commits@vger.kernel.org>; Mon,  9 May 2022 21:11:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A000661740
        for <mm-commits@vger.kernel.org>; Tue, 10 May 2022 04:11:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F16E5C385C2;
        Tue, 10 May 2022 04:11:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652155895;
        bh=p6cJ+A8w/vuflIJ8veCMpRxwh7ykCAjYsBHZWko0pl8=;
        h=Date:To:From:Subject:From;
        b=IJKn9mqkcvQSTIx8SrGmvMNzuLs/m+8XoyBuFImJ70FMwil2A10ayIC3LOKt7fDU8
         KqGWskKSA4COQzXc8ZCof1+h5+ecIkuNcF6oMONdZYTou4FixoV4QYIllzQ+MogYtu
         D+kk1nhqdPFAuFX0asgysgyQPGboMQwIU50LbeD4=
Date:   Mon, 09 May 2022 21:11:34 -0700
To:     mm-commits@vger.kernel.org, ying.huang@intel.com,
        huntbag@linux.vnet.ibm.com, dave.hansen@linux.intel.com,
        baolin.wang@linux.alibaba.com, osalvador@suse.de,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-untangle-config-dependencies-for-demote-on-reclaim.patch removed from -mm tree
Message-Id: <20220510041134.F16E5C385C2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: untangle config dependencies for demote-on-reclaim
has been removed from the -mm tree.  Its filename was
     mm-untangle-config-dependencies-for-demote-on-reclaim.patch

This patch was dropped because it was merged into mm-stable

------------------------------------------------------
From: Oscar Salvador <osalvador@suse.de>
Subject: mm: untangle config dependencies for demote-on-reclaim

At the time demote-on-reclaim was introduced, it was tied to
CONFIG_HOTPLUG_CPU + CONFIG_MIGRATE, but that is not really accurate.

The only two things we need to depend on are CONFIG_NUMA + CONFIG_MIGRATE,
so clean this up.  Furthermore, we only register the hotplug memory
notifier when the system has CONFIG_MEMORY_HOTPLUG.

Link: https://lkml.kernel.org/r/20220322224016.4574-1-osalvador@suse.de
Signed-off-by: Oscar Salvador <osalvador@suse.de>
Suggested-by: "Huang, Ying" <ying.huang@intel.com>
Reviewed-by: "Huang, Ying" <ying.huang@intel.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Abhishek Goel <huntbag@linux.vnet.ibm.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/migrate.h |   34 +++++++++++++++-------------------
 mm/migrate.c            |   11 ++++++-----
 mm/vmstat.c             |    2 --
 3 files changed, 21 insertions(+), 26 deletions(-)

--- a/include/linux/migrate.h~mm-untangle-config-dependencies-for-demote-on-reclaim
+++ a/include/linux/migrate.h
@@ -47,17 +47,8 @@ void folio_migrate_copy(struct folio *ne
 int folio_migrate_mapping(struct address_space *mapping,
 		struct folio *newfolio, struct folio *folio, int extra_count);
 
-extern bool numa_demotion_enabled;
-extern void migrate_on_reclaim_init(void);
-#ifdef CONFIG_HOTPLUG_CPU
-extern void set_migration_target_nodes(void);
-#else
-static inline void set_migration_target_nodes(void) {}
-#endif
 #else
 
-static inline void set_migration_target_nodes(void) {}
-
 static inline void putback_movable_pages(struct list_head *l) {}
 static inline int migrate_pages(struct list_head *l, new_page_t new,
 		free_page_t free, unsigned long private, enum migrate_mode mode,
@@ -82,9 +73,23 @@ static inline int migrate_huge_page_move
 	return -ENOSYS;
 }
 
-#define numa_demotion_enabled	false
 #endif /* CONFIG_MIGRATION */
 
+#if defined(CONFIG_MIGRATION) && defined(CONFIG_NUMA)
+extern void set_migration_target_nodes(void);
+extern void migrate_on_reclaim_init(void);
+extern bool numa_demotion_enabled;
+extern int next_demotion_node(int node);
+#else
+static inline void set_migration_target_nodes(void) {}
+static inline void migrate_on_reclaim_init(void) {}
+static inline int next_demotion_node(int node)
+{
+        return NUMA_NO_NODE;
+}
+#define numa_demotion_enabled  false
+#endif
+
 #ifdef CONFIG_COMPACTION
 extern int PageMovable(struct page *page);
 extern void __SetPageMovable(struct page *page, struct address_space *mapping);
@@ -172,15 +177,6 @@ struct migrate_vma {
 int migrate_vma_setup(struct migrate_vma *args);
 void migrate_vma_pages(struct migrate_vma *migrate);
 void migrate_vma_finalize(struct migrate_vma *migrate);
-int next_demotion_node(int node);
-
-#else /* CONFIG_MIGRATION disabled: */
-
-static inline int next_demotion_node(int node)
-{
-	return NUMA_NO_NODE;
-}
-
 #endif /* CONFIG_MIGRATION */
 
 #endif /* _LINUX_MIGRATE_H */
--- a/mm/migrate.c~mm-untangle-config-dependencies-for-demote-on-reclaim
+++ a/mm/migrate.c
@@ -2104,7 +2104,6 @@ out:
 	return 0;
 }
 #endif /* CONFIG_NUMA_BALANCING */
-#endif /* CONFIG_NUMA */
 
 /*
  * node_demotion[] example:
@@ -2238,7 +2237,6 @@ out:
 	return target;
 }
 
-#if defined(CONFIG_HOTPLUG_CPU)
 /* Disable reclaim-based migration. */
 static void __disable_all_migrate_targets(void)
 {
@@ -2431,6 +2429,7 @@ void set_migration_target_nodes(void)
  * __set_migration_target_nodes() can be used as opposed to
  * set_migration_target_nodes().
  */
+#ifdef CONFIG_MEMORY_HOTPLUG
 static int __meminit migrate_on_reclaim_callback(struct notifier_block *self,
 						 unsigned long action, void *_arg)
 {
@@ -2476,6 +2475,7 @@ static int __meminit migrate_on_reclaim_
 
 	return notifier_from_errno(0);
 }
+#endif
 
 void __init migrate_on_reclaim_init(void)
 {
@@ -2483,8 +2483,9 @@ void __init migrate_on_reclaim_init(void
 				sizeof(struct demotion_nodes),
 				GFP_KERNEL);
 	WARN_ON(!node_demotion);
-
+#ifdef CONFIG_MEMORY_HOTPLUG
 	hotplug_memory_notifier(migrate_on_reclaim_callback, 100);
+#endif
 	/*
 	 * At this point, all numa nodes with memory/CPus have their state
 	 * properly set, so we can build the demotion order now.
@@ -2495,7 +2496,6 @@ void __init migrate_on_reclaim_init(void
 	set_migration_target_nodes();
 	cpus_read_unlock();
 }
-#endif /* CONFIG_HOTPLUG_CPU */
 
 bool numa_demotion_enabled = false;
 
@@ -2556,4 +2556,5 @@ delete_obj:
 	return err;
 }
 subsys_initcall(numa_init_sysfs);
-#endif
+#endif /* CONFIG_SYSFS */
+#endif /* CONFIG_NUMA */
--- a/mm/vmstat.c~mm-untangle-config-dependencies-for-demote-on-reclaim
+++ a/mm/vmstat.c
@@ -2111,9 +2111,7 @@ void __init init_mm_internals(void)
 
 	start_shepherd_timer();
 #endif
-#if defined(CONFIG_MIGRATION) && defined(CONFIG_HOTPLUG_CPU)
 	migrate_on_reclaim_init();
-#endif
 #ifdef CONFIG_PROC_FS
 	proc_create_seq("buddyinfo", 0444, NULL, &fragmentation_op);
 	proc_create_seq("pagetypeinfo", 0400, NULL, &pagetypeinfo_op);
_

Patches currently in -mm which might be from osalvador@suse.de are


