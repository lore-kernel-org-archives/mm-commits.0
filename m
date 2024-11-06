Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D261C13A26F
	for <mm-commits@vger.kernel.org>; Wed,  6 Nov 2024 21:28:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730928512; cv=none; b=S+FfmJnI3mZppQq6R3ZECNCi/BkiLteF7rRxrRyvMOuNWRM46YYVEOhmwC6EaqRUJwn1vrlbYzxOeAe9SgYUGoKy8hYddqhLY1KRIsDh9uTfFNGShgjdioJWvo+ejMo4GAP/lkdyrJd3Mspa/2E6meEBdrsZR/lGN452Hs0UyV4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730928512; c=relaxed/simple;
	bh=KKdAhnIJFc9/CkRdHXQjBUh1qWsEWR3rDf94M4kEc1U=;
	h=Date:To:From:Subject:Message-Id; b=RpuGq6eehFviuiTZEaATy/VasV7/O8wSpy+YlfATVTRLxXgO7+XjrZUR+iX+MplkB8WLPjxO3Uhm8qc1FxP2BAH8iEFZ+keVZPWLDvqTS/DQTLR4CT5vRHg/LyFj8G66HRCVJ0MmSqNWIPPSk6ekxCfSEUu114OuOL1VPhfcYFE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=NEm8eHAL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="NEm8eHAL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CAEBC4CEC6;
	Wed,  6 Nov 2024 21:28:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1730928512;
	bh=KKdAhnIJFc9/CkRdHXQjBUh1qWsEWR3rDf94M4kEc1U=;
	h=Date:To:From:Subject:From;
	b=NEm8eHALu3bbZjfsteR5ZDmh6gnqPlFcUo8q2xio8x5rULlGlcXYRc7sNly8PDIQV
	 fv8zgTrZtdrdYbdyc5eX1/KA3aVBkx1ar8+pvpaU71bJ9BoiNqo3TghJjjNzz7ZxVi
	 +iXQ2PCnj+Kr2kvSccvRhenH63anzn924wF3AcDg=
Date: Wed, 06 Nov 2024 13:28:31 -0800
To: mm-commits@vger.kernel.org,nathan@kernel.org,rppt@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + x86-module-prepare-module-loading-for-rox-allocations-of-text-fix.patch added to mm-unstable branch
Message-Id: <20241106212832.4CAEBC4CEC6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: x86/alternatives: fix writable address in cfi_rewrite_endbr()
has been added to the -mm mm-unstable branch.  Its filename is
     x86-module-prepare-module-loading-for-rox-allocations-of-text-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/x86-module-prepare-module-loading-for-rox-allocations-of-text-fix.patch

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
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Subject: x86/alternatives: fix writable address in cfi_rewrite_endbr()
Date: Tue, 5 Nov 2024 10:49:57 +0200

Commit ("x86/module: prepare module loading for ROX allocations of text")
missed the offset that should be added to the writable address passed to
poison_endbr() from cfi_rewrite_endbr() and this causes boot failures on
kernels running with cfi=fineibt on machines that support IBT.

Add required offset to wr_addr argument to fix the issue.

Link: https://lkml.kernel.org/r/ZysRwR29Ji8CcbXc@kernel.org
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Reported-by: Nathan Chancellor <nathan@kernel.org>
Tested-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/alternative.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/kernel/alternative.c~x86-module-prepare-module-loading-for-rox-allocations-of-text-fix
+++ a/arch/x86/kernel/alternative.c
@@ -1241,7 +1241,7 @@ static void cfi_rewrite_endbr(s32 *start
 		void *addr = (void *)s + *s;
 		void *wr_addr = module_writable_address(mod, addr);
 
-		poison_endbr(addr+16, wr_addr, false);
+		poison_endbr(addr + 16, wr_addr + 16, false);
 	}
 }
 
_

Patches currently in -mm which might be from rppt@kernel.org are

mm-vmalloc-group-declarations-depending-on-config_mmu-together.patch
mm-vmalloc-dont-account-for-number-of-nodes-for-huge_vmap-allocations.patch
asm-generic-introduce-text-patchingh.patch
module-prepare-to-handle-rox-allocations-for-text.patch
arch-introduce-set_direct_map_valid_noflush.patch
x86-module-prepare-module-loading-for-rox-allocations-of-text.patch
x86-module-prepare-module-loading-for-rox-allocations-of-text-fix.patch
execmem-add-support-for-cache-of-large-rox-pages.patch
x86-module-enable-rox-caches-for-module-text-on-64-bit.patch

