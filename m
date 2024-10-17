Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9913C1925B2;
	Thu, 17 Oct 2024 07:28:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729150122; cv=none; b=e4XUSoiztCtfnpbl9xYZ2lv+14DAsmCyHifRm83DbP8RzYmI2NgkE/kn1rGuSaQw8kKZMB3Vmy08GPItQJoLA6oW8ftVzAdnx8ta3lSlTYR3v5VW5z7S80azN2/jXTLhpegMU1jdltM0dv2qxMHtKtl1FJcF3myBUBwFQxQeQXs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729150122; c=relaxed/simple;
	bh=VMZ9CJI8yOSlS52jHP7c+X1DYIm9JXvLStwJIC02zs0=;
	h=Date:To:From:Subject:Message-Id; b=rW1MaVrsQsw/ZvlqlRGDvOoJ2p9TXbnuOlyrOGmpI48tyOW1tE6hYVsrwKI6a7ySy2qfPIbiaQdd9PJSynUlwSOScRIFSbK+h7rx4/vMeCT1/BKzvVdReNkevagQUKs3w9tRWUnLyTbZ6LsMng4DF9FVMfVhScTU0TlNdtLQM/0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=V9bh81Dc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="V9bh81Dc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09E9CC4CEC3;
	Thu, 17 Oct 2024 07:28:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1729150122;
	bh=VMZ9CJI8yOSlS52jHP7c+X1DYIm9JXvLStwJIC02zs0=;
	h=Date:To:From:Subject:From;
	b=V9bh81DcT1GOv14W8xIhrJulYZ5lwitQiT0JgXwqjDJtBdZkRUq+uHZ50lk+klKP1
	 Du/n0IWVK80qd/nxVzcOwk/ATcqVuKG3IEfXu9CN3iKNbQyu0gjjFnx9jLF6zOKbMJ
	 lkyb/8fVZX/P4zCcLfk5LGQ2CEg8uzdwSxBqNgyc=
Date: Thu, 17 Oct 2024 00:28:41 -0700
To: mm-commits@vger.kernel.org,zhengqi.arch@bytedance.com,willy@infradead.org,stable@vger.kernel.org,lorenzo.stoakes@oracle.com,joel@joelfernandes.org,hughd@google.com,david@redhat.com,jannh@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-mremap-fix-move_normal_pmd-retract_page_tables-race.patch removed from -mm tree
Message-Id: <20241017072842.09E9CC4CEC3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/mremap: fix move_normal_pmd/retract_page_tables race
has been removed from the -mm tree.  Its filename was
     mm-mremap-fix-move_normal_pmd-retract_page_tables-race.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Jann Horn <jannh@google.com>
Subject: mm/mremap: fix move_normal_pmd/retract_page_tables race
Date: Mon, 07 Oct 2024 23:42:04 +0200

In mremap(), move_page_tables() looks at the type of the PMD entry and the
specified address range to figure out by which method the next chunk of
page table entries should be moved.

At that point, the mmap_lock is held in write mode, but no rmap locks are
held yet.  For PMD entries that point to page tables and are fully covered
by the source address range, move_pgt_entry(NORMAL_PMD, ...) is called,
which first takes rmap locks, then does move_normal_pmd(). 
move_normal_pmd() takes the necessary page table locks at source and
destination, then moves an entire page table from the source to the
destination.

The problem is: The rmap locks, which protect against concurrent page
table removal by retract_page_tables() in the THP code, are only taken
after the PMD entry has been read and it has been decided how to move it. 
So we can race as follows (with two processes that have mappings of the
same tmpfs file that is stored on a tmpfs mount with huge=advise); note
that process A accesses page tables through the MM while process B does it
through the file rmap:

process A                      process B
=========                      =========
mremap
  mremap_to
    move_vma
      move_page_tables
        get_old_pmd
        alloc_new_pmd
                      *** PREEMPT ***
                               madvise(MADV_COLLAPSE)
                                 do_madvise
                                   madvise_walk_vmas
                                     madvise_vma_behavior
                                       madvise_collapse
                                         hpage_collapse_scan_file
                                           collapse_file
                                             retract_page_tables
                                               i_mmap_lock_read(mapping)
                                               pmdp_collapse_flush
                                               i_mmap_unlock_read(mapping)
        move_pgt_entry(NORMAL_PMD, ...)
          take_rmap_locks
          move_normal_pmd
          drop_rmap_locks

When this happens, move_normal_pmd() can end up creating bogus PMD entries
in the line `pmd_populate(mm, new_pmd, pmd_pgtable(pmd))`.  The effect
depends on arch-specific and machine-specific details; on x86, you can end
up with physical page 0 mapped as a page table, which is likely
exploitable for user->kernel privilege escalation.

Fix the race by letting process B recheck that the PMD still points to a
page table after the rmap locks have been taken.  Otherwise, we bail and
let the caller fall back to the PTE-level copying path, which will then
bail immediately at the pmd_none() check.

Bug reachability: Reaching this bug requires that you can create
shmem/file THP mappings - anonymous THP uses different code that doesn't
zap stuff under rmap locks.  File THP is gated on an experimental config
flag (CONFIG_READ_ONLY_THP_FOR_FS), so on normal distro kernels you need
shmem THP to hit this bug.  As far as I know, getting shmem THP normally
requires that you can mount your own tmpfs with the right mount flags,
which would require creating your own user+mount namespace; though I don't
know if some distros maybe enable shmem THP by default or something like
that.

Bug impact: This issue can likely be used for user->kernel privilege
escalation when it is reachable.

Link: https://lkml.kernel.org/r/20241007-move_normal_pmd-vs-collapse-fix-2-v1-1-5ead9631f2ea@google.com
Fixes: 1d65b771bc08 ("mm/khugepaged: retract_page_tables() without mmap or vma lock")
Signed-off-by: Jann Horn <jannh@google.com>
Signed-off-by: David Hildenbrand <david@redhat.com>
Co-developed-by: David Hildenbrand <david@redhat.com>
Closes: https://project-zero.issues.chromium.org/371047675
Acked-by: Qi Zheng <zhengqi.arch@bytedance.com>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Joel Fernandes <joel@joelfernandes.org>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mremap.c |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

--- a/mm/mremap.c~mm-mremap-fix-move_normal_pmd-retract_page_tables-race
+++ a/mm/mremap.c
@@ -238,6 +238,7 @@ static bool move_normal_pmd(struct vm_ar
 {
 	spinlock_t *old_ptl, *new_ptl;
 	struct mm_struct *mm = vma->vm_mm;
+	bool res = false;
 	pmd_t pmd;
 
 	if (!arch_supports_page_table_move())
@@ -277,19 +278,25 @@ static bool move_normal_pmd(struct vm_ar
 	if (new_ptl != old_ptl)
 		spin_lock_nested(new_ptl, SINGLE_DEPTH_NESTING);
 
-	/* Clear the pmd */
 	pmd = *old_pmd;
+
+	/* Racing with collapse? */
+	if (unlikely(!pmd_present(pmd) || pmd_leaf(pmd)))
+		goto out_unlock;
+	/* Clear the pmd */
 	pmd_clear(old_pmd);
+	res = true;
 
 	VM_BUG_ON(!pmd_none(*new_pmd));
 
 	pmd_populate(mm, new_pmd, pmd_pgtable(pmd));
 	flush_tlb_range(vma, old_addr, old_addr + PMD_SIZE);
+out_unlock:
 	if (new_ptl != old_ptl)
 		spin_unlock(new_ptl);
 	spin_unlock(old_ptl);
 
-	return true;
+	return res;
 }
 #else
 static inline bool move_normal_pmd(struct vm_area_struct *vma,
_

Patches currently in -mm which might be from jannh@google.com are

mm-mark-mas-allocation-in-vms_abort_munmap_vmas-as-__gfp_nofail.patch

