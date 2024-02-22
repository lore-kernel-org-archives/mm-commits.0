Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4308412D1EF
	for <mm-commits@vger.kernel.org>; Thu, 22 Feb 2024 21:43:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708638219; cv=none; b=YCfa23Vn1TZVdRnfwFPaOWp2XWord8uCpYgBXZli02D2GUU4o+pdJk0s5z0Z7pW+gRqEDn2nctPCSm2hVFswQVlQMr4NWOHRIbv1/7ViMct3C7KAYCsn937MSK0ev5oPN5WGs2nxVEHFURbU5AU4DvLyUooVJ2jUn3wFg5dBAfc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708638219; c=relaxed/simple;
	bh=EN7VWo2Nmp1T5TOYdE4x8M/0b2IdHvh1F4aqDvom/iU=;
	h=Date:To:From:Subject:Message-Id; b=KK9nFNWcXDtTI780ADU0578T34gv6Sr+MDpbm//GkxiZxC/m9CS/hBShciKj/5BXLv3NC+SDiFGZUcsqkRlMjxEGYzdHZHSFHmBb3P7TTk1pfwazsCj2LE08/Hyw8xHB0vCQnUrdNLiRqJMNuNgRNI3HVFrQyqmdQlVB9k8CbbY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=LV+1oGrm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="LV+1oGrm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D7E5C433F1;
	Thu, 22 Feb 2024 21:43:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708638219;
	bh=EN7VWo2Nmp1T5TOYdE4x8M/0b2IdHvh1F4aqDvom/iU=;
	h=Date:To:From:Subject:From;
	b=LV+1oGrmj8I2Sph2SxWaBffIu7oD4Y1Ay4tGVDCsx1gIKLeKHEsio1byB74YSv+kP
	 S20W9Pyk/NtUOCA+JVhWtG8jPpGD0eR0iDTHyAh2OdL41Cn7FiEo1tYiTS4590zgyk
	 d1qwu4zi7hiNT5WXZPVmziiQ8AdlStFeWhXoUzlI=
Date: Thu, 22 Feb 2024 13:43:38 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,muchun.song@linux.dev,vishal.moola@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + hugetlb-use-vmf_anon_prepare-instead-of-anon_vma_prepare.patch added to mm-unstable branch
Message-Id: <20240222214339.0D7E5C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: hugetlb: use vmf_anon_prepare() instead of anon_vma_prepare()
has been added to the -mm mm-unstable branch.  Its filename is
     hugetlb-use-vmf_anon_prepare-instead-of-anon_vma_prepare.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/hugetlb-use-vmf_anon_prepare-instead-of-anon_vma_prepare.patch

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
From: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
Subject: hugetlb: use vmf_anon_prepare() instead of anon_vma_prepare()
Date: Wed, 21 Feb 2024 15:47:31 -0800

hugetlb_no_page() and hugetlb_wp() call anon_vma_prepare().  In
preparation for hugetlb to safely handle faults under the VMA lock, use
vmf_anon_prepare() here instead.

Additionally, passing hugetlb_wp() the vm_fault struct from
hugetlb_fault() works toward cleaning up the hugetlb code and function
stack.

Link: https://lkml.kernel.org/r/20240221234732.187629-5-vishal.moola@gmail.com
Signed-off-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Muchun Song <muchun.song@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |   18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

--- a/mm/hugetlb.c~hugetlb-use-vmf_anon_prepare-instead-of-anon_vma_prepare
+++ a/mm/hugetlb.c
@@ -5938,7 +5938,8 @@ static void unmap_ref_private(struct mm_
  */
 static vm_fault_t hugetlb_wp(struct mm_struct *mm, struct vm_area_struct *vma,
 		       unsigned long address, pte_t *ptep, unsigned int flags,
-		       struct folio *pagecache_folio, spinlock_t *ptl)
+		       struct folio *pagecache_folio, spinlock_t *ptl,
+		       struct vm_fault *vmf)
 {
 	const bool unshare = flags & FAULT_FLAG_UNSHARE;
 	pte_t pte = huge_ptep_get(ptep);
@@ -6072,10 +6073,9 @@ retry_avoidcopy:
 	 * When the original hugepage is shared one, it does not have
 	 * anon_vma prepared.
 	 */
-	if (unlikely(anon_vma_prepare(vma))) {
-		ret = VM_FAULT_OOM;
+	ret = vmf_anon_prepare(vmf);
+	if (unlikely(ret))
 		goto out_release_all;
-	}
 
 	if (copy_user_large_folio(new_folio, old_folio, address, vma)) {
 		ret = VM_FAULT_HWPOISON_LARGE;
@@ -6315,10 +6315,10 @@ static vm_fault_t hugetlb_no_page(struct
 			new_pagecache_folio = true;
 		} else {
 			folio_lock(folio);
-			if (unlikely(anon_vma_prepare(vma))) {
-				ret = VM_FAULT_OOM;
+
+			ret = vmf_anon_prepare(vmf);
+			if (unlikely(ret))
 				goto backout_unlocked;
-			}
 			anon_rmap = 1;
 		}
 	} else {
@@ -6385,7 +6385,7 @@ static vm_fault_t hugetlb_no_page(struct
 	hugetlb_count_add(pages_per_huge_page(h), mm);
 	if ((flags & FAULT_FLAG_WRITE) && !(vma->vm_flags & VM_SHARED)) {
 		/* Optimization, do the COW without a second fault */
-		ret = hugetlb_wp(mm, vma, address, ptep, flags, folio, ptl);
+		ret = hugetlb_wp(mm, vma, address, ptep, flags, folio, ptl, vmf);
 	}
 
 	spin_unlock(ptl);
@@ -6608,7 +6608,7 @@ vm_fault_t hugetlb_fault(struct mm_struc
 	if (flags & (FAULT_FLAG_WRITE|FAULT_FLAG_UNSHARE)) {
 		if (!huge_pte_write(entry)) {
 			ret = hugetlb_wp(mm, vma, address, ptep, flags,
-					 pagecache_folio, ptl);
+					 pagecache_folio, ptl, &vmf);
 			goto out_put_page;
 		} else if (likely(flags & FAULT_FLAG_WRITE)) {
 			entry = huge_pte_mkdirty(entry);
_

Patches currently in -mm which might be from vishal.moola@gmail.com are

mm-memory-change-vmf_anon_prepare-to-be-non-static.patch
hugetlb-move-vm_struct-declaration-to-the-top-of-hugetlb_fault.patch
hugetlb-pass-struct-vm_fault-through-to-hugetlb_handle_userfault.patch
hugetlb-use-vmf_anon_prepare-instead-of-anon_vma_prepare.patch
hugetlb-allow-faults-to-be-handled-under-the-vma-lock.patch

