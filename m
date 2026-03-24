Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97067362133
	for <mm-commits@vger.kernel.org>; Tue, 24 Mar 2026 21:43:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774388605; cv=none; b=cr7501bg2tuKvb5cToqOxjQJ74aVox2OfJ0gYHqg4KFydXWs7o9RGswjfi3AiRm9Iqtyozyom6E3kmOQo5Ka4w72Y0qZaUnMMGIYXMooWFSk7CkiplJL/ofTs5yjWx2HIp+BImpjLxn4QjW9yxXFzfa3k3D2yKOeDkyxpZNuN8M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774388605; c=relaxed/simple;
	bh=wxNZZuJf0l+yBp2fMnWBy1sfdpbcQCnHXyYQIq1Cz5M=;
	h=Date:To:From:Subject:Message-Id; b=J6BmyOkE1FzJydbZD+oU+hzIVQpB6MCAnlt6S2x7UGDsnNzV38+T7iHZAFUr5msYd88vTa0NOcEp9PuymIvUWfoi6Zu/StUZJYuNgt5kXGKuT/c/rrdXbhkFfA+jrlaLtLzxwkyIxq20AAYLmVjHyiYPsBYFZPOrgtS1WQfK1YY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=09vIfs7S; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="09vIfs7S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 714F8C19424;
	Tue, 24 Mar 2026 21:43:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774388605;
	bh=wxNZZuJf0l+yBp2fMnWBy1sfdpbcQCnHXyYQIq1Cz5M=;
	h=Date:To:From:Subject:From;
	b=09vIfs7S/MBp6XdFlEGO21D3YVjS4hS9oG8xE9BE93MFyXWMFwaI3oV9DMQHlg1iQ
	 omIYqLztgoNfmK0OASZdD2woT5zAIS8cypctmDKjotNiIH5w06hDyEbBSG+L513MZX
	 opCajC+mmNTJRSotR1/Jhhoz9RJLr8WN+QZnEcYk=
Date: Tue, 24 Mar 2026 14:43:24 -0700
To: mm-commits@vger.kernel.org,will@kernel.org,peterz@infradead.org,npiggin@gmail.com,david@kernel.org,dave.hansen@intel.com,arnd@arndb.de,lance.yang@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-mmu_gather-replace-ipi-with-synchronize_rcu-when-batch-allocation-fails.patch removed from -mm tree
Message-Id: <20260324214325.714F8C19424@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/mmu_gather: replace IPI with synchronize_rcu() when batch allocation fails
has been removed from the -mm tree.  Its filename was
     mm-mmu_gather-replace-ipi-with-synchronize_rcu-when-batch-allocation-fails.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Lance Yang <lance.yang@linux.dev>
Subject: mm/mmu_gather: replace IPI with synchronize_rcu() when batch allocation fails
Date: Tue, 24 Feb 2026 22:21:01 +0800

When freeing page tables, we try to batch them.  If batch allocation fails
(GFP_NOWAIT), __tlb_remove_table_one() immediately frees the one without
batching.

On !CONFIG_PT_RECLAIM, the fallback sends an IPI to all CPUs via
tlb_remove_table_sync_one().  It disrupts all CPUs even when only a single
process is unmapping memory.  IPI broadcast was reported to hurt RT
workloads[1].

tlb_remove_table_sync_one() synchronizes with lockless page-table walkers
(e.g.  GUP-fast) that rely on IRQ disabling.  These walkers use
local_irq_disable(), which is also an RCU read-side critical section.

This patch introduces tlb_remove_table_sync_rcu() which uses RCU grace
period (synchronize_rcu()) instead of IPI broadcast.  This provides the
same guarantee as IPI but without disrupting all CPUs.  Since batch
allocation already failed, we are in a slow path where sleeping is
acceptable - we are in process context (unmap_region, exit_mmap) with only
mmap_lock held.

tlb_remove_table_sync_one() is retained for other callers (e.g.,
khugepaged after pmdp_collapse_flush(), tlb_finish_mmu() when
tlb->fully_unshared_tables) that are not slow paths.  Converting those may
require different approaches such as targeted IPIs.

Link: https://lore.kernel.org/linux-mm/1b27a3fa-359a-43d0-bdeb-c31341749367@kernel.org/ [1]
Link: https://lore.kernel.org/linux-mm/20260202150957.GD1282955@noisy.programming.kicks-ass.net/
Link: https://lore.kernel.org/linux-mm/dfdfeac9-5cd5-46fc-a5c1-9ccf9bd3502a@intel.com/
Link: https://lore.kernel.org/linux-mm/bc489455-bb18-44dc-8518-ae75abda6bec@kernel.org/
Link: https://lkml.kernel.org/r/20260224142101.20500-1-lance.yang@linux.dev
Signed-off-by: Lance Yang <lance.yang@linux.dev>
Suggested-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Suggested-by: Dave Hansen <dave.hansen@intel.com>
Suggested-by: David Hildenbrand (Arm) <david@kernel.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Nick Piggin <npiggin@gmail.com>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-generic/tlb.h |    4 ++++
 mm/mmu_gather.c           |   21 ++++++++++++++++++++-
 2 files changed, 24 insertions(+), 1 deletion(-)

--- a/include/asm-generic/tlb.h~mm-mmu_gather-replace-ipi-with-synchronize_rcu-when-batch-allocation-fails
+++ a/include/asm-generic/tlb.h
@@ -251,6 +251,8 @@ static inline void tlb_remove_table(stru
 
 void tlb_remove_table_sync_one(void);
 
+void tlb_remove_table_sync_rcu(void);
+
 #else
 
 #ifdef tlb_needs_table_invalidate
@@ -259,6 +261,8 @@ void tlb_remove_table_sync_one(void);
 
 static inline void tlb_remove_table_sync_one(void) { }
 
+static inline void tlb_remove_table_sync_rcu(void) { }
+
 #endif /* CONFIG_MMU_GATHER_RCU_TABLE_FREE */
 
 
--- a/mm/mmu_gather.c~mm-mmu_gather-replace-ipi-with-synchronize_rcu-when-batch-allocation-fails
+++ a/mm/mmu_gather.c
@@ -296,6 +296,25 @@ static void tlb_remove_table_free(struct
 	call_rcu(&batch->rcu, tlb_remove_table_rcu);
 }
 
+/**
+ * tlb_remove_table_sync_rcu - synchronize with software page-table walkers
+ *
+ * Like tlb_remove_table_sync_one() but uses RCU grace period instead of IPI
+ * broadcast. Use in slow paths where sleeping is acceptable.
+ *
+ * Software/Lockless page-table walkers use local_irq_disable(), which is also
+ * an RCU read-side critical section. synchronize_rcu() waits for all such
+ * sections, providing the same guarantee as tlb_remove_table_sync_one() but
+ * without disrupting all CPUs with IPIs.
+ *
+ * Do not use for freeing memory. Use RCU callbacks instead to avoid latency
+ * spikes.
+ */
+void tlb_remove_table_sync_rcu(void)
+{
+	synchronize_rcu();
+}
+
 #else /* !CONFIG_MMU_GATHER_RCU_TABLE_FREE */
 
 static void tlb_remove_table_free(struct mmu_table_batch *batch)
@@ -339,7 +358,7 @@ static inline void __tlb_remove_table_on
 #else
 static inline void __tlb_remove_table_one(void *table)
 {
-	tlb_remove_table_sync_one();
+	tlb_remove_table_sync_rcu();
 	__tlb_remove_table(table);
 }
 #endif /* CONFIG_PT_RECLAIM */
_

Patches currently in -mm which might be from lance.yang@linux.dev are


