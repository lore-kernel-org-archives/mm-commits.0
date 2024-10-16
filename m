Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A41E94409
	for <mm-commits@vger.kernel.org>; Wed, 16 Oct 2024 20:58:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729112335; cv=none; b=dIjVg/g/aW3J+G8tlJ4LMaIF69IpxIkuFshfHor3M560o+tAW5rmhDiIbd1xpVBPKiSdmuOrY0kedGiEjYM8F6/Subh6VMngIxPt7/fuMO1z07OYzdcEW2LRHkhvNfLYHTWQm02/NtCYLB8qyPx/t7XxvM+sCs2afn1F6odBCL8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729112335; c=relaxed/simple;
	bh=8wiskyLRqynLiUmTThUdHX2KifWGIwiEB0oynjEdZHY=;
	h=Date:To:From:Subject:Message-Id; b=LHZuFR8Q/HumV/1aH2Hksz2t+8RQN/vzdZxfFW/i+xa5M9QRdUTDYrqH0l9lMMAwT+E9UdDAgUBwe86owmPhsc5DMt/JDXC0XXTlt751meCp6uVG45HhZEQFaVg834FqCzKPO8Sq+/KRkrfkj5i5zH6NtinZJOVJSlX20xYhsZg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=eHAswQJO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="eHAswQJO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 287F9C4CEC5;
	Wed, 16 Oct 2024 20:58:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1729112335;
	bh=8wiskyLRqynLiUmTThUdHX2KifWGIwiEB0oynjEdZHY=;
	h=Date:To:From:Subject:From;
	b=eHAswQJOPwKGtMu967KDD8PBRFLSjiM2jDD84vOO+4oQxTZQjcWxL5wv8nTB0nl1R
	 Nk5+q6S2rnarKoAG8Tv+KJ9Q97KUkxbSsjYxTzcuzkqk2wsNDciL3k9HmPSYGNmAP1
	 8k2o5nLOcHZIaIaJrAQ8+vfDrx3WozDGnxUbwGbg=
Date: Wed, 16 Oct 2024 13:58:54 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,vbabka@suse.cz,lorenzo.stoakes@oracle.com,jannh@google.com,david@redhat.com,Liam.Howlett@Oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mmap-fix-race-in-mmap_region-with-ftrucate.patch added to mm-hotfixes-unstable branch
Message-Id: <20241016205855.287F9C4CEC5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/mmap: Fix race in mmap_region() with ftruncate()
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-mmap-fix-race-in-mmap_region-with-ftrucate.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mmap-fix-race-in-mmap_region-with-ftrucate.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: "Liam R. Howlett" <Liam.Howlett@Oracle.com>
Subject: mm/mmap: Fix race in mmap_region() with ftruncate()
Date: Tue, 15 Oct 2024 21:34:55 -0400

Avoiding the zeroing of the vma tree in mmap_region() introduced a race
with truncate in the page table walk.  To avoid any races, create a hole
in the rmap during the operation by clearing the pagetable entries earlier
under the mmap write lock and (critically) before the new vma is installed
into the vma tree.  The result is that the old vma(s) are left in the vma
tree, but free_pgtables() removes them from the rmap and clears the ptes
while holding the necessary locks.

This change extends the fix required for hugetblfs and the call_mmap()
function by moving the cleanup higher in the function and running it
unconditionally.

Link: https://lkml.kernel.org/r/20241016013455.2241533-1-Liam.Howlett@oracle.com
Fixes: f8d112a4e657 ("mm/mmap: avoid zeroing vma tree in mmap_region()")
Signed-off-by: Liam R. Howlett <Liam.Howlett@Oracle.com>
Reported-by: Jann Horn <jannh@google.com>
Closes: https://lore.kernel.org/all/CAG48ez0ZpGzxi=-5O_uGQ0xKXOmbjeQ0LjZsRJ1Qtf2X5eOr1w@mail.gmail.com/
Reviewed-by: Jann Horn <jannh@google.com>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

--- a/mm/mmap.c~mm-mmap-fix-race-in-mmap_region-with-ftrucate
+++ a/mm/mmap.c
@@ -1418,6 +1418,13 @@ unsigned long mmap_region(struct file *f
 		vmg.flags = vm_flags;
 	}
 
+	/*
+	 * clear PTEs while the vma is still in the tree so that rmap
+	 * cannot race with the freeing later in the truncate scenario.
+	 * This is also needed for call_mmap(), which is why vm_ops
+	 * close function is called.
+	 */
+	vms_clean_up_area(&vms, &mas_detach);
 	vma = vma_merge_new_range(&vmg);
 	if (vma)
 		goto expanded;
@@ -1439,11 +1446,6 @@ unsigned long mmap_region(struct file *f
 
 	if (file) {
 		vma->vm_file = get_file(file);
-		/*
-		 * call_mmap() may map PTE, so ensure there are no existing PTEs
-		 * and call the vm_ops close function if one exists.
-		 */
-		vms_clean_up_area(&vms, &mas_detach);
 		error = call_mmap(file, vma);
 		if (error)
 			goto unmap_and_free_vma;
_

Patches currently in -mm which might be from Liam.Howlett@Oracle.com are

mm-mmap-fix-race-in-mmap_region-with-ftrucate.patch

