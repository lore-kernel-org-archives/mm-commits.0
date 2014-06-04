From: akpm@linux-foundation.org
Subject: [folded-merged]
 ocfs2-limit-printk-when-journal-is-aborted-fix.patch removed from -mm tree
Date: Wed, 04 Jun 2014 15:19:41 -0700
Message-ID: <538f9b7d.C6uv8PxYcy6aNo+z%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38933 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751000AbaFDWTm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 4 Jun 2014 18:19:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mfasheh@suse.com, joseph.qi@huawei.com, jlbec@evilplan.org, akpm@linux-foundation.org

Subject: [folded-merged] ocfs2-limit-printk-when-journal-is-aborted-fix.patch removed from -mm tree
To: akpm@linux-foundation.org,jlbec@evilplan.org,joseph.qi@huawei.com,mfasheh@suse.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 04 Jun 2014 15:19:41 -0700


The patch titled
     Subject: ocfs2-limit-printk-when-journal-is-aborted-fix
has been removed from the -mm tree.  Its filename was
     ocfs2-limit-printk-when-journal-is-aborted-fix.patch

This patch was dropped because it was folded into ocfs2-limit-printk-when-journal-is-aborted.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: ocfs2-limit-printk-when-journal-is-aborted-fix

document the msleep

Cc: Joel Becker <jlbec@evilplan.org>
Cc: Joseph Qi <joseph.qi@huawei.com>
Cc: Mark Fasheh <mfasheh@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/journal.c |    5 +++++
 1 file changed, 5 insertions(+)

diff -puN fs/ocfs2/journal.c~ocfs2-limit-printk-when-journal-is-aborted-fix fs/ocfs2/journal.c
--- a/fs/ocfs2/journal.c~ocfs2-limit-printk-when-journal-is-aborted-fix
+++ a/fs/ocfs2/journal.c
@@ -2193,6 +2193,11 @@ static int ocfs2_commit_thread(void *arg
 			if (printk_timed_ratelimit(&abort_warn_time, 60*HZ))
 				mlog(ML_ERROR, "status = %d, journal is "
 						"already aborted.\n", status);
+			/*
+			 * After ocfs2_commit_cache() fails, j_num_trans has a
+			 * non-zero value.  Sleep here to avoid a busy-wait
+			 * loop.
+			 */
 			msleep_interruptible(1000);
 		}
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
arch-unicore32-mm-ioremapc-convert-printk-warn_on-to-warn1.patch
arch-unicore32-mm-ioremapc-return-null-on-invalid-pfn.patch
ocfs2-limit-printk-when-journal-is-aborted.patch
fs-add-generic-data-flush-to-fsync-fix.patch
fs-add-generic-data-flush-to-fsync-fix-fix.patch
mm-huge_memoryc-complete-conversion-to-pr_foo.patch
include-linux-mmdebugh-add-vm_warn_on-and-vm_warn_on_once.patch
mm-mempool-warn-about-__gfp_zero-usage-fix.patch
mm-pass-vm_bug_on-reason-to-dump_page-fix.patch
hugetlb-add-support-for-gigantic-page-allocation-at-runtime-checkpatch-fixes.patch
mm-page_alloc-do-not-cache-reclaim-distances-fix.patch
fs-hugetlbfs-inodec-complete-conversion-to-pr_foo.patch
mm-compaction-cleanup-isolate_freepages-fix.patch
arc-call-find_vma-with-the-mmap_sem-held-fix.patch
mm-vmscan-do-not-throttle-based-on-pfmemalloc-reserves-if-node-has-no-zone_normal-checkpatch-fixes.patch
swap-use-bdev_read_page-bdev_write_page-fix.patch
mm-update-comment-for-default_max_map_count-fix.patch
memcg-fold-mem_cgroup_stolen-fix.patch
mm-compaction-embed-migration-mode-in-compact_control-fix.patch
mm-add-comment-for-__mod_zone_page_stat.patch
mm-add-comment-for-__mod_zone_page_stat-checkpatch-fixes.patch
mm-fold-mlocked_vma_newpage-into-its-only-call-site.patch
mm-fold-mlocked_vma_newpage-into-its-only-call-site-checkpatch-fixes.patch
fs-buffer-do-not-use-unnecessary-atomic-operations-when-discarding-buffers-fix.patch
mm-non-atomically-mark-page-accessed-during-page-cache-allocation-where-possiblefix-2.patch
mm-compaction-properly-signal-and-act-upon-lock-and-need_sched-contention-fix.patch
mm-document-do_fault_around-feature-fix.patch
mm-memory-failurec-support-dedicated-thread-to-handle-sigbusbus_mceerr_ao-checkpatch-fixes.patch
kernel-res_counterc-replace-simple_strtoull-by-kstrtoull-fix.patch
printk-release-lockbuf_lock-before-calling-console_trylock_for_printk-fix.patch
lib-btreec-fix-leak-of-whole-btree-nodes-fix.patch
init-mainc-dont-use-pr_debug.patch
init-mainc-add-initcall_blacklist-kernel-parameter-fix.patch
init-mainc-remove-an-ifdef.patch

