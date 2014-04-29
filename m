From: akpm@linux-foundation.org
Subject: + fs-configs-itemc-kernel-doc-fixes-clean-up.patch added to -mm
 tree
Date: Tue, 29 Apr 2014 16:45:42 -0700
Message-ID: <536039a6.LSsyA70KRNq1JmjT%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36656 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751828AbaD2Xpn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 29 Apr 2014 19:45:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, jlbec@evilplan.org, fabf@skynet.be

Subject: + fs-configs-itemc-kernel-doc-fixes-clean-up.patch added to -mm tree
To: fabf@skynet.be,jlbec@evilplan.org
From: akpm@linux-foundation.org
Date: Tue, 29 Apr 2014 16:45:42 -0700


The patch titled
     Subject: fs/configs/item.c: kernel-doc fixes + clean-up
has been added to the -mm tree.  Its filename is
     fs-configs-itemc-kernel-doc-fixes-clean-up.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fs-configs-itemc-kernel-doc-fixes-clean-up.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fs-configs-itemc-kernel-doc-fixes-clean-up.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Fabian Frederick <fabf@skynet.be>
Subject: fs/configs/item.c: kernel-doc fixes + clean-up

-Fix function parameter documentation

-EXPORT_SYMBOLS moved after corresponding functions

-Small coding style and checkpatch warning fixes

Signed-off-by: Fabian Frederick <fabf@skynet.be>
Cc: Joel Becker <jlbec@evilplan.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/configfs/item.c |   58 ++++++++++++++++++++-----------------------
 1 file changed, 28 insertions(+), 30 deletions(-)

diff -puN fs/configfs/item.c~fs-configs-itemc-kernel-doc-fixes-clean-up fs/configfs/item.c
--- a/fs/configfs/item.c~fs-configs-itemc-kernel-doc-fixes-clean-up
+++ a/fs/configfs/item.c
@@ -19,7 +19,7 @@
  * Boston, MA 021110-1307, USA.
  *
  * Based on kobject:
- * 	kobject is Copyright (c) 2002-2003 Patrick Mochel
+ *	kobject is Copyright (c) 2002-2003 Patrick Mochel
  *
  * configfs Copyright (C) 2005 Oracle.  All rights reserved.
  *
@@ -35,9 +35,9 @@
 #include <linux/configfs.h>
 
 
-static inline struct config_item * to_item(struct list_head * entry)
+static inline struct config_item *to_item(struct list_head *entry)
 {
-	return container_of(entry,struct config_item,ci_entry);
+	return container_of(entry, struct config_item, ci_entry);
 }
 
 /* Evil kernel */
@@ -47,34 +47,35 @@ static void config_item_release(struct k
  *	config_item_init - initialize item.
  *	@item:	item in question.
  */
-void config_item_init(struct config_item * item)
+void config_item_init(struct config_item *item)
 {
 	kref_init(&item->ci_kref);
 	INIT_LIST_HEAD(&item->ci_entry);
 }
+EXPORT_SYMBOL(config_item_init);
 
 /**
  *	config_item_set_name - Set the name of an item
  *	@item:	item.
- *	@name:	name.
+ *	@fmt:  The vsnprintf()'s format string.
  *
  *	If strlen(name) >= CONFIGFS_ITEM_NAME_LEN, then use a
  *	dynamically allocated string that @item->ci_name points to.
  *	Otherwise, use the static @item->ci_namebuf array.
  */
-int config_item_set_name(struct config_item * item, const char * fmt, ...)
+int config_item_set_name(struct config_item *item, const char *fmt, ...)
 {
 	int error = 0;
 	int limit = CONFIGFS_ITEM_NAME_LEN;
 	int need;
 	va_list args;
-	char * name;
+	char *name;
 
 	/*
 	 * First, try the static array
 	 */
-	va_start(args,fmt);
-	need = vsnprintf(item->ci_namebuf,limit,fmt,args);
+	va_start(args, fmt);
+	need = vsnprintf(item->ci_namebuf, limit, fmt, args);
 	va_end(args);
 	if (need < limit)
 		name = item->ci_namebuf;
@@ -83,13 +84,13 @@ int config_item_set_name(struct config_i
 		 * Need more space? Allocate it and try again
 		 */
 		limit = need + 1;
-		name = kmalloc(limit,GFP_KERNEL);
+		name = kmalloc(limit, GFP_KERNEL);
 		if (!name) {
 			error = -ENOMEM;
 			goto Done;
 		}
-		va_start(args,fmt);
-		need = vsnprintf(name,limit,fmt,args);
+		va_start(args, fmt);
+		need = vsnprintf(name, limit, fmt, args);
 		va_end(args);
 
 		/* Still? Give up. */
@@ -109,7 +110,6 @@ int config_item_set_name(struct config_i
  Done:
 	return error;
 }
-
 EXPORT_SYMBOL(config_item_set_name);
 
 void config_item_init_type_name(struct config_item *item,
@@ -131,20 +131,21 @@ void config_group_init_type_name(struct
 }
 EXPORT_SYMBOL(config_group_init_type_name);
 
-struct config_item * config_item_get(struct config_item * item)
+struct config_item *config_item_get(struct config_item *item)
 {
 	if (item)
 		kref_get(&item->ci_kref);
 	return item;
 }
+EXPORT_SYMBOL(config_item_get);
 
-static void config_item_cleanup(struct config_item * item)
+static void config_item_cleanup(struct config_item *item)
 {
-	struct config_item_type * t = item->ci_type;
-	struct config_group * s = item->ci_group;
-	struct config_item * parent = item->ci_parent;
+	struct config_item_type *t = item->ci_type;
+	struct config_group *s = item->ci_group;
+	struct config_item *parent = item->ci_parent;
 
-	pr_debug("config_item %s: cleaning up\n",config_item_name(item));
+	pr_debug("config_item %s: cleaning up\n", config_item_name(item));
 	if (item->ci_name != item->ci_namebuf)
 		kfree(item->ci_name);
 	item->ci_name = NULL;
@@ -167,21 +168,23 @@ static void config_item_release(struct k
  *
  *	Decrement the refcount, and if 0, call config_item_cleanup().
  */
-void config_item_put(struct config_item * item)
+void config_item_put(struct config_item *item)
 {
 	if (item)
 		kref_put(&item->ci_kref, config_item_release);
 }
+EXPORT_SYMBOL(config_item_put);
 
 /**
  *	config_group_init - initialize a group for use
- *	@k:	group
+ *	@group:	config_group
  */
 void config_group_init(struct config_group *group)
 {
 	config_item_init(&group->cg_item);
 	INIT_LIST_HEAD(&group->cg_children);
 }
+EXPORT_SYMBOL(config_group_init);
 
 /**
  *	config_group_find_item - search for item in group.
@@ -195,11 +198,11 @@ void config_group_init(struct config_gro
 struct config_item *config_group_find_item(struct config_group *group,
 					   const char *name)
 {
-	struct list_head * entry;
-	struct config_item * ret = NULL;
+	struct list_head *entry;
+	struct config_item *ret = NULL;
 
-	list_for_each(entry,&group->cg_children) {
-		struct config_item * item = to_item(entry);
+	list_for_each(entry, &group->cg_children) {
+		struct config_item *item = to_item(entry);
 		if (config_item_name(item) &&
 		    !strcmp(config_item_name(item), name)) {
 			ret = config_item_get(item);
@@ -208,9 +211,4 @@ struct config_item *config_group_find_it
 	}
 	return ret;
 }
-
-EXPORT_SYMBOL(config_item_init);
-EXPORT_SYMBOL(config_group_init);
-EXPORT_SYMBOL(config_item_get);
-EXPORT_SYMBOL(config_item_put);
 EXPORT_SYMBOL(config_group_find_item);
_

Patches currently in -mm which might be from fabf@skynet.be are

ntfs-remove-null-value-assignments.patch
fs-configs-itemc-kernel-doc-fixes-clean-up.patch
ocfs2-remove-null-assignments-on-static.patch
fs-ocfs2-superc-use-ocfs2_max_vol_label_len-and-strlcpy.patch
fs-9p-v9fsc-add-__init-to-v9fs_sysfs_init.patch
mm-slubc-convert-printk-to-pr_foo.patch
mm-slubc-convert-vnsprintf-static-to-va_format.patch
mm-memory_hotplugc-use-pfn_down.patch
mm-memblockc-use-pfn_down.patch
sys_sgetmask-sys_ssetmask-add-config_sgetmask_syscall.patch
fs-binfmt_elfc-fix-bool-assignements.patch
fs-autofs4-dev-ioctlc-add-__init-to-autofs_dev_ioctl_init.patch
fs-befs-linuxvfsc-replace-strncpy-by-strlcpy.patch
fs-befs-btreec-replace-strncpy-by-strlcpy-coding-style-fixing.patch
fs-befs-linuxvfsc-remove-positive-test-on-sector_t.patch
fs-befs-kernel-doc-fixes.patch
fs-isofs-logging-clean-up.patch
fs-ufs-ballocc-remove-err-parameter-in-ufs_add_fragments.patch
fs-reiserfs-bitmapc-coding-style-fixes.patch
fs-affs-filec-remove-unnecessary-function-parameters.patch
fs-affs-convert-printk-to-pr_foo.patch
fs-affs-pr_debug-cleanup.patch
fs-pstore-logging-clean-up.patch
fs-pstore-logging-clean-up-fix.patch
linux-next.patch
ufs-sb-mutex-merge-mutex_destroy.patch

