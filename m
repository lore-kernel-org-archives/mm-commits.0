Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19161204C07
	for <mm-commits@vger.kernel.org>; Sat,  2 Aug 2025 18:54:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754160849; cv=none; b=CN8McCqdB5y0Ns601RYW2yESihTKF+Nswp/QOfwTCRj9Goayk8UowKoQfU3G3s7sM22vovTbDfqtjowuy96HDntLkj/PyUX59jWwWWq9htgHxp/wRtyosIn5pFdsiJl9FjI8uul85e7VQhtsQ1z8JghilDUIeeBlzXg/13fX5+I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754160849; c=relaxed/simple;
	bh=PQXBzrc/23QoqHMwdlFz7uBnRyuUcKb5wu31OluwUOg=;
	h=Date:To:From:Subject:Message-Id; b=LiP1OsJlto1F6lJnrk8KiF25yG5vzi/dc9WnhsGgMnh01gBd3KSbZLuJGcZro/QFHzMZgJR4e68Cn96yrS83JA4cf2he5om6RC+uEkyOmmr8+XBcPbnSsd3Ledi5hM/GZzxoYMfZzp2ooFC0uNvDWFJnEg7FhNw2vj2S+HgAtNA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=OqY3kN8G; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="OqY3kN8G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1F2CC4CEEF;
	Sat,  2 Aug 2025 18:54:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1754160849;
	bh=PQXBzrc/23QoqHMwdlFz7uBnRyuUcKb5wu31OluwUOg=;
	h=Date:To:From:Subject:From;
	b=OqY3kN8Glk6/bANsuJK4k2n2AOf23En7qf7UN1seTFMfF3yn0RXhh7sF8n9he9EkF
	 AvRWI8qV2jFsj2Pt8bvh7zzBLyhV60G6h0TPAzry7H60OFUE2PQKfkFAo+rLw3EH+t
	 WPSDjLVsAH7SbsE+b2BwW97aJeuEgv5le+gOGis0=
Date: Sat, 02 Aug 2025 11:54:08 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,pfalcato@suse.de,Liam.Howlett@oracle.com,kees@kernel.org,jeffxu@chromium.org,jannh@google.com,david@redhat.com,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-mseal-rework-mseal-apply-logic.patch removed from -mm tree
Message-Id: <20250802185408.E1F2CC4CEEF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/mseal: rework mseal apply logic
has been removed from the -mm tree.  Its filename was
     mm-mseal-rework-mseal-apply-logic.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: mm/mseal: rework mseal apply logic
Date: Fri, 25 Jul 2025 09:29:45 +0100

The logic can be simplified - firstly by renaming the inconsistently named
apply_mm_seal() to mseal_apply().

We then wrap mseal_fixup() into the main loop as the logic is simple
enough to not require it, equally it isn't a hugely pleasant pattern in
mprotect() etc.  so it's not something we want to perpetuate.

We eliminate the need for invoking vma_iter_end() on each loop by directly
determining if the VMA was merged - the only thing we need concern
ourselves with is whether the start/end of the (gapless) range are offset
into VMAs.

This refactoring also avoids the rather horrid 'pass pointer to prev
around' pattern used in mprotect() et al.

No functional change intended.

Link: https://lkml.kernel.org/r/ddfa4376ce29f19a589d7dc8c92cb7d4f7605a4c.1753431105.git.lorenzo.stoakes@oracle.com
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reviewed-by: Pedro Falcato <pfalcato@suse.de>
Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Acked-by: David Hildenbrand <david@redhat.com>
Acked-by: Jeff Xu <jeffxu@chromium.org>
Cc: Jann Horn <jannh@google.com>
Cc: Kees Cook <kees@kernel.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mseal.c |   67 +++++++++++++++------------------------------------
 1 file changed, 20 insertions(+), 47 deletions(-)

--- a/mm/mseal.c~mm-mseal-rework-mseal-apply-logic
+++ a/mm/mseal.c
@@ -15,28 +15,6 @@
 #include <linux/sched.h>
 #include "internal.h"
 
-static int mseal_fixup(struct vma_iterator *vmi, struct vm_area_struct *vma,
-		struct vm_area_struct **prev, unsigned long start,
-		unsigned long end, vm_flags_t newflags)
-{
-	int ret = 0;
-	vm_flags_t oldflags = vma->vm_flags;
-
-	if (newflags == oldflags)
-		goto out;
-
-	vma = vma_modify_flags(vmi, *prev, vma, start, end, newflags);
-	if (IS_ERR(vma)) {
-		ret = PTR_ERR(vma);
-		goto out;
-	}
-
-	vm_flags_set(vma, VM_SEALED);
-out:
-	*prev = vma;
-	return ret;
-}
-
 /*
  * mseal() disallows an input range which contain unmapped ranges (VMA holes).
  *
@@ -74,38 +52,33 @@ static bool range_contains_unmapped(stru
 	return prev_end < end;
 }
 
-/*
- * Apply sealing.
- */
-static int apply_mm_seal(unsigned long start, unsigned long end)
+static int mseal_apply(struct mm_struct *mm,
+		unsigned long start, unsigned long end)
 {
-	unsigned long nstart;
 	struct vm_area_struct *vma, *prev;
-	VMA_ITERATOR(vmi, current->mm, start);
+	unsigned long curr_start = start;
+	VMA_ITERATOR(vmi, mm, start);
 
+	/* We know there are no gaps so this will be non-NULL. */
 	vma = vma_iter_load(&vmi);
-	/*
-	 * Note: check_mm_seal should already checked ENOMEM case.
-	 * so vma should not be null, same for the other ENOMEM cases.
-	 */
 	prev = vma_prev(&vmi);
 	if (start > vma->vm_start)
 		prev = vma;
 
-	nstart = start;
 	for_each_vma_range(vmi, vma, end) {
-		int error;
-		unsigned long tmp;
-		vm_flags_t newflags;
-
-		newflags = vma->vm_flags | VM_SEALED;
-		tmp = vma->vm_end;
-		if (tmp > end)
-			tmp = end;
-		error = mseal_fixup(&vmi, vma, &prev, nstart, tmp, newflags);
-		if (error)
-			return error;
-		nstart = vma_iter_end(&vmi);
+		unsigned long curr_end = MIN(vma->vm_end, end);
+
+		if (!(vma->vm_flags & VM_SEALED)) {
+			vma = vma_modify_flags(&vmi, prev, vma,
+					curr_start, curr_end,
+					vma->vm_flags | VM_SEALED);
+			if (IS_ERR(vma))
+				return PTR_ERR(vma);
+			vm_flags_set(vma, VM_SEALED);
+		}
+
+		prev = vma;
+		curr_start = curr_end;
 	}
 
 	return 0;
@@ -204,10 +177,10 @@ int do_mseal(unsigned long start, size_t
 	 * reaching the max supported VMAs, however, those cases shall
 	 * be rare.
 	 */
-	ret = apply_mm_seal(start, end);
+	ret = mseal_apply(mm, start, end);
 
 out:
-	mmap_write_unlock(current->mm);
+	mmap_write_unlock(mm);
 	return ret;
 }
 
_

Patches currently in -mm which might be from lorenzo.stoakes@oracle.com are


