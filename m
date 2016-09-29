From: akpm@linux-foundation.org
Subject: [to-be-updated]
 ima-store-the-builtin-custom-template-definitions-in-a-list.patch removed
 from -mm tree
Date: Thu, 29 Sep 2016 14:36:09 -0700
Message-ID: <57ed8949.MnvpMEKWuXRXcFr/%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47317 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934401AbcI2VgK (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 29 Sep 2016 17:36:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: zohar@linux.vnet.ibm.com, bhe@redhat.com, bsingharora@gmail.com, dyoung@redhat.com, ebiederm@xmission.com, erichte@linux.vnet.ibm.com, mpe@ellerman.id.au, stewart@linux.vnet.ibm.com, vgoyal@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ima: store the builtin/custom template definitions in a list
has been removed from the -mm tree.  Its filename was
     ima-store-the-builtin-custom-template-definitions-in-a-list.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
Subject: ima: store the builtin/custom template definitions in a list

The builtin and single custom templates are currently stored in an array. 
In preparation for being able to restore a measurement list containing
multiple builtin/custom templates, this patch stores the builtin and
custom templates as a linked list.  This will permit defining more than
one custom template per boot.

Link: http://lkml.kernel.org/r/1473938771-2782-7-git-send-email-zohar@linux.vnet.ibm.com
Signed-off-by: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: Eric Biederman <ebiederm@xmission.com>
Cc: Dave Young <dyoung@redhat.com>
Cc: Vivek Goyal <vgoyal@redhat.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Stewart Smith <stewart@linux.vnet.ibm.com>
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: Eric Richter <erichte@linux.vnet.ibm.com>
Cc: Balbir Singh <bsingharora@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 security/integrity/ima/ima.h          |    2 
 security/integrity/ima/ima_main.c     |    1 
 security/integrity/ima/ima_template.c |   52 ++++++++++++++++++------
 3 files changed, 44 insertions(+), 11 deletions(-)

diff -puN security/integrity/ima/ima.h~ima-store-the-builtin-custom-template-definitions-in-a-list security/integrity/ima/ima.h
--- a/security/integrity/ima/ima.h~ima-store-the-builtin-custom-template-definitions-in-a-list
+++ a/security/integrity/ima/ima.h
@@ -81,6 +81,7 @@ struct ima_template_field {
 
 /* IMA template descriptor definition */
 struct ima_template_desc {
+	struct list_head list;
 	char *name;
 	char *fmt;
 	int num_fields;
@@ -136,6 +137,7 @@ int ima_restore_measurement_list(loff_t
 int ima_measurements_show(struct seq_file *m, void *v);
 unsigned long ima_get_binary_runtime_size(void);
 int ima_init_template(void);
+void ima_init_template_list(void);
 
 #ifdef CONFIG_KEXEC_FILE
 void ima_load_kexec_buffer(void);
diff -puN security/integrity/ima/ima_main.c~ima-store-the-builtin-custom-template-definitions-in-a-list security/integrity/ima/ima_main.c
--- a/security/integrity/ima/ima_main.c~ima-store-the-builtin-custom-template-definitions-in-a-list
+++ a/security/integrity/ima/ima_main.c
@@ -418,6 +418,7 @@ static int __init init_ima(void)
 {
 	int error;
 
+	ima_init_template_list();
 	hash_setup(CONFIG_IMA_DEFAULT_HASH);
 	error = ima_init();
 	if (!error) {
diff -puN security/integrity/ima/ima_template.c~ima-store-the-builtin-custom-template-definitions-in-a-list security/integrity/ima/ima_template.c
--- a/security/integrity/ima/ima_template.c~ima-store-the-builtin-custom-template-definitions-in-a-list
+++ a/security/integrity/ima/ima_template.c
@@ -15,16 +15,20 @@
 
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
+#include <linux/rculist.h>
 #include "ima.h"
 #include "ima_template_lib.h"
 
-static struct ima_template_desc defined_templates[] = {
+static struct ima_template_desc builtin_templates[] = {
 	{.name = IMA_TEMPLATE_IMA_NAME, .fmt = IMA_TEMPLATE_IMA_FMT},
 	{.name = "ima-ng", .fmt = "d-ng|n-ng"},
 	{.name = "ima-sig", .fmt = "d-ng|n-ng|sig"},
 	{.name = "", .fmt = ""},	/* placeholder for a custom format */
 };
 
+static LIST_HEAD(defined_templates);
+static DEFINE_SPINLOCK(template_list);
+
 static struct ima_template_field supported_fields[] = {
 	{.field_id = "d", .field_init = ima_eventdigest_init,
 	 .field_show = ima_show_template_digest},
@@ -53,6 +57,8 @@ static int __init ima_template_setup(cha
 	if (ima_template)
 		return 1;
 
+	ima_init_template_list();
+
 	/*
 	 * Verify that a template with the supplied name exists.
 	 * If not, use CONFIG_IMA_DEFAULT_TEMPLATE.
@@ -81,7 +87,7 @@ __setup("ima_template=", ima_template_se
 
 static int __init ima_template_fmt_setup(char *str)
 {
-	int num_templates = ARRAY_SIZE(defined_templates);
+	int num_templates = ARRAY_SIZE(builtin_templates);
 
 	if (ima_template)
 		return 1;
@@ -92,22 +98,28 @@ static int __init ima_template_fmt_setup
 		return 1;
 	}
 
-	defined_templates[num_templates - 1].fmt = str;
-	ima_template = defined_templates + num_templates - 1;
+	builtin_templates[num_templates - 1].fmt = str;
+	ima_template = builtin_templates + num_templates - 1;
+
 	return 1;
 }
 __setup("ima_template_fmt=", ima_template_fmt_setup);
 
 static struct ima_template_desc *lookup_template_desc(const char *name)
 {
-	int i;
+	struct ima_template_desc *template_desc;
+	int found = 0;
 
-	for (i = 0; i < ARRAY_SIZE(defined_templates); i++) {
-		if (strcmp(defined_templates[i].name, name) == 0)
-			return defined_templates + i;
+	rcu_read_lock();
+	list_for_each_entry_rcu(template_desc, &defined_templates, list) {
+		if ((strcmp(template_desc->name, name) == 0) ||
+		    (strcmp(template_desc->fmt, name) == 0)) {
+			found = 1;
+			break;
+		}
 	}
-
-	return NULL;
+	rcu_read_unlock();
+	return found ? template_desc : NULL;
 }
 
 static struct ima_template_field *lookup_template_field(const char *field_id)
@@ -183,11 +195,29 @@ static int template_desc_init_fields(con
 	return 0;
 }
 
+void ima_init_template_list(void)
+{
+	int i;
+
+	if (!list_empty(&defined_templates))
+		return;
+
+	spin_lock(&template_list);
+	for (i = 0; i < ARRAY_SIZE(builtin_templates); i++) {
+		list_add_tail_rcu(&builtin_templates[i].list,
+				  &defined_templates);
+	}
+	spin_unlock(&template_list);
+	synchronize_rcu();
+}
+
 struct ima_template_desc *ima_template_desc_current(void)
 {
-	if (!ima_template)
+	if (!ima_template) {
+		ima_init_template_list();
 		ima_template =
 		    lookup_template_desc(CONFIG_IMA_DEFAULT_TEMPLATE);
+	}
 	return ima_template;
 }
 
_

Patches currently in -mm which might be from zohar@linux.vnet.ibm.com are

ima-support-restoring-multiple-template-formats.patch
ima-define-a-canonical-binary_runtime_measurements-list-format.patch

