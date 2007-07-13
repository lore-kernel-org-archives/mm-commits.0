From: akpm@linux-foundation.org
Subject: + coda-remove-statistics-counters-from-proc-fs-coda.patch added to -mm tree
Date: Thu, 12 Jul 2007 22:29:46 -0700
Message-ID: <200707130529.l6D5Tk4e030829@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50194 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751071AbXGMFiz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 13 Jul 2007 01:38:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jaharkes@cs.cmu.edu


The patch titled
     coda: remove statistics counters from /proc/fs/coda
has been added to the -mm tree.  Its filename is
     coda-remove-statistics-counters-from-proc-fs-coda.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: coda: remove statistics counters from /proc/fs/coda
From: Jan Harkes <jaharkes@cs.cmu.edu>

Similar information can easily be obtained with strace -c.

Signed-off-by: Jan Harkes <jaharkes@cs.cmu.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/coda/coda_int.h         |    7 +
 fs/coda/dir.c              |   16 --
 fs/coda/file.c             |   10 -
 fs/coda/psdev.c            |    1 
 fs/coda/symlink.c          |    2 
 fs/coda/sysctl.c           |  228 -----------------------------------
 fs/coda/upcall.c           |    3 
 include/linux/coda_linux.h |    3 
 include/linux/coda_proc.h  |   76 -----------
 include/linux/coda_psdev.h |    2 
 10 files changed, 15 insertions(+), 333 deletions(-)

diff -puN fs/coda/coda_int.h~coda-remove-statistics-counters-from-proc-fs-coda fs/coda/coda_int.h
--- a/fs/coda/coda_int.h~coda-remove-statistics-counters-from-proc-fs-coda
+++ a/fs/coda/coda_int.h
@@ -1,12 +1,19 @@
 #ifndef _CODA_INT_
 #define _CODA_INT_
 
+struct dentry;
+
 extern struct file_system_type coda_fs_type;
+extern unsigned long coda_timeout;
+extern int coda_hard;
+extern int coda_fake_statfs;
 
 void coda_destroy_inodecache(void);
 int coda_init_inodecache(void);
 int coda_fsync(struct file *coda_file, struct dentry *coda_dentry,
 	       int datasync);
+void coda_sysctl_init(void);
+void coda_sysctl_clean(void);
 
 #endif  /*  _CODA_INT_  */
 
diff -puN fs/coda/dir.c~coda-remove-statistics-counters-from-proc-fs-coda fs/coda/dir.c
--- a/fs/coda/dir.c~coda-remove-statistics-counters-from-proc-fs-coda
+++ a/fs/coda/dir.c
@@ -25,7 +25,6 @@
 #include <linux/coda_psdev.h>
 #include <linux/coda_fs_i.h>
 #include <linux/coda_cache.h>
-#include <linux/coda_proc.h>
 
 #include "coda_int.h"
 
@@ -148,8 +147,6 @@ int coda_permission(struct inode *inode,
 
 	lock_kernel();
 
-	coda_vfs_stat.permission++;
-
 	if (coda_cache_check(inode, mask))
 		goto out; 
 
@@ -206,7 +203,6 @@ static int coda_create(struct inode *dir
 	struct coda_vattr attrs;
 
 	lock_kernel();
-	coda_vfs_stat.create++;
 
 	if (coda_isroot(dir) && coda_iscontrol(name, length)) {
 		unlock_kernel();
@@ -246,7 +242,6 @@ static int coda_mkdir(struct inode *dir,
 	struct CodaFid newfid;
 
 	lock_kernel();
-	coda_vfs_stat.mkdir++;
 
 	if (coda_isroot(dir) && coda_iscontrol(name, len)) {
 		unlock_kernel();
@@ -288,7 +283,6 @@ static int coda_link(struct dentry *sour
 	int error;
 
 	lock_kernel();
-	coda_vfs_stat.link++;
 
 	if (coda_isroot(dir_inode) && coda_iscontrol(name, len)) {
 		unlock_kernel();
@@ -320,10 +314,9 @@ static int coda_symlink(struct inode *di
         const char *name = de->d_name.name;
 	int len = de->d_name.len;
 	int symlen;
-        int error=0;
-        
+	int error = 0;
+
 	lock_kernel();
-	coda_vfs_stat.symlink++;
 
 	if (coda_isroot(dir_inode) && coda_iscontrol(name, len)) {
 		unlock_kernel();
@@ -360,7 +353,6 @@ int coda_unlink(struct inode *dir, struc
 	int len = de->d_name.len;
 
 	lock_kernel();
-	coda_vfs_stat.unlink++;
 
 	error = venus_remove(dir->i_sb, coda_i2f(dir), name, len);
 	if ( error ) {
@@ -381,7 +373,6 @@ int coda_rmdir(struct inode *dir, struct
 	int error;
 
 	lock_kernel();
-	coda_vfs_stat.rmdir++;
 
 	error = venus_rmdir(dir->i_sb, coda_i2f(dir), name, len);
 	if (!error) {
@@ -408,7 +399,6 @@ static int coda_rename(struct inode *old
 	int error;
 
 	lock_kernel();
-	coda_vfs_stat.rename++;
 
 	error = venus_rename(old_dir->i_sb, coda_i2f(old_dir),
 			     coda_i2f(new_dir), old_length, new_length,
@@ -445,8 +435,6 @@ int coda_readdir(struct file *coda_file,
 	BUG_ON(!cfi || cfi->cfi_magic != CODA_MAGIC);
 	host_file = cfi->cfi_container;
 
-	coda_vfs_stat.readdir++;
-
 	if (!host_file->f_op)
 		return -ENOTDIR;
 
diff -puN fs/coda/file.c~coda-remove-statistics-counters-from-proc-fs-coda fs/coda/file.c
--- a/fs/coda/file.c~coda-remove-statistics-counters-from-proc-fs-coda
+++ a/fs/coda/file.c
@@ -22,7 +22,6 @@
 #include <linux/coda_linux.h>
 #include <linux/coda_fs_i.h>
 #include <linux/coda_psdev.h>
-#include <linux/coda_proc.h>
 
 #include "coda_int.h"
 
@@ -134,8 +133,6 @@ int coda_open(struct inode *coda_inode, 
 	unsigned short coda_flags = coda_flags_to_cflags(flags);
 	struct coda_file_info *cfi;
 
-	coda_vfs_stat.open++;
-
 	cfi = kmalloc(sizeof(struct coda_file_info), GFP_KERNEL);
 	if (!cfi)
 		return -ENOMEM;
@@ -176,8 +173,6 @@ int coda_flush(struct file *coda_file, f
 
 	lock_kernel();
 
-	coda_vfs_stat.flush++;
-
 	/* last close semantics */
 	fcnt = file_count(coda_file);
 	if (fcnt > 1)
@@ -219,8 +214,7 @@ int coda_release(struct inode *coda_inod
 	int err = 0;
 
 	lock_kernel();
-	coda_vfs_stat.release++;
- 
+
 	if (!use_coda_close) {
 		err = venus_release(coda_inode->i_sb, coda_i2f(coda_inode),
 				    coda_flags);
@@ -271,8 +265,6 @@ int coda_fsync(struct file *coda_file, s
 	BUG_ON(!cfi || cfi->cfi_magic != CODA_MAGIC);
 	host_file = cfi->cfi_container;
 
-	coda_vfs_stat.fsync++;
-
 	if (host_file->f_op && host_file->f_op->fsync) {
 		host_dentry = host_file->f_path.dentry;
 		host_inode = host_dentry->d_inode;
diff -puN fs/coda/psdev.c~coda-remove-statistics-counters-from-proc-fs-coda fs/coda/psdev.c
--- a/fs/coda/psdev.c~coda-remove-statistics-counters-from-proc-fs-coda
+++ a/fs/coda/psdev.c
@@ -45,7 +45,6 @@
 #include <linux/coda_linux.h>
 #include <linux/coda_fs_i.h>
 #include <linux/coda_psdev.h>
-#include <linux/coda_proc.h>
 
 #include "coda_int.h"
 
diff -puN fs/coda/symlink.c~coda-remove-statistics-counters-from-proc-fs-coda fs/coda/symlink.c
--- a/fs/coda/symlink.c~coda-remove-statistics-counters-from-proc-fs-coda
+++ a/fs/coda/symlink.c
@@ -20,7 +20,6 @@
 #include <linux/coda_linux.h>
 #include <linux/coda_psdev.h>
 #include <linux/coda_fs_i.h>
-#include <linux/coda_proc.h>
 
 static int coda_symlink_filler(struct file *file, struct page *page)
 {
@@ -32,7 +31,6 @@ static int coda_symlink_filler(struct fi
 
 	lock_kernel();
 	cii = ITOC(inode);
-	coda_vfs_stat.follow_link++;
 
 	error = venus_readlink(inode->i_sb, &cii->c_fid, p, &len);
 	unlock_kernel();
diff -puN fs/coda/sysctl.c~coda-remove-statistics-counters-from-proc-fs-coda fs/coda/sysctl.c
--- a/fs/coda/sysctl.c~coda-remove-statistics-counters-from-proc-fs-coda
+++ a/fs/coda/sysctl.c
@@ -5,181 +5,14 @@
  * 
  * Carnegie Mellon encourages users to contribute improvements to
  * the Coda project. Contact Peter Braam (coda@cs.cmu.edu).
- * 
- * CODA operation statistics
- * (c) March, 1998 Zhanyong Wan <zhanyong.wan@yale.edu>
- *
  */
 
-#include <linux/time.h>
-#include <linux/mm.h>
 #include <linux/sysctl.h>
-#include <linux/proc_fs.h>
-#include <linux/seq_file.h>
-#include <linux/slab.h>
-#include <linux/stat.h>
-#include <linux/ctype.h>
-#include <linux/bitops.h>
-#include <asm/uaccess.h>
-#include <linux/utsname.h>
-#include <linux/module.h>
 
-#include <linux/coda.h>
-#include <linux/coda_linux.h>
-#include <linux/coda_fs_i.h>
-#include <linux/coda_psdev.h>
-#include <linux/coda_cache.h>
-#include <linux/coda_proc.h>
+#include "coda_int.h"
 
 static struct ctl_table_header *fs_table_header;
 
-#define CODA_TIMEOUT    3       /* timeout on upcalls to become intrble */
-#define CODA_HARD       5       /* mount type "hard" or "soft" */
-#define CODA_VFS 	 6       /* vfs statistics */
-#define CODA_CACHE_INV 	 9       /* cache invalidation statistics */
-#define CODA_FAKE_STATFS 10	 /* don't query venus for actual cache usage */
-
-struct coda_vfs_stats		coda_vfs_stat;
-static struct coda_cache_inv_stats	coda_cache_inv_stat;
-
-static void reset_coda_vfs_stats( void )
-{
-	memset( &coda_vfs_stat, 0, sizeof( coda_vfs_stat ) );
-}
-
-static void reset_coda_cache_inv_stats( void )
-{
-	memset( &coda_cache_inv_stat, 0, sizeof( coda_cache_inv_stat ) );
-}
-
-static int do_reset_coda_vfs_stats( ctl_table * table, int write,
-				    struct file * filp, void __user * buffer,
-				    size_t * lenp, loff_t * ppos )
-{
-	if ( write ) {
-		reset_coda_vfs_stats();
-
-		*ppos += *lenp;
-	} else {
-		*lenp = 0;
-	}
-
-	return 0;
-}
-
-static int do_reset_coda_cache_inv_stats( ctl_table * table, int write,
-					  struct file * filp,
-					  void __user * buffer,
-					  size_t * lenp, loff_t * ppos )
-{
-	if ( write ) {
-		reset_coda_cache_inv_stats();
-
-		*ppos += *lenp;
-	} else {
-		*lenp = 0;
-	}
-  
-	return 0;
-}
-
-static int proc_vfs_stats_show(struct seq_file *m, void *v)
-{
-	struct coda_vfs_stats * ps = & coda_vfs_stat;
-  
-	seq_printf(m,
-			"Coda VFS statistics\n"
-			"===================\n\n"
-			"File Operations:\n"
-			"\topen\t\t%9d\n"
-			"\tflush\t\t%9d\n"
-			"\trelease\t\t%9d\n"
-			"\tfsync\t\t%9d\n\n"
-			"Dir Operations:\n"
-			"\treaddir\t\t%9d\n\n"
-			"Inode Operations\n"
-			"\tcreate\t\t%9d\n"
-			"\tlookup\t\t%9d\n"
-			"\tlink\t\t%9d\n"
-			"\tunlink\t\t%9d\n"
-			"\tsymlink\t\t%9d\n"
-			"\tmkdir\t\t%9d\n"
-			"\trmdir\t\t%9d\n"
-			"\trename\t\t%9d\n"
-			"\tpermission\t%9d\n",
-
-			/* file operations */
-			ps->open,
-			ps->flush,
-			ps->release,
-			ps->fsync,
-
-			/* dir operations */
-			ps->readdir,
-		  
-			/* inode operations */
-			ps->create,
-			ps->lookup,
-			ps->link,
-			ps->unlink,
-			ps->symlink,
-			ps->mkdir,
-			ps->rmdir,
-			ps->rename,
-			ps->permission); 
-	return 0;
-}
-
-static int proc_cache_inv_stats_show(struct seq_file *m, void *v)
-{
-	struct coda_cache_inv_stats * ps = & coda_cache_inv_stat;
-  
-	seq_printf(m,
-			"Coda cache invalidation statistics\n"
-			"==================================\n\n"
-			"flush\t\t%9d\n"
-			"purge user\t%9d\n"
-			"zap_dir\t\t%9d\n"
-			"zap_file\t%9d\n"
-			"zap_vnode\t%9d\n"
-			"purge_fid\t%9d\n"
-			"replace\t\t%9d\n",
-			ps->flush,
-			ps->purge_user,
-			ps->zap_dir,
-			ps->zap_file,
-			ps->zap_vnode,
-			ps->purge_fid,
-			ps->replace );
-	return 0;
-}
-
-static int proc_vfs_stats_open(struct inode *inode, struct file *file)
-{
-	return single_open(file, proc_vfs_stats_show, NULL);
-}
-
-static int proc_cache_inv_stats_open(struct inode *inode, struct file *file)
-{
-	return single_open(file, proc_cache_inv_stats_show, NULL);
-}
-
-static const struct file_operations proc_vfs_stats_fops = {
-	.owner		= THIS_MODULE,
-	.open		= proc_vfs_stats_open,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-	.release	= single_release,
-};
-
-static const struct file_operations proc_cache_inv_stats_fops = {
-	.owner		= THIS_MODULE,
-	.open		= proc_cache_inv_stats_open,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-	.release	= single_release,
-};
-
 static ctl_table coda_table[] = {
 	{
 		.ctl_name	= CTL_UNNUMBERED,
@@ -199,22 +32,6 @@ static ctl_table coda_table[] = {
 	},
 	{
 		.ctl_name	= CTL_UNNUMBERED,
-		.procname	= "vfs_stats",
-		.data		= NULL,
-		.maxlen		= 0,
-		.mode		= 0644,
-		.proc_handler	= &do_reset_coda_vfs_stats
-	},
-	{
-		.ctl_name	= CTL_UNNUMBERED,
-		.procname	= "cache_inv_stats",
-		.data		= NULL,
-		.maxlen		= 0,
-		.mode		= 0644,
-		.proc_handler	= &do_reset_coda_cache_inv_stats
-	},
-	{
-		.ctl_name	= CTL_UNNUMBERED,
 		.procname	= "fake_statfs",
 		.data		= &coda_fake_statfs,
 		.maxlen		= sizeof(int),
@@ -235,59 +52,20 @@ static ctl_table fs_table[] = {
 };
 
 
-#ifdef CONFIG_PROC_FS
-
-/*
- target directory structure:
-   /proc/fs  (see linux/fs/proc/root.c)
-   /proc/fs/coda
-   /proc/fs/coda/{vfs_stats,
-
-*/
-
-static struct proc_dir_entry* proc_fs_coda;
-
-#endif
-
 void coda_sysctl_init(void)
 {
-	reset_coda_vfs_stats();
-	reset_coda_cache_inv_stats();
-
-#ifdef CONFIG_PROC_FS
-	proc_fs_coda = proc_mkdir("coda", proc_root_fs);
-	if (proc_fs_coda) {
-		struct proc_dir_entry *pde;
-
-		proc_fs_coda->owner = THIS_MODULE;
-		pde = create_proc_entry("vfs_stats", 0, proc_fs_coda);
-		if (pde)
-			pde->proc_fops = &proc_vfs_stats_fops;
-		pde = create_proc_entry("cache_inv_stats", 0, proc_fs_coda);
-		if (pde)
-			pde->proc_fops = &proc_cache_inv_stats_fops;
-	}
-#endif
-
 #ifdef CONFIG_SYSCTL
 	if ( !fs_table_header )
 		fs_table_header = register_sysctl_table(fs_table);
-#endif 
+#endif
 }
 
-void coda_sysctl_clean(void) 
+void coda_sysctl_clean(void)
 {
-
 #ifdef CONFIG_SYSCTL
 	if ( fs_table_header ) {
 		unregister_sysctl_table(fs_table_header);
 		fs_table_header = NULL;
 	}
 #endif
-
-#ifdef CONFIG_PROC_FS
-        remove_proc_entry("cache_inv_stats", proc_fs_coda);
-        remove_proc_entry("vfs_stats", proc_fs_coda);
-	remove_proc_entry("coda", proc_root_fs);
-#endif 
 }
diff -puN fs/coda/upcall.c~coda-remove-statistics-counters-from-proc-fs-coda fs/coda/upcall.c
--- a/fs/coda/upcall.c~coda-remove-statistics-counters-from-proc-fs-coda
+++ a/fs/coda/upcall.c
@@ -35,7 +35,8 @@
 #include <linux/coda_psdev.h>
 #include <linux/coda_fs_i.h>
 #include <linux/coda_cache.h>
-#include <linux/coda_proc.h> 
+
+#include "coda_int.h"
 
 static int coda_upcall(struct venus_comm *vc, int inSize, int *outSize,
 		       union inputArgs *buffer);
diff -puN include/linux/coda_linux.h~coda-remove-statistics-counters-from-proc-fs-coda include/linux/coda_linux.h
--- a/include/linux/coda_linux.h~coda-remove-statistics-counters-from-proc-fs-coda
+++ a/include/linux/coda_linux.h
@@ -43,9 +43,6 @@ int coda_revalidate_inode(struct dentry 
 int coda_getattr(struct vfsmount *, struct dentry *, struct kstat *);
 int coda_setattr(struct dentry *, struct iattr *);
 
-/* global variables */
-extern int coda_fake_statfs;
-
 /* this file:  heloers */
 static __inline__ struct CodaFid *coda_i2f(struct inode *);
 static __inline__ char *coda_i2s(struct inode *);
diff -puN include/linux/coda_proc.h~coda-remove-statistics-counters-from-proc-fs-coda /dev/null
--- a/include/linux/coda_proc.h
+++ /dev/null
@@ -1,76 +0,0 @@
-/*
- * coda_statis.h
- * 
- * CODA operation statistics
- *
- * (c) March, 1998
- * by Michihiro Kuramochi, Zhenyu Xia and Zhanyong Wan
- * zhanyong.wan@yale.edu
- *
- */
-
-#ifndef _CODA_PROC_H
-#define _CODA_PROC_H
-
-void coda_sysctl_init(void);
-void coda_sysctl_clean(void);
-
-#include <linux/sysctl.h>
-#include <linux/coda_fs_i.h>
-#include <linux/coda.h>
-
-/* these four files are presented to show the result of the statistics:
- *
- *	/proc/fs/coda/vfs_stats
- *		      cache_inv_stats
- *
- * these four files are presented to reset the statistics to 0:
- *
- *	/proc/sys/coda/vfs_stats
- *		       cache_inv_stats
- */
-
-/* VFS operation statistics */
-struct coda_vfs_stats 
-{
-	/* file operations */
-	int open;
-	int flush;
-	int release;
-	int fsync;
-
-	/* dir operations */
-	int readdir;
-  
-	/* inode operations */
-	int create;
-	int lookup;
-	int link;
-	int unlink;
-	int symlink;
-	int mkdir;
-	int rmdir;
-	int rename;
-	int permission;
-
-	/* symlink operatoins*/
-	int follow_link;
-	int readlink;
-};
-
-/* cache invalidation statistics */
-struct coda_cache_inv_stats
-{
-	int flush;
-	int purge_user;
-	int zap_dir;
-	int zap_file;
-	int zap_vnode;
-	int purge_fid;
-	int replace;
-};
-
-/* these global variables hold the actual statistics data */
-extern struct coda_vfs_stats		coda_vfs_stat;
-
-#endif /* _CODA_PROC_H */
diff -puN include/linux/coda_psdev.h~coda-remove-statistics-counters-from-proc-fs-coda include/linux/coda_psdev.h
--- a/include/linux/coda_psdev.h~coda-remove-statistics-counters-from-proc-fs-coda
+++ a/include/linux/coda_psdev.h
@@ -69,8 +69,6 @@ int venus_statfs(struct dentry *dentry, 
 
 
 /* messages between coda filesystem in kernel and Venus */
-extern int coda_hard;
-extern unsigned long coda_timeout;
 struct upc_req {
 	struct list_head    uc_chain;
 	caddr_t	            uc_data;
_

Patches currently in -mm which might be from jaharkes@cs.cmu.edu are

coda-do-not-grab-an-uninitialized-fd-when-the-open-upcall-returns-an-error.patch
coda-correctly-invalidate-cached-access-rights.patch
coda-fix-nlink-updates-for-directories.patch
coda-allow-removal-of-busy-directories.patch
coda-coda-doesnt-track-atime.patch
coda-use-ilookup5.patch
coda-cleanup-dev-cfs-open-and-close-handling.patch
coda-cleanup-for-upcall-handling-path.patch
coda-block-signals-during-upcall-processing.patch
coda-avoid-lockdep-warning-in-coda_readdir.patch
coda-replace-upc_alloc-upc_free-with-kmalloc-kfree.patch
coda-ignore-returned-values-when-upcalls-return-errors.patch
coda-cleanup-coda_lookup-use-dsplice_alias.patch
coda-cleanup-downcall-handler.patch
coda-remove-struct-coda_sb_info.patch
coda-remove-statistics-counters-from-proc-fs-coda.patch
coda-update-module-information.patch
