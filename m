Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 485862D047
	for <mm-commits@vger.kernel.org>; Wed, 27 Mar 2024 20:11:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711570286; cv=none; b=IPfgqmVHlW8YVC1PpKxXVjYyFR5MQV16ygv+QIIBypzAprNkPGspYWooBq6X3R1hvqyYFvRdooJo0oTX++FfXCtbCJnfzYlpbMLDw1yIiZgUfiibD8tEEYDulrejMarK1S/5One00Wbp9vvmWEL525yaD6121jCVMREuEuAvOBI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711570286; c=relaxed/simple;
	bh=TjTh9XRmYpePwEk17qDgGfbcUVCP/T2fmP4hpQ5q1Ns=;
	h=Date:To:From:Subject:Message-Id; b=LeKImSUfUtTHHphaNKFgQECZYefCQalHQIZru/gF1AL06LypH8Zpg1qKC/o1VXewhEwi2IdJcsOq0LDBsE1aSEUZ38hrdYMcrBTaV/zrqvW+HsTuFYcve12pSRkIQKZsnu/5fmYNvOLQDTdHq3bzapr5lZgR5xTK+rzrG3YQRr0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=yw5EmQ7D; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="yw5EmQ7D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4FB2C433C7;
	Wed, 27 Mar 2024 20:11:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1711570285;
	bh=TjTh9XRmYpePwEk17qDgGfbcUVCP/T2fmP4hpQ5q1Ns=;
	h=Date:To:From:Subject:From;
	b=yw5EmQ7Db+P3Ht65quoQsJZNwYiNXGMRiZSYLB5cAcGBRM02odY06b1CevMQTHfoz
	 YTv13K1as4w6ijeFOy6SJnlvFm08lK+q4YNwAjr2ztxrX5i8XlF7NNcqwUOPwda6fU
	 aJHpLn2GXZwH7l3Z9EQXf/KHknPMzG1WzENyerFA=
Date: Wed, 27 Mar 2024 13:11:25 -0700
To: mm-commits@vger.kernel.org,tglx@linutronix.de,peterz@infradead.org,npiggin@gmail.com,naveen.n.rao@linux.ibm.com,mpe@ellerman.id.au,mingo@redhat.com,luto@kernel.org,Liam.Howlett@oracle.com,kirill.shutemov@linux.intel.com,keescook@chromium.org,James.Bottomley@HansenPartnership.com,hpa@zytor.com,guoren@kernel.org,deller@gmx.de,debug@rivosinc.com,dave.hansen@linux.intel.com,dan.j.williams@intel.com,christophe.leroy@csgroup.eu,broonie@kernel.org,bp@alien8.de,ast@kernel.org,aneesh.kumar@kernel.org,rick.p.edgecombe@intel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + proc-refactor-pde_get_unmapped_area-as-prep.patch added to mm-unstable branch
Message-Id: <20240327201125.B4FB2C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: proc: refactor pde_get_unmapped_area as prep
has been added to the -mm mm-unstable branch.  Its filename is
     proc-refactor-pde_get_unmapped_area-as-prep.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/proc-refactor-pde_get_unmapped_area-as-prep.patch

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
Subject: proc: refactor pde_get_unmapped_area as prep
Date: Mon, 25 Mar 2024 19:16:43 -0700

Patch series "Cover a guard gap corner case", v4.

In working on x86’s shadow stack feature, I came across some limitations
around the kernel’s handling of guard gaps.  AFAICT these limitations
are not too important for the traditional stack usage of guard gaps, but
have bigger impact on shadow stack’s usage.  And now in addition to x86,
we have two other architectures implementing shadow stack like features
that plan to use guard gaps.  I wanted to see about addressing them, but I
have not worked on mmap() placement related code before, so would greatly
appreciate if people could take a look and point me in the right
direction.

The nature of the limitations of concern is as follows. In order to ensure 
guard gaps between mappings, mmap() would need to consider two things:
 1. That the new mapping isn’t placed in an any existing mapping’s guard
    gap.
 2. That the new mapping isn’t placed such that any existing mappings are
    not in *its* guard gaps
Currently mmap never considers (2), and (1) is not considered in some 
situations.

When not passing an address hint, or passing one without
MAP_FIXED_NOREPLACE, (1) is enforced.  With MAP_FIXED_NOREPLACE, (1) is
not enforced.  With MAP_FIXED, (1) is not considered, but this seems to be
expected since MAP_FIXED can already clobber existing mappings.  For
MAP_FIXED_NOREPLACE I would have guessed it should respect the guard gaps
of existing mappings, but it is probably a little ambiguous.

In this series I just tried to add enforcement of (2) for the normal (no
address hint) case and only for the newer shadow stack memory (not
stacks).  The reason is that with the no-address-hint situation, landing
next to a guard gap could come up naturally and so be more influencable by
attackers such that two shadow stacks could be adjacent without a guard
gap.  Where as the address-hint scenarios would require more control -
being able to call mmap() with specific arguments.  As for why not just
fix the other corner cases anyway, I thought it might have some greater
possibility of affecting existing apps.


This patch (of 14):

Future changes will perform a treewide change to remove the indirect
branch that is involved in calling mm->get_unmapped_area().  After doing
this, the function will no longer be able to be handled as a function
pointer.  To make the treewide change diff cleaner and easier to review,
refactor pde_get_unmapped_area() such that mm->get_unmapped_area() is
called without being stored in a local function pointer.  With this in
refactoring, follow on changes will be able to simply replace the call
site with a future function that calls it directly.

Link: https://lkml.kernel.org/r/20240326021656.202649-1-rick.p.edgecombe@intel.com
Link: https://lkml.kernel.org/r/20240326021656.202649-2-rick.p.edgecombe@intel.com
Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Borislav Petkov (AMD) <bp@alien8.de>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Deepak Gupta <debug@rivosinc.com>
Cc: H. Peter Anvin (Intel) <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Mark Brown <broonie@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Aneesh Kumar K.V <aneesh.kumar@kernel.org>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Guo Ren <guoren@kernel.org>
Cc: Helge Deller <deller@gmx.de>
Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Naveen N. Rao <naveen.n.rao@linux.ibm.com>
Cc: Nicholas Piggin <npiggin@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/inode.c |    9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

--- a/fs/proc/inode.c~proc-refactor-pde_get_unmapped_area-as-prep
+++ a/fs/proc/inode.c
@@ -451,15 +451,12 @@ pde_get_unmapped_area(struct proc_dir_en
 			   unsigned long len, unsigned long pgoff,
 			   unsigned long flags)
 {
-	typeof_member(struct proc_ops, proc_get_unmapped_area) get_area;
+	if (pde->proc_ops->proc_get_unmapped_area)
+		return pde->proc_ops->proc_get_unmapped_area(file, orig_addr, len, pgoff, flags);
 
-	get_area = pde->proc_ops->proc_get_unmapped_area;
 #ifdef CONFIG_MMU
-	if (!get_area)
-		get_area = current->mm->get_unmapped_area;
+	return current->mm->get_unmapped_area(file, orig_addr, len, pgoff, flags);
 #endif
-	if (get_area)
-		return get_area(file, orig_addr, len, pgoff, flags);
 	return orig_addr;
 }
 
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

