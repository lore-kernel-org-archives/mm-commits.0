Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1749431619E
	for <mm-commits@vger.kernel.org>; Tue, 27 Jan 2026 04:03:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769486623; cv=none; b=jFW5bYcNFyxOpZeEHa1U9bClOpECUo4t7m46O6Y6vMslgh49IJQY5+Awve/tVwcAKTgbvsJksgs3gh3FgKG3HDYsZ5dy+cvapaNr+gQUJVnW/AjjmFJ2N8Iet1vqxSOGrjFh9E5ydYZxZPHj4qPjRNI7N01ZaN+OIk73FdM+xdY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769486623; c=relaxed/simple;
	bh=OTK4oXItZft8eht5SYyx5TsSaKHhoWgEItaEo5I6Ey4=;
	h=Date:To:From:Subject:Message-Id; b=LQ5f7i0Lxg+nrsIKkaCZ08VlX6EtfIj/6tmKFGYpQ/I+vbPwZyAuW3anqtOpekyIjrtHmxKifc0cIPaFysdokAS1Ib7zv9rg/LrqfshKhS2LQvmuDlVO02moABTALa7ErnFGRiN2bQjTUnWiD6Q323QkCsyS0JvFvHSwD3D5zjo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=mF4RuLd9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="mF4RuLd9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1B70C116C6;
	Tue, 27 Jan 2026 04:03:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1769486622;
	bh=OTK4oXItZft8eht5SYyx5TsSaKHhoWgEItaEo5I6Ey4=;
	h=Date:To:From:Subject:From;
	b=mF4RuLd9hkFopfi0tcIYlWiEJcg7lVpI+ECOuQKW/K5LJAkdFgsikzua6kDV42Ifu
	 Nkhq84ZzxK0XJS4wiD/Sr6fjR5wpfJnHQ9Jd4HiNTAIC82ihcw9gsXip81RHmDY2QG
	 mS6MauIBHHX6Z1HsOJsAmpKpva4Q6Vs8XNTJqhbU=
Date: Mon, 26 Jan 2026 20:03:42 -0800
To: mm-commits@vger.kernel.org,will@kernel.org,vgupta@kernel.org,vbabka@suse.cz,tsbogend@alpha.franken.de,tglx@linutronix.de,surenb@google.com,shorne@gmail.com,ritesh.list@gmail.com,richard@nod.at,pratyush@kernel.org,palmer@dabbelt.com,osalvador@suse.de,muchun.song@linux.dev,mpe@ellerman.id.au,monstr@monstr.eu,mingo@redhat.com,mhocko@suse.com,mattst88@gmail.com,lorenzo.stoakes@oracle.com,linux@armlinux.org.uk,linmag7@gmail.com,liam.howlett@oracle.com,klarasmodin@gmail.com,johannes@sipsolutions.net,jcmvbkbc@gmail.com,hca@linux.ibm.com,guoren@kernel.org,gor@linux.ibm.com,glaubitz@physik.fu-berlin.de,geert@linux-m68k.org,dinguyen@kernel.org,deller@gmx.de,david@kernel.org,davem@davemloft.net,corbet@lwn.net,chenhuacai@kernel.org,catalin.marinas@arm.com,bp@alien8.de,andreas@gaisler.com,alexs@kernel.org,agordeev@linux.ibm.com,rppt@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] powerpc-introduce-arch_zone_limits_init.patch removed from -mm tree
Message-Id: <20260127040342.C1B70C116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: powerpc: introduce arch_zone_limits_init()
has been removed from the -mm tree.  Its filename was
     powerpc-introduce-arch_zone_limits_init.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Subject: powerpc: introduce arch_zone_limits_init()
Date: Sun, 11 Jan 2026 10:20:49 +0200

Move calculations of zone limits to a dedicated arch_zone_limits_init()
function.

Later MM core will use this function as an architecture specific callback
during nodes and zones initialization and thus there won't be a need to
call free_area_init() from every architecture.

Link: https://lkml.kernel.org/r/20260111082105.290734-16-rppt@kernel.org
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Reviewed-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Alex Shi <alexs@kernel.org>
Cc: Andreas Larsson <andreas@gaisler.com>
Cc: "Borislav Petkov (AMD)" <bp@alien8.de>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: David S. Miller <davem@davemloft.net>
Cc: Dinh Nguyen <dinguyen@kernel.org>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Guo Ren <guoren@kernel.org>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Helge Deller <deller@gmx.de>
Cc: Huacai Chen <chenhuacai@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Johannes Berg <johannes@sipsolutions.net>
Cc: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Klara Modin <klarasmodin@gmail.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Magnus Lindholm <linmag7@gmail.com>
Cc: Matt Turner <mattst88@gmail.com>
Cc: Max Filippov <jcmvbkbc@gmail.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Michal Simek <monstr@monstr.eu>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Pratyush Yadav <pratyush@kernel.org>
Cc: Richard Weinberger <richard@nod.at>
Cc: Russell King <linux@armlinux.org.uk>
Cc: Stafford Horne <shorne@gmail.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Vineet Gupta <vgupta@kernel.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/mm/mem.c |   22 ++++++++++++----------
 1 file changed, 12 insertions(+), 10 deletions(-)

--- a/arch/powerpc/mm/mem.c~powerpc-introduce-arch_zone_limits_init
+++ a/arch/powerpc/mm/mem.c
@@ -221,13 +221,23 @@ static int __init mark_nonram_nosave(voi
  * anyway) will take a first dip into ZONE_NORMAL and get otherwise served by
  * ZONE_DMA.
  */
-static unsigned long max_zone_pfns[MAX_NR_ZONES];
+void __init arch_zone_limits_init(unsigned long *max_zone_pfns)
+{
+#ifdef CONFIG_ZONE_DMA
+	max_zone_pfns[ZONE_DMA] = min((zone_dma_limit >> PAGE_SHIFT) + 1, max_low_pfn);
+#endif
+	max_zone_pfns[ZONE_NORMAL] = max_low_pfn;
+#ifdef CONFIG_HIGHMEM
+	max_zone_pfns[ZONE_HIGHMEM] = max_pfn;
+#endif
+}
 
 /*
  * paging_init() sets up the page tables - in fact we've already done this.
  */
 void __init paging_init(void)
 {
+	unsigned long max_zone_pfns[MAX_NR_ZONES] = { 0 };
 	unsigned long long total_ram = memblock_phys_mem_size();
 	phys_addr_t top_of_ram = memblock_end_of_DRAM();
 	int zone_dma_bits;
@@ -259,15 +269,7 @@ void __init paging_init(void)
 
 	zone_dma_limit = DMA_BIT_MASK(zone_dma_bits);
 
-#ifdef CONFIG_ZONE_DMA
-	max_zone_pfns[ZONE_DMA]	= min(max_low_pfn,
-				      1UL << (zone_dma_bits - PAGE_SHIFT));
-#endif
-	max_zone_pfns[ZONE_NORMAL] = max_low_pfn;
-#ifdef CONFIG_HIGHMEM
-	max_zone_pfns[ZONE_HIGHMEM] = max_pfn;
-#endif
-
+	arch_zone_limits_init(max_zone_pfns);
 	free_area_init(max_zone_pfns);
 
 	mark_nonram_nosave();
_

Patches currently in -mm which might be from rppt@kernel.org are

kho-cleanup-error-handling-in-kho_populate.patch

