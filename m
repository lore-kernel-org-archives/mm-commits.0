Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84DE97493
	for <mm-commits@vger.kernel.org>; Mon, 11 Dec 2023 01:23:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="oJbIv4CI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D596C433C9;
	Mon, 11 Dec 2023 01:23:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1702257822;
	bh=BQG88ZLybv0cjLb26AM+81rEw30l0wwttF1UYAuXtBQ=;
	h=Date:To:From:Subject:From;
	b=oJbIv4CIPSYP6h5Nn0Ffp7rwBa72VyF2/zFz5x5gRJ2oEmyXVgwdJXRz+9dX8zJHf
	 hpdF1FLOAP9qFzCx3/zc4deldd6WpfY/9gkS4do/XZBITvr0wVDXp6KRY2lCBqSp69
	 e+U+02iTsoqrVqpjVbTF07XC5jDMOPR1nWGXzik4=
Date: Sun, 10 Dec 2023 17:23:41 -0800
To: mm-commits@vger.kernel.org,tsbogend@alpha.franken.de,sfr@rothwell.id.au,arnd@arndb.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] mips-fix-setup_zero_pages-prototype.patch removed from -mm tree
Message-Id: <20231211012342.4D596C433C9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mips: fix setup_zero_pages() prototype
has been removed from the -mm tree.  Its filename was
     mips-fix-setup_zero_pages-prototype.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Arnd Bergmann <arnd@arndb.de>
Subject: mips: fix setup_zero_pages() prototype
Date: Mon, 4 Dec 2023 12:57:00 +0100

setup_zero_pages() has a local declaration in a platform specific header,
but that is not seen in the file it is defined in:

arch/mips/mm/init.c:60:6: error: no previous prototype for 'setup_zero_pages' [-Werror=missing-prototypes]

Move it to the corresponding global header and include that where needed.

Link: https://lkml.kernel.org/r/20231204115710.2247097-11-arnd@kernel.org
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Stephen Rothwell <sfr@rothwell.id.au>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/mips/include/asm/mach-loongson64/mmzone.h |    1 -
 arch/mips/include/asm/mmzone.h                 |    2 ++
 arch/mips/mm/init.c                            |    1 +
 3 files changed, 3 insertions(+), 1 deletion(-)

--- a/arch/mips/include/asm/mach-loongson64/mmzone.h~mips-fix-setup_zero_pages-prototype
+++ a/arch/mips/include/asm/mach-loongson64/mmzone.h
@@ -18,7 +18,6 @@ extern struct pglist_data *__node_data[]
 
 #define NODE_DATA(n)		(__node_data[n])
 
-extern void setup_zero_pages(void);
 extern void __init prom_init_numa_memory(void);
 
 #endif /* _ASM_MACH_MMZONE_H */
--- a/arch/mips/include/asm/mmzone.h~mips-fix-setup_zero_pages-prototype
+++ a/arch/mips/include/asm/mmzone.h
@@ -20,4 +20,6 @@
 #define nid_to_addrbase(nid) 0
 #endif
 
+extern void setup_zero_pages(void);
+
 #endif /* _ASM_MMZONE_H_ */
--- a/arch/mips/mm/init.c~mips-fix-setup_zero_pages-prototype
+++ a/arch/mips/mm/init.c
@@ -38,6 +38,7 @@
 #include <asm/dma.h>
 #include <asm/maar.h>
 #include <asm/mmu_context.h>
+#include <asm/mmzone.h>
 #include <asm/sections.h>
 #include <asm/pgalloc.h>
 #include <asm/tlb.h>
_

Patches currently in -mm which might be from arnd@arndb.de are

kexec-fix-kexec_file-dependencies.patch
kexec-fix-kexec_file-dependencies-fix.patch
kexec-select-crypto-from-kexec_file-instead-of-depending-on-it.patch
makefileextrawarn-turn-on-missing-prototypes-globally.patch

