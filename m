From: akpm@linux-foundation.org
Subject: [to-be-updated] fs-hardlink-creation-restrictions.patch removed from -mm tree
Date: Wed, 20 Jun 2012 13:50:50 -0700
Message-ID: <20120620205050.A1869A00B0@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f202.google.com ([209.85.161.202]:52576 "EHLO
	mail-gg0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752792Ab2FTUuv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 20 Jun 2012 16:50:51 -0400
Received: by ggeh3 with SMTP id h3so755801gge.1
        for <mm-commits@vger.kernel.org>; Wed, 20 Jun 2012 13:50:51 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: keescook@chromium.org, a.p.zijlstra@chello.nl, drosenberg@vsecurity.com, eparis@redhat.com, federica.teodori@googlemail.com, lucian.grijincu@gmail.com, matthew@wil.cx, mingo@elte.hu, rdunlap@xenotime.net, riel@redhat.com, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: fs: hardlink creation restrictions
has been removed from the -mm tree.  Its filename was
     fs-hardlink-creation-restrictions.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Kees Cook <keescook@chromium.org>
Subject: fs: hardlink creation restrictions

On systems that have user-writable directories on the same partition as
system files, a long-standing class of security issues is the
hardlink-based time-of-check-time-of-use race, most commonly seen in
world-writable directories like /tmp.  The common method of exploitation
of this flaw is to cross privilege boundaries when following a given
hardlink (i.e.  a root process follows a hardlink created by another
user).  Additionally, an issue exists where users can "pin" a potentially
vulnerable setuid/setgid file so that an administrator will not actually
upgrade a system fully.

The solution is to permit hardlinks to only be created when the user is
already the existing file's owner, or if they already have read/write
access to the existing file.

Many Linux users are surprised when they learn they can link to files they
have no access to, so this change appears to follow the doctrine of "least
surprise".  Additionally, this change does not violate POSIX, which states
"the implementation may require that the calling process has permission to
access the existing file"[1].

This change is known to break some implementations of the "at" daemon,
though the version used by Fedora and Ubuntu has been fixed[2] for a
while.  Otherwise, the change has been undisruptive while in use in Ubuntu
for the last 1.5 years.

This patch is based on the patch in Openwall and grsecurity.  I have added
a sysctl to enable the protected behavior, documentation, and an audit
notification.

[1] http://pubs.opengroup.org/onlinepubs/9699919799/functions/linkat.html
[2] http://anonscm.debian.org/gitweb/?p=collab-maint/at.git;a=commitdiff;h=f4114656c3a6c6f6070e315ffdf940a49eda3279

[akpm@linux-foundation.org: uninline may_linkat() and audit_log_link_denied()]
Signed-off-by: Kees Cook <keescook@chromium.org>
Acked-by: Ingo Molnar <mingo@elte.hu>
Cc: Matthew Wilcox <matthew@wil.cx>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Rik van Riel <riel@redhat.com>
Cc: Federica Teodori <federica.teodori@googlemail.com>
Cc: Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Eric Paris <eparis@redhat.com>
Cc: Randy Dunlap <rdunlap@xenotime.net>
Cc: Dan Rosenberg <drosenberg@vsecurity.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/sysctl/fs.txt |   21 +++++
 fs/Kconfig                  |   56 ++++++++++----
 fs/namei.c                  |  132 +++++++++++++++++++++++++++-------
 include/linux/fs.h          |    1 
 kernel/sysctl.c             |   11 ++
 5 files changed, 178 insertions(+), 43 deletions(-)

diff -puN Documentation/sysctl/fs.txt~fs-hardlink-creation-restrictions Documentation/sysctl/fs.txt
--- a/Documentation/sysctl/fs.txt~fs-hardlink-creation-restrictions
+++ a/Documentation/sysctl/fs.txt
@@ -32,6 +32,7 @@ Currently, these files are in /proc/sys/
 - nr_open
 - overflowuid
 - overflowgid
+- protected_hardlinks
 - protected_symlinks
 - suid_dumpable
 - super-max
@@ -158,6 +159,26 @@ The default is 65534.
 
 ==============================================================
 
+protected_hardlinks:
+
+A long-standing class of security issues is the hardlink-based
+time-of-check-time-of-use race, most commonly seen in world-writable
+directories like /tmp. The common method of exploitation of this flaw
+is to cross privilege boundaries when following a given hardlink (i.e. a
+root process follows a hardlink created by another user). Additionally,
+on systems without separated partitions, this stops unauthorized users
+from "pinning" vulnerable setuid/setgid files against being upgraded by
+the administrator, or linking to special files.
+
+When set to "0", hardlink creation behavior is unrestricted.
+
+When set to "1" hardlinks cannot be created by users if they do not
+already own the source file, or do not have read/write access to it.
+
+This protection is based on the restrictions in Openwall and grsecurity.
+
+==============================================================
+
 protected_symlinks:
 
 A long-standing class of security issues is the symlink-based
diff -puN fs/Kconfig~fs-hardlink-creation-restrictions fs/Kconfig
--- a/fs/Kconfig~fs-hardlink-creation-restrictions
+++ a/fs/Kconfig
@@ -276,27 +276,29 @@ endif # NETWORK_FILESYSTEMS
 source "fs/nls/Kconfig"
 source "fs/dlm/Kconfig"
 
-config PROTECTED_SYMLINKS
-	bool "Evaluate vulnerable symlink conditions"
+config PROTECTED_LINKS
+	bool "Evaluate vulnerable link conditions"
 	default y
 	help
-	  A long-standing class of security issues is the symlink-based
+	  A long-standing class of security issues is the link-based
 	  time-of-check-time-of-use race, most commonly seen in
 	  world-writable directories like /tmp. The common method of
 	  exploitation of this flaw is to cross privilege boundaries
-	  when following a given symlink (i.e. a root process follows
-	  a malicious symlink belonging to another user).
-
-	  Enabling this adds the logic to examine these dangerous symlink
-	  conditions. Whether or not the dangerous symlink situations are
-	  allowed is controlled by PROTECTED_SYMLINKS_ENABLED.
+	  when following a given link (i.e. a root process follows
+	  a malicious symlink belonging to another user, or a hardlink
+	  created to a root-owned file).
+
+	  Enabling this adds the logic to examine these dangerous link
+	  conditions. Whether or not the dangerous link situations are
+	  allowed is controlled by PROTECTED_HARDLINKS_ENABLED and
+	  PROTECTED_SYMLINKS_ENABLED.
 
-config PROTECTED_SYMLINKS_ENABLED
-	depends on PROTECTED_SYMLINKS
+config PROTECTED_SYMLINKS
+	depends on PROTECTED_LINKS
 	bool "Disallow symlink following in sticky world-writable dirs"
 	default y
 	help
-	  Solve ToCToU symlink race vulnerablities by permitting symlinks
+	  Solve ToCToU symlink race vulnerabilities by permitting symlinks
 	  to be followed only when outside a sticky world-writable directory,
 	  or when the uid of the symlink and follower match, or when the
 	  directory and symlink owners match.
@@ -304,10 +306,34 @@ config PROTECTED_SYMLINKS_ENABLED
 	  When PROC_SYSCTL is enabled, this setting can also be controlled
 	  via /proc/sys/kernel/protected_symlinks.
 
-config PROTECTED_SYMLINKS_ENABLED_SYSCTL
-	depends on PROTECTED_SYMLINKS
+	  See Documentation/sysctl/fs.txt for details.
+
+config PROTECTED_SYMLINKS_SYSCTL
+	depends on PROTECTED_LINKS
+	int
+	default "1" if PROTECTED_SYMLINKS
+	default "0"
+
+config PROTECTED_HARDLINKS
+	depends on PROTECTED_LINKS
+	bool "Disallow hardlink creation to non-accessible files"
+	default y
+	help
+	  Solve ToCToU hardlink race vulnerabilities by permitting hardlinks
+	  to be created only when to a regular file that is owned by the user,
+	  or is readable and writable by the user. Also blocks users from
+	  "pinning" vulnerable setuid/setgid programs from being upgraded by
+	  the administrator.
+
+	  When PROC_SYSCTL is enabled, this setting can also be controlled
+	  via /proc/sys/kernel/protected_hardlinks.
+
+	  See Documentation/sysctl/fs.txt for details.
+
+config PROTECTED_HARDLINKS_SYSCTL
+	depends on PROTECTED_LINKS
 	int
-	default "1" if PROTECTED_SYMLINKS_ENABLED
+	default "1" if PROTECTED_HARDLINKS
 	default "0"
 
 endmenu
diff -puN fs/namei.c~fs-hardlink-creation-restrictions fs/namei.c
--- a/fs/namei.c~fs-hardlink-creation-restrictions
+++ a/fs/namei.c
@@ -610,16 +610,32 @@ static inline void put_link(struct namei
 	path_put(link);
 }
 
-#ifdef CONFIG_PROTECTED_SYMLINKS
+#ifdef CONFIG_PROTECTED_LINKS
 int sysctl_protected_symlinks __read_mostly =
-	CONFIG_PROTECTED_SYMLINKS_ENABLED_SYSCTL;
+	CONFIG_PROTECTED_SYMLINKS_SYSCTL;
+int sysctl_protected_hardlinks __read_mostly =
+	CONFIG_PROTECTED_HARDLINKS_SYSCTL;
+
+static void audit_log_link_denied(const char *operation, struct path *link)
+{
+	struct audit_buffer *ab;
+
+	ab = audit_log_start(current->audit_context, GFP_KERNEL, AUDIT_AVC);
+	audit_log_format(ab, "op=%s action=denied", operation);
+	audit_log_format(ab, " pid=%d comm=", current->pid);
+	audit_log_untrustedstring(ab, current->comm);
+	audit_log_d_path(ab, " path=", link);
+	audit_log_format(ab, " dev=");
+	audit_log_untrustedstring(ab, link->dentry->d_inode->i_sb->s_id);
+	audit_log_format(ab, " ino=%lu", link->dentry->d_inode->i_ino);
+	audit_log_end(ab);
+}
 
 /**
  * may_follow_link - Check symlink following for unsafe situations
- * @dentry: The inode/dentry of the symlink
- * @nameidata: The path data of the symlink
+ * @link: The path of the symlink
  *
- * In the case of the protected_symlinks sysctl being enabled,
+ * In the case of the sysctl_protected_symlinks sysctl being enabled,
  * CAP_DAC_OVERRIDE needs to be specifically ignored if the symlink is
  * in a sticky world-writable directory. This is to protect privileged
  * processes from failing races against path names that may change out
@@ -630,19 +646,20 @@ int sysctl_protected_symlinks __read_mos
  *
  * Returns 0 if following the symlink is allowed, -ve on error.
  */
-static inline int
-may_follow_link(struct dentry *dentry, struct nameidata *nameidata)
+static inline int may_follow_link(struct path *link)
 {
 	int error = 0;
 	const struct inode *parent;
 	const struct inode *inode;
 	const struct cred *cred;
+	struct dentry *dentry;
 
 	if (!sysctl_protected_symlinks)
 		return 0;
 
 	/* Allowed if owner and follower match. */
 	cred = current_cred();
+	dentry = link->dentry;
 	inode = dentry->d_inode;
 	if (cred->fsuid == inode->i_uid)
 		return 0;
@@ -656,29 +673,87 @@ may_follow_link(struct dentry *dentry, s
 	}
 	spin_unlock(&dentry->d_lock);
 
-#ifdef CONFIG_AUDIT
-	if (error) {
-		struct audit_buffer *ab;
+	if (error)
+		audit_log_link_denied("follow_link", link);
 
-		ab = audit_log_start(current->audit_context,
-				     GFP_KERNEL, AUDIT_AVC);
-		audit_log_format(ab, "op=follow_link action=denied");
-		audit_log_format(ab, " pid=%d comm=", current->pid);
-		audit_log_untrustedstring(ab, current->comm);
-		audit_log_d_path(ab, " path=", &nameidata->path);
-		audit_log_format(ab, " name=");
-		audit_log_untrustedstring(ab, dentry->d_name.name);
-		audit_log_format(ab, " dev=");
-		audit_log_untrustedstring(ab, inode->i_sb->s_id);
-		audit_log_format(ab, " ino=%lu", inode->i_ino);
-		audit_log_end(ab);
-	}
-#endif
 	return error;
 }
+
+/**
+ * safe_hardlink_source - Check for safe hardlink conditions
+ * @inode: the source inode to hardlink from
+ *
+ * Return false if at least one of the following conditions:
+ *    - inode is not a regular file
+ *    - inode is setuid
+ *    - inode is setgid and group-exec
+ *    - access failure for read and write
+ *
+ * Otherwise returns true.
+ */
+static bool safe_hardlink_source(struct inode *inode)
+{
+	mode_t mode = inode->i_mode;
+
+	/* Special files should not get pinned to the filesystem. */
+	if (!S_ISREG(mode))
+		return false;
+
+	/* Setuid files should not get pinned to the filesystem. */
+	if (mode & S_ISUID)
+		return false;
+
+	/* Executable setgid files should not get pinned to the filesystem. */
+	if ((mode & (S_ISGID | S_IXGRP)) == (S_ISGID | S_IXGRP))
+		return false;
+
+	/* Hardlinking to unreadable or unwritable sources is dangerous. */
+	if (inode_permission(inode, MAY_READ | MAY_WRITE))
+		return false;
+
+	return true;
+}
+
+/**
+ * may_linkat - Check permissions for creating a hardlink
+ * @link: the source to hardlink from
+ *
+ * Block hardlink when all of:
+ *  - sysctl_protected_hardlinks enabled
+ *  - fsuid does not match inode
+ *  - hardlink source is unsafe (see safe_hardlink_source() above)
+ *  - not CAP_FOWNER
+ *
+ * Returns 0 if successful, -ve on error.
+ */
+static int may_linkat(struct path *link)
+{
+	const struct cred *cred;
+	struct inode *inode;
+
+	if (!sysctl_protected_hardlinks)
+		return 0;
+
+	cred = current_cred();
+	inode = link->dentry->d_inode;
+
+	/* Source inode owner (or CAP_FOWNER) can hardlink all they like,
+	 * otherwise, it must be a safe source.
+	 */
+	if (cred->fsuid == inode->i_uid || safe_hardlink_source(inode) ||
+	    capable(CAP_FOWNER))
+		return 0;
+
+	audit_log_link_denied("linkat", link);
+	return -EPERM;
+}
 #else
-static inline int
-may_follow_link(struct dentry *dentry, struct nameidata *nameidata)
+static inline int may_follow_link(struct path *link)
+{
+	return 0;
+}
+
+static inline int may_linkat(struct path *link)
 {
 	return 0;
 }
@@ -707,7 +782,7 @@ follow_link(struct path *link, struct na
 	nd_set_link(nd, NULL);
 
 	if (sensitive)
-		error = may_follow_link(link->dentry, nd);
+		error = may_follow_link(link);
 	if (!error)
 		error = security_inode_follow_link(link->dentry, nd);
 	if (error) {
@@ -3209,6 +3284,9 @@ SYSCALL_DEFINE5(linkat, int, olddfd, con
 	error = -EXDEV;
 	if (old_path.mnt != new_path.mnt)
 		goto out_dput;
+	error = may_linkat(&old_path);
+	if (error)
+		goto out_dput;
 	error = mnt_want_write(new_path.mnt);
 	if (error)
 		goto out_dput;
diff -puN include/linux/fs.h~fs-hardlink-creation-restrictions include/linux/fs.h
--- a/include/linux/fs.h~fs-hardlink-creation-restrictions
+++ a/include/linux/fs.h
@@ -438,6 +438,7 @@ extern int sysctl_nr_open;
 extern struct inodes_stat_t inodes_stat;
 extern int leases_enable, lease_break_time;
 extern int sysctl_protected_symlinks;
+extern int sysctl_protected_hardlinks;
 
 struct buffer_head;
 typedef int (get_block_t)(struct inode *inode, sector_t iblock,
diff -puN kernel/sysctl.c~fs-hardlink-creation-restrictions kernel/sysctl.c
--- a/kernel/sysctl.c~fs-hardlink-creation-restrictions
+++ a/kernel/sysctl.c
@@ -1493,7 +1493,7 @@ static struct ctl_table fs_table[] = {
 	},
 #endif
 #endif
-#ifdef CONFIG_PROTECTED_SYMLINKS
+#ifdef CONFIG_PROTECTED_LINKS
 	{
 		.procname	= "protected_symlinks",
 		.data		= &sysctl_protected_symlinks,
@@ -1503,6 +1503,15 @@ static struct ctl_table fs_table[] = {
 		.extra1		= &zero,
 		.extra2		= &one,
 	},
+	{
+		.procname	= "protected_hardlinks",
+		.data		= &sysctl_protected_hardlinks,
+		.maxlen		= sizeof(int),
+		.mode		= 0600,
+		.proc_handler	= proc_dointvec_minmax,
+		.extra1		= &zero,
+		.extra2		= &one,
+	},
 #endif
 	{
 		.procname	= "suid_dumpable",
_

Patches currently in -mm which might be from keescook@chromium.org are

linux-next.patch
c-r-prctl-move-pr_get_tid_address-to-a-proper-place.patch

