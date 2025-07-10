Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F6B02905
	for <mm-commits@vger.kernel.org>; Thu, 10 Jul 2025 05:43:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752126195; cv=none; b=oLu7VACrCF9r2SDdM7t6OwC+nRFF2DxjH4vTpVCj04/e4/nxIfkQrvqH+I23GyNyUXRdxk3t3/1JozhLsG2+xxRL4v+6VZxssQDAFwlndMLlEee+UNUomnk3frYK2U28vcrO5FKFASRpHeZ4MX9T+UHwsTXivP0LuQwEheX+eDQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752126195; c=relaxed/simple;
	bh=j20z3/ZERKfFh2deYT9Acmd0mi/2bfghxNdoydjldu4=;
	h=Date:To:From:Subject:Message-Id; b=LNMAkTiPov1dD8yL5eIziJSm5C2ETj2QPY2yphrQDKuWSILyQg6tTm+RKn2ryLqVC5a9gtkQazXethEUdjUHFkfifZsr01snEvdYWcf2X4HgDZwUI1dHTZO993RUOLlVWgBv68dFG5XIJRZPeZQKyTJNL6zhm0fampiPe0kNRM0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=KoOq+glg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="KoOq+glg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFADCC4CEF4;
	Thu, 10 Jul 2025 05:43:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752126194;
	bh=j20z3/ZERKfFh2deYT9Acmd0mi/2bfghxNdoydjldu4=;
	h=Date:To:From:Subject:From;
	b=KoOq+glgeBIiKciMiUEWuoK62cSjN/PCO/Qs3grggS/d7ZDdotjS52C63yvxHNnwE
	 sd7xqcsnIQmXYj5a3181D9Oq31I0XIaHACiEWEMwhg057zDXl8ScOGU4ZPCX11fAWc
	 5dd5j5GTSpiI34NANvPqH2//ZGBG74F/R+hXA5EY=
Date: Wed, 09 Jul 2025 22:43:14 -0700
To: mm-commits@vger.kernel.org,xu.xin16@zte.com.cn,viro@zeniv.linux.org.uk,vbabka@suse.cz,shr@devkernel.io,Liam.Howlett@oracle.com,jannh@google.com,jack@suse.cz,david@redhat.com,chengming.zhou@linux.dev,brauner@kernel.org,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-ksm-have-ksm-vma-checks-not-require-a-vma-pointer.patch removed from -mm tree
Message-Id: <20250710054314.BFADCC4CEF4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: ksm: have KSM VMA checks not require a VMA pointer
has been removed from the -mm tree.  Its filename was
     mm-ksm-have-ksm-vma-checks-not-require-a-vma-pointer.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: mm: ksm: have KSM VMA checks not require a VMA pointer
Date: Thu, 29 May 2025 18:15:45 +0100

Patch series "mm: ksm: prevent KSM from breaking merging of new VMAs", v3.

When KSM-by-default is established using prctl(PR_SET_MEMORY_MERGE), this
defaults all newly mapped VMAs to having VM_MERGEABLE set, and thus makes
them available to KSM for samepage merging.  It also sets VM_MERGEABLE in
all existing VMAs.

However this causes an issue upon mapping of new VMAs - the initial flags
will never have VM_MERGEABLE set when attempting a merge with adjacent
VMAs (this is set later in the mmap() logic), and adjacent VMAs will
ALWAYS have VM_MERGEABLE set.

This renders all newly mapped VMAs unmergeable.

To avoid this, this series performs the check for PR_SET_MEMORY_MERGE far
earlier in the mmap() logic, prior to the merge being attempted.

However we run into complexity with the depreciated .mmap() callback - if
a driver hooks this, it might change flags which adjust KSM merge
eligibility.

We have to worry about this because, while KSM is only applicable to
private mappings, this includes both anonymous and MAP_PRIVATE-mapped
file-backed mappings.

This isn't a problem for brk(), where the VMA must be anonymous.  However
in mmap() we must be conservative - if the VMA is anonymous then we can
always proceed, however if not, we permit only shmem mappings (whose .mmap
hook does not affect KSM eligibility) and drivers which implement
.mmap_prepare() (invoked prior to the KSM eligibility check).

If we can't be sure of the driver changing things, then we maintain the
same behaviour of performing the KSM check later in the mmap() logic (and
thus losing new VMA mergeability).

A great many use-cases for this logic will use anonymous mappings any
rate, so this change should already cover the majority of actual KSM
use-cases.


This patch (of 4):

In subsequent commits we are going to determine KSM eligibility prior to a
VMA being constructed, at which point we will of course not yet have
access to a VMA pointer.

It is trivial to boil down the check logic to be parameterised on
mm_struct, file and VMA flags, so do so.

As a part of this change, additionally expose and use file_is_dax() to
determine whether a file is being mapped under a DAX inode.

Link: https://lkml.kernel.org/r/cover.1748537921.git.lorenzo.stoakes@oracle.com
Link: https://lkml.kernel.org/r/36ad13eb50cdbd8aac6dcfba22c65d5031667295.1748537921.git.lorenzo.stoakes@oracle.com
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Chengming Zhou <chengming.zhou@linux.dev>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: Xu Xin <xu.xin16@zte.com.cn>
Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Jan Kara <jack@suse.cz>
Cc: Jann Horn <jannh@google.com>
Cc: Stefan Roesch <shr@devkernel.io>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/fs.h |    7 ++++++-
 mm/ksm.c           |   32 ++++++++++++++++++++------------
 2 files changed, 26 insertions(+), 13 deletions(-)

--- a/include/linux/fs.h~mm-ksm-have-ksm-vma-checks-not-require-a-vma-pointer
+++ a/include/linux/fs.h
@@ -3726,9 +3726,14 @@ void setattr_copy(struct mnt_idmap *, st
 
 extern int file_update_time(struct file *file);
 
+static inline bool file_is_dax(const struct file *file)
+{
+	return file && IS_DAX(file->f_mapping->host);
+}
+
 static inline bool vma_is_dax(const struct vm_area_struct *vma)
 {
-	return vma->vm_file && IS_DAX(vma->vm_file->f_mapping->host);
+	return file_is_dax(vma->vm_file);
 }
 
 static inline bool vma_is_fsdax(struct vm_area_struct *vma)
--- a/mm/ksm.c~mm-ksm-have-ksm-vma-checks-not-require-a-vma-pointer
+++ a/mm/ksm.c
@@ -677,28 +677,33 @@ static int break_ksm(struct vm_area_stru
 	return (ret & VM_FAULT_OOM) ? -ENOMEM : 0;
 }
 
-static bool vma_ksm_compatible(struct vm_area_struct *vma)
+static bool ksm_compatible(const struct file *file, vm_flags_t vm_flags)
 {
-	if (vma->vm_flags & (VM_SHARED  | VM_MAYSHARE   | VM_PFNMAP  |
-			     VM_IO      | VM_DONTEXPAND | VM_HUGETLB |
-			     VM_MIXEDMAP| VM_DROPPABLE))
+	if (vm_flags & (VM_SHARED   | VM_MAYSHARE   | VM_PFNMAP  |
+			VM_IO       | VM_DONTEXPAND | VM_HUGETLB |
+			VM_MIXEDMAP | VM_DROPPABLE))
 		return false;		/* just ignore the advice */
 
-	if (vma_is_dax(vma))
+	if (file_is_dax(file))
 		return false;
 
 #ifdef VM_SAO
-	if (vma->vm_flags & VM_SAO)
+	if (vm_flags & VM_SAO)
 		return false;
 #endif
 #ifdef VM_SPARC_ADI
-	if (vma->vm_flags & VM_SPARC_ADI)
+	if (vm_flags & VM_SPARC_ADI)
 		return false;
 #endif
 
 	return true;
 }
 
+static bool vma_ksm_compatible(struct vm_area_struct *vma)
+{
+	return ksm_compatible(vma->vm_file, vma->vm_flags);
+}
+
 static struct vm_area_struct *find_mergeable_vma(struct mm_struct *mm,
 		unsigned long addr)
 {
@@ -2696,14 +2701,17 @@ static int ksm_scan_thread(void *nothing
 	return 0;
 }
 
-static void __ksm_add_vma(struct vm_area_struct *vma)
+static bool __ksm_should_add_vma(const struct file *file, vm_flags_t vm_flags)
 {
-	unsigned long vm_flags = vma->vm_flags;
-
 	if (vm_flags & VM_MERGEABLE)
-		return;
+		return false;
+
+	return ksm_compatible(file, vm_flags);
+}
 
-	if (vma_ksm_compatible(vma))
+static void __ksm_add_vma(struct vm_area_struct *vma)
+{
+	if (__ksm_should_add_vma(vma->vm_file, vma->vm_flags))
 		vm_flags_set(vma, VM_MERGEABLE);
 }
 
_

Patches currently in -mm which might be from lorenzo.stoakes@oracle.com are

mm-madvise-remove-the-visitor-pattern-and-thread-anon_vma-state.patch
mm-madvise-thread-mm_struct-through-madvise_behavior.patch
mm-madvise-thread-vma-range-state-through-madvise_behavior.patch
mm-madvise-thread-all-madvise-state-through-madv_behavior.patch
mm-madvise-eliminate-very-confusing-manipulation-of-prev-vma.patch
mm-madvise-eliminate-very-confusing-manipulation-of-prev-vma-fix.patch
tools-testing-selftests-add-mremap-unfaulted-faulted-test-cases.patch
mm-mremap-perform-some-simple-cleanups.patch
mm-mremap-refactor-initial-parameter-sanity-checks.patch
mm-mremap-put-vma-check-and-prep-logic-into-helper-function.patch
mm-mremap-cleanup-post-processing-stage-of-mremap.patch
mm-mremap-use-an-explicit-uffd-failure-path-for-mremap.patch
mm-mremap-use-an-explicit-uffd-failure-path-for-mremap-fix.patch
mm-mremap-check-remap-conditions-earlier.patch
mm-mremap-move-remap_is_valid-into-check_prep_vma.patch
mm-mremap-clean-up-mlock-populate-behaviour.patch
mm-mremap-permit-mremap-move-of-multiple-vmas.patch
tools-testing-selftests-extend-mremap_test-to-test-multi-vma-mremap.patch

