Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 362B723C6EA
	for <mm-commits@vger.kernel.org>; Tue, 14 Jan 2025 06:43:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736837026; cv=none; b=YiPhmfc6iHbRDF1c+IlCpnBlWVMDCxdonN/0QV2IPHk6mRXRct87f62x0CWaeIe4faWl1ACY86D6l568kA6D07PbuWNvyTLB/ELWC5Obas4deG7VlBbwrzNLtK2q2VGlQyfOW1Wbvq0cpPkPF7Tnc7MdXcqUXwfQUvtK/gzBvMc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736837026; c=relaxed/simple;
	bh=sQlN60DEzHS1voBkLrsS9y900vXqyvuxFwtugOMo4UU=;
	h=Date:To:From:Subject:Message-Id; b=OyWTg4HxZG6ikNQxwQ6txlEbtJNgrcuShI+paduZwAJvOFC6J3VFBDica16Bxk17/rAVky7iUxEGviylmPPa+vIedgWhTykQW5SQ7LEji1f+cRPvxMQ2PTZRuikWCMNzOD3N0KQ6Cm4C9X9VKGEPhZC91cJJm0eEv3828yiaR7M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=f6+XB9+h; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="f6+XB9+h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2967C4CEDD;
	Tue, 14 Jan 2025 06:43:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736837025;
	bh=sQlN60DEzHS1voBkLrsS9y900vXqyvuxFwtugOMo4UU=;
	h=Date:To:From:Subject:From;
	b=f6+XB9+h7NZpQboJZw5crE4X8HFeuAnMK5x9kJsNx+DYI6msPWPbbDvyDyX+4IM0q
	 f0DXsuPftvG3eQWT6XJE/eZM/pCCWgbdlEoWc9ZS6UgMpLDwmc3pB7vWYCfXxqrrJA
	 DIxGfuFq//VAU5jtX4NatxD7nUQgd+b0VK6pvG54=
Date: Mon, 13 Jan 2025 22:43:45 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,Liam.Howlett@Oracle.com,jannh@google.com,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-enforce-__must_check-on-vma-merge-and-split.patch removed from -mm tree
Message-Id: <20250114064345.C2967C4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: enforce __must_check on VMA merge and split
has been removed from the -mm tree.  Its filename was
     mm-enforce-__must_check-on-vma-merge-and-split.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Reviewed-by: Liam R. Howlett <Liam.Howlett@Oracle.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Jann Horn <jannh@google.com>
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
@@ -174,13 +175,14 @@ void unmap_region(struct ma_state *mas,
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
@@ -190,7 +192,7 @@ struct vm_area_struct
 		       struct anon_vma_name *new_name);
 
 /* We are about to modify the VMA's memory policy. */
-struct vm_area_struct
+__must_check struct vm_area_struct
 *vma_modify_policy(struct vma_iterator *vmi,
 		   struct vm_area_struct *prev,
 		   struct vm_area_struct *vma,
@@ -198,7 +200,7 @@ struct vm_area_struct
 		   struct mempolicy *new_pol);
 
 /* We are about to modify the VMA's flags and/or uffd context. */
-struct vm_area_struct
+__must_check struct vm_area_struct
 *vma_modify_flags_uffd(struct vma_iterator *vmi,
 		       struct vm_area_struct *prev,
 		       struct vm_area_struct *vma,
@@ -206,11 +208,13 @@ struct vm_area_struct
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

mips-vdso-prefer-do_mmap-to-mmap_region.patch
mm-make-mmap_region-internal.patch

