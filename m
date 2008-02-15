From: akpm@linux-foundation.org
Subject: + ncpfs-add-prototypes-to-ncp_fsh.patch added to -mm tree
Date: Fri, 15 Feb 2008 13:25:42 -0800
Message-ID: <200802152125.m1FLPgGA024737@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43343 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760523AbYBOV0X (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 15 Feb 2008 16:26:23 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: harvey.harrison@gmail.com, VANDROVE@vc.cvut.cz


The patch titled
     ncpfs: add prototypes to ncp_fs.h
has been added to the -mm tree.  Its filename is
     ncpfs-add-prototypes-to-ncp_fsh.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ncpfs: add prototypes to ncp_fs.h
From: Harvey Harrison <harvey.harrison@gmail.com>

Removes some externs from C files, noticed from the sparse warnings:
fs/ncpfs/dir.c:90:26: warning: symbol 'ncp_root_dentry_operations' was not declared. Should it be static?
fs/ncpfs/symlink.c:107:5: warning: symbol 'ncp_symlink' was not declared. Should it be static?
fs/ncpfs/symlink.c:101:39: warning: symbol 'ncp_symlink_aops' was not declared. Should it be static?

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Petr Vandrovec <VANDROVE@vc.cvut.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ncpfs/inode.c       |    6 ------
 include/linux/ncp_fs.h |    7 +++++++
 2 files changed, 7 insertions(+), 6 deletions(-)

diff -puN fs/ncpfs/inode.c~ncpfs-add-prototypes-to-ncp_fsh fs/ncpfs/inode.c
--- a/fs/ncpfs/inode.c~ncpfs-add-prototypes-to-ncp_fsh
+++ a/fs/ncpfs/inode.c
@@ -107,12 +107,6 @@ static const struct super_operations ncp
 	.show_options	= ncp_show_options,
 };
 
-extern struct dentry_operations ncp_root_dentry_operations;
-#if defined(CONFIG_NCPFS_EXTRAS) || defined(CONFIG_NCPFS_NFS_NS)
-extern const struct address_space_operations ncp_symlink_aops;
-extern int ncp_symlink(struct inode*, struct dentry*, const char*);
-#endif
-
 /*
  * Fill in the ncpfs-specific information in the inode.
  */
diff -puN include/linux/ncp_fs.h~ncpfs-add-prototypes-to-ncp_fsh include/linux/ncp_fs.h
--- a/include/linux/ncp_fs.h~ncpfs-add-prototypes-to-ncp_fsh
+++ a/include/linux/ncp_fs.h
@@ -204,6 +204,7 @@ void ncp_update_inode2(struct inode *, s
 /* linux/fs/ncpfs/dir.c */
 extern const struct inode_operations ncp_dir_inode_operations;
 extern const struct file_operations ncp_dir_operations;
+extern struct dentry_operations ncp_root_dentry_operations;
 int ncp_conn_logged_in(struct super_block *);
 int ncp_date_dos2unix(__le16 time, __le16 date);
 void ncp_date_unix2dos(int unix_date, __le16 * time, __le16 * date);
@@ -223,6 +224,12 @@ int ncp_disconnect(struct ncp_server *se
 void ncp_lock_server(struct ncp_server *server);
 void ncp_unlock_server(struct ncp_server *server);
 
+/* linux/fs/ncpfs/symlink.c */
+#if defined(CONFIG_NCPFS_EXTRAS) || defined(CONFIG_NCPFS_NFS_NS)
+extern const struct address_space_operations ncp_symlink_aops;
+int ncp_symlink(struct inode*, struct dentry*, const char*);
+#endif
+
 /* linux/fs/ncpfs/file.c */
 extern const struct inode_operations ncp_file_inode_operations;
 extern const struct file_operations ncp_file_operations;
_

Patches currently in -mm which might be from harvey.harrison@gmail.com are

origin.patch
dlm-match-signedness-between-dlm_config_info-and-cluster_set.patch
ubi-fix-sparse-errors-in-ubih.patch
x86-remove-pt_regs-arg-from-smp_thermal_interrupt.patch
remove-sparse-warning-for-mmzoneh.patch
remove-sparse-warning-for-mmzoneh-checkpatch-fixes.patch
adfs-work-around-bogus-sparse-warning.patch
debugfs-fix-sparse-warnings.patch
coda-add-static-to-functions-in-dirc.patch
befs-fix-sparse-warning-in-linuxvfsc.patch
ncpfs-add-prototypes-to-ncp_fsh.patch
ncpfs-fix-sparse-warnings-in-ioctlc.patch
ncpfs-fix-sparse-warning-in-ncpsign_kernelc.patch
jbd-sparse-warnings-in-revokec-journalc.patch
jbd2-sparse-warnings-in-revokec-journalc.patch
