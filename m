Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 095EB265CAF
	for <mm-commits@vger.kernel.org>; Tue, 10 Jun 2025 20:52:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749588760; cv=none; b=pnf/ElAVHn38rn80eUCyNgLAMPi434ngUFH6LWx8zDw/+xAQ8bDuMts4gXecFOCVrKiPOpIJTi20B2UmFRJbctktG/OmlRjmzrS7OwrtS2mOmFCtzHOwWD7I+0ITIA3v/hZ5mApim+rggSX+vLY6yLos1YXMRNGiSGIVFi9H5ts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749588760; c=relaxed/simple;
	bh=dZNQZKsIKfdmfYv25x4t662q0MjFtjYQZwU2PY3zrqQ=;
	h=Date:To:From:Subject:Message-Id; b=MbbYP1+X6stG+O3FZptZI2Rlk/vb9JkpfZLhevH9+osfmPYZRVmlAxIGwfRFfEABN1QjjughTCR5yjYYe2QLTu1Ta7YGidlg058rZEL+8A13w5e/xWGhkaUvAe9vbAYmtlxvZmAnlZ+ugwQDF0OjM1GcWkvtUljy9Ri6nln73FE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=nwHotKj7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="nwHotKj7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81CBFC4CEF3;
	Tue, 10 Jun 2025 20:52:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1749588758;
	bh=dZNQZKsIKfdmfYv25x4t662q0MjFtjYQZwU2PY3zrqQ=;
	h=Date:To:From:Subject:From;
	b=nwHotKj7Yk5G3avVDRj/Kjhk4p0/uvGSxsQGgIgbtBUzqpEiuv9EAw0njtAzjdkj/
	 WII5RZeXjcmzESNz44clo5ao1gKgg6f0WZpUHzGgMvom4fdIemclAhmD37q1fE1PWi
	 DpZrI4vbsA2s9haNW3C9z3AlVLvDaSBB3AfVGLwc=
Date: Tue, 10 Jun 2025 13:52:37 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,willy@infradead.org,vbabka@suse.cz,surenb@google.com,ryan.roberts@arm.com,riel@surriel.com,richard.weiyang@gmail.com,npache@redhat.com,matenajakub@gmail.com,liam.howlett@oracle.com,jannh@google.com,dev.jain@arm.com,david@redhat.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mremap-add-mremap_must_relocate_anon.patch added to mm-new branch
Message-Id: <20250610205238.81CBFC4CEF3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/mremap: add MREMAP_MUST_RELOCATE_ANON
has been added to the -mm mm-new branch.  Its filename is
     mm-mremap-add-mremap_must_relocate_anon.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mremap-add-mremap_must_relocate_anon.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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
Subject: mm/mremap: add MREMAP_MUST_RELOCATE_ANON
Date: Mon, 9 Jun 2025 14:26:36 +0100

This flag is the same as MREMAP_RELOCATE_ANON, however it returns an
-EFAULT error should folios not be able to be relocated.

The operation is undone when this occurs so the user can choose to proceed
without setting this flag at this stage.

This is useful for cases where a use case absolutely requires
mergeability, or moreover a user needs to know whether it succeeded or not
for internal bookkeeping purposes.

If the move would be a no-op (could be merged, or folios in range are
unmapped), then the operation proceeds normally.

It is only in instances where we would have fallen back to the usual
mremap() logic if we were using MREMAP_RELOCATE_ANON that we return
-EFAULT for MREMAP_MUST_RELOCATE_ANON.

Link: https://lkml.kernel.org/r/d770c484f643c77ca11191eec63073457ce03d63.1749473726.git.lorenzo.stoakes@oracle.com
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Jakub Matěna <matenajakub@gmail.com>
Cc: Jann Horn <jannh@google.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Mariano Pache <npache@redhat.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Rik van Riel <riel@surriel.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Wei Yang <richard.weiyang@gmail.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/uapi/linux/mman.h |    9 +++++----
 mm/mremap.c               |   35 ++++++++++++++++++++++++++---------
 2 files changed, 31 insertions(+), 13 deletions(-)

--- a/include/uapi/linux/mman.h~mm-mremap-add-mremap_must_relocate_anon
+++ a/include/uapi/linux/mman.h
@@ -6,10 +6,11 @@
 #include <asm-generic/hugetlb_encode.h>
 #include <linux/types.h>
 
-#define MREMAP_MAYMOVE		1
-#define MREMAP_FIXED		2
-#define MREMAP_DONTUNMAP	4
-#define MREMAP_RELOCATE_ANON	8
+#define MREMAP_MAYMOVE			1
+#define MREMAP_FIXED			2
+#define MREMAP_DONTUNMAP		4
+#define MREMAP_RELOCATE_ANON		8
+#define MREMAP_MUST_RELOCATE_ANON	16
 
 #define OVERCOMMIT_GUESS		0
 #define OVERCOMMIT_ALWAYS		1
--- a/mm/mremap.c~mm-mremap-add-mremap_must_relocate_anon
+++ a/mm/mremap.c
@@ -1385,14 +1385,18 @@ static void unmap_source_vma(struct vma_
  * is being moved to by updating index and mapping fields accordingly?
  */
 static bool should_relocate_anon(struct vma_remap_struct *vrm,
-	struct pagetable_move_control *pmc)
+	struct pagetable_move_control *pmc, int *errp)
 {
 	struct vm_area_struct *old = vrm->vma;
 
 	/* Currently we only do this if requested. */
-	if (!(vrm->flags & MREMAP_RELOCATE_ANON))
+	if (!(vrm->flags & (MREMAP_RELOCATE_ANON | MREMAP_MUST_RELOCATE_ANON)))
 		return false;
 
+	/* Failures are fatal in the 'must' case. */
+	if (vrm->flags & MREMAP_MUST_RELOCATE_ANON)
+		*errp = -EFAULT;
+
 	/* We can't deal with special or hugetlb mappings. */
 	if (old->vm_flags & (VM_SPECIAL | VM_HUGETLB))
 		return false;
@@ -1401,14 +1405,17 @@ static bool should_relocate_anon(struct
 	if (!vma_is_anonymous(old))
 		return false;
 
-	/* If no folios are mapped, then no need to attempt this. */
-	if (!old->anon_vma)
-		return false;
-
 	/* We don't allow relocation of non-exclusive folios. */
 	if (vma_maybe_has_shared_anon_folios(old))
 		return false;
 
+	/* Below issues are non-fatal in 'must' case. */
+	*errp = 0;
+
+	/* If no folios are mapped, then no need to attempt this. */
+	if (!old->anon_vma)
+		return false;
+
 	/* Otherwise, we're good to go! */
 	return true;
 }
@@ -1460,7 +1467,10 @@ static int copy_vma_and_data(struct vma_
 	struct vm_area_struct *new_vma;
 	int err = 0;
 	PAGETABLE_MOVE(pmc, NULL, NULL, vrm->addr, vrm->new_addr, vrm->old_len);
-	bool relocate_anon = should_relocate_anon(vrm, &pmc);
+	bool relocate_anon = should_relocate_anon(vrm, &pmc, &err);
+
+	if (err)
+		return err;
 
 again:
 	new_vma = copy_vma(&vma, vrm->new_addr, vrm->new_len, new_pgoff,
@@ -1491,6 +1501,12 @@ again:
 
 			do_munmap(current->mm, start, size, NULL);
 			relocate_anon = false;
+			if (vrm->flags & MREMAP_MUST_RELOCATE_ANON) {
+				vrm_uncharge(vrm);
+				*new_vma_ptr = NULL;
+				return -EFAULT;
+			}
+
 			goto again;
 		}
 	}
@@ -1840,7 +1856,7 @@ static unsigned long check_mremap_params
 
 	/* Ensure no unexpected flag values. */
 	if (flags & ~(MREMAP_FIXED | MREMAP_MAYMOVE | MREMAP_DONTUNMAP |
-		      MREMAP_RELOCATE_ANON))
+		      MREMAP_RELOCATE_ANON | MREMAP_MUST_RELOCATE_ANON))
 		return -EINVAL;
 
 	/* Start address must be page-aligned. */
@@ -1856,7 +1872,8 @@ static unsigned long check_mremap_params
 		return -EINVAL;
 
 	/* We can't relocate without allowing a move. */
-	if ((flags & MREMAP_RELOCATE_ANON) && !(flags & MREMAP_MAYMOVE))
+	if ((flags & (MREMAP_RELOCATE_ANON | MREMAP_MUST_RELOCATE_ANON)) &&
+	     !(flags & MREMAP_MAYMOVE))
 		return -EINVAL;
 
 	/* Remainder of checks are for cases with specific new_addr. */
_

Patches currently in -mm which might be from lorenzo.stoakes@oracle.com are

mm-vma-reset-vma-iterator-on-commit_merge-oom-failure.patch
mm-add-mmap_prepare-compatibility-layer-for-nested-file-systems.patch
mm-add-mmap_prepare-compatibility-layer-for-nested-file-systems-fix-2.patch
docs-mm-expand-vma-doc-to-highlight-pte-freeing-non-vma-traversal.patch
mm-ksm-have-ksm-vma-checks-not-require-a-vma-pointer.patch
mm-ksm-refer-to-special-vmas-via-vm_special-in-ksm_compatible.patch
mm-prevent-ksm-from-breaking-vma-merging-for-new-vmas.patch
tools-testing-selftests-add-vma-merge-tests-for-ksm-merge.patch
mm-pagewalk-split-walk_page_range_novma-into-kernel-user-parts.patch
mm-mremap-introduce-more-mergeable-mremap-via-mremap_relocate_anon.patch
mm-mremap-add-mremap_must_relocate_anon.patch
mm-mremap-add-mremap_relocate_anon-support-for-large-folios.patch
tools-uapi-update-copy-of-linux-mmanh-from-the-kernel-sources.patch
tools-testing-selftests-add-sys_mremap-helper-to-vm_utilh.patch
tools-testing-selftests-add-mremap-cases-that-merge-normally.patch
tools-testing-selftests-add-mremap_relocate_anon-merge-test-cases.patch
tools-testing-selftests-expand-mremap-tests-for-mremap_relocate_anon.patch
tools-testing-selftests-have-cow-self-test-use-mremap_relocate_anon.patch
tools-testing-selftests-test-relocate-anon-in-split-huge-page-test.patch
tools-testing-selftests-add-mremap_relocate_anon-fork-tests.patch

