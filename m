Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33E261514E5
	for <mm-commits@vger.kernel.org>; Wed, 27 Mar 2024 20:11:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711570310; cv=none; b=X9AtJUdelBIsxEKtzAZRjt8g/kqlLUHRRxGycRmq62RybCcAVi+gSGVcwVfiEGb6MrdEP0tPfEjxWjXPr3nFB0nbR8gFNgYdjTz85dz7J9iXA57dDpMmK9DOGvTQo2W3wF2vlUYrEw4e0qrEf3ZJfX6jwl5JKZrrS/S9QnkSkcA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711570310; c=relaxed/simple;
	bh=SoW1WFbBVK9vLMzczN4nj1CYKieGfH8e7BgJSIuHxcU=;
	h=Date:To:From:Subject:Message-Id; b=obdgWS01oORZ1IGaPBPTdrEU7aNKVlrJmIeoIKorSCXps/jP7D1k2BWqKaM98n63o5BxD2fDY2YVynqp54gJQAQwSulfkEMzEncByil97Eezw48lAlMx5MYt/P4g9TkHX5NaL9gAPv268FMNMkrAGvczdbnDtVLOK0jmAZ3/tDI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=af6GoIxe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="af6GoIxe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEE06C433C7;
	Wed, 27 Mar 2024 20:11:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1711570309;
	bh=SoW1WFbBVK9vLMzczN4nj1CYKieGfH8e7BgJSIuHxcU=;
	h=Date:To:From:Subject:From;
	b=af6GoIxeG5NLjhTTu3jA5fLPVMW5AY0d4oX0h3ghWABOIOFmUAghRnEg1tARwevbF
	 Zc2zUSEVW22P/6n/Ddj2WE+zxTKlpqMMWE3Xc/mOB1TVUx5KAxsh3z0fwrxx7J6N2E
	 CI6OtePnus3Q1Z/oG9syxMoJpgdE/3qcNNEpS9g0=
Date: Wed, 27 Mar 2024 13:11:49 -0700
To: mm-commits@vger.kernel.org,tglx@linutronix.de,peterz@infradead.org,npiggin@gmail.com,naveen.n.rao@linux.ibm.com,mpe@ellerman.id.au,mingo@redhat.com,luto@kernel.org,Liam.Howlett@oracle.com,kirill.shutemov@linux.intel.com,keescook@chromium.org,James.Bottomley@HansenPartnership.com,hpa@zytor.com,guoren@kernel.org,deller@gmx.de,debug@rivosinc.com,dave.hansen@linux.intel.com,dan.j.williams@intel.com,christophe.leroy@csgroup.eu,broonie@kernel.org,bp@alien8.de,ast@kernel.org,aneesh.kumar@kernel.org,rick.p.edgecombe@intel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-take-placement-mappings-gap-into-account.patch added to mm-unstable branch
Message-Id: <20240327201149.AEE06C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: take placement mappings gap into account
has been added to the -mm mm-unstable branch.  Its filename is
     mm-take-placement-mappings-gap-into-account.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-take-placement-mappings-gap-into-account.patch

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
Subject: mm: take placement mappings gap into account
Date: Mon, 25 Mar 2024 19:16:53 -0700

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

For MAP_GROWSDOWN/VM_GROWSDOWN and MAP_GROWSUP/VM_GROWSUP this has not
been a problem in practice because applications place these kinds of
mappings very early, when there is not many mappings to find a space
between.  But for shadow stacks, they may be placed throughout the
lifetime of the application.

Use the start_gap field to find a space that includes the guard gap for
the new mapping.  Take care to not interfere with the alignment.

Link: https://lkml.kernel.org/r/20240326021656.202649-12-rick.p.edgecombe@intel.com
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

 include/linux/mm.h |    1 +
 mm/mmap.c          |   12 +++++++++---
 2 files changed, 10 insertions(+), 3 deletions(-)

--- a/include/linux/mm.h~mm-take-placement-mappings-gap-into-account
+++ a/include/linux/mm.h
@@ -3467,6 +3467,7 @@ struct vm_unmapped_area_info {
 	unsigned long high_limit;
 	unsigned long align_mask;
 	unsigned long align_offset;
+	unsigned long start_gap;
 };
 
 extern unsigned long vm_unmapped_area(struct vm_unmapped_area_info *info);
--- a/mm/mmap.c~mm-take-placement-mappings-gap-into-account
+++ a/mm/mmap.c
@@ -1579,7 +1579,7 @@ static unsigned long unmapped_area(struc
 	VMA_ITERATOR(vmi, current->mm, 0);
 
 	/* Adjust search length to account for worst case alignment overhead */
-	length = info->length + info->align_mask;
+	length = info->length + info->align_mask + info->start_gap;
 	if (length < info->length)
 		return -ENOMEM;
 
@@ -1591,7 +1591,13 @@ retry:
 	if (vma_iter_area_lowest(&vmi, low_limit, high_limit, length))
 		return -ENOMEM;
 
-	gap = vma_iter_addr(&vmi);
+	/*
+	 * Adjust for the gap first so it doesn't interfere with the
+	 * later alignment. The first step is the minimum needed to
+	 * fulill the start gap, the next steps is the minimum to align
+	 * that. It is the minimum needed to fulill both.
+	 */
+	gap = vma_iter_addr(&vmi) + info->start_gap;
 	gap += (info->align_offset - gap) & info->align_mask;
 	tmp = vma_next(&vmi);
 	if (tmp && (tmp->vm_flags & VM_STARTGAP_FLAGS)) { /* Avoid prev check if possible */
@@ -1630,7 +1636,7 @@ static unsigned long unmapped_area_topdo
 	VMA_ITERATOR(vmi, current->mm, 0);
 
 	/* Adjust search length to account for worst case alignment overhead */
-	length = info->length + info->align_mask;
+	length = info->length + info->align_mask + info->start_gap;
 	if (length < info->length)
 		return -ENOMEM;
 
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

