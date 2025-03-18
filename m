Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51CCF1C701D
	for <mm-commits@vger.kernel.org>; Tue, 18 Mar 2025 05:09:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742274570; cv=none; b=BqDnceloc1aW7YOZqSOx2siG/Wm5jBXmSb2nQ+6xDKnFHZHHorl9zRNqS+nI71kwGKgQ9Y30uineOVL606rXC6Ft+rQ4MjzbyyABMCQtATzLL4qxtiTcT6SHf1YyMYTilEg/4P/j/Dh00g8JGyw97o7A6FxnctNq+apKn6DfRzs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742274570; c=relaxed/simple;
	bh=cOpsAwGK1hTi9A4LJmEibUaYEI7i+fd+l2FhXUbKT/8=;
	h=Date:To:From:Subject:Message-Id; b=TKVUZIP4znsegQwvRZTVgBf0oirjHLfkfadqROAaUXfR8XmtUD/Kg5+D8B2QV/mQDntJeOK4rEYZr5FxBlxkov6UonWQbq8J0pKJ0Tjc0bAkMMOqcuZoqX3ghglx6RtqB+iauDfL35b3EXtZCDKyWcRhrBC1XtHQQES6ExniTJs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=W3reyFxp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="W3reyFxp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E245C4CEDD;
	Tue, 18 Mar 2025 05:09:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742274570;
	bh=cOpsAwGK1hTi9A4LJmEibUaYEI7i+fd+l2FhXUbKT/8=;
	h=Date:To:From:Subject:From;
	b=W3reyFxplkt3HjuAlbAQ8XuecaouyFixfrFwafoN7p6Hpo+MC32fgcVt+cYJjVXWI
	 Rr90LlDj3WDtV+hH602d0Wu6X9t0SJvoTTPCPDluJzwSnYsdnkZLg6XDYZkQd2uKKm
	 fN2Gf1gkxdJpPeCA+Gh5P/68bxlKgD9jWHhVfT4I=
Date: Mon, 17 Mar 2025 22:09:29 -0700
To: mm-commits@vger.kernel.org,will@kernel.org,vgupta@kernel.org,tsbogend@alpha.franken.de,tglx@linutronix.de,shorne@gmail.com,richard@nod.at,palmer@dabbelt.com,mpe@ellerman.id.au,monstr@monstr.eu,mingo@redhat.com,mattst88@gmail.com,maddy@linux.ibm.com,luto@kernel.org,linux@armlinux.org.uk,johannes@sipsolutions.net,jiaxun.yang@flygoat.com,jcmvbkbc@gmail.com,hca@linux.ibm.com,guoren@kernel.org,gor@linux.ibm.com,glaubitz@physik.fu-berlin.de,gerald.schaefer@linux.ibm.com,geert@linux-m68k.org,dinguyen@kernel.org,deller@gmx.de,davem@davemloft.net,dave.hansen@linux.intel.com,chenhuacai@kernel.org,catalin.marinas@arm.com,broonie@kernel.org,bp@alien8.de,arnd@arndb.de,ardb@kernel.org,andreas@gaisler.com,agordeev@linux.ibm.com,rppt@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] arm-mem_init-use-memblock_phys_free-to-free-dma-memory-on-sa1111.patch removed from -mm tree
Message-Id: <20250318050930.1E245C4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: arm: mem_init: use memblock_phys_free() to free DMA memory on SA1111
has been removed from the -mm tree.  Its filename was
     arm-mem_init-use-memblock_phys_free-to-free-dma-memory-on-sa1111.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

mm-mm_init-rename-__init_reserved_page_zone-to-__init_page_from_nid.patch
mm-mm_init-rename-init_reserved_page-to-init_deferred_page.patch

