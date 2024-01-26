Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0827524F
	for <mm-commits@vger.kernel.org>; Fri, 26 Jan 2024 02:16:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706235380; cv=none; b=EfMFmxWFCJxhngcqIQsiKyqLXAVjkKKJ2KJr80965mvas9z9/pGRr2RLLO/lUXtpgboiOAFxBb7QzumNGeYxGy/BAW0msXp+moFxpbNmOdIVvVIJpXtHnScfnynd1VVnjCtGw5EHgOxmYXf/mo3uhgE63g+ARRZzapmHa/YiPb0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706235380; c=relaxed/simple;
	bh=nKmld2cxmoHHZ1lhuSQq87rXTzS2Vi5K51MqHxKWM5A=;
	h=Date:To:From:Subject:Message-Id; b=Ub52NSvnTM2iUXek/sybe4J5RrkeVb9OXsFBwvDBdtaSa3/aarHyqTEEsRd8rAirEaEp4PhV1B+Tcrk8SNS13cMjozrxD97ijCvnT7a8MZHtb9kY5jt+xq0RUhldLEH2IxyKdmd/u8drgUUxxLCWw42TZoiM5SVMv5odHVr0SrM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=FsunmKcm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="FsunmKcm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE2A9C433F1;
	Fri, 26 Jan 2024 02:16:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1706235380;
	bh=nKmld2cxmoHHZ1lhuSQq87rXTzS2Vi5K51MqHxKWM5A=;
	h=Date:To:From:Subject:From;
	b=FsunmKcmTZd2D+GqrXE5zhjo8z+RmV1no7vrPaUHWD6gEnIfCOM+N3sr9B5bGcPhg
	 waDLARw/fEubvi56HCpAsdv/ozRwrFs3+rPx8uHcxkRdjSfXXTWzfAJmVGqkiPC+Ff
	 SmACajDKcdkvbszEoN1mJpl2IYejaaVwpeit8gx4=
Date: Thu, 25 Jan 2024 18:16:17 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,viro@zeniv.linux.org.uk,vbabka@suse.cz,surenb@google.com,lstoakes@gmail.com,Liam.Howlett@oracle.com,brauner@kernel.org,yajun.deng@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mmap-remove-find_vma_intersection-in-vma_merge.patch added to mm-unstable branch
Message-Id: <20240126021619.AE2A9C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/mmap: remove find_vma_intersection() in vma_merge()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-mmap-remove-find_vma_intersection-in-vma_merge.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mmap-remove-find_vma_intersection-in-vma_merge.patch

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
Subject: mm/mmap: remove find_vma_intersection() in vma_merge()
Date: Thu, 25 Jan 2024 11:49:22 +0800

We need to find the current vma by find_vma_intersection() in vma_merge().
Since the src vma was passed, we can add a check to figure out if the
current vma is NULL or the src vma directly.

Remove find_vma_intersection() in vma_merge().  And initialize the next to
NULL when defining it.

Link: https://lkml.kernel.org/r/20240125034922.1004671-3-yajun.deng@linux.dev
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
mm-mmap-pass-vma-to-vma_merge.patch
mm-mmap-remove-find_vma_intersection-in-vma_merge.patch

