From: akpm@linux-foundation.org
Subject: + sched-debug-cleanup-the-sysctl-registration-code.patch added to -mm tree
Date: Tue, 07 Aug 2007 19:30:10 -0700
Message-ID: <200708080230.l782UAuK016698@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40441 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757124AbXHHCbJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 Aug 2007 22:31:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ebiederm@xmission.com, mingo@elte.hu, nickpiggin@yahoo.com.au


The patch titled
     sched debug: clean up the sysctl registration code.
has been added to the -mm tree.  Its filename is
     sched-debug-cleanup-the-sysctl-registration-code.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: sched debug: clean up the sysctl registration code.
From: Eric W. Biederman <ebiederm@xmission.com>

- Use C99 initializers (struct ctl_table may change again)
- We don't need to set ctl_name anywhere to anything besides CTL_UNNUMBERED
- memset after kmalloc isn't needed if we just use kzalloc
- Directories under /proc/sys should always be 0555.
  User space programs can not write to them.

Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sched.c |   56 ++++++++++++++++++++++++++---------------------
 1 file changed, 32 insertions(+), 24 deletions(-)

diff -puN kernel/sched.c~sched-debug-cleanup-the-sysctl-registration-code kernel/sched.c
--- a/kernel/sched.c~sched-debug-cleanup-the-sysctl-registration-code
+++ a/kernel/sched.c
@@ -5208,32 +5208,40 @@ static void migrate_dead_tasks(unsigned 
 #if defined(CONFIG_SCHED_DEBUG) && defined(CONFIG_SYSCTL)
 
 static struct ctl_table sd_ctl_dir[] = {
-	{CTL_UNNUMBERED, "sched_domain", NULL, 0, 0755, NULL, },
-	{0,},
+	{
+		.ctl_name 	= CTL_UNNUMBERED,
+		.procname	= "sched_domain",
+		.mode		= 0555,
+	},
+	{}
 };
 
 static struct ctl_table sd_ctl_root[] = {
-	{CTL_UNNUMBERED, "kernel", NULL, 0, 0755, sd_ctl_dir, },
-	{0,},
+	{
+		.ctl_name	= CTL_UNNUMBERED,
+		.procname	= "kernel",
+		.mode		= 0555,
+		.child		= sd_ctl_dir,
+	},
+	{}
 };
 
 static struct ctl_table *sd_alloc_ctl_entry(int n)
 {
 	struct ctl_table *entry =
-		kmalloc(n * sizeof(struct ctl_table), GFP_KERNEL);
+		kzalloc(n * sizeof(struct ctl_table), GFP_KERNEL);
 
 	BUG_ON(!entry);
-	memset(entry, 0, n * sizeof(struct ctl_table));
 
 	return entry;
 }
 
 static void
-set_table_entry(struct ctl_table *entry, int ctl_name,
+set_table_entry(struct ctl_table *entry,
 		const char *procname, void *data, int maxlen,
 		mode_t mode, proc_handler *proc_handler)
 {
-	entry->ctl_name = ctl_name;
+	entry->ctl_name = CTL_UNNUMBERED;
 	entry->procname = procname;
 	entry->data = data;
 	entry->maxlen = maxlen;
@@ -5246,34 +5254,34 @@ sd_alloc_ctl_domain_table(struct sched_d
 {
 	struct ctl_table *table = sd_alloc_ctl_entry(14);
 
-	set_table_entry(&table[0], 1, "min_interval", &sd->min_interval,
+	set_table_entry(&table[0], "min_interval", &sd->min_interval,
 		sizeof(long), 0644, proc_doulongvec_minmax);
-	set_table_entry(&table[1], 2, "max_interval", &sd->max_interval,
+	set_table_entry(&table[1], "max_interval", &sd->max_interval,
 		sizeof(long), 0644, proc_doulongvec_minmax);
-	set_table_entry(&table[2], 3, "busy_idx", &sd->busy_idx,
+	set_table_entry(&table[2], "busy_idx", &sd->busy_idx,
 		sizeof(int), 0644, proc_dointvec_minmax);
-	set_table_entry(&table[3], 4, "idle_idx", &sd->idle_idx,
+	set_table_entry(&table[3], "idle_idx", &sd->idle_idx,
 		sizeof(int), 0644, proc_dointvec_minmax);
-	set_table_entry(&table[4], 5, "newidle_idx", &sd->newidle_idx,
+	set_table_entry(&table[4], "newidle_idx", &sd->newidle_idx,
 		sizeof(int), 0644, proc_dointvec_minmax);
-	set_table_entry(&table[5], 6, "wake_idx", &sd->wake_idx,
+	set_table_entry(&table[5], "wake_idx", &sd->wake_idx,
 		sizeof(int), 0644, proc_dointvec_minmax);
-	set_table_entry(&table[6], 7, "forkexec_idx", &sd->forkexec_idx,
+	set_table_entry(&table[6], "forkexec_idx", &sd->forkexec_idx,
 		sizeof(int), 0644, proc_dointvec_minmax);
-	set_table_entry(&table[7], 8, "busy_factor", &sd->busy_factor,
+	set_table_entry(&table[7], "busy_factor", &sd->busy_factor,
 		sizeof(int), 0644, proc_dointvec_minmax);
-	set_table_entry(&table[8], 9, "imbalance_pct", &sd->imbalance_pct,
+	set_table_entry(&table[8], "imbalance_pct", &sd->imbalance_pct,
 		sizeof(int), 0644, proc_dointvec_minmax);
-	set_table_entry(&table[10], 11, "cache_nice_tries",
+	set_table_entry(&table[10], "cache_nice_tries",
 		&sd->cache_nice_tries,
 		sizeof(int), 0644, proc_dointvec_minmax);
-	set_table_entry(&table[12], 13, "flags", &sd->flags,
+	set_table_entry(&table[12], "flags", &sd->flags,
 		sizeof(int), 0644, proc_dointvec_minmax);
 
 	return table;
 }
 
-static ctl_table *sd_alloc_ctl_cpu_table(int cpu)
+static struct ctl_table *sd_alloc_ctl_cpu_table(int cpu)
 {
 	struct ctl_table *entry, *table;
 	struct sched_domain *sd;
@@ -5287,9 +5295,9 @@ static ctl_table *sd_alloc_ctl_cpu_table
 	i = 0;
 	for_each_domain(cpu, sd) {
 		snprintf(buf, 32, "domain%d", i);
-		entry->ctl_name = i + 1;
+		entry->ctl_name = CTL_UNNUMBERED;
 		entry->procname = kstrdup(buf, GFP_KERNEL);
-		entry->mode = 0755;
+		entry->mode = 0555;
 		entry->child = sd_alloc_ctl_domain_table(sd);
 		entry++;
 		i++;
@@ -5308,9 +5316,9 @@ static void init_sched_domain_sysctl(voi
 
 	for (i = 0; i < cpu_num; i++, entry++) {
 		snprintf(buf, 32, "cpu%d", i);
-		entry->ctl_name = i + 1;
+		entry->ctl_name = CTL_UNNUMBERED;
 		entry->procname = kstrdup(buf, GFP_KERNEL);
-		entry->mode = 0755;
+		entry->mode = 0555;
 		entry->child = sd_alloc_ctl_cpu_table(i);
 	}
 	sd_sysctl_header = register_sysctl_table(sd_ctl_root);
_

Patches currently in -mm which might be from ebiederm@xmission.com are

remove-unused-struct-proc_dir_entryset.patch
dvb_en_50221-convert-to-kthread-api.patch
sched-debug-cleanup-the-sysctl-registration-code.patch
kdump-fix-apic-shutdown-sequence.patch
x86_64-remove-sync_arb_ids.patch
x86_64-clear-io_apic-before-enabing-apic-error-vector.patch
clone-flag-clone_parent_tidptr-leaves-invalid-results-in-memory.patch
handle-the-multi-threaded-inits-exit-properly.patch
cpuset-zero-malloc-revert-the-old-cpuset-fix.patch
task-containersv11-basic-task-container-framework.patch
task-containersv11-add-tasks-file-interface.patch
task-containersv11-add-fork-exit-hooks.patch
task-containersv11-add-container_clone-interface.patch
task-containersv11-add-procfs-interface.patch
task-containersv11-shared-container-subsystem-group-arrays.patch
task-containersv11-automatic-userspace-notification-of-idle-containers.patch
task-containersv11-make-cpusets-a-client-of-containers.patch
task-containersv11-example-cpu-accounting-subsystem.patch
task-containersv11-simple-task-container-debug-info-subsystem.patch
pid-namespaces-round-up-the-api.patch
pid-namespaces-make-get_pid_ns-return-the-namespace-itself.patch
pid-namespaces-dynamic-kmem-cache-allocator-for-pid-namespaces.patch
pid-namespaces-dynamic-kmem-cache-allocator-for-pid-namespaces-fix.patch
pid-namespaces-define-and-use-task_active_pid_ns-wrapper.patch
pid-namespaces-rename-child_reaper-function.patch
pid-namespaces-use-task_pid-to-find-leaders-pid.patch
pid-namespaces-define-is_global_init-and-is_container_init.patch
pid-namespaces-move-alloc_pid-to-copy_process.patch
