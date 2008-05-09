From: akpm@linux-foundation.org
Subject: + jfs-switch-to-seq_files.patch added to -mm tree
Date: Fri, 09 May 2008 12:46:09 -0700
Message-ID: <200805091946.m49Jk988022727@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58663 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751790AbYEITqn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 9 May 2008 15:46:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: adobriyan@gmail.com, shaggy@austin.ibm.com


The patch titled
     jfs: switch to seq_files
has been added to the -mm tree.  Its filename is
     jfs-switch-to-seq_files.patch

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
Subject: jfs: switch to seq_files
From: Alexey Dobriyan <adobriyan@gmail.com>

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Dave Kleikamp <shaggy@austin.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/jfs/jfs_debug.c    |   62 ++++++++++++++++--------------------
 fs/jfs/jfs_debug.h    |   10 ++---
 fs/jfs/jfs_logmgr.c   |   35 +++++++++-----------
 fs/jfs/jfs_metapage.c |   36 ++++++++++-----------
 fs/jfs/jfs_txnmgr.c   |   68 ++++++++++++++++++----------------------
 fs/jfs/jfs_xtree.c    |   36 ++++++++++-----------
 6 files changed, 114 insertions(+), 133 deletions(-)

diff -puN fs/jfs/jfs_debug.c~jfs-switch-to-seq_files fs/jfs/jfs_debug.c
--- a/fs/jfs/jfs_debug.c~jfs-switch-to-seq_files
+++ a/fs/jfs/jfs_debug.c
@@ -21,6 +21,7 @@
 #include <linux/ctype.h>
 #include <linux/module.h>
 #include <linux/proc_fs.h>
+#include <linux/seq_file.h>
 #include <asm/uaccess.h>
 #include "jfs_incore.h"
 #include "jfs_filsys.h"
@@ -30,29 +31,19 @@
 
 static struct proc_dir_entry *base;
 #ifdef CONFIG_JFS_DEBUG
-static int loglevel_read(char *page, char **start, off_t off,
-			 int count, int *eof, void *data)
+static int jfs_loglevel_proc_show(struct seq_file *m, void *v)
 {
-	int len;
-
-	len = sprintf(page, "%d\n", jfsloglevel);
-
-	len -= off;
-	*start = page + off;
-
-	if (len > count)
-		len = count;
-	else
-		*eof = 1;
-
-	if (len < 0)
-		len = 0;
+	seq_printf(m, "%d\n", jfsloglevel);
+	return 0;
+}
 
-	return len;
+static int jfs_loglevel_proc_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, jfs_loglevel_proc_show, NULL);
 }
 
-static int loglevel_write(struct file *file, const char __user *buffer,
-			unsigned long count, void *data)
+static ssize_t jfs_loglevel_proc_write(struct file *file,
+		const char __user *buffer, size_t count, loff_t *ppos)
 {
 	char c;
 
@@ -65,22 +56,30 @@ static int loglevel_write(struct file *f
 	jfsloglevel = c - '0';
 	return count;
 }
+
+static const struct file_operations jfs_loglevel_proc_fops = {
+	.owner		= THIS_MODULE,
+	.open		= jfs_loglevel_proc_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+	.write		= jfs_loglevel_proc_write,
+};
 #endif
 
 static struct {
 	const char	*name;
-	read_proc_t	*read_fn;
-	write_proc_t	*write_fn;
+	const struct file_operations *proc_fops;
 } Entries[] = {
 #ifdef CONFIG_JFS_STATISTICS
-	{ "lmstats",	jfs_lmstats_read, },
-	{ "txstats",	jfs_txstats_read, },
-	{ "xtstat",	jfs_xtstat_read, },
-	{ "mpstat",	jfs_mpstat_read, },
+	{ "lmstats",	&jfs_lmstats_proc_fops, },
+	{ "txstats",	&jfs_txstats_proc_fops, },
+	{ "xtstat",	&jfs_xtstat_proc_fops, },
+	{ "mpstat",	&jfs_mpstat_proc_fops, },
 #endif
 #ifdef CONFIG_JFS_DEBUG
-	{ "TxAnchor",	jfs_txanchor_read, },
-	{ "loglevel",	loglevel_read, loglevel_write }
+	{ "TxAnchor",	&jfs_txanchor_proc_fops, },
+	{ "loglevel",	&jfs_loglevel_proc_fops }
 #endif
 };
 #define NPROCENT	ARRAY_SIZE(Entries)
@@ -93,13 +92,8 @@ void jfs_proc_init(void)
 		return;
 	base->owner = THIS_MODULE;
 
-	for (i = 0; i < NPROCENT; i++) {
-		struct proc_dir_entry *p;
-		if ((p = create_proc_entry(Entries[i].name, 0, base))) {
-			p->read_proc = Entries[i].read_fn;
-			p->write_proc = Entries[i].write_fn;
-		}
-	}
+	for (i = 0; i < NPROCENT; i++)
+		proc_create(Entries[i].name, 0, base, Entries[i].proc_fops);
 }
 
 void jfs_proc_clean(void)
diff -puN fs/jfs/jfs_debug.h~jfs-switch-to-seq_files fs/jfs/jfs_debug.h
--- a/fs/jfs/jfs_debug.h~jfs-switch-to-seq_files
+++ a/fs/jfs/jfs_debug.h
@@ -62,7 +62,7 @@ extern void jfs_proc_clean(void);
 
 extern int jfsloglevel;
 
-extern int jfs_txanchor_read(char *, char **, off_t, int, int *, void *);
+extern const struct file_operations jfs_txanchor_proc_fops;
 
 /* information message: e.g., configuration, major event */
 #define jfs_info(fmt, arg...) do {			\
@@ -105,10 +105,10 @@ extern int jfs_txanchor_read(char *, cha
  *	----------
  */
 #ifdef	CONFIG_JFS_STATISTICS
-extern int jfs_lmstats_read(char *, char **, off_t, int, int *, void *);
-extern int jfs_txstats_read(char *, char **, off_t, int, int *, void *);
-extern int jfs_mpstat_read(char *, char **, off_t, int, int *, void *);
-extern int jfs_xtstat_read(char *, char **, off_t, int, int *, void *);
+extern const struct file_operations jfs_lmstats_proc_fops;
+extern const struct file_operations jfs_txstats_proc_fops;
+extern const struct file_operations jfs_mpstat_proc_fops;
+extern const struct file_operations jfs_xtstat_proc_fops;
 
 #define	INCREMENT(x)		((x)++)
 #define	DECREMENT(x)		((x)--)
diff -puN fs/jfs/jfs_logmgr.c~jfs-switch-to-seq_files fs/jfs/jfs_logmgr.c
--- a/fs/jfs/jfs_logmgr.c~jfs-switch-to-seq_files
+++ a/fs/jfs/jfs_logmgr.c
@@ -69,6 +69,7 @@
 #include <linux/freezer.h>
 #include <linux/delay.h>
 #include <linux/mutex.h>
+#include <linux/seq_file.h>
 #include "jfs_incore.h"
 #include "jfs_filsys.h"
 #include "jfs_metapage.h"
@@ -2503,13 +2504,9 @@ exit:
 }
 
 #ifdef CONFIG_JFS_STATISTICS
-int jfs_lmstats_read(char *buffer, char **start, off_t offset, int length,
-		      int *eof, void *data)
+static int jfs_lmstats_proc_show(struct seq_file *m, void *v)
 {
-	int len = 0;
-	off_t begin;
-
-	len += sprintf(buffer,
+	seq_printf(m,
 		       "JFS Logmgr stats\n"
 		       "================\n"
 		       "commits = %d\n"
@@ -2522,19 +2519,19 @@ int jfs_lmstats_read(char *buffer, char 
 		       lmStat.pagedone,
 		       lmStat.full_page,
 		       lmStat.partial_page);
+	return 0;
+}
 
-	begin = offset;
-	*start = buffer + begin;
-	len -= begin;
-
-	if (len > length)
-		len = length;
-	else
-		*eof = 1;
-
-	if (len < 0)
-		len = 0;
-
-	return len;
+static int jfs_lmstats_proc_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, jfs_lmstats_proc_show, NULL);
 }
+
+const struct file_operations jfs_lmstats_proc_fops = {
+	.owner		= THIS_MODULE,
+	.open		= jfs_lmstats_proc_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+};
 #endif /* CONFIG_JFS_STATISTICS */
diff -puN fs/jfs/jfs_metapage.c~jfs-switch-to-seq_files fs/jfs/jfs_metapage.c
--- a/fs/jfs/jfs_metapage.c~jfs-switch-to-seq_files
+++ a/fs/jfs/jfs_metapage.c
@@ -19,10 +19,12 @@
 
 #include <linux/fs.h>
 #include <linux/mm.h>
+#include <linux/module.h>
 #include <linux/bio.h>
 #include <linux/init.h>
 #include <linux/buffer_head.h>
 #include <linux/mempool.h>
+#include <linux/seq_file.h>
 #include "jfs_incore.h"
 #include "jfs_superblock.h"
 #include "jfs_filsys.h"
@@ -804,13 +806,9 @@ void __invalidate_metapages(struct inode
 }
 
 #ifdef CONFIG_JFS_STATISTICS
-int jfs_mpstat_read(char *buffer, char **start, off_t offset, int length,
-		    int *eof, void *data)
+static int jfs_mpstat_proc_show(struct seq_file *m, void *v)
 {
-	int len = 0;
-	off_t begin;
-
-	len += sprintf(buffer,
+	seq_printf(m,
 		       "JFS Metapage statistics\n"
 		       "=======================\n"
 		       "page allocations = %d\n"
@@ -819,19 +817,19 @@ int jfs_mpstat_read(char *buffer, char *
 		       mpStat.pagealloc,
 		       mpStat.pagefree,
 		       mpStat.lockwait);
+	return 0;
+}
 
-	begin = offset;
-	*start = buffer + begin;
-	len -= begin;
-
-	if (len > length)
-		len = length;
-	else
-		*eof = 1;
-
-	if (len < 0)
-		len = 0;
-
-	return len;
+static int jfs_mpstat_proc_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, jfs_mpstat_proc_show, NULL);
 }
+
+const struct file_operations jfs_mpstat_proc_fops = {
+	.owner		= THIS_MODULE,
+	.open		= jfs_mpstat_proc_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+};
 #endif
diff -puN fs/jfs/jfs_txnmgr.c~jfs-switch-to-seq_files fs/jfs/jfs_txnmgr.c
--- a/fs/jfs/jfs_txnmgr.c~jfs-switch-to-seq_files
+++ a/fs/jfs/jfs_txnmgr.c
@@ -49,6 +49,7 @@
 #include <linux/module.h>
 #include <linux/moduleparam.h>
 #include <linux/kthread.h>
+#include <linux/seq_file.h>
 #include "jfs_incore.h"
 #include "jfs_inode.h"
 #include "jfs_filsys.h"
@@ -3009,11 +3010,8 @@ int jfs_sync(void *arg)
 }
 
 #if defined(CONFIG_PROC_FS) && defined(CONFIG_JFS_DEBUG)
-int jfs_txanchor_read(char *buffer, char **start, off_t offset, int length,
-		      int *eof, void *data)
+static int jfs_txanchor_proc_show(struct seq_file *m, void *v)
 {
-	int len = 0;
-	off_t begin;
 	char *freewait;
 	char *freelockwait;
 	char *lowlockwait;
@@ -3025,7 +3023,7 @@ int jfs_txanchor_read(char *buffer, char
 	lowlockwait =
 	    waitqueue_active(&TxAnchor.lowlockwait) ? "active" : "empty";
 
-	len += sprintf(buffer,
+	seq_printf(m,
 		       "JFS TxAnchor\n"
 		       "============\n"
 		       "freetid = %d\n"
@@ -3044,31 +3042,27 @@ int jfs_txanchor_read(char *buffer, char
 		       TxAnchor.tlocksInUse,
 		       jfs_tlocks_low,
 		       list_empty(&TxAnchor.unlock_queue) ? "" : "not ");
+	return 0;
+}
 
-	begin = offset;
-	*start = buffer + begin;
-	len -= begin;
-
-	if (len > length)
-		len = length;
-	else
-		*eof = 1;
-
-	if (len < 0)
-		len = 0;
-
-	return len;
+static int jfs_txanchor_proc_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, jfs_txanchor_proc_show, NULL);
 }
+
+const struct file_operations jfs_txanchor_proc_fops = {
+	.owner		= THIS_MODULE,
+	.open		= jfs_txanchor_proc_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+};
 #endif
 
 #if defined(CONFIG_PROC_FS) && defined(CONFIG_JFS_STATISTICS)
-int jfs_txstats_read(char *buffer, char **start, off_t offset, int length,
-		     int *eof, void *data)
+static int jfs_txstats_proc_show(struct seq_file *m, void *v)
 {
-	int len = 0;
-	off_t begin;
-
-	len += sprintf(buffer,
+	seq_printf(m,
 		       "JFS TxStats\n"
 		       "===========\n"
 		       "calls to txBegin = %d\n"
@@ -3089,19 +3083,19 @@ int jfs_txstats_read(char *buffer, char 
 		       TxStat.txBeginAnon_lockslow,
 		       TxStat.txLockAlloc,
 		       TxStat.txLockAlloc_freelock);
+	return 0;
+}
 
-	begin = offset;
-	*start = buffer + begin;
-	len -= begin;
-
-	if (len > length)
-		len = length;
-	else
-		*eof = 1;
-
-	if (len < 0)
-		len = 0;
-
-	return len;
+static int jfs_txstats_proc_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, jfs_txstats_proc_show, NULL);
 }
+
+const struct file_operations jfs_txstats_proc_fops = {
+	.owner		= THIS_MODULE,
+	.open		= jfs_txstats_proc_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+};
 #endif
diff -puN fs/jfs/jfs_xtree.c~jfs-switch-to-seq_files fs/jfs/jfs_xtree.c
--- a/fs/jfs/jfs_xtree.c~jfs-switch-to-seq_files
+++ a/fs/jfs/jfs_xtree.c
@@ -20,7 +20,9 @@
  */
 
 #include <linux/fs.h>
+#include <linux/module.h>
 #include <linux/quotaops.h>
+#include <linux/seq_file.h>
 #include "jfs_incore.h"
 #include "jfs_filsys.h"
 #include "jfs_metapage.h"
@@ -4134,13 +4136,9 @@ s64 xtTruncate_pmap(tid_t tid, struct in
 }
 
 #ifdef CONFIG_JFS_STATISTICS
-int jfs_xtstat_read(char *buffer, char **start, off_t offset, int length,
-		    int *eof, void *data)
+static int jfs_xtstat_proc_show(struct seq_file *m, void *v)
 {
-	int len = 0;
-	off_t begin;
-
-	len += sprintf(buffer,
+	seq_printf(m,
 		       "JFS Xtree statistics\n"
 		       "====================\n"
 		       "searches = %d\n"
@@ -4149,19 +4147,19 @@ int jfs_xtstat_read(char *buffer, char *
 		       xtStat.search,
 		       xtStat.fastSearch,
 		       xtStat.split);
+	return 0;
+}
 
-	begin = offset;
-	*start = buffer + begin;
-	len -= begin;
-
-	if (len > length)
-		len = length;
-	else
-		*eof = 1;
-
-	if (len < 0)
-		len = 0;
-
-	return len;
+static int jfs_xtstat_proc_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, jfs_xtstat_proc_show, NULL);
 }
+
+const struct file_operations jfs_xtstat_proc_fops = {
+	.owner		= THIS_MODULE,
+	.open		= jfs_xtstat_proc_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+};
 #endif
_

Patches currently in -mm which might be from adobriyan@gmail.com are

cpumask-remove-bitmap_scnprintf_len-and-cpumask_scnprintf_len.patch
linux-next.patch
arm-lubbock-fix-compilation.patch
mpt-remove-unused-struct-mpt_proc_entry_t.patch
git-block.patch
kbuild-escape-meta-characters-in-regular-expression-in-make-tags.patch
move-proc_kmsg_operations-to-fs-proc-internalh.patch
proc-use-non-racy-method-for-proc-page_owner-creation-page_owner.patch
likely_prof-changed-to-use-proc_create.patch
proc-remove-proc_root-from-drivers-likelyprof.patch
ext4-switch-to-seq_files.patch
cifs-switch-to-seq_files.patch
jfs-switch-to-seq_files.patch

