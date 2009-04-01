From: akpm@linux-foundation.org
Subject: [merged] mm-fix-proc_dointvec_userhz_jiffies-breakage.patch removed from -mm tree
Date: Wed, 01 Apr 2009 11:38:30 -0700
Message-ID: <200904011838.n31IcUNq008290@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49283 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933436AbZDASnY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Apr 2009 14:43:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@gmail.com, nickpiggin@yahoo.com.au, peterz@infradead.org, mm-commits@vger.kernel.org


The patch titled
     mm: fix proc_dointvec_userhz_jiffies "breakage"
has been removed from the -mm tree.  Its filename was
     mm-fix-proc_dointvec_userhz_jiffies-breakage.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: fix proc_dointvec_userhz_jiffies "breakage"
From: Alexey Dobriyan <adobriyan@gmail.com>

Addresses http://bugzilla.kernel.org/show_bug.cgi?id=9838

On i386, HZ=1000, jiffies_to_clock_t() converts time in a somewhat strange
way from the user's point of view:

	# echo 500 >/proc/sys/vm/dirty_writeback_centisecs
	# cat /proc/sys/vm/dirty_writeback_centisecs
	499

So, we have 5000 jiffies converted to only 499 clock ticks and reported
back.

TICK_NSEC = 999848
ACTHZ = 256039

Keeping in-kernel variable in units passed from userspace will fix issue
of course, but this probably won't be right for every sysctl.

[akpm@linux-foundation.org: coding-style fixes]
Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/writeback.h |    4 ++--
 kernel/sysctl.c           |    2 +-
 mm/page-writeback.c       |   20 +++++++++++---------
 3 files changed, 14 insertions(+), 12 deletions(-)

diff -puN include/linux/writeback.h~mm-fix-proc_dointvec_userhz_jiffies-breakage include/linux/writeback.h
--- a/include/linux/writeback.h~mm-fix-proc_dointvec_userhz_jiffies-breakage
+++ a/include/linux/writeback.h
@@ -109,8 +109,8 @@ extern int dirty_background_ratio;
 extern unsigned long dirty_background_bytes;
 extern int vm_dirty_ratio;
 extern unsigned long vm_dirty_bytes;
-extern int dirty_writeback_interval;
-extern int dirty_expire_interval;
+extern unsigned int dirty_writeback_interval;
+extern unsigned int dirty_expire_interval;
 extern int vm_highmem_is_dirtyable;
 extern int block_dump;
 extern int laptop_mode;
diff -puN kernel/sysctl.c~mm-fix-proc_dointvec_userhz_jiffies-breakage kernel/sysctl.c
--- a/kernel/sysctl.c~mm-fix-proc_dointvec_userhz_jiffies-breakage
+++ a/kernel/sysctl.c
@@ -1010,7 +1010,7 @@ static struct ctl_table vm_table[] = {
 		.data		= &dirty_expire_interval,
 		.maxlen		= sizeof(dirty_expire_interval),
 		.mode		= 0644,
-		.proc_handler	= &proc_dointvec_userhz_jiffies,
+		.proc_handler	= &proc_dointvec,
 	},
 	{
 		.ctl_name	= VM_NR_PDFLUSH_THREADS,
diff -puN mm/page-writeback.c~mm-fix-proc_dointvec_userhz_jiffies-breakage mm/page-writeback.c
--- a/mm/page-writeback.c~mm-fix-proc_dointvec_userhz_jiffies-breakage
+++ a/mm/page-writeback.c
@@ -92,14 +92,14 @@ int vm_dirty_ratio = 20;
 unsigned long vm_dirty_bytes;
 
 /*
- * The interval between `kupdate'-style writebacks, in jiffies
+ * The interval between `kupdate'-style writebacks
  */
-int dirty_writeback_interval = 5 * HZ;
+unsigned int dirty_writeback_interval = 5 * 100; /* sentiseconds */
 
 /*
- * The longest number of jiffies for which data is allowed to remain dirty
+ * The longest time for which data is allowed to remain dirty
  */
-int dirty_expire_interval = 30 * HZ;
+unsigned int dirty_expire_interval = 30 * 100; /* sentiseconds */
 
 /*
  * Flag that makes the machine dump writes/reads and block dirtyings.
@@ -770,9 +770,9 @@ static void wb_kupdate(unsigned long arg
 
 	sync_supers();
 
-	oldest_jif = jiffies - dirty_expire_interval;
+	oldest_jif = jiffies - msecs_to_jiffies(dirty_expire_interval);
 	start_jif = jiffies;
-	next_jif = start_jif + dirty_writeback_interval;
+	next_jif = start_jif + msecs_to_jiffies(dirty_writeback_interval * 10);
 	nr_to_write = global_page_state(NR_FILE_DIRTY) +
 			global_page_state(NR_UNSTABLE_NFS) +
 			(inodes_stat.nr_inodes - inodes_stat.nr_unused);
@@ -801,9 +801,10 @@ static void wb_kupdate(unsigned long arg
 int dirty_writeback_centisecs_handler(ctl_table *table, int write,
 	struct file *file, void __user *buffer, size_t *length, loff_t *ppos)
 {
-	proc_dointvec_userhz_jiffies(table, write, file, buffer, length, ppos);
+	proc_dointvec(table, write, file, buffer, length, ppos);
 	if (dirty_writeback_interval)
-		mod_timer(&wb_timer, jiffies + dirty_writeback_interval);
+		mod_timer(&wb_timer, jiffies +
+			msecs_to_jiffies(dirty_writeback_interval * 10));
 	else
 		del_timer(&wb_timer);
 	return 0;
@@ -905,7 +906,8 @@ void __init page_writeback_init(void)
 {
 	int shift;
 
-	mod_timer(&wb_timer, jiffies + dirty_writeback_interval);
+	mod_timer(&wb_timer,
+		  jiffies + msecs_to_jiffies(dirty_writeback_interval * 10));
 	writeback_set_ratelimit();
 	register_cpu_notifier(&ratelimit_nb);
 
_

Patches currently in -mm which might be from adobriyan@gmail.com are

origin.patch
linux-next.patch
sysctl-dont-take-the-use-count-of-multiple-heads-at-a-time.patch
sysctl-lockdep-support-for-sysctl-reference-counting.patch
simplify-copy_thread.patch
simplify-copy_thread-checkpatch-fixes.patch
softirq-introduce-statistics-for-softirq.patch
proc-export-statistics-for-softirq-to-proc.patch
proc-export-statistics-for-softirq-to-proc-fix.patch
proc-update-document-for-proc-softirqs-and-proc-stat.patch
proc_sysctl-use-config_proc_sysctl-around-ipc-and-utsname-proc_handlers.patch
sysctl-fix-suid_dumpable-and-lease-break-time-sysctls.patch
namespaces-move-proc_net_get_sb-to-a-generic-fs-superc-helper.patch
namespaces-move-proc_net_get_sb-to-a-generic-fs-superc-helper-fix.patch
namespaces-mqueue-ns-move-mqueue_mnt-into-struct-ipc_namespace.patch
namespaces-ipc-namespaces-implement-support-for-posix-msqueues.patch
namespaces-ipc-namespaces-implement-support-for-posix-msqueues-initialize-init_ipc_nscount-to-1.patch
namespaces-mqueue-namespace-adapt-sysctl.patch
namespaces-mqueue-namespace-adapt-sysctl-update.patch
namespaces-mqueue-namespace-adapt-sysctl-update-fix.patch

