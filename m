Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BA573FE4
	for <mm-commits@vger.kernel.org>; Tue,  3 Jun 2025 02:52:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748919142; cv=none; b=mPCZfc/aCOvy1zz56uqQD+y0RTdXwTD0IZaRsr/ylpxKYB3q7BbYTsupJSKPm+l3njaAOLji8sTtIL7oSn9XFp4iZc2XndzQx5EQhNjUwegcXn/L/WPFLz3ciA/I3KM6/HzDS97FtEv2JhpBzusFIAOPHZrJCsDaGKLt9tkHt8w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748919142; c=relaxed/simple;
	bh=T8tVzt7axbPOkqBHZv4Nw1Ou7CDw6jrBWUTDHb45kMY=;
	h=Date:To:From:Subject:Message-Id; b=Mn40ag/+AlxIbo9Ai1FthUgaQpUYw3DEmh7CypnPd+aVTRHP1H50Jwqoium4Hd++2VLmeDUkpHjx92UiqqxnWW+cApnonTW0YTPfRiw2GdmZav25UaxDrEafqdBBRcqdLq+hf8Y4GCWWj2KZXqpFi8Ts/UBdZYuE16so6VqT4YY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=fuBMvgHl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="fuBMvgHl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 405E6C4CEEB;
	Tue,  3 Jun 2025 02:52:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1748919141;
	bh=T8tVzt7axbPOkqBHZv4Nw1Ou7CDw6jrBWUTDHb45kMY=;
	h=Date:To:From:Subject:From;
	b=fuBMvgHlxJh5yYm5wNwnFKLh/22De2eaP2xBIOX51voJy32f5ONl1jFMTYDpcUypl
	 s9Hd5lTX0ZQFa6xAjVACtguxuhHtPLKg8KpUsgIE7+udL6lIExPBXKmOriDBbVBo/h
	 1r6WhYs0+zbjf28mL1c5YppBl5CT8Dkx0AkSAPic=
Date: Mon, 02 Jun 2025 19:52:20 -0700
To: mm-commits@vger.kernel.org,xu.xin16@zte.com.cn,viro@zeniv.linux.org.uk,vbabka@suse.cz,shr@devkernel.io,Liam.Howlett@oracle.com,jannh@google.com,jack@suse.cz,david@redhat.com,chengming.zhou@linux.dev,brauner@kernel.org,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-ksm-have-ksm-vma-checks-not-require-a-vma-pointer.patch added to mm-new branch
Message-Id: <20250603025221.405E6C4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: ksm: have KSM VMA checks not require a VMA pointer
has been added to the -mm mm-new branch.  Its filename is
     mm-ksm-have-ksm-vma-checks-not-require-a-vma-pointer.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-ksm-have-ksm-vma-checks-not-require-a-vma-pointer.patch

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
@@ -3720,9 +3720,14 @@ void setattr_copy(struct mnt_idmap *, st
 
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

kvm-s390-rename-prot_none-to-prot_type_dummy.patch
mm-ksm-have-ksm-vma-checks-not-require-a-vma-pointer.patch
mm-ksm-refer-to-special-vmas-via-vm_special-in-ksm_compatible.patch
mm-prevent-ksm-from-breaking-vma-merging-for-new-vmas.patch
tools-testing-selftests-add-vma-merge-tests-for-ksm-merge.patch

