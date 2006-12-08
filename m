From: akpm@osdl.org
Subject: - x86_64-change-uses-of-f_dentry.patch removed from -mm tree
Date: Fri, 08 Dec 2006 12:02:00 -0800
Message-ID: <200612082002.kB8K205u001936@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:56944 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1426229AbWLHUCC (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 15:02:02 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jsipek@cs.sunysb.edu, mm-commits@vger.kernel.org


The patch titled
     x86_64: change uses of f_{dentry, vfsmnt} to use f_path
has been removed from the -mm tree.  Its filename was
     x86_64-change-uses-of-f_dentry.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: x86_64: change uses of f_{dentry, vfsmnt} to use f_path
From: Josef "Jeff" Sipek <jsipek@cs.sunysb.edu>

Change all the uses of f_{dentry,vfsmnt} to f_path.{dentry,mnt} in the x86_64
arch code.

Signed-off-by: Josef "Jeff" Sipek <jsipek@cs.sunysb.edu>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 arch/x86_64/ia32/ia32_aout.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN arch/x86_64/ia32/ia32_aout.c~x86_64-change-uses-of-f_dentry arch/x86_64/ia32/ia32_aout.c
--- a/arch/x86_64/ia32/ia32_aout.c~x86_64-change-uses-of-f_dentry
+++ a/arch/x86_64/ia32/ia32_aout.c
@@ -272,7 +272,7 @@ static int load_aout_binary(struct linux
 	if ((N_MAGIC(ex) != ZMAGIC && N_MAGIC(ex) != OMAGIC &&
 	     N_MAGIC(ex) != QMAGIC && N_MAGIC(ex) != NMAGIC) ||
 	    N_TRSIZE(ex) || N_DRSIZE(ex) ||
-	    i_size_read(bprm->file->f_dentry->d_inode) < ex.a_text+ex.a_data+N_SYMSIZE(ex)+N_TXTOFF(ex)) {
+	    i_size_read(bprm->file->f_path.dentry->d_inode) < ex.a_text+ex.a_data+N_SYMSIZE(ex)+N_TXTOFF(ex)) {
 		return -ENOEXEC;
 	}
 
@@ -357,7 +357,7 @@ static int load_aout_binary(struct linux
 		{
 			printk(KERN_WARNING 
 			       "fd_offset is not page aligned. Please convert program: %s\n",
-			       bprm->file->f_dentry->d_name.name);
+			       bprm->file->f_path.dentry->d_name.name);
 			error_time = jiffies;
 		}
 #endif
@@ -440,7 +440,7 @@ static int load_aout_library(struct file
 	int retval;
 	struct exec ex;
 
-	inode = file->f_dentry->d_inode;
+	inode = file->f_path.dentry->d_inode;
 
 	retval = -ENOEXEC;
 	error = kernel_read(file, 0, (char *) &ex, sizeof(ex));
@@ -471,7 +471,7 @@ static int load_aout_library(struct file
 		{
 			printk(KERN_WARNING 
 			       "N_TXTOFF is not page aligned. Please convert library: %s\n",
-			       file->f_dentry->d_name.name);
+			       file->f_path.dentry->d_name.name);
 			error_time = jiffies;
 		}
 #endif
_

Patches currently in -mm which might be from jsipek@cs.sunysb.edu are

x86_64-change-uses-of-f_dentry.patch
kernel-change-uses-of-f_dentry.patch
mm-change-uses-of-f_dentryvfsmnt-to-use-f_path.patch
9p-change-uses-of-f_dentryvfsmnt-to-use-f_path.patch
affs-change-uses-of-f_dentry-vfsmnt-to-use-f_path.patch
autofs-change-uses-of-f_dentry.patch
autofs4-change-uses-of-f_dentry.patch
configfs-change-uses-of-f_dentry.patch
cifs-change-uses-of-f_dentry-vfsmnt-to-use-f_path.patch
ecryptfs-change-uses-of-f_dentry.patch
xfs-change-uses-of-f_dentryvfsmnt-to-use-f_path.patch

