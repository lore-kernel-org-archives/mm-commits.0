Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25B5C80607
	for <mm-commits@vger.kernel.org>; Fri, 26 Apr 2024 04:01:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714104096; cv=none; b=Uc7K0T7wQO3AyavxEqkyBZ+b9In5KzZVZ9exkZc1m23G3qIEEE0BUs3sUK2ir4yPqc+h1x7eWC8PpCXVuxzjoxhi/ctEpjzPSlRrEUqyxHURFEl0MFONdSvrrhvdqxOPV7UoJwXatU6oDy+7CPK4kzfHhr2oHzFj/Ljbb73CjDA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714104096; c=relaxed/simple;
	bh=kaGrXWopVVDCuJq/+2THJtSKVSVqRhOQWQcbLpVlN78=;
	h=Date:To:From:Subject:Message-Id; b=RPfE47Y6jgGtQpwCu1m7nRMSUFYzvnxw7VxJqEpU+dJt2/dINT9McF3aMalSFQDGA57kLQf2HfBJmra9F1V8epB+k2WoXzsl1SfJOf3ASEJqLDdnUBCsVeqfKARkDKLiXeOQhSD4eRqTKApNNmHgVbVewwXYA+apPuF8pea/okM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=qoqvsu3S; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="qoqvsu3S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED011C113CD;
	Fri, 26 Apr 2024 04:01:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714104096;
	bh=kaGrXWopVVDCuJq/+2THJtSKVSVqRhOQWQcbLpVlN78=;
	h=Date:To:From:Subject:From;
	b=qoqvsu3SnP9Yvweaq1+MfGPoWuHahNZqP38S/8goeh+gPpPl7gPybRhKB21L3nmmt
	 l8FG9TM5mbEcssf/JuThHWzs3wEooO5hqB7fqlDPDlQNI57JGOCtynRy4Vc/pAQn0Y
	 UCgxH6vLTvYf/z7Ur2SBhQ6l/CAz49RYOJXoZ7vg=
Date: Thu, 25 Apr 2024 21:01:35 -0700
To: mm-commits@vger.kernel.org,tglx@linutronix.de,peterz@infradead.org,npiggin@gmail.com,naveen.n.rao@linux.ibm.com,mpe@ellerman.id.au,mingo@redhat.com,luto@kernel.org,Liam.Howlett@oracle.com,kirill.shutemov@linux.intel.com,keescook@chromium.org,James.Bottomley@HansenPartnership.com,hpa@zytor.com,guoren@kernel.org,deller@gmx.de,debug@rivosinc.com,dave.hansen@linux.intel.com,dan.j.williams@intel.com,christophe.leroy@csgroup.eu,broonie@kernel.org,bp@alien8.de,ast@kernel.org,aneesh.kumar@kernel.org,rick.p.edgecombe@intel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] x86-mm-care-about-shadow-stack-guard-gap-during-placement.patch removed from -mm tree
Message-Id: <20240426040135.ED011C113CD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: x86/mm: care about shadow stack guard gap during placement
has been removed from the -mm tree.  Its filename was
     x86-mm-care-about-shadow-stack-guard-gap-during-placement.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


