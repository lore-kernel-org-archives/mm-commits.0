Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 616FFC6FA82
	for <mm-commits@archiver.kernel.org>; Tue, 27 Sep 2022 02:50:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230188AbiI0Cua (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 26 Sep 2022 22:50:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230385AbiI0Csp (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 26 Sep 2022 22:48:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60BB59F196
        for <mm-commits@vger.kernel.org>; Mon, 26 Sep 2022 19:48:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id ED3AB61459
        for <mm-commits@vger.kernel.org>; Tue, 27 Sep 2022 02:48:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C792C433D6;
        Tue, 27 Sep 2022 02:48:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664246895;
        bh=lo9kwQ9oz6SkeHvvLExaDk+Vg0jAeVvITBF2Yz9Vahk=;
        h=Date:To:From:Subject:From;
        b=vmKuAOYwWHibnmxZ1jbT1zk0f7P2ngEtPc56VRRxHXk221/pQhcofKCkgaAoEF/Rk
         pRbvnx5A5MOgm+A3P7bqcSWblJ5C/kPSwQgK4acFTjdaycKunBb4GjlcXe0b/MJUXN
         XQ5OoaFvtLXFiSGg68IKyyTVsuoKCrnK/M7TEZZ4=
Date:   Mon, 26 Sep 2022 19:48:14 -0700
To:     mm-commits@vger.kernel.org, ying.huang@intel.com,
        weixugc@google.com, tim.c.chen@intel.com, sj@kernel.org,
        shy828301@gmail.com, mhocko@kernel.org, jvgediya.oss@gmail.com,
        Jonathan.Cameron@huawei.com, hesham.almatary@huawei.com,
        hannes@cmpxchg.org, dave@stgolabs.net, dave.hansen@intel.com,
        dan.j.williams@intel.com, bharata@amd.com, apopple@nvidia.com,
        aneesh.kumar@linux.ibm.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-demotion-move-memory-demotion-related-code.patch removed from -mm tree
Message-Id: <20220927024815.4C792C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/demotion: move memory demotion related code
has been removed from the -mm tree.  Its filename was
     mm-demotion-move-memory-demotion-related-code.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
Subject: mm/demotion: move memory demotion related code
Date: Thu, 18 Aug 2022 18:40:34 +0530

This moves memory demotion related code to mm/memory-tiers.c.  No
functional change in this patch.

Link: https://lkml.kernel.org/r/20220818131042.113280-3-aneesh.kumar@linux.ibm.com
Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Reviewed-by: "Huang, Ying" <ying.huang@intel.com>
Acked-by: Wei Xu <weixugc@google.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Bharata B Rao <bharata@amd.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: Hesham Almatary <hesham.almatary@huawei.com>
Cc: Jagdish Gediya <jvgediya.oss@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Tim Chen <tim.c.chen@intel.com>
Cc: Yang Shi <shy828301@gmail.com>
Cc: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memory-tiers.h |    8 ++++
 include/linux/migrate.h      |    2 -
 mm/memory-tiers.c            |   64 +++++++++++++++++++++++++++++++++
 mm/migrate.c                 |   60 ------------------------------
 mm/vmscan.c                  |    1 
 5 files changed, 74 insertions(+), 61 deletions(-)

--- a/include/linux/memory-tiers.h~mm-demotion-move-memory-demotion-related-code
+++ a/include/linux/memory-tiers.h
@@ -15,4 +15,12 @@
  */
 #define MEMTIER_ADISTANCE_DRAM	((4 * MEMTIER_CHUNK_SIZE) + (MEMTIER_CHUNK_SIZE >> 1))
 
+#ifdef CONFIG_NUMA
+#include <linux/types.h>
+extern bool numa_demotion_enabled;
+
+#else
+
+#define numa_demotion_enabled	false
+#endif	/* CONFIG_NUMA */
 #endif  /* _LINUX_MEMORY_TIERS_H */
--- a/include/linux/migrate.h~mm-demotion-move-memory-demotion-related-code
+++ a/include/linux/migrate.h
@@ -103,7 +103,6 @@ static inline int migrate_huge_page_move
 #if defined(CONFIG_MIGRATION) && defined(CONFIG_NUMA)
 extern void set_migration_target_nodes(void);
 extern void migrate_on_reclaim_init(void);
-extern bool numa_demotion_enabled;
 extern int next_demotion_node(int node);
 #else
 static inline void set_migration_target_nodes(void) {}
@@ -112,7 +111,6 @@ static inline int next_demotion_node(int
 {
         return NUMA_NO_NODE;
 }
-#define numa_demotion_enabled  false
 #endif
 
 #ifdef CONFIG_COMPACTION
--- a/mm/memory-tiers.c~mm-demotion-move-memory-demotion-related-code
+++ a/mm/memory-tiers.c
@@ -3,6 +3,8 @@
 #include <linux/nodemask.h>
 #include <linux/slab.h>
 #include <linux/lockdep.h>
+#include <linux/sysfs.h>
+#include <linux/kobject.h>
 #include <linux/memory-tiers.h>
 
 struct memory_tier {
@@ -127,3 +129,65 @@ static int __init memory_tier_init(void)
 	return 0;
 }
 subsys_initcall(memory_tier_init);
+
+bool numa_demotion_enabled = false;
+
+#ifdef CONFIG_MIGRATION
+#ifdef CONFIG_SYSFS
+static ssize_t numa_demotion_enabled_show(struct kobject *kobj,
+					  struct kobj_attribute *attr, char *buf)
+{
+	return sysfs_emit(buf, "%s\n",
+			  numa_demotion_enabled ? "true" : "false");
+}
+
+static ssize_t numa_demotion_enabled_store(struct kobject *kobj,
+					   struct kobj_attribute *attr,
+					   const char *buf, size_t count)
+{
+	ssize_t ret;
+
+	ret = kstrtobool(buf, &numa_demotion_enabled);
+	if (ret)
+		return ret;
+
+	return count;
+}
+
+static struct kobj_attribute numa_demotion_enabled_attr =
+	__ATTR(demotion_enabled, 0644, numa_demotion_enabled_show,
+	       numa_demotion_enabled_store);
+
+static struct attribute *numa_attrs[] = {
+	&numa_demotion_enabled_attr.attr,
+	NULL,
+};
+
+static const struct attribute_group numa_attr_group = {
+	.attrs = numa_attrs,
+};
+
+static int __init numa_init_sysfs(void)
+{
+	int err;
+	struct kobject *numa_kobj;
+
+	numa_kobj = kobject_create_and_add("numa", mm_kobj);
+	if (!numa_kobj) {
+		pr_err("failed to create numa kobject\n");
+		return -ENOMEM;
+	}
+	err = sysfs_create_group(numa_kobj, &numa_attr_group);
+	if (err) {
+		pr_err("failed to register numa group\n");
+		goto delete_obj;
+	}
+	return 0;
+
+delete_obj:
+	kobject_put(numa_kobj);
+	return err;
+}
+subsys_initcall(numa_init_sysfs);
+#endif /* CONFIG_SYSFS */
+#endif
--- a/mm/migrate.c~mm-demotion-move-memory-demotion-related-code
+++ a/mm/migrate.c
@@ -2590,64 +2590,6 @@ void __init migrate_on_reclaim_init(void
 	set_migration_target_nodes();
 	cpus_read_unlock();
 }
+#endif /* CONFIG_NUMA */
 
-bool numa_demotion_enabled = false;
-
-#ifdef CONFIG_SYSFS
-static ssize_t numa_demotion_enabled_show(struct kobject *kobj,
-					  struct kobj_attribute *attr, char *buf)
-{
-	return sysfs_emit(buf, "%s\n",
-			  numa_demotion_enabled ? "true" : "false");
-}
-
-static ssize_t numa_demotion_enabled_store(struct kobject *kobj,
-					   struct kobj_attribute *attr,
-					   const char *buf, size_t count)
-{
-	ssize_t ret;
-
-	ret = kstrtobool(buf, &numa_demotion_enabled);
-	if (ret)
-		return ret;
-
-	return count;
-}
-
-static struct kobj_attribute numa_demotion_enabled_attr =
-	__ATTR(demotion_enabled, 0644, numa_demotion_enabled_show,
-	       numa_demotion_enabled_store);
-
-static struct attribute *numa_attrs[] = {
-	&numa_demotion_enabled_attr.attr,
-	NULL,
-};
-
-static const struct attribute_group numa_attr_group = {
-	.attrs = numa_attrs,
-};
-
-static int __init numa_init_sysfs(void)
-{
-	int err;
-	struct kobject *numa_kobj;
-
-	numa_kobj = kobject_create_and_add("numa", mm_kobj);
-	if (!numa_kobj) {
-		pr_err("failed to create numa kobject\n");
-		return -ENOMEM;
-	}
-	err = sysfs_create_group(numa_kobj, &numa_attr_group);
-	if (err) {
-		pr_err("failed to register numa group\n");
-		goto delete_obj;
-	}
-	return 0;
 
-delete_obj:
-	kobject_put(numa_kobj);
-	return err;
-}
-subsys_initcall(numa_init_sysfs);
-#endif /* CONFIG_SYSFS */
-#endif /* CONFIG_NUMA */
--- a/mm/vmscan.c~mm-demotion-move-memory-demotion-related-code
+++ a/mm/vmscan.c
@@ -43,6 +43,7 @@
 #include <linux/migrate.h>
 #include <linux/delayacct.h>
 #include <linux/sysctl.h>
+#include <linux/memory-tiers.h>
 #include <linux/oom.h>
 #include <linux/pagevec.h>
 #include <linux/prefetch.h>
_

Patches currently in -mm which might be from aneesh.kumar@linux.ibm.com are


