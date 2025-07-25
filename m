Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C78A72620C3
	for <mm-commits@vger.kernel.org>; Fri, 25 Jul 2025 23:27:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753486022; cv=none; b=h6SZkGwK1rYNZND4rZopmqE9G0PXnfLfPn3Eff2G7q+7lr8wUqFpLC4t0qBXyzNgp17n1nlGZTVxorJxp3MdiQAyA8p6nunu/E9b5NdvbzFLhyIbxEnOVftl06vC+SBHBTuSuIWp3H9B6Y640xG69ljoENJ66rkRMTU0pz9ZpY0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753486022; c=relaxed/simple;
	bh=g5/PrLBauXlIo0BvNCBXVA5SaDlehF80vhxGTIkSwuc=;
	h=Date:To:From:Subject:Message-Id; b=czHwfGhuzFo94f+Kf/Gb/usNLZDQd+YleNN7ohg2kkooVLl1HZHCRtLntTJPfugxEd8RypYYvpG/TsfypXopXqnRYmIVNMh7OHVyLaGVTpe2CHZKa+PwGW5sb2dqB5my2uFUrgoGqFEIIjGoeLpsq7OF98PFR/ATtmx8k/4ZbB4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=TRbH9Pn3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="TRbH9Pn3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 814EAC4CEF6;
	Fri, 25 Jul 2025 23:27:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1753486022;
	bh=g5/PrLBauXlIo0BvNCBXVA5SaDlehF80vhxGTIkSwuc=;
	h=Date:To:From:Subject:From;
	b=TRbH9Pn3iXue5DzHQ17GPVF/vlgI24wrGnY3LeF/Ntk8oK8ua9yrMoNX//CWu19eI
	 TJi2vrkPkdVXlHGZOeTM8U4y3rjna4voiV25jLTRvIl7QlP1I7jjNXxRo5ntKVzNn5
	 yaXEdOUSH9fHytEnyvbW0iJb5haS7A2oL2fGCkCY=
Date: Fri, 25 Jul 2025 16:27:01 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,pfalcato@suse.de,Liam.Howlett@oracle.com,kees@kernel.org,jeffxu@chromium.org,jannh@google.com,david@redhat.com,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mseal-small-cleanups.patch added to mm-unstable branch
Message-Id: <20250725232702.814EAC4CEF6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/mseal: small cleanups
has been added to the -mm mm-unstable branch.  Its filename is
     mm-mseal-small-cleanups.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mseal-small-cleanups.patch

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
Subject: mm/mseal: small cleanups
Date: Fri, 25 Jul 2025 09:29:43 +0100

Drop the wholly unnecessary set_vma_sealed() helper(), which is used only
once, and place VMA_ITERATOR() declarations in the correct place.

Retain vma_is_sealed(), and use it instead of the confusingly named
can_modify_vma(), so it's abundantly clear what's being tested, rather
then a nebulous sense of 'can the VMA be modified'.

No functional change intended.

Link: https://lkml.kernel.org/r/98cf28d04583d632a6eb698e9ad23733bb6af26b.1753431105.git.lorenzo.stoakes@oracle.com
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Reviewed-by: Pedro Falcato <pfalcato@suse.de>
Acked-by: David Hildenbrand <david@redhat.com>
Acked-by: Jeff Xu <jeffxu@chromium.org>
Cc: Jann Horn <jannh@google.com>
Cc: Kees Cook <kees@kernel.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/madvise.c  |    2 +-
 mm/mprotect.c |    2 +-
 mm/mremap.c   |    2 +-
 mm/mseal.c    |    9 +--------
 mm/vma.c      |    4 ++--
 mm/vma.h      |   20 ++------------------
 6 files changed, 8 insertions(+), 31 deletions(-)

--- a/mm/madvise.c~mm-mseal-small-cleanups
+++ a/mm/madvise.c
@@ -1287,7 +1287,7 @@ static bool can_madvise_modify(struct ma
 	struct vm_area_struct *vma = madv_behavior->vma;
 
 	/* If the VMA isn't sealed we're good. */
-	if (can_modify_vma(vma))
+	if (!vma_is_sealed(vma))
 		return true;
 
 	/* For a sealed VMA, we only care about discard operations. */
--- a/mm/mprotect.c~mm-mseal-small-cleanups
+++ a/mm/mprotect.c
@@ -766,7 +766,7 @@ mprotect_fixup(struct vma_iterator *vmi,
 	unsigned long charged = 0;
 	int error;
 
-	if (!can_modify_vma(vma))
+	if (vma_is_sealed(vma))
 		return -EPERM;
 
 	if (newflags == oldflags) {
--- a/mm/mremap.c~mm-mseal-small-cleanups
+++ a/mm/mremap.c
@@ -1651,7 +1651,7 @@ static int check_prep_vma(struct vma_rem
 		return -EFAULT;
 
 	/* If mseal()'d, mremap() is prohibited. */
-	if (!can_modify_vma(vma))
+	if (vma_is_sealed(vma))
 		return -EPERM;
 
 	/* Align to hugetlb page size, if required. */
--- a/mm/mseal.c~mm-mseal-small-cleanups
+++ a/mm/mseal.c
@@ -15,11 +15,6 @@
 #include <linux/sched.h>
 #include "internal.h"
 
-static inline void set_vma_sealed(struct vm_area_struct *vma)
-{
-	vm_flags_set(vma, VM_SEALED);
-}
-
 static int mseal_fixup(struct vma_iterator *vmi, struct vm_area_struct *vma,
 		struct vm_area_struct **prev, unsigned long start,
 		unsigned long end, vm_flags_t newflags)
@@ -36,7 +31,7 @@ static int mseal_fixup(struct vma_iterat
 		goto out;
 	}
 
-	set_vma_sealed(vma);
+	vm_flags_set(vma, VM_SEALED);
 out:
 	*prev = vma;
 	return ret;
@@ -53,7 +48,6 @@ static int check_mm_seal(unsigned long s
 {
 	struct vm_area_struct *vma;
 	unsigned long nstart = start;
-
 	VMA_ITERATOR(vmi, current->mm, start);
 
 	/* going through each vma to check. */
@@ -78,7 +72,6 @@ static int apply_mm_seal(unsigned long s
 {
 	unsigned long nstart;
 	struct vm_area_struct *vma, *prev;
-
 	VMA_ITERATOR(vmi, current->mm, start);
 
 	vma = vma_iter_load(&vmi);
--- a/mm/vma.c~mm-mseal-small-cleanups
+++ a/mm/vma.c
@@ -1351,7 +1351,7 @@ static int vms_gather_munmap_vmas(struct
 		}
 
 		/* Don't bother splitting the VMA if we can't unmap it anyway */
-		if (!can_modify_vma(vms->vma)) {
+		if (vma_is_sealed(vms->vma)) {
 			error = -EPERM;
 			goto start_split_failed;
 		}
@@ -1371,7 +1371,7 @@ static int vms_gather_munmap_vmas(struct
 	for_each_vma_range(*(vms->vmi), next, vms->end) {
 		long nrpages;
 
-		if (!can_modify_vma(next)) {
+		if (vma_is_sealed(next)) {
 			error = -EPERM;
 			goto modify_vma_failed;
 		}
--- a/mm/vma.h~mm-mseal-small-cleanups
+++ a/mm/vma.h
@@ -559,31 +559,15 @@ struct vm_area_struct *vma_iter_next_rew
 }
 
 #ifdef CONFIG_64BIT
-
 static inline bool vma_is_sealed(struct vm_area_struct *vma)
 {
 	return (vma->vm_flags & VM_SEALED);
 }
-
-/*
- * check if a vma is sealed for modification.
- * return true, if modification is allowed.
- */
-static inline bool can_modify_vma(struct vm_area_struct *vma)
-{
-	if (unlikely(vma_is_sealed(vma)))
-		return false;
-
-	return true;
-}
-
 #else
-
-static inline bool can_modify_vma(struct vm_area_struct *vma)
+static inline bool vma_is_sealed(struct vm_area_struct *vma)
 {
-	return true;
+	return false;
 }
-
 #endif
 
 #if defined(CONFIG_STACK_GROWSUP)
_

Patches currently in -mm which might be from lorenzo.stoakes@oracle.com are

maintainers-add-missing-percpu-internalh-file-to-per-cpu-section.patch
maintainers-add-missing-interval_treec-to-memory-mapping-section.patch
maintainers-add-missing-mm_sloth-file-thp-section.patch
maintainers-add-missing-mm_sloth-file-thp-section-fix.patch
maintainers-move-memremap-to-hotplug-section.patch
maintainers-add-missing-shrinker-files.patch
maintainers-add-missing-files-to-page-alloc-section.patch
maintainers-add-missing-zsmalloc-file.patch
maintainers-add-mm-misc-section-add-missing-files-to-misc-and-core.patch
maintainers-add-missing-file-to-cgroup-section.patch
mm-mseal-always-define-vm_sealed.patch
mm-mseal-update-madvise-logic.patch
mm-mseal-small-cleanups.patch
mm-mseal-simplify-and-rename-vma-gap-check.patch
mm-mseal-simplify-and-rename-vma-gap-check-fix.patch
mm-mseal-rework-mseal-apply-logic.patch
mm-remove-mm-io-mappingc.patch

