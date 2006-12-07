From: akpm@osdl.org
Subject: - struct-seq_operations-and-struct-file_operations-constification.patch removed from -mm tree
Date: Thu, 07 Dec 2006 15:16:53 -0800
Message-ID: <200612072316.kB7NGrS4030886@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:53691 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1163817AbWLGXQ6 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 7 Dec 2006 18:16:58 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: deller@gmx.de, mm-commits@vger.kernel.org


The patch titled
     struct seq_operations and struct file_operations constification
has been removed from the -mm tree.  Its filename was
     struct-seq_operations-and-struct-file_operations-constification.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: struct seq_operations and struct file_operations constification
From: Helge Deller <deller@gmx.de>

- move some file_operations structs into the .rodata section

- move static strings from policy_types[] array into the .rodata section

- fix generic seq_operations usages, so that those structs may be defined
  as "const" as well

[akpm@osdl.org: couple of fixes]
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/seq_file.c            |    4 ++--
 include/linux/cpuset.h   |    2 +-
 include/linux/mmzone.h   |    2 +-
 include/linux/relay.h    |    2 +-
 include/linux/sched.h    |    2 +-
 include/linux/seq_file.h |    4 ++--
 kernel/configs.c         |    2 +-
 kernel/cpuset.c          |    4 ++--
 kernel/dma.c             |    2 +-
 kernel/futex.c           |    2 +-
 kernel/kallsyms.c        |    4 ++--
 kernel/lockdep_proc.c    |    6 +++---
 kernel/module.c          |    2 +-
 kernel/power/user.c      |    2 +-
 kernel/profile.c         |    2 +-
 kernel/relay.c           |    2 +-
 kernel/resource.c        |    6 +++---
 kernel/sched.c           |    2 +-
 kernel/sysctl.c          |    2 +-
 mm/mempolicy.c           |    4 ++--
 mm/page_alloc.c          |    2 +-
 mm/shmem.c               |    4 ++--
 mm/slab.c                |    4 ++--
 mm/swapfile.c            |    4 ++--
 mm/vmstat.c              |    8 ++++----
 25 files changed, 40 insertions(+), 40 deletions(-)

diff -puN fs/seq_file.c~struct-seq_operations-and-struct-file_operations-constification fs/seq_file.c
--- a/fs/seq_file.c~struct-seq_operations-and-struct-file_operations-constification
+++ a/fs/seq_file.c
@@ -26,7 +26,7 @@
  *	ERR_PTR(error).  In the end of sequence they return %NULL. ->show()
  *	returns 0 in case of success and negative number in case of error.
  */
-int seq_open(struct file *file, struct seq_operations *op)
+int seq_open(struct file *file, const struct seq_operations *op)
 {
 	struct seq_file *p = file->private_data;
 
@@ -408,7 +408,7 @@ EXPORT_SYMBOL(single_open);
 
 int single_release(struct inode *inode, struct file *file)
 {
-	struct seq_operations *op = ((struct seq_file *)file->private_data)->op;
+	const struct seq_operations *op = ((struct seq_file *)file->private_data)->op;
 	int res = seq_release(inode, file);
 	kfree(op);
 	return res;
diff -puN include/linux/cpuset.h~struct-seq_operations-and-struct-file_operations-constification include/linux/cpuset.h
--- a/include/linux/cpuset.h~struct-seq_operations-and-struct-file_operations-constification
+++ a/include/linux/cpuset.h
@@ -46,7 +46,7 @@ extern int cpuset_excl_nodes_overlap(con
 extern int cpuset_memory_pressure_enabled;
 extern void __cpuset_memory_pressure_bump(void);
 
-extern struct file_operations proc_cpuset_operations;
+extern const struct file_operations proc_cpuset_operations;
 extern char *cpuset_task_status_allowed(struct task_struct *task, char *buffer);
 
 extern void cpuset_lock(void);
diff -puN include/linux/mmzone.h~struct-seq_operations-and-struct-file_operations-constification include/linux/mmzone.h
--- a/include/linux/mmzone.h~struct-seq_operations-and-struct-file_operations-constification
+++ a/include/linux/mmzone.h
@@ -278,7 +278,7 @@ struct zone {
 	/*
 	 * rarely used fields:
 	 */
-	char			*name;
+	const char		*name;
 } ____cacheline_internodealigned_in_smp;
 
 /*
diff -puN include/linux/relay.h~struct-seq_operations-and-struct-file_operations-constification include/linux/relay.h
--- a/include/linux/relay.h~struct-seq_operations-and-struct-file_operations-constification
+++ a/include/linux/relay.h
@@ -274,7 +274,7 @@ static inline void subbuf_start_reserve(
 /*
  * exported relay file operations, kernel/relay.c
  */
-extern struct file_operations relay_file_operations;
+extern const struct file_operations relay_file_operations;
 
 #endif /* _LINUX_RELAY_H */
 
diff -puN include/linux/sched.h~struct-seq_operations-and-struct-file_operations-constification include/linux/sched.h
--- a/include/linux/sched.h~struct-seq_operations-and-struct-file_operations-constification
+++ a/include/linux/sched.h
@@ -573,7 +573,7 @@ struct sched_info {
 #endif /* defined(CONFIG_SCHEDSTATS) || defined(CONFIG_TASK_DELAY_ACCT) */
 
 #ifdef CONFIG_SCHEDSTATS
-extern struct file_operations proc_schedstat_operations;
+extern const struct file_operations proc_schedstat_operations;
 #endif /* CONFIG_SCHEDSTATS */
 
 #ifdef CONFIG_TASK_DELAY_ACCT
diff -puN include/linux/seq_file.h~struct-seq_operations-and-struct-file_operations-constification include/linux/seq_file.h
--- a/include/linux/seq_file.h~struct-seq_operations-and-struct-file_operations-constification
+++ a/include/linux/seq_file.h
@@ -20,7 +20,7 @@ struct seq_file {
 	loff_t index;
 	loff_t version;
 	struct mutex lock;
-	struct seq_operations *op;
+	const struct seq_operations *op;
 	void *private;
 };
 
@@ -31,7 +31,7 @@ struct seq_operations {
 	int (*show) (struct seq_file *m, void *v);
 };
 
-int seq_open(struct file *, struct seq_operations *);
+int seq_open(struct file *, const struct seq_operations *);
 ssize_t seq_read(struct file *, char __user *, size_t, loff_t *);
 loff_t seq_lseek(struct file *, loff_t, int);
 int seq_release(struct inode *, struct file *);
diff -puN kernel/configs.c~struct-seq_operations-and-struct-file_operations-constification kernel/configs.c
--- a/kernel/configs.c~struct-seq_operations-and-struct-file_operations-constification
+++ a/kernel/configs.c
@@ -75,7 +75,7 @@ ikconfig_read_current(struct file *file,
 	return count;
 }
 
-static struct file_operations ikconfig_file_ops = {
+static const struct file_operations ikconfig_file_ops = {
 	.owner = THIS_MODULE,
 	.read = ikconfig_read_current,
 };
diff -puN kernel/cpuset.c~struct-seq_operations-and-struct-file_operations-constification kernel/cpuset.c
--- a/kernel/cpuset.c~struct-seq_operations-and-struct-file_operations-constification
+++ a/kernel/cpuset.c
@@ -1531,7 +1531,7 @@ static int cpuset_rename(struct inode *o
 	return simple_rename(old_dir, old_dentry, new_dir, new_dentry);
 }
 
-static struct file_operations cpuset_file_operations = {
+static const struct file_operations cpuset_file_operations = {
 	.read = cpuset_file_read,
 	.write = cpuset_file_write,
 	.llseek = generic_file_llseek,
@@ -2605,7 +2605,7 @@ static int cpuset_open(struct inode *ino
 	return single_open(file, proc_cpuset_show, pid);
 }
 
-struct file_operations proc_cpuset_operations = {
+const struct file_operations proc_cpuset_operations = {
 	.open		= cpuset_open,
 	.read		= seq_read,
 	.llseek		= seq_lseek,
diff -puN kernel/dma.c~struct-seq_operations-and-struct-file_operations-constification kernel/dma.c
--- a/kernel/dma.c~struct-seq_operations-and-struct-file_operations-constification
+++ a/kernel/dma.c
@@ -140,7 +140,7 @@ static int proc_dma_open(struct inode *i
 	return single_open(file, proc_dma_show, NULL);
 }
 
-static struct file_operations proc_dma_operations = {
+static const struct file_operations proc_dma_operations = {
 	.open		= proc_dma_open,
 	.read		= seq_read,
 	.llseek		= seq_lseek,
diff -puN kernel/futex.c~struct-seq_operations-and-struct-file_operations-constification kernel/futex.c
--- a/kernel/futex.c~struct-seq_operations-and-struct-file_operations-constification
+++ a/kernel/futex.c
@@ -1492,7 +1492,7 @@ static unsigned int futex_poll(struct fi
 	return ret;
 }
 
-static struct file_operations futex_fops = {
+static const struct file_operations futex_fops = {
 	.release	= futex_close,
 	.poll		= futex_poll,
 };
diff -puN kernel/kallsyms.c~struct-seq_operations-and-struct-file_operations-constification kernel/kallsyms.c
--- a/kernel/kallsyms.c~struct-seq_operations-and-struct-file_operations-constification
+++ a/kernel/kallsyms.c
@@ -398,7 +398,7 @@ static int s_show(struct seq_file *m, vo
 	return 0;
 }
 
-static struct seq_operations kallsyms_op = {
+static const struct seq_operations kallsyms_op = {
 	.start = s_start,
 	.next = s_next,
 	.stop = s_stop,
@@ -433,7 +433,7 @@ static int kallsyms_release(struct inode
 	return seq_release(inode, file);
 }
 
-static struct file_operations kallsyms_operations = {
+static const struct file_operations kallsyms_operations = {
 	.open = kallsyms_open,
 	.read = seq_read,
 	.llseek = seq_lseek,
diff -puN kernel/lockdep_proc.c~struct-seq_operations-and-struct-file_operations-constification kernel/lockdep_proc.c
--- a/kernel/lockdep_proc.c~struct-seq_operations-and-struct-file_operations-constification
+++ a/kernel/lockdep_proc.c
@@ -113,7 +113,7 @@ static int l_show(struct seq_file *m, vo
 	return 0;
 }
 
-static struct seq_operations lockdep_ops = {
+static const struct seq_operations lockdep_ops = {
 	.start	= l_start,
 	.next	= l_next,
 	.stop	= l_stop,
@@ -135,7 +135,7 @@ static int lockdep_open(struct inode *in
 	return res;
 }
 
-static struct file_operations proc_lockdep_operations = {
+static const struct file_operations proc_lockdep_operations = {
 	.open		= lockdep_open,
 	.read		= seq_read,
 	.llseek		= seq_lseek,
@@ -319,7 +319,7 @@ static int lockdep_stats_open(struct ino
 	return single_open(file, lockdep_stats_show, NULL);
 }
 
-static struct file_operations proc_lockdep_stats_operations = {
+static const struct file_operations proc_lockdep_stats_operations = {
 	.open		= lockdep_stats_open,
 	.read		= seq_read,
 	.llseek		= seq_lseek,
diff -puN kernel/module.c~struct-seq_operations-and-struct-file_operations-constification kernel/module.c
--- a/kernel/module.c~struct-seq_operations-and-struct-file_operations-constification
+++ a/kernel/module.c
@@ -2209,7 +2209,7 @@ static int m_show(struct seq_file *m, vo
    Where refcount is a number or -, and deps is a comma-separated list
    of depends or -.
 */
-struct seq_operations modules_op = {
+const struct seq_operations modules_op = {
 	.start	= m_start,
 	.next	= m_next,
 	.stop	= m_stop,
diff -puN kernel/power/user.c~struct-seq_operations-and-struct-file_operations-constification kernel/power/user.c
--- a/kernel/power/user.c~struct-seq_operations-and-struct-file_operations-constification
+++ a/kernel/power/user.c
@@ -383,7 +383,7 @@ static int snapshot_ioctl(struct inode *
 	return error;
 }
 
-static struct file_operations snapshot_fops = {
+static const struct file_operations snapshot_fops = {
 	.open = snapshot_open,
 	.release = snapshot_release,
 	.read = snapshot_read,
diff -puN kernel/profile.c~struct-seq_operations-and-struct-file_operations-constification kernel/profile.c
--- a/kernel/profile.c~struct-seq_operations-and-struct-file_operations-constification
+++ a/kernel/profile.c
@@ -501,7 +501,7 @@ static ssize_t write_profile(struct file
 	return count;
 }
 
-static struct file_operations proc_profile_operations = {
+static const struct file_operations proc_profile_operations = {
 	.read		= read_profile,
 	.write		= write_profile,
 };
diff -puN kernel/relay.c~struct-seq_operations-and-struct-file_operations-constification kernel/relay.c
--- a/kernel/relay.c~struct-seq_operations-and-struct-file_operations-constification
+++ a/kernel/relay.c
@@ -1013,7 +1013,7 @@ static ssize_t relay_file_sendfile(struc
 				       actor, &desc);
 }
 
-struct file_operations relay_file_operations = {
+const struct file_operations relay_file_operations = {
 	.open		= relay_file_open,
 	.poll		= relay_file_poll,
 	.mmap		= relay_file_mmap,
diff -puN kernel/resource.c~struct-seq_operations-and-struct-file_operations-constification kernel/resource.c
--- a/kernel/resource.c~struct-seq_operations-and-struct-file_operations-constification
+++ a/kernel/resource.c
@@ -88,7 +88,7 @@ static int r_show(struct seq_file *m, vo
 	return 0;
 }
 
-static struct seq_operations resource_op = {
+static const struct seq_operations resource_op = {
 	.start	= r_start,
 	.next	= r_next,
 	.stop	= r_stop,
@@ -115,14 +115,14 @@ static int iomem_open(struct inode *inod
 	return res;
 }
 
-static struct file_operations proc_ioports_operations = {
+static const struct file_operations proc_ioports_operations = {
 	.open		= ioports_open,
 	.read		= seq_read,
 	.llseek		= seq_lseek,
 	.release	= seq_release,
 };
 
-static struct file_operations proc_iomem_operations = {
+static const struct file_operations proc_iomem_operations = {
 	.open		= iomem_open,
 	.read		= seq_read,
 	.llseek		= seq_lseek,
diff -puN kernel/sched.c~struct-seq_operations-and-struct-file_operations-constification kernel/sched.c
--- a/kernel/sched.c~struct-seq_operations-and-struct-file_operations-constification
+++ a/kernel/sched.c
@@ -505,7 +505,7 @@ static int schedstat_open(struct inode *
 	return res;
 }
 
-struct file_operations proc_schedstat_operations = {
+const struct file_operations proc_schedstat_operations = {
 	.open    = schedstat_open,
 	.read    = seq_read,
 	.llseek  = seq_lseek,
diff -puN kernel/sysctl.c~struct-seq_operations-and-struct-file_operations-constification kernel/sysctl.c
--- a/kernel/sysctl.c~struct-seq_operations-and-struct-file_operations-constification
+++ a/kernel/sysctl.c
@@ -170,7 +170,7 @@ static ssize_t proc_readsys(struct file 
 static ssize_t proc_writesys(struct file *, const char __user *, size_t, loff_t *);
 static int proc_opensys(struct inode *, struct file *);
 
-struct file_operations proc_sys_file_operations = {
+const struct file_operations proc_sys_file_operations = {
 	.open		= proc_opensys,
 	.read		= proc_readsys,
 	.write		= proc_writesys,
diff -puN mm/mempolicy.c~struct-seq_operations-and-struct-file_operations-constification mm/mempolicy.c
--- a/mm/mempolicy.c~struct-seq_operations-and-struct-file_operations-constification
+++ a/mm/mempolicy.c
@@ -1707,8 +1707,8 @@ void mpol_rebind_mm(struct mm_struct *mm
  * Display pages allocated per node and memory policy via /proc.
  */
 
-static const char *policy_types[] = { "default", "prefer", "bind",
-				      "interleave" };
+static const char * const policy_types[] =
+	{ "default", "prefer", "bind", "interleave" };
 
 /*
  * Convert a mempolicy into a string.
diff -puN mm/page_alloc.c~struct-seq_operations-and-struct-file_operations-constification mm/page_alloc.c
--- a/mm/page_alloc.c~struct-seq_operations-and-struct-file_operations-constification
+++ a/mm/page_alloc.c
@@ -83,7 +83,7 @@ int sysctl_lowmem_reserve_ratio[MAX_NR_Z
 
 EXPORT_SYMBOL(totalram_pages);
 
-static char *zone_names[MAX_NR_ZONES] = {
+static char * const zone_names[MAX_NR_ZONES] = {
 	 "DMA",
 #ifdef CONFIG_ZONE_DMA32
 	 "DMA32",
diff -puN mm/shmem.c~struct-seq_operations-and-struct-file_operations-constification mm/shmem.c
--- a/mm/shmem.c~struct-seq_operations-and-struct-file_operations-constification
+++ a/mm/shmem.c
@@ -177,7 +177,7 @@ static inline void shmem_unacct_blocks(u
 
 static struct super_operations shmem_ops;
 static const struct address_space_operations shmem_aops;
-static struct file_operations shmem_file_operations;
+static const struct file_operations shmem_file_operations;
 static struct inode_operations shmem_inode_operations;
 static struct inode_operations shmem_dir_inode_operations;
 static struct inode_operations shmem_special_inode_operations;
@@ -2319,7 +2319,7 @@ static const struct address_space_operat
 	.migratepage	= migrate_page,
 };
 
-static struct file_operations shmem_file_operations = {
+static const struct file_operations shmem_file_operations = {
 	.mmap		= shmem_mmap,
 #ifdef CONFIG_TMPFS
 	.llseek		= generic_file_llseek,
diff -puN mm/slab.c~struct-seq_operations-and-struct-file_operations-constification mm/slab.c
--- a/mm/slab.c~struct-seq_operations-and-struct-file_operations-constification
+++ a/mm/slab.c
@@ -4142,7 +4142,7 @@ static int s_show(struct seq_file *m, vo
  * + further values on SMP and with statistics enabled
  */
 
-struct seq_operations slabinfo_op = {
+const struct seq_operations slabinfo_op = {
 	.start = s_start,
 	.next = s_next,
 	.stop = s_stop,
@@ -4340,7 +4340,7 @@ static int leaks_show(struct seq_file *m
 	return 0;
 }
 
-struct seq_operations slabstats_op = {
+const struct seq_operations slabstats_op = {
 	.start = leaks_start,
 	.next = s_next,
 	.stop = s_stop,
diff -puN mm/swapfile.c~struct-seq_operations-and-struct-file_operations-constification mm/swapfile.c
--- a/mm/swapfile.c~struct-seq_operations-and-struct-file_operations-constification
+++ a/mm/swapfile.c
@@ -1368,7 +1368,7 @@ static int swap_show(struct seq_file *sw
 	return 0;
 }
 
-static struct seq_operations swaps_op = {
+static const struct seq_operations swaps_op = {
 	.start =	swap_start,
 	.next =		swap_next,
 	.stop =		swap_stop,
@@ -1380,7 +1380,7 @@ static int swaps_open(struct inode *inod
 	return seq_open(file, &swaps_op);
 }
 
-static struct file_operations proc_swaps_operations = {
+static const struct file_operations proc_swaps_operations = {
 	.open		= swaps_open,
 	.read		= seq_read,
 	.llseek		= seq_lseek,
diff -puN mm/vmstat.c~struct-seq_operations-and-struct-file_operations-constification mm/vmstat.c
--- a/mm/vmstat.c~struct-seq_operations-and-struct-file_operations-constification
+++ a/mm/vmstat.c
@@ -430,7 +430,7 @@ static int frag_show(struct seq_file *m,
 	return 0;
 }
 
-struct seq_operations fragmentation_op = {
+const struct seq_operations fragmentation_op = {
 	.start	= frag_start,
 	.next	= frag_next,
 	.stop	= frag_stop,
@@ -452,7 +452,7 @@ struct seq_operations fragmentation_op =
 #define TEXTS_FOR_ZONES(xx) xx "_dma", TEXT_FOR_DMA32(xx) xx "_normal", \
 					TEXT_FOR_HIGHMEM(xx)
 
-static char *vmstat_text[] = {
+static const char * const vmstat_text[] = {
 	/* Zoned VM counters */
 	"nr_anon_pages",
 	"nr_mapped",
@@ -597,7 +597,7 @@ static int zoneinfo_show(struct seq_file
 	return 0;
 }
 
-struct seq_operations zoneinfo_op = {
+const struct seq_operations zoneinfo_op = {
 	.start	= frag_start, /* iterate over all zones. The same as in
 			       * fragmentation. */
 	.next	= frag_next,
@@ -660,7 +660,7 @@ static void vmstat_stop(struct seq_file 
 	m->private = NULL;
 }
 
-struct seq_operations vmstat_op = {
+const struct seq_operations vmstat_op = {
 	.start	= vmstat_start,
 	.next	= vmstat_next,
 	.stop	= vmstat_stop,
_

Patches currently in -mm which might be from deller@gmx.de are

origin.patch
fbcmapc-mark-structs-const-or.patch
various-fbdev-files-mark-structs.patch
various-fbdev-files-mark-structs-fix.patch
constify-and-annotate-__read_mostly.patch
annotate-some-variables-in-vesafb.patch
constify-vga16fbc.patch

