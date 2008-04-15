From: akpm@linux-foundation.org
Subject: + kernel-use-non-racy-method-for-proc-entries-creation.patch added to -mm tree
Date: Tue, 15 Apr 2008 16:56:44 -0700
Message-ID: <200804152356.m3FNujRU022569@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46333 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753667AbYDOX47 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 15 Apr 2008 19:56:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: den@openvz.org, adobriyan@gmail.com, ebiederm@xmission.com, mingo@elte.hu


The patch titled
     kernel: use non-racy method for proc entries creation
has been added to the -mm tree.  Its filename is
     kernel-use-non-racy-method-for-proc-entries-creation.patch

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
@@ -588,10 +588,10 @@ static int __init create_proc_profile(vo
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
@@ -248,12 +248,9 @@ static int __init init_sched_debug_procf
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
-
 	return 0;
 }
 __initcall(init_tstats_procfs);
_

Patches currently in -mm which might be from den@openvz.org are

git-net.patch
proc-introduce-proc_create_data-to-setup-de-data.patch
nfsd-use-proc_create-to-setup-de-proc_fops.patch
nfs-use-proc_create-to-setup-de-proc_fops.patch
afs-use-non-racy-method-for-proc-entries-creation.patch
ext4-use-non-racy-method-for-proc-entries-creation.patch
reiserfs-use-non-racy-method-for-proc-entries-creation.patch
jbd2-use-non-racy-method-for-proc-entries-creation.patch
sysvipc-use-non-racy-method-for-proc-entries-creation.patch
mm-use-non-racy-method-for-proc-swaps-creation.patch
sound-use-non-racy-method-for-proc-driver-snd-page-alloc-creation.patch
zorro-use-non-racy-method-for-proc-entries-creation.patch
samples-use-non-racy-method-for-proc-marker-example-creation.patch
scsi-use-non-racy-method-for-proc-entries-creation.patch
usb-use-non-racy-method-for-proc-entries-creation.patch
s390-use-non-racy-method-for-proc-entries-creation.patch
arm-use-non-racy-method-for-proc-davinci_clocks-creation.patch
avr32-proc-use-non-racy-method-for-proc-tlb-creation.patch
cris-use-non-racy-method-for-proc-system_profile-creation.patch
ia64-use-non-racy-method-for-proc-entries-creation.patch
parisc-use-non-racy-method-for-proc-pcxl_dma-creation.patch
powerpc-use-non-racy-method-for-proc-entries-creation.patch
acpi-use-non-racy-method-for-proc-entries-creation.patch
netdev-use-non-racy-method-for-proc-entries-creation.patch
isdn-use-non-racy-method-for-proc-entries-creation.patch
kernel-use-non-racy-method-for-proc-entries-creation.patch
parisc-use-non-racy-method-for-proc-entries-creation.patch
drivers-use-non-racy-method-for-proc-entries-creation.patch
drivers-use-non-racy-method-for-proc-entries-creation-2.patch
sysctl-merge-equal-proc_sys_read-and-proc_sys_write.patch
sysctl-clean-from-unneeded-extern-and-forward-declarations.patch
sysctl-add-the-permissions-callback-on-the-ctl_table_root.patch
proc-use-non-racy-method-for-proc-page_owner-creation-page_owner.patch

