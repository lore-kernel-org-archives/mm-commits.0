Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68447395D84
	for <mm-commits@vger.kernel.org>; Wed, 25 Feb 2026 19:48:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772048894; cv=none; b=P3u4zVtXN+Gvi8Lifn8R/ujX9y2XhagQX/4V8v6gpBXjYwi0e/lHBoatB31agfx0Q/41xmiY3NGIfs9dkKUqT8dUNXQLJ8DeQkXN/a/He1MzmTsx50Wa3BFfzi6UmOuXZz5yO3Mn6J2NxMw7grCDYPrIEMrwnmK10/6CVW9LN3s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772048894; c=relaxed/simple;
	bh=6UZQdOaYoQKOX2b3Tiur2WDvZa+kJYxF9rPeepqYNA0=;
	h=Date:To:From:Subject:Message-Id; b=kQHsR//VMl36V2S0x7LY7032M1oRWUiMuPJR2UOdL4J4vgDCeOEQty+k+G9r7uzfyONUf036dfjMWcIbnnL6DU7aRBvn0U7sGQm6nWFvXuIbWDVT9yn7hsvQzulIueAavTVvKbKzvRsNs3y6dobfAQYF/COE2S2UFoWh7BpTQrA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=bbVGKyTk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="bbVGKyTk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18643C116D0;
	Wed, 25 Feb 2026 19:48:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1772048894;
	bh=6UZQdOaYoQKOX2b3Tiur2WDvZa+kJYxF9rPeepqYNA0=;
	h=Date:To:From:Subject:From;
	b=bbVGKyTkP9dTU0witP1Sy5sEXnLrifw7fNwe/gDjAE8z318DiNdxqmeX7JzIzNNuj
	 npcjlI+TEeIq9mmXgK2Yb8cUQj2eASjBgIYpL1vXzNxucKNR/oKQQuFYzaKZqkOHqD
	 ZQS7tvidvzIq5i+AYdOMmE8HzvoZsgXJmurYmFp0=
Date: Wed, 25 Feb 2026 11:48:13 -0800
To: mm-commits@vger.kernel.org,will@kernel.org,vbabka@suse.cz,tglx@kernel.org,surenb@google.com,rppt@kernel.org,rick.p.edgecombe@intel.com,pjw@kernel.org,palmer@dabbelt.com,mingo@redhat.com,mhocko@suse.com,lorenzo.stoakes@oracle.com,Liam.Howlett@oracle.com,hpa@zytor.com,debug@rivosinc.com,david@kernel.org,dave.hansen@linux.intel.com,broonie@kernel.org,bp@alien8.de,aou@eecs.berkeley.edu,alex@ghiti.fr,catalin.marinas@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-do-not-map-the-shadow-stack-as-thp.patch added to mm-new branch
Message-Id: <20260225194814.18643C116D0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: do not map the shadow stack as THP
has been added to the -mm mm-new branch.  Its filename is
     mm-do-not-map-the-shadow-stack-as-thp.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-do-not-map-the-shadow-stack-as-thp.patch

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
Subject: mm: do not map the shadow stack as THP
Date: Wed, 25 Feb 2026 16:14:02 +0000

The default shadow stack size allocated on first prctl() for the main
thread or subsequently on clone() is either half of RLIMIT_STACK or half
of a thread's stack size (for arm64).  Both of these are likely to be
suitable for a THP allocation and the kernel is more aggressive in
creating such mappings.  However, it does not make much sense to use a
huge page.  It didn't make sense for the normal stacks either, see commit
c4608d1bf7c6 ("mm: mmap: map MAP_STACK to VM_NOHUGEPAGE").

Force VM_NOHUGEPAGE when allocating/mapping the shadow stack.  As per
commit 7190b3c8bd2b ("mm: mmap: map MAP_STACK to VM_NOHUGEPAGE only if THP
is enabled"), only pass this flag if TRANSPARENT_HUGEPAGE is enabled as
not to confuse CRIU tools.

Link: https://lkml.kernel.org/r/20260225161404.3157851-6-catalin.marinas@arm.com
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Tested-by: Deepak Gupta <debug@rivosinc.com>
Reviewed-by: Mark Brown <broonie@kernel.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Albert Ou <aou@eecs.berkeley.edu>
Cc: Alexandre Ghiti <alex@ghiti.fr>
Cc: "Borislav Petkov (AMD)" <bp@alien8.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Paul Walmsley <pjw@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Thomas Gleixner <tglx@kernel.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/util.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/mm/util.c~mm-do-not-map-the-shadow-stack-as-thp
+++ a/mm/util.c
@@ -629,14 +629,18 @@ unsigned long vm_mmap_shadow_stack(unsig
 {
 	struct mm_struct *mm = current->mm;
 	unsigned long ret, unused;
+	vm_flags_t vm_flags = VM_SHADOW_STACK;
 
 	flags |= MAP_ANONYMOUS | MAP_PRIVATE;
 	if (addr)
 		flags |= MAP_FIXED_NOREPLACE;
 
+	if (IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE))
+		vm_flags |= VM_NOHUGEPAGE;
+
 	mmap_write_lock(mm);
 	ret = do_mmap(NULL, addr, len, PROT_READ | PROT_WRITE, flags,
-		      VM_SHADOW_STACK, 0, &unused, NULL);
+		      vm_flags, 0, &unused, NULL);
 	mmap_write_unlock(mm);
 
 	return ret;
_

Patches currently in -mm which might be from catalin.marinas@arm.com are

mm-introduce-vm_mmap_shadow_stack-as-a-helper-for-vm_shadow_stack-mappings.patch
arm64-gcs-use-the-new-common-vm_mmap_shadow_stack-helper.patch
riscv-shstk-use-the-new-common-vm_mmap_shadow_stack-helper.patch
x86-shstk-use-the-new-common-vm_mmap_shadow_stack-helper.patch
mm-do-not-map-the-shadow-stack-as-thp.patch

