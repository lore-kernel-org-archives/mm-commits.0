From: akpm@linux-foundation.org
Subject: +
 ima-store-the-builtin-custom-template-definitions-in-a-list.patch added to
 -mm tree
Date: Wed, 31 Aug 2016 13:51:05 -0700
Message-ID: <57c74339.NY556Q8vU+jlKqvx%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50934 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1760110AbcHaUvG (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 31 Aug 2016 16:51:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: zohar@linux.vnet.ibm.com, andreas.steffen@strongswan.org, bauerman@linux.vnet.ibm.com, dyoung@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ima: store the builtin/custom template definitions in a list
has been added to the -mm tree.  Its filename is
     ima-store-the-builtin-custom-template-definitions-in-a-list.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ima-store-the-builtin-custom-template-definitions-in-a-list.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ima-store-the-builtin-custom-template-definitions-in-a-list.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
Subject: ima: store the builtin/custom template definitions in a list

The builtin and single custom templates are currently stored in an
array.  In preparation for being able to restore a measurement list
containing multiple builtin/custom templates, this patch stores the
builtin and custom templates as a linked list.  This will permit
defining more than one custom template per boot.

Changelog v2:
- fix lookup_template_desc() preemption imbalance (kernel test robot)

Link: http://lkml.kernel.org/r/1472596811-9596-7-git-send-email-zohar@linux.vnet.ibm.com
Signed-off-by: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: Andreas Steffen <andreas.steffen@strongswan.org>
Cc: Dave Young <dyoung@redhat.com>
Cc: Thiago Jung Bauermann <bauerman@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 security/integrity/ima/ima.h          |    2 +
 security/integrity/ima/ima_main.c     |    1 
 security/integrity/ima/ima_template.c |   43 ++++++++++++++++++------
 3 files changed, 36 insertions(+), 10 deletions(-)

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
+spinlock_t template_list;
+
 static struct ima_template_field supported_fields[] = {
 	{.field_id = "d", .field_init = ima_eventdigest_init,
 	 .field_show = ima_show_template_digest},
@@ -81,7 +85,7 @@ __setup("ima_template=", ima_template_se
 
 static int __init ima_template_fmt_setup(char *str)
 {
-	int num_templates = ARRAY_SIZE(defined_templates);
+	int num_templates = ARRAY_SIZE(builtin_templates);
 
 	if (ima_template)
 		return 1;
@@ -92,22 +96,28 @@ static int __init ima_template_fmt_setup
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
@@ -191,6 +201,19 @@ struct ima_template_desc *ima_template_d
 	return ima_template;
 }
 
+void __init ima_init_template_list(void)
+{
+	int i;
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
 int __init ima_init_template(void)
 {
 	struct ima_template_desc *template = ima_template_desc_current();
_

Patches currently in -mm which might be from zohar@linux.vnet.ibm.com are

ima-on-soft-reboot-restore-the-measurement-list.patch
ima-permit-duplicate-measurement-list-entries.patch
ima-maintain-memory-size-needed-for-serializing-the-measurement-list.patch
ima-serialize-the-binary_runtime_measurements.patch
ima-store-the-builtin-custom-template-definitions-in-a-list.patch
ima-support-restoring-multiple-template-formats.patch
ima-define-a-canonical-binary_runtime_measurements-list-format.patch

