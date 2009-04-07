From: akpm@linux-foundation.org
Subject: [merged] mm-add-proc-controls-for-pdflush-threads.patch removed from -mm tree
Date: Tue, 07 Apr 2009 12:06:10 -0700
Message-ID: <200904071906.n37J6ATi010700@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45568 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754130AbZDGTIX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 Apr 2009 15:08:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: pmorreale@novell.com, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     mm: add /proc controls for pdflush threads
has been removed from the -mm tree.  Its filename was
     mm-add-proc-controls-for-pdflush-threads.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: add /proc controls for pdflush threads
From: Peter W Morreale <pmorreale@novell.com>

Add /proc entries to give the admin the ability to control the minimum and
maximum number of pdflush threads.  This allows finer control of pdflush
on both large and small machines.

The rationale is simply one size does not fit all.  Admins on large and/or
small systems may want to tune the min/max pdflush thread count to best
suit their needs.  Right now the min/max is hardcoded to 2/8.  While
probably a fair estimate for smaller machines, large machines with large
numbers of CPUs and large numbers of filesystems/block devices may benefit
from larger numbers of threads working on different block devices.

Even if the background flushing algorithm is radically changed, it is
still likely that multiple threads will be involved and admins would still
desire finer control on the min/max other than to have to recompile the
kernel.

The patch adds '/proc/sys/vm/nr_pdflush_threads_min' and
'/proc/sys/vm/nr_pdflush_threads_max' with r/w permissions.

The minimum value for nr_pdflush_threads_min is 1 and the maximum value is
the current value of nr_pdflush_threads_max.  This minimum is required
since additional thread creation is performed in a pdflush thread itself.

The minimum value for nr_pdflush_threads_max is the current value of
nr_pdflush_threads_min and the maximum value can be 1000.

Documentation/sysctl/vm.txt is also updated.

[akpm@linux-foundation.org: fix comment, fix whitespace, use __read_mostly]
Signed-off-by: Peter W Morreale <pmorreale@novell.com>
Reviewed-by: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/sysctl/vm.txt |   28 ++++++++++++++++++++++++++++
 include/linux/writeback.h   |    2 ++
 kernel/sysctl.c             |   23 +++++++++++++++++++++++
 mm/pdflush.c                |   31 +++++++++++++++++++------------
 4 files changed, 72 insertions(+), 12 deletions(-)

diff -puN Documentation/sysctl/vm.txt~mm-add-proc-controls-for-pdflush-threads Documentation/sysctl/vm.txt
--- a/Documentation/sysctl/vm.txt~mm-add-proc-controls-for-pdflush-threads
+++ a/Documentation/sysctl/vm.txt
@@ -39,6 +39,8 @@ Currently, these files are in /proc/sys/
 - nr_hugepages
 - nr_overcommit_hugepages
 - nr_pdflush_threads
+- nr_pdflush_threads_min
+- nr_pdflush_threads_max
 - nr_trim_pages         (only if CONFIG_MMU=n)
 - numa_zonelist_order
 - oom_dump_tasks
@@ -463,6 +465,32 @@ The default value is 0.
 
 ==============================================================
 
+nr_pdflush_threads_min
+
+This value controls the minimum number of pdflush threads.
+
+At boot time, the kernel will create and maintain 'nr_pdflush_threads_min'
+threads for the kernel's lifetime.
+
+The default value is 2.  The minimum value you can specify is 1, and
+the maximum value is the current setting of 'nr_pdflush_threads_max'.
+
+See 'nr_pdflush_threads_max' below for more information.
+
+==============================================================
+
+nr_pdflush_threads_max
+
+This value controls the maximum number of pdflush threads that can be
+created.  The pdflush algorithm will create a new pdflush thread (up to
+this maximum) if no pdflush threads have been available for >= 1 second.
+
+The default value is 8.  The minimum value you can specify is the
+current value of 'nr_pdflush_threads_min' and the
+maximum is 1000.
+
+==============================================================
+
 overcommit_memory:
 
 This value contains a flag that enables memory overcommitment.
diff -puN include/linux/writeback.h~mm-add-proc-controls-for-pdflush-threads include/linux/writeback.h
--- a/include/linux/writeback.h~mm-add-proc-controls-for-pdflush-threads
+++ a/include/linux/writeback.h
@@ -168,6 +168,8 @@ void writeback_set_ratelimit(void);
 /* pdflush.c */
 extern int nr_pdflush_threads;	/* Global so it can be exported to sysctl
 				   read-only. */
+extern int nr_pdflush_threads_max; /* Global so it can be exported to sysctl */
+extern int nr_pdflush_threads_min; /* Global so it can be exported to sysctl */
 
 
 #endif		/* WRITEBACK_H */
diff -puN kernel/sysctl.c~mm-add-proc-controls-for-pdflush-threads kernel/sysctl.c
--- a/kernel/sysctl.c~mm-add-proc-controls-for-pdflush-threads
+++ a/kernel/sysctl.c
@@ -101,6 +101,7 @@ static int __maybe_unused one = 1;
 static int __maybe_unused two = 2;
 static unsigned long one_ul = 1;
 static int one_hundred = 100;
+static int one_thousand = 1000;
 
 /* this is needed for the proc_dointvec_minmax for [fs_]overflow UID and GID */
 static int maxolduid = 65535;
@@ -1027,6 +1028,28 @@ static struct ctl_table vm_table[] = {
 		.proc_handler	= &proc_dointvec,
 	},
 	{
+		.ctl_name	= CTL_UNNUMBERED,
+		.procname	= "nr_pdflush_threads_min",
+		.data		= &nr_pdflush_threads_min,
+		.maxlen		= sizeof nr_pdflush_threads_min,
+		.mode		= 0644 /* read-write */,
+		.proc_handler	= &proc_dointvec_minmax,
+		.strategy	= &sysctl_intvec,
+		.extra1		= &one,
+		.extra2		= &nr_pdflush_threads_max,
+	},
+	{
+		.ctl_name	= CTL_UNNUMBERED,
+		.procname	= "nr_pdflush_threads_max",
+		.data		= &nr_pdflush_threads_max,
+		.maxlen		= sizeof nr_pdflush_threads_max,
+		.mode		= 0644 /* read-write */,
+		.proc_handler	= &proc_dointvec_minmax,
+		.strategy	= &sysctl_intvec,
+		.extra1		= &nr_pdflush_threads_min,
+		.extra2		= &one_thousand,
+	},
+	{
 		.ctl_name	= VM_SWAPPINESS,
 		.procname	= "swappiness",
 		.data		= &vm_swappiness,
diff -puN mm/pdflush.c~mm-add-proc-controls-for-pdflush-threads mm/pdflush.c
--- a/mm/pdflush.c~mm-add-proc-controls-for-pdflush-threads
+++ a/mm/pdflush.c
@@ -58,6 +58,14 @@ static DEFINE_SPINLOCK(pdflush_lock);
 int nr_pdflush_threads = 0;
 
 /*
+ * The max/min number of pdflush threads. R/W by sysctl at
+ * /proc/sys/vm/nr_pdflush_threads_max/min
+ */
+int nr_pdflush_threads_max __read_mostly = MAX_PDFLUSH_THREADS;
+int nr_pdflush_threads_min __read_mostly = MIN_PDFLUSH_THREADS;
+
+
+/*
  * The time at which the pdflush thread pool last went empty
  */
 static unsigned long last_empty_jifs;
@@ -68,7 +76,7 @@ static unsigned long last_empty_jifs;
  * Thread pool management algorithm:
  * 
  * - The minimum and maximum number of pdflush instances are bound
- *   by MIN_PDFLUSH_THREADS and MAX_PDFLUSH_THREADS.
+ *   by nr_pdflush_threads_min and nr_pdflush_threads_max.
  * 
  * - If there have been no idle pdflush instances for 1 second, create
  *   a new one.
@@ -134,14 +142,13 @@ static int __pdflush(struct pdflush_work
 		 * To throttle creation, we reset last_empty_jifs.
 		 */
 		if (time_after(jiffies, last_empty_jifs + 1 * HZ)) {
-			if (list_empty(&pdflush_list)) {
-				if (nr_pdflush_threads < MAX_PDFLUSH_THREADS) {
-					last_empty_jifs = jiffies;
-					nr_pdflush_threads++;
-					spin_unlock_irq(&pdflush_lock);
-					start_one_pdflush_thread();
-					spin_lock_irq(&pdflush_lock);
-				}
+			if (list_empty(&pdflush_list) &&
+			    nr_pdflush_threads < nr_pdflush_threads_max) {
+				last_empty_jifs = jiffies;
+				nr_pdflush_threads++;
+				spin_unlock_irq(&pdflush_lock);
+				start_one_pdflush_thread();
+				spin_lock_irq(&pdflush_lock);
 			}
 		}
 
@@ -153,7 +160,7 @@ static int __pdflush(struct pdflush_work
 		 */
 		if (list_empty(&pdflush_list))
 			continue;
-		if (nr_pdflush_threads <= MIN_PDFLUSH_THREADS)
+		if (nr_pdflush_threads <= nr_pdflush_threads_min)
 			continue;
 		pdf = list_entry(pdflush_list.prev, struct pdflush_work, list);
 		if (time_after(jiffies, pdf->when_i_went_to_sleep + 1 * HZ)) {
@@ -259,9 +266,9 @@ static int __init pdflush_init(void)
 	 * Pre-set nr_pdflush_threads...  If we fail to create,
 	 * the count will be decremented.
 	 */
-	nr_pdflush_threads = MIN_PDFLUSH_THREADS;
+	nr_pdflush_threads = nr_pdflush_threads_min;
 
-	for (i = 0; i < MIN_PDFLUSH_THREADS; i++)
+	for (i = 0; i < nr_pdflush_threads_min; i++)
 		start_one_pdflush_thread();
 	return 0;
 }
_

Patches currently in -mm which might be from pmorreale@novell.com are

origin.patch

