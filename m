Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D77FE145355
	for <mm-commits@vger.kernel.org>; Wed, 12 Mar 2025 21:49:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741816164; cv=none; b=kQFrJ9kJ/Xzsmo2FvAjw6VEbb540+/kA5K/86q/t0BcaYjtwQLrprwbAOqOSSS0NF2bkhWjjbmrPlTmkQsSxECWzDvFbc9BV8UHwGB+RpbKwwRVbb+tVYFxvBim3auZaffNgEoKOKAnmrUHieAgQD3vUA5PqvJdhaNvuSOSJSQc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741816164; c=relaxed/simple;
	bh=qdpXWaLrE0VaDx1IDrZfH13PxEHhNx5mVxvzV4Am3Zw=;
	h=Date:To:From:Subject:Message-Id; b=YQATWj2eZSkYj70J0ZmnelLiz41+tbSstZPrZZyBEbKnAXwBOkxyDNaijLmNCrXwk88NceJ5B/nFi4PmdO2mSgOLooMTUVuA7TTqMxGSANhXs0Tco63KT9vyzKYZ+J1iTuNP6Y0+KfETl0RulB26za+vCKocpkmhHA4xebUMdHY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=nDbIDc/U; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="nDbIDc/U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EC4DC4CEDD;
	Wed, 12 Mar 2025 21:49:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1741816163;
	bh=qdpXWaLrE0VaDx1IDrZfH13PxEHhNx5mVxvzV4Am3Zw=;
	h=Date:To:From:Subject:From;
	b=nDbIDc/UpwqkCJ/mE1mb6PCxg7ZnsC6x2h/61xxQxMJGQ6t82ve9OMaaVNGBd7vvK
	 IU38Ak3xpaH/Z4L6BzfoIj++q5NbbO4ZOXpHv1VG6WTJIyBgb0O8tSd8iOE3cfgpTd
	 /VzSoVRGp/3PpogfxQE3mDnowFyY+56aCF/dv4/Q=
Date: Wed, 12 Mar 2025 14:49:22 -0700
To: mm-commits@vger.kernel.org,hca@linux.ibm.com,ardb@kernel.org,rppt@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + s390-make-setup_zero_pages-use-memblock-fix.patch added to mm-unstable branch
Message-Id: <20250312214923.2EC4DC4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: s390: use memblock_alloc_or_panic() in setup_zero_page()
has been added to the -mm mm-unstable branch.  Its filename is
     s390-make-setup_zero_pages-use-memblock-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/s390-make-setup_zero_pages-use-memblock-fix.patch

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
Subject: s390: use memblock_alloc_or_panic() in setup_zero_page()
Date: Tue, 11 Mar 2025 07:51:27 +0200

Link: https://lkml.kernel.org/r/Z8_Qawg0dGtZdys7@kernel.org
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Ard Biesheuvel <ardb@kernel.org>
Cc: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/s390/mm/init.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/arch/s390/mm/init.c~s390-make-setup_zero_pages-use-memblock-fix
+++ a/arch/s390/mm/init.c
@@ -81,9 +81,7 @@ static void __init setup_zero_pages(void
 	while (order > 2 && (total_pages >> 10) < (1UL << order))
 		order--;
 
-	empty_zero_page = (unsigned long)memblock_alloc(PAGE_SIZE << order, order);
-	if (!empty_zero_page)
-		panic("Out of memory in setup_zero_pages");
+	empty_zero_page = (unsigned long)memblock_alloc_or_panic(PAGE_SIZE << order, order);
 
 	zero_page_mask = ((PAGE_SIZE << order) - 1) & PAGE_MASK;
 }
_

Patches currently in -mm which might be from rppt@kernel.org are

arm-mem_init-use-memblock_phys_free-to-free-dma-memory-on-sa1111.patch
csky-move-setup_initrd-to-setupc.patch
hexagon-move-initialization-of-init_mmcontext-init-to-paging_init.patch
mips-consolidate-mem_init-for-numa-machines.patch
mips-make-setup_zero_pages-use-memblock.patch
nios2-move-pr_debug-about-memory-start-and-end-to-setup_arch.patch
s390-make-setup_zero_pages-use-memblock.patch
s390-make-setup_zero_pages-use-memblock-fix.patch
xtensa-split-out-printing-of-virtual-memory-layout-to-a-function.patch
arch-mm-set-max_mapnr-when-allocating-memory-map-for-flatmem.patch
arch-mm-set-high_memory-in-free_area_init.patch
arch-mm-streamline-highmem-freeing.patch
arch-mm-introduce-arch_mm_preinit.patch
arch-mm-make-releasing-of-memory-to-page-allocator-more-explicit.patch

