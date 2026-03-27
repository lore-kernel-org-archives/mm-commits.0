Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EDA05478D
	for <mm-commits@vger.kernel.org>; Fri, 27 Mar 2026 23:04:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774652697; cv=none; b=mla4JjsBEtjpFBrHM4k/6Dqk0Yt0E5vvQZ88z55dCOiO7PUZqwq1RSP3w2mG1jCY5hu9LwRMuML0dg8h8hrgnUsETIdoaiGPu+eGTuhmCZNPlfajglG40jvoX/DMWg1x0fHVgmbVTNcVtmRfD4nnt6rj7JSd0U23QuWIZ/VogYM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774652697; c=relaxed/simple;
	bh=EVeLCeFYjq7aBUzoPgWCPu//1N4kzWzTSYVqzUn8sFU=;
	h=Date:To:From:Subject:Message-Id; b=Nsg1vTT92sHW1cp/2aTik6zRkefGo8B0Zh2CXV9lB8b1LzKTJ6IFpnCejus0UGTpBzvaJGMvPhlDoVnA8eQOZC+TnijHIrTiagxx3gTql1VhvaUuuipSIwXoOJtDMscOTQj1Nm6f3Zj05GWnVw2hiTY1HHuXt/p7+b2tJKqiQHw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=SNMco5+H; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="SNMco5+H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0611BC19423;
	Fri, 27 Mar 2026 23:04:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774652697;
	bh=EVeLCeFYjq7aBUzoPgWCPu//1N4kzWzTSYVqzUn8sFU=;
	h=Date:To:From:Subject:From;
	b=SNMco5+HX6ncnej9FgG81G+dTR6C+zf3qMRduZuCdsP/BAp0elcM+ePhy+oRFRRUp
	 ZI1gaulmjhQ16MQ1UvzsXVqmeV8lUMSK6BG8ralbtByek0SDntROm6wmADJ86NFRp8
	 F1Ay1KUmf3MWbYh14bJKyNcjlxDeLukqIHPjRx3I=
Date: Fri, 27 Mar 2026 16:04:56 -0700
To: mm-commits@vger.kernel.org,surenb@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-use-vma_start_write_killable-in-mm-syscalls.patch removed from -mm tree
Message-Id: <20260327230457.0611BC19423@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: use vma_start_write_killable() in mm syscalls
has been removed from the -mm tree.  Its filename was
     mm-use-vma_start_write_killable-in-mm-syscalls.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Suren Baghdasaryan <surenb@google.com>
Subject: mm: use vma_start_write_killable() in mm syscalls
Date: Thu, 26 Mar 2026 01:08:32 -0700

Replace vma_start_write() with vma_start_write_killable() in syscalls,
improving reaction time to the kill signal.

In a number of places we now lock VMA earlier than before to avoid doing
work and undoing it later if a fatal signal is pending.  This is safe
because the moves are happening within sections where we already hold the
mmap_write_lock, so the moves do not change the locking order relative to
other kernel locks.

Link: https://lkml.kernel.org/r/20260326080836.695207-3-surenb@google.com
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Suggested-by: Matthew Wilcox <willy@infradead.org>
Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Byungchul Park <byungchul@sk.com>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>
Cc: Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Cc: Gregory Price <gourry@gourry.net>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: "Huang, Ying" <ying.huang@linux.alibaba.com>
Cc: Jann Horn <jannh@google.com>
Cc: Janosch Frank <frankja@linux.ibm.com>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Kees Cook <kees@kernel.org>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Nico Pache <npache@redhat.com>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: Rakie Kim <rakie.kim@sk.com>
Cc: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Sven Schnelle <svens@linux.ibm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/madvise.c   |    4 +++-
 mm/memory.c    |    2 ++
 mm/mempolicy.c |   11 +++++++++--
 mm/mlock.c     |   28 ++++++++++++++++++++++------
 mm/mprotect.c  |    5 ++++-
 mm/mremap.c    |    8 +++++---
 mm/mseal.c     |    5 ++++-
 7 files changed, 49 insertions(+), 14 deletions(-)

--- a/mm/madvise.c~mm-use-vma_start_write_killable-in-mm-syscalls
+++ a/mm/madvise.c
@@ -175,7 +175,9 @@ static int madvise_update_vma(vm_flags_t
 	madv_behavior->vma = vma;
 
 	/* vm_flags is protected by the mmap_lock held in write mode. */
-	vma_start_write(vma);
+	if (vma_start_write_killable(vma))
+		return -EINTR;
+
 	vma->flags = new_vma_flags;
 	if (set_new_anon_name)
 		return replace_anon_vma_name(vma, anon_name);
--- a/mm/memory.c~mm-use-vma_start_write_killable-in-mm-syscalls
+++ a/mm/memory.c
@@ -366,6 +366,8 @@ void free_pgd_range(struct mmu_gather *t
  * page tables that should be removed.  This can differ from the vma mappings on
  * some archs that may have mappings that need to be removed outside the vmas.
  * Note that the prev->vm_end and next->vm_start are often used.
+ * We don't use vma_start_write_killable() because page tables should be freed
+ * even if the task is being killed.
  *
  * The vma_end differs from the pg_end when a dup_mmap() failed and the tree has
  * unrelated data to the mm_struct being torn down.
--- a/mm/mempolicy.c~mm-use-vma_start_write_killable-in-mm-syscalls
+++ a/mm/mempolicy.c
@@ -1784,7 +1784,8 @@ SYSCALL_DEFINE4(set_mempolicy_home_node,
 		return -EINVAL;
 	if (end == start)
 		return 0;
-	mmap_write_lock(mm);
+	if (mmap_write_lock_killable(mm))
+		return -EINTR;
 	prev = vma_prev(&vmi);
 	for_each_vma_range(vmi, vma, end) {
 		/*
@@ -1801,13 +1802,19 @@ SYSCALL_DEFINE4(set_mempolicy_home_node,
 			err = -EOPNOTSUPP;
 			break;
 		}
+		/*
+		 * Lock the VMA early to avoid extra work if fatal signal
+		 * is pending.
+		 */
+		err = vma_start_write_killable(vma);
+		if (err)
+			break;
 		new = mpol_dup(old);
 		if (IS_ERR(new)) {
 			err = PTR_ERR(new);
 			break;
 		}
 
-		vma_start_write(vma);
 		new->home_node = home_node;
 		err = mbind_range(&vmi, vma, &prev, start, end, new);
 		mpol_put(new);
--- a/mm/mlock.c~mm-use-vma_start_write_killable-in-mm-syscalls
+++ a/mm/mlock.c
@@ -419,8 +419,10 @@ out:
  *
  * Called for mlock(), mlock2() and mlockall(), to set @vma VM_LOCKED;
  * called for munlock() and munlockall(), to clear VM_LOCKED from @vma.
+ *
+ * Return: 0 on success, -EINTR if fatal signal is pending.
  */
-static void mlock_vma_pages_range(struct vm_area_struct *vma,
+static int mlock_vma_pages_range(struct vm_area_struct *vma,
 	unsigned long start, unsigned long end,
 	vma_flags_t *new_vma_flags)
 {
@@ -442,7 +444,9 @@ static void mlock_vma_pages_range(struct
 	 */
 	if (vma_flags_test(new_vma_flags, VMA_LOCKED_BIT))
 		vma_flags_set(new_vma_flags, VMA_IO_BIT);
-	vma_start_write(vma);
+	if (vma_start_write_killable(vma))
+		return -EINTR;
+
 	vma_flags_reset_once(vma, new_vma_flags);
 
 	lru_add_drain();
@@ -453,6 +457,7 @@ static void mlock_vma_pages_range(struct
 		vma_flags_clear(new_vma_flags, VMA_IO_BIT);
 		vma_flags_reset_once(vma, new_vma_flags);
 	}
+	return 0;
 }
 
 /*
@@ -506,11 +511,13 @@ static int mlock_fixup(struct vma_iterat
 	 */
 	if (vma_flags_test(&new_vma_flags, VMA_LOCKED_BIT) &&
 	    vma_flags_test(&old_vma_flags, VMA_LOCKED_BIT)) {
+		ret = vma_start_write_killable(vma);
+		if (ret)
+			goto out; /* mm->locked_vm is fine as nr_pages == 0 */
 		/* No work to do, and mlocking twice would be wrong */
-		vma_start_write(vma);
 		vma->flags = new_vma_flags;
 	} else {
-		mlock_vma_pages_range(vma, start, end, &new_vma_flags);
+		ret = mlock_vma_pages_range(vma, start, end, &new_vma_flags);
 	}
 out:
 	*prev = vma;
@@ -739,9 +746,18 @@ static int apply_mlockall_flags(int flag
 
 		error = mlock_fixup(&vmi, vma, &prev, vma->vm_start, vma->vm_end,
 				    newflags);
-		/* Ignore errors, but prev needs fixing up. */
-		if (error)
+		if (error) {
+			/*
+			 * If we failed due to a pending fatal signal, return
+			 * now. If we locked the vma before signal arrived, it
+			 * will be unlocked when we drop mmap_write_lock.
+			 */
+			if (fatal_signal_pending(current))
+				return -EINTR;
+
+			/* Ignore errors, but prev needs fixing up. */
 			prev = vma;
+		}
 		cond_resched();
 	}
 out:
--- a/mm/mprotect.c~mm-use-vma_start_write_killable-in-mm-syscalls
+++ a/mm/mprotect.c
@@ -784,7 +784,10 @@ mprotect_fixup(struct vma_iterator *vmi,
 	 * vm_flags and vm_page_prot are protected by the mmap_lock
 	 * held in write mode.
 	 */
-	vma_start_write(vma);
+	error = vma_start_write_killable(vma);
+	if (error)
+		goto fail;
+
 	vma_flags_reset_once(vma, &new_vma_flags);
 	if (vma_wants_manual_pte_write_upgrade(vma))
 		mm_cp_flags |= MM_CP_TRY_CHANGE_WRITABLE;
--- a/mm/mremap.c~mm-use-vma_start_write_killable-in-mm-syscalls
+++ a/mm/mremap.c
@@ -1348,6 +1348,11 @@ static unsigned long move_vma(struct vma
 	if (err)
 		return err;
 
+	/* We don't want racing faults. */
+	err = vma_start_write_killable(vrm->vma);
+	if (err)
+		return err;
+
 	/*
 	 * If accounted, determine the number of bytes the operation will
 	 * charge.
@@ -1355,9 +1360,6 @@ static unsigned long move_vma(struct vma
 	if (!vrm_calc_charge(vrm))
 		return -ENOMEM;
 
-	/* We don't want racing faults. */
-	vma_start_write(vrm->vma);
-
 	/* Perform copy step. */
 	err = copy_vma_and_data(vrm, &new_vma);
 	/*
--- a/mm/mseal.c~mm-use-vma_start_write_killable-in-mm-syscalls
+++ a/mm/mseal.c
@@ -70,6 +70,7 @@ static int mseal_apply(struct mm_struct
 
 		if (!vma_test(vma, VMA_SEALED_BIT)) {
 			vma_flags_t vma_flags = vma->flags;
+			int err;
 
 			vma_flags_set(&vma_flags, VMA_SEALED_BIT);
 
@@ -77,7 +78,9 @@ static int mseal_apply(struct mm_struct
 					       curr_end, &vma_flags);
 			if (IS_ERR(vma))
 				return PTR_ERR(vma);
-			vma_start_write(vma);
+			err = vma_start_write_killable(vma);
+			if (err)
+				return err;
 			vma_set_flags(vma, VMA_SEALED_BIT);
 		}
 
_

Patches currently in -mm which might be from surenb@google.com are

a.patch
mm-khugepaged-use-vma_start_write_killable-in-collapse_huge_page.patch
mm-vma-use-vma_start_write_killable-in-vma-operations.patch
mm-use-vma_start_write_killable-in-process_vma_walk_lock.patch
kvm-ppc-use-vma_start_write_killable-in-kvmppc_memslot_page_merge.patch
mm-vmscan-prevent-mglru-reclaim-from-pinning-address-space.patch

