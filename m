Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77EBE289E06
	for <mm-commits@vger.kernel.org>; Thu, 15 Jan 2026 23:19:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768519141; cv=none; b=jsfAtCDe5nUvjb1fWwzT43DDoX95fZ1Kj/l6CdR05+tRnkhfqvM9iAc8i531ksoSr8fj/N4ujS0T8+acnqFZqaSq/XKxFPZbUolb8cy2thobbarl70xEz6B/xS9oviUNOJBvjH0/hj9xYwis0a33nGuCJvL8UBVg94+E7ehECiA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768519141; c=relaxed/simple;
	bh=zwJr0ynThT0SEEPvCtK2OCi2VB8GkNDEYhFM9HlLRLM=;
	h=Date:To:From:Subject:Message-Id; b=gspy8HUDv107/HPyHy3zyA7ufyeNQr7No+jBqV9a5vodFjNUu8k9Tdp91xPrzqIBziZkxrMSox+frY6KvJvs/y9FYcHTvn4mSfiO0/ZYOVgqzv0KRyM0IMnALU5lZb5dR/nzOQE0e8Y0m4tDqp5vKSrfpUlHkXXizjKB5pNCRWU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=O/eiX8K+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="O/eiX8K+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3DC7C116D0;
	Thu, 15 Jan 2026 23:19:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768519141;
	bh=zwJr0ynThT0SEEPvCtK2OCi2VB8GkNDEYhFM9HlLRLM=;
	h=Date:To:From:Subject:From;
	b=O/eiX8K+juRvMwi67pnlJ+ad8aymi4vWTVczvltxYfyvu7406WaLz4i/AZEYVekr9
	 TFPup0p61Fy2h+KhHLK/KV7eb4fzKOUQSTLi8HTSgshqU+Sw6iZXUI9bngvhaUpZ2B
	 E4on+XnKxk5p5tvPF3TIUvUJElM8t/2Zx/jRryMM=
Date: Thu, 15 Jan 2026 15:19:00 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,surenb@google.com,rppt@kernel.org,pfalcato@suse.de,mhocko@suse.com,liam.howlett@oracle.com,david@kernel.org,clm@meta.com,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-do-not-copy-page-tables-unnecessarily-for-vm_uffd_wp.patch added to mm-hotfixes-unstable branch
Message-Id: <20260115231900.E3DC7C116D0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: do not copy page tables unnecessarily for VM_UFFD_WP
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-do-not-copy-page-tables-unnecessarily-for-vm_uffd_wp.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-do-not-copy-page-tables-unnecessarily-for-vm_uffd_wp.patch

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

mm-vma-do-not-leak-memory-when-mmap_prepare-swaps-the-file.patch
mm-remove-unnecessary-and-incorrect-mmap-lock-assert.patch
mm-do-not-copy-page-tables-unnecessarily-for-vm_uffd_wp.patch
mm-rmap-improve-anon_vma_clone-unlink_anon_vmas-comments-add-asserts.patch
mm-rmap-improve-anon_vma_clone-unlink_anon_vmas-comments-add-asserts-fix.patch
mm-rmap-skip-unfaulted-vmas-on-anon_vma-clone-unlink.patch
mm-rmap-remove-unnecessary-root-lock-dance-in-anon_vma-clone-unmap.patch
mm-rmap-remove-anon_vma_merge-function.patch
mm-rmap-make-anon_vma-functions-internal.patch
mm-mmap_lock-add-vma_is_attached-helper.patch
mm-rmap-allocate-anon_vma_chain-objects-unlocked-when-possible.patch
mm-rmap-allocate-anon_vma_chain-objects-unlocked-when-possible-fix.patch
mm-rmap-separate-out-fork-only-logic-on-anon_vma_clone.patch
mm-rmap-separate-out-fork-only-logic-on-anon_vma_clone-fix.patch

