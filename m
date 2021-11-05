Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0944C433F5
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 20:43:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DE5DC61361
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 20:43:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233650AbhKEUqT (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 5 Nov 2021 16:46:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:41214 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232810AbhKEUqP (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 5 Nov 2021 16:46:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AD9F96135E;
        Fri,  5 Nov 2021 20:43:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636145015;
        bh=S3ylJVi4Y3zA8dfZ57nqli1UzSqoSQsY+ZY63liPn/g=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=iUFsHqbw+l433P5GE87zdjzZjkg10jFVbQdKy8Qt9zrM+wt3wYvyMU3fStA/TJ3F9
         pVhsvuOQCSSR0CEIBU48KmTx9TLdz40pq/uPKEJzI5kfuSKwkWypoPGwfwT4VH52vJ
         mk9U94GqGII/1ggKnRY/1ELomBSmo9n7y2gyvF4o=
Date:   Fri, 05 Nov 2021 13:43:35 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, dave.hansen@linux.intel.com,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        shy828301@gmail.com, torvalds@linux-foundation.org,
        ying.huang@intel.com
Subject:  [patch 171/262] mm: migrate: make demotion knob depend on
 migration
Message-ID: <20211105204335.h7ZAr40SM%akpm@linux-foundation.org>
In-Reply-To: <20211105133408.cccbb98b71a77d5e8430aba1@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Yang Shi <shy828301@gmail.com>
Subject: mm: migrate: make demotion knob depend on migration

The memory demotion needs to call migrate_pages() to do the jobs.  And it
is controlled by a knob, however, the knob doesn't depend on
CONFIG_MIGRATION.  The knob could be truned on even though MIGRATION is
disabled, this will not cause any crash since migrate_pages() would just
return -ENOSYS.  But it is definitely not optimal to go through demotion
path then retry regular swap every time.

And it doesn't make too much sense to have the knob visible to the users
when !MIGRATION.  Move the related code from mempolicy.[h|c] to
migrate.[h|c].

Link: https://lkml.kernel.org/r/20211015005559.246709-1-shy828301@gmail.com
Signed-off-by: Yang Shi <shy828301@gmail.com>
Acked-by: "Huang, Ying" <ying.huang@intel.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mempolicy.h |    4 --
 include/linux/migrate.h   |    4 ++
 mm/mempolicy.c            |   61 ------------------------------------
 mm/migrate.c              |   61 ++++++++++++++++++++++++++++++++++++
 4 files changed, 65 insertions(+), 65 deletions(-)

--- a/include/linux/mempolicy.h~mm-migrate-make-demotion-knob-depend-on-migration
+++ a/include/linux/mempolicy.h
@@ -183,8 +183,6 @@ extern bool vma_migratable(struct vm_are
 extern int mpol_misplaced(struct page *, struct vm_area_struct *, unsigned long);
 extern void mpol_put_task_policy(struct task_struct *);
 
-extern bool numa_demotion_enabled;
-
 static inline bool mpol_is_preferred_many(struct mempolicy *pol)
 {
 	return  (pol->mode == MPOL_PREFERRED_MANY);
@@ -300,8 +298,6 @@ static inline nodemask_t *policy_nodemas
 	return NULL;
 }
 
-#define numa_demotion_enabled	false
-
 static inline bool mpol_is_preferred_many(struct mempolicy *pol)
 {
 	return  false;
--- a/include/linux/migrate.h~mm-migrate-make-demotion-knob-depend-on-migration
+++ a/include/linux/migrate.h
@@ -40,6 +40,8 @@ extern int migrate_huge_page_move_mappin
 				  struct page *newpage, struct page *page);
 extern int migrate_page_move_mapping(struct address_space *mapping,
 		struct page *newpage, struct page *page, int extra_count);
+
+extern bool numa_demotion_enabled;
 #else
 
 static inline void putback_movable_pages(struct list_head *l) {}
@@ -65,6 +67,8 @@ static inline int migrate_huge_page_move
 {
 	return -ENOSYS;
 }
+
+#define numa_demotion_enabled	false
 #endif /* CONFIG_MIGRATION */
 
 #ifdef CONFIG_COMPACTION
--- a/mm/mempolicy.c~mm-migrate-make-demotion-knob-depend-on-migration
+++ a/mm/mempolicy.c
@@ -3057,64 +3057,3 @@ void mpol_to_str(char *buffer, int maxle
 		p += scnprintf(p, buffer + maxlen - p, ":%*pbl",
 			       nodemask_pr_args(&nodes));
 }
-
-bool numa_demotion_enabled = false;
-
-#ifdef CONFIG_SYSFS
-static ssize_t numa_demotion_enabled_show(struct kobject *kobj,
-					  struct kobj_attribute *attr, char *buf)
-{
-	return sysfs_emit(buf, "%s\n",
-			  numa_demotion_enabled? "true" : "false");
-}
-
-static ssize_t numa_demotion_enabled_store(struct kobject *kobj,
-					   struct kobj_attribute *attr,
-					   const char *buf, size_t count)
-{
-	if (!strncmp(buf, "true", 4) || !strncmp(buf, "1", 1))
-		numa_demotion_enabled = true;
-	else if (!strncmp(buf, "false", 5) || !strncmp(buf, "0", 1))
-		numa_demotion_enabled = false;
-	else
-		return -EINVAL;
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
-
-delete_obj:
-	kobject_put(numa_kobj);
-	return err;
-}
-subsys_initcall(numa_init_sysfs);
-#endif
--- a/mm/migrate.c~mm-migrate-make-demotion-knob-depend-on-migration
+++ a/mm/migrate.c
@@ -3306,3 +3306,64 @@ static int __init migrate_on_reclaim_ini
 }
 late_initcall(migrate_on_reclaim_init);
 #endif /* CONFIG_HOTPLUG_CPU */
+
+bool numa_demotion_enabled = false;
+
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
+	if (!strncmp(buf, "true", 4) || !strncmp(buf, "1", 1))
+		numa_demotion_enabled = true;
+	else if (!strncmp(buf, "false", 5) || !strncmp(buf, "0", 1))
+		numa_demotion_enabled = false;
+	else
+		return -EINVAL;
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
+#endif
_
