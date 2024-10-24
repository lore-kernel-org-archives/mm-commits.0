Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C09F170A0B
	for <mm-commits@vger.kernel.org>; Thu, 24 Oct 2024 06:15:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729750523; cv=none; b=qs6KHsUTIsezy8LEMlrO+iZfKN0VpFBWqxZtUmkMGuDMEO0D//MnVwLSoYWQyRX//R05Ab7V0d4KZGpdk9jXj99HoXTKVsGINO7GOrZYdreG1Py60+2y6nldH8b7NH15DyJuvkCBJayTxGWQrQDl5MubAhAkUKiYvibGgkfTke8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729750523; c=relaxed/simple;
	bh=X3U6CML1RnGTyJIxuebudmgHThz2zhRAzBu1G44Hc0Y=;
	h=Date:To:From:Subject:Message-Id; b=cJ6xWMLX73fe29KDymebJaDTMfeXZq8XopS2mdPe70R6nV01EAgDivXHUiM584wPvSb9amWyq6sAAbeUOY/RqhAxJLXefspzHqSrBKO0t91fmlHX+HbkXVFGF7+F/pTs8YTRuCX9GyLu7HAlFkhHpmiKmSr8pSrpBHq9kbCkGes=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=uupY0YRE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="uupY0YRE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85952C4CEE6;
	Thu, 24 Oct 2024 06:15:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1729750522;
	bh=X3U6CML1RnGTyJIxuebudmgHThz2zhRAzBu1G44Hc0Y=;
	h=Date:To:From:Subject:From;
	b=uupY0YRE2tCczr/80snhGvXUf0fXGrvyhWo0vaHhZqhVcfYcJ0zx6zDT/Usrbe5kT
	 IsdAFRrREhlGeGo8jVQJknzw1Nsz2Qw5kPFa8ODqSh+bjZh+On3KveYyeCm1wBpfUB
	 10h6NYa/+62XkfnolLxPax0xWi4CqwdJSPHl9poU=
Date: Wed, 23 Oct 2024 23:15:22 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,vbabka@suse.cz,lorenzo.stoakes@oracle.com,jannh@google.com,david@redhat.com,Liam.Howlett@Oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-mmap-fix-race-in-mmap_region-with-ftrucate.patch removed from -mm tree
Message-Id: <20241024061522.85952C4CEE6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/mmap: fix race in mmap_region() with ftruncate()
has been removed from the -mm tree.  Its filename was
     mm-mmap-fix-race-in-mmap_region-with-ftrucate.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Liam R. Howlett" <Liam.Howlett@Oracle.com>
Subject: mm/mmap: fix race in mmap_region() with ftruncate()
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

mm-mremap-clean-up-vma_to_resize.patch
mm-mremap-remove-goto-from-mremap_to.patch

