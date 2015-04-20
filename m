From: akpm@linux-foundation.org
Subject: [merged] kernel-sysctlc-threads-max-observe-limits.patch removed
 from -mm tree
Date: Mon, 20 Apr 2015 12:19:46 -0700
Message-ID: <55355152.2OlZP1PdDajFnNNu%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40385 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753176AbbDTTNZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 20 Apr 2015 15:13:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: xypron.glpk@gmx.de, linux@roeck-us.net, mingo@kernel.org, oleg@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kernel/sysctl.c: threads-max observe limits
has been removed from the -mm tree.  Its filename was
     kernel-sysctlc-threads-max-observe-limits.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Heinrich Schuchardt <xypron.glpk@gmx.de>
Subject: kernel/sysctl.c: threads-max observe limits

Users can change the maximum number of threads by writing to
/proc/sys/kernel/threads-max.

With the patch the value entered is checked against the same limits that
apply when fork_init is called.

Signed-off-by: Heinrich Schuchardt <xypron.glpk@gmx.de>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/sysctl.h |    3 +++
 kernel/fork.c          |   31 +++++++++++++++++++++++++++++--
 kernel/sysctl.c        |    6 ++----
 3 files changed, 34 insertions(+), 6 deletions(-)

diff -puN include/linux/sysctl.h~kernel-sysctlc-threads-max-observe-limits include/linux/sysctl.h
--- a/include/linux/sysctl.h~kernel-sysctlc-threads-max-observe-limits
+++ a/include/linux/sysctl.h
@@ -212,4 +212,7 @@ static inline void setup_sysctl_set(stru
 
 #endif /* CONFIG_SYSCTL */
 
+int sysctl_max_threads(struct ctl_table *table, int write,
+		       void __user *buffer, size_t *lenp, loff_t *ppos);
+
 #endif /* _LINUX_SYSCTL_H */
diff -puN kernel/fork.c~kernel-sysctlc-threads-max-observe-limits kernel/fork.c
--- a/kernel/fork.c~kernel-sysctlc-threads-max-observe-limits
+++ a/kernel/fork.c
@@ -74,6 +74,7 @@
 #include <linux/uprobes.h>
 #include <linux/aio.h>
 #include <linux/compiler.h>
+#include <linux/sysctl.h>
 
 #include <asm/pgtable.h>
 #include <asm/pgalloc.h>
@@ -266,7 +267,7 @@ void __init __weak arch_task_cache_init(
 /*
  * set_max_threads
  */
-static void set_max_threads(void)
+static void set_max_threads(unsigned int max_threads_suggested)
 {
 	u64 threads;
 
@@ -280,6 +281,9 @@ static void set_max_threads(void)
 		threads = div64_u64((u64) totalram_pages * (u64) PAGE_SIZE,
 				    (u64) THREAD_SIZE * 8UL);
 
+	if (threads > max_threads_suggested)
+		threads = max_threads_suggested;
+
 	max_threads = clamp_t(u64, threads, MIN_THREADS, MAX_THREADS);
 }
 
@@ -298,7 +302,7 @@ void __init fork_init(void)
 	/* do the arch specific task caches init */
 	arch_task_cache_init();
 
-	set_max_threads();
+	set_max_threads(MAX_THREADS);
 
 	init_task.signal->rlim[RLIMIT_NPROC].rlim_cur = max_threads/2;
 	init_task.signal->rlim[RLIMIT_NPROC].rlim_max = max_threads/2;
@@ -2020,3 +2024,26 @@ int unshare_files(struct files_struct **
 	task_unlock(task);
 	return 0;
 }
+
+int sysctl_max_threads(struct ctl_table *table, int write,
+		       void __user *buffer, size_t *lenp, loff_t *ppos)
+{
+	struct ctl_table t;
+	int ret;
+	int threads = max_threads;
+	int min = MIN_THREADS;
+	int max = MAX_THREADS;
+
+	t = *table;
+	t.data = &threads;
+	t.extra1 = &min;
+	t.extra2 = &max;
+
+	ret = proc_dointvec_minmax(&t, write, buffer, lenp, ppos);
+	if (ret || !write)
+		return ret;
+
+	set_max_threads(threads);
+
+	return 0;
+}
diff -puN kernel/sysctl.c~kernel-sysctlc-threads-max-observe-limits kernel/sysctl.c
--- a/kernel/sysctl.c~kernel-sysctlc-threads-max-observe-limits
+++ a/kernel/sysctl.c
@@ -93,11 +93,9 @@
 #include <linux/nmi.h>
 #endif
 
-
 #if defined(CONFIG_SYSCTL)
 
 /* External variables not in a header file. */
-extern int max_threads;
 extern int suid_dumpable;
 #ifdef CONFIG_COREDUMP
 extern int core_uses_pid;
@@ -710,10 +708,10 @@ static struct ctl_table kern_table[] = {
 #endif
 	{
 		.procname	= "threads-max",
-		.data		= &max_threads,
+		.data		= NULL,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
-		.proc_handler	= proc_dointvec,
+		.proc_handler	= sysctl_max_threads,
 	},
 	{
 		.procname	= "random",
_

Patches currently in -mm which might be from xypron.glpk@gmx.de are

origin.patch

