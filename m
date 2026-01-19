Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2F1621FF47
	for <mm-commits@vger.kernel.org>; Mon, 19 Jan 2026 20:31:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768854665; cv=none; b=BdkxkMKKO6RPvWM2Gdd3wteekm+z72EzLXdQxamAS9l6zmrIsWWoWCTHlp9CkOodCyYZpiteiTzeH4mf6YEZmNP9/KjBchPxRPi2BN0gqA+eSIC8H30ifiBo9jpNhmxYhugH6qCaRAMiw2CjziFFyZrnT+sGFqHB/z2aPhjP0ns=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768854665; c=relaxed/simple;
	bh=W+/uaX7MQ5oGAhBejYxhgI2nneVF1r6ZJpBTfIK6IxE=;
	h=Date:To:From:Subject:Message-Id; b=NmgIqerLMpKIPP62hg73XzJqqflCeny3oZUec7CpfsSOo17AndPwEkuVBgOie0EwKBAzmhdb87k92WYmO7mkRVrZZCSoXtGt6FguagDAU9zhp0XhAGVqipuoNm4+oPr1ceK4YQWGHJwKLfOZh9rEafi4VhMvEjO4NUt5USzpue4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=t6QzFybX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="t6QzFybX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A14F2C116C6;
	Mon, 19 Jan 2026 20:31:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768854665;
	bh=W+/uaX7MQ5oGAhBejYxhgI2nneVF1r6ZJpBTfIK6IxE=;
	h=Date:To:From:Subject:From;
	b=t6QzFybXlGNYgoEvlPDUtnm0WRy69Vsd8m+1mm15NN8tr8kS++NxpGt+LWPsGNW1d
	 x3WCWISlb1rOZBCyBpHea8ttW0wyIoFHlOlA73Q0CM/ernfDV9IKX/cfWqe49RATj6
	 U3QZeRzrgdILXOKSpM+XXA/wfb0t5hr3nvC3CLkQ=
Date: Mon, 19 Jan 2026 12:31:05 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,surenb@google.com,rppt@kernel.org,pfalcato@suse.de,mhocko@suse.com,liam.howlett@oracle.com,david@kernel.org,clm@meta.com,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-do-not-copy-page-tables-unnecessarily-for-vm_uffd_wp.patch removed from -mm tree
Message-Id: <20260119203105.A14F2C116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: do not copy page tables unnecessarily for VM_UFFD_WP
has been removed from the -mm tree.  Its filename was
     mm-do-not-copy-page-tables-unnecessarily-for-vm_uffd_wp.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: mm: do not copy page tables unnecessarily for VM_UFFD_WP
Date: Wed, 14 Jan 2026 11:00:06 +0000

Commit ab04b530e7e8 ("mm: introduce copy-on-fork VMAs and make
VM_MAYBE_GUARD one") aggregates flags checks in vma_needs_copy(),
including VM_UFFD_WP.

However in doing so, it incorrectly performed this check against src_vma. 
This check was done on the assumption that all relevant flags are copied
upon fork.

However the userfaultfd logic is very innovative in that it implements
custom logic on fork in dup_userfaultfd(), including a rather well hidden
case where lacking UFFD_FEATURE_EVENT_FORK causes VM_UFFD_WP to not be
propagated to the destination VMA.

And indeed, vma_needs_copy(), prior to this patch, did check this property
on dst_vma, not src_vma.

Since all the other relevant flags are copied on fork, we can simply fix
this by checking against dst_vma.

While we're here, we fix a comment against VM_COPY_ON_FORK (noting that it
did indeed already reference dst_vma) to make it abundantly clear that we
must check against the destination VMA.

Link: https://lkml.kernel.org/r/20260114110006.1047071-1-lorenzo.stoakes@oracle.com
Fixes: ab04b530e7e8 ("mm: introduce copy-on-fork VMAs and make VM_MAYBE_GUARD one")
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reported-by: Chris Mason <clm@meta.com>
Closes: https://lore.kernel.org/all/20260113231257.3002271-1-clm@meta.com/
Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>
Acked-by: Pedro Falcato <pfalcato@suse.de>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    6 +++++-
 mm/memory.c        |    6 +++++-
 2 files changed, 10 insertions(+), 2 deletions(-)

--- a/include/linux/mm.h~mm-do-not-copy-page-tables-unnecessarily-for-vm_uffd_wp
+++ a/include/linux/mm.h
@@ -608,7 +608,11 @@ enum {
 /*
  * Flags which should result in page tables being copied on fork. These are
  * flags which indicate that the VMA maps page tables which cannot be
- * reconsistuted upon page fault, so necessitate page table copying upon
+ * reconsistuted upon page fault, so necessitate page table copying upon fork.
+ *
+ * Note that these flags should be compared with the DESTINATION VMA not the
+ * source, as VM_UFFD_WP may not be propagated to destination, while all other
+ * flags will be.
  *
  * VM_PFNMAP / VM_MIXEDMAP - These contain kernel-mapped data which cannot be
  *                           reasonably reconstructed on page fault.
--- a/mm/memory.c~mm-do-not-copy-page-tables-unnecessarily-for-vm_uffd_wp
+++ a/mm/memory.c
@@ -1465,7 +1465,11 @@ copy_p4d_range(struct vm_area_struct *ds
 static bool
 vma_needs_copy(struct vm_area_struct *dst_vma, struct vm_area_struct *src_vma)
 {
-	if (src_vma->vm_flags & VM_COPY_ON_FORK)
+	/*
+	 * We check against dst_vma as while sane VMA flags will have been
+	 * copied, VM_UFFD_WP may be set only on dst_vma.
+	 */
+	if (dst_vma->vm_flags & VM_COPY_ON_FORK)
 		return true;
 	/*
 	 * The presence of an anon_vma indicates an anonymous VMA has page
_

Patches currently in -mm which might be from lorenzo.stoakes@oracle.com are

mm-rmap-improve-anon_vma_clone-unlink_anon_vmas-comments-add-asserts.patch
mm-rmap-eliminate-partial-anon_vma-tear-down-in-anon_vma_fork.patch
mm-rmap-skip-unfaulted-vmas-on-anon_vma-clone-unlink.patch
mm-rmap-remove-unnecessary-root-lock-dance-in-anon_vma-clone-unmap.patch
mm-rmap-remove-anon_vma_merge-function.patch
mm-rmap-make-anon_vma-functions-internal.patch
mm-mmap_lock-add-vma_is_attached-helper.patch
mm-rmap-allocate-anon_vma_chain-objects-unlocked-when-possible.patch
mm-rmap-separate-out-fork-only-logic-on-anon_vma_clone.patch
locking-add-rwsem_is_write_locked-update-non-lockdep-asserts.patch
mm-vma-add-vma_is__locked-helpers.patch
mm-add-use-vma_is_stabilised-vma_assert_stabilised-helpers.patch
selftests-mm-remove-virtual_address_range-test.patch

