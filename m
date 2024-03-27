Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3A5C2D047
	for <mm-commits@vger.kernel.org>; Wed, 27 Mar 2024 20:11:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711570314; cv=none; b=c2tYBp8jlhC6YL7AnHAEmS9X40esKtYgy+g7YOQObSn/ZQUxZgyIM4JDeyAD/5uq0Rh9pwx7ZAlAUrHiQNKaDRC01r15ocHvOkk3sa/DtGccTLumi4t66QaYPvBlHw+QcCUmKf+cHD3eMkBVVnI2yppPgqMVFSly1iLuPdjnDzA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711570314; c=relaxed/simple;
	bh=9RjC61KHrvRQRmU1j76vh0EuD+NClg+aReSm+DJaZkM=;
	h=Date:To:From:Subject:Message-Id; b=DxlVi6YC/uVx8aA9loQ9q9UaSuHoofMDnkAgWe7xzW9zMWeQP5henzeHb+sWlcwLLjrKl/0ri0RZwNrODvZ/my0h4k49656XIx6RnlRR9WuG9fcMSwQ/Y0R5FZCJRLUx1dN4Wfp4kt+tOzy+/FBPn7KmN+QmJ8FSdmbv0nytlaQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=2amX9QHA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="2amX9QHA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56DA7C433C7;
	Wed, 27 Mar 2024 20:11:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1711570313;
	bh=9RjC61KHrvRQRmU1j76vh0EuD+NClg+aReSm+DJaZkM=;
	h=Date:To:From:Subject:From;
	b=2amX9QHAf2jDOxACge60m5UhgLza4j9LGfFvf781FbB4B+39SQkoJbzsw2w3KE8NH
	 HZ4HyQcRbAkEN2dgtNbNZdswaTvz8Rbd0Dh2ol0e1QZSdhiLh7VKRxK9H1HSry5TRQ
	 5xsvqdOE1jALbB9SRABRaHdRZWRFyDw9tEjQeVYw=
Date: Wed, 27 Mar 2024 13:11:52 -0700
To: mm-commits@vger.kernel.org,tglx@linutronix.de,peterz@infradead.org,npiggin@gmail.com,naveen.n.rao@linux.ibm.com,mpe@ellerman.id.au,mingo@redhat.com,luto@kernel.org,Liam.Howlett@oracle.com,kirill.shutemov@linux.intel.com,keescook@chromium.org,James.Bottomley@HansenPartnership.com,hpa@zytor.com,guoren@kernel.org,deller@gmx.de,debug@rivosinc.com,dave.hansen@linux.intel.com,dan.j.williams@intel.com,christophe.leroy@csgroup.eu,broonie@kernel.org,bp@alien8.de,ast@kernel.org,aneesh.kumar@kernel.org,rick.p.edgecombe@intel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + x86-mm-care-about-shadow-stack-guard-gap-during-placement.patch added to mm-unstable branch
Message-Id: <20240327201153.56DA7C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: x86/mm: care about shadow stack guard gap during placement
has been added to the -mm mm-unstable branch.  Its filename is
     x86-mm-care-about-shadow-stack-guard-gap-during-placement.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/x86-mm-care-about-shadow-stack-guard-gap-during-placement.patch

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
From: Rick Edgecombe <rick.p.edgecombe@intel.com>
Subject: x86/mm: care about shadow stack guard gap during placement
Date: Mon, 25 Mar 2024 19:16:55 -0700

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

Now that the vm_flags is passed into the arch get_unmapped_area()'s, and
vm_unmapped_area() is ready to consider it, have VM_SHADOW_STACK's get
guard gap consideration for scenario 2.

Link: https://lkml.kernel.org/r/20240326021656.202649-14-rick.p.edgecombe@intel.com
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

 arch/x86/kernel/sys_x86_64.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/arch/x86/kernel/sys_x86_64.c~x86-mm-care-about-shadow-stack-guard-gap-during-placement
+++ a/arch/x86/kernel/sys_x86_64.c
@@ -112,6 +112,14 @@ static void find_start_end(unsigned long
 		*end = task_size_64bit(addr > DEFAULT_MAP_WINDOW);
 }
 
+static inline unsigned long stack_guard_placement(vm_flags_t vm_flags)
+{
+	if (vm_flags & VM_SHADOW_STACK)
+		return PAGE_SIZE;
+
+	return 0;
+}
+
 unsigned long
 arch_get_unmapped_area_vmflags(struct file *filp, unsigned long addr, unsigned long len,
 		       unsigned long pgoff, unsigned long flags, vm_flags_t vm_flags)
@@ -141,6 +149,7 @@ arch_get_unmapped_area_vmflags(struct fi
 	info.low_limit = begin;
 	info.high_limit = end;
 	info.align_offset = pgoff << PAGE_SHIFT;
+	info.start_gap = stack_guard_placement(vm_flags);
 	if (filp) {
 		info.align_mask = get_align_mask();
 		info.align_offset += get_align_bits();
@@ -190,6 +199,7 @@ get_unmapped_area:
 		info.low_limit = PAGE_SIZE;
 
 	info.high_limit = get_mmap_base(0);
+	info.start_gap = stack_guard_placement(vm_flags);
 
 	/*
 	 * If hint address is above DEFAULT_MAP_WINDOW, look for unmapped area
_

Patches currently in -mm which might be from rick.p.edgecombe@intel.com are

proc-refactor-pde_get_unmapped_area-as-prep.patch
mm-switch-mm-get_unmapped_area-to-a-flag.patch
mm-introduce-arch_get_unmapped_area_vmflags.patch
mm-remove-export-for-get_unmapped_area.patch
mm-use-get_unmapped_area_vmflags.patch
thp-add-thp_get_unmapped_area_vmflags.patch
csky-use-initializer-for-struct-vm_unmapped_area_info.patch
parisc-use-initializer-for-struct-vm_unmapped_area_info.patch
powerpc-use-initializer-for-struct-vm_unmapped_area_info.patch
treewide-use-initializer-for-struct-vm_unmapped_area_info.patch
mm-take-placement-mappings-gap-into-account.patch
x86-mm-implement-have_arch_unmapped_area_vmflags.patch
x86-mm-care-about-shadow-stack-guard-gap-during-placement.patch
selftests-x86-add-placement-guard-gap-test-for-shstk.patch

