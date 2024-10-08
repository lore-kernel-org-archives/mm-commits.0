Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B5A5C147;
	Tue,  8 Oct 2024 00:58:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728349092; cv=none; b=ucS4DLMI1VX5QMUO/UdZKjYUUi5ZQJQ10Hs31VHqZp3fA9tFb4xd2c1zANYqS/r+HKmc+7/U5CGH1cr62IEvsNagEM1E0dX1/7J6Mhotn5cBUa+YhMHegmhFQPhHXIOplYdr3nsO/XuXHfdV6Q6eNnpAcbjAa6EB8gVEzNzmvhs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728349092; c=relaxed/simple;
	bh=rx9BM2UYOVo0Bc1y2nKz/FkHUdDTyt0emuvJ2NNUWw0=;
	h=Date:To:From:Subject:Message-Id; b=uXio7xSukxfoyjgwcytUQjiE3E7W0HuHLtZ5VMXLOE3ormTz9YdZppGpBNBrn6P+mYcvR++ll0vLiloUFFJyiJB5U3LqtdCTeJDqYdK9DgXD4vznKZAEc7GYoINfxqEHglFUni5Fl4AFU3VeThAlIeFIozRxdL7tdqrntDOqoDI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=R6Pw60rF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="R6Pw60rF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5762C4CEC6;
	Tue,  8 Oct 2024 00:58:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1728349091;
	bh=rx9BM2UYOVo0Bc1y2nKz/FkHUdDTyt0emuvJ2NNUWw0=;
	h=Date:To:From:Subject:From;
	b=R6Pw60rF8cSNr4nW+u0C9yIFP7EWN/nTR7YRPuP3H30MUaLl06gKOfXOLKElssuL6
	 VcmACU76O0CaoNw0hF/JYkFRWlPjbAqqb6HKQXLFHMbREH9LiwBXu9u/bwRrJzS/ho
	 s2sqIr0sDUQSiSlWT17tyXKrB8OwVvPIQ8bGgny4=
Date: Mon, 07 Oct 2024 17:58:11 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,stable@vger.kernel.org,lorenzo.stoakes@oracle.com,joel@joelfernandes.org,hughd@google.com,david@redhat.com,jannh@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mremap-fix-move_normal_pmd-retract_page_tables-race.patch added to mm-hotfixes-unstable branch
Message-Id: <20241008005811.C5762C4CEC6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/mremap: fix move_normal_pmd/retract_page_tables race
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-mremap-fix-move_normal_pmd-retract_page_tables-race.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mremap-fix-move_normal_pmd-retract_page_tables-race.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

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
Closes: https://project-zero.issues.chromium.org/371047675
Co-developed-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Jann Horn <jannh@google.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Joel Fernandes <joel@joelfernandes.org>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
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

mm-enforce-a-minimal-stack-gap-even-against-inaccessible-vmas.patch
mm-mremap-fix-move_normal_pmd-retract_page_tables-race.patch

