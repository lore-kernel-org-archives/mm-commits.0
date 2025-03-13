Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E2AF78F37
	for <mm-commits@vger.kernel.org>; Thu, 13 Mar 2025 21:01:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741899707; cv=none; b=KnU542SYEG+xh03awZILqIq50+5z1DogPt77IQLtJ/lJ7QIm+g0c+7/zj/q59ExTPYMEdi6sZCy0lyPSNfvW1lKO3WtQjwBzBP2quvdWkz7hu3Bb1DdvgMe+OxhaQejsHo7Wm7gi0einZEyfRAdu3qbCkMmHn1YMt0yqSHLZ3Jo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741899707; c=relaxed/simple;
	bh=7GFnZMA7IUPJGmfWWMjt6yNMl8ncMR2t75Dtkfh0p7k=;
	h=Date:To:From:Subject:Message-Id; b=k2rMOHrsSep7nv/oEUjp0mmByEI6rSk82d8r6CrfS2ypED1hvlMtUycTnk0qaTWO2OziC2HejGsVNaTh3Pfb5OeVWzWkZ889Y/Yl7sbyhBV+X7i2CfQ5loXvvVassxu9S2TBBpKAWp9z3cx2FIHK062kLK7P0SJF76IBmZK2kW8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=DqXnCYxR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="DqXnCYxR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F2C5C4CEDD;
	Thu, 13 Mar 2025 21:01:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1741899706;
	bh=7GFnZMA7IUPJGmfWWMjt6yNMl8ncMR2t75Dtkfh0p7k=;
	h=Date:To:From:Subject:From;
	b=DqXnCYxRRsMo+2vmDz7n7NFzuhI6z/h3qOFYD/rjUjognGxNq90qLDLsFZUM7F9T2
	 wTm0SrFCkHoXcMe/6eksot/9OQkxpS/4auKUUruGlcHQLhh4NQRe2HOjXi0cIaUjtJ
	 yx8Zb/YtjTvllcJKCELA+b8VZ4QgW+CIYVKpm/GI=
Date: Thu, 13 Mar 2025 14:01:45 -0700
To: mm-commits@vger.kernel.org,will@kernel.org,vgupta@kernel.org,tsbogend@alpha.franken.de,tglx@linutronix.de,shorne@gmail.com,richard@nod.at,palmer@dabbelt.com,mpe@ellerman.id.au,monstr@monstr.eu,mingo@redhat.com,mattst88@gmail.com,maddy@linux.ibm.com,luto@kernel.org,linux@armlinux.org.uk,johannes@sipsolutions.net,jiaxun.yang@flygoat.com,jcmvbkbc@gmail.com,hca@linux.ibm.com,guoren@kernel.org,gor@linux.ibm.com,glaubitz@physik.fu-berlin.de,gerald.schaefer@linux.ibm.com,geert@linux-m68k.org,dinguyen@kernel.org,deller@gmx.de,davem@davemloft.net,dave.hansen@linux.intel.com,chenhuacai@kernel.org,catalin.marinas@arm.com,broonie@kernel.org,bp@alien8.de,arnd@arndb.de,ardb@kernel.org,andreas@gaisler.com,agordeev@linux.ibm.com,rppt@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + arm-mem_init-use-memblock_phys_free-to-free-dma-memory-on-sa1111.patch added to mm-unstable branch
Message-Id: <20250313210146.8F2C5C4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: arm: mem_init: use memblock_phys_free() to free DMA memory on SA1111
has been added to the -mm mm-unstable branch.  Its filename is
     arm-mem_init-use-memblock_phys_free-to-free-dma-memory-on-sa1111.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/arm-mem_init-use-memblock_phys_free-to-free-dma-memory-on-sa1111.patch

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
Subject: arm: mem_init: use memblock_phys_free() to free DMA memory on SA1111
Date: Thu, 13 Mar 2025 15:49:51 +0200

Patch series "arch, mm: reduce code duplication in mem_init()", v2.

Every architecture has implementation of mem_init() function and some even
more than one.  All these release free memory to the buddy allocator, most
of them set high_memory to the end of directly addressable memory and many
of them set max_mapnr for FLATMEM case.

These patches pull the commonalities into the generic code and refactor
some of the mem_init() implementations so that many of them can be just
dropped.


This patch (of 13):

This will help to pull out memblock_free_all() to generic code.

Link: https://lkml.kernel.org/r/20250313135003.836600-1-rppt@kernel.org
Link: https://lkml.kernel.org/r/20250313135003.836600-2-rppt@kernel.org
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Tested-by: Mark Brown <broonie@kernel.org>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Andreas Larsson <andreas@gaisler.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Ard Biesheuvel <ardb@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Borislav Betkov <bp@alien8.de>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Dinh Nguyen <dinguyen@kernel.org>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Cc: Guo Ren <guoren@kernel.org>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Helge Deller <deller@gmx.de>
Cc: Huacai Chen <chenhuacai@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jiaxun Yang <jiaxun.yang@flygoat.com>
Cc: Johannes Berg <johannes@sipsolutions.net>
Cc: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Matt Turner <mattst88@gmail.com>
Cc: Max Filippov <jcmvbkbc@gmail.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Michal Simek <monstr@monstr.eu>
Cc: "Mike Rapoport (IBM)" <rppt@kernel.org>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Richard Weinberger <richard@nod.at>
Cc: Russel King <linux@armlinux.org.uk>
Cc: Stafford Horne <shorne@gmail.com>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: Thomas Gleinxer <tglx@linutronix.de>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Vineet Gupta <vgupta@kernel.org>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/mm/init.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/arch/arm/mm/init.c~arm-mem_init-use-memblock_phys_free-to-free-dma-memory-on-sa1111
+++ a/arch/arm/mm/init.c
@@ -277,14 +277,14 @@ void __init mem_init(void)
 
 	set_max_mapnr(pfn_to_page(max_pfn) - mem_map);
 
-	/* this will put all unused low memory onto the freelists */
-	memblock_free_all();
-
 #ifdef CONFIG_SA1111
 	/* now that our DMA memory is actually so designated, we can free it */
-	free_reserved_area(__va(PHYS_OFFSET), swapper_pg_dir, -1, NULL);
+	memblock_phys_free(PHYS_OFFSET, __pa(swapper_pg_dir) - PHYS_OFFSET);
 #endif
 
+	/* this will put all unused low memory onto the freelists */
+	memblock_free_all();
+
 	free_highpages();
 
 	/*
_

Patches currently in -mm which might be from rppt@kernel.org are

arm-mem_init-use-memblock_phys_free-to-free-dma-memory-on-sa1111.patch
csky-move-setup_initrd-to-setupc.patch
hexagon-move-initialization-of-init_mmcontext-init-to-paging_init.patch
mips-consolidate-mem_init-for-numa-machines.patch
mips-make-setup_zero_pages-use-memblock.patch
nios2-move-pr_debug-about-memory-start-and-end-to-setup_arch.patch
s390-make-setup_zero_pages-use-memblock.patch
xtensa-split-out-printing-of-virtual-memory-layout-to-a-function.patch
arch-mm-set-max_mapnr-when-allocating-memory-map-for-flatmem.patch
arch-mm-set-high_memory-in-free_area_init.patch
arch-mm-streamline-highmem-freeing.patch
arch-mm-introduce-arch_mm_preinit.patch
arch-mm-make-releasing-of-memory-to-page-allocator-more-explicit.patch

