Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2113D20311
	for <mm-commits@vger.kernel.org>; Sat,  4 Jan 2025 02:26:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735957590; cv=none; b=u8UqhATqHET7Jym8FAhFMGuilOv/d8XDtQQPPYBNMXMWA7Il66q0JbNS6qb8QqSj+g7126vAPaYxp7HNr9syvh2AAJEPFGb6ECjLwbs/a25jU2k7UzaKvrYcNp/ERav7Hd2URvumlKh1KyDRpAyTu3HZQ/HRWRrYWhT/le0p9TM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735957590; c=relaxed/simple;
	bh=YvxQh6OdNw0Ag7VQJZMCUpTpzfHxhuc5dEGrn7eeZIU=;
	h=Date:To:From:Subject:Message-Id; b=nCLiMRBvtZDhJ5qgZqo3nQi2GvsEA1weg/934bOAN8C3YvOLtGJ/ShxD3TADWlS3wOc7hyRETHi2N0wVEPtZvfIapDy0CXxuJw0UWzdQH6ANAHMplbx1dSDrJFRYuWDKmXZ2VDR7W+XMYRa2rtRTuDxTSzofK0RUIv1caqMDR0Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=cITNUWCG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="cITNUWCG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84189C4CED6;
	Sat,  4 Jan 2025 02:26:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1735957589;
	bh=YvxQh6OdNw0Ag7VQJZMCUpTpzfHxhuc5dEGrn7eeZIU=;
	h=Date:To:From:Subject:From;
	b=cITNUWCGPJ2sY0qolEMpluaR8Hz26deqx41rrfjl9VZRt8QPuxzpe1HID8DX0j8s1
	 68tiW2tV5/DRAUnYCtBwOEgO8iEyyczCtwMHvFvT9+iEfwMKcKuLcr9PrKd6j+m/tU
	 Rv7vRkyypP3PZk2mlfOLpDvfZdYxv6qldRjowVno=
Date: Fri, 03 Jan 2025 18:26:29 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,vbabka@suse.cz,Liam.Howlett@Oracle.com,jannh@google.com,david@redhat.com,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-debug-prefer-vm_warn_on_vmg-to-report-vmg-debug-warnings.patch added to mm-unstable branch
Message-Id: <20250104022629.84189C4CED6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/debug: prefer VM_WARN_ON_VMG() to report VMG debug warnings
has been added to the -mm mm-unstable branch.  Its filename is
     mm-debug-prefer-vm_warn_on_vmg-to-report-vmg-debug-warnings.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-debug-prefer-vm_warn_on_vmg-to-report-vmg-debug-warnings.patch

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
Subject: mm/debug: prefer VM_WARN_ON_VMG() to report VMG debug warnings
Date: Fri, 3 Jan 2025 19:35:36 +0000

Now we have VM_WARN_ON_VMG() to provide us with considerably more debug
output when a debug assert fails, utilise it everywhere we can.

This allows us to have considerably more information to go on when things
go wrong, especially when a non-repro issue occurs as reported by
syzkaller or the like.

Link: https://lkml.kernel.org/r/986e45e9549e71284ac7a7fa878688568a94d58b.1735932169.git.lorenzo.stoakes@oracle.com
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Jann Horn <jannh@google.com>
Cc: Liam R. Howlett <Liam.Howlett@Oracle.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vma.c |   33 +++++++++++++++++----------------
 1 file changed, 17 insertions(+), 16 deletions(-)

--- a/mm/vma.c~mm-debug-prefer-vm_warn_on_vmg-to-report-vmg-debug-warnings
+++ a/mm/vma.c
@@ -726,19 +726,20 @@ static __must_check struct vm_area_struc
 	bool expanded;
 
 	mmap_assert_write_locked(vmg->mm);
-	VM_WARN_ON(!vma); /* We are modifying a VMA, so caller must specify. */
-	VM_WARN_ON(vmg->next); /* We set this. */
-	VM_WARN_ON(prev && start <= prev->vm_start);
-	VM_WARN_ON(start >= end);
+	VM_WARN_ON_VMG(!vma, vmg); /* We are modifying a VMA, so caller must specify. */
+	VM_WARN_ON_VMG(vmg->next, vmg); /* We set this. */
+	VM_WARN_ON_VMG(prev && start <= prev->vm_start, vmg);
+	VM_WARN_ON_VMG(start >= end, vmg);
+
 	/*
 	 * If vma == prev, then we are offset into a VMA. Otherwise, if we are
 	 * not, we must span a portion of the VMA.
 	 */
-	VM_WARN_ON(vma && ((vma != prev && vmg->start != vma->vm_start) ||
-			   vmg->end > vma->vm_end));
+	VM_WARN_ON_VMG(vma && ((vma != prev && vmg->start != vma->vm_start) ||
+			       vmg->end > vma->vm_end), vmg);
 	/* The vmi must be positioned within vmg->vma. */
-	VM_WARN_ON(vma && !(vma_iter_addr(vmg->vmi) >= vma->vm_start &&
-			    vma_iter_addr(vmg->vmi) < vma->vm_end));
+	VM_WARN_ON_VMG(vma && !(vma_iter_addr(vmg->vmi) >= vma->vm_start &&
+				vma_iter_addr(vmg->vmi) < vma->vm_end), vmg);
 
 	vmg->state = VMA_MERGE_NOMERGE;
 
@@ -855,9 +856,9 @@ static __must_check struct vm_area_struc
 
 		pgoff_t pglen = PHYS_PFN(vmg->end - vmg->start);
 
-		VM_WARN_ON(!merge_right);
+		VM_WARN_ON_VMG(!merge_right, vmg);
 		/* If we are offset into a VMA, then prev must be vma. */
-		VM_WARN_ON(vmg->start > vma->vm_start && prev && vma != prev);
+		VM_WARN_ON_VMG(vmg->start > vma->vm_start && prev && vma != prev, vmg);
 
 		if (merge_will_delete_vma) {
 			vmg->vma = next;
@@ -969,9 +970,9 @@ struct vm_area_struct *vma_merge_new_ran
 	bool just_expand = vmg->merge_flags & VMG_FLAG_JUST_EXPAND;
 
 	mmap_assert_write_locked(vmg->mm);
-	VM_WARN_ON(vmg->vma);
+	VM_WARN_ON_VMG(vmg->vma, vmg);
 	/* vmi must point at or before the gap. */
-	VM_WARN_ON(vma_iter_addr(vmg->vmi) > end);
+	VM_WARN_ON_VMG(vma_iter_addr(vmg->vmi) > end, vmg);
 
 	vmg->state = VMA_MERGE_NOMERGE;
 
@@ -1053,7 +1054,7 @@ int vma_expand(struct vma_merge_struct *
 
 		remove_next = true;
 		/* This should already have been checked by this point. */
-		VM_WARN_ON(!can_merge_remove_vma(next));
+		VM_WARN_ON_VMG(!can_merge_remove_vma(next), vmg);
 		vma_start_write(next);
 		ret = dup_anon_vma(vma, next, &anon_dup);
 		if (ret)
@@ -1061,10 +1062,10 @@ int vma_expand(struct vma_merge_struct *
 	}
 
 	/* Not merging but overwriting any part of next is not handled. */
-	VM_WARN_ON(next && !remove_next &&
-		  next != vma && vmg->end > next->vm_start);
+	VM_WARN_ON_VMG(next && !remove_next &&
+		       next != vma && vmg->end > next->vm_start, vmg);
 	/* Only handles expanding */
-	VM_WARN_ON(vma->vm_start < vmg->start || vma->vm_end > vmg->end);
+	VM_WARN_ON_VMG(vma->vm_start < vmg->start || vma->vm_end > vmg->end, vmg);
 
 	if (commit_merge(vmg, NULL, remove_next ? next : NULL, NULL, 0, true))
 		goto nomem;
_

Patches currently in -mm which might be from lorenzo.stoakes@oracle.com are

mm-vma-move-brk-internals-to-mm-vmac.patch
mm-vma-move-brk-internals-to-mm-vmac-fix.patch
mm-vma-move-unmapped_area-internals-to-mm-vmac.patch
mm-abstract-get_arg_page-stack-expansion-and-mmap-read-lock.patch
mm-vma-move-stack-expansion-logic-to-mm-vmac.patch
mm-vma-move-__vm_munmap-to-mm-vmac.patch
selftests-mm-add-fork-cow-guard-page-test.patch
mm-enforce-__must_check-on-vma-merge-and-split.patch
mm-perform-all-memfd-seal-checks-in-a-single-place.patch
mm-perform-all-memfd-seal-checks-in-a-single-place-fix.patch
maintainers-update-memory-mapping-section.patch
mm-assert-mmap-write-lock-held-on-do_mmap-mmap_region.patch
mm-add-comments-to-do_mmap-mmap_region-and-vm_mmap.patch
tools-testing-add-simple-__mmap_region-userland-test.patch
mips-vdso-prefer-do_mmap-to-mmap_region.patch
mm-make-mmap_region-internal.patch
mm-debug-introduce-vm_warn_on_vmg-to-dump-vma-merge-state.patch
mm-debug-prefer-vm_warn_on_vmg-to-report-vmg-debug-warnings.patch

