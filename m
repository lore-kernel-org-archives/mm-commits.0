Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5855D1BE23D
	for <mm-commits@vger.kernel.org>; Tue,  2 Jul 2024 17:26:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719941214; cv=none; b=iQg8QyB0WC63718emsKefY3QjWcdYbkwQkt/KaIOGqI5NDUuFrRgYV2VRP/r/y9re0BKN3Zbh6Iydl4sPwqNvYNW+RXGf/6GR5gl5sQYLZXrWHhjUoUXWRl5xnkrskYw0lNomUxjldCJuqiFmqzNSTu5IQYAYlJy1+WUhmi1U0E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719941214; c=relaxed/simple;
	bh=1OhR3gU3DQjdCH/pHhlNBIsDPH2GALWrvdNHXFe7EYw=;
	h=Date:To:From:Subject:Message-Id; b=EkHDTlR0HTXVq4Kq1BTRM/OzsHqyRFZ2HpTdn8DzGOGH0WteFrUXlyu5kz/JDADdB2ziIjAcurQWHBmNlkI3xWPZPp0YdaBlDcKxy69A4cU/gUdPbLnAPcwBCPw/W/X0uEHMlstHKuHzMPXXyX9iefv6TR97cSyf09AMyYr4IuA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=T2Ycgb9Y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="T2Ycgb9Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0856AC4AF0C;
	Tue,  2 Jul 2024 17:26:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719941214;
	bh=1OhR3gU3DQjdCH/pHhlNBIsDPH2GALWrvdNHXFe7EYw=;
	h=Date:To:From:Subject:From;
	b=T2Ycgb9YCKFAzUUzHpJty/zMK5XReAyrqLbiu2UlEBSDZMBJBpiKKqMX5k4V9JhVm
	 UUV6XyNEonneS169wcemE0oJ2b0WoJZHF9W9LlWDBlQcvgt3TgZeX4UqytG4xQpl6B
	 9I7v0CcjCe5c2qfUbzufOnxs5AIRZdN14uT39u6Y=
Date: Tue, 02 Jul 2024 10:26:53 -0700
To: mm-commits@vger.kernel.org,peterx@redhat.com,osalvador@suse.de,npiggin@gmail.com,mpe@ellerman.id.au,jgg@nvidia.com,christophe.leroy@csgroup.eu,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + powerpc-e500-dont-pre-check-write-access-on-data-tlb-error.patch added to mm-unstable branch
Message-Id: <20240702172654.0856AC4AF0C@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: powerpc/e500: don't pre-check write access on data TLB error
has been added to the -mm mm-unstable branch.  Its filename is
     powerpc-e500-dont-pre-check-write-access-on-data-tlb-error.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/powerpc-e500-dont-pre-check-write-access-on-data-tlb-error.patch

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
From: Christophe Leroy <christophe.leroy@csgroup.eu>
Subject: powerpc/e500: don't pre-check write access on data TLB error
Date: Tue, 2 Jul 2024 15:51:30 +0200

Don't pre-check write access on read-only pages on data TLB error.

Load the TLB anyway and take a DSI exception when it happens.  This avoids
reading SPRN_ESR at every data TLB error exception.

Link: https://lkml.kernel.org/r/8525518e1657d6032b7e980c1888102828d66950.1719928057.git.christophe.leroy@csgroup.eu
Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Peter Xu <peterx@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/kernel/head_85xx.S |   15 ---------------
 1 file changed, 15 deletions(-)

--- a/arch/powerpc/kernel/head_85xx.S~powerpc-e500-dont-pre-check-write-access-on-data-tlb-error
+++ a/arch/powerpc/kernel/head_85xx.S
@@ -472,27 +472,12 @@ END_BTB_FLUSH_SECTION
 #endif
 
 4:
-	/* Mask of required permission bits. Note that while we
-	 * do copy ESR:ST to _PAGE_WRITE position as trying to write
-	 * to an RO page is pretty common, we don't do it with
-	 * _PAGE_DIRTY. We could do it, but it's a fairly rare
-	 * event so I'd rather take the overhead when it happens
-	 * rather than adding an instruction here. We should measure
-	 * whether the whole thing is worth it in the first place
-	 * as we could avoid loading SPRN_ESR completely in the first
-	 * place...
-	 *
-	 * TODO: Is it worth doing that mfspr & rlwimi in the first
-	 *       place or can we save a couple of instructions here ?
-	 */
-	mfspr	r12,SPRN_ESR
 #ifdef CONFIG_PTE_64BIT
 	li	r13,_PAGE_PRESENT|_PAGE_BAP_SR
 	oris	r13,r13,_PAGE_ACCESSED@h
 #else
 	li	r13,_PAGE_PRESENT|_PAGE_READ|_PAGE_ACCESSED
 #endif
-	rlwimi	r13,r12,11,29,29
 
 	FIND_PTE
 	andc.	r13,r13,r11		/* Check permission */
_

Patches currently in -mm which might be from christophe.leroy@csgroup.eu are

mm-define-__pte_leaf_size-to-also-take-a-pmd-entry.patch
mm-provide-mm_struct-and-address-to-huge_ptep_get.patch
powerpc-mm-remove-_page_psize.patch
powerpc-mm-fix-__find_linux_pte-on-32-bits-with-pmd-leaf-entries.patch
powerpc-mm-allow-hugepages-without-hugepd.patch
powerpc-8xx-fix-size-given-to-set_huge_pte_at.patch
powerpc-8xx-rework-support-for-8m-pages-using-contiguous-pte-entries.patch
powerpc-8xx-simplify-struct-mmu_psize_def.patch
powerpc-e500-remove-enc-and-ind-fields-from-struct-mmu_psize_def.patch
powerpc-e500-switch-to-64-bits-pgd-on-85xx-32-bits.patch
powerpc-e500-encode-hugepage-size-in-pte-bits.patch
powerpc-e500-dont-pre-check-write-access-on-data-tlb-error.patch
powerpc-e500-free-r10-for-find_pte.patch
powerpc-e500-use-contiguous-pmd-instead-of-hugepd.patch
powerpc-64s-use-contiguous-pmd-pud-instead-of-hugepd.patch
powerpc-mm-remove-hugepd-leftovers.patch
mm-remove-config_arch_has_hugepd.patch

