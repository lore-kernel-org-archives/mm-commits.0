Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39F352E822
	for <mm-commits@vger.kernel.org>; Sat,  7 Dec 2024 04:35:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733546159; cv=none; b=E4WGQD7liBeYKx98g/G3t+iVtpNzRkebdAAg9jk2WriPnplQgU0vcZJxEXbm+VN10QQIhv19GBIihu+hd5e4wOX7vbnSx0OqzEhJccU49sn3oxT8G/u+WnVuH3MwiueJI8iK9lOYx8cGuULKAMenSK6drXLoAgWlXdXacPU6kGU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733546159; c=relaxed/simple;
	bh=A9Cap1X2I5oYtigXxj32U4Ky5VV5+hByMhYlvM4R/c8=;
	h=Date:To:From:Subject:Message-Id; b=ipggGYu9MbHyTeYZP8kiyRy74XD474fEQg4pbcls25AXkFZVZ5XGsgCNrDa+aQi3mrONe6nlCIB5c8i9DS6Lj5OkS7X8ao3OQi7DdKgooBIUmZABgTzH5DgJ5g6OpskK78yNoyyV7iTxAFsVF6NpbV6siMHcuezzbNP4yvZHb1Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=EuDC3X2z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="EuDC3X2z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B975CC4CECD;
	Sat,  7 Dec 2024 04:35:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1733546158;
	bh=A9Cap1X2I5oYtigXxj32U4Ky5VV5+hByMhYlvM4R/c8=;
	h=Date:To:From:Subject:From;
	b=EuDC3X2zbB9FCmQeYPm0zRk0LnfvyYv7U+7Rrzza+joXabrs77e0FDSqQ56rFhpBb
	 GeGvl5UDEhyS2e9+yAQ+JDjKJvJZSNLN2R8je+gt4g4LR85NY/q6/HwfJrQ/BGTKXQ
	 TigHLYJU81PDzkJGSfZ81Hth0BX8YQxhuBTMiQ6Y=
Date: Fri, 06 Dec 2024 20:35:58 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,Liam.Howlett@Oracle.com,jannh@google.com,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-enforce-__must_check-on-vma-merge-and-split.patch added to mm-unstable branch
Message-Id: <20241207043558.B975CC4CECD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: enforce __must_check on VMA merge and split
has been added to the -mm mm-unstable branch.  Its filename is
     mm-enforce-__must_check-on-vma-merge-and-split.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-enforce-__must_check-on-vma-merge-and-split.patch

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
Subject: mm: enforce __must_check on VMA merge and split
Date: Fri, 6 Dec 2024 22:50:36 +0000

It is of critical importance to check the return results on VMA merge (and
split), failure to do so can result in use-after-free's.  This bug has
recurred, so have the compiler enforce this check to prevent any future
repetition.

Link: https://lkml.kernel.org/r/20241206225036.273103-1-lorenzo.stoakes@oracle.com
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Jann Horn <jannh@google.com>
Cc: Liam R. Howlett <Liam.Howlett@Oracle.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vma.c |    8 +++++---
 mm/vma.h |   26 +++++++++++++++-----------
 2 files changed, 20 insertions(+), 14 deletions(-)

--- a/mm/vma.c~mm-enforce-__must_check-on-vma-merge-and-split
+++ a/mm/vma.c
@@ -447,8 +447,9 @@ void unmap_region(struct ma_state *mas,
  * has already been checked or doesn't make sense to fail.
  * VMA Iterator will point to the original VMA.
  */
-static int __split_vma(struct vma_iterator *vmi, struct vm_area_struct *vma,
-		       unsigned long addr, int new_below)
+static __must_check int
+__split_vma(struct vma_iterator *vmi, struct vm_area_struct *vma,
+	    unsigned long addr, int new_below)
 {
 	struct vma_prepare vp;
 	struct vm_area_struct *new;
@@ -710,7 +711,8 @@ static bool can_merge_remove_vma(struct
  * - The caller must hold a WRITE lock on the mm_struct->mmap_lock.
  * - vmi must be positioned within [@vmg->vma->vm_start, @vmg->vma->vm_end).
  */
-static struct vm_area_struct *vma_merge_existing_range(struct vma_merge_struct *vmg)
+static __must_check struct vm_area_struct *vma_merge_existing_range(
+		struct vma_merge_struct *vmg)
 {
 	struct vm_area_struct *vma = vmg->vma;
 	struct vm_area_struct *prev = vmg->prev;
--- a/mm/vma.h~mm-enforce-__must_check-on-vma-merge-and-split
+++ a/mm/vma.h
@@ -139,9 +139,10 @@ void validate_mm(struct mm_struct *mm);
 #define validate_mm(mm) do { } while (0)
 #endif
 
-int vma_expand(struct vma_merge_struct *vmg);
-int vma_shrink(struct vma_iterator *vmi, struct vm_area_struct *vma,
-	       unsigned long start, unsigned long end, pgoff_t pgoff);
+__must_check int vma_expand(struct vma_merge_struct *vmg);
+__must_check int vma_shrink(struct vma_iterator *vmi,
+		struct vm_area_struct *vma,
+		unsigned long start, unsigned long end, pgoff_t pgoff);
 
 static inline int vma_iter_store_gfp(struct vma_iterator *vmi,
 			struct vm_area_struct *vma, gfp_t gfp)
@@ -175,13 +176,14 @@ void unmap_region(struct ma_state *mas,
 		struct vm_area_struct *prev, struct vm_area_struct *next);
 
 /* We are about to modify the VMA's flags. */
-struct vm_area_struct *vma_modify_flags(struct vma_iterator *vmi,
+__must_check struct vm_area_struct
+*vma_modify_flags(struct vma_iterator *vmi,
 		struct vm_area_struct *prev, struct vm_area_struct *vma,
 		unsigned long start, unsigned long end,
 		unsigned long new_flags);
 
 /* We are about to modify the VMA's flags and/or anon_name. */
-struct vm_area_struct
+__must_check struct vm_area_struct
 *vma_modify_flags_name(struct vma_iterator *vmi,
 		       struct vm_area_struct *prev,
 		       struct vm_area_struct *vma,
@@ -191,7 +193,7 @@ struct vm_area_struct
 		       struct anon_vma_name *new_name);
 
 /* We are about to modify the VMA's memory policy. */
-struct vm_area_struct
+__must_check struct vm_area_struct
 *vma_modify_policy(struct vma_iterator *vmi,
 		   struct vm_area_struct *prev,
 		   struct vm_area_struct *vma,
@@ -199,7 +201,7 @@ struct vm_area_struct
 		   struct mempolicy *new_pol);
 
 /* We are about to modify the VMA's flags and/or uffd context. */
-struct vm_area_struct
+__must_check struct vm_area_struct
 *vma_modify_flags_uffd(struct vma_iterator *vmi,
 		       struct vm_area_struct *prev,
 		       struct vm_area_struct *vma,
@@ -207,11 +209,13 @@ struct vm_area_struct
 		       unsigned long new_flags,
 		       struct vm_userfaultfd_ctx new_ctx);
 
-struct vm_area_struct *vma_merge_new_range(struct vma_merge_struct *vmg);
+__must_check struct vm_area_struct
+*vma_merge_new_range(struct vma_merge_struct *vmg);
 
-struct vm_area_struct *vma_merge_extend(struct vma_iterator *vmi,
-					struct vm_area_struct *vma,
-					unsigned long delta);
+__must_check struct vm_area_struct
+*vma_merge_extend(struct vma_iterator *vmi,
+		  struct vm_area_struct *vma,
+		  unsigned long delta);
 
 void unlink_file_vma_batch_init(struct unlink_vma_file_batch *vb);
 
_

Patches currently in -mm which might be from lorenzo.stoakes@oracle.com are

docs-mm-add-vma-locks-documentation.patch
mm-reinstate-ability-to-map-write-sealed-memfd-mappings-read-only.patch
selftests-memfd-add-test-for-mapping-write-sealed-memfd-read-only.patch
mm-correctly-reference-merged-vma.patch
mm-vma-move-brk-internals-to-mm-vmac.patch
mm-vma-move-brk-internals-to-mm-vmac-fix.patch
mm-vma-move-unmapped_area-internals-to-mm-vmac.patch
mm-abstract-get_arg_page-stack-expansion-and-mmap-read-lock.patch
mm-vma-move-stack-expansion-logic-to-mm-vmac.patch
mm-vma-move-__vm_munmap-to-mm-vmac.patch
selftests-mm-add-fork-cow-guard-page-test.patch
mm-enforce-__must_check-on-vma-merge-and-split.patch

