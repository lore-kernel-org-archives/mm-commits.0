Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7C902153E0
	for <mm-commits@vger.kernel.org>; Mon, 17 Mar 2025 05:10:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742188255; cv=none; b=DawenAddkJ6QO6F5gfHO6jzcmB3pLtM21P5PoDOyoKc8qmnM3ayjz6fYHle1VGVpM+6Yl7c2AEtSUnr3b+n+ezueiR3Hj+RGhZdu1PNq3Z/QHleeJMqJcgsQlFQLu6Ryzcg8EwjG66Wac1vRixXU6OOUCucpIfenDt6QoK5o8bA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742188255; c=relaxed/simple;
	bh=theiClfDGYsFkWcsiMrILkJ3yJX96AOLMHAn7McJ+UI=;
	h=Date:To:From:Subject:Message-Id; b=dSqdZrfk1z/034DI6SXAXkt2NP/5USyFGBcwzvJNbm9sPNTXwVdJGlPFjx0+h3H74ibcpgtmn8uyueBHKAZwG3oZtotU/R66pDsKS12SI1CBQAmNIn5xGkuVYIJYEX65VrehKXUjiqS5SAQ8ZEgZYAOEL+MPkenyuuq9/suHzss=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=xWzWWEQL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="xWzWWEQL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E0D6C4CEEC;
	Mon, 17 Mar 2025 05:10:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742188255;
	bh=theiClfDGYsFkWcsiMrILkJ3yJX96AOLMHAn7McJ+UI=;
	h=Date:To:From:Subject:From;
	b=xWzWWEQLnWkSbh9//vvme0LqcRh6AVHgk4t6mI7KvBU9cTiGKRmoiUyTCiFBablNJ
	 92Z9POP8ZscyP0lxRz+3eESCc3hJY9kgdfSvFrP6I69s9f1grt9jAfNNrvU+5VP2B3
	 +DbO9GY+/qyKIohcyZUlkGdYWFXG1GNE650rR47I=
Date: Sun, 16 Mar 2025 22:10:54 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,liam.howlett@oracle.com,jannh@google.com,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-use-read-write_once-for-vma-vm_flags-on-migrate-mprotect.patch removed from -mm tree
Message-Id: <20250317051055.7E0D6C4CEEC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: use READ/WRITE_ONCE() for vma->vm_flags on migrate, mprotect
has been removed from the -mm tree.  Its filename was
     mm-use-read-write_once-for-vma-vm_flags-on-migrate-mprotect.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: mm: use READ/WRITE_ONCE() for vma->vm_flags on migrate, mprotect
Date: Fri, 7 Feb 2025 17:24:42 +0000

According to the syzbot report referenced here, it is possible to
encounter a race between mprotect() writing to the vma->vm_flags field and
migration checking whether the VMA is locked.

There is no real problem with timing here per se, only that torn
reads/writes may occur.  Therefore, as a proximate fix, ensure both
operations READ_ONCE() and WRITE_ONCE() to avoid this.

This race is possible due to the ability to look up VMAs via the rmap,
which migration does in this case, which takes no mmap or VMA lock and
therefore does not preclude an operation to modify a VMA.

When the final update of VMA flags is performed by mprotect, this will
cause the rmap lock to be taken while the VMA is inserted on split/merge.

However the means by which we perform splits/merges in the kernel is that
we perform the split/merge operation on the VMA, acquiring/releasing locks
as needed, and only then, after having done so, modifying fields.

We should carefully examine and determine whether we can combine the two
operations so as to avoid such races, and whether it might be possible to
otherwise annotate these rmap field accesses.

Link: https://lkml.kernel.org/r/20250207172442.78836-1-lorenzo.stoakes@oracle.com
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reported-by: syzbot+c2e5712cbb14c95d4847@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/all/67a34e60.050a0220.50516.0040.GAE@google.com/
Cc: Jann Horn <jannh@google.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c  |    2 +-
 mm/mprotect.c |    6 +++---
 2 files changed, 4 insertions(+), 4 deletions(-)

--- a/mm/migrate.c~mm-use-read-write_once-for-vma-vm_flags-on-migrate-mprotect
+++ a/mm/migrate.c
@@ -328,7 +328,7 @@ static bool remove_migration_pte(struct
 				folio_add_file_rmap_pte(folio, new, vma);
 			set_pte_at(vma->vm_mm, pvmw.address, pvmw.pte, pte);
 		}
-		if (vma->vm_flags & VM_LOCKED)
+		if (READ_ONCE(vma->vm_flags) & VM_LOCKED)
 			mlock_drain_local();
 
 		trace_remove_migration_pte(pvmw.address, pte_val(pte),
--- a/mm/mprotect.c~mm-use-read-write_once-for-vma-vm_flags-on-migrate-mprotect
+++ a/mm/mprotect.c
@@ -599,7 +599,7 @@ mprotect_fixup(struct vma_iterator *vmi,
 	       unsigned long start, unsigned long end, unsigned long newflags)
 {
 	struct mm_struct *mm = vma->vm_mm;
-	unsigned long oldflags = vma->vm_flags;
+	unsigned long oldflags = READ_ONCE(vma->vm_flags);
 	long nrpages = (end - start) >> PAGE_SHIFT;
 	unsigned int mm_cp_flags = 0;
 	unsigned long charged = 0;
@@ -619,7 +619,7 @@ mprotect_fixup(struct vma_iterator *vmi,
 	 * uncommon case, so doesn't need to be very optimized.
 	 */
 	if (arch_has_pfn_modify_check() &&
-	    (vma->vm_flags & (VM_PFNMAP|VM_MIXEDMAP)) &&
+	    (oldflags & (VM_PFNMAP|VM_MIXEDMAP)) &&
 	    (newflags & VM_ACCESS_FLAGS) == 0) {
 		pgprot_t new_pgprot = vm_get_page_prot(newflags);
 
@@ -668,7 +668,7 @@ mprotect_fixup(struct vma_iterator *vmi,
 	 * held in write mode.
 	 */
 	vma_start_write(vma);
-	vm_flags_reset(vma, newflags);
+	vm_flags_reset_once(vma, newflags);
 	if (vma_wants_manual_pte_write_upgrade(vma))
 		mm_cp_flags |= MM_CP_TRY_CHANGE_WRITABLE;
 	vma_set_page_prot(vma);
_

Patches currently in -mm which might be from lorenzo.stoakes@oracle.com are

mm-mremap-correctly-handle-partial-mremap-of-vma-starting-at-0.patch
mm-mremap-refactor-mremap-system-call-implementation.patch
mm-mremap-introduce-and-use-vma_remap_struct-threaded-state.patch
mm-mremap-initial-refactor-of-move_vma.patch
mm-mremap-complete-refactor-of-move_vma.patch
mm-mremap-refactor-move_page_tables-abstracting-state.patch
mm-mremap-thread-state-through-move-page-table-operation.patch

