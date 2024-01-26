Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC90E524F
	for <mm-commits@vger.kernel.org>; Fri, 26 Jan 2024 02:16:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706235376; cv=none; b=heHGPk+NRvZoW1iJCO3H+popsSuOe8pmhmVUxUb/tTM85fmubBxNjhgQdP8s7ZFHM1yo+Ne7CaPfBcqwBAakg0IUv0jhnz3moJX72frqt4pS935d4DtXQo1zCSwbZBDwq/50es4OFCZcn6/u4uL7brCs055qqfC5Kj0wQpJGCPI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706235376; c=relaxed/simple;
	bh=sKBP+rxz/jtKqvMy3faKiLJZNz32NEu+8O9CkbugTk8=;
	h=Date:To:From:Subject:Message-Id; b=U+fiPin9KeDqbFyL6T7lcyr95DyxkyhAd0c8W9+8zC7lY+yMr87HLeTZG2MHCmmdD3Lxd6RhTMWNBKaIYuLPWoH0IQ8KokUPPyRsiKNuVledggmcao+f0w9JbiP1vQumbPBuuTE1jCxbSTvdbbzEBaJ8hEBIT8roqdJzNYxe8ek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=g/k1zVFE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="g/k1zVFE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BEE8C43390;
	Fri, 26 Jan 2024 02:16:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1706235376;
	bh=sKBP+rxz/jtKqvMy3faKiLJZNz32NEu+8O9CkbugTk8=;
	h=Date:To:From:Subject:From;
	b=g/k1zVFEETpearoJ2RpApnar/8Ne5e/1rK2gtbHOf+xy/Zw4xNlBy+0LMrvGvG0g7
	 AEtjcpbArkyStQtbi3S7SQUKJvedtFt1Us+17Z5smOPNVwjsRVSAkjCUk4rXy3lmMg
	 sJQfGERM8cEEAMCTEmHGqUMMjx0qRSM+SNCZsmZs=
Date: Thu, 25 Jan 2024 18:16:13 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,viro@zeniv.linux.org.uk,vbabka@suse.cz,surenb@google.com,lstoakes@gmail.com,Liam.Howlett@oracle.com,brauner@kernel.org,yajun.deng@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mmap-pass-vma-to-vma_merge.patch added to mm-unstable branch
Message-Id: <20240126021616.3BEE8C43390@smtp.kernel.org>
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
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
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
mm-mmap-pass-vma-to-vma_merge.patch
mm-mmap-remove-find_vma_intersection-in-vma_merge.patch

