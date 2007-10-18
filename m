From: akpm@linux-foundation.org
Subject: + slub-avoid-atomic-operation-for-slab_unlock.patch added to -mm tree
Date: Thu, 18 Oct 2007 15:31:36 -0700
Message-ID: <200710182231.l9IMVaPG001850@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52747 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754684AbXJRWbj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Oct 2007 18:31:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: clameter@sgi.com, nickpiggin@yahoo.com.au


The patch titled
     SLUB: avoid atomic operation for slab_unlock
has been added to the -mm tree.  Its filename is
     slub-avoid-atomic-operation-for-slab_unlock.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: SLUB: avoid atomic operation for slab_unlock
From: Christoph Lameter <clameter@sgi.com>

Currently page flags are only modified in SLUB under page lock.  This means
that we do not need an atomic operation to release the lock since there is
nothing we can race against that is modifying page flags.  We can simply
clear the bit without the use of an atomic operation and make sure that
this change becomes visible after the other changes to slab metadata
through a memory barrier.

The performance of slab_free() increases 10-15% (SMP configuration doing
a long series of remote frees).

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |   15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff -puN mm/slub.c~slub-avoid-atomic-operation-for-slab_unlock mm/slub.c
--- a/mm/slub.c~slub-avoid-atomic-operation-for-slab_unlock
+++ a/mm/slub.c
@@ -1181,9 +1181,22 @@ static __always_inline void slab_lock(st
 	bit_spin_lock(PG_locked, &page->flags);
 }
 
+/*
+ * Slab unlock version that avoids having to use atomic operations
+ * (echos some of the code of bit_spin_unlock!)
+ */
 static __always_inline void slab_unlock(struct page *page)
 {
-	bit_spin_unlock(PG_locked, &page->flags);
+#ifdef CONFIG_SMP
+	unsigned long flags;
+
+	flags = page->flags & ~(1 << PG_locked);
+
+	smp_wmb();
+	page->flags = flags;
+#endif
+	preempt_enable();
+	__release(bitlock);
 }
 
 static __always_inline int slab_trylock(struct page *page)
_

Patches currently in -mm which might be from clameter@sgi.com are

origin.patch
cpu-hotplug-slab-cleanup-cpuup_callback.patch
cpu-hotplug-slab-fix-memory-leak-in-cpu-hotplug-error-path.patch
bit_spin_lock-use-lock-bitops.patch
ext3-support-large-blocksize-up-to-pagesize.patch
git-parisc.patch
mem-policy-fix-mempolicy-usage-in-pci-driver.patch
slab-api-remove-useless-ctor-parameter-and-reorder-parameters-vs-unionfs.patch
git-x86.patch
slub-avoid-atomic-operation-for-slab_unlock.patch
intel-iommu-dmar-detection-and-parsing-logic.patch
intel-iommu-pci-generic-helper-function.patch
intel-iommu-clflush_cache_range-now-takes-size-param.patch
intel-iommu-iova-allocation-and-management-routines.patch
intel-iommu-intel-iommu-driver.patch
intel-iommu-avoid-memory-allocation-failures-in-dma-map-api-calls.patch
intel-iommu-intel-iommu-cmdline-option-forcedac.patch
intel-iommu-dmar-fault-handling-support.patch
intel-iommu-iommu-gfx-workaround.patch
intel-iommu-iommu-floppy-workaround.patch
revoke-core-code.patch
slab-api-remove-useless-ctor-parameter-and-reorder-parameters-vs-revoke.patch
cpuset-zero-malloc-revert-the-old-cpuset-fix.patch
memcontrol-move-oom-task-exclusion-to-tasklist.patch
memcontrol-move-oom-task-exclusion-to-tasklist-fix.patch
oom-add-sysctl-to-enable-task-memory-dump.patch
hotplug-cpu-migrate-a-task-within-its-cpuset.patch
hotplug-cpu-migrate-a-task-within-its-cpuset-fix.patch
hotplug-cpu-migrate-a-task-within-its-cpuset-whitespace-fix.patch
hotplug-cpu-migrate-a-task-within-its-cpuset-doc.patch
slab-api-remove-useless-ctor-parameter-and-reorder-parameters-vs-reiser4.patch
page-owner-tracking-leak-detector.patch
