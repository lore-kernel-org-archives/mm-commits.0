Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C99027FBB6
	for <mm-commits@vger.kernel.org>; Fri, 26 Apr 2024 04:01:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714104094; cv=none; b=hUn+RbpuYNUjCUNQSBDg5NecQ4eyvkx2F1CFKGhKWvdtBYPvei35zFkEGc+AN2QWUsv5yaDex1rWvaTaeMZUkxzAZX3VqukThQXXtcH5W6Erm0IOb08s84qiKFusK/3qJPChblo5DCttIG39zpiS66JddRrch/MHhexCNCdfKlk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714104094; c=relaxed/simple;
	bh=gUehdHvomtFnATd2VBOPUoAi26fKGwqcAvwbJ+ejKQM=;
	h=Date:To:From:Subject:Message-Id; b=ER2ZD89L6kkokbec4rMjluny1brDDSraIudyWIZj9YRTXDhgkzu+I2l5Aj3qiD8/yoSHJFD1uW27svtnNLdNbSKOj0E7r8GiKHkRjXE3sbU93HXYxks0AHJFjHZMcdG2nvItVEWBBLSJ/Kt8E+H1knnW6ZNQOUgU35dSl6hup3w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ih8M9nnW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ih8M9nnW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EE34C113CD;
	Fri, 26 Apr 2024 04:01:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714104094;
	bh=gUehdHvomtFnATd2VBOPUoAi26fKGwqcAvwbJ+ejKQM=;
	h=Date:To:From:Subject:From;
	b=ih8M9nnWyDDyOTUPgqsvNgKFPlp3T09DAaGGz5muV7+eOVdT3o03yvf5xWBfihHUQ
	 9+B8IXfoVI3AkPIklym5XFh/CD+pMjISWNxzNTIQdD3Y3M0TipTpLYXfIw1PaXOH5y
	 +JYm88ZNyZd63gqIyTa6Dh1c5LXNcf00KOSdwtpo=
Date: Thu, 25 Apr 2024 21:01:34 -0700
To: mm-commits@vger.kernel.org,tglx@linutronix.de,peterz@infradead.org,npiggin@gmail.com,naveen.n.rao@linux.ibm.com,mpe@ellerman.id.au,mingo@redhat.com,luto@kernel.org,Liam.Howlett@oracle.com,kirill.shutemov@linux.intel.com,keescook@chromium.org,James.Bottomley@HansenPartnership.com,hpa@zytor.com,guoren@kernel.org,deller@gmx.de,debug@rivosinc.com,dave.hansen@linux.intel.com,dan.j.williams@intel.com,christophe.leroy@csgroup.eu,broonie@kernel.org,bp@alien8.de,ast@kernel.org,aneesh.kumar@kernel.org,rick.p.edgecombe@intel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] x86-mm-implement-have_arch_unmapped_area_vmflags.patch removed from -mm tree
Message-Id: <20240426040134.9EE34C113CD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: x86/mm: implement HAVE_ARCH_UNMAPPED_AREA_VMFLAGS
has been removed from the -mm tree.  Its filename was
     x86-mm-implement-have_arch_unmapped_area_vmflags.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Rick Edgecombe <rick.p.edgecombe@intel.com>
Subject: x86/mm: implement HAVE_ARCH_UNMAPPED_AREA_VMFLAGS
Date: Mon, 25 Mar 2024 19:16:54 -0700

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

Add x86 arch implementations of arch_get_unmapped_area_vmflags/_topdown()
so future changes can allow the guard gap of type of vma being placed to
be taken into account.  This will be used for shadow stack memory.

Link: https://lkml.kernel.org/r/20240326021656.202649-13-rick.p.edgecombe@intel.com
Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Aneesh Kumar K.V <aneesh.kumar@kernel.org>
Cc: Borislav Petkov (AMD) <bp@alien8.de>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
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

 arch/x86/include/asm/pgtable_64.h |    1 +
 arch/x86/kernel/sys_x86_64.c      |   25 ++++++++++++++++++++-----
 2 files changed, 21 insertions(+), 5 deletions(-)

--- a/arch/x86/include/asm/pgtable_64.h~x86-mm-implement-have_arch_unmapped_area_vmflags
+++ a/arch/x86/include/asm/pgtable_64.h
@@ -245,6 +245,7 @@ extern void cleanup_highmap(void);
 
 #define HAVE_ARCH_UNMAPPED_AREA
 #define HAVE_ARCH_UNMAPPED_AREA_TOPDOWN
+#define HAVE_ARCH_UNMAPPED_AREA_VMFLAGS
 
 #define PAGE_AGP    PAGE_KERNEL_NOCACHE
 #define HAVE_PAGE_AGP 1
--- a/arch/x86/kernel/sys_x86_64.c~x86-mm-implement-have_arch_unmapped_area_vmflags
+++ a/arch/x86/kernel/sys_x86_64.c
@@ -113,8 +113,8 @@ static void find_start_end(unsigned long
 }
 
 unsigned long
-arch_get_unmapped_area(struct file *filp, unsigned long addr,
-		unsigned long len, unsigned long pgoff, unsigned long flags)
+arch_get_unmapped_area_vmflags(struct file *filp, unsigned long addr, unsigned long len,
+		       unsigned long pgoff, unsigned long flags, vm_flags_t vm_flags)
 {
 	struct mm_struct *mm = current->mm;
 	struct vm_area_struct *vma;
@@ -149,9 +149,9 @@ arch_get_unmapped_area(struct file *filp
 }
 
 unsigned long
-arch_get_unmapped_area_topdown(struct file *filp, const unsigned long addr0,
-			  const unsigned long len, const unsigned long pgoff,
-			  const unsigned long flags)
+arch_get_unmapped_area_topdown_vmflags(struct file *filp, unsigned long addr0,
+			  unsigned long len, unsigned long pgoff,
+			  unsigned long flags, vm_flags_t vm_flags)
 {
 	struct vm_area_struct *vma;
 	struct mm_struct *mm = current->mm;
@@ -220,3 +220,18 @@ bottomup:
 	 */
 	return arch_get_unmapped_area(filp, addr0, len, pgoff, flags);
 }
+
+unsigned long
+arch_get_unmapped_area(struct file *filp, unsigned long addr,
+		unsigned long len, unsigned long pgoff, unsigned long flags)
+{
+	return arch_get_unmapped_area_vmflags(filp, addr, len, pgoff, flags, 0);
+}
+
+unsigned long
+arch_get_unmapped_area_topdown(struct file *filp, const unsigned long addr,
+			  const unsigned long len, const unsigned long pgoff,
+			  const unsigned long flags)
+{
+	return arch_get_unmapped_area_topdown_vmflags(filp, addr, len, pgoff, flags, 0);
+}
_

Patches currently in -mm which might be from rick.p.edgecombe@intel.com are


