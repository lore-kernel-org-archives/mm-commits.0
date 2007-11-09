From: akpm@linux-foundation.org
Subject: + sclp_cpi_sysc-unbork.patch added to -mm tree
Date: Thu, 08 Nov 2007 20:28:20 -0800
Message-ID: <200711090428.lA94SKBB029267@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44001 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751778AbXKIE26 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 8 Nov 2007 23:28:58 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kamalesh@linux.vnet.ibm.com, cornelia.huck@de.ibm.com, greg@kroah.com


The patch titled
     sclp_cpi_sys.c: unbork
has been added to the -mm tree.  Its filename is
     sclp_cpi_sysc-unbork.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: sclp_cpi_sys.c: unbork
From: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>

On Tue, Nov 06, 2007 at 05:42:08PM +0100, Cornelia Huck wrote:
> On Tue, 6 Nov 2007 16:29:39 +0100,
> Cornelia Huck <cornelia.huck@de.ibm.com> wrote:
>
> > That's a clash between git-s390 and the recent kset cleanup.
> >
> > sclp_cpi_sys.c needs to be converted from firmware_register() to the
> > new dynamic kset allocation (kset_create_and_register()) and the
> > subsys_attributes to kobj_attributes (I may look at it later if I find
> > some time).
>
> Adapt sclp_cpi_sys.c to the dynamic kset changes.

Hi Cornelia,

Thanks, the patch fixes the build failure.

Tested-by: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Signed-off-by: Cornelia Huck <cornelia.huck@de.ibm.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/s390/char/sclp_cpi_sys.c |   58 ++++++++++++++++-------------
 1 file changed, 33 insertions(+), 25 deletions(-)

diff -puN drivers/s390/char/sclp_cpi_sys.c~sclp_cpi_sysc-unbork drivers/s390/char/sclp_cpi_sys.c
--- a/drivers/s390/char/sclp_cpi_sys.c~sclp_cpi_sysc-unbork
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
+	cpi_kset = kset_create_and_register("cpi", NULL, NULL, firmware_kset);
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

Patches currently in -mm which might be from kamalesh@linux.vnet.ibm.com are

origin.patch
rpadlpar_sysfsc-unbork.patch
sclp_cpi_sysc-unbork.patch
add-dma-engine-driver-for-freescale-mpc85xx-processors-fix.patch
