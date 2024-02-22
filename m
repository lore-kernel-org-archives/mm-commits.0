Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9938111B2
	for <mm-commits@vger.kernel.org>; Thu, 22 Feb 2024 00:03:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708560182; cv=none; b=MQsj2qYVoeUSBQ2X0j+TZpZujhIR3STa4hQIMUDnNWcre3p0kPwpTrNxR5iWHhHaFK5WH7aUqWm5Ylq94Z6gE6sP3bvNgFxxJqQJoHpbNiJDeX5JMMEJg/wQX/M+ao+G4o6JYO2NNaxJHlX8gF/ZdidwDhxbBjZwmqqeaOyv59U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708560182; c=relaxed/simple;
	bh=fAglSGoqYl1phewENBAQZ9Mc+9vzoSJlHT8cdgbnf2Y=;
	h=Date:To:From:Subject:Message-Id; b=r0pH/du9tav2HrjOE5lbLAgLW7v7tLQKkLj3C6e+5xYjG0FOHSlnQNkvARvPxNHblxGmNazVqm1tgAf7NksRoNWSBkdnVGILDSCLBAL+C+XdKkbPEajrmyGW2d2UUx0XHb8P+80CU9tnm+9zlN81aQsMSqYQFhpI37lNowQWx7A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=HSK5KEJz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="HSK5KEJz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0742C43390;
	Thu, 22 Feb 2024 00:03:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708560181;
	bh=fAglSGoqYl1phewENBAQZ9Mc+9vzoSJlHT8cdgbnf2Y=;
	h=Date:To:From:Subject:From;
	b=HSK5KEJzmmQqAdxfyWVfAcuUQqI5hJRJ8vdW24s84GEZ+RTcUK6xrkwicSsZwILGy
	 Da3PO0AZOfdvgHPuuk93t9OgMoQqFYwErgr6nDK6LV29LMlWZr5zyG2xfwKEQxe2UI
	 T9/Yj6679PD0tcWMaIEzYZ1QIDdHBRfpjEMbUv1A=
Date: Wed, 21 Feb 2024 16:03:01 -0800
To: mm-commits@vger.kernel.org,Liam.Howlett@oracle.com,yajun.deng@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-mmap-pass-vma-to-vma_merge.patch removed from -mm tree
Message-Id: <20240222000301.C0742C43390@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/mmap: pass vma to vma_merge()
has been removed from the -mm tree.  Its filename was
     mm-mmap-pass-vma-to-vma_merge.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


