From: akpm@osdl.org
Subject: + seq_file-conversion-coda.patch added to -mm tree
Date: Tue, 23 Jan 2007 16:53:40 -0800
Message-ID: <200701240053.l0O0rehW004309@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:45368 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965606AbXAXAxp (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 23 Jan 2007 19:53:45 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: adobriyan@gmail.com, jaharkes@cs.cmu.edu


The patch titled
     seq_file conversion: coda
has been added to the -mm tree.  Its filename is
     seq_file-conversion-coda.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: seq_file conversion: coda
From: Alexey Dobriyan <adobriyan@gmail.com>

Compile-tested.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Cc: <jaharkes@cs.cmu.edu>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/coda/sysctl.c |   78 +++++++++++++++++++++++----------------------
 1 files changed, 40 insertions(+), 38 deletions(-)

diff -puN fs/coda/sysctl.c~seq_file-conversion-coda fs/coda/sysctl.c
--- a/fs/coda/sysctl.c~seq_file-conversion-coda
+++ a/fs/coda/sysctl.c
@@ -15,6 +15,7 @@
 #include <linux/mm.h>
 #include <linux/sysctl.h>
 #include <linux/proc_fs.h>
+#include <linux/seq_file.h>
 #include <linux/slab.h>
 #include <linux/stat.h>
 #include <linux/ctype.h>
@@ -84,15 +85,11 @@ static int do_reset_coda_cache_inv_stats
 	return 0;
 }
 
-static int coda_vfs_stats_get_info( char * buffer, char ** start,
-				    off_t offset, int length)
+static int proc_vfs_stats_show(struct seq_file *m, void *v)
 {
-	int len=0;
-	off_t begin;
 	struct coda_vfs_stats * ps = & coda_vfs_stat;
   
-  /* this works as long as we are below 1024 characters! */
-	len += sprintf( buffer,
+	seq_printf(m,
 			"Coda VFS statistics\n"
 			"===================\n\n"
 			"File Operations:\n"
@@ -132,28 +129,14 @@ static int coda_vfs_stats_get_info( char
 			ps->rmdir,
 			ps->rename,
 			ps->permission); 
-
-	begin = offset;
-	*start = buffer + begin;
-	len -= begin;
-
-	if ( len > length )
-		len = length;
-	if ( len < 0 )
-		len = 0;
-
-	return len;
+	return 0;
 }
 
-static int coda_cache_inv_stats_get_info( char * buffer, char ** start,
-					  off_t offset, int length)
+static int proc_cache_inv_stats_show(struct seq_file *m, void *v)
 {
-	int len=0;
-	off_t begin;
 	struct coda_cache_inv_stats * ps = & coda_cache_inv_stat;
   
-	/* this works as long as we are below 1024 characters! */
-	len += sprintf( buffer,
+	seq_printf(m,
 			"Coda cache invalidation statistics\n"
 			"==================================\n\n"
 			"flush\t\t%9d\n"
@@ -170,19 +153,35 @@ static int coda_cache_inv_stats_get_info
 			ps->zap_vnode,
 			ps->purge_fid,
 			ps->replace );
-  
-	begin = offset;
-	*start = buffer + begin;
-	len -= begin;
-
-	if ( len > length )
-		len = length;
-	if ( len < 0 )
-		len = 0;
+	return 0;
+}
 
-	return len;
+static int proc_vfs_stats_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, proc_vfs_stats_show, NULL);
 }
 
+static int proc_cache_inv_stats_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, proc_cache_inv_stats_show, NULL);
+}
+
+static const struct file_operations proc_vfs_stats_fops = {
+	.owner		= THIS_MODULE,
+	.open		= proc_vfs_stats_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+};
+
+static const struct file_operations proc_cache_inv_stats_fops = {
+	.owner		= THIS_MODULE,
+	.open		= proc_cache_inv_stats_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+};
+
 static ctl_table coda_table[] = {
  	{CODA_TIMEOUT, "timeout", &coda_timeout, sizeof(int), 0644, NULL, &proc_dointvec},
  	{CODA_HARD, "hard", &coda_hard, sizeof(int), 0644, NULL, &proc_dointvec},
@@ -212,9 +211,6 @@ static struct proc_dir_entry* proc_fs_co
 
 #endif
 
-#define coda_proc_create(name,get_info) \
-	create_proc_info_entry(name, 0, proc_fs_coda, get_info)
-
 void coda_sysctl_init(void)
 {
 	reset_coda_vfs_stats();
@@ -223,9 +219,15 @@ void coda_sysctl_init(void)
 #ifdef CONFIG_PROC_FS
 	proc_fs_coda = proc_mkdir("coda", proc_root_fs);
 	if (proc_fs_coda) {
+		struct proc_dir_entry *pde;
+
 		proc_fs_coda->owner = THIS_MODULE;
-		coda_proc_create("vfs_stats", coda_vfs_stats_get_info);
-		coda_proc_create("cache_inv_stats", coda_cache_inv_stats_get_info);
+		pde = create_proc_entry("vfs_stats", 0, proc_fs_coda);
+		if (pde)
+			pde->proc_fops = &proc_vfs_stats_fops;
+		pde = create_proc_entry("cache_inv_stats", 0, proc_fs_coda);
+		if (pde)
+			pde->proc_fops = &proc_cache_inv_stats_fops;
 	}
 #endif
 
_

Patches currently in -mm which might be from adobriyan@gmail.com are

origin.patch
git-dvb.patch
megaraid-fix-warnings-when-config_proc_fs=n.patch
proc-remove-useless-and-buggy-nlink-settings.patch
seq_file-conversion-coda.patch
