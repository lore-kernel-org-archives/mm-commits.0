Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B6A678C89
	for <mm-commits@vger.kernel.org>; Wed,  4 Sep 2024 04:19:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725423571; cv=none; b=YCP90Ah7jKZo1B9ZYQG1IBwjj3ip3Meg1iGYOWjXH0i6JXVPSiQ6t8etBih8rPneSQV4iDJc3cQtS1PynuKs2OIkI3aTiJv0Z6+/H8/ZznNuyIomvKgkS8pQgiOQCrjun6hOLZSMm7V26UQTlDjITIRjx+r/AYQMZy6hyIfbGXc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725423571; c=relaxed/simple;
	bh=+mKHJRlDVKeReMyw5DEMOIpROVOH4WERLcj4d3MmuK0=;
	h=Date:To:From:Subject:Message-Id; b=IPBIFu6LxV6v78LC67p9fENvtgAJQg1H6TDOuusthTO4pgYqKemj8sdjr5VHFPHbe5IMXxy5cCVQ+KUm2m5fJFOBdnK6lcAb4Z1su28PJQpdBxLAlPPNR1a5ooIFkSPw4yBqt0seh7mkIx92q3w4wyvejt10db+QwHWyy6Tnzw4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=sw2eWSLQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="sw2eWSLQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10AA1C4CEC2;
	Wed,  4 Sep 2024 04:19:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725423571;
	bh=+mKHJRlDVKeReMyw5DEMOIpROVOH4WERLcj4d3MmuK0=;
	h=Date:To:From:Subject:From;
	b=sw2eWSLQR2BO1okJdqEZMbxWztqifVIY1c/CD2Ls7efDdij6kxD5X6iTY6yJ6WAr5
	 JmkxIQOZTOzfQ++k/AqJ/b/nQR01aEQlA2ha6F+MsEFULR+jOS2VCZCLuVhTSdjjo7
	 TPTZxS/wr/Hib3Rs9OIs3gL1Vv44mMgh4OCOm9I4=
Date: Tue, 03 Sep 2024 21:19:30 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,vbabka@suse.cz,surenb@google.com,spasswolf@web.de,sidhartha.kumar@oracle.com,paul@paul-moore.com,paulmck@kernel.org,olsajiri@gmail.com,lstoakes@gmail.com,lorenzo.stoakes@oracle.com,kees@kernel.org,jeffxu@chromium.org,broonie@kernel.org,Liam.Howlett@Oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-mmap-use-phys_pfn-in-mmap_region.patch removed from -mm tree
Message-Id: <20240904041931.10AA1C4CEC2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/mmap: use PHYS_PFN in mmap_region()
has been removed from the -mm tree.  Its filename was
     mm-mmap-use-phys_pfn-in-mmap_region.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Liam R. Howlett" <Liam.Howlett@Oracle.com>
Subject: mm/mmap: use PHYS_PFN in mmap_region()
Date: Fri, 30 Aug 2024 00:00:56 -0400

Instead of shifting the length by PAGE_SIZE, use PHYS_PFN.  Also use the
existing local variable everywhere instead of some of the time.

Link: https://lkml.kernel.org/r/20240830040101.822209-17-Liam.Howlett@oracle.com
Signed-off-by: Liam R. Howlett <Liam.Howlett@Oracle.com>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reviewed-by: Suren Baghdasaryan <surenb@google.com>
Cc: Bert Karwatzki <spasswolf@web.de>
Cc: Jeff Xu <jeffxu@chromium.org>
Cc: Jiri Olsa <olsajiri@gmail.com>
Cc: Kees Cook <kees@kernel.org>
Cc: Lorenzo Stoakes <lstoakes@gmail.com>
Cc: Mark Brown <broonie@kernel.org>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: "Paul E. McKenney" <paulmck@kernel.org>
Cc: Paul Moore <paul@paul-moore.com>
Cc: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/mm/mmap.c~mm-mmap-use-phys_pfn-in-mmap_region
+++ a/mm/mmap.c
@@ -1364,7 +1364,7 @@ unsigned long mmap_region(struct file *f
 	struct mm_struct *mm = current->mm;
 	struct vm_area_struct *vma = NULL;
 	struct vm_area_struct *next, *prev, *merge;
-	pgoff_t pglen = len >> PAGE_SHIFT;
+	pgoff_t pglen = PHYS_PFN(len);
 	unsigned long charged = 0;
 	struct vma_munmap_struct vms;
 	struct ma_state mas_detach;
@@ -1384,7 +1384,7 @@ unsigned long mmap_region(struct file *f
 	 * MAP_FIXED may remove pages of mappings that intersects with requested
 	 * mapping. Account for the pages it would unmap.
 	 */
-	if (!may_expand_vm(mm, vm_flags, (len >> PAGE_SHIFT) - nr_pages))
+	if (!may_expand_vm(mm, vm_flags, pglen - nr_pages))
 		return -ENOMEM;
 
 	/* Find the first overlapping VMA */
@@ -1413,7 +1413,7 @@ unsigned long mmap_region(struct file *f
 	 * Private writable mapping: check memory availability
 	 */
 	if (accountable_mapping(file, vm_flags)) {
-		charged = len >> PAGE_SHIFT;
+		charged = pglen;
 		charged -= nr_accounted;
 		if (security_vm_enough_memory_mm(mm, charged))
 			goto abort_munmap;
@@ -1574,14 +1574,14 @@ expanded:
 	/* Unmap any existing mapping in the area */
 	vms_complete_munmap_vmas(&vms, &mas_detach);
 
-	vm_stat_account(mm, vm_flags, len >> PAGE_SHIFT);
+	vm_stat_account(mm, vm_flags, pglen);
 	if (vm_flags & VM_LOCKED) {
 		if ((vm_flags & VM_SPECIAL) || vma_is_dax(vma) ||
 					is_vm_hugetlb_page(vma) ||
 					vma == get_gate_vma(current->mm))
 			vm_flags_clear(vma, VM_LOCKED_MASK);
 		else
-			mm->locked_vm += (len >> PAGE_SHIFT);
+			mm->locked_vm += pglen;
 	}
 
 	if (file)
_

Patches currently in -mm which might be from Liam.Howlett@Oracle.com are


