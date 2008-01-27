From: akpm@linux-foundation.org
Subject: + procfs-constify-function-pointer-tables.patch added to -mm tree
Date: Sat, 26 Jan 2008 21:18:36 -0800
Message-ID: <200801270518.m0R5IXMw031208@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51727 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751601AbYA0F03 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 27 Jan 2008 00:26:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jengelh@computergmbh.de, bryan.wu@analog.com, dhowells@redhat.com, geert@linux-m68k.org, jesper.nilsson@axis.com, linux-arch@vger.kernel.org, vapier@gentoo.org


The patch titled
     procfs: constify function pointer tables
has been added to the -mm tree.  Its filename is
     procfs-constify-function-pointer-tables.patch

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
Subject: procfs: constify function pointer tables
From: Jan Engelhardt <jengelh@computergmbh.de>

Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>
cked-by: Geert Uytterhoeven <geert@linux-m68k.org>
Acked-by: Mike Frysinger <vapier@gentoo.org>
Acked-By: David Howells <dhowells@redhat.com>
Acked-by: Bryan Wu <bryan.wu@analog.com>
Acked-by: Jesper Nilsson <jesper.nilsson@axis.com>
Cc: <linux-arch@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/alpha/kernel/setup.c     |    2 +-
 arch/blackfin/kernel/setup.c  |    2 +-
 arch/cris/kernel/setup.c      |    2 +-
 arch/frv/kernel/setup.c       |    2 +-
 arch/h8300/kernel/setup.c     |    2 +-
 arch/m32r/kernel/setup.c      |    2 +-
 arch/m68k/kernel/setup.c      |    2 +-
 arch/m68knommu/kernel/setup.c |    2 +-
 arch/parisc/kernel/setup.c    |    2 +-
 arch/ppc/kernel/setup.c       |    2 +-
 arch/v850/kernel/procfs.c     |    2 +-
 arch/xtensa/kernel/setup.c    |    2 +-
 fs/proc/base.c                |    4 ++--
 fs/proc/nommu.c               |    2 +-
 fs/proc/proc_misc.c           |   22 +++++++++++-----------
 fs/proc/proc_sysctl.c         |    4 ++--
 fs/proc/proc_tty.c            |    2 +-
 fs/proc/task_mmu.c            |    8 ++++----
 fs/proc/task_nommu.c          |    2 +-
 19 files changed, 34 insertions(+), 34 deletions(-)

diff -puN arch/alpha/kernel/setup.c~procfs-constify-function-pointer-tables arch/alpha/kernel/setup.c
--- a/arch/alpha/kernel/setup.c~procfs-constify-function-pointer-tables
+++ a/arch/alpha/kernel/setup.c
@@ -1471,7 +1471,7 @@ c_stop(struct seq_file *f, void *v)
 {
 }
 
-struct seq_operations cpuinfo_op = {
+const struct seq_operations cpuinfo_op = {
 	.start	= c_start,
 	.next	= c_next,
 	.stop	= c_stop,
diff -puN arch/blackfin/kernel/setup.c~procfs-constify-function-pointer-tables arch/blackfin/kernel/setup.c
--- a/arch/blackfin/kernel/setup.c~procfs-constify-function-pointer-tables
+++ a/arch/blackfin/kernel/setup.c
@@ -691,7 +691,7 @@ static void c_stop(struct seq_file *m, v
 {
 }
 
-struct seq_operations cpuinfo_op = {
+const struct seq_operations cpuinfo_op = {
 	.start = c_start,
 	.next = c_next,
 	.stop = c_stop,
diff -puN arch/cris/kernel/setup.c~procfs-constify-function-pointer-tables arch/cris/kernel/setup.c
--- a/arch/cris/kernel/setup.c~procfs-constify-function-pointer-tables
+++ a/arch/cris/kernel/setup.c
@@ -180,7 +180,7 @@ static void c_stop(struct seq_file *m, v
 
 extern int show_cpuinfo(struct seq_file *m, void *v);
 
-struct seq_operations cpuinfo_op = {
+const struct seq_operations cpuinfo_op = {
 	.start = c_start,
 	.next  = c_next,
 	.stop  = c_stop,
diff -puN arch/frv/kernel/setup.c~procfs-constify-function-pointer-tables arch/frv/kernel/setup.c
--- a/arch/frv/kernel/setup.c~procfs-constify-function-pointer-tables
+++ a/arch/frv/kernel/setup.c
@@ -1113,7 +1113,7 @@ static void c_stop(struct seq_file *m, v
 {
 }
 
-struct seq_operations cpuinfo_op = {
+const struct seq_operations cpuinfo_op = {
 	.start	= c_start,
 	.next	= c_next,
 	.stop	= c_stop,
diff -puN arch/h8300/kernel/setup.c~procfs-constify-function-pointer-tables arch/h8300/kernel/setup.c
--- a/arch/h8300/kernel/setup.c~procfs-constify-function-pointer-tables
+++ a/arch/h8300/kernel/setup.c
@@ -236,7 +236,7 @@ static void c_stop(struct seq_file *m, v
 {
 }
 
-struct seq_operations cpuinfo_op = {
+const struct seq_operations cpuinfo_op = {
 	.start	= c_start,
 	.next	= c_next,
 	.stop	= c_stop,
diff -puN arch/m32r/kernel/setup.c~procfs-constify-function-pointer-tables arch/m32r/kernel/setup.c
--- a/arch/m32r/kernel/setup.c~procfs-constify-function-pointer-tables
+++ a/arch/m32r/kernel/setup.c
@@ -369,7 +369,7 @@ static void c_stop(struct seq_file *m, v
 {
 }
 
-struct seq_operations cpuinfo_op = {
+const struct seq_operations cpuinfo_op = {
 	.start = c_start,
 	.next = c_next,
 	.stop = c_stop,
diff -puN arch/m68k/kernel/setup.c~procfs-constify-function-pointer-tables arch/m68k/kernel/setup.c
--- a/arch/m68k/kernel/setup.c~procfs-constify-function-pointer-tables
+++ a/arch/m68k/kernel/setup.c
@@ -450,7 +450,7 @@ static void *c_next(struct seq_file *m, 
 static void c_stop(struct seq_file *m, void *v)
 {
 }
-struct seq_operations cpuinfo_op = {
+const struct seq_operations cpuinfo_op = {
 	.start	= c_start,
 	.next	= c_next,
 	.stop	= c_stop,
diff -puN arch/m68knommu/kernel/setup.c~procfs-constify-function-pointer-tables arch/m68knommu/kernel/setup.c
--- a/arch/m68knommu/kernel/setup.c~procfs-constify-function-pointer-tables
+++ a/arch/m68knommu/kernel/setup.c
@@ -260,7 +260,7 @@ static void c_stop(struct seq_file *m, v
 {
 }
 
-struct seq_operations cpuinfo_op = {
+const struct seq_operations cpuinfo_op = {
 	.start	= c_start,
 	.next	= c_next,
 	.stop	= c_stop,
diff -puN arch/parisc/kernel/setup.c~procfs-constify-function-pointer-tables arch/parisc/kernel/setup.c
--- a/arch/parisc/kernel/setup.c~procfs-constify-function-pointer-tables
+++ a/arch/parisc/kernel/setup.c
@@ -190,7 +190,7 @@ c_stop (struct seq_file *m, void *v)
 {
 }
 
-struct seq_operations cpuinfo_op = {
+const struct seq_operations cpuinfo_op = {
 	.start	= c_start,
 	.next	= c_next,
 	.stop	= c_stop,
diff -puN arch/ppc/kernel/setup.c~procfs-constify-function-pointer-tables arch/ppc/kernel/setup.c
--- a/arch/ppc/kernel/setup.c~procfs-constify-function-pointer-tables
+++ a/arch/ppc/kernel/setup.c
@@ -276,7 +276,7 @@ static void c_stop(struct seq_file *m, v
 {
 }
 
-struct seq_operations cpuinfo_op = {
+const struct seq_operations cpuinfo_op = {
 	.start =c_start,
 	.next =	c_next,
 	.stop =	c_stop,
diff -puN arch/v850/kernel/procfs.c~procfs-constify-function-pointer-tables arch/v850/kernel/procfs.c
--- a/arch/v850/kernel/procfs.c~procfs-constify-function-pointer-tables
+++ a/arch/v850/kernel/procfs.c
@@ -59,7 +59,7 @@ static void cpuinfo_stop (struct seq_fil
 {
 }
 
-struct seq_operations cpuinfo_op = {
+const struct seq_operations cpuinfo_op = {
 	.start	= cpuinfo_start,
 	.next	= cpuinfo_next,
 	.stop	= cpuinfo_stop,
diff -puN arch/xtensa/kernel/setup.c~procfs-constify-function-pointer-tables arch/xtensa/kernel/setup.c
--- a/arch/xtensa/kernel/setup.c~procfs-constify-function-pointer-tables
+++ a/arch/xtensa/kernel/setup.c
@@ -464,7 +464,7 @@ c_stop(struct seq_file *f, void *v)
 {
 }
 
-struct seq_operations cpuinfo_op =
+const struct seq_operations cpuinfo_op =
 {
 	start:  c_start,
 	next:   c_next,
diff -puN fs/proc/base.c~procfs-constify-function-pointer-tables fs/proc/base.c
--- a/fs/proc/base.c~procfs-constify-function-pointer-tables
+++ a/fs/proc/base.c
@@ -492,7 +492,7 @@ static const struct inode_operations pro
 	.setattr	= proc_setattr,
 };
 
-extern struct seq_operations mounts_op;
+extern const struct seq_operations mounts_op;
 struct proc_mounts {
 	struct seq_file m;
 	int event;
@@ -571,7 +571,7 @@ static const struct file_operations proc
 	.poll		= mounts_poll,
 };
 
-extern struct seq_operations mountstats_op;
+extern const struct seq_operations mountstats_op;
 static int mountstats_open(struct inode *inode, struct file *file)
 {
 	int ret = seq_open(file, &mountstats_op);
diff -puN fs/proc/nommu.c~procfs-constify-function-pointer-tables fs/proc/nommu.c
--- a/fs/proc/nommu.c~procfs-constify-function-pointer-tables
+++ a/fs/proc/nommu.c
@@ -116,7 +116,7 @@ static void *nommu_vma_list_next(struct 
 	return rb_next((struct rb_node *) v);
 }
 
-static struct seq_operations proc_nommu_vma_list_seqop = {
+static const struct seq_operations proc_nommu_vma_list_seqop = {
 	.start	= nommu_vma_list_start,
 	.next	= nommu_vma_list_next,
 	.stop	= nommu_vma_list_stop,
diff -puN fs/proc/proc_misc.c~procfs-constify-function-pointer-tables fs/proc/proc_misc.c
--- a/fs/proc/proc_misc.c~procfs-constify-function-pointer-tables
+++ a/fs/proc/proc_misc.c
@@ -222,7 +222,7 @@ static int meminfo_read_proc(char *page,
 #undef K
 }
 
-extern struct seq_operations fragmentation_op;
+extern const struct seq_operations fragmentation_op;
 static int fragmentation_open(struct inode *inode, struct file *file)
 {
 	(void)inode;
@@ -236,7 +236,7 @@ static const struct file_operations frag
 	.release	= seq_release,
 };
 
-extern struct seq_operations pagetypeinfo_op;
+extern const struct seq_operations pagetypeinfo_op;
 static int pagetypeinfo_open(struct inode *inode, struct file *file)
 {
 	return seq_open(file, &pagetypeinfo_op);
@@ -249,7 +249,7 @@ static const struct file_operations page
 	.release	= seq_release,
 };
 
-extern struct seq_operations zoneinfo_op;
+extern const struct seq_operations zoneinfo_op;
 static int zoneinfo_open(struct inode *inode, struct file *file)
 {
 	return seq_open(file, &zoneinfo_op);
@@ -274,7 +274,7 @@ static int version_read_proc(char *page,
 	return proc_calc_metrics(page, start, off, count, eof, len);
 }
 
-extern struct seq_operations cpuinfo_op;
+extern const struct seq_operations cpuinfo_op;
 static int cpuinfo_open(struct inode *inode, struct file *file)
 {
 	return seq_open(file, &cpuinfo_op);
@@ -327,7 +327,7 @@ static void devinfo_stop(struct seq_file
 	/* Nothing to do */
 }
 
-static struct seq_operations devinfo_ops = {
+static const struct seq_operations devinfo_ops = {
 	.start = devinfo_start,
 	.next  = devinfo_next,
 	.stop  = devinfo_stop,
@@ -346,7 +346,7 @@ static const struct file_operations proc
 	.release	= seq_release,
 };
 
-extern struct seq_operations vmstat_op;
+extern const struct seq_operations vmstat_op;
 static int vmstat_open(struct inode *inode, struct file *file)
 {
 	return seq_open(file, &vmstat_op);
@@ -377,7 +377,7 @@ static int stram_read_proc(char *page, c
 #endif
 
 #ifdef CONFIG_BLOCK
-extern struct seq_operations partitions_op;
+extern const struct seq_operations partitions_op;
 static int partitions_open(struct inode *inode, struct file *file)
 {
 	return seq_open(file, &partitions_op);
@@ -389,7 +389,7 @@ static const struct file_operations proc
 	.release	= seq_release,
 };
 
-extern struct seq_operations diskstats_op;
+extern const struct seq_operations diskstats_op;
 static int diskstats_open(struct inode *inode, struct file *file)
 {
 	return seq_open(file, &diskstats_op);
@@ -403,7 +403,7 @@ static const struct file_operations proc
 #endif
 
 #ifdef CONFIG_MODULES
-extern struct seq_operations modules_op;
+extern const struct seq_operations modules_op;
 static int modules_open(struct inode *inode, struct file *file)
 {
 	return seq_open(file, &modules_op);
@@ -430,7 +430,7 @@ static const struct file_operations proc
 };
 
 #ifdef CONFIG_DEBUG_SLAB_LEAK
-extern struct seq_operations slabstats_op;
+extern const struct seq_operations slabstats_op;
 static int slabstats_open(struct inode *inode, struct file *file)
 {
 	unsigned long *n = kzalloc(PAGE_SIZE, GFP_KERNEL);
@@ -604,7 +604,7 @@ static void int_seq_stop(struct seq_file
 }
 
 
-static struct seq_operations int_seq_ops = {
+static const struct seq_operations int_seq_ops = {
 	.start = int_seq_start,
 	.next  = int_seq_next,
 	.stop  = int_seq_stop,
diff -puN fs/proc/proc_sysctl.c~procfs-constify-function-pointer-tables fs/proc/proc_sysctl.c
--- a/fs/proc/proc_sysctl.c~procfs-constify-function-pointer-tables
+++ a/fs/proc/proc_sysctl.c
@@ -9,7 +9,7 @@
 
 static struct dentry_operations proc_sys_dentry_operations;
 static const struct file_operations proc_sys_file_operations;
-static struct inode_operations proc_sys_inode_operations;
+static const struct inode_operations proc_sys_inode_operations;
 
 static void proc_sys_refresh_inode(struct inode *inode, struct ctl_table *table)
 {
@@ -446,7 +446,7 @@ static const struct file_operations proc
 	.readdir	= proc_sys_readdir,
 };
 
-static struct inode_operations proc_sys_inode_operations = {
+static const struct inode_operations proc_sys_inode_operations = {
 	.lookup		= proc_sys_lookup,
 	.permission	= proc_sys_permission,
 	.setattr	= proc_sys_setattr,
diff -puN fs/proc/proc_tty.c~procfs-constify-function-pointer-tables fs/proc/proc_tty.c
--- a/fs/proc/proc_tty.c~procfs-constify-function-pointer-tables
+++ a/fs/proc/proc_tty.c
@@ -117,7 +117,7 @@ static void t_stop(struct seq_file *m, v
 	mutex_unlock(&tty_mutex);
 }
 
-static struct seq_operations tty_drivers_op = {
+static const struct seq_operations tty_drivers_op = {
 	.start	= t_start,
 	.next	= t_next,
 	.stop	= t_stop,
diff -puN fs/proc/task_mmu.c~procfs-constify-function-pointer-tables fs/proc/task_mmu.c
--- a/fs/proc/task_mmu.c~procfs-constify-function-pointer-tables
+++ a/fs/proc/task_mmu.c
@@ -182,7 +182,7 @@ static void m_stop(struct seq_file *m, v
 }
 
 static int do_maps_open(struct inode *inode, struct file *file,
-			struct seq_operations *ops)
+			const struct seq_operations *ops)
 {
 	struct proc_maps_private *priv;
 	int ret = -ENOMEM;
@@ -265,7 +265,7 @@ static int show_map(struct seq_file *m, 
 	return 0;
 }
 
-static struct seq_operations proc_pid_maps_op = {
+static const struct seq_operations proc_pid_maps_op = {
 	.start	= m_start,
 	.next	= m_next,
 	.stop	= m_stop,
@@ -400,7 +400,7 @@ static int show_smap(struct seq_file *m,
 	return ret;
 }
 
-static struct seq_operations proc_pid_smaps_op = {
+static const struct seq_operations proc_pid_smaps_op = {
 	.start	= m_start,
 	.next	= m_next,
 	.stop	= m_stop,
@@ -700,7 +700,7 @@ static int show_numa_map_checked(struct 
 	return show_numa_map(m, v);
 }
 
-static struct seq_operations proc_pid_numa_maps_op = {
+static const struct seq_operations proc_pid_numa_maps_op = {
         .start  = m_start,
         .next   = m_next,
         .stop   = m_stop,
diff -puN fs/proc/task_nommu.c~procfs-constify-function-pointer-tables fs/proc/task_nommu.c
--- a/fs/proc/task_nommu.c~procfs-constify-function-pointer-tables
+++ a/fs/proc/task_nommu.c
@@ -165,7 +165,7 @@ static void *m_next(struct seq_file *m, 
 	return vml ? vml->next : NULL;
 }
 
-static struct seq_operations proc_pid_maps_ops = {
+static const struct seq_operations proc_pid_maps_ops = {
 	.start	= m_start,
 	.next	= m_next,
 	.stop	= m_stop,
_

Patches currently in -mm which might be from jengelh@computergmbh.de are

git-kbuild.patch
git-net.patch
git-unionfs.patch
git-x86.patch
fs-fat-refine-chmod-checks.patch
documentation-about-unaligned-memory-access.patch
char-mxser-reorder-mxser_cardinfo-fields.patch
char-mxser-simplify-mxser_get_serial_info.patch
reiserfs-constify-function-pointer-tables.patch
procfs-constify-function-pointer-tables.patch
oss-constify-function-pointer-tables.patch
