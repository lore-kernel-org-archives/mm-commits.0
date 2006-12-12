From: akpm@osdl.org
Subject: + kobject-kobject_uevent-returns-manageable-value.patch added to -mm tree
Date: Tue, 12 Dec 2006 12:56:29 -0800
Message-ID: <200612122056.kBCKuTN9015499@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:40668 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932361AbWLLU4d (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 12 Dec 2006 15:56:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: aneesh.kumar@gmail.com, greg@kroah.com, mauriciolin@gmail.com


The patch titled
     kobject: kobject_uevent() returns manageable value
has been added to the -mm tree.  Its filename is
     kobject-kobject_uevent-returns-manageable-value.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: kobject: kobject_uevent() returns manageable value
From: "Aneesh Kumar K.V" <aneesh.kumar@gmail.com>

Since kobject_uevent() function does not return an integer value to
indicate if its operation was completed with success or not, it is worth
changing it in order to report a proper status (success or error) instead
of returning void.

Cc: Mauricio Lin <mauriciolin@gmail.com>
Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@gmail.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 include/linux/kobject.h |    8 +++---
 lib/kobject_uevent.c    |   44 +++++++++++++++++++++++++-------------
 2 files changed, 34 insertions(+), 18 deletions(-)

diff -puN include/linux/kobject.h~kobject-kobject_uevent-returns-manageable-value include/linux/kobject.h
--- a/include/linux/kobject.h~kobject-kobject_uevent-returns-manageable-value
+++ a/include/linux/kobject.h
@@ -265,8 +265,8 @@ extern int __must_check subsys_create_fi
 					struct subsys_attribute *);
 
 #if defined(CONFIG_HOTPLUG)
-void kobject_uevent(struct kobject *kobj, enum kobject_action action);
-void kobject_uevent_env(struct kobject *kobj, enum kobject_action action,
+int kobject_uevent(struct kobject *kobj, enum kobject_action action);
+int kobject_uevent_env(struct kobject *kobj, enum kobject_action action,
 			char *envp[]);
 
 int add_uevent_var(char **envp, int num_envp, int *cur_index,
@@ -274,8 +274,8 @@ int add_uevent_var(char **envp, int num_
 			const char *format, ...)
 	__attribute__((format (printf, 7, 8)));
 #else
-static inline void kobject_uevent(struct kobject *kobj, enum kobject_action action) { }
-static inline void kobject_uevent_env(struct kobject *kobj,
+static inline int kobject_uevent(struct kobject *kobj, enum kobject_action action) { }
+static inline int kobject_uevent_env(struct kobject *kobj,
 				      enum kobject_action action,
 				      char *envp[])
 { }
diff -puN lib/kobject_uevent.c~kobject-kobject_uevent-returns-manageable-value lib/kobject_uevent.c
--- a/lib/kobject_uevent.c~kobject-kobject_uevent-returns-manageable-value
+++ a/lib/kobject_uevent.c
@@ -63,8 +63,11 @@ static char *action_to_string(enum kobje
  * @action: action that is happening (usually KOBJ_MOVE)
  * @kobj: struct kobject that the action is happening to
  * @envp_ext: pointer to environmental data
+ *
+ * Returns 0 if kobject_uevent() is completed with success or the
+ * corresponding error when it fails.
  */
-void kobject_uevent_env(struct kobject *kobj, enum kobject_action action,
+int kobject_uevent_env(struct kobject *kobj, enum kobject_action action,
 			char *envp_ext[])
 {
 	char **envp;
@@ -79,14 +82,16 @@ void kobject_uevent_env(struct kobject *
 	u64 seq;
 	char *seq_buff;
 	int i = 0;
-	int retval;
+	int retval = 0;
 	int j;
 
 	pr_debug("%s\n", __FUNCTION__);
 
 	action_string = action_to_string(action);
-	if (!action_string)
-		return;
+	if (!action_string) {
+		pr_debug("kobject attempted to send uevent without action_string!\n");
+		return -EINVAL;
+	}
 
 	/* search the kset we belong to */
 	top_kobj = kobj;
@@ -95,31 +100,39 @@ void kobject_uevent_env(struct kobject *
 			top_kobj = top_kobj->parent;
 		} while (!top_kobj->kset && top_kobj->parent);
 	}
-	if (!top_kobj->kset)
-		return;
+	if (!top_kobj->kset) {
+		pr_debug("kobject attempted to send uevent without kset!\n");
+		return -EINVAL;
+	}
 
 	kset = top_kobj->kset;
 	uevent_ops = kset->uevent_ops;
 
 	/*  skip the event, if the filter returns zero. */
 	if (uevent_ops && uevent_ops->filter)
-		if (!uevent_ops->filter(kset, kobj))
-			return;
+		if (!uevent_ops->filter(kset, kobj)) {
+			pr_debug("kobject filter function caused the event to drop!\n");
+			return 0;
+		}
 
 	/* environment index */
 	envp = kzalloc(NUM_ENVP * sizeof (char *), GFP_KERNEL);
 	if (!envp)
-		return;
+		return -ENOMEM;
 
 	/* environment values */
 	buffer = kmalloc(BUFFER_SIZE, GFP_KERNEL);
-	if (!buffer)
+	if (!buffer) {
+		retval = -ENOMEM;
 		goto exit;
+	}
 
 	/* complete object path */
 	devpath = kobject_get_path(kobj, GFP_KERNEL);
-	if (!devpath)
+	if (!devpath) {
+		retval = -ENOENT;
 		goto exit;
+	}
 
 	/* originating subsystem */
 	if (uevent_ops && uevent_ops->name)
@@ -204,7 +217,7 @@ exit:
 	kfree(devpath);
 	kfree(buffer);
 	kfree(envp);
-	return;
+	return retval;
 }
 
 EXPORT_SYMBOL_GPL(kobject_uevent_env);
@@ -214,10 +227,13 @@ EXPORT_SYMBOL_GPL(kobject_uevent_env);
  *
  * @action: action that is happening (usually KOBJ_ADD and KOBJ_REMOVE)
  * @kobj: struct kobject that the action is happening to
+ *
+ * Returns 0 if kobject_uevent() is completed with success or the
+ * corresponding error when it fails.
  */
-void kobject_uevent(struct kobject *kobj, enum kobject_action action)
+int kobject_uevent(struct kobject *kobj, enum kobject_action action)
 {
-	kobject_uevent_env(kobj, action, NULL);
+	return kobject_uevent_env(kobj, action, NULL);
 }
 
 EXPORT_SYMBOL_GPL(kobject_uevent);
_

Patches currently in -mm which might be from aneesh.kumar@gmail.com are

kobject-kobject_uevent-returns-manageable-value.patch

