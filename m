From: akpm@linux-foundation.org
Subject: + mm-fix-proc_dointvec_userhz_jiffies-breakage.patch added to -mm tree
Date: Mon, 09 Mar 2009 14:50:23 -0700
Message-ID: <200903092150.n29LoNmZ010849@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55720 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752539AbZCIV4W (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Mar 2009 17:56:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: adobriyan@gmail.com, nickpiggin@yahoo.com.au, peterz@infradead.org


The patch titled
     mm: fix proc_dointvec_userhz_jiffies "breakage"
has been added to the -mm tree.  Its filename is
     mm-fix-proc_dointvec_userhz_jiffies-breakage.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/writeback.h |    4 ++--
 kernel/sysctl.c           |    2 +-
 mm/page-writeback.c       |   18 +++++++++---------
 3 files changed, 12 insertions(+), 12 deletions(-)

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
@@ -1044,7 +1044,7 @@ static struct ctl_table vm_table[] = {
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
@@ -92,14 +92,14 @@ int vm_dirty_ratio = 10;
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
@@ -801,9 +801,9 @@ static void wb_kupdate(unsigned long arg
 int dirty_writeback_centisecs_handler(ctl_table *table, int write,
 	struct file *file, void __user *buffer, size_t *length, loff_t *ppos)
 {
-	proc_dointvec_userhz_jiffies(table, write, file, buffer, length, ppos);
+	proc_dointvec(table, write, file, buffer, length, ppos);
 	if (dirty_writeback_interval)
-		mod_timer(&wb_timer, jiffies + dirty_writeback_interval);
+		mod_timer(&wb_timer, jiffies + msecs_to_jiffies(dirty_writeback_interval * 10));
 	else
 		del_timer(&wb_timer);
 	return 0;
@@ -905,7 +905,7 @@ void __init page_writeback_init(void)
 {
 	int shift;
 
-	mod_timer(&wb_timer, jiffies + dirty_writeback_interval);
+	mod_timer(&wb_timer, jiffies + msecs_to_jiffies(dirty_writeback_interval * 10));
 	writeback_set_ratelimit();
 	register_cpu_notifier(&ratelimit_nb);
 
_

Patches currently in -mm which might be from adobriyan@gmail.com are

origin.patch
xtensa-fix-compilation-somewhat.patch
devpts-remove-graffiti.patch
linux-next.patch
proc-tty-add-struct-tty_operations-proc_fops.patch
proc-tty-switch-cyclades-to-proc_fops.patch
proc-tty-switch-ip2-to-proc_fops.patch
proc-tty-switch-istallion-to-proc_fops.patch
proc-tty-switch-synclink_cs-to-proc_fops.patch
proc-tty-switch-stallion-to-proc_fops.patch
proc-tty-switch-synclink-to-proc_fops.patch
proc-tty-switch-synclink_gt-to-proc_fops.patch
proc-tty-switch-synclinkmp-to-proc_fops.patch
proc-tty-switch-sdio_uart-to-proc_fops.patch
proc-tty-switch-serial_core-to-proc_fops.patch
proc-tty-switch-usb-serial-to-proc_fops.patch
proc-tty-switch-ircomm-to-proc_fops.patch
proc-tty-switch-amiserial-to-proc_fops.patch
proc-tty-switch-ia64-simserial-to-proc_fops.patch
proc-tty-switch-xtensa-iss-console-to-proc_fops.patch
proc-tty-remove-struct-tty_operations-read_proc.patch
memdup_user-introduce.patch
mm-fix-proc_dointvec_userhz_jiffies-breakage.patch
softirq-introduce-statistics-for-softirq.patch
proc-export-statistics-for-softirq-to-proc.patch
proc-export-statistics-for-softirq-to-proc-fix.patch
proc-update-document-for-proc-softirqs-and-proc-stat.patch
proc_sysctl-use-config_proc_sysctl-around-ipc-and-utsname-proc_handlers.patch
namespaces-move-proc_net_get_sb-to-a-generic-fs-superc-helper.patch
namespaces-move-proc_net_get_sb-to-a-generic-fs-superc-helper-fix.patch
namespaces-mqueue-ns-move-mqueue_mnt-into-struct-ipc_namespace.patch
namespaces-ipc-namespaces-implement-support-for-posix-msqueues.patch
namespaces-ipc-namespaces-implement-support-for-posix-msqueues-initialize-init_ipc_nscount-to-1.patch
namespaces-mqueue-namespace-adapt-sysctl.patch
namespaces-mqueue-namespace-adapt-sysctl-update.patch
namespaces-mqueue-namespace-adapt-sysctl-update-fix.patch

