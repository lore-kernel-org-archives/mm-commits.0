From: akpm@linux-foundation.org
Subject: + fs-symlink-restrictions-on-sticky-directories-fix-2.patch added to -mm tree
Date: Tue, 21 Feb 2012 15:11:24 -0800
Message-ID: <20120221231125.1E54DA011D@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ww0-f74.google.com ([74.125.82.74]:58032 "EHLO
	mail-ww0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756219Ab2BUXL1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 21 Feb 2012 18:11:27 -0500
Received: by wgbds12 with SMTP id ds12so247443wgb.1
        for <mm-commits@vger.kernel.org>; Tue, 21 Feb 2012 15:11:26 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: keescook@chromium.org


The patch titled
     Subject: fs-symlink-restrictions-on-sticky-directories-fix-2
has been added to the -mm tree.  Its filename is
     fs-symlink-restrictions-on-sticky-directories-fix-2.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -271,7 +271,7 @@ endif # NETWORK_FILESYSTEMS
 source "fs/nls/Kconfig"
 source "fs/dlm/Kconfig"
 
-config PROTECTED_STICKY_SYMLINKS
+config PROTECTED_SYMLINKS
 	bool "Evaluate vulnerable symlink conditions"
 	default y
 	help
@@ -284,10 +284,10 @@ config PROTECTED_STICKY_SYMLINKS
 
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
@@ -297,12 +297,12 @@ config PROTECTED_STICKY_SYMLINKS_ENABLED
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
@@ -422,7 +422,7 @@ extern unsigned long get_max_files(void)
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
@@ -1497,10 +1497,10 @@ static struct ctl_table fs_table[] = {
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
Subject: Subject: fs-symlink-restrictions-on-sticky-directories-fix-2

Patches currently in -mm which might be from keescook@chromium.org are

linux-next.patch
fs-symlink-restrictions-on-sticky-directories-fix-2.patch
fs-hardlink-creation-restrictions.patch
fs-hardlink-creation-restrictions-fix.patch
fs-proc-introduce-proc-pid-task-tid-children-entry-v9.patch
c-r-procfs-add-arg_start-end-env_start-end-and-exit_code-members-to-proc-pid-stat.patch
c-r-prctl-extend-pr_set_mm-to-set-up-more-mm_struct-entries-v2.patch
ramoops-use-pstore-interface.patch
ramoops-use-pstore-interface-fix.patch

