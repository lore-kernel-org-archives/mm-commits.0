From: akpm@linux-foundation.org
Subject: + procfs-parse-mount-options.patch added to -mm tree
Date: Mon, 21 Nov 2011 16:34:16 -0800
Message-ID: <201111220034.pAM0YHCC015781@wpaz9.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vx0-f202.google.com ([209.85.220.202]:47870 "EHLO
	mail-vx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752701Ab1KVAeX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 21 Nov 2011 19:34:23 -0500
Received: by vcbfo14 with SMTP id fo14so383775vcb.1
        for <mm-commits@vger.kernel.org>; Mon, 21 Nov 2011 16:34:22 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: segooon@gmail.com, adobriyan@gmail.com, alan@lxorguk.ukuu.org.uk, greg@kroah.com, hpa@zytor.com, jmorris@namei.org, oleg@redhat.com, rdunlap@xenotime.net, segoon@openwall.com, tytso@MIT.EDU, viro@zeniv.linux.org.uk


The patch titled
     Subject: procfs: parse mount options
has been added to the -mm tree.  Its filename is
     procfs-parse-mount-options.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Vasiliy Kulikov <segooon@gmail.com>
Subject: procfs: parse mount options

Add support for procfs mount options.  Actual mount options are coming in
the next patches.

Signed-off-by: Vasiliy Kulikov <segoon@openwall.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Randy Dunlap <rdunlap@xenotime.net>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Greg KH <greg@kroah.com>
Cc: Theodore Tso <tytso@MIT.EDU>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: James Morris <jmorris@namei.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/inode.c    |   10 +++++++
 fs/proc/internal.h |    1 
 fs/proc/root.c     |   55 +++++++++++++++++++++++++++++++++++++++++--
 3 files changed, 64 insertions(+), 2 deletions(-)

diff -puN fs/proc/inode.c~procfs-parse-mount-options fs/proc/inode.c
--- a/fs/proc/inode.c~procfs-parse-mount-options
+++ a/fs/proc/inode.c
@@ -7,6 +7,7 @@
 #include <linux/time.h>
 #include <linux/proc_fs.h>
 #include <linux/kernel.h>
+#include <linux/pid_namespace.h>
 #include <linux/mm.h>
 #include <linux/string.h>
 #include <linux/stat.h>
@@ -17,7 +18,9 @@
 #include <linux/init.h>
 #include <linux/module.h>
 #include <linux/sysctl.h>
+#include <linux/seq_file.h>
 #include <linux/slab.h>
+#include <linux/mount.h>
 
 #include <asm/system.h>
 #include <asm/uaccess.h>
@@ -104,12 +107,19 @@ void __init proc_init_inodecache(void)
 					     init_once);
 }
 
+static int proc_show_options(struct seq_file *seq, struct vfsmount *vfs)
+{
+	return 0;
+}
+
 static const struct super_operations proc_sops = {
 	.alloc_inode	= proc_alloc_inode,
 	.destroy_inode	= proc_destroy_inode,
 	.drop_inode	= generic_delete_inode,
 	.evict_inode	= proc_evict_inode,
 	.statfs		= simple_statfs,
+	.remount_fs	= proc_remount,
+	.show_options	= proc_show_options,
 };
 
 static void __pde_users_dec(struct proc_dir_entry *pde)
diff -puN fs/proc/internal.h~procfs-parse-mount-options fs/proc/internal.h
--- a/fs/proc/internal.h~procfs-parse-mount-options
+++ a/fs/proc/internal.h
@@ -117,6 +117,7 @@ void pde_put(struct proc_dir_entry *pde)
 
 int proc_fill_super(struct super_block *);
 struct inode *proc_get_inode(struct super_block *, struct proc_dir_entry *);
+int proc_remount(struct super_block *sb, int *flags, char *data);
 
 /*
  * These are generic /proc routines that use the internal
diff -puN fs/proc/root.c~procfs-parse-mount-options fs/proc/root.c
--- a/fs/proc/root.c~procfs-parse-mount-options
+++ a/fs/proc/root.c
@@ -18,6 +18,7 @@
 #include <linux/bitops.h>
 #include <linux/mount.h>
 #include <linux/pid_namespace.h>
+#include <linux/parser.h>
 
 #include "internal.h"
 
@@ -36,6 +37,48 @@ static int proc_set_super(struct super_b
 	return err;
 }
 
+enum {
+	Opt_err,
+};
+
+static const match_table_t tokens = {
+	{Opt_err, NULL},
+};
+
+static int proc_parse_options(char *options, struct pid_namespace *pid)
+{
+	char *p;
+	substring_t args[MAX_OPT_ARGS];
+
+	pr_debug("proc: options = %s\n", options);
+
+	if (!options)
+		return 1;
+
+	while ((p = strsep(&options, ",")) != NULL) {
+		int token;
+		if (!*p)
+			continue;
+
+		args[0].to = args[0].from = 0;
+		token = match_token(p, tokens, args);
+		switch (token) {
+		default:
+			pr_err("proc: unrecognized mount option \"%s\" "
+			       "or missing value\n", p);
+			return 0;
+		}
+	}
+
+	return 1;
+}
+
+int proc_remount(struct super_block *sb, int *flags, char *data)
+{
+	struct pid_namespace *pid = sb->s_fs_info;
+	return !proc_parse_options(data, pid);
+}
+
 static struct dentry *proc_mount(struct file_system_type *fs_type,
 	int flags, const char *dev_name, void *data)
 {
@@ -43,11 +86,15 @@ static struct dentry *proc_mount(struct 
 	struct super_block *sb;
 	struct pid_namespace *ns;
 	struct proc_inode *ei;
+	char *options;
 
-	if (flags & MS_KERNMOUNT)
+	if (flags & MS_KERNMOUNT) {
 		ns = (struct pid_namespace *)data;
-	else
+		options = NULL;
+	} else {
 		ns = current->nsproxy->pid_ns;
+		options = data;
+	}
 
 	sb = sget(fs_type, proc_test_super, proc_set_super, ns);
 	if (IS_ERR(sb))
@@ -55,6 +102,10 @@ static struct dentry *proc_mount(struct 
 
 	if (!sb->s_root) {
 		sb->s_flags = flags;
+		if (!proc_parse_options(options, ns)) {
+			deactivate_locked_super(sb);
+			return ERR_PTR(-EINVAL);
+		}
 		err = proc_fill_super(sb);
 		if (err) {
 			deactivate_locked_super(sb);
_
Subject: Subject: procfs: parse mount options

Patches currently in -mm which might be from segooon@gmail.com are

procfs-parse-mount-options.patch
procfs-add-hidepid=-and-gid=-mount-options.patch
procfs-add-documentation-for-procfs-mount-options.patch

