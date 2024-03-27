Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC10F2D047
	for <mm-commits@vger.kernel.org>; Wed, 27 Mar 2024 20:11:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711570293; cv=none; b=rV47h3iS/Gb2p8+Y1gDfurqsKaKkZ3ziOP0/85L68XN97+Fz4GFMRdpAPXdJgw1Ohg2rQJq5/IpaNLaeACKcfGAAjYP93mN0DmCB6yzoSX9rziM1niE6Mpd1LGsVhiPUarkF3xjoZ934s3MkQpZ5QIdBnLCyHmOQbuxRwNEUbLg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711570293; c=relaxed/simple;
	bh=Qcru4Ci9BRDqxb3xVYds9ppMZinyFNvk/VBlR9hQYsU=;
	h=Date:To:From:Subject:Message-Id; b=TpnsMwEEehX7EdtGmABoU2UNHi/ZFcYDjTKgaapuE/lp2uH7wDG9NgyTiCUMMUv3wFqH4+9MxlHWHqRz9/i/D/+kAdeZhKhhA42neXcY/t+vff/vrf5jUUTDFnRYS1e/w71sekX0/g3/q2TnR9hmkwc8qC3+8oYUNyMBj1gqB5Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=czn6I9Ea; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="czn6I9Ea"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A326C433F1;
	Wed, 27 Mar 2024 20:11:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1711570293;
	bh=Qcru4Ci9BRDqxb3xVYds9ppMZinyFNvk/VBlR9hQYsU=;
	h=Date:To:From:Subject:From;
	b=czn6I9EaY7jAeFxek3rqTcDqifWNrKWBcpS/csyyoWwSWRrGlNkoLzIy53n4zFh18
	 2IfxXbp4bbc5c2Q2Q9+LkDzFA+oQhGUQZnldasCvE4g2sIVDn7baDil2dWFR2njLsB
	 6CDT/XhD9ZB0cijDsYzPEUUI70OLlYbxzyWeb2Zw=
Date: Wed, 27 Mar 2024 13:11:32 -0700
To: mm-commits@vger.kernel.org,tglx@linutronix.de,peterz@infradead.org,npiggin@gmail.com,naveen.n.rao@linux.ibm.com,mpe@ellerman.id.au,mingo@redhat.com,luto@kernel.org,Liam.Howlett@oracle.com,kirill.shutemov@linux.intel.com,keescook@chromium.org,James.Bottomley@HansenPartnership.com,hpa@zytor.com,guoren@kernel.org,deller@gmx.de,debug@rivosinc.com,dave.hansen@linux.intel.com,dan.j.williams@intel.com,christophe.leroy@csgroup.eu,broonie@kernel.org,bp@alien8.de,ast@kernel.org,aneesh.kumar@kernel.org,rick.p.edgecombe@intel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-introduce-arch_get_unmapped_area_vmflags.patch added to mm-unstable branch
Message-Id: <20240327201133.4A326C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: introduce arch_get_unmapped_area_vmflags()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-introduce-arch_get_unmapped_area_vmflags.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-introduce-arch_get_unmapped_area_vmflags.patch

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
Subject: mm: introduce arch_get_unmapped_area_vmflags()
Date: Mon, 25 Mar 2024 19:16:45 -0700

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

In order to take the start gap into account, the maple tree search needs
to know the size of start gap the new mapping will need.  The call chain
from do_mmap() to the actual maple tree search looks like this:

do_mmap(size, vm_flags, map_flags, ..)
	mm/mmap.c:get_unmapped_area(size, map_flags, ...)
		arch_get_unmapped_area(size, map_flags, ...)
			vm_unmapped_area(struct vm_unmapped_area_info)

One option would be to add another MAP_ flag to mean a one page start gap
(as is for shadow stack), but this consumes a flag unnecessarily.  Another
option could be to simply increase the size passed in do_mmap() by the
start gap size, and adjust after the fact, but this will interfere with
the alignment requirements passed in struct vm_unmapped_area_info, and
unknown to mmap.c.  Instead, introduce variants of
arch_get_unmapped_area/_topdown() that take vm_flags.  In future changes,
these variants can be used in mmap.c:get_unmapped_area() to allow the
vm_flags to be passed through to vm_unmapped_area(), while preserving the
normal arch_get_unmapped_area/_topdown() for the existing callers.

Link: https://lkml.kernel.org/r/20240326021656.202649-4-rick.p.edgecombe@intel.com
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

 include/linux/sched/mm.h |   17 +++++++++++++++++
 mm/mmap.c                |   28 ++++++++++++++++++++++++++++
 2 files changed, 45 insertions(+)

--- a/include/linux/sched/mm.h~mm-introduce-arch_get_unmapped_area_vmflags
+++ a/include/linux/sched/mm.h
@@ -192,6 +192,23 @@ unsigned long mm_get_unmapped_area(struc
 				   unsigned long pgoff, unsigned long flags);
 
 unsigned long
+arch_get_unmapped_area_vmflags(struct file *filp, unsigned long addr,
+			       unsigned long len, unsigned long pgoff,
+			       unsigned long flags, vm_flags_t vm_flags);
+unsigned long
+arch_get_unmapped_area_topdown_vmflags(struct file *filp, unsigned long addr,
+				       unsigned long len, unsigned long pgoff,
+				       unsigned long flags, vm_flags_t);
+
+unsigned long mm_get_unmapped_area_vmflags(struct mm_struct *mm,
+					   struct file *filp,
+					   unsigned long addr,
+					   unsigned long len,
+					   unsigned long pgoff,
+					   unsigned long flags,
+					   vm_flags_t vm_flags);
+
+unsigned long
 generic_get_unmapped_area(struct file *filp, unsigned long addr,
 			  unsigned long len, unsigned long pgoff,
 			  unsigned long flags);
--- a/mm/mmap.c~mm-introduce-arch_get_unmapped_area_vmflags
+++ a/mm/mmap.c
@@ -1807,6 +1807,34 @@ arch_get_unmapped_area_topdown(struct fi
 }
 #endif
 
+#ifndef HAVE_ARCH_UNMAPPED_AREA_VMFLAGS
+unsigned long
+arch_get_unmapped_area_vmflags(struct file *filp, unsigned long addr, unsigned long len,
+			       unsigned long pgoff, unsigned long flags, vm_flags_t vm_flags)
+{
+	return arch_get_unmapped_area(filp, addr, len, pgoff, flags);
+}
+
+unsigned long
+arch_get_unmapped_area_topdown_vmflags(struct file *filp, unsigned long addr,
+				       unsigned long len, unsigned long pgoff,
+				       unsigned long flags, vm_flags_t vm_flags)
+{
+	return arch_get_unmapped_area_topdown(filp, addr, len, pgoff, flags);
+}
+#endif
+
+unsigned long mm_get_unmapped_area_vmflags(struct mm_struct *mm, struct file *filp,
+					   unsigned long addr, unsigned long len,
+					   unsigned long pgoff, unsigned long flags,
+					   vm_flags_t vm_flags)
+{
+	if (test_bit(MMF_TOPDOWN, &mm->flags))
+		return arch_get_unmapped_area_topdown_vmflags(filp, addr, len, pgoff,
+							      flags, vm_flags);
+	return arch_get_unmapped_area_vmflags(filp, addr, len, pgoff, flags, vm_flags);
+}
+
 unsigned long
 get_unmapped_area(struct file *file, unsigned long addr, unsigned long len,
 		unsigned long pgoff, unsigned long flags)
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

