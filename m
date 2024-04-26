Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D130D7F7DA
	for <mm-commits@vger.kernel.org>; Fri, 26 Apr 2024 04:01:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714104086; cv=none; b=BlCxyrxHkk0z4bKz25vidmeitVZnXNrQSnGFSVS4NAdbjBwWA2ZneHTHEd5tCWT4KLSjOwQHKxcGfLjR3l2YpPLhgB8XQ1gWxiLe9EIETdHtzl+WwTe64dizbz7YKWX2LFYzL6FdufVT8qcqChNhU/xlv32TmtbgmgH+q9De300=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714104086; c=relaxed/simple;
	bh=v2uWut8KxLtex5nXpWy2vLKcnCp31EZJLLPAbeS5dnU=;
	h=Date:To:From:Subject:Message-Id; b=YtAJDOYwJwQSRJKbruxyS4jaB30xXYJAbiIJAGsUaqROn0RkNIKZXkK7gQP/2qpe4t6efy599WzZgs3R3AAiKKF4ivv8C2iuyGz7pofj9cwauFl9+orbpdspJZpRP7i255eFdpAqvbrCZeZX0EZdSm6KLqIZkx8ZwQCm51/pN8I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=rvqNn+g8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="rvqNn+g8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A50E8C113CD;
	Fri, 26 Apr 2024 04:01:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714104086;
	bh=v2uWut8KxLtex5nXpWy2vLKcnCp31EZJLLPAbeS5dnU=;
	h=Date:To:From:Subject:From;
	b=rvqNn+g8FMkvh3Ix9aj//XWcJRJgWiZHQDeesFIBxUureYRhQWbzG1QkHucNtsiPQ
	 wCb3c1lsmq3ucv7RMrZLC4dpM8pBriG7w4fTE6q44Rx7X1jq3p0IjUn7dBZy/qyVCS
	 kNuYLhGtvJBuHNxa/qjDuQQr2CqFp2SVZKnDpk9Y=
Date: Thu, 25 Apr 2024 21:01:26 -0700
To: mm-commits@vger.kernel.org,tglx@linutronix.de,peterz@infradead.org,npiggin@gmail.com,naveen.n.rao@linux.ibm.com,mpe@ellerman.id.au,mingo@redhat.com,luto@kernel.org,Liam.Howlett@oracle.com,kirill.shutemov@linux.intel.com,keescook@chromium.org,James.Bottomley@HansenPartnership.com,hpa@zytor.com,guoren@kernel.org,deller@gmx.de,debug@rivosinc.com,dave.hansen@linux.intel.com,dan.j.williams@intel.com,christophe.leroy@csgroup.eu,broonie@kernel.org,bp@alien8.de,ast@kernel.org,aneesh.kumar@kernel.org,rick.p.edgecombe@intel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] thp-add-thp_get_unmapped_area_vmflags.patch removed from -mm tree
Message-Id: <20240426040126.A50E8C113CD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: thp: add thp_get_unmapped_area_vmflags()
has been removed from the -mm tree.  Its filename was
     thp-add-thp_get_unmapped_area_vmflags.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Rick Edgecombe <rick.p.edgecombe@intel.com>
Subject: thp: add thp_get_unmapped_area_vmflags()
Date: Mon, 25 Mar 2024 19:16:48 -0700

When memory is being placed, mmap() will take care to respect the guard
gaps of certain types of memory (VM_SHADOWSTACK, VM_GROWSUP and
VM_GROWSDOWN).  In order to ensure guard gaps between mappings, mmap()
needs to consider two things:

 1. That the new mapping isn't placed in an any existing mappings guard
    gaps.
 2. That the new mapping isn't placed such that any existing mappings
    are not in *its* guard gaps.

The longstanding behavior of mmap() is to ensure 1, but not take any care
around 2.  So for example, if there is a PAGE_SIZE free area, and a mmap()
with a PAGE_SIZE size, and a type that has a guard gap is being placed,
mmap() may place the shadow stack in the PAGE_SIZE free area.  Then the
mapping that is supposed to have a guard gap will not have a gap to the
adjacent VMA.

Add a THP implementations of the vm_flags variant of get_unmapped_area(). 
Future changes will call this from mmap.c in the do_mmap() path to allow
shadow stacks to be placed with consideration taken for the start guard
gap.  Shadow stack memory is always private and anonymous and so special
guard gap logic is not needed in a lot of caseis, but it can be mapped by
THP, so needs to be handled.

Link: https://lkml.kernel.org/r/20240326021656.202649-7-rick.p.edgecombe@intel.com
Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
Reviewed-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Aneesh Kumar K.V <aneesh.kumar@kernel.org>
Cc: Borislav Petkov (AMD) <bp@alien8.de>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Deepak Gupta <debug@rivosinc.com>
Cc: Guo Ren <guoren@kernel.org>
Cc: Helge Deller <deller@gmx.de>
Cc: H. Peter Anvin (Intel) <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Mark Brown <broonie@kernel.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Naveen N. Rao <naveen.n.rao@linux.ibm.com>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/huge_mm.h |   11 +++++++++++
 mm/huge_memory.c        |   23 ++++++++++++++++-------
 mm/mmap.c               |   12 +++++++-----
 3 files changed, 34 insertions(+), 12 deletions(-)

--- a/include/linux/huge_mm.h~thp-add-thp_get_unmapped_area_vmflags
+++ a/include/linux/huge_mm.h
@@ -270,6 +270,9 @@ unsigned long thp_vma_allowable_orders(s
 
 unsigned long thp_get_unmapped_area(struct file *filp, unsigned long addr,
 		unsigned long len, unsigned long pgoff, unsigned long flags);
+unsigned long thp_get_unmapped_area_vmflags(struct file *filp, unsigned long addr,
+		unsigned long len, unsigned long pgoff, unsigned long flags,
+		vm_flags_t vm_flags);
 
 bool can_split_folio(struct folio *folio, int *pextra_pins);
 int split_huge_page_to_list_to_order(struct page *page, struct list_head *list,
@@ -413,6 +416,14 @@ static inline unsigned long thp_vma_allo
 
 #define thp_get_unmapped_area	NULL
 
+static inline unsigned long
+thp_get_unmapped_area_vmflags(struct file *filp, unsigned long addr,
+			      unsigned long len, unsigned long pgoff,
+			      unsigned long flags, vm_flags_t vm_flags)
+{
+	return 0;
+}
+
 static inline bool
 can_split_folio(struct folio *folio, int *pextra_pins)
 {
--- a/mm/huge_memory.c~thp-add-thp_get_unmapped_area_vmflags
+++ a/mm/huge_memory.c
@@ -800,7 +800,8 @@ static inline bool is_transparent_hugepa
 
 static unsigned long __thp_get_unmapped_area(struct file *filp,
 		unsigned long addr, unsigned long len,
-		loff_t off, unsigned long flags, unsigned long size)
+		loff_t off, unsigned long flags, unsigned long size,
+		vm_flags_t vm_flags)
 {
 	loff_t off_end = off + len;
 	loff_t off_align = round_up(off, size);
@@ -816,8 +817,8 @@ static unsigned long __thp_get_unmapped_
 	if (len_pad < len || (off + len_pad) < off)
 		return 0;
 
-	ret = mm_get_unmapped_area(current->mm, filp, addr, len_pad,
-				   off >> PAGE_SHIFT, flags);
+	ret = mm_get_unmapped_area_vmflags(current->mm, filp, addr, len_pad,
+					   off >> PAGE_SHIFT, flags, vm_flags);
 
 	/*
 	 * The failure might be due to length padding. The caller will retry
@@ -842,17 +843,25 @@ static unsigned long __thp_get_unmapped_
 	return ret;
 }
 
-unsigned long thp_get_unmapped_area(struct file *filp, unsigned long addr,
-		unsigned long len, unsigned long pgoff, unsigned long flags)
+unsigned long thp_get_unmapped_area_vmflags(struct file *filp, unsigned long addr,
+		unsigned long len, unsigned long pgoff, unsigned long flags,
+		vm_flags_t vm_flags)
 {
 	unsigned long ret;
 	loff_t off = (loff_t)pgoff << PAGE_SHIFT;
 
-	ret = __thp_get_unmapped_area(filp, addr, len, off, flags, PMD_SIZE);
+	ret = __thp_get_unmapped_area(filp, addr, len, off, flags, PMD_SIZE, vm_flags);
 	if (ret)
 		return ret;
 
-	return mm_get_unmapped_area(current->mm, filp, addr, len, pgoff, flags);
+	return mm_get_unmapped_area_vmflags(current->mm, filp, addr, len, pgoff, flags,
+					    vm_flags);
+}
+
+unsigned long thp_get_unmapped_area(struct file *filp, unsigned long addr,
+		unsigned long len, unsigned long pgoff, unsigned long flags)
+{
+	return thp_get_unmapped_area_vmflags(filp, addr, len, pgoff, flags, 0);
 }
 EXPORT_SYMBOL_GPL(thp_get_unmapped_area);
 
--- a/mm/mmap.c~thp-add-thp_get_unmapped_area_vmflags
+++ a/mm/mmap.c
@@ -1860,20 +1860,22 @@ __get_unmapped_area(struct file *file, u
 		 * so use shmem's get_unmapped_area in case it can be huge.
 		 */
 		get_area = shmem_get_unmapped_area;
-	} else if (IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE)) {
-		/* Ensures that larger anonymous mappings are THP aligned. */
-		get_area = thp_get_unmapped_area;
 	}
 
 	/* Always treat pgoff as zero for anonymous memory. */
 	if (!file)
 		pgoff = 0;
 
-	if (get_area)
+	if (get_area) {
 		addr = get_area(file, addr, len, pgoff, flags);
-	else
+	} else if (IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE)) {
+		/* Ensures that larger anonymous mappings are THP aligned. */
+		addr = thp_get_unmapped_area_vmflags(file, addr, len,
+						     pgoff, flags, vm_flags);
+	} else {
 		addr = mm_get_unmapped_area_vmflags(current->mm, file, addr, len,
 						    pgoff, flags, vm_flags);
+	}
 	if (IS_ERR_VALUE(addr))
 		return addr;
 
_

Patches currently in -mm which might be from rick.p.edgecombe@intel.com are


