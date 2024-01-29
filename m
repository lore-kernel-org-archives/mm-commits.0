Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CF41158D7F
	for <mm-commits@vger.kernel.org>; Mon, 29 Jan 2024 22:23:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706567032; cv=none; b=plsmkF65nG2lVPqxsqSZvaLRbzop5kJsH09ibn6yR4qixJxRriA1epOo5u5YrxPtueYRYY64sUAyIGTIP8T60MbaTpIcFa74A503FOT3LBR+muslwmkE3rMv298mZTzGHU2CYzsYxmh2CA/qkevehuugfk2K3g5W+eEqHruItNg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706567032; c=relaxed/simple;
	bh=mIluKo6FjH0bNT4Qk4UP/IvFA6QjDFhAKX7lagllXUM=;
	h=Date:To:From:Subject:Message-Id; b=mrn0B27bZ8pN504FMiMsd+lqlTVLCQ3yYk/+UsoQ4pOvTSNggY2czpXgxwYJZ+x733+jtgzbSdX9vTFBm2QSRojXNyEXYOdT5h0uuDKwY8pN61B/0ZIeJt4T5YtLK3QUxj8hEEE0uc2ICwoO4gN/dUJ+2epBvqjeZ9wZBgiAFao=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=SIczMxwE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="SIczMxwE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4D11C433C7;
	Mon, 29 Jan 2024 22:23:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1706567031;
	bh=mIluKo6FjH0bNT4Qk4UP/IvFA6QjDFhAKX7lagllXUM=;
	h=Date:To:From:Subject:From;
	b=SIczMxwEJ1JynrSrfi6CUElNrepJqFPQOW500E+CTCZ4FJZcD32w34gknLaRTrExp
	 r1GQ4GLRyVhGZr7vNdxsdT5oTMySCZ84SrFgSwvK+5lkBdzAWyU7hCMKNRbZdHzkgd
	 DDqwkscXasvi6qA++OOfymdOK+VeQRX9om6RTGO4=
Date: Mon, 29 Jan 2024 14:23:48 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,viro@zeniv.linux.org.uk,vbabka@suse.cz,surenb@google.com,lstoakes@gmail.com,Liam.Howlett@oracle.com,brauner@kernel.org,yajun.deng@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [failures] mm-mmap-remove-find_vma_intersection-in-vma_merge.patch removed from -mm tree
Message-Id: <20240129222350.E4D11C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/mmap: remove find_vma_intersection() in vma_merge()
has been removed from the -mm tree.  Its filename was
     mm-mmap-remove-find_vma_intersection-in-vma_merge.patch

This patch was dropped because it had testing failures

------------------------------------------------------
From: Yajun Deng <yajun.deng@linux.dev>
Subject: mm/mmap: remove find_vma_intersection() in vma_merge()
Date: Thu, 25 Jan 2024 11:49:22 +0800

We need to find the current vma by find_vma_intersection() in vma_merge().
Since the src vma was passed, we can add a check to figure out if the
current vma is NULL or the src vma directly.

Remove find_vma_intersection() in vma_merge().  And initialize the next to
NULL when defining it.

Link: https://lkml.kernel.org/r/20240125034922.1004671-3-yajun.deng@linux.dev
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

 mm/mmap.c |   15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

--- a/mm/mmap.c~mm-mmap-remove-find_vma_intersection-in-vma_merge
+++ a/mm/mmap.c
@@ -869,7 +869,7 @@ static struct vm_area_struct
 	struct mm_struct *mm = src->vm_mm;
 	struct anon_vma *anon_vma = src->anon_vma;
 	struct file *file = src->vm_file;
-	struct vm_area_struct *curr, *next, *res;
+	struct vm_area_struct *curr = src, *next = NULL, *res;
 	struct vm_area_struct *vma, *adjust, *remove, *remove2;
 	struct vm_area_struct *anon_dup = NULL;
 	struct vma_prepare vp;
@@ -890,14 +890,18 @@ static struct vm_area_struct
 	if (vm_flags & VM_SPECIAL)
 		return NULL;
 
-	/* Does the input range span an existing VMA? (cases 5 - 8) */
-	curr = find_vma_intersection(mm, prev ? prev->vm_end : 0, end);
+	/*
+	 * If the current vma and the prev vma are the same vma, it
+	 * means the current vma is NULL.
+	 * Does the input range span an existing VMA? (cases 5 - 8)
+	 */
+	if (prev == curr || addr != curr->vm_start || end > curr->vm_end)
+		curr = NULL;
 
 	if (!curr ||			/* cases 1 - 4 */
 	    end == curr->vm_end)	/* cases 6 - 8, adjacent VMA */
 		next = vma_lookup(mm, end);
-	else
-		next = NULL;		/* case 5 */
+					/* case 5 set to NULL above */
 
 	if (prev) {
 		vma_start = prev->vm_start;
@@ -921,7 +925,6 @@ static struct vm_area_struct
 
 	/* Verify some invariant that must be enforced by the caller. */
 	VM_WARN_ON(prev && addr <= prev->vm_start);
-	VM_WARN_ON(curr && (addr != curr->vm_start || end > curr->vm_end));
 	VM_WARN_ON(addr >= end);
 
 	if (!merge_prev && !merge_next)
_

Patches currently in -mm which might be from yajun.deng@linux.dev are

mm-mmap-simplify-vma-link-and-unlink.patch
mm-mmap-introduce-vma_set_range.patch
mm-mmap-use-sz_8m-128m-helper-macro.patch

