Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 280DC19B3F6;
	Sat, 12 Oct 2024 22:49:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728773390; cv=none; b=mb6KGZCYD4jXPLwHv3wNze6C10CgYrxP9JqJLaBRruncj7rZJcwFa3DawEKyLZCM/XtvLVJ5Km2wxnqTFi2y67rbsO/5XxtiodvOLbVDJ8WEXDXWlX8P3Gt/zbkK54ANU9ayNqdHe7MOy2gYPPnxFarEGG+a6x4VmeMP7xD4NE0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728773390; c=relaxed/simple;
	bh=DGcxxOBeAflHGnbs1L0X7YJrkzrTddaSkPB9zk2Zdsc=;
	h=Date:To:From:Subject:Message-Id; b=VzA4ZB236+lNMROKtpG2TZx0a10JUL6JJfIVgtFan1X90dxFItt3crMA+toPYh2/tWoRKz3ebXfQFa4WUe8rwnyOQrjSmahBgajHYOHjCWqSFCdDa9X1wXw7x/TDfv5tstNVJaNJgMr8519dLPCLcJooR8iBIBGWOXwiLtttVAU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=fGQEs8XO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="fGQEs8XO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F0AEC4CECD;
	Sat, 12 Oct 2024 22:49:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1728773389;
	bh=DGcxxOBeAflHGnbs1L0X7YJrkzrTddaSkPB9zk2Zdsc=;
	h=Date:To:From:Subject:From;
	b=fGQEs8XOJPxU2hih7T6QAG6jRGFecFb8/LQM/Mg2OsbpUbbdA6ZPtRtMr0SGEBOeR
	 0Kdp3pMmUFNx+ala8wLdKV0NxMFdUczV5YiwID7wX8RR6bPIcwZqhTtRlOf9euBmZ+
	 AyiVLuGX7uf7b7ZfTznXxdUSVOYuxmajq/jou7+A=
Date: Sat, 12 Oct 2024 15:49:48 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,thuth@redhat.com,stable@vger.kernel.org,ryan.roberts@arm.com,imbrenda@linux.ibm.com,hughd@google.com,frankja@linux.ibm.com,david@redhat.com,borntraeger@linux.ibm.com,bfu@redhat.com,wangkefeng.wang@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-huge_memory-add-vma_thp_disabled-and-thp_disabled_by_hw.patch added to mm-hotfixes-unstable branch
Message-Id: <20241012224949.8F0AEC4CECD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: huge_memory: add vma_thp_disabled() and thp_disabled_by_hw()
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-huge_memory-add-vma_thp_disabled-and-thp_disabled_by_hw.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-huge_memory-add-vma_thp_disabled-and-thp_disabled_by_hw.patch

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
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: mm: huge_memory: add vma_thp_disabled() and thp_disabled_by_hw()
Date: Fri, 11 Oct 2024 12:24:44 +0200

Patch series "mm: don't install PMD mappings when THPs are disabled by the
hw/process/vma".

During testing, it was found that we can get PMD mappings in processes
where THP (and more precisely, PMD mappings) are supposed to be disabled. 
While it works as expected for anon+shmem, the pagecache is the
problematic bit.

For s390 KVM this currently means that a VM backed by a file located on
filesystem with large folio support can crash when KVM tries accessing the
problematic page, because the readahead logic might decide to use a
PMD-sized THP and faulting it into the page tables will install a PMD
mapping, something that s390 KVM cannot tolerate.

This might also be a problem with HW that does not support PMD mappings,
but I did not try reproducing it.

Fix it by respecting the ways to disable THPs when deciding whether we can
install a PMD mapping.  khugepaged should already be taking care of not
collapsing if THPs are effectively disabled for the hw/process/vma.


This patch (of 2):

Add vma_thp_disabled() and thp_disabled_by_hw() helpers to be shared by
shmem_allowable_huge_orders() and __thp_vma_allowable_orders().

[david@redhat.com: rename to vma_thp_disabled(), split out thp_disabled_by_hw() ]
Link: https://lkml.kernel.org/r/20241011102445.934409-2-david@redhat.com
Fixes: 793917d997df ("mm/readahead: Add large folio readahead")
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Signed-off-by: David Hildenbrand <david@redhat.com>
Reported-by: Leo Fu <bfu@redhat.com>
Tested-by: Thomas Huth <thuth@redhat.com>
Reviewed-by: Ryan Roberts <ryan.roberts@arm.com>
Cc: Boqiao Fu <bfu@redhat.com>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Janosch Frank <frankja@linux.ibm.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/huge_mm.h |   18 ++++++++++++++++++
 mm/huge_memory.c        |   13 +------------
 mm/shmem.c              |    7 +------
 3 files changed, 20 insertions(+), 18 deletions(-)

--- a/include/linux/huge_mm.h~mm-huge_memory-add-vma_thp_disabled-and-thp_disabled_by_hw
+++ a/include/linux/huge_mm.h
@@ -322,6 +322,24 @@ struct thpsize {
 	(transparent_hugepage_flags &					\
 	 (1<<TRANSPARENT_HUGEPAGE_USE_ZERO_PAGE_FLAG))
 
+static inline bool vma_thp_disabled(struct vm_area_struct *vma,
+		unsigned long vm_flags)
+{
+	/*
+	 * Explicitly disabled through madvise or prctl, or some
+	 * architectures may disable THP for some mappings, for
+	 * example, s390 kvm.
+	 */
+	return (vm_flags & VM_NOHUGEPAGE) ||
+	       test_bit(MMF_DISABLE_THP, &vma->vm_mm->flags);
+}
+
+static inline bool thp_disabled_by_hw(void)
+{
+	/* If the hardware/firmware marked hugepage support disabled. */
+	return transparent_hugepage_flags & (1 << TRANSPARENT_HUGEPAGE_UNSUPPORTED);
+}
+
 unsigned long thp_get_unmapped_area(struct file *filp, unsigned long addr,
 		unsigned long len, unsigned long pgoff, unsigned long flags);
 unsigned long thp_get_unmapped_area_vmflags(struct file *filp, unsigned long addr,
--- a/mm/huge_memory.c~mm-huge_memory-add-vma_thp_disabled-and-thp_disabled_by_hw
+++ a/mm/huge_memory.c
@@ -109,18 +109,7 @@ unsigned long __thp_vma_allowable_orders
 	if (!vma->vm_mm)		/* vdso */
 		return 0;
 
-	/*
-	 * Explicitly disabled through madvise or prctl, or some
-	 * architectures may disable THP for some mappings, for
-	 * example, s390 kvm.
-	 * */
-	if ((vm_flags & VM_NOHUGEPAGE) ||
-	    test_bit(MMF_DISABLE_THP, &vma->vm_mm->flags))
-		return 0;
-	/*
-	 * If the hardware/firmware marked hugepage support disabled.
-	 */
-	if (transparent_hugepage_flags & (1 << TRANSPARENT_HUGEPAGE_UNSUPPORTED))
+	if (thp_disabled_by_hw() || vma_thp_disabled(vma, vm_flags))
 		return 0;
 
 	/* khugepaged doesn't collapse DAX vma, but page fault is fine. */
--- a/mm/shmem.c~mm-huge_memory-add-vma_thp_disabled-and-thp_disabled_by_hw
+++ a/mm/shmem.c
@@ -1664,12 +1664,7 @@ unsigned long shmem_allowable_huge_order
 	loff_t i_size;
 	int order;
 
-	if (vma && ((vm_flags & VM_NOHUGEPAGE) ||
-	    test_bit(MMF_DISABLE_THP, &vma->vm_mm->flags)))
-		return 0;
-
-	/* If the hardware/firmware marked hugepage support disabled. */
-	if (transparent_hugepage_flags & (1 << TRANSPARENT_HUGEPAGE_UNSUPPORTED))
+	if (thp_disabled_by_hw() || (vma && vma_thp_disabled(vma, vm_flags)))
 		return 0;
 
 	global_huge = shmem_huge_global_enabled(inode, index, write_end,
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are

mm-huge_memory-add-vma_thp_disabled-and-thp_disabled_by_hw.patch
mm-remove-unused-hugepage-for-vma_alloc_folio.patch

