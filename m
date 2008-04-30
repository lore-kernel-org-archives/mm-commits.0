From: akpm@linux-foundation.org
Subject: - kernel-use-non-racy-method-for-proc-entries-creation.patch removed from -mm tree
Date: Tue, 29 Apr 2008 22:47:29 -0700
Message-ID: <200804300547.m3U5lTE6029709@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54566 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760686AbYD3GMa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Apr 2008 02:12:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: den@openvz.org, adobriyan@gmail.com, ebiederm@xmission.com, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     kernel: use non-racy method for proc entries creation
has been removed from the -mm tree.  Its filename was
     kernel-use-non-racy-method-for-proc-entries-creation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: kernel: use non-racy method for proc entries creation
From: "Denis V. Lunev" <den@openvz.org>

Use proc_create()/proc_create_data() to make sure that ->proc_fops and ->data
be setup before gluing PDE to main tree.

Signed-off-by: Denis V. Lunev <den@openvz.org>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/configs.c          |    4 ++--
 kernel/dma.c              |    7 +------
 kernel/kallsyms.c         |    6 +-----
 kernel/latencytop.c       |    9 +--------
 kernel/lockdep_proc.c     |   16 ++++------------
 kernel/profile.c          |    4 ++--
 kernel/resource.c         |   10 ++--------
 kernel/sched_debug.c      |    5 +----
 kernel/time/timer_list.c  |    5 +----
 kernel/time/timer_stats.c |    5 +----
 10 files changed, 16 insertions(+), 55 deletions(-)

diff -puN kernel/configs.c~kernel-use-non-racy-method-for-proc-entries-creation kernel/configs.c
--- a/kernel/configs.c~kernel-use-non-racy-method-for-proc-entries-creation
+++ a/kernel/configs.c
@@ -79,11 +79,11 @@ static int __init ikconfig_init(void)
 	struct proc_dir_entry *entry;
 
 	/* create the current config file */
-	entry = create_proc_entry("config.gz", S_IFREG | S_IRUGO, NULL);
+	entry = proc_create("config.gz", S_IFREG | S_IRUGO, NULL,
+			    &ikconfig_file_ops);
 	if (!entry)
 		return -ENOMEM;
 
-	entry->proc_fops = &ikconfig_file_ops;
 	entry->size = kernel_config_data_size;
 
 	return 0;
diff -puN kernel/dma.c~kernel-use-non-racy-method-for-proc-entries-creation kernel/dma.c
--- a/kernel/dma.c~kernel-use-non-racy-method-for-proc-entries-creation
+++ a/kernel/dma.c
@@ -149,12 +149,7 @@ static const struct file_operations proc
 
 static int __init proc_dma_init(void)
 {
-	struct proc_dir_entry *e;
-
-	e = create_proc_entry("dma", 0, NULL);
-	if (e)
-		e->proc_fops = &proc_dma_operations;
-
+	proc_create("dma", 0, NULL, &proc_dma_operations);
 	return 0;
 }
 
diff -puN kernel/kallsyms.c~kernel-use-non-racy-method-for-proc-entries-creation kernel/kallsyms.c
--- a/kernel/kallsyms.c~kernel-use-non-racy-method-for-proc-entries-creation
+++ a/kernel/kallsyms.c
@@ -472,11 +472,7 @@ static const struct file_operations kall
 
 static int __init kallsyms_init(void)
 {
-	struct proc_dir_entry *entry;
-
-	entry = create_proc_entry("kallsyms", 0444, NULL);
-	if (entry)
-		entry->proc_fops = &kallsyms_operations;
+	proc_create("kallsyms", 0444, NULL, &kallsyms_operations);
 	return 0;
 }
 __initcall(kallsyms_init);
diff -puN kernel/latencytop.c~kernel-use-non-racy-method-for-proc-entries-creation kernel/latencytop.c
--- a/kernel/latencytop.c~kernel-use-non-racy-method-for-proc-entries-creation
+++ a/kernel/latencytop.c
@@ -233,14 +233,7 @@ static struct file_operations lstats_fop
 
 static int __init init_lstats_procfs(void)
 {
-	struct proc_dir_entry *pe;
-
-	pe = create_proc_entry("latency_stats", 0644, NULL);
-	if (!pe)
-		return -ENOMEM;
-
-	pe->proc_fops = &lstats_fops;
-
+	proc_create("latency_stats", 0644, NULL, &lstats_fops);
 	return 0;
 }
 __initcall(init_lstats_procfs);
diff -puN kernel/lockdep_proc.c~kernel-use-non-racy-method-for-proc-entries-creation kernel/lockdep_proc.c
--- a/kernel/lockdep_proc.c~kernel-use-non-racy-method-for-proc-entries-creation
+++ a/kernel/lockdep_proc.c
@@ -660,20 +660,12 @@ static const struct file_operations proc
 
 static int __init lockdep_proc_init(void)
 {
-	struct proc_dir_entry *entry;
-
-	entry = create_proc_entry("lockdep", S_IRUSR, NULL);
-	if (entry)
-		entry->proc_fops = &proc_lockdep_operations;
-
-	entry = create_proc_entry("lockdep_stats", S_IRUSR, NULL);
-	if (entry)
-		entry->proc_fops = &proc_lockdep_stats_operations;
+	proc_create("lockdep", S_IRUSR, NULL, &proc_lockdep_operations);
+	proc_create("lockdep_stats", S_IRUSR, NULL,
+		    &proc_lockdep_stats_operations);
 
 #ifdef CONFIG_LOCK_STAT
-	entry = create_proc_entry("lock_stat", S_IRUSR, NULL);
-	if (entry)
-		entry->proc_fops = &proc_lock_stat_operations;
+	proc_create("lock_stat", S_IRUSR, NULL, &proc_lock_stat_operations);
 #endif
 
 	return 0;
diff -puN kernel/profile.c~kernel-use-non-racy-method-for-proc-entries-creation kernel/profile.c
--- a/kernel/profile.c~kernel-use-non-racy-method-for-proc-entries-creation
+++ a/kernel/profile.c
@@ -587,10 +587,10 @@ static int __init create_proc_profile(vo
 		return 0;
 	if (create_hash_tables())
 		return -1;
-	entry = create_proc_entry("profile", S_IWUSR | S_IRUGO, NULL);
+	entry = proc_create("profile", S_IWUSR | S_IRUGO,
+			    NULL, &proc_profile_operations);
 	if (!entry)
 		return 0;
-	entry->proc_fops = &proc_profile_operations;
 	entry->size = (1+prof_len) * sizeof(atomic_t);
 	hotcpu_notifier(profile_cpu_callback, 0);
 	return 0;
diff -puN kernel/resource.c~kernel-use-non-racy-method-for-proc-entries-creation kernel/resource.c
--- a/kernel/resource.c~kernel-use-non-racy-method-for-proc-entries-creation
+++ a/kernel/resource.c
@@ -131,14 +131,8 @@ static const struct file_operations proc
 
 static int __init ioresources_init(void)
 {
-	struct proc_dir_entry *entry;
-
-	entry = create_proc_entry("ioports", 0, NULL);
-	if (entry)
-		entry->proc_fops = &proc_ioports_operations;
-	entry = create_proc_entry("iomem", 0, NULL);
-	if (entry)
-		entry->proc_fops = &proc_iomem_operations;
+	proc_create("ioports", 0, NULL, &proc_ioports_operations);
+	proc_create("iomem", 0, NULL, &proc_iomem_operations);
 	return 0;
 }
 __initcall(ioresources_init);
diff -puN kernel/sched_debug.c~kernel-use-non-racy-method-for-proc-entries-creation kernel/sched_debug.c
--- a/kernel/sched_debug.c~kernel-use-non-racy-method-for-proc-entries-creation
+++ a/kernel/sched_debug.c
@@ -277,12 +277,9 @@ static int __init init_sched_debug_procf
 {
 	struct proc_dir_entry *pe;
 
-	pe = create_proc_entry("sched_debug", 0644, NULL);
+	pe = proc_create("sched_debug", 0644, NULL, &sched_debug_fops);
 	if (!pe)
 		return -ENOMEM;
-
-	pe->proc_fops = &sched_debug_fops;
-
 	return 0;
 }
 
diff -puN kernel/time/timer_list.c~kernel-use-non-racy-method-for-proc-entries-creation kernel/time/timer_list.c
--- a/kernel/time/timer_list.c~kernel-use-non-racy-method-for-proc-entries-creation
+++ a/kernel/time/timer_list.c
@@ -278,12 +278,9 @@ static int __init init_timer_list_procfs
 {
 	struct proc_dir_entry *pe;
 
-	pe = create_proc_entry("timer_list", 0644, NULL);
+	pe = proc_create("timer_list", 0644, NULL, &timer_list_fops);
 	if (!pe)
 		return -ENOMEM;
-
-	pe->proc_fops = &timer_list_fops;
-
 	return 0;
 }
 __initcall(init_timer_list_procfs);
diff -puN kernel/time/timer_stats.c~kernel-use-non-racy-method-for-proc-entries-creation kernel/time/timer_stats.c
--- a/kernel/time/timer_stats.c~kernel-use-non-racy-method-for-proc-entries-creation
+++ a/kernel/time/timer_stats.c
@@ -415,12 +415,9 @@ static int __init init_tstats_procfs(voi
 {
 	struct proc_dir_entry *pe;
 
-	pe = create_proc_entry("timer_stats", 0644, NULL);
+	pe = proc_create("timer_stats", 0644, NULL, &tstats_fops);
 	if (!pe)
 		return -ENOMEM;
-
-	pe->proc_fops = &tstats_fops;
