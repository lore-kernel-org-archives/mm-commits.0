From: akpm@linux-foundation.org
Subject: - proc-switch-to-proc_create.patch removed from -mm tree
Date: Tue, 29 Apr 2008 22:45:45 -0700
Message-ID: <200804300545.m3U5jjRq029538@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35331 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757808AbYD3Fqu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Apr 2008 01:46:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@sw.ru, mm-commits@vger.kernel.org


The patch titled
     proc: switch to proc_create()
has been removed from the -mm tree.  Its filename was
     proc-switch-to-proc_create.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: proc: switch to proc_create()
From: Alexey Dobriyan <adobriyan@sw.ru>

Signed-off-by: Alexey Dobriyan <adobriyan@sw.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/internal.h  |    2 -
 fs/proc/nommu.c     |    2 -
 fs/proc/proc_misc.c |   68 ++++++++++++++----------------------------
 fs/proc/proc_tty.c  |    5 ---
 4 files changed, 25 insertions(+), 52 deletions(-)

diff -puN fs/proc/internal.h~proc-switch-to-proc_create fs/proc/internal.h
--- a/fs/proc/internal.h~proc-switch-to-proc_create
+++ a/fs/proc/internal.h
@@ -46,8 +46,6 @@ extern int nommu_vma_show(struct seq_fil
 
 extern int maps_protect;
 
-extern void create_seq_entry(char *name, mode_t mode,
-				const struct file_operations *f);
 extern int proc_tid_stat(struct seq_file *m, struct pid_namespace *ns,
 				struct pid *pid, struct task_struct *task);
 extern int proc_tgid_stat(struct seq_file *m, struct pid_namespace *ns,
diff -puN fs/proc/nommu.c~proc-switch-to-proc_create fs/proc/nommu.c
--- a/fs/proc/nommu.c~proc-switch-to-proc_create
+++ a/fs/proc/nommu.c
@@ -137,7 +137,7 @@ static const struct file_operations proc
 
 static int __init proc_nommu_init(void)
 {
-	create_seq_entry("maps", S_IRUGO, &proc_nommu_vma_list_operations);
+	proc_create("maps", S_IRUGO, NULL, &proc_nommu_vma_list_operations);
 	return 0;
 }
 
diff -puN fs/proc/proc_misc.c~proc-switch-to-proc_create fs/proc/proc_misc.c
--- a/fs/proc/proc_misc.c~proc-switch-to-proc_create
+++ a/fs/proc/proc_misc.c
@@ -826,14 +826,6 @@ static struct file_operations proc_kpage
 
 struct proc_dir_entry *proc_root_kcore;
 
-void create_seq_entry(char *name, mode_t mode, const struct file_operations *f)
-{
-	struct proc_dir_entry *entry;
-	entry = create_proc_entry(name, mode, NULL);
-	if (entry)
-		entry->proc_fops = f;
-}
-
 void __init proc_misc_init(void)
 {
 	static struct {
@@ -862,66 +854,52 @@ void __init proc_misc_init(void)
 
 	/* And now for trickier ones */
 #ifdef CONFIG_PRINTK
-	{
-		struct proc_dir_entry *entry;
-		entry = create_proc_entry("kmsg", S_IRUSR, &proc_root);
-		if (entry)
-			entry->proc_fops = &proc_kmsg_operations;
-	}
-#endif
-	create_seq_entry("locks", 0, &proc_locks_operations);
-	create_seq_entry("devices", 0, &proc_devinfo_operations);
-	create_seq_entry("cpuinfo", 0, &proc_cpuinfo_operations);
+	proc_create("kmsg", S_IRUSR, &proc_root, &proc_kmsg_operations);
+#endif
+	proc_create("locks", 0, NULL, &proc_locks_operations);
+	proc_create("devices", 0, NULL, &proc_devinfo_operations);
+	proc_create("cpuinfo", 0, NULL, &proc_cpuinfo_operations);
 #ifdef CONFIG_BLOCK
-	create_seq_entry("partitions", 0, &proc_partitions_operations);
+	proc_create("partitions", 0, NULL, &proc_partitions_operations);
 #endif
-	create_seq_entry("stat", 0, &proc_stat_operations);
-	create_seq_entry("interrupts", 0, &proc_interrupts_operations);
+	proc_create("stat", 0, NULL, &proc_stat_operations);
+	proc_create("interrupts", 0, NULL, &proc_interrupts_operations);
 #ifdef CONFIG_SLABINFO
-	create_seq_entry("slabinfo",S_IWUSR|S_IRUGO,&proc_slabinfo_operations);
+	proc_create("slabinfo",S_IWUSR|S_IRUGO,NULL,&proc_slabinfo_operations);
 #ifdef CONFIG_DEBUG_SLAB_LEAK
-	create_seq_entry("slab_allocators", 0 ,&proc_slabstats_operations);
+	proc_create("slab_allocators", 0, NULL, &proc_slabstats_operations);
 #endif
 #endif
 #ifdef CONFIG_MMU
 	proc_create("vmallocinfo", S_IRUSR, NULL, &proc_vmalloc_operations);
 #endif
-	create_seq_entry("buddyinfo",S_IRUGO, &fragmentation_file_operations);
-	create_seq_entry("pagetypeinfo", S_IRUGO, &pagetypeinfo_file_ops);
-	create_seq_entry("vmstat",S_IRUGO, &proc_vmstat_file_operations);
-	create_seq_entry("zoneinfo",S_IRUGO, &proc_zoneinfo_file_operations);
+	proc_create("buddyinfo", S_IRUGO, NULL, &fragmentation_file_operations);
+	proc_create("pagetypeinfo", S_IRUGO, NULL, &pagetypeinfo_file_ops);
+	proc_create("vmstat", S_IRUGO, NULL, &proc_vmstat_file_operations);
+	proc_create("zoneinfo", S_IRUGO, NULL, &proc_zoneinfo_file_operations);
 #ifdef CONFIG_BLOCK
-	create_seq_entry("diskstats", 0, &proc_diskstats_operations);
+	proc_create("diskstats", 0, NULL, &proc_diskstats_operations);
 #endif
 #ifdef CONFIG_MODULES
-	create_seq_entry("modules", 0, &proc_modules_operations);
+	proc_create("modules", 0, NULL, &proc_modules_operations);
 #endif
 #ifdef CONFIG_SCHEDSTATS
-	create_seq_entry("schedstat", 0, &proc_schedstat_operations);
+	proc_create("schedstat", 0, NULL, &proc_schedstat_operations);
 #endif
 #ifdef CONFIG_PROC_KCORE
-	proc_root_kcore = create_proc_entry("kcore", S_IRUSR, NULL);
-	if (proc_root_kcore) {
-		proc_root_kcore->proc_fops = &proc_kcore_operations;
+	proc_root_kcore = proc_create("kcore", S_IRUSR, NULL, &proc_kcore_operations);
+	if (proc_root_kcore)
 		proc_root_kcore->size =
 				(size_t)high_memory - PAGE_OFFSET + PAGE_SIZE;
-	}
 #endif
 #ifdef CONFIG_PROC_PAGE_MONITOR
-	create_seq_entry("kpagecount", S_IRUSR, &proc_kpagecount_operations);
-	create_seq_entry("kpageflags", S_IRUSR, &proc_kpageflags_operations);
+	proc_create("kpagecount", S_IRUSR, NULL, &proc_kpagecount_operations);
+	proc_create("kpageflags", S_IRUSR, NULL, &proc_kpageflags_operations);
 #endif
 #ifdef CONFIG_PROC_VMCORE
-	proc_vmcore = create_proc_entry("vmcore", S_IRUSR, NULL);
-	if (proc_vmcore)
-		proc_vmcore->proc_fops = &proc_vmcore_operations;
+	proc_vmcore = proc_create("vmcore", S_IRUSR, NULL, &proc_vmcore_operations);
 #endif
 #ifdef CONFIG_MAGIC_SYSRQ
-	{
-		struct proc_dir_entry *entry;
-		entry = create_proc_entry("sysrq-trigger", S_IWUSR, NULL);
-		if (entry)
-			entry->proc_fops = &proc_sysrq_trigger_operations;
-	}
+	proc_create("sysrq-trigger", S_IWUSR, NULL, &proc_sysrq_trigger_operations);
 #endif
 }
diff -puN fs/proc/proc_tty.c~proc-switch-to-proc_create fs/proc/proc_tty.c
--- a/fs/proc/proc_tty.c~proc-switch-to-proc_create
+++ a/fs/proc/proc_tty.c
@@ -214,7 +214,6 @@ void proc_tty_unregister_driver(struct t
  */
 void __init proc_tty_init(void)
 {
-	struct proc_dir_entry *entry;
 	if (!proc_mkdir("tty", NULL))
 		return;
 	proc_tty_ldisc = proc_mkdir("tty/ldisc", NULL);
@@ -227,7 +226,5 @@ void __init proc_tty_init(void)
 	proc_tty_driver = proc_mkdir_mode("tty/driver", S_IRUSR | S_IXUSR, NULL);
 
 	create_proc_read_entry("tty/ldiscs", 0, NULL, tty_ldiscs_read_proc, NULL);
-	entry = create_proc_entry("tty/drivers", 0, NULL);
-	if (entry)
-		entry->proc_fops = &proc_tty_drivers_operations;
+	proc_create("tty/drivers", 0, NULL, &proc_tty_drivers_operations);
 }
_

Patches currently in -mm which might be from adobriyan@sw.ru are

origin.patch
single_open-seq_release-leak-diagnostics.patch

