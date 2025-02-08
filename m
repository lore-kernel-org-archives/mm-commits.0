Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1513213B7A3
	for <mm-commits@vger.kernel.org>; Sat,  8 Feb 2025 02:51:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738983078; cv=none; b=Elpjg2f3w0FidGB55UfFjUz+sgsoRnPilZTSbUzlcd2YlTPkGAvwj1ZUw1HWwEUAJ2Y7q76zVGco+OYWSMXQqOPM8johpm4T9SwNkDDY0cGpybxt0uNY2LUrQ/x1i0Au4pFLJ9sror2bk4InTu3QvFA3nDq2KEIUl9mkE+GuIVw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738983078; c=relaxed/simple;
	bh=ALMjGXpP0s01nfLxAGyhiMeowdMteoANZSR9E5tVec8=;
	h=Date:To:From:Subject:Message-Id; b=rVPZDP537p12mWJCfIOburVjrTUUl2gMd3Gb0LpkIXG75DPjX79LSiS4m11Q46Oe7rnIM/8Ki9BO56KCLteP66qVBWROo8YktA8qXVer5zEGDDe+/Y6pRNpDvUpbTpjedf5lvfzmkthzMnmE99eTlafhPq3fd1TH5tV61jYc7JU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=SdJ0AZCj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="SdJ0AZCj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76219C4CED1;
	Sat,  8 Feb 2025 02:51:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1738983074;
	bh=ALMjGXpP0s01nfLxAGyhiMeowdMteoANZSR9E5tVec8=;
	h=Date:To:From:Subject:From;
	b=SdJ0AZCjh+pzLTK2PgANnK6/qTbhdwW5/w+3IY6Yd3My872f2rPdNr1LGdsr7IMc1
	 QiUVYZBIEdrm7MOybEvC9NnQaFaay/LJ4fHxStTx7MylUmveuGxN3+RalJPQxFYY7Z
	 6QLQRl6ICnw1ti699ZdGE2ijcGH3zspA6LK7+qec=
Date: Fri, 07 Feb 2025 18:51:13 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,liam.howlett@oracle.com,jannh@google.com,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-use-read-write_once-for-vma-vm_flags-on-migrate-mprotect.patch added to mm-unstable branch
Message-Id: <20250208025114.76219C4CED1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: use READ/WRITE_ONCE() for vma->vm_flags on migrate, mprotect
has been added to the -mm mm-unstable branch.  Its filename is
     mm-use-read-write_once-for-vma-vm_flags-on-migrate-mprotect.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-use-read-write_once-for-vma-vm_flags-on-migrate-mprotect.patch

This patch will later appear in the mm-unstable branch at
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
@@ -607,7 +607,7 @@ mprotect_fixup(struct vma_iterator *vmi,
 	       unsigned long start, unsigned long end, unsigned long newflags)
 {
 	struct mm_struct *mm = vma->vm_mm;
-	unsigned long oldflags = vma->vm_flags;
+	unsigned long oldflags = READ_ONCE(vma->vm_flags);
 	long nrpages = (end - start) >> PAGE_SHIFT;
 	unsigned int mm_cp_flags = 0;
 	unsigned long charged = 0;
@@ -627,7 +627,7 @@ mprotect_fixup(struct vma_iterator *vmi,
 	 * uncommon case, so doesn't need to be very optimized.
 	 */
 	if (arch_has_pfn_modify_check() &&
-	    (vma->vm_flags & (VM_PFNMAP|VM_MIXEDMAP)) &&
+	    (oldflags & (VM_PFNMAP|VM_MIXEDMAP)) &&
 	    (newflags & VM_ACCESS_FLAGS) == 0) {
 		pgprot_t new_pgprot = vm_get_page_prot(newflags);
 
@@ -676,7 +676,7 @@ mprotect_fixup(struct vma_iterator *vmi,
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

mm-simplify-vma-merge-structure-and-expand-comments.patch
mm-further-refactor-commit_merge.patch
mm-eliminate-adj_start-parameter-from-commit_merge.patch
mm-make-vmg-target-consistent-and-further-simplify-commit_merge.patch
mm-completely-abstract-unnecessary-adj_start-calculation.patch
mm-refactor-rmap_walk_file-to-separate-out-traversal-logic.patch
mm-provide-mapping_wrprotect_range-function.patch
fb_defio-do-not-use-deprecated-page-mapping-index-fields.patch
mm-use-read-write_once-for-vma-vm_flags-on-migrate-mprotect.patch

