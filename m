Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82B567FBD2
	for <mm-commits@vger.kernel.org>; Fri, 26 Apr 2024 04:01:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714104085; cv=none; b=cYZCs7icEtO//TdlKY0FpmYiC1RbAr9jciBE3ZU5TVVMwS0MXB8DfQ5oEljEbFt3Xt7/DbXbUDfOm7y6gHggIXkkDwlN+jUhi7x/4E6UuK6RMDxmddsF16Z2uKs7IFlXFzSotdBoAzqvPQD0iaDTn5dTUq8qwuPLOsr7AEhbs+8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714104085; c=relaxed/simple;
	bh=UpRxr8idhzXuZNY4Ew+7RXDEEPiNHgoYzjgXIChnaNc=;
	h=Date:To:From:Subject:Message-Id; b=pEOkHMWUETPNjU5ZmRaMK1WnXrRCGISYP1Z7AM/qN4XSJsTgJfmmOmguka7jsDeER0fVWuN+HXNx5fL6+n5Gsf2hxRvay6lFxkH5qlYtGclk/WI9IOFUFX8eqeSueqMIB03c297I+BT7QUOD/+gC6BN1mmwXvQpvj1TMm6d4kiI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=KbpM06EM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="KbpM06EM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58D1FC113CD;
	Fri, 26 Apr 2024 04:01:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714104085;
	bh=UpRxr8idhzXuZNY4Ew+7RXDEEPiNHgoYzjgXIChnaNc=;
	h=Date:To:From:Subject:From;
	b=KbpM06EMTX1ybgEFw7ncEZXy0GHOPmwRtU3+Kn/G/TqYRHL9e0euW1dsyYyAnsocR
	 yQmE2o55Kc2U5Bsca6dmRHJmW9gDr/AGekKJyO95o8yTaTtxnMYe9p+2fQgiyKsvwB
	 AzPIN4WNorFi2t9faaIqmOV0yHZnk5GbEoQrynMg=
Date: Thu, 25 Apr 2024 21:01:24 -0700
To: mm-commits@vger.kernel.org,tglx@linutronix.de,peterz@infradead.org,npiggin@gmail.com,naveen.n.rao@linux.ibm.com,mpe@ellerman.id.au,mingo@redhat.com,luto@kernel.org,Liam.Howlett@oracle.com,kirill.shutemov@linux.intel.com,keescook@chromium.org,James.Bottomley@HansenPartnership.com,hpa@zytor.com,guoren@kernel.org,deller@gmx.de,debug@rivosinc.com,dave.hansen@linux.intel.com,dan.j.williams@intel.com,christophe.leroy@csgroup.eu,broonie@kernel.org,bp@alien8.de,ast@kernel.org,aneesh.kumar@kernel.org,rick.p.edgecombe@intel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-use-get_unmapped_area_vmflags.patch removed from -mm tree
Message-Id: <20240426040125.58D1FC113CD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: use get_unmapped_area_vmflags()
has been removed from the -mm tree.  Its filename was
     mm-use-get_unmapped_area_vmflags.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Rick Edgecombe <rick.p.edgecombe@intel.com>
Subject: mm: use get_unmapped_area_vmflags()
Date: Mon, 25 Mar 2024 19:16:47 -0700

When memory is being placed, mmap() will take care to respect the guard
gaps of certain types of memory (VM_SHADOWSTACK, VM_GROWSUP and
VM_GROWSDOWN).  In order to ensure guard gaps between mappings, mmap()
needs to consider two things:

 1. That the new mapping isn't placed in an any existing mappings guard
    gaps.
 2. That the new mapping isn't placed such that any existing mappings
    are not in *its* guard gaps.

The long standing behavior of mmap() is to ensure 1, but not take any care
around 2.  So for example, if there is a PAGE_SIZE free area, and a mmap()
with a PAGE_SIZE size, and a type that has a guard gap is being placed,
mmap() may place the shadow stack in the PAGE_SIZE free area.  Then the
mapping that is supposed to have a guard gap will not have a gap to the
adjacent VMA.

Use mm_get_unmapped_area_vmflags() in the do_mmap() so future changes can
cause shadow stack mappings to be placed with a guard gap.  Also use the
THP variant that takes vm_flags, such that THP shadow stack can get the
same treatment.  Adjust the vm_flags calculation to happen earlier so that
the vm_flags can be passed into __get_unmapped_area().

Link: https://lkml.kernel.org/r/20240326021656.202649-6-rick.p.edgecombe@intel.com
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

 include/linux/mm.h |   11 ++++++++++-
 mm/mmap.c          |   32 ++++++++++++++++----------------
 2 files changed, 26 insertions(+), 17 deletions(-)

--- a/include/linux/mm.h~mm-use-get_unmapped_area_vmflags
+++ a/include/linux/mm.h
@@ -3413,7 +3413,16 @@ extern int install_special_mapping(struc
 unsigned long randomize_stack_top(unsigned long stack_top);
 unsigned long randomize_page(unsigned long start, unsigned long range);
 
-extern unsigned long get_unmapped_area(struct file *, unsigned long, unsigned long, unsigned long, unsigned long);
+unsigned long
+__get_unmapped_area(struct file *file, unsigned long addr, unsigned long len,
+		    unsigned long pgoff, unsigned long flags, vm_flags_t vm_flags);
+
+static inline unsigned long
+get_unmapped_area(struct file *file, unsigned long addr, unsigned long len,
+		  unsigned long pgoff, unsigned long flags)
+{
+	return __get_unmapped_area(file, addr, len, pgoff, flags, 0);
+}
 
 extern unsigned long mmap_region(struct file *file, unsigned long addr,
 	unsigned long len, vm_flags_t vm_flags, unsigned long pgoff,
--- a/mm/mmap.c~mm-use-get_unmapped_area_vmflags
+++ a/mm/mmap.c
@@ -1255,18 +1255,6 @@ unsigned long do_mmap(struct file *file,
 	if (mm->map_count > sysctl_max_map_count)
 		return -ENOMEM;
 
-	/* Obtain the address to map to. we verify (or select) it and ensure
-	 * that it represents a valid section of the address space.
-	 */
-	addr = get_unmapped_area(file, addr, len, pgoff, flags);
-	if (IS_ERR_VALUE(addr))
-		return addr;
-
-	if (flags & MAP_FIXED_NOREPLACE) {
-		if (find_vma_intersection(mm, addr, addr + len))
-			return -EEXIST;
-	}
-
 	if (prot == PROT_EXEC) {
 		pkey = execute_only_pkey(mm);
 		if (pkey < 0)
@@ -1280,6 +1268,18 @@ unsigned long do_mmap(struct file *file,
 	vm_flags |= calc_vm_prot_bits(prot, pkey) | calc_vm_flag_bits(flags) |
 			mm->def_flags | VM_MAYREAD | VM_MAYWRITE | VM_MAYEXEC;
 
+	/* Obtain the address to map to. we verify (or select) it and ensure
+	 * that it represents a valid section of the address space.
+	 */
+	addr = __get_unmapped_area(file, addr, len, pgoff, flags, vm_flags);
+	if (IS_ERR_VALUE(addr))
+		return addr;
+
+	if (flags & MAP_FIXED_NOREPLACE) {
+		if (find_vma_intersection(mm, addr, addr + len))
+			return -EEXIST;
+	}
+
 	if (flags & MAP_LOCKED)
 		if (!can_do_mlock())
 			return -EPERM;
@@ -1836,8 +1836,8 @@ unsigned long mm_get_unmapped_area_vmfla
 }
 
 unsigned long
-get_unmapped_area(struct file *file, unsigned long addr, unsigned long len,
-		unsigned long pgoff, unsigned long flags)
+__get_unmapped_area(struct file *file, unsigned long addr, unsigned long len,
+		unsigned long pgoff, unsigned long flags, vm_flags_t vm_flags)
 {
 	unsigned long (*get_area)(struct file *, unsigned long,
 				  unsigned long, unsigned long, unsigned long)
@@ -1872,8 +1872,8 @@ get_unmapped_area(struct file *file, uns
 	if (get_area)
 		addr = get_area(file, addr, len, pgoff, flags);
 	else
-		addr = mm_get_unmapped_area(current->mm, file, addr, len,
-					    pgoff, flags);
+		addr = mm_get_unmapped_area_vmflags(current->mm, file, addr, len,
+						    pgoff, flags, vm_flags);
 	if (IS_ERR_VALUE(addr))
 		return addr;
 
_

Patches currently in -mm which might be from rick.p.edgecombe@intel.com are


