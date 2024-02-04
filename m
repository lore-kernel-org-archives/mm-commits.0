Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8957879EE
	for <mm-commits@vger.kernel.org>; Sun,  4 Feb 2024 07:20:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707031234; cv=none; b=eixE7ZOQ/nFouh5vSW8Dd5aRHX89U0CX7AShIWtfSTgFuS8GIZwrdui9J44ey/Tz4kLOnArznIhSAObui9Ah0Q42BdwZrs2NuVg0eB3pGJoNX3nJ8CUZaHsXKLz/iP0kIDmT1b7nQQIfcfIx+598xFdWryVR4e28tEMDvqA4DsE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707031234; c=relaxed/simple;
	bh=U+k/LqkgOq4ZcouLnYXRK8/ji0p/g1kipRpENU9tQUw=;
	h=Date:To:From:Subject:Message-Id; b=koC/40soQ9kjyVDYhQFVk3sjBzzXmWiJrYFYNHfDsFtetDNESvPe7newSFF04oiD7ByOzicSTxXRjODsJhTORPAkNxcqk/RQr7FRUovniPqVX0ZQMZ7wLSbdr5jM8QPFq6qgMQduFpHrzIdnoCksjO8NYAr23Ip97gHYHW51erw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=W9Vn7OSX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="W9Vn7OSX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E43AC43390;
	Sun,  4 Feb 2024 07:20:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1707031234;
	bh=U+k/LqkgOq4ZcouLnYXRK8/ji0p/g1kipRpENU9tQUw=;
	h=Date:To:From:Subject:From;
	b=W9Vn7OSXhN8oIvgyKIUJuzEGkaezStPIO8h60AO6z/dGwUoW+OPa76Cifk9wNGnyq
	 CSZRk0XA8afubcLetbOiU9FxenX5tASz9cV3ZdpeDWerfWnq3vhzmtWxlI1oyHVqWj
	 iAVvSQQ4khVyOMxC0OpdHIvG2hgWJmAkG9fc8wSI=
Date: Sat, 03 Feb 2024 23:20:33 -0800
To: mm-commits@vger.kernel.org,Liam.Howlett@oracle.com,yajun.deng@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mmap-pass-vma-to-vma_merge.patch added to mm-unstable branch
Message-Id: <20240204072034.3E43AC43390@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/mmap: pass vma to vma_merge()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-mmap-pass-vma-to-vma_merge.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mmap-pass-vma-to-vma_merge.patch

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
From: Yajun Deng <yajun.deng@linux.dev>
Subject: mm/mmap: pass vma to vma_merge()
Date: Sat, 3 Feb 2024 09:46:32 +0800

These vma_merge() callers will pass mm, anon_vma and file, they all from
the same vma.  There is no need to pass three parameters at the same time.

Pass vma instead of mm, anon_vma and file to vma_merge(), so that it can
save two parameters.

Link: https://lkml.kernel.org/r/20240203014632.2726545-1-yajun.deng@linux.dev
Link: https://lore.kernel.org/lkml/20240125034922.1004671-2-yajun.deng@linux.dev/
Signed-off-by: Yajun Deng <yajun.deng@linux.dev>
Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Yajun Deng <yajun.deng@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |   27 +++++++++++++--------------
 1 file changed, 13 insertions(+), 14 deletions(-)

--- a/mm/mmap.c~mm-mmap-pass-vma-to-vma_merge
+++ a/mm/mmap.c
@@ -860,13 +860,15 @@ can_vma_merge_after(struct vm_area_struc
  *      area is returned, or the function will return NULL
  */
 static struct vm_area_struct
-*vma_merge(struct vma_iterator *vmi, struct mm_struct *mm,
-	   struct vm_area_struct *prev, unsigned long addr, unsigned long end,
-	   unsigned long vm_flags, struct anon_vma *anon_vma, struct file *file,
-	   pgoff_t pgoff, struct mempolicy *policy,
+*vma_merge(struct vma_iterator *vmi, struct vm_area_struct *prev,
+	   struct vm_area_struct *src, unsigned long addr, unsigned long end,
+	   unsigned long vm_flags, pgoff_t pgoff, struct mempolicy *policy,
 	   struct vm_userfaultfd_ctx vm_userfaultfd_ctx,
 	   struct anon_vma_name *anon_name)
 {
+	struct mm_struct *mm = src->vm_mm;
+	struct anon_vma *anon_vma = src->anon_vma;
+	struct file *file = src->vm_file;
 	struct vm_area_struct *curr, *next, *res;
 	struct vm_area_struct *vma, *adjust, *remove, *remove2;
 	struct vm_area_struct *anon_dup = NULL;
@@ -2426,9 +2428,8 @@ struct vm_area_struct *vma_modify(struct
 	pgoff_t pgoff = vma->vm_pgoff + ((start - vma->vm_start) >> PAGE_SHIFT);
 	struct vm_area_struct *merged;
 
-	merged = vma_merge(vmi, vma->vm_mm, prev, start, end, vm_flags,
-			   vma->anon_vma, vma->vm_file, pgoff, policy,
-			   uffd_ctx, anon_name);
+	merged = vma_merge(vmi, prev, vma, start, end, vm_flags,
+			   pgoff, policy, uffd_ctx, anon_name);
 	if (merged)
 		return merged;
 
@@ -2458,9 +2459,8 @@ static struct vm_area_struct
 		   struct vm_area_struct *vma, unsigned long start,
 		   unsigned long end, pgoff_t pgoff)
 {
-	return vma_merge(vmi, vma->vm_mm, prev, start, end, vma->vm_flags,
-			 vma->anon_vma, vma->vm_file, pgoff, vma_policy(vma),
-			 vma->vm_userfaultfd_ctx, anon_vma_name(vma));
+	return vma_merge(vmi, prev, vma, start, end, vma->vm_flags, pgoff,
+			 vma_policy(vma), vma->vm_userfaultfd_ctx, anon_vma_name(vma));
 }
 
 /*
@@ -2474,10 +2474,9 @@ struct vm_area_struct *vma_merge_extend(
 	pgoff_t pgoff = vma->vm_pgoff + vma_pages(vma);
 
 	/* vma is specified as prev, so case 1 or 2 will apply. */
-	return vma_merge(vmi, vma->vm_mm, vma, vma->vm_end, vma->vm_end + delta,
-			 vma->vm_flags, vma->anon_vma, vma->vm_file, pgoff,
-			 vma_policy(vma), vma->vm_userfaultfd_ctx,
-			 anon_vma_name(vma));
+	return vma_merge(vmi, vma, vma, vma->vm_end, vma->vm_end + delta,
+			 vma->vm_flags, pgoff, vma_policy(vma),
+			 vma->vm_userfaultfd_ctx, anon_vma_name(vma));
 }
 
 /*
_

Patches currently in -mm which might be from yajun.deng@linux.dev are

mm-mmap-simplify-vma-link-and-unlink.patch
mm-mmap-introduce-vma_set_range.patch
mm-mmap-use-sz_8k-128k-helper-macro.patch
mm-mmap-pass-vma-to-vma_merge.patch

