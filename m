Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3010E1A8413
	for <mm-commits@vger.kernel.org>; Tue, 18 Mar 2025 05:09:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742274579; cv=none; b=mlix+HKKvKsYEt2COC/e9o+o1kNtsQXzs1ZP9exO2cf8nbcW4sPXt2qMbBybw4MwY5QD8d0QGl6/k2W2jEmuWU+LbiNf7Nx93uNd+FHjQv+aRCEDhxd7JdbfvYiAG9SpPqHS0Gn8qglB3gq744xVft1kfVUW7vU3XIAhsudXWJI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742274579; c=relaxed/simple;
	bh=b0ouPfCvFQd5+FU8rySIesvMB6q2P8gCgrBQ3dhOlmI=;
	h=Date:To:From:Subject:Message-Id; b=Yh7htareQKQs+YrXFK/FmWWaZtVNh/+9No6zX6UE6KSAD4jafF6/L0XX9fcW/lJEJebjiDRael/GFpcb1N/FyWMR3nrExpJxbKHnnsSYIaDcohXezXxIPSj0/K+23k84sDdecTISmlCJCqQh6BsyuyXzOoqUcA0xv3RkFdF2waE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=uE+W+tk0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="uE+W+tk0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4E09C4CEDD;
	Tue, 18 Mar 2025 05:09:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742274579;
	bh=b0ouPfCvFQd5+FU8rySIesvMB6q2P8gCgrBQ3dhOlmI=;
	h=Date:To:From:Subject:From;
	b=uE+W+tk0TaAPvpY5d/4oTvJ1AuZ+i3dGVOwZrU6z9mTysdRL+aKY+kwJH611KdBNL
	 +bgEdQdhuu+QUdK8bjvVXH/UWzb7uMRav2LMtyqP+ZrajLwIupnt6bWBClzAzX5Dvf
	 sDtri5mF/5di0iXcHYghA5og9FZSJZQFS9env4zg=
Date: Mon, 17 Mar 2025 22:09:38 -0700
To: mm-commits@vger.kernel.org,will@kernel.org,vgupta@kernel.org,tsbogend@alpha.franken.de,tglx@linutronix.de,shorne@gmail.com,richard@nod.at,palmer@dabbelt.com,mpe@ellerman.id.au,monstr@monstr.eu,mingo@redhat.com,mattst88@gmail.com,maddy@linux.ibm.com,luto@kernel.org,linux@armlinux.org.uk,johannes@sipsolutions.net,jiaxun.yang@flygoat.com,jcmvbkbc@gmail.com,hca@linux.ibm.com,guoren@kernel.org,gor@linux.ibm.com,glaubitz@physik.fu-berlin.de,gerald.schaefer@linux.ibm.com,geert@linux-m68k.org,dinguyen@kernel.org,deller@gmx.de,davem@davemloft.net,dave.hansen@linux.intel.com,chenhuacai@kernel.org,catalin.marinas@arm.com,broonie@kernel.org,bp@alien8.de,arnd@arndb.de,ardb@kernel.org,andreas@gaisler.com,agordeev@linux.ibm.com,rppt@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] nios2-move-pr_debug-about-memory-start-and-end-to-setup_arch.patch removed from -mm tree
Message-Id: <20250318050938.E4E09C4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: nios2: move pr_debug() about memory start and end to setup_arch()
has been removed from the -mm tree.  Its filename was
     nios2-move-pr_debug-about-memory-start-and-end-to-setup_arch.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Subject: nios2: move pr_debug() about memory start and end to setup_arch()
Date: Thu, 13 Mar 2025 15:49:56 +0200

This will help with pulling out memblock_free_all() to the generic
code and reducing code duplication in arch::mem_init().

Link: https://lkml.kernel.org/r/20250313135003.836600-7-rppt@kernel.org
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

 arch/nios2/kernel/setup.c |    2 ++
 arch/nios2/mm/init.c      |    2 --
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/arch/nios2/kernel/setup.c~nios2-move-pr_debug-about-memory-start-and-end-to-setup_arch
+++ a/arch/nios2/kernel/setup.c
@@ -149,6 +149,8 @@ void __init setup_arch(char **cmdline_p)
 	memory_start = memblock_start_of_DRAM();
 	memory_end = memblock_end_of_DRAM();
 
+	pr_debug("%s: start=%lx, end=%lx\n", __func__, memory_start, memory_end);
+
 	setup_initial_init_mm(_stext, _etext, _edata, _end);
 	init_task.thread.kregs = &fake_regs;
 
--- a/arch/nios2/mm/init.c~nios2-move-pr_debug-about-memory-start-and-end-to-setup_arch
+++ a/arch/nios2/mm/init.c
@@ -65,8 +65,6 @@ void __init mem_init(void)
 	unsigned long end_mem   = memory_end; /* this must not include
 						kernel stack at top */
 
-	pr_debug("mem_init: start=%lx, end=%lx\n", memory_start, memory_end);
-
 	end_mem &= PAGE_MASK;
 	high_memory = __va(end_mem);
 
_

Patches currently in -mm which might be from rppt@kernel.org are

mm-mm_init-rename-__init_reserved_page_zone-to-__init_page_from_nid.patch
mm-mm_init-rename-init_reserved_page-to-init_deferred_page.patch

