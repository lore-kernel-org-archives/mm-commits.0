From: akpm@linux-foundation.org
Subject: [folded-merged]
 arc-call-find_vma-with-the-mmap_sem-held-fix.patch removed from -mm tree
Date: Wed, 04 Jun 2014 15:26:15 -0700
Message-ID: <538f9d07.Qc5vhHxX7W7E0snu%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39104 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751900AbaFDW0P (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 4 Jun 2014 18:26:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, vgupta@synopsys.com, davidlohr@hp.com, akpm@linux-foundation.org

Subject: [folded-merged] arc-call-find_vma-with-the-mmap_sem-held-fix.patch removed from -mm tree
To: akpm@linux-foundation.org,davidlohr@hp.com,vgupta@synopsys.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 04 Jun 2014 15:26:15 -0700


The patch titled
     Subject: arc-call-find_vma-with-the-mmap_sem-held-fix
has been removed from the -mm tree.  Its filename was
     arc-call-find_vma-with-the-mmap_sem-held-fix.patch

This patch was dropped because it was folded into arc-call-find_vma-with-the-mmap_sem-held.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: arc-call-find_vma-with-the-mmap_sem-held-fix

CSE current->active_mm, per Vineet

Cc: Davidlohr Bueso <davidlohr@hp.com>
Cc: Vineet Gupta <vgupta@synopsys.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arc/kernel/troubleshoot.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff -puN arch/arc/kernel/troubleshoot.c~arc-call-find_vma-with-the-mmap_sem-held-fix arch/arc/kernel/troubleshoot.c
--- a/arch/arc/kernel/troubleshoot.c~arc-call-find_vma-with-the-mmap_sem-held-fix
+++ a/arch/arc/kernel/troubleshoot.c
@@ -86,12 +86,13 @@ static void show_faulting_vma(unsigned l
 	unsigned long ino = 0;
 	dev_t dev = 0;
 	char *nm = buf;
+	struct mm_struct *active_mm = current->active_mm;
 
 	/* can't use print_vma_addr() yet as it doesn't check for
 	 * non-inclusive vma
 	 */
-	down_read(&current->active_mm->mmap_sem);
-	vma = find_vma(current->active_mm, address);
+	down_read(&active_mm->mmap_sem);
+	vma = find_vma(active_mm, address);
 
 	/* check against the find_vma( ) behaviour which returns the next VMA
 	 * if the container VMA is not found
@@ -113,7 +114,7 @@ static void show_faulting_vma(unsigned l
 	} else
 		pr_info("    @No matching VMA found\n");
 
-	up_read(&current->active_mm->mmap_sem);
+	up_read(&active_mm->mmap_sem);
 }
 
 static void show_ecr_verbose(struct pt_regs *regs)
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

