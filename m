Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEC9738F949
	for <mm-commits@vger.kernel.org>; Wed, 25 Feb 2026 19:48:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772048889; cv=none; b=arMyJ6BeLnVWdHz0SS1QO/ufQmFNRFdQXr/08ueKI4vW8KVG+088MBEaru0QKGalqJ8xHIevsOXbMSv8OfTVOoQ7tfmscR5dUgTi+OH1O0XeUFMXXB4wAG3accjXJwIlWo50F7hDqIQQW7pLWZukhSLR1sdC2x28DbGn207Y5X4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772048889; c=relaxed/simple;
	bh=V8MWdWlnvPEARlrMjtyMSp8bVgSiFdmvunGeNDYmbdg=;
	h=Date:To:From:Subject:Message-Id; b=UEebCloHz5s5T5XLAJgf0OHxDE9Amh2eWbfs+yUhvNwQk9s3FnYLd683PCZtqxj5YsfhdZEh71QhTqorY7M6riWH2SzYhboBttTvBGP9811g8LoE4fmIcciswszvVTnVhRZqR2tV0IlR79JCzsxODUMhLh8oE5ceBviFI1qPGVg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=TmLfnhrg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="TmLfnhrg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71D36C19422;
	Wed, 25 Feb 2026 19:48:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1772048889;
	bh=V8MWdWlnvPEARlrMjtyMSp8bVgSiFdmvunGeNDYmbdg=;
	h=Date:To:From:Subject:From;
	b=TmLfnhrgkHalLVfVQMaA/Hj3Vgy29U+VM3z/wPxjCUiP7mkdqxV/gWzoarR3JMxOg
	 y6uSupl097dTP9K6Mu3b8kObD2rVRKvKjd6cdqndlJVXhfptfvvbDUchtjeN+8HkXw
	 v3GlwhqJOSIAlNqu0rrLRbveOV0Yn/eyOQRGtjFI=
Date: Wed, 25 Feb 2026 11:48:08 -0800
To: mm-commits@vger.kernel.org,will@kernel.org,vbabka@suse.cz,tglx@kernel.org,surenb@google.com,rppt@kernel.org,rick.p.edgecombe@intel.com,pjw@kernel.org,palmer@dabbelt.com,mingo@redhat.com,mhocko@suse.com,lorenzo.stoakes@oracle.com,Liam.Howlett@oracle.com,hpa@zytor.com,debug@rivosinc.com,david@kernel.org,dave.hansen@linux.intel.com,broonie@kernel.org,bp@alien8.de,aou@eecs.berkeley.edu,alex@ghiti.fr,catalin.marinas@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + riscv-shstk-use-the-new-common-vm_mmap_shadow_stack-helper.patch added to mm-new branch
Message-Id: <20260225194809.71D36C19422@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: riscv: shstk: use the new common vm_mmap_shadow_stack() helper
has been added to the -mm mm-new branch.  Its filename is
     riscv-shstk-use-the-new-common-vm_mmap_shadow_stack-helper.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/riscv-shstk-use-the-new-common-vm_mmap_shadow_stack-helper.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Catalin Marinas <catalin.marinas@arm.com>
Subject: riscv: shstk: use the new common vm_mmap_shadow_stack() helper
Date: Wed, 25 Feb 2026 16:14:00 +0000

Replace part of the allocate_shadow_stack() content with a call to
vm_mmap_shadow_stack().  There is no functional change.

Link: https://lkml.kernel.org/r/20260225161404.3157851-4-catalin.marinas@arm.com
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Tested-by: Deepak Gupta <debug@rivosinc.com>
Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Paul Walmsley <pjw@kernel.org>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Albert Ou <aou@eecs.berkeley.edu>
Cc: Alexandre Ghiti <alex@ghiti.fr>
Cc: "Borislav Petkov (AMD)" <bp@alien8.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Mark Brown <broonie@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Thomas Gleixner <tglx@kernel.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/riscv/kernel/usercfi.c |   12 +-----------
 1 file changed, 1 insertion(+), 11 deletions(-)

--- a/arch/riscv/kernel/usercfi.c~riscv-shstk-use-the-new-common-vm_mmap_shadow_stack-helper
+++ a/arch/riscv/kernel/usercfi.c
@@ -230,17 +230,7 @@ int restore_user_shstk(struct task_struc
 static unsigned long allocate_shadow_stack(unsigned long addr, unsigned long size,
 					   unsigned long token_offset, bool set_tok)
 {
-	int flags = MAP_ANONYMOUS | MAP_PRIVATE;
-	struct mm_struct *mm = current->mm;
-	unsigned long populate;
-
-	if (addr)
-		flags |= MAP_FIXED_NOREPLACE;
-
-	mmap_write_lock(mm);
-	addr = do_mmap(NULL, addr, size, PROT_READ, flags,
-		       VM_SHADOW_STACK | VM_WRITE, 0, &populate, NULL);
-	mmap_write_unlock(mm);
+	addr = vm_mmap_shadow_stack(addr, size, 0);
 
 	if (!set_tok || IS_ERR_VALUE(addr))
 		goto out;
_

Patches currently in -mm which might be from catalin.marinas@arm.com are

mm-introduce-vm_mmap_shadow_stack-as-a-helper-for-vm_shadow_stack-mappings.patch
arm64-gcs-use-the-new-common-vm_mmap_shadow_stack-helper.patch
riscv-shstk-use-the-new-common-vm_mmap_shadow_stack-helper.patch
x86-shstk-use-the-new-common-vm_mmap_shadow_stack-helper.patch
mm-do-not-map-the-shadow-stack-as-thp.patch

