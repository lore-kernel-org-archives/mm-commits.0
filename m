From: akpm@linux-foundation.org
Subject: [merged] fs-configs-itemc-kernel-doc-fixes-clean-up.patch removed from -mm tree
Date: Thu, 05 Jun 2014 12:42:26 -0700
Message-ID: <5390c822.TYeHsTDPvqkxnneC%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55551 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752325AbaFETm1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Jun 2014 15:42:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, jlbec@evilplan.org, fabf@skynet.be

Subject: [merged] fs-configs-itemc-kernel-doc-fixes-clean-up.patch removed from -mm tree
To: fabf@skynet.be,jlbec@evilplan.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 05 Jun 2014 12:42:26 -0700


The patch titled
     Subject: fs/configs/item.c: kernel-doc fixes + clean-up
has been removed from the -mm tree.  Its filename was
     fs-configs-itemc-kernel-doc-fixes-clean-up.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Fabian Frederick <fabf@skynet.be>
Subject: fs/configs/item.c: kernel-doc fixes + clean-up

- Fix function parameter documentation

- EXPORT_SYMBOLS moved after corresponding functions

- Small coding style and checkpatch warning fixes

Signed-off-by: Fabian Frederick <fabf@skynet.be>
Acked-by: Joel Becker <jlbec@evilplan.org>
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

origin.patch
fs-ceph-replace-pr_warning-by-pr_warn.patch
fs-ceph-debugfsc-replace-seq_printf-by-seq_puts.patch
fs-cifs-remove-obsolete-__constant.patch
kernel-posix-timersc-code-clean-up.patch
kernel-posix-timersc-code-clean-up-checkpatch-fixes.patch
fs-ext4-fsyncc-generic_file_fsync-call-based-on-barrier-flag.patch
fs-befs-linuxvfsc-replace-strncpy-by-strlcpy.patch
fs-befs-btreec-replace-strncpy-by-strlcpy-coding-style-fixing.patch
fs-befs-linuxvfsc-remove-positive-test-on-sector_t.patch
fs-befs-kernel-doc-fixes.patch
fs-isofs-logging-clean-up.patch
fs-coda-replace-printk-by-pr_foo.patch
fs-coda-logging-prefix-uniformization.patch
fs-coda-use-__func__.patch
fs-hfsplus-bnodec-replace-min-casting-by-min_t.patch
fs-hfsplus-optionsc-replace-seq_printf-by-seq_puts.patch
fs-hfsplus-wrapperc-replace-min-casting-by-min_t.patch
fs-hfsplus-wrapperc-replace-shift-loop-by-ilog2.patch
fs-hfsplus-fix-pr_foo-and-hfs_dbg-formats.patch
fs-ufs-ballocc-remove-err-parameter-in-ufs_add_fragments.patch
fs-hpfs-convert-printk-to-pr_foo.patch
fs-hpfs-use-pr_fmt-for-logging.patch
fs-hpfs-use-__func__-for-logging.patch
fs-hpfs-increase-pr_warn-level.patch
documentation-filesystems-seq_filetxt-create_proc_entry-deprecated.patch
fs-proc-task_mmuc-replace-seq_printf-by-seq_puts.patch
fs-proc-vmcorec-remove-null-assignment-on-static.patch
kernel-kexecc-convert-printk-to-pr_foo.patch
kernel-user_namespacec-kernel-doc-checkpatch-fixes.patch
fs-affs-filec-remove-unnecessary-function-parameters.patch
fs-affs-convert-printk-to-pr_foo.patch
fs-affs-pr_debug-cleanup.patch
kernel-profilec-convert-printk-to-pr_foo.patch
kernel-profilec-use-static-const-char-instead-of-static-char.patch
fs-pstore-logging-clean-up.patch
fs-pstore-logging-clean-up-fix.patch
fs-cachefiles-convert-printk-to-pr_foo.patch
fs-cachefiles-replace-kerror-by-pr_err.patch
fs-devpts-inodec-convert-printk-to-pr_foo.patch
fs-devpts-inodec-convert-printk-to-pr_foo-fix.patch
kernel-seccompc-kernel-doc-warning-fix.patch
linux-next.patch
kernel-watchdogc-convert-printk-pr_warning-to-pr_foo.patch
init-mainc-code-clean-up.patch
fs-reiserfs-bitmapc-coding-style-fixes.patch
fs-reiserfs-streec-remove-obsolete-__constant.patch
kernel-kprobesc-convert-printk-to-pr_foo.patch
fs-dlm-configc-convert-simple_str-to-kstr.patch
fs-dlm-lockspacec-convert-simple_str-to-kstr.patch
fs-dlm-debug_fsc-replace-seq_printf-by-seq_puts.patch
mm-kmemleak-testc-use-pr_fmt-for-logging.patch
ufs-sb-mutex-merge-mutex_destroy.patch

