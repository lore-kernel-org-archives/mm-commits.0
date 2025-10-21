Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32E911C3C11;
	Tue, 21 Oct 2025 22:46:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761086816; cv=none; b=etE31qAD/FJjHOV/cz+2ibJs8JhYuSohme5SVs9Rov+NVSJGkT6q0B5/G4QVHFo967hblssilufn5Usv50tLfwpytEJ3Q0YkF62JKhZAiiBytr/0N2GHtnuXMsBPhyhHkTPDRtVFlSpbmx+2AJlgxZ4oB+ZRpznlWbDg4V4u79M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761086816; c=relaxed/simple;
	bh=HwjKxoRqWWm+zyASq59PHrY+g+Yeveiw7Tu3cLecB6w=;
	h=Date:To:From:Subject:Message-Id; b=QbEwqGUUzKAH9CmAHv1i1O0ImWle1MpsrEI7Z11D9FCYddkbnmYE0IxQ9isJDqZXTFlzvnVIoO5BUV5bni1RFhLTIjHO30PL+wnTykndNdvT3qNZ0fEdnnDg26fs21w+GTxIeU+u371TDlb00ZcrSPv6Zyf4l7SGkV1NQ3f8KWw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=MmKFGYey; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="MmKFGYey"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A58D2C4CEF1;
	Tue, 21 Oct 2025 22:46:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1761086815;
	bh=HwjKxoRqWWm+zyASq59PHrY+g+Yeveiw7Tu3cLecB6w=;
	h=Date:To:From:Subject:From;
	b=MmKFGYeyiuJ/Ir+cGavCqcdpPxRcJqHnWo+hWzXhtiRqxnyGwbsKhUtu4z2cSMM8y
	 WfKskFApNUPbZ2SdGSzUh6CQSURTPWatZ600RL356hVqmM42qMSDXAHYrcF3FTg2f3
	 4EN8n5AN7sTJxFaciZL02tOvMpRoeV6w781g1UN8=
Date: Tue, 21 Oct 2025 15:46:54 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,stable@vger.kernel.org,pfalcato@suse.de,liam.howlett@oracle.com,jannh@google.com,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-mremap-correctly-account-old-mapping-after-mremap_dontunmap-remap.patch removed from -mm tree
Message-Id: <20251021224655.A58D2C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/mremap: correctly account old mapping after MREMAP_DONTUNMAP remap
has been removed from the -mm tree.  Its filename was
     mm-mremap-correctly-account-old-mapping-after-mremap_dontunmap-remap.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Reviewed-by: Pedro Falcato <pfalcato@suse.de>
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

mm-shmem-update-shmem-to-use-mmap_prepare.patch
device-dax-update-devdax-to-use-mmap_prepare.patch
mm-vma-remove-unused-function-make-internal-functions-static.patch
mm-add-vma_desc_size-vma_desc_pages-helpers.patch
relay-update-relay-to-use-mmap_prepare.patch
mm-vma-rename-__mmap_prepare-function-to-avoid-confusion.patch
mm-add-remap_pfn_range_prepare-remap_pfn_range_complete.patch
mm-abstract-io_remap_pfn_range-based-on-pfn.patch
mm-introduce-io_remap_pfn_range_.patch
mm-add-ability-to-take-further-action-in-vm_area_desc.patch
doc-update-porting-vfs-documentation-for-mmap_prepare-actions.patch
mm-hugetlbfs-update-hugetlbfs-to-use-mmap_prepare.patch
mm-add-shmem_zero_setup_desc.patch
mm-update-mem-char-driver-to-use-mmap_prepare.patch
mm-update-resctl-to-use-mmap_prepare.patch

