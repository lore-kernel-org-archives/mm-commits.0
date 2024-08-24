Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83E31257D
	for <mm-commits@vger.kernel.org>; Sat, 24 Aug 2024 06:22:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724480568; cv=none; b=fKxXitD5GQP7up8m7UAHmQUIohuq4Bp1+LIuVAAe5Pf55gx7x6NKFp4zrJqS8cqx3J1sVJhyfHnQymhKvOqBfMzdOyuoGDVBLNH9XIBmI1TUZgJso0teIXqFvNWQVm3DK7O3zzElcG/vQP7tpaDV6LmX1Km0/0wNo3RWUq9c9jU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724480568; c=relaxed/simple;
	bh=SDc0ROA+dtXd+lYDPQY6IIh77KwVxLR9YYZivUkVns4=;
	h=Date:To:From:Subject:Message-Id; b=pHWE5dK91k9uFvcFpRO4EPyfmNl/76qFYdw/Z16On4DNH/Kaa1bFAPIBfjkdHwiQzj/C6Td9gvbfKZr7IxoE3Re/dFyc1Y4dIB5My5K4Ec4Aay2Wu4PXvugtzlhUb3JqgrUki5JL89u4HqRNkEwFRvsVdN1+6t6c0bDLvVNli4k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=CPRG9u93; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="CPRG9u93"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D91BC4AF09;
	Sat, 24 Aug 2024 06:22:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1724480568;
	bh=SDc0ROA+dtXd+lYDPQY6IIh77KwVxLR9YYZivUkVns4=;
	h=Date:To:From:Subject:From;
	b=CPRG9u93Pl4K/p4AzHcyPYpTRwlGeOa1zzBLcvRcfFqKI5cdWsDNJVImrLGr9bPev
	 F1ccn03tY5h4PdAoszSUFmBMTsyi4RhV/DtdTLOJJh4Rsk+txiEPh/r0+kBr1Srjls
	 2RM0XPY3mjGH047Vk6bBfaGFq3w6VAp7RVyF3jEg=
Date: Fri, 23 Aug 2024 23:22:47 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,vbabka@suse.cz,surenb@google.com,spasswolf@web.de,sidhartha.kumar@oracle.com,paul@paul-moore.com,paulmck@kernel.org,olsajiri@gmail.com,lstoakes@gmail.com,Liam.Howlett@oracle.com,kees@kernel.org,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-remove-duplicated-open-coded-vma-policy-check.patch added to mm-unstable branch
Message-Id: <20240824062248.3D91BC4AF09@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: remove duplicated open-coded VMA policy check
has been added to the -mm mm-unstable branch.  Its filename is
     mm-remove-duplicated-open-coded-vma-policy-check.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-remove-duplicated-open-coded-vma-policy-check.patch

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
Subject: mm: remove duplicated open-coded VMA policy check
Date: Fri, 23 Aug 2024 21:06:59 +0100

Both can_vma_merge_before() and can_vma_merge_after() are invoked after
checking for compatible VMA NUMA policy, we can simply move this to
is_mergeable_vma() and abstract this altogether.

In mmap_region() we set vmg->policy to NULL, so the policy comparisons
checked in can_vma_merge_before() and can_vma_merge_after() are exactly
equivalent to !vma_policy(vmg.next) and !vma_policy(vmg.prev).

Equally, in do_brk_flags(), vmg->policy is NULL, so the
can_vma_merge_after() is checking !vma_policy(vma), as we set vmg.prev to
vma.

In vma_merge(), we compare prev and next policies with vmg->policy before
checking can_vma_merge_after() and can_vma_merge_before() respectively,
which this patch causes to be checked in precisely the same way.

This therefore maintains precisely the same logic as before, only now
abstracted into is_mergeable_vma().

Link: https://lkml.kernel.org/r/c0b2c70cf5c7a036c560d9ddba7b2904b84ab9ab.1724441678.git.lorenzo.stoakes@oracle.com
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Bert Karwatzki <spasswolf@web.de>
Cc: Jiri Olsa <olsajiri@gmail.com>
Cc: Kees Cook <kees@kernel.org>
Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Lorenzo Stoakes <lstoakes@gmail.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: "Paul E. McKenney" <paulmck@kernel.org>
Cc: Paul Moore <paul@paul-moore.com>
Cc: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |    8 +++-----
 mm/vma.c  |    9 ++++-----
 2 files changed, 7 insertions(+), 10 deletions(-)

--- a/mm/mmap.c~mm-remove-duplicated-open-coded-vma-policy-check
+++ a/mm/mmap.c
@@ -1423,8 +1423,7 @@ unsigned long mmap_region(struct file *f
 
 	/* Attempt to expand an old mapping */
 	/* Check next */
-	if (next && next->vm_start == end && !vma_policy(next) &&
-	    can_vma_merge_before(&vmg)) {
+	if (next && next->vm_start == end && can_vma_merge_before(&vmg)) {
 		merge_end = next->vm_end;
 		vma = next;
 		vmg.pgoff = next->vm_pgoff - pglen;
@@ -1438,8 +1437,7 @@ unsigned long mmap_region(struct file *f
 	}
 
 	/* Check prev */
-	if (prev && prev->vm_end == addr && !vma_policy(prev) &&
-	    can_vma_merge_after(&vmg)) {
+	if (prev && prev->vm_end == addr && can_vma_merge_after(&vmg)) {
 		merge_start = prev->vm_start;
 		vma = prev;
 		vmg.pgoff = prev->vm_pgoff;
@@ -1778,7 +1776,7 @@ static int do_brk_flags(struct vma_itera
 	 * Expand the existing vma if possible; Note that singular lists do not
 	 * occur after forking, so the expand will only happen on new VMAs.
 	 */
-	if (vma && vma->vm_end == addr && !vma_policy(vma)) {
+	if (vma && vma->vm_end == addr) {
 		VMG_STATE(vmg, mm, vmi, addr, addr + len, flags, PHYS_PFN(addr));
 
 		vmg.prev = vma;
--- a/mm/vma.c~mm-remove-duplicated-open-coded-vma-policy-check
+++ a/mm/vma.c
@@ -19,6 +19,8 @@ static inline bool is_mergeable_vma(stru
 	 */
 	bool may_remove_vma = merge_next;
 
+	if (!mpol_equal(vmg->policy, vma_policy(vma)))
+		return false;
 	/*
 	 * VM_SOFTDIRTY should not prevent from VMA merging, if we
 	 * match the flags but dirty bit -- the caller should mark
@@ -1058,17 +1060,14 @@ static struct vm_area_struct *vma_merge(
 		vma_pgoff = prev->vm_pgoff;
 
 		/* Can we merge the predecessor? */
-		if (addr == prev->vm_end && mpol_equal(vma_policy(prev), vmg->policy)
-		    && can_vma_merge_after(vmg)) {
-
+		if (addr == prev->vm_end && can_vma_merge_after(vmg)) {
 			merge_prev = true;
 			vma_prev(vmg->vmi);
 		}
 	}
 
 	/* Can we merge the successor? */
-	if (next && mpol_equal(vmg->policy, vma_policy(next)) &&
-	    can_vma_merge_before(vmg)) {
+	if (next && can_vma_merge_before(vmg)) {
 		merge_next = true;
 	}
 
_

Patches currently in -mm which might be from lorenzo.stoakes@oracle.com are

userfaultfd-move-core-vma-manipulation-logic-to-mm-userfaultfdc.patch
userfaultfd-move-core-vma-manipulation-logic-to-mm-userfaultfdc-fix.patch
mm-move-vma_modify-and-helpers-to-internal-header.patch
mm-move-vma_shrink-vma_expand-to-internal-header.patch
mm-move-internal-core-vma-manipulation-functions-to-own-file.patch
maintainers-add-entry-for-new-vma-files.patch
tools-separate-out-shared-radix-tree-components.patch
tools-add-skeleton-code-for-userland-testing-of-vma-logic.patch
tools-improve-vma-test-makefile.patch
tools-add-vma-merge-tests.patch
mm-introduce-vma_merge_struct-and-abstract-vma_mergevma_modify.patch
mm-remove-duplicated-open-coded-vma-policy-check.patch
mm-abstract-vma_expand-to-use-vma_merge_struct.patch
mm-avoid-using-vma_merge-for-new-vmas.patch
mm-make-vma_prepare-and-friends-static-and-internal-to-vmac.patch
mm-introduce-commit_merge-abstracting-final-commit-of-merge.patch
mm-refactor-vma_merge-into-modify-only-vma_merge_existing_range.patch
mm-rework-vm_ops-close-handling-on-vma-merge.patch

