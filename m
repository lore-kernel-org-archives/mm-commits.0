Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 811A17BB15
	for <mm-commits@vger.kernel.org>; Tue, 17 Sep 2024 08:07:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726560475; cv=none; b=KVQZ8Ib1PS+HFn0fLwYX/fQa/OU9zjuI+Rs4dpvJUAAuAz7BC6bM8N57zMFw21p8h/Zyxns9bErS6I3CGTaStKySfV9EPfV/xwr1J603YHqU0Z3YQbFGqR9vY4tu0MExwa02JANq6oa0gN7jrHpBYrAv1edKKok7p1u6o8h/Jz4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726560475; c=relaxed/simple;
	bh=zKd+a67ajfgrhECd+8CY2HDQJT2HB5Wovp0P3czoDFc=;
	h=Date:To:From:Subject:Message-Id; b=ALRtW57xLSqA1dobyQXf2oYmuXeat1Svt0rvYKfL00b8uu+zUQP3jB/3RmR4e7e9PZSoprnYjLupkJs9Ajz8/jPrCspno7uklSWzdkX+mkW+KGrl312TWqmEI0yH6A3JJGNT9ZN7grX0USRARr3BOEIn8Ynf+cVKvJ9sbMzRUNQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=UsdS7uRv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="UsdS7uRv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E89F1C4CEC6;
	Tue, 17 Sep 2024 08:07:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1726560475;
	bh=zKd+a67ajfgrhECd+8CY2HDQJT2HB5Wovp0P3czoDFc=;
	h=Date:To:From:Subject:From;
	b=UsdS7uRvoZJ79NNgBBnZQr5ZEmwuLqKi5lYkVRFYBCSAr2l3/rbTcvWcZkVOAVo60
	 2h+qDOQ7OeY0zqMgW/TIo2ZVNsMWVQthRoy5DZZfCeHZm1x2ldCQL2pTFgk6hlGEx5
	 BhG+lyU4aiq2OMOhaP9Xz1FUBupSE1HRGIAK1mPE=
Date: Tue, 17 Sep 2024 01:07:52 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,willy@infradead.org,will@kernel.org,tglx@linutronix.de,svens@linux.ibm.com,seanjc@google.com,schnelle@linux.ibm.com,ryan.roberts@arm.com,pbonzini@redhat.com,mingo@redhat.com,jgg@nvidia.com,hca@linux.ibm.com,gshan@redhat.com,gor@linux.ibm.com,gerald.schaefer@linux.ibm.com,david@redhat.com,dave.hansen@linux.intel.com,catalin.marinas@arm.com,bp@alien8.de,borntraeger@linux.ibm.com,aneesh.kumar@linux.ibm.com,alex.williamson@redhat.com,agordeev@linux.ibm.com,peterx@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-fork-accept-huge-pfnmap-entries.patch removed from -mm tree
Message-Id: <20240917080754.E89F1C4CEC6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/fork: accept huge pfnmap entries
has been removed from the -mm tree.  Its filename was
     mm-fork-accept-huge-pfnmap-entries.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Peter Xu <peterx@redhat.com>
Subject: mm/fork: accept huge pfnmap entries
Date: Mon, 26 Aug 2024 16:43:41 -0400

Teach the fork code to properly copy pfnmaps for pmd/pud levels.  Pud is
much easier, the write bit needs to be persisted though for writable and
shared pud mappings like PFNMAP ones, otherwise a follow up write in
either parent or child process will trigger a write fault.

Do the same for pmd level.

Link: https://lkml.kernel.org/r/20240826204353.2228736-8-peterx@redhat.com
Signed-off-by: Peter Xu <peterx@redhat.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Alex Williamson <alex.williamson@redhat.com>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Gavin Shan <gshan@redhat.com>
Cc: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Niklas Schnelle <schnelle@linux.ibm.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Sean Christopherson <seanjc@google.com>
Cc: Sven Schnelle <svens@linux.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |   29 ++++++++++++++++++++++++++---
 1 file changed, 26 insertions(+), 3 deletions(-)

--- a/mm/huge_memory.c~mm-fork-accept-huge-pfnmap-entries
+++ a/mm/huge_memory.c
@@ -1583,6 +1583,24 @@ int copy_huge_pmd(struct mm_struct *dst_
 	pgtable_t pgtable = NULL;
 	int ret = -ENOMEM;
 
+	pmd = pmdp_get_lockless(src_pmd);
+	if (unlikely(pmd_special(pmd))) {
+		dst_ptl = pmd_lock(dst_mm, dst_pmd);
+		src_ptl = pmd_lockptr(src_mm, src_pmd);
+		spin_lock_nested(src_ptl, SINGLE_DEPTH_NESTING);
+		/*
+		 * No need to recheck the pmd, it can't change with write
+		 * mmap lock held here.
+		 *
+		 * Meanwhile, making sure it's not a CoW VMA with writable
+		 * mapping, otherwise it means either the anon page wrongly
+		 * applied special bit, or we made the PRIVATE mapping be
+		 * able to wrongly write to the backend MMIO.
+		 */
+		VM_WARN_ON_ONCE(is_cow_mapping(src_vma->vm_flags) && pmd_write(pmd));
+		goto set_pmd;
+	}
+
 	/* Skip if can be re-fill on fault */
 	if (!vma_is_anonymous(dst_vma))
 		return 0;
@@ -1664,7 +1682,9 @@ out_zero_page:
 	pmdp_set_wrprotect(src_mm, addr, src_pmd);
 	if (!userfaultfd_wp(dst_vma))
 		pmd = pmd_clear_uffd_wp(pmd);
-	pmd = pmd_mkold(pmd_wrprotect(pmd));
+	pmd = pmd_wrprotect(pmd);
+set_pmd:
+	pmd = pmd_mkold(pmd);
 	set_pmd_at(dst_mm, addr, dst_pmd, pmd);
 
 	ret = 0;
@@ -1710,8 +1730,11 @@ int copy_huge_pud(struct mm_struct *dst_
 	 * TODO: once we support anonymous pages, use
 	 * folio_try_dup_anon_rmap_*() and split if duplicating fails.
 	 */
-	pudp_set_wrprotect(src_mm, addr, src_pud);
-	pud = pud_mkold(pud_wrprotect(pud));
+	if (is_cow_mapping(vma->vm_flags) && pud_write(pud)) {
+		pudp_set_wrprotect(src_mm, addr, src_pud);
+		pud = pud_wrprotect(pud);
+	}
+	pud = pud_mkold(pud);
 	set_pud_at(dst_mm, addr, dst_pud, pud);
 
 	ret = 0;
_

Patches currently in -mm which might be from peterx@redhat.com are


