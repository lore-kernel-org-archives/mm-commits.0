Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76A54189BBD
	for <mm-commits@vger.kernel.org>; Mon,  7 Oct 2024 21:07:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728335260; cv=none; b=r+xUDKRqD/8HREoezMcHDCjlqMhMfhVn06huylbBpJdNa7BxM1G6jujBcODb1hzktsQplfOKkNhUz1oxSzsAkse+sYwMIWBfUh+Vgds/lbtW66HwYGGJ8hF4lq3VILNbhhbAkC7l3+kzGA60S6bleM8eKSqFTWeueH84GywlP9w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728335260; c=relaxed/simple;
	bh=RsWZ6xEjCfqMmoCym+89U34mop36ZawCr1Y5FZp1VjY=;
	h=Date:To:From:Subject:Message-Id; b=CXDLw5uQEtjsepMKTLYMTHRQ+YIeZb2CEl3c8LDbIYr1WKIYyPvMKRslJ32/MAso53r/6a6pKr4UOjVyGWaQXHFKTU9CIBbmkW9vkufIsclMJz2/J3k6mr4DJvNL91k32aRh+MKM/X6/E52Mdrvc/SPBpuHCDZC3bvx7v6uQ/yA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=JmD9aB72; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="JmD9aB72"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45C81C4CEC6;
	Mon,  7 Oct 2024 21:07:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1728335260;
	bh=RsWZ6xEjCfqMmoCym+89U34mop36ZawCr1Y5FZp1VjY=;
	h=Date:To:From:Subject:From;
	b=JmD9aB72D2bkYBcZARyUuhUQQVKLSIXNIP92z+6fS5ICDBhemDKJx3q3K+2yNUzIV
	 x+9obBbRJRKSy7rcKpD7zCs+bB6VdX8gs6708yo8iOWUxsGJPNm1+TZVbiv2TJDRf2
	 a2/s28m2jhbLLWTDvsrXo65ZeKKVKrW5vkjpoU60=
Date: Mon, 07 Oct 2024 14:07:39 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,peterx@redhat.com,muchun.song@linux.dev,mhocko@suse.com,lorenzo.stoakes@oracle.com,donettom@linux.ibm.com,david@redhat.com,osalvador@suse.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + arch-powerpc-teach-book3s64-arch_get_unmapped_area_topdown-to-handle-hugetlb-mappings.patch added to mm-unstable branch
Message-Id: <20241007210740.45C81C4CEC6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: arch/powerpc: teach book3s64 arch_get_unmapped_area{_topdown} to handle hugetlb mappings
has been added to the -mm mm-unstable branch.  Its filename is
     arch-powerpc-teach-book3s64-arch_get_unmapped_area_topdown-to-handle-hugetlb-mappings.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/arch-powerpc-teach-book3s64-arch_get_unmapped_area_topdown-to-handle-hugetlb-mappings.patch

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

mm-mmap-teach-generic_get_unmapped_area_topdown-to-handle-hugetlb-mappings.patch
arch-s390-teach-arch_get_unmapped_area_topdown-to-handle-hugetlb-mappings.patch
arch-x86-teach-arch_get_unmapped_area_vmflags-to-handle-hugetlb-mappings.patch
arch-sparc-teach-arch_get_unmapped_area_topdown-to-handle-hugetlb-mappings.patch
arch-powerpc-teach-book3s64-arch_get_unmapped_area_topdown-to-handle-hugetlb-mappings.patch
mm-make-hugetlb-mappings-go-through-mm_get_unmapped_area_vmflags.patch
mm-drop-hugetlb_get_unmapped_area_-functions.patch
arch-s390-clean-up-hugetlb-definitions.patch
mm-consolidate-common-checks-in-hugetlb_get_unmapped_area.patch

