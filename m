Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A401A78F37
	for <mm-commits@vger.kernel.org>; Thu, 13 Mar 2025 21:01:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741899711; cv=none; b=AHD9ec0emdqEQ29yKyWzFBGOqCeWjl/Bak1xL916fM5dAcnkG6bjZDUA/TJbhCch5m+xXZ7cnWuzfAB5srhPXn6gz4blB417EnPKPT2XoJ8PbM/nLbwVuY7caGlG5rZo2va+boMRb9CcLW+hU64NPExBi8lP7E7QGMefjoLeMd4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741899711; c=relaxed/simple;
	bh=IBy1dhz3qLhOE+vDZw8tFJ0nsLpBNdGNG4BBDd6fv9E=;
	h=Date:To:From:Subject:Message-Id; b=i27Hu1SucM6bfmcazCLLRFG8dYZ+Di6xL7idnbgeEghhBZaGEbc/RO6789Lo/exiem2l2kR1cM04ZTnb0D1MrOEIHQ9sM7hsgYLcnEchurxiLG2Rj3RFMo3UzilT4tf34lrSEgUIRS4iLPubTof2VmCwnC6enfCanJeBOYu7yWc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=vEL+Rh6D; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="vEL+Rh6D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D306C4CEDD;
	Thu, 13 Mar 2025 21:01:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1741899711;
	bh=IBy1dhz3qLhOE+vDZw8tFJ0nsLpBNdGNG4BBDd6fv9E=;
	h=Date:To:From:Subject:From;
	b=vEL+Rh6Dg/oe703W0SNavrbdSCrV3X9EeVqqYclvrseMiKL1tC7tWtGuuHKo0RzN6
	 eAZi3dyWW9JdrbbmcmLTvdRKpPv3/ItGZOR84rvavu8fM3JJybMLyYLzye5xw7GV+M
	 mwdEa5gJDAQuaUtsdmkPhtjMaXQLex07dI0hrYEw=
Date: Thu, 13 Mar 2025 14:01:50 -0700
To: mm-commits@vger.kernel.org,will@kernel.org,vgupta@kernel.org,tsbogend@alpha.franken.de,tglx@linutronix.de,shorne@gmail.com,richard@nod.at,palmer@dabbelt.com,mpe@ellerman.id.au,monstr@monstr.eu,mingo@redhat.com,mattst88@gmail.com,maddy@linux.ibm.com,luto@kernel.org,linux@armlinux.org.uk,johannes@sipsolutions.net,jiaxun.yang@flygoat.com,jcmvbkbc@gmail.com,hca@linux.ibm.com,guoren@kernel.org,gor@linux.ibm.com,glaubitz@physik.fu-berlin.de,gerald.schaefer@linux.ibm.com,geert@linux-m68k.org,dinguyen@kernel.org,deller@gmx.de,davem@davemloft.net,dave.hansen@linux.intel.com,chenhuacai@kernel.org,catalin.marinas@arm.com,broonie@kernel.org,bp@alien8.de,arnd@arndb.de,ardb@kernel.org,andreas@gaisler.com,agordeev@linux.ibm.com,rppt@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mips-consolidate-mem_init-for-numa-machines.patch added to mm-unstable branch
Message-Id: <20250313210151.0D306C4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: MIPS: consolidate mem_init() for NUMA machines
has been added to the -mm mm-unstable branch.  Its filename is
     mips-consolidate-mem_init-for-numa-machines.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mips-consolidate-mem_init-for-numa-machines.patch

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
Subject: MIPS: consolidate mem_init() for NUMA machines
Date: Thu, 13 Mar 2025 15:49:54 +0200

Both MIPS systems that support numa (loongsoon3 and sgi-ip27) have
identical mem_init() for NUMA case.

Move that into arch/mips/mm/init.c and drop duplicate per-machine
definitions.

Link: https://lkml.kernel.org/r/20250313135003.836600-5-rppt@kernel.org
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
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
Cc: Guo Ren (csky) <guoren@kernel.org>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Helge Deller <deller@gmx.de>
Cc: Huacai Chen <chenhuacai@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jiaxun Yang <jiaxun.yang@flygoat.com>
Cc: Johannes Berg <johannes@sipsolutions.net>
Cc: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Mark Brown <broonie@kernel.org>
Cc: Matt Turner <mattst88@gmail.com>
Cc: Max Filippov <jcmvbkbc@gmail.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Michal Simek <monstr@monstr.eu>
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

 arch/mips/loongson64/numa.c      |    7 -------
 arch/mips/mm/init.c              |    7 +++++++
 arch/mips/sgi-ip27/ip27-memory.c |    9 ---------
 3 files changed, 7 insertions(+), 16 deletions(-)

--- a/arch/mips/loongson64/numa.c~mips-consolidate-mem_init-for-numa-machines
+++ a/arch/mips/loongson64/numa.c
@@ -164,13 +164,6 @@ void __init paging_init(void)
 	free_area_init(zones_size);
 }
 
-void __init mem_init(void)
-{
-	high_memory = (void *) __va(get_num_physpages() << PAGE_SHIFT);
-	memblock_free_all();
-	setup_zero_pages();	/* This comes from node 0 */
-}
-
 /* All PCI device belongs to logical Node-0 */
 int pcibus_to_node(struct pci_bus *bus)
 {
--- a/arch/mips/mm/init.c~mips-consolidate-mem_init-for-numa-machines
+++ a/arch/mips/mm/init.c
@@ -482,6 +482,13 @@ void __init mem_init(void)
 				0x80000000 - 4, KCORE_TEXT);
 #endif
 }
+#else  /* CONFIG_NUMA */
+void __init mem_init(void)
+{
+	high_memory = (void *) __va(get_num_physpages() << PAGE_SHIFT);
+	memblock_free_all();
+	setup_zero_pages();	/* This comes from node 0 */
+}
 #endif /* !CONFIG_NUMA */
 
 void free_init_pages(const char *what, unsigned long begin, unsigned long end)
--- a/arch/mips/sgi-ip27/ip27-memory.c~mips-consolidate-mem_init-for-numa-machines
+++ a/arch/mips/sgi-ip27/ip27-memory.c
@@ -406,8 +406,6 @@ void __init prom_meminit(void)
 	}
 }
 
-extern void setup_zero_pages(void);
-
 void __init paging_init(void)
 {
 	unsigned long zones_size[MAX_NR_ZONES] = {0, };
@@ -416,10 +414,3 @@ void __init paging_init(void)
 	zones_size[ZONE_NORMAL] = max_low_pfn;
 	free_area_init(zones_size);
 }
-
-void __init mem_init(void)
-{
-	high_memory = (void *) __va(get_num_physpages() << PAGE_SHIFT);
-	memblock_free_all();
-	setup_zero_pages();	/* This comes from node 0 */
-}
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

