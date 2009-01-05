From: akpm@linux-foundation.org
Subject: + mm-add-proc-controls-for-pdflush-threads.patch added to -mm tree
Date: Mon, 05 Jan 2009 14:53:03 -0800
Message-ID: <200901052253.n05Mr3au014416@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57909 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750890AbZAEWxv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 5 Jan 2009 17:53:51 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: pmorreale@novell.com, riel@redhat.com


The patch titled
     mm: add /proc controls for pdflush threads
has been added to the -mm tree.  Its filename is
     mm-add-proc-controls-for-pdflush-threads.patch

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

Signed-off-by: Peter W Morreale <pmorreale@novell.com>
Reviewed-by: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/sysctl/vm.txt |   28 ++++++++++++++++++++++++++++
 include/linux/writeback.h   |    2 ++
 kernel/sysctl.c             |   23 +++++++++++++++++++++++
 mm/pdflush.c                |   19 ++++++++++++++-----
 4 files changed, 67 insertions(+), 5 deletions(-)

diff -puN Documentation/sysctl/vm.txt~mm-add-proc-controls-for-pdflush-threads Documentation/sysctl/vm.txt
--- a/Documentation/sysctl/vm.txt~mm-add-proc-controls-for-pdflush-threads
+++ a/Documentation/sysctl/vm.txt
@@ -22,6 +22,8 @@ Currently, these files are in /proc/sys/
 - dirty_background_ratio
 - dirty_expire_centisecs
 - dirty_writeback_centisecs
+- nr_pdflush_threads_min
+- nr_pdflush_threads_max
 - highmem_is_dirtyable   (only if CONFIG_HIGHMEM set)
 - max_map_count
 - min_free_kbytes
@@ -52,6 +54,32 @@ See Documentation/filesystems/proc.txt
 
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
@@ -103,6 +103,7 @@ static int two = 2;
 static int zero;
 static int one = 1;
 static int one_hundred = 100;
+static int one_thousand = 1000;
 
 /* this is needed for the proc_dointvec_minmax for [fs_]overflow UID and GID */
 static int maxolduid = 65535;
@@ -1022,6 +1023,28 @@ static struct ctl_table vm_table[] = {
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
+ * /proc/sys/vm/nr_pdflush_threads_max
+ */
+int nr_pdflush_threads_max = MAX_PDFLUSH_THREADS;
+int nr_pdflush_threads_min = MIN_PDFLUSH_THREADS;
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
@@ -135,7 +143,8 @@ static int __pdflush(struct pdflush_work
 		 */
 		if (time_after(jiffies, last_empty_jifs + 1 * HZ)) {
 			if (list_empty(&pdflush_list)) {
-				if (nr_pdflush_threads < MAX_PDFLUSH_THREADS) {
+				if (nr_pdflush_threads <
+						nr_pdflush_threads_max) {
 					last_empty_jifs = jiffies;
 					nr_pdflush_threads++;
 					spin_unlock_irq(&pdflush_lock);
@@ -153,7 +162,7 @@ static int __pdflush(struct pdflush_work
 		 */
 		if (list_empty(&pdflush_list))
 			continue;
-		if (nr_pdflush_threads <= MIN_PDFLUSH_THREADS)
+		if (nr_pdflush_threads <= nr_pdflush_threads_min)
 			continue;
 		pdf = list_entry(pdflush_list.prev, struct pdflush_work, list);
 		if (time_after(jiffies, pdf->when_i_went_to_sleep + 1 * HZ)) {
@@ -259,9 +268,9 @@ static int __init pdflush_init(void)
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

mm-fix-pdflush-thread-creation-upper-bound.patch
mm-add-proc-controls-for-pdflush-threads.patch
mm-add-proc-controls-for-pdflush-threads-fix.patch

