Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE07C85931
	for <mm-commits@vger.kernel.org>; Wed, 23 Apr 2025 21:36:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745444191; cv=none; b=Rc5LspgqDr7Z67GvlUlU01z3/t+76vG/DCK1g66CFQO0zaEWTkbXieP/TRsko5Xa/9xBT/sIy+YmdaWiYKNScjWPKm1okRegMHXnJc7lc5YcXgcjRO3VXbu3RSiJ/akRV/rmRh4482lILUK3bysdNhGbtHhpI44jwOJ8/xaOVRg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745444191; c=relaxed/simple;
	bh=VDL0okLu+9p2BY/EFTn/4zVQuaBTWleqrbqN8W6+vhY=;
	h=Date:To:From:Subject:Message-Id; b=WpqTPK3dagaFEzYXhRt0Tyui8QoNXrIDrd8aM82AZBYQYCPFt9upN0CcvPLhSNLePPvnm363Hj/0XKBrZXA585yFJtL2FfvOJf9Xkqou+rG63S4FMsp+3UEQZ00NOS2Y3AtEeG+gU+omN8gyoM0Y/ReX8eI5cfWLGosPQRbXbAg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=JzcWT27f; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="JzcWT27f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DAC8C4CEE2;
	Wed, 23 Apr 2025 21:36:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1745444191;
	bh=VDL0okLu+9p2BY/EFTn/4zVQuaBTWleqrbqN8W6+vhY=;
	h=Date:To:From:Subject:From;
	b=JzcWT27fu0gq23TdAokdLINLQGFowpXo1zzdDEm+BtgGrFxc/938SvPlxt3TUR+Lp
	 V+3jdrIHKCR/8jhPs2g7INAbgTCcRhV4ojN2ARFU7rMkSYjmGO+Qe5AI1G8it6/57A
	 2lNnuls2xpq2hXYx6PcZj5r4AAjwMKwLhHlK0qZU=
Date: Wed, 23 Apr 2025 14:36:29 -0700
To: mm-commits@vger.kernel.org,peterz@infradead.org,rppt@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + execmem-enforce-allocation-size-aligment-to-page_size.patch added to mm-unstable branch
Message-Id: <20250423213631.0DAC8C4CEE2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: execmem: enforce allocation size aligment to PAGE_SIZE
has been added to the -mm mm-unstable branch.  Its filename is
     execmem-enforce-allocation-size-aligment-to-page_size.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/execmem-enforce-allocation-size-aligment-to-page_size.patch

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
Subject: execmem: enforce allocation size aligment to PAGE_SIZE
Date: Wed, 23 Apr 2025 17:48:07 +0300

Before introduction of ROX cache execmem allocation size was always
implicitly aligned to PAGE_SIZE inside vmalloc.

However, when allocation happens from the ROX cache, this is not
enforced.

Make sure that the allocation size is always consistently aligned to
PAGE_SIZE.

Link: https://lkml.kernel.org/r/20250423144808.1619863-1-rppt@kernel.org
Fixes: 2e45474ab14f ("execmem: add support for cache of large ROX pages")
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Suggested-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/execmem.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/mm/execmem.c~execmem-enforce-allocation-size-aligment-to-page_size
+++ a/mm/execmem.c
@@ -377,6 +377,8 @@ void *execmem_alloc(enum execmem_type ty
 	pgprot_t pgprot = range->pgprot;
 	void *p;
 
+	size = PAGE_ALIGN(size);
+
 	if (use_cache)
 		p = execmem_cache_alloc(range, size);
 	else
_

Patches currently in -mm which might be from rppt@kernel.org are

memblock-add-memblock_rsrv_kern-flag.patch
memblock-introduce-memmap_init_kho_scratch.patch
kexec-enable-kho-support-for-memory-preservation.patch
x86-setup-use-memblock_reserve_kern-for-memory-used-by-kernel.patch
documentation-kho-add-memblock-bindings.patch
execmem-enforce-allocation-size-aligment-to-page_size.patch

