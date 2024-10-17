Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CDF11C32EB;
	Thu, 17 Oct 2024 07:28:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729150135; cv=none; b=sFLBg3t12P9VkW8DuS6+RVOjnmoDq69Sf8Mk3pv9gGKufLQmXim++7SyP5J+Dhc06AB60pjOpIO/Exzeb6ZgGadLtjie/df3oDMhVH8bN9jvWQCCSR7bjajvwncXc08+7ZlvieNnkPIU1A7cRxpv8B+RyAcyaLG+ogeEKqvI6qw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729150135; c=relaxed/simple;
	bh=lkcBWSZPSXTTYwnaf8JQwHMDwesBbpSrGyfJgJNj31s=;
	h=Date:To:From:Subject:Message-Id; b=lMOXyXUNh0nHkwuuEVGpbPqODWMFxYi/1P/ZNzmI2VPcojjWWy9yLSl5eAG4BpV3tRxpaDoJUYXMQ5uykYhb09SzheS5kHKmNiKePbP2ErtARKNhkZuGVoKGetS55yGsMtk+Qo2nPCstVeDgyaFptoRWBzt8n4cKUqz1Ne9KKs8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=GjvekOSS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="GjvekOSS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6207EC4CEC3;
	Thu, 17 Oct 2024 07:28:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1729150135;
	bh=lkcBWSZPSXTTYwnaf8JQwHMDwesBbpSrGyfJgJNj31s=;
	h=Date:To:From:Subject:From;
	b=GjvekOSSB9lRuwrSyM5M7UhCn9MxoLJ6YWg38cBoT1/QOMkh1Sxawx3DyLD5eQ/XH
	 fGw232DZmp+Kh8ychN2c8Raazuu0SdwXuvk1ZaVbTDxdGpccqHRLBrl/mxJBK0mboE
	 VgaOpEALFX3CGvbTZyaB11oPa+V96WgDEJLVjD+8=
Date: Thu, 17 Oct 2024 00:28:54 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,thuth@redhat.com,stable@vger.kernel.org,ryan.roberts@arm.com,imbrenda@linux.ibm.com,hughd@google.com,frankja@linux.ibm.com,david@redhat.com,borntraeger@linux.ibm.com,bfu@redhat.com,wangkefeng.wang@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-huge_memory-add-vma_thp_disabled-and-thp_disabled_by_hw.patch removed from -mm tree
Message-Id: <20241017072855.6207EC4CEC3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: huge_memory: add vma_thp_disabled() and thp_disabled_by_hw()
has been removed from the -mm tree.  Its filename was
     mm-huge_memory-add-vma_thp_disabled-and-thp_disabled_by_hw.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

mm-remove-unused-hugepage-for-vma_alloc_folio.patch

