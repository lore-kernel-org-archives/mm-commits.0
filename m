Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B14422580F2;
	Tue, 10 Feb 2026 01:36:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770687376; cv=none; b=ZadICgzkn9MEeqfWacOrph38GGD42ZLqsxaCoD2SrmCUQ33d5BMh430fiktCITMsKTnVWIrGN4TqkU60FlmTBFpY0XYCberJz6w8TGtq1vgvZH2fN4rJ08vVBTmFaVwDZgJiU+658nwyCc4yBldLuJTgu8zDMCBSy1YNakgFTeg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770687376; c=relaxed/simple;
	bh=HP0w4T2ynjDn3Nhm+Da/XwHGKl4T2rN0CmZvW9gTDfY=;
	h=Date:To:From:Subject:Message-Id; b=dD3jDC62m8rCzOAcNOXITaRV8IaYOgbuPJ+jrkR9J8bNQbh/wwIZwdRZUUu2phhhmg00LK8pgqlV7T3B3Oo2AG4M0uWmFPaiyeeVrzEuxULcjJwQk+sNhHeFaZSQfwhWvVBd9gH3jHvuhJhq50Ubl31yXU8qlNU/XqWD/WF4nTc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=TNPtFMUU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="TNPtFMUU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3ED35C116C6;
	Tue, 10 Feb 2026 01:36:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1770687376;
	bh=HP0w4T2ynjDn3Nhm+Da/XwHGKl4T2rN0CmZvW9gTDfY=;
	h=Date:To:From:Subject:From;
	b=TNPtFMUUCzPpG1Mcbj3pj4D6ieBsnSGCaV5QKGx7qwFBwKPs607wLM9SlhDvRhlKZ
	 uN2J4WZT+tO4XW2HRPhH+a9lpb2961Eon99leon3V8fEarGAiCBCDBvjRjbfScvYEg
	 n3eAm3MH09LIxqGm9s19HDtEYEjz0M6ssdRFKqY8=
Date: Mon, 09 Feb 2026 17:36:15 -0800
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,rcampbell@nvidia.com,matthew.brost@intel.com,leon@kernel.org,jhubbard@nvidia.com,jgg@ziepe.ca,jgg@mellanox.com,hch@lst.de,dri-devel@lists.freedesktop.org,apopple@nvidia.com,thomas.hellstrom@linux.intel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-fix-a-hmm_range_fault-livelock-starvation-problem.patch added to mm-hotfixes-unstable branch
Message-Id: <20260210013616.3ED35C116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: fix a hmm_range_fault() livelock / starvation problem
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-fix-a-hmm_range_fault-livelock-starvation-problem.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-fix-a-hmm_range_fault-livelock-starvation-problem.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Subject: mm: fix a hmm_range_fault() livelock / starvation problem
Date: Thu, 5 Feb 2026 12:10:28 +0100

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
The lru_add_drain_all() function requires a short work-item
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
folio_trylock() fails in the do_swap_page() function.

Rename the migration_entry_wait_on_locked() function to
softleaf_entry_wait_unlock() and update its documentation to indicate the
new use-case.

Future code improvements might consider moving the lru_add_drain_all()
call in migrate_device_unmap() to be called *after* all pages have
migration entries inserted.  That would eliminate also b) above.

Link: https://lkml.kernel.org/r/20260205111028.200506-1-thomas.hellstrom@linux.intel.com
Fixes: 1afaeb8293c9 ("mm/migrate: Trylock device page in do_swap_page")
Signed-off-by: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Suggested-by: Alistair Popple <apopple@nvidia.com>
Reviewed-by: John Hubbard <jhubbard@nvidia.com> #v3
Cc: Ralph Campbell <rcampbell@nvidia.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Jason Gunthorpe <jgg@mellanox.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Leon Romanovsky <leon@kernel.org>
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: <dri-devel@lists.freedesktop.org>
Cc: <stable@vger.kernel.org>	[6.15+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/migrate.h |    8 +++++++-
 mm/filemap.c            |   15 ++++++++++-----
 mm/memory.c             |    3 ++-
 mm/migrate.c            |    8 ++++----
 mm/migrate_device.c     |    2 +-
 5 files changed, 24 insertions(+), 12 deletions(-)

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
@@ -97,6 +97,12 @@ static inline int set_movable_ops(const
 	return -ENOSYS;
 }
 
+static inline void softleaf_entry_wait_on_locked(softleaf_t entry, spinlock_t *ptl)
+	__releases(ptl)
+{
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

mm-fix-a-hmm_range_fault-livelock-starvation-problem.patch

