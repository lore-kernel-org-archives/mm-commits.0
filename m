Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFF73159589
	for <mm-commits@vger.kernel.org>; Mon, 29 Jan 2024 22:23:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706567028; cv=none; b=ifhLQJRvaMVm9nk3JDJ6TeAJjfQcXhbm7DVN+ze2nbEdBp3jD9JPmAeu5cdGmbG3XtESQ78loG77xUQXEWI+qEmkPaaFPgCEjIagknoZ0BPfxm5WCCRtT9Tmp/h8qeaaYMY6ji31RmdxkQ0OlQ+qJ+NaFtNkvXuh+NhIoG1nr9I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706567028; c=relaxed/simple;
	bh=FZGnQXfYUHk5tk34pyE1UrOqrjH0RFYAh4ATNCMnpZs=;
	h=Date:To:From:Subject:Message-Id; b=ldtUfMHiZxv9AZIQ0mEwlCD+mDuqS9iSjGvlIiprosZykcKQuc5AEifbqYk39N+pt88kAbJl4U+E0cCnMwyM07/L9adhSqIBPT0Ba5TU8eYF+HKZ20R/RM8wZWSu19I11w7J0al3yzisOIQIcFd271CWWlz94+0k6wDxMhFFYws=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=j3vDWbHv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="j3vDWbHv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDFB9C433C7;
	Mon, 29 Jan 2024 22:23:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1706567027;
	bh=FZGnQXfYUHk5tk34pyE1UrOqrjH0RFYAh4ATNCMnpZs=;
	h=Date:To:From:Subject:From;
	b=j3vDWbHvyR/9LmuzN2LRO/lQKIy9gD0/nmCorucftBVzL02Dd6zMY+bAdf+hp82vF
	 h7DXKoLWXG6yYCneCbHcAARYC/6oNY1yo3U3SSME5vbF6rOIspAwCjIJ5aGtd6VVRn
	 1FSo0Q5t7iaDxipVDHELrBzOXdRijqDMjndfXTSs=
Date: Mon, 29 Jan 2024 14:23:43 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,viro@zeniv.linux.org.uk,vbabka@suse.cz,surenb@google.com,lstoakes@gmail.com,Liam.Howlett@oracle.com,brauner@kernel.org,yajun.deng@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [failures] mm-mmap-pass-vma-to-vma_merge.patch removed from -mm tree
Message-Id: <20240129222346.BDFB9C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/mmap: pass vma to vma_merge()
has been removed from the -mm tree.  Its filename was
     mm-mmap-pass-vma-to-vma_merge.patch

This patch was dropped because it had testing failures

------------------------------------------------------
From: Yajun Deng <yajun.deng@linux.dev>
Subject: mm/mmap: pass vma to vma_merge()
Date: Thu, 25 Jan 2024 11:49:21 +0800

Patch series "mm/mmap: simplify vma_merge()", v2.

The vma_merge() has too many parameters, we can pass vma to vma_merge(),
so that it can save two parameters.  Since the src vma was passed,
find_vma_intersection() can be removed.


This patch (of 2):

These vma_merge() callers will pass mm, anon_vma and file, they all from
the same vma.  There is no need to pass three parameters at the same time.

Pass vma instead of mm, anon_vma and file to vma_merge(), so that it can
save two parameters.

Link: https://lkml.kernel.org/r/20240125034922.1004671-1-yajun.deng@linux.dev
Link: https://lkml.kernel.org/r/20240125034922.1004671-2-yajun.deng@linux.dev
Signed-off-by: Yajun Deng <yajun.deng@linux.dev>
Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Lorenzo Stoakes <lstoakes@gmail.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
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
mm-mmap-remove-find_vma_intersection-in-vma_merge.patch
mm-mmap-use-sz_8m-128m-helper-macro.patch

