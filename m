From: akpm@linux-foundation.org
Subject: [folded] fs-symlink-restrictions-on-sticky-directories-fix-2.patch removed from -mm tree
Date: Wed, 28 Mar 2012 15:13:45 -0700
Message-ID: <20120328221346.0DC4EA00AE@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ey0-f202.google.com ([209.85.215.202]:48565 "EHLO
	mail-ey0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758714Ab2C1WNs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 28 Mar 2012 18:13:48 -0400
Received: by eaaq10 with SMTP id q10so74375eaa.1
        for <mm-commits@vger.kernel.org>; Wed, 28 Mar 2012 15:13:47 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: keescook@chromium.org, mm-commits@vger.kernel.org


The patch titled
     Subject: fs-symlink-restrictions-on-sticky-directories-fix-2
has been removed from the -mm tree.  Its filename was
     fs-symlink-restrictions-on-sticky-directories-fix-2.patch

This patch was dropped because it was folded into fs-symlink-restrictions-on-sticky-directories.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Kees Cook <keescook@chromium.org>
Subject: fs-symlink-restrictions-on-sticky-directories-fix-2

s/sticky_//

Cc: Kees Cook <keescook@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/sysctl/fs.txt |    4 ++--
 fs/Kconfig                  |   16 ++++++++--------
 fs/namei.c                  |   10 +++++-----
 include/linux/fs.h          |    2 +-
 kernel/sysctl.c             |    6 +++---
 5 files changed, 19 insertions(+), 19 deletions(-)

diff -puN Documentation/sysctl/fs.txt~fs-symlink-restrictions-on-sticky-directories-fix-2 Documentation/sysctl/fs.txt
--- a/Documentation/sysctl/fs.txt~fs-symlink-restrictions-on-sticky-directories-fix-2
+++ a/Documentation/sysctl/fs.txt
@@ -32,7 +32,7 @@ Currently, these files are in /proc/sys/
 - nr_open
 - overflowuid
 - overflowgid
-- protected_sticky_symlinks
+- protected_symlinks
 - suid_dumpable
 - super-max
 - super-nr
@@ -158,7 +158,7 @@ The default is 65534.
 
 ==============================================================
 
-protected_sticky_symlinks:
+protected_symlinks:
 
 A long-standing class of security issues is the symlink-based
 time-of-check-time-of-use race, most commonly seen in world-writable
diff -puN fs/Kconfig~fs-symlink-restrictions-on-sticky-directories-fix-2 fs/Kconfig
--- a/fs/Kconfig~fs-symlink-restrictions-on-sticky-directories-fix-2
+++ a/fs/Kconfig
@@ -276,7 +276,7 @@ endif # NETWORK_FILESYSTEMS
 source "fs/nls/Kconfig"
 source "fs/dlm/Kconfig"
 
-config PROTECTED_STICKY_SYMLINKS
+config PROTECTED_SYMLINKS
 	bool "Evaluate vulnerable symlink conditions"
 	default y
 	help
@@ -289,10 +289,10 @@ config PROTECTED_STICKY_SYMLINKS
 
 	  Enabling this adds the logic to examine these dangerous symlink
 	  conditions. Whether or not the dangerous symlink situations are
-	  allowed is controlled by PROTECTED_STICKY_SYMLINKS_ENABLED.
+	  allowed is controlled by PROTECTED_SYMLINKS_ENABLED.
 
-config PROTECTED_STICKY_SYMLINKS_ENABLED
-	depends on PROTECTED_STICKY_SYMLINKS
+config PROTECTED_SYMLINKS_ENABLED
+	depends on PROTECTED_SYMLINKS
 	bool "Disallow symlink following in sticky world-writable dirs"
 	default y
 	help
@@ -302,12 +302,12 @@ config PROTECTED_STICKY_SYMLINKS_ENABLED
 	  directory and symlink owners match.
 
 	  When PROC_SYSCTL is enabled, this setting can also be controlled
-	  via /proc/sys/kernel/protected_sticky_symlinks.
+	  via /proc/sys/kernel/protected_symlinks.
 
-config PROTECTED_STICKY_SYMLINKS_ENABLED_SYSCTL
-	depends on PROTECTED_STICKY_SYMLINKS
+config PROTECTED_SYMLINKS_ENABLED_SYSCTL
+	depends on PROTECTED_SYMLINKS
 	int
-	default "1" if PROTECTED_STICKY_SYMLINKS_ENABLED
+	default "1" if PROTECTED_SYMLINKS_ENABLED
 	default "0"
 
 endmenu
diff -puN fs/namei.c~fs-symlink-restrictions-on-sticky-directories-fix-2 fs/namei.c
--- a/fs/namei.c~fs-symlink-restrictions-on-sticky-directories-fix-2
+++ a/fs/namei.c
@@ -623,16 +623,16 @@ static inline void put_link(struct namei
 	path_put(link);
 }
 
-#ifdef CONFIG_PROTECTED_STICKY_SYMLINKS
-int sysctl_protected_sticky_symlinks __read_mostly =
-	CONFIG_PROTECTED_STICKY_SYMLINKS_ENABLED_SYSCTL;
+#ifdef CONFIG_PROTECTED_SYMLINKS
+int sysctl_protected_symlinks __read_mostly =
+	CONFIG_PROTECTED_SYMLINKS_ENABLED_SYSCTL;
 
 /**
  * may_follow_link - Check symlink following for unsafe situations
  * @dentry: The inode/dentry of the symlink
  * @nameidata: The path data of the symlink
  *
- * In the case of the protected_sticky_symlinks sysctl being enabled,
+ * In the case of the protected_symlinks sysctl being enabled,
  * CAP_DAC_OVERRIDE needs to be specifically ignored if the symlink is
  * in a sticky world-writable directory. This is to protect privileged
  * processes from failing races against path names that may change out
@@ -651,7 +651,7 @@ may_follow_link(struct dentry *dentry, s
 	const struct inode *inode;
 	const struct cred *cred;
 
-	if (!sysctl_protected_sticky_symlinks)
+	if (!sysctl_protected_symlinks)
 		return 0;
 
 	/* Allowed if owner and follower match. */
diff -puN include/linux/fs.h~fs-symlink-restrictions-on-sticky-directories-fix-2 include/linux/fs.h
--- a/include/linux/fs.h~fs-symlink-restrictions-on-sticky-directories-fix-2
+++ a/include/linux/fs.h
@@ -427,7 +427,7 @@ extern unsigned long get_max_files(void)
 extern int sysctl_nr_open;
 extern struct inodes_stat_t inodes_stat;
 extern int leases_enable, lease_break_time;
-extern int sysctl_protected_sticky_symlinks;
+extern int sysctl_protected_symlinks;
 
 struct buffer_head;
 typedef int (get_block_t)(struct inode *inode, sector_t iblock,
diff -puN kernel/sysctl.c~fs-symlink-restrictions-on-sticky-directories-fix-2 kernel/sysctl.c
--- a/kernel/sysctl.c~fs-symlink-restrictions-on-sticky-directories-fix-2
+++ a/kernel/sysctl.c
@@ -1491,10 +1491,10 @@ static struct ctl_table fs_table[] = {
 	},
 #endif
 #endif
-#ifdef CONFIG_PROTECTED_STICKY_SYMLINKS
+#ifdef CONFIG_PROTECTED_SYMLINKS
 	{
-		.procname	= "protected_sticky_symlinks",
-		.data		= &sysctl_protected_sticky_symlinks,
+		.procname	= "protected_symlinks",
+		.data		= &sysctl_protected_symlinks,
 		.maxlen		= sizeof(int),
 		.mode		= 0600,
 		.proc_handler	= proc_dointvec_minmax,
_

Patches currently in -mm which might be from keescook@chromium.org are

origin.patch
linux-next.patch
fs-symlink-restrictions-on-sticky-directories.patch
fs-hardlink-creation-restrictions.patch
fs-hardlink-creation-restrictions-fix.patch
fs-hardlink-creation-restrictions-cleanup.patch
fs-proc-introduce-proc-pid-task-tid-children-entry-v9.patch
c-r-procfs-add-arg_start-end-env_start-end-and-exit_code-members-to-proc-pid-stat.patch
c-r-prctl-extend-pr_set_mm-to-set-up-more-mm_struct-entries-v2.patch
c-r-prctl-add-ability-to-set-new-mm_struct-exe_file.patch
ramoops-use-pstore-interface.patch
ramoops-use-pstore-interface-fix.patch

