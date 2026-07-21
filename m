Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B56C14746C3
	for <mm-commits@vger.kernel.org>; Tue, 21 Jul 2026 21:03:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784667833; cv=none; b=P6SctUMzs9pCGXGNj5VawSLkmcZRYdj+TH9ELKuUJ51lBj8Ob/yZ+E9x7pVgGDPUwy+PSLmS69XVGKB+nZx6fhzLRsvpM1E99Sts0zwTVCCi9JtnsCoNev9wbD+vq8piQa3HqWNtnXFqd3R4KL7RHB+DZl0H6QFC0Ihqa0xremQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784667833; c=relaxed/simple;
	bh=QUJZREfTblE9FGe+hVR0gcdzN9/4wD3QJb7wfD+a8rQ=;
	h=Date:To:From:Subject:Message-Id; b=hjnkEpljvnpOCMulDb86cvwIDPxU0NQkhcOv3yFtTwkFK6XLHY0SSy+7WpgVwYxmfP3axDVp8iO+ohHiY5BgixBBEoXuBjDUUGYJ3WYuytwsOQj11kwrjD+9QfXPuei2ZBqVkJIIH2FygVNynghAoCs/cGdjGvjfzbMq4bDm/SI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=y0rQWxA3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="y0rQWxA3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7C1E1F000E9;
	Tue, 21 Jul 2026 21:03:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1784667829;
	bh=tDkAvE/b6P1oNXsu/HdDmHGoStgswJuo0unYId/N6hI=;
	h=Date:To:From:Subject;
	b=y0rQWxA3/EqwrfjXMCdGPHLkvD6ltmT1QUM2xfEpKB5GfAj2ZwOhToaL6QTWZa4fs
	 OUobdd7/ctWeAYFqPdMCiUQHSmvwhiTpQtbZ0+6MawqStW+7uhWIOqfIGKrcriKXDU
	 Qyj1kJPHmlrqq7UH8uBsBAz/pDV/qqGizCEHQyxU=
Date: Tue, 21 Jul 2026 14:03:48 -0700
To: mm-commits@vger.kernel.org,will@kernel.org,vbabka@kernel.org,surenb@google.com,rppt@kernel.org,palmer@dabbelt.com,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,david@kernel.org,catalin.marinas@arm.com,aou@eecs.berkeley.edu,alex@ghiti.fr,ekffu200098@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-early_ioremap-clarify-early_ioremap_reset-semantics.patch added to mm-new branch
Message-Id: <20260721210348.D7C1E1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/early_ioremap: clarify early_ioremap_reset() semantics
has been added to the -mm mm-new branch.  Its filename is
     mm-early_ioremap-clarify-early_ioremap_reset-semantics.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-early_ioremap-clarify-early_ioremap_reset-semantics.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

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
From: Sang-Heon Jeon <ekffu200098@gmail.com>
Subject: mm/early_ioremap: clarify early_ioremap_reset() semantics
Date: Thu, 9 Jul 2026 02:06:45 +0900

Patch series "mm/early_ioremap: clarify and clean up
early_ioremap_reset()".

__late_set_fixmap() and __late_clear_fixmap() are only used after
early_ioremap_reset() has been called, but the comment above them does not
say anything about that.  So arm64, riscv and powerpc, whose
__set_fixmap() works before and after paging_init(), describe the same
situation in three different ways:

                 calls reset    defines the macros
        arm64    yes            yes
        riscv    no             yes
        powerpc  no             no

Patch 1 documents when early_ioremap_reset() needs to be called and that
only architectures calling it need to define the macros.

Patches 2 and 3 remove the unneeded riscv macros, which are unreachable,
and the arm64 reset call and macros, which change nothing.

No functional change.


This patch (of 3):

__late_set_fixmap() and __late_clear_fixmap() are only used after
early_ioremap_reset() has been called.

arm64, riscv and powerpc all have a __set_fixmap() that works before and
after paging_init(), so they do not need to call early_ioremap_reset() or
define the macros, but they describe the same situation in three different
ways:

                 calls reset    defines the macros
        arm64    yes            yes
        riscv    no             yes
        powerpc  no             no

The existing comment is vague and allows all three.  Replace it with
comments that make it clear when the reset and the macros are needed.

No functional change.

Link: https://lore.kernel.org/20260708170647.362562-1-ekffu200098@gmail.com
Link: https://lore.kernel.org/20260708170647.362562-2-ekffu200098@gmail.com
Signed-off-by: Sang-Heon Jeon <ekffu200098@gmail.com>
Cc: Albert Ou <aou@eecs.berkeley.edu>
Cc: Alexandre Ghiti <alex@ghiti.fr>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/early_ioremap.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

--- a/mm/early_ioremap.c~mm-early_ioremap-clarify-early_ioremap_reset-semantics
+++ a/mm/early_ioremap.c
@@ -47,15 +47,19 @@ pgprot_t __init __weak early_memremap_pg
 	return prot;
 }
 
+/*
+ * Only architectures whose early_ioremap() must stop using __early_set_fixmap()
+ * after paging_init() need to call this.
+ */
 void __init early_ioremap_reset(void)
 {
 	after_paging_init = 1;
 }
 
 /*
- * Generally, ioremap() is available after paging_init() has been called.
- * Architectures wanting to allow early_ioremap after paging_init() can
- * define __late_set_fixmap and __late_clear_fixmap to do the right thing.
+ * Only architectures that call early_ioremap_reset() need to define
+ * __late_set_fixmap() and __late_clear_fixmap(), which early_ioremap() uses
+ * instead of __early_set_fixmap() after the reset.
  */
 #ifndef __late_set_fixmap
 static inline void __init __late_set_fixmap(enum fixed_addresses idx,
_

Patches currently in -mm which might be from ekffu200098@gmail.com are

arch_numa-remove-redundant-nodemask-clears-in-numa_init.patch
mm-early_ioremap-clarify-early_ioremap_reset-semantics.patch
riscv-remove-unused-__late_set_fixmap-and-__late_clear_fixmap.patch
arm64-remove-early_ioremap_reset-call-and-__late_-macros.patch

