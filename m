From: akpm@linux-foundation.org
Subject: + memcg-convert-uncharge-batching-from-bytes-to-page-granularity.patch added to -mm tree
Date: Wed, 09 Feb 2011 13:35:27 -0800
Message-ID: <201102092135.p19LZRq8023529@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39192 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751455Ab1BIVfk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 Feb 2011 16:35:40 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hannes@cmpxchg.org, balbir@linux.vnet.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, nishimura@mxp.nes.nec.co.jp


The patch titled
     memcg: convert uncharge batching from bytes to page granularity
has been added to the -mm tree.  Its filename is
     memcg-convert-uncharge-batching-from-bytes-to-page-granularity.patch

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
Subject: memcg: convert uncharge batching from bytes to page granularity
From: Johannes Weiner <hannes@cmpxchg.org>

We never uncharge subpage quantities.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/sched.h |    4 ++--
 mm/memcontrol.c       |   18 ++++++++++--------
 2 files changed, 12 insertions(+), 10 deletions(-)

diff -puN include/linux/sched.h~memcg-convert-uncharge-batching-from-bytes-to-page-granularity include/linux/sched.h
--- a/include/linux/sched.h~memcg-convert-uncharge-batching-from-bytes-to-page-granularity
+++ a/include/linux/sched.h
@@ -1524,8 +1524,8 @@ struct task_struct {
 	struct memcg_batch_info {
 		int do_batch;	/* incremented when batch uncharge started */
 		struct mem_cgroup *memcg; /* target memcg of uncharge */
-		unsigned long bytes; 		/* uncharged usage */
-		unsigned long memsw_bytes; /* uncharged mem+swap usage */
+		unsigned long nr_pages;	/* uncharged usage */
+		unsigned long memsw_nr_pages; /* uncharged mem+swap usage */
 	} memcg_batch;
 #endif
 };
diff -puN mm/memcontrol.c~memcg-convert-uncharge-batching-from-bytes-to-page-granularity mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-convert-uncharge-batching-from-bytes-to-page-granularity
+++ a/mm/memcontrol.c
@@ -2569,9 +2569,9 @@ __do_uncharge(struct mem_cgroup *mem, co
 	if (batch->memcg != mem)
 		goto direct_uncharge;
 	/* remember freed charge and uncharge it later */
-	batch->bytes += PAGE_SIZE;
+	batch->nr_pages++;
 	if (uncharge_memsw)
-		batch->memsw_bytes += PAGE_SIZE;
+		batch->memsw_nr_pages++;
 	return;
 direct_uncharge:
 	res_counter_uncharge(&mem->res, page_size);
@@ -2698,8 +2698,8 @@ void mem_cgroup_uncharge_start(void)
 	/* We can do nest. */
 	if (current->memcg_batch.do_batch == 1) {
 		current->memcg_batch.memcg = NULL;
-		current->memcg_batch.bytes = 0;
-		current->memcg_batch.memsw_bytes = 0;
+		current->memcg_batch.nr_pages = 0;
+		current->memcg_batch.memsw_nr_pages = 0;
 	}
 }
 
@@ -2720,10 +2720,12 @@ void mem_cgroup_uncharge_end(void)
 	 * This "batch->memcg" is valid without any css_get/put etc...
 	 * bacause we hide charges behind us.
 	 */
-	if (batch->bytes)
-		res_counter_uncharge(&batch->memcg->res, batch->bytes);
-	if (batch->memsw_bytes)
-		res_counter_uncharge(&batch->memcg->memsw, batch->memsw_bytes);
+	if (batch->nr_pages)
+		res_counter_uncharge(&batch->memcg->res,
+				     batch->nr_pages * PAGE_SIZE);
+	if (batch->memsw_nr_pages)
+		res_counter_uncharge(&batch->memcg->memsw,
+				     batch->memsw_nr_pages * PAGE_SIZE);
 	memcg_oom_recover(batch->memcg);
 	/* forget this pointer (for sanity check) */
 	batch->memcg = NULL;
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

vmscan-fix-zone-shrinking-exit-when-scan-work-is-done.patch
mm-introduce-delete_from_page_cache.patch
mm-hugetlbfs-change-remove_from_page_cache.patch
mm-shmem-change-remove_from_page_cache.patch
mm-truncate-change-remove_from_page_cache.patch
mm-good-bye-remove_from_page_cache.patch
mm-change-__remove_from_page_cache.patch
mm-batch-free-pcp-list-if-possible.patch
mm-batch-free-pcp-list-if-possible-fix.patch
epoll-fix-compiler-warning-and-optimize-the-non-blocking-path-fix.patch
memcg-res_counter_read_u64-fix-potential-races-on-32-bit-machines.patch
memcg-fix-ugly-initialization-of-return-value-is-in-caller.patch
memcg-soft-limit-reclaim-should-end-at-limit-not-below.patch
memcg-simplify-the-way-memory-limits-are-checked.patch
memcg-remove-unused-page-flag-bitfield-defines.patch
memcg-remove-impossible-conditional-when-committing.patch
memcg-remove-null-check-from-lookup_page_cgroup-result.patch
memcg-add-memcg-sanity-checks-at-allocating-and-freeing-pages.patch
memcg-add-memcg-sanity-checks-at-allocating-and-freeing-pages-update.patch
memcg-no-uncharged-pages-reach-page_cgroup_zoneinfo.patch
memcg-change-page_cgroup_zoneinfo-signature.patch
memcg-fold-__mem_cgroup_move_account-into-caller.patch
memcg-condense-page_cgroup-to-page-lookup-points.patch
memcg-remove-direct-page_cgroup-to-page-pointer.patch
memcg-remove-direct-page_cgroup-to-page-pointer-fix.patch
memcg-remove-direct-page_cgroup-to-page-pointer-fix-fix.patch
memcg-keep-only-one-charge-cancelling-function.patch
memcg-convert-per-cpu-stock-from-bytes-to-page-granularity.patch
memcg-convert-uncharge-batching-from-bytes-to-page-granularity.patch
memcg-unify-charge-uncharge-quantities-to-units-of-pages.patch
crash_dump-export-is_kdump_kernel-to-modules-consolidate-elfcorehdr_addr-setup_elfcorehdr-and-saved_max_pfn.patch
crash_dump-export-is_kdump_kernel-to-modules-consolidate-elfcorehdr_addr-setup_elfcorehdr-and-saved_max_pfn-fix.patch
crash_dump-export-is_kdump_kernel-to-modules-consolidate-elfcorehdr_addr-setup_elfcorehdr-and-saved_max_pfn-fix-fix.patch

