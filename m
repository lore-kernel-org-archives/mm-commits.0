Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B28A6C43334
	for <mm-commits@archiver.kernel.org>; Mon,  4 Jul 2022 01:11:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232901AbiGDBLr (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 3 Jul 2022 21:11:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232904AbiGDBKw (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 3 Jul 2022 21:10:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15B886349
        for <mm-commits@vger.kernel.org>; Sun,  3 Jul 2022 18:10:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A563961305
        for <mm-commits@vger.kernel.org>; Mon,  4 Jul 2022 01:10:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05B66C341C6;
        Mon,  4 Jul 2022 01:10:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1656897031;
        bh=iFlDg/6u+X5wThp3nDfef9n/giiieW0u43HcLyx0S5Y=;
        h=Date:To:From:Subject:From;
        b=xciarVj2KWfR5BFA9IGEps0AN7eEOIo4o4GCqyfc7QxMP5CB1LgVK38Akead84YKF
         OB7tD8aNgbkmCe8ZEPY4ItPPXTdw0tTAB0suTXP96bG9EjNofCM954iMq8E8ou47za
         ReJ6F0sVpxV7xgipKgmRIldyyBMlXYNyK+/Ixf9Q=
Date:   Sun, 03 Jul 2022 18:10:30 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-swap-pull-the-cpu-conditional-out-of-__lru_add_drain_all.patch removed from -mm tree
Message-Id: <20220704011031.05B66C341C6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/swap: pull the CPU conditional out of __lru_add_drain_all()
has been removed from the -mm tree.  Its filename was
     mm-swap-pull-the-cpu-conditional-out-of-__lru_add_drain_all.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm/swap: pull the CPU conditional out of __lru_add_drain_all()
Date: Fri, 17 Jun 2022 18:50:08 +0100

The function is too long, so pull this complicated conditional out into
cpu_needs_drain().  This ends up shrinking the text by 14 bytes,
by allowing GCC to cache the result of calling per_cpu() instead of
relocating each lookup individually.

Link: https://lkml.kernel.org/r/20220617175020.717127-11-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swap.c |   24 ++++++++++++++++--------
 1 file changed, 16 insertions(+), 8 deletions(-)

--- a/mm/swap.c~mm-swap-pull-the-cpu-conditional-out-of-__lru_add_drain_all
+++ a/mm/swap.c
@@ -765,6 +765,21 @@ static void lru_add_drain_per_cpu(struct
 	lru_add_and_bh_lrus_drain();
 }
 
+static bool cpu_needs_drain(unsigned int cpu)
+{
+	struct cpu_fbatches *fbatches = &per_cpu(cpu_fbatches, cpu);
+
+	/* Check these in order of likelihood that they're not zero */
+	return folio_batch_count(&fbatches->lru_add) ||
+		data_race(folio_batch_count(&per_cpu(lru_rotate.fbatch, cpu))) ||
+		folio_batch_count(&fbatches->lru_deactivate_file) ||
+		folio_batch_count(&fbatches->lru_deactivate) ||
+		folio_batch_count(&fbatches->lru_lazyfree) ||
+		folio_batch_count(&fbatches->activate) ||
+		need_mlock_page_drain(cpu) ||
+		has_bh_in_lru(cpu, NULL);
+}
+
 /*
  * Doesn't need any cpu hotplug locking because we do rely on per-cpu
  * kworkers being shut down before our page_alloc_cpu_dead callback is
@@ -849,14 +864,7 @@ static inline void __lru_add_drain_all(b
 	for_each_online_cpu(cpu) {
 		struct work_struct *work = &per_cpu(lru_add_drain_work, cpu);
 
-		if (folio_batch_count(&per_cpu(cpu_fbatches.lru_add, cpu)) ||
-		    data_race(folio_batch_count(&per_cpu(lru_rotate.fbatch, cpu))) ||
-		    folio_batch_count(&per_cpu(cpu_fbatches.lru_deactivate_file, cpu)) ||
-		    folio_batch_count(&per_cpu(cpu_fbatches.lru_deactivate, cpu)) ||
-		    folio_batch_count(&per_cpu(cpu_fbatches.lru_lazyfree, cpu)) ||
-		    folio_batch_count(&per_cpu(cpu_fbatches.activate, cpu)) ||
-		    need_mlock_page_drain(cpu) ||
-		    has_bh_in_lru(cpu, NULL)) {
+		if (cpu_needs_drain(cpu)) {
 			INIT_WORK(work, lru_add_drain_per_cpu);
 			queue_work_on(cpu, mm_percpu_wq, work);
 			__cpumask_set_cpu(cpu, &has_work);
_

Patches currently in -mm which might be from willy@infradead.org are

mm-swap-optimise-lru_add_drain_cpu.patch
mm-swap-convert-try_to_free_swap-to-use-a-folio.patch
mm-swap-convert-release_pages-to-use-a-folio-internally.patch
mm-swap-convert-put_pages_list-to-use-folios.patch
mm-swap-convert-__put_page-to-__folio_put.patch
mm-swap-convert-__put_single_page-to-__folio_put_small.patch
mm-swap-convert-__put_compound_page-to-__folio_put_large.patch
mm-swap-convert-__page_cache_release-to-use-a-folio.patch
mm-convert-destroy_compound_page-to-destroy_large_folio.patch
mm-convert-page_swap_flags-to-folio_swap_flags.patch
mm-swap-convert-delete_from_swap_cache-to-take-a-folio.patch
mm-swap-convert-__delete_from_swap_cache-to-a-folio.patch
mm-add-vma-iterator.patch
mmap-use-the-vma-iterator-in-count_vma_pages_range.patch
proc-remove-vma-rbtree-use-from-nommu.patch
arm64-remove-mmap-linked-list-from-vdso.patch
parisc-remove-mmap-linked-list-from-cache-handling.patch
powerpc-remove-mmap-linked-list-walks.patch
s390-remove-vma-linked-list-walks.patch
x86-remove-vma-linked-list-walks.patch
xtensa-remove-vma-linked-list-walks.patch
cxl-remove-vma-linked-list-walk.patch
optee-remove-vma-linked-list-walk.patch
um-remove-vma-linked-list-walk.patch
coredump-remove-vma-linked-list-walk.patch
exec-use-vma-iterator-instead-of-linked-list.patch
fs-proc-task_mmu-stop-using-linked-list-and-highest_vm_end.patch
acct-use-vma-iterator-instead-of-linked-list.patch
perf-use-vma-iterator.patch
sched-use-maple-tree-iterator-to-walk-vmas.patch
fork-use-vma-iterator.patch
mm-khugepaged-stop-using-vma-linked-list.patch
mm-ksm-use-vma-iterators-instead-of-vma-linked-list.patch
mm-mlock-use-vma-iterator-and-maple-state-instead-of-vma-linked-list.patch
mm-pagewalk-use-vma_find-instead-of-vma-linked-list.patch
i915-use-the-vma-iterator.patch
nommu-remove-uses-of-vma-linked-list.patch
mips-rename-pmd_order-to-pmd_table_order.patch

