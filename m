Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 438091C5F1F
	for <mm-commits@vger.kernel.org>; Tue, 18 Mar 2025 05:09:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742274575; cv=none; b=XiJLX7BHOU/9BSgOcUzn96p5t0z/OIq0Wf5CipsxJmEJWpHgoMgYhS7f6ucmuCMpBZg+rix3RLF05LSkhi09rMMp7Yr4P4bYLdRsDmOUGdCJTYHjY6jatQNNDmBLZEehYHjwrbMnnyNLnHaHMrr3QZFMUu87hMAxhW/NqnRKhbo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742274575; c=relaxed/simple;
	bh=YPsoeyTPlfMBi8bYtZKBP2dUpMXBryHP5RdhMmFQL4s=;
	h=Date:To:From:Subject:Message-Id; b=ZZSwMNWWe9rWIhWQHgsYQx78Avwi8i/UpRyUQ2YCNi/4hQtGNbU0IFxTF9jT/e5ESPn04vE/o+CuQVeCMXlzp8NTxSVLiDPO/4xU16dp5L4RjkvIe9g2CdjDyCsnkDyoUqccxDacrMfw+idQU8CBYI9O+Y1GPxooq6bwohzRCnA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=jPbJTEjO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="jPbJTEjO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E23FC4CEDD;
	Tue, 18 Mar 2025 05:09:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742274573;
	bh=YPsoeyTPlfMBi8bYtZKBP2dUpMXBryHP5RdhMmFQL4s=;
	h=Date:To:From:Subject:From;
	b=jPbJTEjORvNtGyJwObFirydt1j+EDA88ycObUMouM9JS9L911p3a7FGu+s0jmgE5s
	 M/gn4I02+6CSeYkJjg9qZCMAKSRO7dVh6sCcbhZ6VtEaJsitOLbyb+QbUMbNO5+P8m
	 Ln8usDEOARMKZgnkhDtMJhGrWm9U30lRXkrwJEKE=
Date: Mon, 17 Mar 2025 22:09:33 -0700
To: mm-commits@vger.kernel.org,will@kernel.org,vgupta@kernel.org,tsbogend@alpha.franken.de,tglx@linutronix.de,shorne@gmail.com,richard@nod.at,palmer@dabbelt.com,mpe@ellerman.id.au,monstr@monstr.eu,mingo@redhat.com,mattst88@gmail.com,maddy@linux.ibm.com,luto@kernel.org,linux@armlinux.org.uk,johannes@sipsolutions.net,jiaxun.yang@flygoat.com,jcmvbkbc@gmail.com,hca@linux.ibm.com,guoren@kernel.org,gor@linux.ibm.com,glaubitz@physik.fu-berlin.de,gerald.schaefer@linux.ibm.com,geert@linux-m68k.org,dinguyen@kernel.org,deller@gmx.de,davem@davemloft.net,dave.hansen@linux.intel.com,chenhuacai@kernel.org,catalin.marinas@arm.com,broonie@kernel.org,bp@alien8.de,arnd@arndb.de,ardb@kernel.org,andreas@gaisler.com,agordeev@linux.ibm.com,rppt@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] hexagon-move-initialization-of-init_mmcontext-init-to-paging_init.patch removed from -mm tree
Message-Id: <20250318050933.9E23FC4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: hexagon: move initialization of init_mm.context init to paging_init()
has been removed from the -mm tree.  Its filename was
     hexagon-move-initialization-of-init_mmcontext-init-to-paging_init.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Subject: hexagon: move initialization of init_mm.context init to paging_init()
Date: Thu, 13 Mar 2025 15:49:53 +0200

This will help with pulling out memblock_free_all() to the generic
code and reducing code duplication in arch::mem_init().

Link: https://lkml.kernel.org/r/20250313135003.836600-4-rppt@kernel.org
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

 arch/hexagon/mm/init.c |   14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

--- a/arch/hexagon/mm/init.c~hexagon-move-initialization-of-init_mmcontext-init-to-paging_init
+++ a/arch/hexagon/mm/init.c
@@ -59,14 +59,6 @@ void __init mem_init(void)
 	 *  To-Do:  someone somewhere should wipe out the bootmem map
 	 *  after we're done?
 	 */
-
-	/*
-	 * This can be moved to some more virtual-memory-specific
-	 * initialization hook at some point.  Set the init_mm
-	 * descriptors "context" value to point to the initial
-	 * kernel segment table's physical address.
-	 */
-	init_mm.context.ptbase = __pa(init_mm.pgd);
 }
 
 void sync_icache_dcache(pte_t pte)
@@ -104,6 +96,12 @@ static void __init paging_init(void)
 	free_area_init(max_zone_pfn);  /*  sets up the zonelists and mem_map  */
 
 	/*
+	 * Set the init_mm descriptors "context" value to point to the
+	 * initial kernel segment table's physical address.
+	 */
+	init_mm.context.ptbase = __pa(init_mm.pgd);
+
+	/*
 	 * Start of high memory area.  Will probably need something more
 	 * fancy if we...  get more fancy.
 	 */
_

Patches currently in -mm which might be from rppt@kernel.org are

mm-mm_init-rename-__init_reserved_page_zone-to-__init_page_from_nid.patch
mm-mm_init-rename-init_reserved_page-to-init_deferred_page.patch

