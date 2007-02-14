From: akpm@linux-foundation.org
Subject: - sysctl-reimplement-the-sysctl-proc-support-fix-3.patch removed from -mm tree
Date: Tue, 13 Feb 2007 22:59:26 -0800
Message-ID: <200702140659.l1E6xQi2023854@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:44037 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932168AbXBNHCj (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 14 Feb 2007 02:02:39 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@stusta.de, ebiederm@xmission.com, mm-commits@vger.kernel.org


The patch titled
     fs/proc/: make code static
has been removed from the -mm tree.  Its filename was
     sysctl-reimplement-the-sysctl-proc-support-fix-3.patch

This patch was dropped because it was folded into sysctl-reimplement-the-sysctl-proc-support.patch

------------------------------------------------------
Subject: fs/proc/: make code static
From: Adrian Bunk <bunk@stusta.de>

proc_match() and struct proc_sys_root can now become static.

Signed-off-by: Adrian Bunk <bunk@stusta.de>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/generic.c       |    2 +-
 fs/proc/proc_sysctl.c   |    2 +-
 include/linux/proc_fs.h |    2 --
 3 files changed, 2 insertions(+), 4 deletions(-)

diff -puN fs/proc/generic.c~sysctl-reimplement-the-sysctl-proc-support-fix-3 fs/proc/generic.c
--- a/fs/proc/generic.c~sysctl-reimplement-the-sysctl-proc-support-fix-3
+++ a/fs/proc/generic.c
@@ -32,7 +32,7 @@ static loff_t proc_file_lseek(struct fil
 
 DEFINE_SPINLOCK(proc_subdir_lock);
 
-int proc_match(int len, const char *name, struct proc_dir_entry *de)
+static int proc_match(int len, const char *name, struct proc_dir_entry *de)
 {
 	if (de->namelen != len)
 		return 0;
diff -puN fs/proc/proc_sysctl.c~sysctl-reimplement-the-sysctl-proc-support-fix-3 fs/proc/proc_sysctl.c
--- a/fs/proc/proc_sysctl.c~sysctl-reimplement-the-sysctl-proc-support-fix-3
+++ a/fs/proc/proc_sysctl.c
@@ -466,7 +466,7 @@ static struct dentry_operations proc_sys
 	.d_revalidate	= proc_sys_revalidate,
 };
 
-struct proc_dir_entry *proc_sys_root;
+static struct proc_dir_entry *proc_sys_root;
 
 int proc_sys_init(void)
 {
diff -puN include/linux/proc_fs.h~sysctl-reimplement-the-sysctl-proc-support-fix-3 include/linux/proc_fs.h
--- a/include/linux/proc_fs.h~sysctl-reimplement-the-sysctl-proc-support-fix-3
+++ a/include/linux/proc_fs.h
@@ -130,8 +130,6 @@ extern struct vfsmount *proc_mnt;
 extern int proc_fill_super(struct super_block *,void *,int);
 extern struct inode *proc_get_inode(struct super_block *, unsigned int, struct proc_dir_entry *);
 
-extern int proc_match(int, const char *,struct proc_dir_entry *);
-
 /*
  * These are generic /proc routines that use the internal
  * "struct proc_dir_entry" tree to traverse the filesystem.
_

Patches currently in -mm which might be from bunk@stusta.de are

origin.patch
sysctl-reimplement-the-sysctl-proc-support.patch
sysctl-reimplement-the-sysctl-proc-support-fix-3.patch
i386-enable-4k-stacks-by-default.patch
mutex-subsystem-synchro-test-module.patch
