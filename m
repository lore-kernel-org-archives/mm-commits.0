From: akpm@linux-foundation.org
Subject: + writeback-report-dirty-thresholds-in-proc-vmstat.patch added to -mm tree
Date: Mon, 13 Sep 2010 15:48:54 -0700
Message-ID: <201009132248.o8DMmtPl025738@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54404 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752232Ab0IMWtG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 13 Sep 2010 18:49:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mrubin@google.com, axboe@kernel.dk, david@fromorbit.com, fengguang.wu@intel.com, kosaki.motohiro@jp.fujitsu.com, nickpiggin@yahoo.com.au


The patch titled
     writeback: report dirty thresholds in /proc/vmstat
has been added to the -mm tree.  Its filename is
     writeback-report-dirty-thresholds-in-proc-vmstat.patch

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
Subject: writeback: report dirty thresholds in /proc/vmstat
From: Michael Rubin <mrubin@google.com>

The kernel already exposes the user desired thresholds in /proc/sys/vm
with dirty_background_ratio and background_ratio.  But the kernel may
alter the number requested without giving the user any indication that is
the case.

Knowing the actual ratios the kernel is honoring can help app developers
understand how their buffered IO will be sent to the disk.

        $ grep threshold /proc/vmstat
        nr_dirty_threshold 409111
        nr_dirty_background_threshold 818223

Signed-off-by: Michael Rubin <mrubin@google.com>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmstat.c |   39 +++++++++++++++++++++++++--------------
 1 file changed, 25 insertions(+), 14 deletions(-)

diff -puN mm/vmstat.c~writeback-report-dirty-thresholds-in-proc-vmstat mm/vmstat.c
--- a/mm/vmstat.c~writeback-report-dirty-thresholds-in-proc-vmstat
+++ a/mm/vmstat.c
@@ -17,6 +17,7 @@
 #include <linux/vmstat.h>
 #include <linux/sched.h>
 #include <linux/math64.h>
+#include <linux/writeback.h>
 
 #ifdef CONFIG_VM_EVENT_COUNTERS
 DEFINE_PER_CPU(struct vm_event_state, vm_event_states) = {{0}};
@@ -747,6 +748,8 @@ static const char * const vmstat_text[] 
 	"nr_shmem",
 	"nr_dirtied",
 	"nr_written",
+	"nr_dirty_threshold",
+	"nr_dirty_background_threshold",
 
 #ifdef CONFIG_NUMA
 	"numa_hit",
@@ -907,36 +910,44 @@ static const struct file_operations proc
 	.release	= seq_release,
 };
 
+enum writeback_stat_item {
+	NR_DIRTY_THRESHOLD,
+	NR_DIRTY_BG_THRESHOLD,
+	NR_VM_WRITEBACK_STAT_ITEMS,
+};
+
 static void *vmstat_start(struct seq_file *m, loff_t *pos)
 {
 	unsigned long *v;
-#ifdef CONFIG_VM_EVENT_COUNTERS
-	unsigned long *e;
-#endif
-	int i;
+	int i, stat_items_size;
 
 	if (*pos >= ARRAY_SIZE(vmstat_text))
 		return NULL;
+	stat_items_size = NR_VM_ZONE_STAT_ITEMS * sizeof(unsigned long) +
+			  NR_VM_WRITEBACK_STAT_ITEMS * sizeof(unsigned long);
 
 #ifdef CONFIG_VM_EVENT_COUNTERS
-	v = kmalloc(NR_VM_ZONE_STAT_ITEMS * sizeof(unsigned long)
-			+ sizeof(struct vm_event_state), GFP_KERNEL);
-#else
-	v = kmalloc(NR_VM_ZONE_STAT_ITEMS * sizeof(unsigned long),
-			GFP_KERNEL);
+	stat_items_size += sizeof(struct vm_event_state);
 #endif
+
+	v = kmalloc(stat_items_size, GFP_KERNEL);
 	m->private = v;
 	if (!v)
 		return ERR_PTR(-ENOMEM);
 	for (i = 0; i < NR_VM_ZONE_STAT_ITEMS; i++)
 		v[i] = global_page_state(i);
+	v += NR_VM_ZONE_STAT_ITEMS;
+
+	global_dirty_limits(v + NR_DIRTY_BG_THRESHOLD,
+			    v + NR_DIRTY_THRESHOLD);
+	v += NR_VM_WRITEBACK_STAT_ITEMS;
+
 #ifdef CONFIG_VM_EVENT_COUNTERS
-	e = v + NR_VM_ZONE_STAT_ITEMS;
-	all_vm_events(e);
-	e[PGPGIN] /= 2;		/* sectors -> kbytes */
-	e[PGPGOUT] /= 2;
+	all_vm_events(v);
+	v[PGPGIN] /= 2;		/* sectors -> kbytes */
+	v[PGPGOUT] /= 2;
 #endif
-	return v + *pos;
+	return m->private + *pos;
 }
 
 static void *vmstat_next(struct seq_file *m, void *arg, loff_t *pos)
_

Patches currently in -mm which might be from mrubin@google.com are

vmscan-do-not-writeback-filesystem-pages-in-direct-reclaim.patch
vmscan-kick-flusher-threads-to-clean-pages-when-reclaim-is-encountering-dirty-pages.patch
mm-export-account_page_dirty.patch
mm-add-account_page_writeback.patch
writeback-add-nr_dirtied-and-nr_written-to-proc-vmstat.patch
writeback-add-nr_dirtied-and-nr_written-to-proc-vmstat-fix.patch
writeback-add-sys-devices-system-node-node-vmstat.patch
writeback-report-dirty-thresholds-in-proc-vmstat.patch

