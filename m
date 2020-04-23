From: akpm@linux-foundation.org
Subject: [merged]
 proc-add-option-to-mount-only-a-pids-subset.patch removed from -mm tree
Date: Thu, 23 Apr 2020 12:52:17 -0700
Message-ID: <20200423195217.16lQtsQC-%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:56120 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726121AbgDWTwT (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 23 Apr 2020 15:52:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@gmail.com, akinobu.mita@gmail.com, bfields@fieldses.org, corbet@lwn.net, danielmicay@gmail.com, dhowells@redhat.com, ebiederm@xmission.com, gladkov.alexey@gmail.com, gregkh@linuxfoundation.org, jlayton@poochiereds.net, keescook@chromium.org, ldv@altlinux.org, luto@kernel.org, mingo@kernel.org, mm-commits@vger.kernel.org, oleg@redhat.com, tixxdz@gmail.com, viro@zeniv.linux.org.uk


The patch titled
     Subject: proc: add option to mount only a pids subset
has been removed from the -mm tree.  Its filename was
     proc-add-option-to-mount-only-a-pids-subset.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Alexey Gladkov <gladkov.alexey@gmail.com>
Subject: proc: add option to mount only a pids subset

This allows to hide all files and directories in the procfs that are not
related to tasks.

Link: http://lkml.kernel.org/r/20200419141057.621356-5-gladkov.alexey@gmail.com
Signed-off-by: Alexey Gladkov <gladkov.alexey@gmail.com>
Reviewed-by: Alexey Dobriyan <adobriyan@gmail.com>
Reviewed-by: Kees Cook <keescook@chromium.org>
Cc: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Daniel Micay <danielmicay@gmail.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Djalal Harouni <tixxdz@gmail.com>
Cc: "Dmitry V . Levin" <ldv@altlinux.org>
Cc: "Eric W . Biederman" <ebiederm@xmission.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: "J . Bruce Fields" <bfields@fieldses.org>
Cc: Jeff Layton <jlayton@poochiereds.net>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/generic.c       |    9 +++++++++
 fs/proc/inode.c         |    6 ++++++
 fs/proc/root.c          |   33 +++++++++++++++++++++++++++++++++
 include/linux/proc_fs.h |    7 +++++++
 4 files changed, 55 insertions(+)

--- a/fs/proc/generic.c~proc-add-option-to-mount-only-a-pids-subset
+++ a/fs/proc/generic.c
@@ -269,6 +269,11 @@ struct dentry *proc_lookup_de(struct ino
 struct dentry *proc_lookup(struct inode *dir, struct dentry *dentry,
 		unsigned int flags)
 {
+	struct proc_fs_info *fs_info = proc_sb_info(dir->i_sb);
+
+	if (fs_info->pidonly == PROC_PIDONLY_ON)
+		return ERR_PTR(-ENOENT);
+
 	return proc_lookup_de(dir, dentry, PDE(dir));
 }
 
@@ -325,6 +330,10 @@ int proc_readdir_de(struct file *file, s
 int proc_readdir(struct file *file, struct dir_context *ctx)
 {
 	struct inode *inode = file_inode(file);
+	struct proc_fs_info *fs_info = proc_sb_info(inode->i_sb);
+
+	if (fs_info->pidonly == PROC_PIDONLY_ON)
+		return 1;
 
 	return proc_readdir_de(file, ctx, PDE(inode));
 }
--- a/fs/proc/inode.c~proc-add-option-to-mount-only-a-pids-subset
+++ a/fs/proc/inode.c
@@ -173,6 +173,8 @@ static int proc_show_options(struct seq_
 		seq_printf(seq, ",gid=%u", from_kgid_munged(&init_user_ns, fs_info->pid_gid));
 	if (fs_info->hide_pid != HIDEPID_OFF)
 		seq_printf(seq, ",hidepid=%u", fs_info->hide_pid);
+	if (fs_info->pidonly != PROC_PIDONLY_OFF)
+		seq_printf(seq, ",subset=pid");
 
 	return 0;
 }
@@ -463,6 +465,7 @@ proc_reg_get_unmapped_area(struct file *
 
 static int proc_reg_open(struct inode *inode, struct file *file)
 {
+	struct proc_fs_info *fs_info = proc_sb_info(inode->i_sb);
 	struct proc_dir_entry *pde = PDE(inode);
 	int rv = 0;
 	typeof_member(struct proc_ops, proc_open) open;
@@ -476,6 +479,9 @@ static int proc_reg_open(struct inode *i
 		return rv;
 	}
 
+	if (fs_info->pidonly == PROC_PIDONLY_ON)
+		return -ENOENT;
+
 	/*
 	 * Ensure that
 	 * 1) PDE's ->release hook will be called no matter what
--- a/fs/proc/root.c~proc-add-option-to-mount-only-a-pids-subset
+++ a/fs/proc/root.c
@@ -34,16 +34,19 @@ struct proc_fs_context {
 	unsigned int		mask;
 	int			hidepid;
 	int			gid;
+	int			pidonly;
 };
 
 enum proc_param {
 	Opt_gid,
 	Opt_hidepid,
+	Opt_subset,
 };
 
 static const struct fs_parameter_spec proc_fs_parameters[] = {
 	fsparam_u32("gid",	Opt_gid),
 	fsparam_u32("hidepid",	Opt_hidepid),
+	fsparam_string("subset",	Opt_subset),
 	{}
 };
 
@@ -55,6 +58,29 @@ static inline int valid_hidepid(unsigned
 		value == HIDEPID_NOT_PTRACEABLE);
 }
 
+static int proc_parse_subset_param(struct fs_context *fc, char *value)
+{
+	struct proc_fs_context *ctx = fc->fs_private;
+
+	while (value) {
+		char *ptr = strchr(value, ',');
+
+		if (ptr != NULL)
+			*ptr++ = '\0';
+
+		if (*value != '\0') {
+			if (!strcmp(value, "pid")) {
+				ctx->pidonly = PROC_PIDONLY_ON;
+			} else {
+				return invalf(fc, "proc: unsupported subset option - %s\n", value);
+			}
+		}
+		value = ptr;
+	}
+
+	return 0;
+}
+
 static int proc_parse_param(struct fs_context *fc, struct fs_parameter *param)
 {
 	struct proc_fs_context *ctx = fc->fs_private;
@@ -76,6 +102,11 @@ static int proc_parse_param(struct fs_co
 		ctx->hidepid = result.uint_32;
 		break;
 
+	case Opt_subset:
+		if (proc_parse_subset_param(fc, param->string) < 0)
+			return -EINVAL;
+		break;
+
 	default:
 		return -EINVAL;
 	}
@@ -94,6 +125,8 @@ static void proc_apply_options(struct pr
 		fs_info->pid_gid = make_kgid(user_ns, ctx->gid);
 	if (ctx->mask & (1 << Opt_hidepid))
 		fs_info->hide_pid = ctx->hidepid;
+	if (ctx->mask & (1 << Opt_subset))
+		fs_info->pidonly = ctx->pidonly;
 }
 
 static int proc_fill_super(struct super_block *s, struct fs_context *fc)
--- a/include/linux/proc_fs.h~proc-add-option-to-mount-only-a-pids-subset
+++ a/include/linux/proc_fs.h
@@ -50,12 +50,19 @@ enum {
 	HIDEPID_NOT_PTRACEABLE = 4, /* Limit pids to only ptraceable pids */
 };
 
+/* definitions for proc mount option pidonly */
+enum {
+	PROC_PIDONLY_OFF = 0,
+	PROC_PIDONLY_ON  = 1,
+};
+
 struct proc_fs_info {
 	struct pid_namespace *pid_ns;
 	struct dentry *proc_self;        /* For /proc/self */
 	struct dentry *proc_thread_self; /* For /proc/thread-self */
 	kgid_t pid_gid;
 	int hide_pid;
+	int pidonly;
 };
 
 static inline struct proc_fs_info *proc_sb_info(struct super_block *sb)
_

Patches currently in -mm which might be from gladkov.alexey@gmail.com are
