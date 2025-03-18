Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F67E1A8413
	for <mm-commits@vger.kernel.org>; Tue, 18 Mar 2025 05:09:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742274577; cv=none; b=bFVv8JZ4r0NXp+BwMdH2LjRUSj+fSDpnoOPdDBFAjX6Va+5Zey6wUEHzK6M+tWKmlf0wfZdkHvA7Muzns6C+HfpnT513lQ7nT3ch8QUujinhVV4M7o6oaeySejKvDLyK+VFFPRq2fwlrofZaTSqnWmnA8D5P5IUzG5Y9VGUfBMs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742274577; c=relaxed/simple;
	bh=TwwFgxCrh8m3BbOVSQkCDdstiuNC47lzdxlmReiR1eo=;
	h=Date:To:From:Subject:Message-Id; b=Ehl//vY7eHFJI60S4b5zjq8hT+O0p6y1/7Tj7B5XEYWX9ugzALclbkk0cSAzy5tbAl4sQTfna7pACQ8RRloDO6XF8Auh5AkUxPM/pTDrPeB91viqihUmpCJG65MyKhAnHGy1SkiVMiXdj2AATbwntIzxDSVhU5v/NLmtqu5k+bs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=G9DmPNxP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="G9DmPNxP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AE32C4CEDD;
	Tue, 18 Mar 2025 05:09:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742274577;
	bh=TwwFgxCrh8m3BbOVSQkCDdstiuNC47lzdxlmReiR1eo=;
	h=Date:To:From:Subject:From;
	b=G9DmPNxP41azBjX1lkontQ5w02kEHqNoe9BA+VSOx3USgrjDBcre4hrc4Q0V6kUzF
	 LjRt0VPPWyR+sKIxMojFm4bPDDVrGXAvV6CmMfXCUdBcLv+xa6wNTLyBkU0MLoP2AJ
	 KG8oEa2Z6j5EKqjs+njI4DBQORFkKBo2n6Aypdak=
Date: Mon, 17 Mar 2025 22:09:36 -0700
To: mm-commits@vger.kernel.org,will@kernel.org,vgupta@kernel.org,tsbogend@alpha.franken.de,tglx@linutronix.de,shorne@gmail.com,richard@nod.at,palmer@dabbelt.com,mpe@ellerman.id.au,monstr@monstr.eu,mingo@redhat.com,mattst88@gmail.com,maddy@linux.ibm.com,luto@kernel.org,linux@armlinux.org.uk,johannes@sipsolutions.net,jiaxun.yang@flygoat.com,jcmvbkbc@gmail.com,hca@linux.ibm.com,guoren@kernel.org,gor@linux.ibm.com,glaubitz@physik.fu-berlin.de,gerald.schaefer@linux.ibm.com,geert@linux-m68k.org,dinguyen@kernel.org,deller@gmx.de,davem@davemloft.net,dave.hansen@linux.intel.com,chenhuacai@kernel.org,catalin.marinas@arm.com,broonie@kernel.org,bp@alien8.de,arnd@arndb.de,ardb@kernel.org,andreas@gaisler.com,agordeev@linux.ibm.com,rppt@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mips-make-setup_zero_pages-use-memblock.patch removed from -mm tree
Message-Id: <20250318050937.2AE32C4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: MIPS: make setup_zero_pages() use memblock
has been removed from the -mm tree.  Its filename was
     mips-make-setup_zero_pages-use-memblock.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Subject: MIPS: make setup_zero_pages() use memblock
Date: Thu, 13 Mar 2025 15:49:55 +0200

Allocating the zero pages from memblock is simpler because the memory is
already reserved.

This will also help with pulling out memblock_free_all() to the generic
code and reducing code duplication in arch::mem_init().

Link: https://lkml.kernel.org/r/20250313135003.836600-6-rppt@kernel.org
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

 arch/mips/include/asm/mmzone.h |    2 --
 arch/mips/mm/init.c            |   18 +++++-------------
 2 files changed, 5 insertions(+), 15 deletions(-)

--- a/arch/mips/include/asm/mmzone.h~mips-make-setup_zero_pages-use-memblock
+++ a/arch/mips/include/asm/mmzone.h
@@ -20,6 +20,4 @@
 #define nid_to_addrbase(nid) 0
 #endif
 
-extern void setup_zero_pages(void);
-
 #endif /* _ASM_MMZONE_H_ */
--- a/arch/mips/mm/init.c~mips-make-setup_zero_pages-use-memblock
+++ a/arch/mips/mm/init.c
@@ -59,24 +59,16 @@ EXPORT_SYMBOL(zero_page_mask);
 /*
  * Not static inline because used by IP27 special magic initialization code
  */
-void setup_zero_pages(void)
+static void __init setup_zero_pages(void)
 {
-	unsigned int order, i;
-	struct page *page;
+	unsigned int order;
 
 	if (cpu_has_vce)
 		order = 3;
 	else
 		order = 0;
 
-	empty_zero_page = __get_free_pages(GFP_KERNEL | __GFP_ZERO, order);
-	if (!empty_zero_page)
-		panic("Oh boy, that early out of memory?");
-
-	page = virt_to_page((void *)empty_zero_page);
-	split_page(page, order);
-	for (i = 0; i < (1 << order); i++, page++)
-		mark_page_reserved(page);
+	empty_zero_page = (unsigned long)memblock_alloc_or_panic(PAGE_SIZE << order, PAGE_SIZE);
 
 	zero_page_mask = ((PAGE_SIZE << order) - 1) & PAGE_MASK;
 }
@@ -470,9 +462,9 @@ void __init mem_init(void)
 	BUILD_BUG_ON(IS_ENABLED(CONFIG_32BIT) && (PFN_PTE_SHIFT > PAGE_SHIFT));
 
 	maar_init();
-	memblock_free_all();
 	setup_zero_pages();	/* Setup zeroed pages.  */
 	mem_init_free_highmem();
+	memblock_free_all();
 
 #ifdef CONFIG_64BIT
 	if ((unsigned long) &_text > (unsigned long) CKSEG0)
@@ -486,8 +478,8 @@ void __init mem_init(void)
 void __init mem_init(void)
 {
 	high_memory = (void *) __va(get_num_physpages() << PAGE_SHIFT);
-	memblock_free_all();
 	setup_zero_pages();	/* This comes from node 0 */
+	memblock_free_all();
 }
 #endif /* !CONFIG_NUMA */
 
_

Patches currently in -mm which might be from rppt@kernel.org are

mm-mm_init-rename-__init_reserved_page_zone-to-__init_page_from_nid.patch
mm-mm_init-rename-init_reserved_page-to-init_deferred_page.patch

