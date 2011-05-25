From: akpm@linux-foundation.org
Subject: [merged] mm-introduce-wait_on_page_locked_killable.patch removed from -mm tree
Date: Wed, 25 May 2011 13:27:34 -0700
Message-ID: <201105252025.p4PKPvVX014442@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48709 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755678Ab1EYU0r (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 25 May 2011 16:26:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kosaki.motohiro@jp.fujitsu.com, hpa@zytor.com, kamezawa.hiroyu@jp.fujitsu.com, minchan.kim@gmail.com, mingo@elte.hu, tglx@linutronix.de, willy@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     mm: introduce wait_on_page_locked_killable()
has been removed from the -mm tree.  Its filename was
     mm-introduce-wait_on_page_locked_killable.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: introduce wait_on_page_locked_killable()
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

commit 2687a356 ("Add lock_page_killable") introduced killable
lock_page().  Similarly this patch introdues killable
wait_on_page_locked().

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>
Cc: Matthew Wilcox <willy@linux.intel.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pagemap.h |    9 +++++++++
 mm/filemap.c            |   11 +++++++++++
 2 files changed, 20 insertions(+)

diff -puN include/linux/pagemap.h~mm-introduce-wait_on_page_locked_killable include/linux/pagemap.h
--- a/include/linux/pagemap.h~mm-introduce-wait_on_page_locked_killable
+++ a/include/linux/pagemap.h
@@ -357,6 +357,15 @@ static inline int lock_page_or_retry(str
  */
 extern void wait_on_page_bit(struct page *page, int bit_nr);
 
+extern int wait_on_page_bit_killable(struct page *page, int bit_nr);
+
+static inline int wait_on_page_locked_killable(struct page *page)
+{
+	if (PageLocked(page))
+		return wait_on_page_bit_killable(page, PG_locked);
+	return 0;
+}
+
 /* 
  * Wait for a page to be unlocked.
  *
diff -puN mm/filemap.c~mm-introduce-wait_on_page_locked_killable mm/filemap.c
--- a/mm/filemap.c~mm-introduce-wait_on_page_locked_killable
+++ a/mm/filemap.c
@@ -562,6 +562,17 @@ void wait_on_page_bit(struct page *page,
 }
 EXPORT_SYMBOL(wait_on_page_bit);
 
+int wait_on_page_bit_killable(struct page *page, int bit_nr)
+{
+	DEFINE_WAIT_BIT(wait, &page->flags, bit_nr);
+
+	if (!test_bit(bit_nr, &page->flags))
+		return 0;
+
+	return __wait_on_bit(page_waitqueue(page), &wait,
+			     sleep_on_page_killable, TASK_KILLABLE);
+}
+
 /**
  * add_page_wait_queue - Add an arbitrary waiter to a page's wait queue
  * @page: Page defining the wait queue of interest
_

Patches currently in -mm which might be from kosaki.motohiro@jp.fujitsu.com are

origin.patch
linux-next.patch
mm-increase-reclaim_distance-to-30.patch
slab-use-numa_no_node.patch
m32r-convert-cpumask-api.patch
m32r-fix-spin_lock_irqsave-misuse.patch
m32r-remove-redundant-declaration.patch
getdelays-show-average-cpu-io-swap-reclaim-delays.patch
mm-move-enum-vm_event_item-into-a-standalone-header-file.patch
memcg-count-the-soft_limit-reclaim-in-global-background-reclaim.patch
memcg-add-the-soft_limit-reclaim-in-global-direct-reclaim.patch
memcg-reclaim-memory-from-nodes-in-round-robin-order.patch
memcg-reclaim-memory-from-nodes-in-round-robin-fix.patch
memcg-reclaim-memory-from-nodes-in-round-robin-fix-2.patch
memcg-reclaim-memory-from-nodes-in-round-robin-order-fix.patch
memcg-fix-get_scan_count-for-small-targets.patch
memcg-remove-unused-retry-signal-from-reclaim.patch
vmscanmemcg-memcg-aware-swap-token.patch
vmscan-implement-swap-token-trace.patch
vmscan-implement-swap-token-priority-aging.patch
add-the-pagefault-count-into-memcg-stats.patch
cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node.patch
cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node-cpusets-initialize-spread-rotor-lazily.patch
proc-put-check_mem_permission-after-__get_free_page-in-mem_write.patch
proc-fix-pagemap_read-error-case.patch
cpumask-convert-for_each_cpumask-with-for_each_cpu.patch
cpumask-convert-cpumask_of_cpu-to-cpumask_of.patch
cpumask-alloc_cpumask_var-use-numa_no_node.patch
cpumask-add-cpumask_var_t-documentation.patch
kexec-remove-kmsg_dump_kexec.patch
kexec-remove-kmsg_dump_kexec-fix.patch

