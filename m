From: akpm@linux-foundation.org
Subject: [folded-merged]
 hugetlb-add-support-for-gigantic-page-allocation-at-runtime-checkpatch-fixes.patch removed from -mm tree
Date: Wed, 04 Jun 2014 15:24:32 -0700
Message-ID: <538f9ca0.qGtpHq2NkaDNNBr9%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39066 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751680AbaFDWYd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 4 Jun 2014 18:24:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, lcapitulino@redhat.com, akpm@linux-foundation.org

Subject: [folded-merged] hugetlb-add-support-for-gigantic-page-allocation-at-runtime-checkpatch-fixes.patch removed from -mm tree
To: akpm@linux-foundation.org,lcapitulino@redhat.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 04 Jun 2014 15:24:32 -0700


The patch titled
     Subject: hugetlb-add-support-for-gigantic-page-allocation-at-runtime-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     hugetlb-add-support-for-gigantic-page-allocation-at-runtime-checkpatch-fixes.patch

This patch was dropped because it was folded into hugetlb-add-support-for-gigantic-page-allocation-at-runtime.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: hugetlb-add-support-for-gigantic-page-allocation-at-runtime-checkpatch-fixes

WARNING: braces {} are not necessary for any arm of this statement
#282: FILE: mm/hugetlb.c:1650:
+		if (hstate_is_gigantic(h)) {
[...]
+		} else {
[...]

total: 0 errors, 1 warnings, 219 lines checked

./patches/hugetlb-add-support-for-gigantic-page-allocation-at-runtime.patch has style problems, please review.

If any of these errors are false positives, please report
them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Luiz Capitulino <lcapitulino@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff -puN mm/hugetlb.c~hugetlb-add-support-for-gigantic-page-allocation-at-runtime-checkpatch-fixes mm/hugetlb.c
--- a/mm/hugetlb.c~hugetlb-add-support-for-gigantic-page-allocation-at-runtime-checkpatch-fixes
+++ a/mm/hugetlb.c
@@ -1647,11 +1647,10 @@ static unsigned long set_max_huge_pages(
 		 * and reducing the surplus.
 		 */
 		spin_unlock(&hugetlb_lock);
-		if (hstate_is_gigantic(h)) {
+		if (hstate_is_gigantic(h))
 			ret = alloc_fresh_gigantic_page(h, nodes_allowed);
-		} else {
+		else
 			ret = alloc_fresh_huge_page(h, nodes_allowed);
-		}
 		spin_lock(&hugetlb_lock);
 		if (!ret)
 			goto out;
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

