Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 472BB2ECD34
	for <mm-commits@vger.kernel.org>; Fri,  6 Mar 2026 22:22:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772835764; cv=none; b=SoyDf8sPL+PcYwajHEPDGoRQdY4vbPdaxSIfXiCTipRMx+0U5LlCatt34BVZKnyI911mE9xfLXpBbFwUjTPGyrwFOLmDJqmOuS0hwUXzz6R83B5NVKuezG2zY7c4d2/jH+neuGd7cVGyeIr76U8+4R81BBliUtTo0WnjX2svYHY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772835764; c=relaxed/simple;
	bh=oe3/aeAd7mquiuOKMF0bLOHddwjxQm+NHqlBCk4pXSA=;
	h=Date:To:From:Subject:Message-Id; b=tA+5htdHACyxYFCGBQT6wYXNaYOagmLB77oPnpyPndkggZVxCl6zSr/dMSzXZzbxltJW+N7OLN+5oD2FhDB+cJEeJOuJkabnY4xcyH1uknmoxlZW8ysO3aBOzczX+KZDoEUbbnZvl/oYzQuAzQo30w8k1Y8h6kqT1LNpO+U2lRI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Vr3xSjrK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Vr3xSjrK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2C9BC4CEF7;
	Fri,  6 Mar 2026 22:22:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1772835763;
	bh=oe3/aeAd7mquiuOKMF0bLOHddwjxQm+NHqlBCk4pXSA=;
	h=Date:To:From:Subject:From;
	b=Vr3xSjrKZtvzh8Lvlw7HyG0Tg/jOOo12AHWLQhBD6AIF4fyhQ43yT2EFie9kMi0MI
	 PDJ2jpWvm32pY+AxUbtGAAsG6Io9eW7QWeZHM+JWwyFt5+2DCr7Jox/Yelhl6/Pv2u
	 gIKfqRvBU0fyUyIXO4elf2HrVXBDtkuEWBsiaZg8=
Date: Fri, 06 Mar 2026 14:22:43 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,surenb@google.com,rppt@kernel.org,pfalcato@suse.de,mhocko@suse.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,jason@zx2c4.com,jannh@google.com,david@kernel.org,anthony.yznaga@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-prevent-droppable-mappings-from-being-locked.patch added to mm-new branch
Message-Id: <20260306222243.C2C9BC4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: prevent droppable mappings from being locked
has been added to the -mm mm-new branch.  Its filename is
     mm-prevent-droppable-mappings-from-being-locked.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-prevent-droppable-mappings-from-being-locked.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

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
From: Anthony Yznaga <anthony.yznaga@oracle.com>
Subject: mm: prevent droppable mappings from being locked
Date: Fri, 6 Mar 2026 12:45:50 -0800

Mappings created with MAP_DROPPABLE cannot be locked via mlock() due to
the check in mlock_fixup().  However, they will be locked indirectly if
they are created after mlockall(MCL_FUTURE).

Link: https://lkml.kernel.org/r/20260306204550.8405-1-anthony.yznaga@oracle.com
Fixes: 9651fcedf7b9 ("mm: add MAP_DROPPABLE for designating always lazily freeable mappings")
Signed-off-by: Anthony Yznaga <anthony.yznaga@oracle.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Jann Horn <jannh@google.com>
Cc: Jason A. Donenfeld <jason@zx2c4.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    3 +++
 mm/mlock.c         |    4 ++--
 mm/vma.c           |    2 +-
 3 files changed, 6 insertions(+), 3 deletions(-)

--- a/include/linux/mm.h~mm-prevent-droppable-mappings-from-being-locked
+++ a/include/linux/mm.h
@@ -573,6 +573,9 @@ enum {
 /* This mask represents all the VMA flag bits used by mlock */
 #define VM_LOCKED_MASK	(VM_LOCKED | VM_LOCKONFAULT)
 
+/* This mask prevents VMAs from being mlock'd */
+#define VM_NO_MLOCK_MASK	(VM_SPECIAL | VM_DROPPABLE)
+
 /* These flags can be updated atomically via VMA/mmap read lock. */
 #define VM_ATOMIC_SET_ALLOWED VM_MAYBE_GUARD
 
--- a/mm/mlock.c~mm-prevent-droppable-mappings-from-being-locked
+++ a/mm/mlock.c
@@ -472,9 +472,9 @@ static int mlock_fixup(struct vma_iterat
 	int ret = 0;
 	vm_flags_t oldflags = vma->vm_flags;
 
-	if (newflags == oldflags || (oldflags & VM_SPECIAL) ||
+	if (newflags == oldflags || (oldflags & VM_NO_MLOCK_MASK) ||
 	    is_vm_hugetlb_page(vma) || vma == get_gate_vma(current->mm) ||
-	    vma_is_dax(vma) || vma_is_secretmem(vma) || (oldflags & VM_DROPPABLE))
+	    vma_is_dax(vma) || vma_is_secretmem(vma))
 		/* don't set VM_LOCKED or VM_LOCKONFAULT and don't count */
 		goto out;
 
--- a/mm/vma.c~mm-prevent-droppable-mappings-from-being-locked
+++ a/mm/vma.c
@@ -2589,7 +2589,7 @@ static void __mmap_complete(struct mmap_
 
 	vm_stat_account(mm, vma->vm_flags, map->pglen);
 	if (vm_flags & VM_LOCKED) {
-		if ((vm_flags & VM_SPECIAL) || vma_is_dax(vma) ||
+		if ((vm_flags & VM_NO_MLOCK_MASK) || vma_is_dax(vma) ||
 					is_vm_hugetlb_page(vma) ||
 					vma == get_gate_vma(mm))
 			vm_flags_clear(vma, VM_LOCKED_MASK);
_

Patches currently in -mm which might be from anthony.yznaga@oracle.com are

mm-prevent-droppable-mappings-from-being-locked.patch

