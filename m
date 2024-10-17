Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 669B21925B2
	for <mm-commits@vger.kernel.org>; Thu, 17 Oct 2024 07:28:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729150115; cv=none; b=UdAh1gpy8/XeWKDHdStJc1zLhaGS3Oxf+D6OTBdcsgR4gP5PPTwsv4G1NVSDrKUlTEO+s2aeL5hQIHT9okPSMivS9KXk9HpV9an9dartgiy56gihPc34KisrVMTAuOH5I1xNfj2Wa8w7mfJMnGJ/ovReroB0LqQ7WueGxRdB9/A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729150115; c=relaxed/simple;
	bh=4lJOyIx3j34i4b8XgRDIiBiI53hqm0M5DUebr/UL7PA=;
	h=Date:To:From:Subject:Message-Id; b=gQ5DHJ8mxQ24pOI1inVLfboTO9rtLkNXKv3nbinBlvlOXzfnOpJo5x0iUv8jyf2ewLPue4J2H4FRrQbVXPxaBcmQ61ZpNVKNc3VonaFTE3n+mk5Ag30A8zZnSrI4ItW9srkt4Cl8ohgoU7nBJHQWstfdaqpBl4FNgb7WY62JbOU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ABTAElzF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ABTAElzF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DECCBC4CEC3;
	Thu, 17 Oct 2024 07:28:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1729150114;
	bh=4lJOyIx3j34i4b8XgRDIiBiI53hqm0M5DUebr/UL7PA=;
	h=Date:To:From:Subject:From;
	b=ABTAElzF0ZRbIdWO3qyIK1Ozu/ORX2OQQpFaKQvnQBivym7aRkIVvK3muXIZFzmDE
	 ACXYODR2xG2YaG/2aTzEJlgZA1vkhiyTE99TiTb7LjYxKaR6Bqw8vnXgA0Uye7NCOZ
	 EsAJGct60DvftCJp2Q+fWdJun5Zm7DI7DMAkaaN4=
Date: Thu, 17 Oct 2024 00:28:34 -0700
To: mm-commits@vger.kernel.org,vegard.nossum@oracle.com,vbabka@suse.cz,Liam.Howlett@oracle.com,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-mmap-correct-error-handling-in-mmap_region.patch removed from -mm tree
Message-Id: <20241017072834.DECCBC4CEC3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/mmap: correct error handling in mmap_region()
has been removed from the -mm tree.  Its filename was
     mm-mmap-correct-error-handling-in-mmap_region.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: mm/mmap: correct error handling in mmap_region()
Date: Wed, 2 Oct 2024 08:39:32 +0100

Commit f8d112a4e657 ("mm/mmap: avoid zeroing vma tree in mmap_region()")
changed how error handling is performed in mmap_region().

The error value defaults to -ENOMEM, but then gets reassigned immediately
to the result of vms_gather_munmap_vmas() if we are performing a MAP_FIXED
mapping over existing VMAs (and thus unmapping them).

This overwrites the error value, potentially clearing it.

After this, we invoke may_expand_vm() and possibly vm_area_alloc(), and
check to see if they failed. If they do so, then we perform error-handling
logic, but importantly, we do NOT update the error code.

This means that, if vms_gather_munmap_vmas() succeeds, but one of these
calls does not, the function will return indicating no error, but rather an
address value of zero, which is entirely incorrect.

Correct this and avoid future confusion by strictly setting error on each
and every occasion we jump to the error handling logic, and set the error
code immediately prior to doing so.

This way we can see at a glance that the error code is always correct.

Many thanks to Vegard Nossum who spotted this issue in discussion around
this problem.

Link: https://lkml.kernel.org/r/20241002073932.13482-1-lorenzo.stoakes@oracle.com
Fixes: f8d112a4e657 ("mm/mmap: avoid zeroing vma tree in mmap_region()")
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Suggested-by: Vegard Nossum <vegard.nossum@oracle.com>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |   32 +++++++++++++++++++++-----------
 1 file changed, 21 insertions(+), 11 deletions(-)

--- a/mm/mmap.c~mm-mmap-correct-error-handling-in-mmap_region
+++ a/mm/mmap.c
@@ -1371,7 +1371,7 @@ unsigned long mmap_region(struct file *f
 	struct maple_tree mt_detach;
 	unsigned long end = addr + len;
 	bool writable_file_mapping = false;
-	int error = -ENOMEM;
+	int error;
 	VMA_ITERATOR(vmi, mm, addr);
 	VMG_STATE(vmg, mm, &vmi, addr, end, vm_flags, pgoff);
 
@@ -1396,8 +1396,10 @@ unsigned long mmap_region(struct file *f
 	}
 
 	/* Check against address space limit. */
-	if (!may_expand_vm(mm, vm_flags, pglen - vms.nr_pages))
+	if (!may_expand_vm(mm, vm_flags, pglen - vms.nr_pages)) {
+		error = -ENOMEM;
 		goto abort_munmap;
+	}
 
 	/*
 	 * Private writable mapping: check memory availability
@@ -1405,8 +1407,11 @@ unsigned long mmap_region(struct file *f
 	if (accountable_mapping(file, vm_flags)) {
 		charged = pglen;
 		charged -= vms.nr_accounted;
-		if (charged && security_vm_enough_memory_mm(mm, charged))
-			goto abort_munmap;
+		if (charged) {
+			error = security_vm_enough_memory_mm(mm, charged);
+			if (error)
+				goto abort_munmap;
+		}
 
 		vms.nr_accounted = 0;
 		vm_flags |= VM_ACCOUNT;
@@ -1422,8 +1427,10 @@ unsigned long mmap_region(struct file *f
 	 * not unmapped, but the maps are removed from the list.
 	 */
 	vma = vm_area_alloc(mm);
-	if (!vma)
+	if (!vma) {
+		error = -ENOMEM;
 		goto unacct_error;
+	}
 
 	vma_iter_config(&vmi, addr, end);
 	vma_set_range(vma, addr, end, pgoff);
@@ -1453,9 +1460,10 @@ unsigned long mmap_region(struct file *f
 		 * Expansion is handled above, merging is handled below.
 		 * Drivers should not alter the address of the VMA.
 		 */
-		error = -EINVAL;
-		if (WARN_ON((addr != vma->vm_start)))
+		if (WARN_ON((addr != vma->vm_start))) {
+			error = -EINVAL;
 			goto close_and_free_vma;
+		}
 
 		vma_iter_config(&vmi, addr, end);
 		/*
@@ -1500,13 +1508,15 @@ unsigned long mmap_region(struct file *f
 	}
 
 	/* Allow architectures to sanity-check the vm_flags */
-	error = -EINVAL;
-	if (!arch_validate_flags(vma->vm_flags))
+	if (!arch_validate_flags(vma->vm_flags)) {
+		error = -EINVAL;
 		goto close_and_free_vma;
+	}
 
-	error = -ENOMEM;
-	if (vma_iter_prealloc(&vmi, vma))
+	if (vma_iter_prealloc(&vmi, vma)) {
+		error = -ENOMEM;
 		goto close_and_free_vma;
+	}
 
 	/* Lock the VMA since it is modified after insertion into VMA tree */
 	vma_start_write(vma);
_

Patches currently in -mm which might be from lorenzo.stoakes@oracle.com are

maple_tree-correct-tree-corruption-on-spanning-store.patch
maple_tree-add-regression-test-for-spanning-store-bug.patch
fork-do-not-invoke-uffd-on-fork-if-error-occurs.patch
fork-only-invoke-khugepaged-ksm-hooks-if-no-error.patch
selftests-mm-add-pkey_sighandler_xx-hugetlb_dio-to-gitignore.patch
mm-refactor-mm_access-to-not-return-null.patch
mm-refactor-mm_access-to-not-return-null-fix.patch
mm-madvise-unrestrict-process_madvise-for-current-process.patch
maple_tree-do-not-hash-pointers-on-dump-in-debug-mode.patch

