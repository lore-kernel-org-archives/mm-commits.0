From: akpm@linux-foundation.org
Subject: [folded-dropped] mm-mmu_notifier-fix-inconsistent-memory-between-secondary-mmu-and-host-fix.patch removed from -mm tree
Date: Mon, 08 Oct 2012 16:03:36 -0700
Message-ID: <20121008230337.B78005C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-la0-f74.google.com ([209.85.215.74]:42536 "EHLO
	mail-la0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753225Ab2JHXDl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Oct 2012 19:03:41 -0400
Received: by mail-la0-f74.google.com with SMTP id j13so239889lah.1
        for <mm-commits@vger.kernel.org>; Mon, 08 Oct 2012 16:03:39 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, aarcange@redhat.com, avi@redhat.com, hughd@google.com, mtosatti@redhat.com, xiaoguangrong@linux.vnet.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-mmu_notifier-fix-inconsistent-memory-between-secondary-mmu-and-host-fix
has been removed from the -mm tree.  Its filename was
     mm-mmu_notifier-fix-inconsistent-memory-between-secondary-mmu-and-host-fix.patch

This patch was dropped because it was folded into mm-mmu_notifier-fix-inconsistent-memory-between-secondary-mmu-and-host.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-mmu_notifier-fix-inconsistent-memory-between-secondary-mmu-and-host-fix

add comment from Andrea

Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Avi Kivity <avi@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>
Cc: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmu_notifier.h |   10 ++++++++++
 1 file changed, 10 insertions(+)

diff -puN include/linux/mmu_notifier.h~mm-mmu_notifier-fix-inconsistent-memory-between-secondary-mmu-and-host-fix include/linux/mmu_notifier.h
--- a/include/linux/mmu_notifier.h~mm-mmu_notifier-fix-inconsistent-memory-between-secondary-mmu-and-host-fix
+++ a/include/linux/mmu_notifier.h
@@ -311,6 +311,16 @@ static inline void mmu_notifier_mm_destr
 	__young;							\
 })
 
+/*
+ * set_pte_at_notify() sets the pte _after_ running the notifier.
+ * This is safe to start by updating the secondary MMUs, because the primary MMU
+ * pte invalidate must have already happened with a ptep_clear_flush() before
+ * set_pte_at_notify() has been invoked.  Updating the secondary MMUs first is
+ * required when we change both the protection of the mapping from read-only to
+ * read-write and the pfn (like during copy on write page faults). Otherwise the
+ * old page would remain mapped readonly in the secondary MMUs after the new
+ * page is already writable by some CPU through the primary MMU.
+ */
 #define set_pte_at_notify(__mm, __address, __ptep, __pte)		\
 ({									\
 	struct mm_struct *___mm = __mm;					\
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
x86-pat-separate-the-pfn-attribute-tracking-for-remap_pfn_range-and-vm_insert_pfn.patch
mm-kill-vma-flag-vm_reserved-and-mm-reserved_vm-counter.patch
mm-fix-nonuniform-page-status-when-writing-new-file-with-small-buffer.patch
mm-vmscan-scale-number-of-pages-reclaimed-by-reclaim-compaction-based-on-failures.patch
mm-mmu_notifier-fix-inconsistent-memory-between-secondary-mmu-and-host.patch
rbtree-performance-and-correctness-test-fix.patch
mm-cma-discard-clean-pages-during-contiguous-allocation-instead-of-migration-fix-fix.patch
mm-fix-tracing-in-free_pcppages_bulk-fix.patch
cma-count-free-cma-pages-fix.patch
memory-hotplug-fix-pages-missed-by-race-rather-than-failng-fix.patch
atomic-implement-generic-atomic_dec_if_positive-fix.patch
mm-compaction-abort-compaction-loop-if-lock-is-contended-or-run-too-long.patch
mm-compaction-abort-compaction-loop-if-lock-is-contended-or-run-too-long-fix.patch
mm-compaction-abort-compaction-loop-if-lock-is-contended-or-run-too-long-fix-2.patch
mm-compaction-acquire-the-zone-lru_lock-as-late-as-possible-fix-fix.patch
mm-page_alloc-refactor-out-__alloc_contig_migrate_alloc-checkpatch-fixes.patch
mm-fix-invalidate_complete_page2-lock-ordering.patch
mm-numa-reclaim-from-all-nodes-within-reclaim-distance-fix.patch
mm-move-all-mmu-notifier-invocations-to-be-done-outside-the-pt-lock.patch
cma-migrate-mlocked-pages-fix.patch
mm-avoid-section-mismatch-warning-for-memblock_type_name-fix.patch
mm-document-pagehuge-somewhat.patch
mm-memcg-clean-up-mm_match_cgroup-signature-fix.patch
memory-hotplug-suppress-trying-to-free-nonexistent-resource-xxxxxxxxxxxxxxxx-yyyyyyyyyyyyyyyy-warning.patch
mm-add-and-use-update_mmu_cache_pmd-in-transparent-huge-page-code-fix.patch

