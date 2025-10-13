Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A86A82FE058;
	Mon, 13 Oct 2025 23:03:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760396580; cv=none; b=c/LB9llE1PHD7LyhBSpD1IhBHOIPGFN2uxpGuPIXe8ltjyvCcB0Tx4aCPiooXVrDQznZT5/rvrbTPEOWC3uzy8YK5kCI2j8j0QaAorIoBCBUjk5sjEaTlU6oW/xbh7NU8HD1V7S0Zr8nhTnSOwm81GSY10GSO1o/GMX6YpR/dvo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760396580; c=relaxed/simple;
	bh=f6n6SX5y5y/14RlIb6Cbh0wyuy4ECH9GThF4DSAzwy8=;
	h=Date:To:From:Subject:Message-Id; b=R3frUH3UtFtvad4fwM+PqNwr6cWxyXajdS42GdogogPabzNEs4iSto15ntnFcCToC4FEi+qN//A9Bzcg3d8qQetkr341WFnF0D4rKl8l0Fk4gVSpDb6RbKUF3YeyrnYmPkgi/7mUKoMJn+VvtB0GErUhc4bXR/Jp5Q6OYjVvEPI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=QJPDswOB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="QJPDswOB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A59EC4CEE7;
	Mon, 13 Oct 2025 23:03:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1760396580;
	bh=f6n6SX5y5y/14RlIb6Cbh0wyuy4ECH9GThF4DSAzwy8=;
	h=Date:To:From:Subject:From;
	b=QJPDswOBp1KtCtmTjNUA0ExpRbi4/V0ihzFyy+Dem9eQShhFh8Z+iqVHGyUNgXZPq
	 IYTRteynp0vXZv84E3XAhE6Q95mG4VrIIGellhZx0WOyipmFCq04Grdc95G0wvvbN+
	 9Uf8UIVsL6RhRfwqm+QyXPb9bLEXlSNddKRfCz+8=
Date: Mon, 13 Oct 2025 16:02:59 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,stable@vger.kernel.org,liam.howlett@oracle.com,jannh@google.com,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mremap-correctly-account-old-mapping-after-mremap_dontunmap-remap.patch added to mm-hotfixes-unstable branch
Message-Id: <20251013230300.0A59EC4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/mremap: correctly account old mapping after MREMAP_DONTUNMAP remap
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-mremap-correctly-account-old-mapping-after-mremap_dontunmap-remap.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mremap-correctly-account-old-mapping-after-mremap_dontunmap-remap.patch

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
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: mm/mremap: correctly account old mapping after MREMAP_DONTUNMAP remap
Date: Mon, 13 Oct 2025 17:58:36 +0100

Commit b714ccb02a76 ("mm/mremap: complete refactor of move_vma()")
mistakenly introduced a new behaviour - clearing the VM_ACCOUNT flag of
the old mapping when a mapping is mremap()'d with the MREMAP_DONTUNMAP
flag set.

While we always clear the VM_LOCKED and VM_LOCKONFAULT flags for the old
mapping (the page tables have been moved, so there is no data that could
possibly be locked in memory), there is no reason to touch any other VMA
flags.

This is because after the move the old mapping is in a state as if it were
freshly mapped.  This implies that the attributes of the mapping ought to
remain the same, including whether or not the mapping is accounted.

Link: https://lkml.kernel.org/r/20251013165836.273113-1-lorenzo.stoakes@oracle.com
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Fixes: b714ccb02a76 ("mm/mremap: complete refactor of move_vma()")
Cc: Jann Horn <jannh@google.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mremap.c |   15 ++++++---------
 1 file changed, 6 insertions(+), 9 deletions(-)

--- a/mm/mremap.c~mm-mremap-correctly-account-old-mapping-after-mremap_dontunmap-remap
+++ a/mm/mremap.c
@@ -1237,10 +1237,10 @@ static int copy_vma_and_data(struct vma_
 }
 
 /*
- * Perform final tasks for MADV_DONTUNMAP operation, clearing mlock() and
- * account flags on remaining VMA by convention (it cannot be mlock()'d any
- * longer, as pages in range are no longer mapped), and removing anon_vma_chain
- * links from it (if the entire VMA was copied over).
+ * Perform final tasks for MADV_DONTUNMAP operation, clearing mlock() flag on
+ * remaining VMA by convention (it cannot be mlock()'d any longer, as pages in
+ * range are no longer mapped), and removing anon_vma_chain links from it if the
+ * entire VMA was copied over.
  */
 static void dontunmap_complete(struct vma_remap_struct *vrm,
 			       struct vm_area_struct *new_vma)
@@ -1250,11 +1250,8 @@ static void dontunmap_complete(struct vm
 	unsigned long old_start = vrm->vma->vm_start;
 	unsigned long old_end = vrm->vma->vm_end;
 
-	/*
-	 * We always clear VM_LOCKED[ONFAULT] | VM_ACCOUNT on the old
-	 * vma.
-	 */
-	vm_flags_clear(vrm->vma, VM_LOCKED_MASK | VM_ACCOUNT);
+	/* We always clear VM_LOCKED[ONFAULT] on the old VMA. */
+	vm_flags_clear(vrm->vma, VM_LOCKED_MASK);
 
 	/*
 	 * anon_vma links of the old vma is no longer needed after its page
_

Patches currently in -mm which might be from lorenzo.stoakes@oracle.com are

mm-mremap-correctly-account-old-mapping-after-mremap_dontunmap-remap.patch
mm-shmem-update-shmem-to-use-mmap_prepare.patch
device-dax-update-devdax-to-use-mmap_prepare.patch
mm-add-vma_desc_size-vma_desc_pages-helpers.patch
relay-update-relay-to-use-mmap_prepare.patch
mm-vma-rename-__mmap_prepare-function-to-avoid-confusion.patch
mm-add-remap_pfn_range_prepare-remap_pfn_range_complete.patch
mm-abstract-io_remap_pfn_range-based-on-pfn.patch
mm-introduce-io_remap_pfn_range_.patch
mm-introduce-io_remap_pfn_range_-fix.patch
mm-add-ability-to-take-further-action-in-vm_area_desc.patch
doc-update-porting-vfs-documentation-for-mmap_prepare-actions.patch
mm-hugetlbfs-update-hugetlbfs-to-use-mmap_prepare.patch
mm-add-shmem_zero_setup_desc.patch
mm-update-mem-char-driver-to-use-mmap_prepare.patch
mm-update-resctl-to-use-mmap_prepare.patch

