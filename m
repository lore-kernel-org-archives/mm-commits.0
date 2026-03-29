Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 734442517AC
	for <mm-commits@vger.kernel.org>; Sun, 29 Mar 2026 00:40:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774744845; cv=none; b=C//ht+ABQwmNI6pzD8eQfbUp+3xYYeYbH5purtcedBp5bYJNGO5mDUC8c87nyTdrLbEIpcnM+4PC0CgKQcPugHk38wlD/45/fJD1L1S5NeKIFoU+DR9GSyFaQ3XAC2lpBqVZWR4+AFQBLuzebjfxYFdhamSGtj8CyPPa3Ya8wJU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774744845; c=relaxed/simple;
	bh=0L7KUxnhLqYXyLdx9spWBgMAd2HXF04tBdHwzxUW2kI=;
	h=Date:To:From:Subject:Message-Id; b=THX1+Vywp8gabWBXw9O99Bbb3IiaM39V7zoOhis8+rjF2ydB78vrLk7pQoK5trIZMQ2+1fTRFij+NhAz5N4xJ8VsZA9wNU6HrZMtSrQVnYI1yU3gGP5NrUJP0JMp/vbQNTAAPO0mFORFCMpI6KcI5yCDTQ69NeDT6YDFlwD/Epw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=0d7QNVyF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="0d7QNVyF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C004C4CEF7;
	Sun, 29 Mar 2026 00:40:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774744845;
	bh=0L7KUxnhLqYXyLdx9spWBgMAd2HXF04tBdHwzxUW2kI=;
	h=Date:To:From:Subject:From;
	b=0d7QNVyFXNX0IlYpNzSNQ/E7ojvrQ5hcMl4SLJ9E6tJUT65lTdsQGRLkxpnz1fiTY
	 HUaBlZO78rlKNDGFzVDc6xpDG8P+f0jufS8qJAaI+b+Uvyh7J9PNpdpgHXXLDeSD0O
	 1+ejGKx5y6iLTISdoLFngfCuOx2kibunRQvd589Y=
Date: Sat, 28 Mar 2026 17:40:44 -0700
To: mm-commits@vger.kernel.org,surenb@google.com,rppt@kernel.org,pfalcato@suse.de,pbonzini@redhat.com,osalvador@suse.de,npiggin@gmail.com,muchun.song@linux.dev,mpe@ellerman.id.au,mhocko@suse.com,maddy@linux.ibm.com,ljs@kernel.org,liam.howlett@oracle.com,jannh@google.com,dan.j.williams@intel.com,chleroy@kernel.org,david@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-move-vma_kernel_pagesize-from-hugetlb-to-mmh.patch removed from -mm tree
Message-Id: <20260329004045.4C004C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: move vma_kernel_pagesize() from hugetlb to mm.h
has been removed from the -mm tree.  Its filename was
     mm-move-vma_kernel_pagesize-from-hugetlb-to-mmh.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "David Hildenbrand (Arm)" <david@kernel.org>
Subject: mm: move vma_kernel_pagesize() from hugetlb to mm.h
Date: Mon, 9 Mar 2026 16:18:58 +0100

Patch series "mm: move vma_(kernel|mmu)_pagesize() out of hugetlb.c", v2.

Looking into vma_(kernel|mmu)_pagesize(), I realized that there is one
scenario where DAX would not do the right thing when the kernel is not
compiled with hugetlb support.

Without hugetlb support, vma_(kernel|mmu)_pagesize() will always return
PAGE_SIZE instead of using the ->pagesize() result provided by dax-device
code.

Fix that by moving vma_kernel_pagesize() to core MM code, where it
belongs.  I don't think this is stable material, but am not 100% sure.

Also, move vma_mmu_pagesize() while at it.  Remove the unnecessary
hugetlb.h inclusion from KVM code.


This patch (of 4):

In the past, only hugetlb had special "vma_kernel_pagesize()"
requirements, so it provided its own implementation.

In commit 05ea88608d4e ("mm, hugetlbfs: introduce ->pagesize() to
vm_operations_struct") we generalized that approach by providing a
vm_ops->pagesize() callback to be used by device-dax.

Once device-dax started using that callback in commit c1d53b92b95c
("device-dax: implement ->pagesize() for smaps to report MMUPageSize") it
was missed that CONFIG_DEV_DAX does not depend on hugetlb support.

So building a kernel with CONFIG_DEV_DAX but without CONFIG_HUGETLBFS
would not pick up that value.

Fix it by moving vma_kernel_pagesize() to mm.h, providing only a single
implementation.  While at it, improve the kerneldoc a bit.

Ideally, we'd move vma_mmu_pagesize() as well to the header.  However, its
__weak symbol might be overwritten by a PPC variant in hugetlb code.  So
let's leave it in there for now, as it really only matters for some
hugetlb oddities.

This was found by code inspection.

Link: https://lkml.kernel.org/r/20260309151901.123947-1-david@kernel.org
Link: https://lkml.kernel.org/r/20260309151901.123947-2-david@kernel.org
Fixes: c1d53b92b95c ("device-dax: implement ->pagesize() for smaps to report MMUPageSize")
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>
Cc: Jann Horn <jannh@google.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/hugetlb.h |    7 -------
 include/linux/mm.h      |   20 ++++++++++++++++++++
 mm/hugetlb.c            |   17 -----------------
 3 files changed, 20 insertions(+), 24 deletions(-)

--- a/include/linux/hugetlb.h~mm-move-vma_kernel_pagesize-from-hugetlb-to-mmh
+++ a/include/linux/hugetlb.h
@@ -777,8 +777,6 @@ static inline unsigned long huge_page_si
 	return (unsigned long)PAGE_SIZE << h->order;
 }
 
-extern unsigned long vma_kernel_pagesize(struct vm_area_struct *vma);
-
 extern unsigned long vma_mmu_pagesize(struct vm_area_struct *vma);
 
 static inline unsigned long huge_page_mask(struct hstate *h)
@@ -1177,11 +1175,6 @@ static inline unsigned long huge_page_ma
 	return PAGE_MASK;
 }
 
-static inline unsigned long vma_kernel_pagesize(struct vm_area_struct *vma)
-{
-	return PAGE_SIZE;
-}
-
 static inline unsigned long vma_mmu_pagesize(struct vm_area_struct *vma)
 {
 	return PAGE_SIZE;
--- a/include/linux/mm.h~mm-move-vma_kernel_pagesize-from-hugetlb-to-mmh
+++ a/include/linux/mm.h
@@ -1351,6 +1351,26 @@ static inline bool vma_is_shared_maywrit
 	return is_shared_maywrite(&vma->flags);
 }
 
+/**
+ * vma_kernel_pagesize - Default page size granularity for this VMA.
+ * @vma: The user mapping.
+ *
+ * The kernel page size specifies in which granularity VMA modifications
+ * can be performed. Folios in this VMA will be aligned to, and at least
+ * the size of the number of bytes returned by this function.
+ *
+ * The default kernel page size is not affected by Transparent Huge Pages
+ * being in effect.
+ *
+ * Return: The default page size granularity for this VMA.
+ */
+static inline unsigned long vma_kernel_pagesize(struct vm_area_struct *vma)
+{
+	if (unlikely(vma->vm_ops && vma->vm_ops->pagesize))
+		return vma->vm_ops->pagesize(vma);
+	return PAGE_SIZE;
+}
+
 static inline
 struct vm_area_struct *vma_find(struct vma_iterator *vmi, unsigned long max)
 {
--- a/mm/hugetlb.c~mm-move-vma_kernel_pagesize-from-hugetlb-to-mmh
+++ a/mm/hugetlb.c
@@ -1017,23 +1017,6 @@ static pgoff_t vma_hugecache_offset(stru
 			(vma->vm_pgoff >> huge_page_order(h));
 }
 
-/**
- * vma_kernel_pagesize - Page size granularity for this VMA.
- * @vma: The user mapping.
- *
- * Folios in this VMA will be aligned to, and at least the size of the
- * number of bytes returned by this function.
- *
- * Return: The default size of the folios allocated when backing a VMA.
- */
-unsigned long vma_kernel_pagesize(struct vm_area_struct *vma)
-{
-	if (vma->vm_ops && vma->vm_ops->pagesize)
-		return vma->vm_ops->pagesize(vma);
-	return PAGE_SIZE;
-}
-EXPORT_SYMBOL_GPL(vma_kernel_pagesize);
-
 /*
  * Return the page size being used by the MMU to back a VMA. In the majority
  * of cases, the page size used by the kernel matches the MMU size. On
_

Patches currently in -mm which might be from david@kernel.org are


