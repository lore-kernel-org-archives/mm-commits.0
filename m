Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F2281E7C1C
	for <mm-commits@vger.kernel.org>; Sat,  2 Aug 2025 18:54:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754160846; cv=none; b=HhIkxDtvknw/B/t6gQQpr3o6LUC7aYc+j83X66Rmsm/Y8+Ub3RgxcyOo3NVaPMxnzZfk20Ea7kPKcrf4W13VsFSqs6PbGCqtj6BRT0q++0sCEE+EPOvBpAKtNKJAs/ujanGH7LSQplIQOiyKfjdpmWIFzm+D9Nbi0AmDmcuVa94=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754160846; c=relaxed/simple;
	bh=ys7ZqZov5qYpOj3Jo7bJLclw2PiK9MV84M3EUAxLpZE=;
	h=Date:To:From:Subject:Message-Id; b=bYjVL3iX6dCBVoqjFXXJwO/qMfxmC1xXlwZjMKsLAInZrmRWB9EiLR/ugO9cNBOdB8lTgkCJXo/WZVgvHWnzSxHFkwg4Q8jt9GfGeK1klySxJU55ndmNALaOvvIlg7lsDwBvZF/Cx41oDDXbJ3lPPWBoV3UA4oBY3rs714Zau8E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=EkxOjr1+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="EkxOjr1+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D70B7C4CEEF;
	Sat,  2 Aug 2025 18:54:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1754160845;
	bh=ys7ZqZov5qYpOj3Jo7bJLclw2PiK9MV84M3EUAxLpZE=;
	h=Date:To:From:Subject:From;
	b=EkxOjr1+8pDGrE0oNkkLXyji7nNu7v8ih5w+Wpz8nTUQtt808o0uH63NwZPicCxOw
	 X4CVkyAkvoDmJdtyupWb2/7eetvWCgp8uUGNQ62R/1IuJDhIBpxyeFveHecDGG5yYz
	 IlMiJ6H1Fcs2+KPIdnd+2pDZ9tvGlas2wXFuEKQU=
Date: Sat, 02 Aug 2025 11:54:05 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,pfalcato@suse.de,Liam.Howlett@oracle.com,kees@kernel.org,jeffxu@chromium.org,jannh@google.com,david@redhat.com,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-mseal-small-cleanups.patch removed from -mm tree
Message-Id: <20250802185405.D70B7C4CEEF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/mseal: small cleanups
has been removed from the -mm tree.  Its filename was
     mm-mseal-small-cleanups.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


