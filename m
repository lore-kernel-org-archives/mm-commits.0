From: akpm@linux-foundation.org
Subject: [patch 078/117] mm: /proc/sys/vm/stat_refresh to force vmstat
 update
Date: Thu, 19 May 2016 17:12:50 -0700
Message-ID: <573e5682.78cGSAV4yym0N51H%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46430 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755059AbcETAMw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 19 May 2016 20:12:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, hughd@google.com, aarcange@redhat.com, andreslc@google.com, kirill.shutemov@linux.intel.com, koct9i@gmail.com, mgorman@techsingularity.net, quning@gmail.com, yang.shi@linaro.org

From: Hugh Dickins <hughd@google.com>
Subject: mm: /proc/sys/vm/stat_refresh to force vmstat update

Provide /proc/sys/vm/stat_refresh to force an immediate update of per-cpu
into global vmstats: useful to avoid a sleep(2) or whatever before
checking counts when testing.  Originally added to work around a bug which
left counts stranded indefinitely on a cpu going idle (an inaccuracy
magnified when small below-batch numbers represent "huge" amounts of
memory), but I believe that bug is now fixed: nonetheless, this is still a
useful knob.

Its schedule_on_each_cpu() is probably too expensive just to fold into
reading /proc/meminfo itself: give this mode 0600 to prevent abuse.  Allow
a write or a read to do the same: nothing to read, but "grep -h Shmem
/proc/sys/vm/stat_refresh /proc/meminfo" is convenient.  Oh, and since
global_page_state() itself is careful to disguise any underflow as 0, hack
in an "Invalid argument" and pr_warn() if a counter is negative after the
refresh - this helped to fix a misaccounting of NR_ISOLATED_FILE in my
migration code.

But on recent kernels, I find that NR_ALLOC_BATCH and NR_PAGES_SCANNED
often go negative some of the time.  I have not yet worked out why, but
have no evidence that it's actually harmful.  Punt for the moment by just
ignoring the anomaly on those.

Signed-off-by: Hugh Dickins <hughd@google.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Andres Lagar-Cavilla <andreslc@google.com>
Cc: Yang Shi <yang.shi@linaro.org>
Cc: Ning Qu <quning@gmail.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Andres Lagar-Cavilla <andreslc@google.com>
Cc: Konstantin Khlebnikov <koct9i@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/sysctl/vm.txt |   14 +++++++
 include/linux/vmstat.h      |    4 ++
 kernel/sysctl.c             |    7 +++
 mm/vmstat.c                 |   60 ++++++++++++++++++++++++++++++++++
 4 files changed, 85 insertions(+)

diff -puN Documentation/sysctl/vm.txt~mm-proc-sys-vm-stat_refresh-to-force-vmstat-update Documentation/sysctl/vm.txt
--- a/Documentation/sysctl/vm.txt~mm-proc-sys-vm-stat_refresh-to-force-vmstat-update
+++ a/Documentation/sysctl/vm.txt
@@ -57,6 +57,7 @@ Currently, these files are in /proc/sys/
 - panic_on_oom
 - percpu_pagelist_fraction
 - stat_interval
+- stat_refresh
 - swappiness
 - user_reserve_kbytes
 - vfs_cache_pressure
@@ -755,6 +756,19 @@ is 1 second.
 
 ==============================================================
 
+stat_refresh
+
+Any read or write (by root only) flushes all the per-cpu vm statistics
+into their global totals, for more accurate reports when testing
+e.g. cat /proc/sys/vm/stat_refresh /proc/meminfo
+
+As a side-effect, it also checks for negative totals (elsewhere reported
+as 0) and "fails" with EINVAL if any are found, with a warning in dmesg.
+(At time of writing, a few stats are known sometimes to be found negative,
+with no ill effects: errors and warnings on these stats are suppressed.)
+
+==============================================================
+
 swappiness
 
 This control is used to define how aggressive the kernel will swap
diff -puN include/linux/vmstat.h~mm-proc-sys-vm-stat_refresh-to-force-vmstat-update include/linux/vmstat.h
--- a/include/linux/vmstat.h~mm-proc-sys-vm-stat_refresh-to-force-vmstat-update
+++ a/include/linux/vmstat.h
@@ -193,6 +193,10 @@ void quiet_vmstat(void);
 void cpu_vm_stats_fold(int cpu);
 void refresh_zone_stat_thresholds(void);
 
+struct ctl_table;
+int vmstat_refresh(struct ctl_table *, int write,
+		   void __user *buffer, size_t *lenp, loff_t *ppos);
+
 void drain_zonestat(struct zone *zone, struct per_cpu_pageset *);
 
 int calculate_pressure_threshold(struct zone *zone);
diff -puN kernel/sysctl.c~mm-proc-sys-vm-stat_refresh-to-force-vmstat-update kernel/sysctl.c
--- a/kernel/sysctl.c~mm-proc-sys-vm-stat_refresh-to-force-vmstat-update
+++ a/kernel/sysctl.c
@@ -1521,6 +1521,13 @@ static struct ctl_table vm_table[] = {
 		.mode		= 0644,
 		.proc_handler	= proc_dointvec_jiffies,
 	},
+	{
+		.procname	= "stat_refresh",
+		.data		= NULL,
+		.maxlen		= 0,
+		.mode		= 0600,
+		.proc_handler	= vmstat_refresh,
+	},
 #endif
 #ifdef CONFIG_MMU
 	{
diff -puN mm/vmstat.c~mm-proc-sys-vm-stat_refresh-to-force-vmstat-update mm/vmstat.c
--- a/mm/vmstat.c~mm-proc-sys-vm-stat_refresh-to-force-vmstat-update
+++ a/mm/vmstat.c
@@ -1379,6 +1379,66 @@ static DEFINE_PER_CPU(struct delayed_wor
 int sysctl_stat_interval __read_mostly = HZ;
 static cpumask_var_t cpu_stat_off;
 
+#ifdef CONFIG_PROC_FS
+static void refresh_vm_stats(struct work_struct *work)
+{
+	refresh_cpu_vm_stats(true);
+}
+
+int vmstat_refresh(struct ctl_table *table, int write,
+		   void __user *buffer, size_t *lenp, loff_t *ppos)
+{
+	long val;
+	int err;
+	int i;
+
+	/*
+	 * The regular update, every sysctl_stat_interval, may come later
+	 * than expected: leaving a significant amount in per_cpu buckets.
+	 * This is particularly misleading when checking a quantity of HUGE
+	 * pages, immediately after running a test.  /proc/sys/vm/stat_refresh,
+	 * which can equally be echo'ed to or cat'ted from (by root),
+	 * can be used to update the stats just before reading them.
+	 *
+	 * Oh, and since global_page_state() etc. are so careful to hide
+	 * transiently negative values, report an error here if any of
+	 * the stats is negative, so we know to go looking for imbalance.
+	 */
+	err = schedule_on_each_cpu(refresh_vm_stats);
+	if (err)
+		return err;
+	for (i = 0; i < NR_VM_ZONE_STAT_ITEMS; i++) {
+		val = atomic_long_read(&vm_stat[i]);
+		if (val < 0) {
+			switch (i) {
+			case NR_ALLOC_BATCH:
+			case NR_PAGES_SCANNED:
+				/*
+				 * These are often seen to go negative in
+				 * recent kernels, but not to go permanently
+				 * negative.  Whilst it would be nicer not to
+				 * have exceptions, rooting them out would be
+				 * another task, of rather low priority.
+				 */
+				break;
+			default:
+				pr_warn("%s: %s %ld\n",
+					__func__, vmstat_text[i], val);
+				err = -EINVAL;
+				break;
+			}
+		}
+	}
+	if (err)
+		return err;
+	if (write)
+		*ppos += *lenp;
+	else
+		*lenp = 0;
+	return 0;
+}
+#endif /* CONFIG_PROC_FS */
+
 static void vmstat_update(struct work_struct *w)
 {
 	if (refresh_cpu_vm_stats(true)) {
_
