Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50CB31C6FE9
	for <mm-commits@vger.kernel.org>; Tue, 15 Jul 2025 23:11:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752621082; cv=none; b=fAtI6KTtN84Wxjm7vEGWzu8cGw57cz1vhNr9kl8pG5E2uIsAu+/vHpKeXxTjpiD+8nGH1y4oz36ClAKBvbueQd6744k01VPGOZzJSwOSxaJHM1MgdL8wVPwVq6t1ClRVJDK6kE347uBbdTuB9hKrTlxgAWLrTJpP9kDyeiqvKx8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752621082; c=relaxed/simple;
	bh=hcQsvJ9uAxY7h/n5OouRWjGWg8213/gbKcbO+0cqPeU=;
	h=Date:To:From:Subject:Message-Id; b=qr16pCdV6IskmB5Lpx1mVcvL1ovCvOvCc3IEZ1e8nSO+G6WHSR2Uh/pT02bZTP8xXtQFpFO+DmheBSKFRN57N0K6chnjOVN4g0eoreaDWDEmm79Owb0hvJUeIwnNemMVQoi4Stb6jR3vZ+qUkTsJcpc8E84ad7aGbojzLm8Ibqc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=J5SqaeRQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="J5SqaeRQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A979C4CEE3;
	Tue, 15 Jul 2025 23:11:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752621081;
	bh=hcQsvJ9uAxY7h/n5OouRWjGWg8213/gbKcbO+0cqPeU=;
	h=Date:To:From:Subject:From;
	b=J5SqaeRQ4TD3WMNW+4u4qRgQB3JG2PBI12U55hMgXF7uNKomqlNSOfKx7Cz5t5tNj
	 QJ+MMXGurwcpLhjRyhxa08QwaEdzRMjVy9nG1ZSI8b+/ppcBLo7B4/ov9vyPjeDtN2
	 8GHQ/gPam82fYKrB7L5iPpTda/p63puCv9c/G/Ug=
Date: Tue, 15 Jul 2025 16:11:21 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,pfalcato@suse.de,Liam.Howlett@oracle.com,jeffxu@chromium.org,jannh@google.com,david@redhat.com,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mseal-small-cleanups.patch added to mm-new branch
Message-Id: <20250715231121.8A979C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/mseal: small cleanups
has been added to the -mm mm-new branch.  Its filename is
     mm-mseal-small-cleanups.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mseal-small-cleanups.patch

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
Subject: mm/mseal: small cleanups
Date: Tue, 15 Jul 2025 14:37:40 +0100

Drop the wholly unnecessary set_vma_sealed() and vma_is_sealed() helpers
which are used only once, and place VMA_ITERATOR() declarations in the
correct place.

No functional change intended.

Link: https://lkml.kernel.org/r/7c0b2bb1f88db0c587190c2ae8bf3557f889cb3f.1752586090.git.lorenzo.stoakes@oracle.com
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Reviewed-by: Pedro Falcato <pfalcato@suse.de>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Jann Horn <jannh@google.com>
Cc: Jeff Xu <jeffxu@chromium.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mseal.c |    9 +--------
 mm/vma.h   |   16 ++--------------
 2 files changed, 3 insertions(+), 22 deletions(-)

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
--- a/mm/vma.h~mm-mseal-small-cleanups
+++ a/mm/vma.h
@@ -559,31 +559,19 @@ struct vm_area_struct *vma_iter_next_rew
 }
 
 #ifdef CONFIG_64BIT
-
-static inline bool vma_is_sealed(struct vm_area_struct *vma)
-{
-	return (vma->vm_flags & VM_SEALED);
-}
-
-/*
- * check if a vma is sealed for modification.
- * return true, if modification is allowed.
- */
+/* Check if a vma is sealed for modification. */
 static inline bool can_modify_vma(struct vm_area_struct *vma)
 {
-	if (unlikely(vma_is_sealed(vma)))
+	if (unlikely(vma->vm_flags & VM_SEALED))
 		return false;
 
 	return true;
 }
-
 #else
-
 static inline bool can_modify_vma(struct vm_area_struct *vma)
 {
 	return true;
 }
-
 #endif
 
 #if defined(CONFIG_STACK_GROWSUP)
_

Patches currently in -mm which might be from lorenzo.stoakes@oracle.com are

mm-mremap-perform-some-simple-cleanups.patch
mm-mremap-refactor-initial-parameter-sanity-checks.patch
mm-mremap-put-vma-check-and-prep-logic-into-helper-function.patch
mm-mremap-cleanup-post-processing-stage-of-mremap.patch
mm-mremap-use-an-explicit-uffd-failure-path-for-mremap.patch
mm-mremap-check-remap-conditions-earlier.patch
mm-mremap-move-remap_is_valid-into-check_prep_vma.patch
mm-mremap-clean-up-mlock-populate-behaviour.patch
mm-mremap-permit-mremap-move-of-multiple-vmas.patch
mm-mremap-permit-mremap-move-of-multiple-vmas-fix.patch
tools-testing-selftests-extend-mremap_test-to-test-multi-vma-mremap.patch
mm-vma-refactor-vma_modify_flags_name-to-vma_modify_name.patch
mm-vma-refactor-vma_modify_flags_name-to-vma_modify_name-fix.patch
mm-mseal-always-define-vm_sealed.patch
mm-mseal-update-madvise-logic.patch
mm-mseal-small-cleanups.patch
mm-mseal-simplify-and-rename-vma-gap-check.patch
mm-mseal-rework-mseal-apply-logic.patch

