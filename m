Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B1D2C433EF
	for <mm-commits@archiver.kernel.org>; Fri, 15 Oct 2021 20:16:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 17A8F61181
	for <mm-commits@archiver.kernel.org>; Fri, 15 Oct 2021 20:16:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242968AbhJOUSH (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 15 Oct 2021 16:18:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:57566 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232084AbhJOUSG (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 15 Oct 2021 16:18:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B6C2A60F48;
        Fri, 15 Oct 2021 20:15:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1634328959;
        bh=AC1Q9pWgO8h+jRpmhVzblDH10pcbHc0MWmempjzISA0=;
        h=Date:From:To:Subject:From;
        b=SfSMFr75c0siyPLU04+w/L2M3C908vwKTgc8rTVpU4FO3VvpGrCZ8N5xSnXlZGGhr
         6KKoRKXQgA9ycGd08m57yhrB3s0+cRrQ1svNfeIVH5Iv5CtzWK8UPBVrYQMHkHpj0H
         RTvakkW0glPDieoQ5HdqVM+JyOC/CDy60eBg2rXc=
Date:   Fri, 15 Oct 2021 13:15:59 -0700
From:   akpm@linux-foundation.org
To:     dave.hansen@linux.intel.com, mm-commits@vger.kernel.org,
        shy828301@gmail.com, ying.huang@intel.com
Subject:  + mm-migrate-make-demotion-knob-depend-on-migration.patch
 added to -mm tree
Message-ID: <20211015201559.V4vmk_t7f%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: migrate: make demotion knob depend on migration
has been added to the -mm tree.  Its filename is
     mm-migrate-make-demotion-knob-depend-on-migration.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-migrate-make-demotion-knob-depend-on-migration.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-migrate-make-demotion-knob-depend-on-migration.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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
@@ -184,8 +184,6 @@ extern bool vma_migratable(struct vm_are
 extern int mpol_misplaced(struct page *, struct vm_area_struct *, unsigned long);
 extern void mpol_put_task_policy(struct task_struct *);
 
-extern bool numa_demotion_enabled;
-
 static inline bool mpol_is_preferred_many(struct mempolicy *pol)
 {
 	return  (pol->mode == MPOL_PREFERRED_MANY);
@@ -301,8 +299,6 @@ static inline nodemask_t *policy_nodemas
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
@@ -2975,64 +2975,3 @@ void mpol_to_str(char *buffer, int maxle
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
+			  numa_demotion_enabled? "true" : "false");
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

Patches currently in -mm which might be from shy828301@gmail.com are

mm-migrate-make-demotion-knob-depend-on-migration.patch

