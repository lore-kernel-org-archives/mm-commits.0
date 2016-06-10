From: akpm@linux-foundation.org
Subject: [merged]
 mm-introduce-dedicated-wq_mem_reclaim-workqueue-to-do-lru_add_drain_all.patch removed from -mm tree
Date: Fri, 10 Jun 2016 12:12:20 -0700
Message-ID: <575b1114.wrpenogttFPOvrvm%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50103 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932158AbcFJTMV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 10 Jun 2016 15:12:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: shhuiw@foxmail.com, keith.busch@intel.com, mingo@redhat.com, peterz@infradead.org, tj@kernel.org, treding@nvidia.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: introduce dedicated WQ_MEM_RECLAIM workqueue to do lru_add_drain_all
has been removed from the -mm tree.  Its filename was
     mm-introduce-dedicated-wq_mem_reclaim-workqueue-to-do-lru_add_drain_all.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Wang Sheng-Hui <shhuiw@foxmail.com>
Subject: mm: introduce dedicated WQ_MEM_RECLAIM workqueue to do lru_add_drain_all

This patch is based on https://patchwork.ozlabs.org/patch/574623/.

Tejun submitted commit 23d11a58a9a6 ("workqueue: skip flush dependency
checks for legacy workqueues") for the legacy create*_workqueue()
interface.  But some workq created by alloc_workqueue still reports
warning on memory reclaim, e.g nvme_workq with flag WQ_MEM_RECLAIM set:

[    0.153902] workqueue: WQ_MEM_RECLAIM nvme:nvme_reset_work is
flushing !WQ_MEM_RECLAIM events:lru_add_drain_per_cpu
[    0.153907] ------------[ cut here ]------------
[    0.153912] WARNING: CPU: 0 PID: 6 at
SoC/linux/kernel/workqueue.c:2448
check_flush_dependency+0xb4/0x10c
...
[    0.154083] [<fffffc00080d6de0>] check_flush_dependency+0xb4/0x10c
[    0.154088] [<fffffc00080d8e80>] flush_work+0x54/0x140
[    0.154092] [<fffffc0008166a0c>] lru_add_drain_all+0x138/0x188
[    0.154097] [<fffffc00081ab2dc>] migrate_prep+0xc/0x18
[    0.154101] [<fffffc0008160e88>] alloc_contig_range+0xf4/0x350
[    0.154105] [<fffffc00081bcef8>] cma_alloc+0xec/0x1e4
[    0.154110] [<fffffc0008446ad0>] dma_alloc_from_contiguous+0x38/0x40
[    0.154114] [<fffffc00080a093c>] __dma_alloc+0x74/0x25c
[    0.154119] [<fffffc00084828d8>] nvme_alloc_queue+0xcc/0x36c
[    0.154123] [<fffffc0008484b2c>] nvme_reset_work+0x5c4/0xda8
[    0.154128] [<fffffc00080d9528>] process_one_work+0x128/0x2ec
[    0.154132] [<fffffc00080d9744>] worker_thread+0x58/0x434
[    0.154136] [<fffffc00080df0ec>] kthread+0xd4/0xe8
[    0.154141] [<fffffc0008093ac0>] ret_from_fork+0x10/0x50

That's because lru_add_drain_all() will schedule the drain work on
system_wq, whose flag is set to 0, !WQ_MEM_RECLAIM.

Introduce a dedicated WQ_MEM_RECLAIM workqueue to do lru_add_drain_all(),
aiding in getting memory freed.

Link: http://lkml.kernel.org/r/1464917521-9775-1-git-send-email-shhuiw@foxmail.com
Signed-off-by: Wang Sheng-Hui <shhuiw@foxmail.com>
Acked-by: Tejun Heo <tj@kernel.org>
Cc: Keith Busch <keith.busch@intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thierry Reding <treding@nvidia.com>
Cc: Ingo Molnar <mingo@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swap.c |   20 +++++++++++++++++++-
 1 file changed, 19 insertions(+), 1 deletion(-)

diff -puN mm/swap.c~mm-introduce-dedicated-wq_mem_reclaim-workqueue-to-do-lru_add_drain_all mm/swap.c
--- a/mm/swap.c~mm-introduce-dedicated-wq_mem_reclaim-workqueue-to-do-lru_add_drain_all
+++ a/mm/swap.c
@@ -667,6 +667,24 @@ static void lru_add_drain_per_cpu(struct
 
 static DEFINE_PER_CPU(struct work_struct, lru_add_drain_work);
 
+/*
+ * lru_add_drain_wq is used to do lru_add_drain_all() from a WQ_MEM_RECLAIM
+ * workqueue, aiding in getting memory freed.
+ */
+static struct workqueue_struct *lru_add_drain_wq;
+
+static int __init lru_init(void)
+{
+	lru_add_drain_wq = alloc_workqueue("lru-add-drain", WQ_MEM_RECLAIM, 0);
+
+	if (WARN(!lru_add_drain_wq,
+		"Failed to create workqueue lru_add_drain_wq"))
+		return -ENOMEM;
+
+	return 0;
+}
+early_initcall(lru_init);
+
 void lru_add_drain_all(void)
 {
 	static DEFINE_MUTEX(lock);
@@ -686,7 +704,7 @@ void lru_add_drain_all(void)
 		    pagevec_count(&per_cpu(lru_deactivate_pvecs, cpu)) ||
 		    need_activate_page_drain(cpu)) {
 			INIT_WORK(work, lru_add_drain_per_cpu);
-			schedule_work_on(cpu, work);
+			queue_work_on(cpu, lru_add_drain_wq, work);
 			cpumask_set_cpu(cpu, &has_work);
 		}
 	}
_

Patches currently in -mm which might be from shhuiw@foxmail.com are


