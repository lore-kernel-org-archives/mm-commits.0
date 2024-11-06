Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D35D7156C7B
	for <mm-commits@vger.kernel.org>; Wed,  6 Nov 2024 00:59:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730854775; cv=none; b=fxWNGTr4BGRAd2zJYVebReZm2c0S6qf7pL/MMIn+vJ1r5WrYClMVEqtB6LgnvULlp5YwxfvX2DRb92H7xuWYPf8nOx51F+Xm0M5gFfjAiDIuBc25iNdaHD5gbVuTwnwc71q+7hPmxs58Bu8hFa04n7lRGLYF+FS/BioC67Nh1DM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730854775; c=relaxed/simple;
	bh=e5exgv4qmeZ4rRrpSTVDSzrTkStyJVm8f1CQytGJCgo=;
	h=Date:To:From:Subject:Message-Id; b=V0iuSUb9vkwlXOcIkosCuAUCEM4jNy/f7xPlFL+wjbuMdJJmiRPLkw/g9vfcYcFKQrUjfPSgvr3tAxjfV5RcRJb0zWMs2WTyUPT61FzW9M+sg2nmC9u3vzpdgmmpkeKBuF+DzGvdH4I0VDvPDnSJG6QK98xDUSSUnfAU69bVsSw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=YgfNaMbv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="YgfNaMbv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAFF1C4CECF;
	Wed,  6 Nov 2024 00:59:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1730854775;
	bh=e5exgv4qmeZ4rRrpSTVDSzrTkStyJVm8f1CQytGJCgo=;
	h=Date:To:From:Subject:From;
	b=YgfNaMbvBEGhZQ/gbaVf80jK9dTm3yGSrc48rdUpQSGOVZtptHemwfH+LdyrfyFP9
	 nY9NSbvqcU0BkAtjieS9/q/GKwhQ4yG8m8incCW40SWPPFCDsS6TBMV6yFA/W/G/aZ
	 UkWvCkIjZ5GWs7TCGpTt4v3yaK0q937UrHf7Qla8=
Date: Tue, 05 Nov 2024 16:59:35 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,peterx@redhat.com,muchun.song@linux.dev,mhocko@suse.com,lorenzo.stoakes@oracle.com,donettom@linux.ibm.com,david@redhat.com,osalvador@suse.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] arch-powerpc-teach-book3s64-arch_get_unmapped_area_topdown-to-handle-hugetlb-mappings.patch removed from -mm tree
Message-Id: <20241106005935.AAFF1C4CECF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: arch/powerpc: teach book3s64 arch_get_unmapped_area{_topdown} to handle hugetlb mappings
has been removed from the -mm tree.  Its filename was
     arch-powerpc-teach-book3s64-arch_get_unmapped_area_topdown-to-handle-hugetlb-mappings.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Oscar Salvador <osalvador@suse.de>
Subject: arch/powerpc: teach book3s64 arch_get_unmapped_area{_topdown} to handle hugetlb mappings
Date: Mon, 7 Oct 2024 09:50:33 +0200

We want to stop special casing hugetlb mappings and make them go through
generic channels, so teach arch_get_unmapped_area{_topdown} to handle
those.

Reshuffle file_to_psize() definition so arch_get_unmapped_area{_topdown}
can make use of it.

Link: https://lkml.kernel.org/r/20241007075037.267650-6-osalvador@suse.de
Signed-off-by: Oscar Salvador <osalvador@suse.de>
Cc: David Hildenbrand <david@redhat.com>
Cc: Donet Tom <donettom@linux.ibm.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Peter Xu <peterx@redhat.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/mm/book3s64/slice.c |   40 +++++++++++++++++++++--------
 1 file changed, 30 insertions(+), 10 deletions(-)

--- a/arch/powerpc/mm/book3s64/slice.c~arch-powerpc-teach-book3s64-arch_get_unmapped_area_topdown-to-handle-hugetlb-mappings
+++ a/arch/powerpc/mm/book3s64/slice.c
@@ -633,6 +633,20 @@ return_addr:
 }
 EXPORT_SYMBOL_GPL(slice_get_unmapped_area);
 
+#ifdef CONFIG_HUGETLB_PAGE
+static int file_to_psize(struct file *file)
+{
+	struct hstate *hstate = hstate_file(file);
+
+	return shift_to_mmu_psize(huge_page_shift(hstate));
+}
+#else
+static int file_to_psize(struct file *file)
+{
+	return 0;
+}
+#endif
+
 unsigned long arch_get_unmapped_area(struct file *filp,
 				     unsigned long addr,
 				     unsigned long len,
@@ -640,11 +654,17 @@ unsigned long arch_get_unmapped_area(str
 				     unsigned long flags,
 				     vm_flags_t vm_flags)
 {
+	unsigned int psize;
+
 	if (radix_enabled())
 		return generic_get_unmapped_area(filp, addr, len, pgoff, flags, vm_flags);
 
-	return slice_get_unmapped_area(addr, len, flags,
-				       mm_ctx_user_psize(&current->mm->context), 0);
+	if (filp && is_file_hugepages(filp))
+		psize = file_to_psize(filp);
+	else
+		psize = mm_ctx_user_psize(&current->mm->context);
+
+	return slice_get_unmapped_area(addr, len, flags, psize, 0);
 }
 
 unsigned long arch_get_unmapped_area_topdown(struct file *filp,
@@ -654,11 +674,17 @@ unsigned long arch_get_unmapped_area_top
 					     const unsigned long flags,
 					     vm_flags_t vm_flags)
 {
+	unsigned int psize;
+
 	if (radix_enabled())
 		return generic_get_unmapped_area_topdown(filp, addr0, len, pgoff, flags, vm_flags);
 
-	return slice_get_unmapped_area(addr0, len, flags,
-				       mm_ctx_user_psize(&current->mm->context), 1);
+	if (filp && is_file_hugepages(filp))
+		psize = file_to_psize(filp);
+	else
+		psize = mm_ctx_user_psize(&current->mm->context);
+
+	return slice_get_unmapped_area(addr0, len, flags, psize, 1);
 }
 
 unsigned int notrace get_slice_psize(struct mm_struct *mm, unsigned long addr)
@@ -789,12 +815,6 @@ unsigned long vma_mmu_pagesize(struct vm
 	return 1UL << mmu_psize_to_shift(get_slice_psize(vma->vm_mm, vma->vm_start));
 }
 
-static int file_to_psize(struct file *file)
-{
-	struct hstate *hstate = hstate_file(file);
-	return shift_to_mmu_psize(huge_page_shift(hstate));
-}
-
 unsigned long hugetlb_get_unmapped_area(struct file *file, unsigned long addr,
 					unsigned long len, unsigned long pgoff,
 					unsigned long flags)
_

Patches currently in -mm which might be from osalvador@suse.de are


