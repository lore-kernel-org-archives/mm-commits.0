From: akpm@linux-foundation.org
Subject: + mm-oom-analysis-show-kernel-stack-usage-in-proc-meminfo-and-oom-log-output.patch added to -mm tree
Date: Mon, 13 Jul 2009 15:30:27 -0700
Message-ID: <200907132230.n6DMUSBp004891@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53633 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753242AbZGMWax (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 13 Jul 2009 18:30:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kosaki.motohiro@jp.fujitsu.com, cl@linux-foundation.org, minchan.kim@gmail.com, riel@redhat.com, rientjes@google.com


The patch titled
     mm: oom analysis: Show kernel stack usage in /proc/meminfo and OOM log output
has been added to the -mm tree.  Its filename is
     mm-oom-analysis-show-kernel-stack-usage-in-proc-meminfo-and-oom-log-output.patch

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
Subject: mm: oom analysis: Show kernel stack usage in /proc/meminfo and OOM log output
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

The amount of memory allocated to kernel stacks can become significant and
cause OOM conditions.  However, we do not display the amount of memory
consumed by stacks.

Add code to display the amount of memory used for stacks in /proc/meminfo.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Reviewed-by: Christoph Lameter <cl@linux-foundation.org>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>
Reviewed-by: Rik van Riel <riel@redhat.com>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/node.c    |    3 +++
 fs/proc/meminfo.c      |    2 ++
 include/linux/mmzone.h |    3 ++-
 kernel/fork.c          |   11 +++++++++++
 mm/page_alloc.c        |    3 +++
 mm/vmstat.c            |    1 +
 6 files changed, 22 insertions(+), 1 deletion(-)

diff -puN drivers/base/node.c~mm-oom-analysis-show-kernel-stack-usage-in-proc-meminfo-and-oom-log-output drivers/base/node.c
--- a/drivers/base/node.c~mm-oom-analysis-show-kernel-stack-usage-in-proc-meminfo-and-oom-log-output
+++ a/drivers/base/node.c
@@ -85,6 +85,7 @@ static ssize_t node_read_meminfo(struct 
 		       "Node %d FilePages:      %8lu kB\n"
 		       "Node %d Mapped:         %8lu kB\n"
 		       "Node %d AnonPages:      %8lu kB\n"
+		       "Node %d KernelStack:    %8lu kB\n"
 		       "Node %d PageTables:     %8lu kB\n"
 		       "Node %d NFS_Unstable:   %8lu kB\n"
 		       "Node %d Bounce:         %8lu kB\n"
@@ -116,6 +117,8 @@ static ssize_t node_read_meminfo(struct 
 		       nid, K(node_page_state(nid, NR_FILE_PAGES)),
 		       nid, K(node_page_state(nid, NR_FILE_MAPPED)),
 		       nid, K(node_page_state(nid, NR_ANON_PAGES)),
+		       nid, node_page_state(nid, NR_KERNEL_STACK) *
+				THREAD_SIZE / 1024,
 		       nid, K(node_page_state(nid, NR_PAGETABLE)),
 		       nid, K(node_page_state(nid, NR_UNSTABLE_NFS)),
 		       nid, K(node_page_state(nid, NR_BOUNCE)),
diff -puN fs/proc/meminfo.c~mm-oom-analysis-show-kernel-stack-usage-in-proc-meminfo-and-oom-log-output fs/proc/meminfo.c
--- a/fs/proc/meminfo.c~mm-oom-analysis-show-kernel-stack-usage-in-proc-meminfo-and-oom-log-output
+++ a/fs/proc/meminfo.c
@@ -84,6 +84,7 @@ static int meminfo_proc_show(struct seq_
 		"Slab:           %8lu kB\n"
 		"SReclaimable:   %8lu kB\n"
 		"SUnreclaim:     %8lu kB\n"
+		"KernelStack:    %8lu kB\n"
 		"PageTables:     %8lu kB\n"
 #ifdef CONFIG_QUICKLIST
 		"Quicklists:     %8lu kB\n"
@@ -128,6 +129,7 @@ static int meminfo_proc_show(struct seq_
 				global_page_state(NR_SLAB_UNRECLAIMABLE)),
 		K(global_page_state(NR_SLAB_RECLAIMABLE)),
 		K(global_page_state(NR_SLAB_UNRECLAIMABLE)),
+		global_page_state(NR_KERNEL_STACK) * THREAD_SIZE / 1024,
 		K(global_page_state(NR_PAGETABLE)),
 #ifdef CONFIG_QUICKLIST
 		K(quicklist_total_size()),
diff -puN include/linux/mmzone.h~mm-oom-analysis-show-kernel-stack-usage-in-proc-meminfo-and-oom-log-output include/linux/mmzone.h
--- a/include/linux/mmzone.h~mm-oom-analysis-show-kernel-stack-usage-in-proc-meminfo-and-oom-log-output
+++ a/include/linux/mmzone.h
@@ -94,10 +94,11 @@ enum zone_stat_item {
 	NR_SLAB_RECLAIMABLE,
 	NR_SLAB_UNRECLAIMABLE,
 	NR_PAGETABLE,		/* used for pagetables */
+	NR_KERNEL_STACK,
+	/* Second 128 byte cacheline */
 	NR_UNSTABLE_NFS,	/* NFS unstable pages */
 	NR_BOUNCE,
 	NR_VMSCAN_WRITE,
-	/* Second 128 byte cacheline */
 	NR_WRITEBACK_TEMP,	/* Writeback using temporary buffers */
 #ifdef CONFIG_NUMA
 	NUMA_HIT,		/* allocated in intended node */
diff -puN kernel/fork.c~mm-oom-analysis-show-kernel-stack-usage-in-proc-meminfo-and-oom-log-output kernel/fork.c
--- a/kernel/fork.c~mm-oom-analysis-show-kernel-stack-usage-in-proc-meminfo-and-oom-log-output
+++ a/kernel/fork.c
@@ -136,9 +136,17 @@ struct kmem_cache *vm_area_cachep;
 /* SLAB cache for mm_struct structures (tsk->mm) */
 static struct kmem_cache *mm_cachep;
 
+static void account_kernel_stack(struct thread_info *ti, int account)
+{
+	struct zone *zone = page_zone(virt_to_page(ti));
+
+	mod_zone_page_state(zone, NR_KERNEL_STACK, account);
+}
+
 void free_task(struct task_struct *tsk)
 {
 	prop_local_destroy_single(&tsk->dirties);
+	account_kernel_stack(tsk->stack, -1);
 	free_thread_info(tsk->stack);
 	rt_mutex_debug_task_free(tsk);
 	ftrace_graph_exit_task(tsk);
@@ -254,6 +262,9 @@ static struct task_struct *dup_task_stru
 	tsk->btrace_seq = 0;
 #endif
 	tsk->splice_pipe = NULL;
+
+	account_kernel_stack(ti, 1);
+
 	return tsk;
 
 out:
diff -puN mm/page_alloc.c~mm-oom-analysis-show-kernel-stack-usage-in-proc-meminfo-and-oom-log-output mm/page_alloc.c
--- a/mm/page_alloc.c~mm-oom-analysis-show-kernel-stack-usage-in-proc-meminfo-and-oom-log-output
+++ a/mm/page_alloc.c
@@ -2177,6 +2177,7 @@ void show_free_areas(void)
 			" mapped:%lukB"
 			" slab_reclaimable:%lukB"
 			" slab_unreclaimable:%lukB"
+			" kernel_stack:%lukB"
 			" pagetables:%lukB"
 			" unstable:%lukB"
 			" bounce:%lukB"
@@ -2201,6 +2202,8 @@ void show_free_areas(void)
 			K(zone_page_state(zone, NR_FILE_MAPPED)),
 			K(zone_page_state(zone, NR_SLAB_RECLAIMABLE)),
 			K(zone_page_state(zone, NR_SLAB_UNRECLAIMABLE)),
+			zone_page_state(zone, NR_KERNEL_STACK) *
+				THREAD_SIZE / 1024,
 			K(zone_page_state(zone, NR_PAGETABLE)),
 			K(zone_page_state(zone, NR_UNSTABLE_NFS)),
 			K(zone_page_state(zone, NR_BOUNCE)),
diff -puN mm/vmstat.c~mm-oom-analysis-show-kernel-stack-usage-in-proc-meminfo-and-oom-log-output mm/vmstat.c
--- a/mm/vmstat.c~mm-oom-analysis-show-kernel-stack-usage-in-proc-meminfo-and-oom-log-output
+++ a/mm/vmstat.c
@@ -639,6 +639,7 @@ static const char * const vmstat_text[] 
 	"nr_slab_reclaimable",
 	"nr_slab_unreclaimable",
 	"nr_page_table_pages",
+	"nr_kernel_stack",
 	"nr_unstable",
 	"nr_bounce",
 	"nr_vmscan_write",
_

Patches currently in -mm which might be from kosaki.motohiro@jp.fujitsu.com are

linux-next.patch
readahead-add-blk_run_backing_dev.patch
readahead-add-blk_run_backing_dev-fix.patch
readahead-add-blk_run_backing_dev-fix-fix-2.patch
mm-clean-up-page_remove_rmap.patch
mm-show_free_areas-display-slab-pages-in-two-separate-fields.patch
mm-oom-analysis-add-per-zone-statistics-to-show_free_areas.patch
mm-oom-analysis-add-buffer-cache-information-to-show_free_areas.patch
mm-oom-analysis-show-kernel-stack-usage-in-proc-meminfo-and-oom-log-output.patch
mm-oom-analysis-add-shmem-vmstat.patch
getrusage-fill-ru_maxrss-value.patch
getrusage-fill-ru_maxrss-value-update.patch
fs-symlink-write_begin-allocation-context-fix-reiser4-fix.patch

