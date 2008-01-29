From: akpm@linux-foundation.org
Subject: - adapt-sclp_cpi_sysc-to-the-kobject-kset-changes.patch removed from -mm tree
Date: Mon, 28 Jan 2008 17:49:16 -0800
Message-ID: <200801290149.m0T1nGVh027475@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50659 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755516AbYA2B5u (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Jan 2008 20:57:50 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: cornelia.huck@de.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Adapt sclp_cpi_sys.c to the kobject/kset changes
has been removed from the -mm tree.  Its filename was
     adapt-sclp_cpi_sysc-to-the-kobject-kset-changes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Adapt sclp_cpi_sys.c to the kobject/kset changes
From: Cornelia Huck <cornelia.huck@de.ibm.com>

Adapt sclp_cpi_sys.c to the kobject/kset changes.

(Regenerated from the last patch to handle the firmware_kset ->
firmware_kobj change.)

Signed-off-by: Cornelia Huck <cornelia.huck@de.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/s390/char/sclp_cpi_sys.c |   58 ++++++++++++++++-------------
 1 file changed, 33 insertions(+), 25 deletions(-)

diff -puN drivers/s390/char/sclp_cpi_sys.c~adapt-sclp_cpi_sysc-to-the-kobject-kset-changes drivers/s390/char/sclp_cpi_sys.c
--- a/drivers/s390/char/sclp_cpi_sys.c~adapt-sclp_cpi_sysc-to-the-kobject-kset-changes
+++ a/drivers/s390/char/sclp_cpi_sys.c
@@ -220,13 +220,15 @@ static void set_string(char *attr, const
 	}
 }
 
-static ssize_t system_name_show(struct kset *kset, char *page)
+static ssize_t system_name_show(struct kobject *kobj,
+				struct kobj_attribute *attr, char *page)
 {
 	return snprintf(page, PAGE_SIZE, "%s\n", system_name);
 }
 
-static ssize_t system_name_store(struct kset *kset, const char *buf,
-	size_t len)
+static ssize_t system_name_store(struct kobject *kobj,
+				 struct kobj_attribute *attr, const char *buf,
+				 size_t len)
 {
 	int rc;
 
@@ -239,16 +241,18 @@ static ssize_t system_name_store(struct 
 	return len;
 }
 
-static struct subsys_attribute system_name_attr =
+static struct kobj_attribute system_name_attr =
 	__ATTR(system_name, 0644, system_name_show, system_name_store);
 
-static ssize_t sysplex_name_show(struct kset *kset, char *page)
+static ssize_t sysplex_name_show(struct kobject *kobj,
+				 struct kobj_attribute *attr, char *page)
 {
 	return snprintf(page, PAGE_SIZE, "%s\n", sysplex_name);
 }
 
-static ssize_t sysplex_name_store(struct kset *kset, const char *buf,
-	size_t len)
+static ssize_t sysplex_name_store(struct kobject *kobj,
+				  struct kobj_attribute *attr, const char *buf,
+				  size_t len)
 {
 	int rc;
 
@@ -261,17 +265,19 @@ static ssize_t sysplex_name_store(struct
 	return len;
 }
 
-static struct subsys_attribute sysplex_name_attr =
+static struct kobj_attribute sysplex_name_attr =
 	__ATTR(sysplex_name, 0644, sysplex_name_show,
 	sysplex_name_store);
 
-static ssize_t system_type_show(struct kset *kset, char *page)
+static ssize_t system_type_show(struct kobject *kobj,
+				struct kobj_attribute *attr, char *page)
 {
 	return snprintf(page, PAGE_SIZE, "%s\n", system_type);
 }
 
-static ssize_t system_type_store(struct kset *kset, const char *buf,
-	size_t len)
+static ssize_t system_type_store(struct kobject *kobj,
+				 struct kobj_attribute *attr, const char *buf,
+				 size_t len)
 {
 	int rc;
 
@@ -284,18 +290,20 @@ static ssize_t system_type_store(struct 
 	return len;
 }
 
-static struct subsys_attribute system_type_attr =
+static struct kobj_attribute system_type_attr =
 	__ATTR(system_type, 0644, system_type_show, system_type_store);
 
-static ssize_t system_level_show(struct kset *kset, char *page)
+static ssize_t system_level_show(struct kobject *kobj,
+				 struct kobj_attribute *attr, char *page)
 {
 	unsigned long long level = system_level;
 
 	return snprintf(page, PAGE_SIZE, "%#018llx\n", level);
 }
 
-static ssize_t system_level_store(struct kset *kset, const char *buf,
-	size_t len)
+static ssize_t system_level_store(struct kobject *kobj,
+				  struct kobj_attribute *attr, const char *buf,
+				  size_t len)
 {
 	unsigned long long level;
 	char *endp;
@@ -314,12 +322,12 @@ static ssize_t system_level_store(struct
 	return len;
 }
 
-static struct subsys_attribute system_level_attr =
+static struct kobj_attribute system_level_attr =
 	__ATTR(system_level, 0644, system_level_show,
 	system_level_store);
 
-static ssize_t set_store(struct kset *kset, const char *buf,
-	size_t len)
+static ssize_t set_store(struct kobject *kobj, struct kobj_attribute *attr,
+			 const char *buf, size_t len)
 {
 	int rc;
 
@@ -330,7 +338,7 @@ static ssize_t set_store(struct kset *ks
 	return len;
 }
 
-static struct subsys_attribute set_attr =
+static struct kobj_attribute set_attr =
 	__ATTR(set, 0200, NULL, set_store);
 
 static struct attribute *cpi_attrs[] = {
@@ -346,7 +354,7 @@ static struct attribute_group cpi_attr_g
 	.attrs = cpi_attrs,
 };
 
-static decl_subsys(cpi, NULL, NULL);
+static struct kset *cpi_kset;
 
 int sclp_cpi_set_data(const char *system, const char *sysplex, const char *type,
 		      const u64 level)
@@ -376,13 +384,13 @@ static int __init cpi_init(void)
 {
 	int rc;
 
-	rc = firmware_register(&cpi_subsys);
-	if (rc)
-		return rc;
+	cpi_kset = kset_create_and_register("cpi", NULL, firmware_kobj, NULL);
+	if (IS_ERR(cpi_kset))
+		return PTR_ERR(cpi_kset);
 
-	rc = sysfs_create_group(&cpi_subsys.kobj, &cpi_attr_group);
+	rc = sysfs_create_group(&cpi_kset->kobj, &cpi_attr_group);
 	if (rc)
-		firmware_unregister(&cpi_subsys);
+		kset_unregister(cpi_kset);
 
 	return rc;
 }
_

Patches currently in -mm which might be from cornelia.huck@de.ibm.com are

origin.patch
