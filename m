Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B430A2D047
	for <mm-commits@vger.kernel.org>; Wed, 27 Mar 2024 20:11:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711570295; cv=none; b=gsIWB6FEYhiPA9ftL25V9nDDdr7woQqF1yIJOF3QcKSn+T2SzXDiRmbhFNcSbSyH+FMLIn60wMGAsBfzVCfjWA4UIzdWEjgmQMD0ZEGcAj0La+65cHEMqFg8o4xn+AJBvtzMKBN08JLwbIyAHrZZapB2xunDkRNt9BVqMpxTFDY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711570295; c=relaxed/simple;
	bh=GA9nAs/yr/b+kILkzB14aK3stf1/toyE9NgTeto8TO4=;
	h=Date:To:From:Subject:Message-Id; b=l/SDQn//pi6XSA/aD6p8Q4iVEoXUDotFR8El7i12y8UskFSAcEMlKYFLEELRGmSzxyhkUpJNPpnng8k5uJPALmO7sXhJ5YpDCFLJ4zQeg9pCl2Jo6lP7tYrBMN+UZeHjh4Sg+KAfY89qlQO+YIdFUTSSn7HdKegD86tpEv+ZAvg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=hDk0QPWq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="hDk0QPWq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E21FC433F1;
	Wed, 27 Mar 2024 20:11:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1711570295;
	bh=GA9nAs/yr/b+kILkzB14aK3stf1/toyE9NgTeto8TO4=;
	h=Date:To:From:Subject:From;
	b=hDk0QPWqxXL/1VWJrR2xyO7s85SOrrKCfHuDgptG+w8KhaqZNfh/+T4ne9RAYodX4
	 z0KVTcuH1qEbgr77xf6b0Zms+WIvTAyc52Bi0UElyCnuLP81XDvvroCEap+HqzKp8z
	 wKcZ15gjy9qbkVbVC7HOby+2D6IPKaQ6n8YBXqvY=
Date: Wed, 27 Mar 2024 13:11:34 -0700
To: mm-commits@vger.kernel.org,tglx@linutronix.de,peterz@infradead.org,npiggin@gmail.com,naveen.n.rao@linux.ibm.com,mpe@ellerman.id.au,mingo@redhat.com,luto@kernel.org,Liam.Howlett@oracle.com,kirill.shutemov@linux.intel.com,keescook@chromium.org,James.Bottomley@HansenPartnership.com,hpa@zytor.com,guoren@kernel.org,deller@gmx.de,debug@rivosinc.com,dave.hansen@linux.intel.com,dan.j.williams@intel.com,christophe.leroy@csgroup.eu,broonie@kernel.org,bp@alien8.de,ast@kernel.org,aneesh.kumar@kernel.org,rick.p.edgecombe@intel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-remove-export-for-get_unmapped_area.patch added to mm-unstable branch
Message-Id: <20240327201135.1E21FC433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: remove export for get_unmapped_area()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-remove-export-for-get_unmapped_area.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-remove-export-for-get_unmapped_area.patch

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
Subject: mm: remove export for get_unmapped_area()
Date: Mon, 25 Mar 2024 19:16:46 -0700

The mm/mmap.c function get_unmapped_area() is not used from any modules,
so it doesn't need to be exported.  Remove the export.

Link: https://lkml.kernel.org/r/20240326021656.202649-5-rick.p.edgecombe@intel.com
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

 mm/mmap.c |    2 --
 1 file changed, 2 deletions(-)

--- a/mm/mmap.c~mm-remove-export-for-get_unmapped_area
+++ a/mm/mmap.c
@@ -1886,8 +1886,6 @@ get_unmapped_area(struct file *file, uns
 	return error ? error : addr;
 }
 
-EXPORT_SYMBOL(get_unmapped_area);
-
 unsigned long
 mm_get_unmapped_area(struct mm_struct *mm, struct file *file,
 		     unsigned long addr, unsigned long len,
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

