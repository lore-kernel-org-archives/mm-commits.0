From: akpm@linux-foundation.org
Subject: + maps2-make-proc-pid-smaps-optional-under-config_embeddedpatch.patch added to -mm tree
Date: Thu, 19 Jul 2007 17:54:33 -0700
Message-ID: <200707200054.l6K0sXAI031913@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45016 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753871AbXGTAz1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Jul 2007 20:55:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rusty@rustcorp.com.au, mpm@selenic.com


The patch titled
     maps2: make proc pid smaps optional under CONFIG_EMBEDDED
has been added to the -mm tree.  Its filename is
     maps2-make-proc-pid-smaps-optional-under-config_embeddedpatch.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: maps2: make proc pid smaps optional under CONFIG_EMBEDDED
From: Rusty Russell <rusty@rustcorp.com.au>

Merge the three config options PROC_SMAPS/PROC_CLEAR_REFS/PROC_PAGEMAP
and report the approximate memory usage (i386 SMP).

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Cc: Matt Mackall <mpm@selenic.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/base.c      |   12 +-----
 fs/proc/proc_misc.c |    6 +--
 fs/proc/task_mmu.c  |   76 +++++++++++++++++++-----------------------
 init/Kconfig        |   32 +++--------------
 4 files changed, 48 insertions(+), 78 deletions(-)

diff -puN fs/proc/base.c~maps2-make-proc-pid-smaps-optional-under-config_embeddedpatch fs/proc/base.c
--- a/fs/proc/base.c~maps2-make-proc-pid-smaps-optional-under-config_embeddedpatch
+++ a/fs/proc/base.c
@@ -2033,13 +2033,9 @@ static const struct pid_entry tgid_base_
 	REG("mounts",     S_IRUGO, mounts),
 	REG("mountstats", S_IRUSR, mountstats),
 #ifdef CONFIG_MMU
-#ifdef CONFIG_PROC_CLEAR_REFS
+#ifdef CONFIG_PROC_PAGE_MONITOR
 	REG("clear_refs", S_IWUSR, clear_refs),
-#endif
-#ifdef CONFIG_PROC_SMAPS
 	REG("smaps",      S_IRUGO, smaps),
-#endif
-#ifdef CONFIG_PROC_PAGEMAP
 	REG("pagemap",    S_IRUSR, pagemap),
 #endif
 #endif
@@ -2326,13 +2322,9 @@ static const struct pid_entry tid_base_s
 	LNK("exe",       exe),
 	REG("mounts",    S_IRUGO, mounts),
 #ifdef CONFIG_MMU
-#ifdef CONFIG_PROC_CLEAR_REFS
+#ifdef CONFIG_PROC_PAGE_MONITOR
 	REG("clear_refs", S_IWUSR, clear_refs),
-#endif
-#ifdef CONFIG_PROC_SMAPS
 	REG("smaps",     S_IRUGO, smaps),
-#endif
-#ifdef CONFIG_PROC_PAGEMAP
 	REG("pagemap",    S_IRUSR, pagemap),
 #endif
 #endif
diff -puN fs/proc/proc_misc.c~maps2-make-proc-pid-smaps-optional-under-config_embeddedpatch fs/proc/proc_misc.c
--- a/fs/proc/proc_misc.c~maps2-make-proc-pid-smaps-optional-under-config_embeddedpatch
+++ a/fs/proc/proc_misc.c
@@ -671,7 +671,7 @@ static const struct file_operations proc
 };
 #endif
 
-#ifdef CONFIG_PROC_KPAGEMAP
+#ifdef CONFIG_PROC_PAGE_MONITOR
 #define KPMSIZE (sizeof(unsigned long) * 2)
 #define KPMMASK (KPMSIZE - 1)
 /* /proc/kpagemap - an array exposing page flags and counts
@@ -698,7 +698,7 @@ static ssize_t kpagemap_read(struct file
 	int chunk, i;
 
 	pfn = src / KPMSIZE - 1;
-	count = min_t(size_t, count, ((max_pfn + 1) * KPMSIZE) - src);
+	count = min(count, ((max_pfn + 1) * KPMSIZE) - src);
 	if (src & KPMMASK || count & KPMMASK)
 		return -EIO;
 
@@ -836,7 +836,7 @@ void __init proc_misc_init(void)
 				(size_t)high_memory - PAGE_OFFSET + PAGE_SIZE;
 	}
 #endif
-#ifdef CONFIG_PROC_KPAGEMAP
+#ifdef CONFIG_PROC_PAGE_MONITOR
 	proc_kpagemap = create_proc_entry("kpagemap", S_IRUSR, NULL);
 	if (proc_kpagemap)
 		proc_kpagemap->proc_fops = &proc_kpagemap_operations;
diff -puN fs/proc/task_mmu.c~maps2-make-proc-pid-smaps-optional-under-config_embeddedpatch fs/proc/task_mmu.c
--- a/fs/proc/task_mmu.c~maps2-make-proc-pid-smaps-optional-under-config_embeddedpatch
+++ a/fs/proc/task_mmu.c
@@ -315,7 +315,7 @@ const struct file_operations proc_maps_o
 	.release	= seq_release_private,
 };
 
-#ifdef CONFIG_PROC_SMAPS
+#ifdef CONFIG_PROC_PAGE_MONITOR
 struct mem_size_stats
 {
 	unsigned long resident;
@@ -429,9 +429,7 @@ const struct file_operations proc_smaps_
 	.llseek		= seq_lseek,
 	.release	= seq_release_private,
 };
-#endif
 
-#ifdef CONFIG_PROC_CLEAR_REFS
 static int clear_refs_pte_range(pmd_t *pmd, unsigned long addr,
 				unsigned long end, void *private)
 {
@@ -501,43 +499,7 @@ static ssize_t clear_refs_write(struct f
 const struct file_operations proc_clear_refs_operations = {
 	.write		= clear_refs_write,
 };
-#endif
-
-#ifdef CONFIG_NUMA
-extern int show_numa_map(struct seq_file *m, void *v);
-
-static int show_numa_map_checked(struct seq_file *m, void *v)
-{
-	struct proc_maps_private *priv = m->private;
-	struct task_struct *task = priv->task;
-
-	if (maps_protect && !ptrace_may_attach(task))
-		return -EACCES;
-
-	return show_numa_map(m, v);
-}
-
-static struct seq_operations proc_pid_numa_maps_op = {
-        .start  = m_start,
-        .next   = m_next,
-        .stop   = m_stop,
-        .show   = show_numa_map_checked
-};
-
-static int numa_maps_open(struct inode *inode, struct file *file)
-{
-	return do_maps_open(inode, file, &proc_pid_numa_maps_op);
-}
-
-const struct file_operations proc_numa_maps_operations = {
-	.open		= numa_maps_open,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-	.release	= seq_release_private,
-};
-#endif
 
-#ifdef CONFIG_PROC_PAGEMAP
 struct pagemapread {
 	struct mm_struct *mm;
 	unsigned long next;
@@ -744,4 +706,38 @@ const struct file_operations proc_pagema
 	.llseek		= mem_lseek, /* borrow this */
 	.read		= pagemap_read,
 };
-#endif
+#endif /* CONFIG_PROC_PAGE_MONITOR */
+
+#ifdef CONFIG_NUMA
+extern int show_numa_map(struct seq_file *m, void *v);
+
+static int show_numa_map_checked(struct seq_file *m, void *v)
+{
+	struct proc_maps_private *priv = m->private;
+	struct task_struct *task = priv->task;
+
+	if (maps_protect && !ptrace_may_attach(task))
+		return -EACCES;
+
+	return show_numa_map(m, v);
+}
+
+static struct seq_operations proc_pid_numa_maps_op = {
+        .start  = m_start,
+        .next   = m_next,
+        .stop   = m_stop,
+        .show   = show_numa_map_checked
+};
+
+static int numa_maps_open(struct inode *inode, struct file *file)
+{
+	return do_maps_open(inode, file, &proc_pid_numa_maps_op);
+}
+
+const struct file_operations proc_numa_maps_operations = {
+	.open		= numa_maps_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= seq_release_private,
+};
+#endif /* CONFIG_NUMA */
diff -puN init/Kconfig~maps2-make-proc-pid-smaps-optional-under-config_embeddedpatch init/Kconfig
--- a/init/Kconfig~maps2-make-proc-pid-smaps-optional-under-config_embeddedpatch
+++ a/init/Kconfig
@@ -579,32 +579,14 @@ config SLOB
 
 endchoice
 
-config PROC_SMAPS
+config PROC_PAGE_MONITOR
 	default y
-	bool "Enable /proc/pid/smaps support" if EMBEDDED && PROC_FS && MMU
+	bool "Enable /proc page monitoring" if EMBEDDED && PROC_FS && MMU
 	help
-	  The /proc/pid/smaps interface reports a process's private and
-          shared memory per mapping. Disabling this interface will reduce
-          the size of the kernel for small machines.
-
-config PROC_CLEAR_REFS
-	default y
-	bool "Enable /proc/pid/clear_refs support" if EMBEDDED && PROC_FS && MMU
-	help
-	  The /proc/pid/clear_refs interface allows clearing the
-          referenced bits on a process's memory maps to allow monitoring
-          working set size. Disabling this interface will reduce
-          the size of the kernel for small machines.
-
-config PROC_PAGEMAP
-	default y
-	bool "Enable /proc/pid/pagemap support" if EMBEDDED && PROC_FS && MMU
-	help
-	  The /proc/pid/pagemap interface allows reading the
-          kernel's virtual memory to page frame mapping to determine which
-          individual pages a process has mapped and which pages it shares
-          with other processes. Disabling this interface will reduce the
-          size of the kernel for small machines.
+	  Various /proc files exist to monitor process memory utilization:
+	  /proc/pid/smaps, /proc/pid/clear_refs and /proc/pid/pagemap.
+	  Disabling these interfaces will reduce the size of the kernel by
+	  approximately 4kb.
 
 config PROC_KPAGEMAP
 	default y
@@ -613,7 +595,7 @@ config PROC_KPAGEMAP
 	  The /proc/pid/kpagemap interface allows reading the
           kernel's per-page flag and usage counts to gather precise
           information on page-level memory usage. Disabling this interface
-          will reduce the size of the kernel for small machines.
+          will reduce the size of the kernel by around 600 bytes.
 
 endmenu		# General setup
 
_

Patches currently in -mm which might be from rusty@rustcorp.com.au are

origin.patch
git-kbuild.patch
git-kvm.patch
lguest-the-host-code-lguest-vs-clockevents-fix-resume-logic.patch
mmaps2-vma-out-of-mem_size_stats.patch
maps2-make-proc-pid-smaps-optional-under-config_embeddedpatch.patch
mm-clean-up-and-kernelify-shrinker-registration-reiser4.patch
