Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E1AB7082F;
	Thu, 12 Feb 2026 15:44:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770911089; cv=none; b=L/u4lSkDBWzE2Gp3+p7QPMtA6Mb7sPtOdwHhsrjr0a2C3oqkrhPgeUGKg9s2ZpOp16KF3aHHgelNpm9l1ETKLx96UIi5bT4R7FQUgtz2oIc99pzv747DfyAf/7u2j+CX0DKB9Bk3sUvBY44EC7BEUZUeG5YGGK4Jey5WaoZvAhI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770911089; c=relaxed/simple;
	bh=3PzrZU2BEdK2n3XcSigmtSJUjiL09RYksQYRAsOC3KU=;
	h=Date:To:From:Subject:Message-Id; b=P+8cuzSmCZImP+9boMkTv9Ni3vozbP8X2GzFpTMTc+w0MXR8sTDcdCl7SIDu5Q7PSDH0G35S8VODcfHmY00s2P1kKJpNvblB3/qkex0boZfwOn5HMOamGtIBLTwc7onppbawyZki4xWbLlSI41Hw/uxAvOybxZshV2NwV0nrmgM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=aG/iFurh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="aG/iFurh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B66BCC4CEF7;
	Thu, 12 Feb 2026 15:44:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1770911087;
	bh=3PzrZU2BEdK2n3XcSigmtSJUjiL09RYksQYRAsOC3KU=;
	h=Date:To:From:Subject:From;
	b=aG/iFurhB5j8/L78UWqVHS5d4Gpcz8MbIOerHBbiwWS4/9tD5+orV8O1G2EKezDV/
	 z6pQe4UiAO6puOujn3UFgGeKmYkutlPFycXGuPuJTe8kxPBhqwOajMSJM3inua75L9
	 AhUcVOq19jskDPG8PSVGtTrMobRoUiWbV/uPB848=
Date: Thu, 12 Feb 2026 07:44:47 -0800
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,rcampbell@nvidia.com,matthew.brost@intel.com,leon@kernel.org,jhubbard@nvidia.com,jgg@ziepe.ca,jgg@mellanox.com,hch@lst.de,apopple@nvidia.com,thomas.hellstrom@linux.intel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] mm-fix-a-hmm_range_fault-livelock-starvation-problem.patch removed from -mm tree
Message-Id: <20260212154447.B66BCC4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: fix a hmm_range_fault() livelock / starvation problem
has been removed from the -mm tree.  Its filename was
     mm-fix-a-hmm_range_fault-livelock-starvation-problem.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Subject: mm: fix a hmm_range_fault() livelock / starvation problem
Date: Tue, 10 Feb 2026 12:56:53 +0100

If hmm_range_fault() fails a folio_trylock() in do_swap_page, trying to
acquire the lock of a device-private folio for migration, to ram, the
function will spin until it succeeds grabbing the lock.

However, if the process holding the lock is depending on a work item to be
completed, which is scheduled on the same CPU as the spinning
hmm_range_fault(), that work item might be starved and we end up in a
livelock / starvation situation which is never resolved.

This can happen, for example if the process holding the
device-private folio lock is stuck in
   migrate_device_unmap()->lru_add_drain_all()
sinc lru_add_drain_all() requires a short work-item
to be run on all online cpus to complete.

A prerequisite for this to happen is:
a) Both zone device and system memory folios are considered in
   migrate_device_unmap(), so that there is a reason to call
   lru_add_drain_all() for a system memory folio while a
   folio lock is held on a zone device folio.
b) The zone device folio has an initial mapcount > 1 which causes
   at least one migration PTE entry insertion to be deferred to
   try_to_migrate(), which can happen after the call to
   lru_add_drain_all().
c) No or voluntary only preemption.

This all seems pretty unlikely to happen, but indeed is hit by the
"xe_exec_system_allocator" igt test.

Resolve this by waiting for the folio to be unlocked if the
folio_trylock() fails in do_swap_page().

Rename migration_entry_wait_on_locked() to softleaf_entry_wait_unlock()
and update its documentation to indicate the new use-case.

Future code improvements might consider moving the lru_add_drain_all()
call in migrate_device_unmap() to be called *after* all pages have
migration entries inserted.  That would eliminate also b) above.

Link: https://lkml.kernel.org/r/20260210115653.92413-1-thomas.hellstrom@linux.intel.com
Fixes: 1afaeb8293c9 ("mm/migrate: Trylock device page in do_swap_page")
Signed-off-by: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Suggested-by: Alistair Popple <apopple@nvidia.com>
Reviewed-by: John Hubbard <jhubbard@nvidia.com>		[v3]
Reviewed-by: Alistair Popple <apopple@nvidia.com>
Cc: Ralph Campbell <rcampbell@nvidia.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Jason Gunthorpe <jgg@mellanox.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Leon Romanovsky <leon@kernel.org>
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: <stable@vger.kernel.org>	[6.15+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/migrate.h |   10 +++++++++-
 mm/filemap.c            |   15 ++++++++++-----
 mm/memory.c             |    3 ++-
 mm/migrate.c            |    8 ++++----
 mm/migrate_device.c     |    2 +-
 5 files changed, 26 insertions(+), 12 deletions(-)

--- a/include/linux/migrate.h~mm-fix-a-hmm_range_fault-livelock-starvation-problem
+++ a/include/linux/migrate.h
@@ -65,7 +65,7 @@ bool isolate_folio_to_list(struct folio
 
 int migrate_huge_page_move_mapping(struct address_space *mapping,
 		struct folio *dst, struct folio *src);
-void migration_entry_wait_on_locked(softleaf_t entry, spinlock_t *ptl)
+void softleaf_entry_wait_on_locked(softleaf_t entry, spinlock_t *ptl)
 		__releases(ptl);
 void folio_migrate_flags(struct folio *newfolio, struct folio *folio);
 int folio_migrate_mapping(struct address_space *mapping,
@@ -97,6 +97,14 @@ static inline int set_movable_ops(const
 	return -ENOSYS;
 }
 
+static inline void softleaf_entry_wait_on_locked(softleaf_t entry, spinlock_t *ptl)
+	__releases(ptl)
+{
+	WARN_ON_ONCE(1);
+
+	spin_unlock(ptl);
+}
+
 #endif /* CONFIG_MIGRATION */
 
 #ifdef CONFIG_NUMA_BALANCING
--- a/mm/filemap.c~mm-fix-a-hmm_range_fault-livelock-starvation-problem
+++ a/mm/filemap.c
@@ -1379,14 +1379,16 @@ repeat:
 
 #ifdef CONFIG_MIGRATION
 /**
- * migration_entry_wait_on_locked - Wait for a migration entry to be removed
- * @entry: migration swap entry.
+ * softleaf_entry_wait_on_locked - Wait for a migration entry or
+ * device_private entry to be removed.
+ * @entry: migration or device_private swap entry.
  * @ptl: already locked ptl. This function will drop the lock.
  *
- * Wait for a migration entry referencing the given page to be removed. This is
+ * Wait for a migration entry referencing the given page, or device_private
+ * entry referencing a dvice_private page to be unlocked. This is
  * equivalent to folio_put_wait_locked(folio, TASK_UNINTERRUPTIBLE) except
  * this can be called without taking a reference on the page. Instead this
- * should be called while holding the ptl for the migration entry referencing
+ * should be called while holding the ptl for @entry referencing
  * the page.
  *
  * Returns after unlocking the ptl.
@@ -1394,7 +1396,7 @@ repeat:
  * This follows the same logic as folio_wait_bit_common() so see the comments
  * there.
  */
-void migration_entry_wait_on_locked(softleaf_t entry, spinlock_t *ptl)
+void softleaf_entry_wait_on_locked(softleaf_t entry, spinlock_t *ptl)
 	__releases(ptl)
 {
 	struct wait_page_queue wait_page;
@@ -1428,6 +1430,9 @@ void migration_entry_wait_on_locked(soft
 	 * If a migration entry exists for the page the migration path must hold
 	 * a valid reference to the page, and it must take the ptl to remove the
 	 * migration entry. So the page is valid until the ptl is dropped.
+	 * Similarly any path attempting to drop the last reference to a
+	 * device-private page needs to grab the ptl to remove the device-private
+	 * entry.
 	 */
 	spin_unlock(ptl);
 
--- a/mm/memory.c~mm-fix-a-hmm_range_fault-livelock-starvation-problem
+++ a/mm/memory.c
@@ -4684,7 +4684,8 @@ vm_fault_t do_swap_page(struct vm_fault
 				unlock_page(vmf->page);
 				put_page(vmf->page);
 			} else {
-				pte_unmap_unlock(vmf->pte, vmf->ptl);
+				pte_unmap(vmf->pte);
+				softleaf_entry_wait_on_locked(entry, vmf->ptl);
 			}
 		} else if (softleaf_is_hwpoison(entry)) {
 			ret = VM_FAULT_HWPOISON;
--- a/mm/migrate.c~mm-fix-a-hmm_range_fault-livelock-starvation-problem
+++ a/mm/migrate.c
@@ -499,7 +499,7 @@ void migration_entry_wait(struct mm_stru
 	if (!softleaf_is_migration(entry))
 		goto out;
 
-	migration_entry_wait_on_locked(entry, ptl);
+	softleaf_entry_wait_on_locked(entry, ptl);
 	return;
 out:
 	spin_unlock(ptl);
@@ -531,10 +531,10 @@ void migration_entry_wait_huge(struct vm
 		 * If migration entry existed, safe to release vma lock
 		 * here because the pgtable page won't be freed without the
 		 * pgtable lock released.  See comment right above pgtable
-		 * lock release in migration_entry_wait_on_locked().
+		 * lock release in softleaf_entry_wait_on_locked().
 		 */
 		hugetlb_vma_unlock_read(vma);
-		migration_entry_wait_on_locked(entry, ptl);
+		softleaf_entry_wait_on_locked(entry, ptl);
 		return;
 	}
 
@@ -552,7 +552,7 @@ void pmd_migration_entry_wait(struct mm_
 	ptl = pmd_lock(mm, pmd);
 	if (!pmd_is_migration_entry(*pmd))
 		goto unlock;
-	migration_entry_wait_on_locked(softleaf_from_pmd(*pmd), ptl);
+	softleaf_entry_wait_on_locked(softleaf_from_pmd(*pmd), ptl);
 	return;
 unlock:
 	spin_unlock(ptl);
--- a/mm/migrate_device.c~mm-fix-a-hmm_range_fault-livelock-starvation-problem
+++ a/mm/migrate_device.c
@@ -176,7 +176,7 @@ static int migrate_vma_collect_huge_pmd(
 		}
 
 		if (softleaf_is_migration(entry)) {
-			migration_entry_wait_on_locked(entry, ptl);
+			softleaf_entry_wait_on_locked(entry, ptl);
 			spin_unlock(ptl);
 			return -EAGAIN;
 		}
_

Patches currently in -mm which might be from thomas.hellstrom@linux.intel.com are


