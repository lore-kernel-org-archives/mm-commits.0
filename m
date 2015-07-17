From: akpm@linux-foundation.org
Subject: + mm-meminit-replace-rwsem-with-completion.patch added to -mm
 tree
Date: Fri, 17 Jul 2015 13:25:30 -0700
Message-ID: <55a964ba.my4CiReGRQaYRG4F%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38578 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751893AbbGQUZb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 17 Jul 2015 16:25:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: nicstange@gmail.com, alexng@microsoft.com, dave.hansen@intel.com, fengguang.wu@intel.com, mgorman@suse.de, peterz@infradead.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, meminit: replace rwsem with completion
has been added to the -mm tree.  Its filename is
     mm-meminit-replace-rwsem-with-completion.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-meminit-replace-rwsem-with-completion.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-meminit-replace-rwsem-with-completion.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Nicolai Stange <nicstange@gmail.com>
Subject: mm, meminit: replace rwsem with completion

Commit 0e1cc95b4cc7 ("mm: meminit: finish initialisation of struct pages
before basic setup") introduced a rwsem to signal completion of the
initialization workers.

Lockdep complains about possible recursive locking:
  =============================================
  [ INFO: possible recursive locking detected ]
  4.1.0-12802-g1dc51b8 #3 Not tainted
  ---------------------------------------------
  swapper/0/1 is trying to acquire lock:
  (pgdat_init_rwsem){++++.+},
    at: [<ffffffff8424c7fb>] page_alloc_init_late+0xc7/0xe6

  but task is already holding lock:
  (pgdat_init_rwsem){++++.+},
    at: [<ffffffff8424c772>] page_alloc_init_late+0x3e/0xe6

Replace the rwsem by a completion together with an atomic
"outstanding work counter".

[peterz@infradead.org: Barrier removal on the grounds of being pointless]
[mgorman@suse.de: Applied review feedback]
Signed-off-by: Nicolai Stange <nicstange@gmail.com>
Signed-off-by: Mel Gorman <mgorman@suse.de>
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Alex Ng <alexng@microsoft.com>
Cc: Fengguang Wu <fengguang.wu@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   22 +++++++++++++++-------
 1 file changed, 15 insertions(+), 7 deletions(-)

diff -puN mm/page_alloc.c~mm-meminit-replace-rwsem-with-completion mm/page_alloc.c
--- a/mm/page_alloc.c~mm-meminit-replace-rwsem-with-completion
+++ a/mm/page_alloc.c
@@ -18,7 +18,6 @@
 #include <linux/mm.h>
 #include <linux/swap.h>
 #include <linux/interrupt.h>
-#include <linux/rwsem.h>
 #include <linux/pagemap.h>
 #include <linux/jiffies.h>
 #include <linux/bootmem.h>
@@ -1060,7 +1059,15 @@ static void __init deferred_free_range(s
 		__free_pages_boot_core(page, pfn, 0);
 }
 
-static __initdata DECLARE_RWSEM(pgdat_init_rwsem);
+/* Completion tracking for deferred_init_memmap() threads */
+static atomic_t pgdat_init_n_undone __initdata;
+static __initdata DECLARE_COMPLETION(pgdat_init_all_done_comp);
+
+static inline void __init pgdat_init_report_one_done(void)
+{
+	if (atomic_dec_and_test(&pgdat_init_n_undone))
+		complete(&pgdat_init_all_done_comp);
+}
 
 /* Initialise remaining memory on a node */
 static int __init deferred_init_memmap(void *data)
@@ -1077,7 +1084,7 @@ static int __init deferred_init_memmap(v
 	const struct cpumask *cpumask = cpumask_of_node(pgdat->node_id);
 
 	if (first_init_pfn == ULONG_MAX) {
-		up_read(&pgdat_init_rwsem);
+		pgdat_init_report_one_done();
 		return 0;
 	}
 
@@ -1177,7 +1184,8 @@ free_range:
 
 	pr_info("node %d initialised, %lu pages in %ums\n", nid, nr_pages,
 					jiffies_to_msecs(jiffies - start));
-	up_read(&pgdat_init_rwsem);
+
+	pgdat_init_report_one_done();
 	return 0;
 }
 
@@ -1185,14 +1193,14 @@ void __init page_alloc_init_late(void)
 {
 	int nid;
 
+	/* There will be num_node_state(N_MEMORY) threads */
+	atomic_set(&pgdat_init_n_undone, num_node_state(N_MEMORY));
 	for_each_node_state(nid, N_MEMORY) {
-		down_read(&pgdat_init_rwsem);
 		kthread_run(deferred_init_memmap, NODE_DATA(nid), "pgdatinit%d", nid);
 	}
 
 	/* Block until all are initialised */
-	down_write(&pgdat_init_rwsem);
-	up_write(&pgdat_init_rwsem);
+	wait_for_completion(&pgdat_init_all_done_comp);
 }
 #endif /* CONFIG_DEFERRED_STRUCT_PAGE_INIT */
 
_

Patches currently in -mm which might be from nicstange@gmail.com are

mm-meminit-allow-early_pfn_to_nid-to-be-used-during-runtime.patch
mm-meminit-replace-rwsem-with-completion.patch
fs-file-table-reinit-files_statmax_files-after-deferred-memory-initialisation.patch

