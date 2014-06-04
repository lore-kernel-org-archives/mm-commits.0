From: akpm@linux-foundation.org
Subject: [folded-merged]
 kernel-res_counterc-replace-simple_strtoull-by-kstrtoull-fix.patch removed
 from -mm tree
Date: Wed, 04 Jun 2014 15:52:43 -0700
Message-ID: <538fa33b.baIYu2btPxq8hYIE%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39343 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751421AbaFDWwo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 4 Jun 2014 18:52:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tj@kernel.org, mhocko@suse.cz, fabf@skynet.be, akpm@linux-foundation.org

Subject: [folded-merged] kernel-res_counterc-replace-simple_strtoull-by-kstrtoull-fix.patch removed from -mm tree
To: akpm@linux-foundation.org,fabf@skynet.be,mhocko@suse.cz,tj@kernel.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 04 Jun 2014 15:52:43 -0700


The patch titled
     Subject: kernel-res_counterc-replace-simple_strtoull-by-kstrtoull-fix
has been removed from the -mm tree.  Its filename was
     kernel-res_counterc-replace-simple_strtoull-by-kstrtoull-fix.patch

This patch was dropped because it was folded into kernel-res_counterc-replace-simple_strtoull-by-kstrtoull.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: kernel-res_counterc-replace-simple_strtoull-by-kstrtoull-fix

don't overwrite kstrtoull()'s errno

Cc: Fabian Frederick <fabf@skynet.be>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/res_counter.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff -puN kernel/res_counter.c~kernel-res_counterc-replace-simple_strtoull-by-kstrtoull-fix kernel/res_counter.c
--- a/kernel/res_counter.c~kernel-res_counterc-replace-simple_strtoull-by-kstrtoull-fix
+++ a/kernel/res_counter.c
@@ -187,7 +187,10 @@ int res_counter_memparse_write_strategy(
 	/* return RES_COUNTER_MAX(unlimited) if "-1" is specified */
 	if (*buf == '-') {
 		int rc = kstrtoull(buf + 1, 10, &res);
-		if ((res != 1) || rc)
+
+		if (rc)
+			return rc;
+		if (res != 1)
 			return -EINVAL;
 		*resp = RES_COUNTER_MAX;
 		return 0;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
arch-unicore32-mm-ioremapc-convert-printk-warn_on-to-warn1.patch
arch-unicore32-mm-ioremapc-return-null-on-invalid-pfn.patch
ocfs2-limit-printk-when-journal-is-aborted.patch
fs-add-generic-data-flush-to-fsync.patch
mm-huge_memoryc-complete-conversion-to-pr_foo.patch
include-linux-mmdebugh-add-vm_warn_on-and-vm_warn_on_once.patch
mm-mempool-warn-about-__gfp_zero-usage.patch
mm-pass-vm_bug_on-reason-to-dump_page.patch
hugetlb-add-support-for-gigantic-page-allocation-at-runtime.patch
fs-hugetlbfs-inodec-complete-conversion-to-pr_foo.patch
mm-compaction-cleanup-isolate_freepages.patch
arc-call-find_vma-with-the-mmap_sem-held.patch
mm-vmscan-do-not-throttle-based-on-pfmemalloc-reserves-if-node-has-no-zone_normal.patch
swap-use-bdev_read_page-bdev_write_page.patch
mm-update-comment-for-default_max_map_count.patch
memcg-fold-mem_cgroup_stolen.patch
mm-compaction-embed-migration-mode-in-compact_control.patch
mm-add-comment-for-__mod_zone_page_stat.patch
mm-fold-mlocked_vma_newpage-into-its-only-call-site.patch
fs-buffer-do-not-use-unnecessary-atomic-operations-when-discarding-buffers.patch
mm-non-atomically-mark-page-accessed-during-page-cache-allocation-where-possible.patch
mm-compaction-properly-signal-and-act-upon-lock-and-need_sched-contention.patch
mm-document-do_fault_around-feature.patch
mm-memory-failurec-support-dedicated-thread-to-handle-sigbusbus_mceerr_ao.patch
kernel-res_counterc-replace-simple_strtoull-by-kstrtoull.patch
printk-release-lockbuf_lock-before-calling-console_trylock_for_printk-fix.patch
lib-btreec-fix-leak-of-whole-btree-nodes-fix.patch
init-mainc-dont-use-pr_debug.patch
init-mainc-add-initcall_blacklist-kernel-parameter-fix.patch
init-mainc-remove-an-ifdef.patch

