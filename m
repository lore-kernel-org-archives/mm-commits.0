Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 801587493
	for <mm-commits@vger.kernel.org>; Mon, 11 Dec 2023 01:23:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Hoh4yA0i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4970EC433C7;
	Mon, 11 Dec 2023 01:23:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1702257823;
	bh=pO1RjGd0QIWm9MdIRu/pC1P4Y+Amj46EGUSp84atR7E=;
	h=Date:To:From:Subject:From;
	b=Hoh4yA0iTsE3AkualMIXh7JgYSJnhqevSce2paJ31U4CrBYuyv0qzkS57nXJPK5uw
	 ncxKeK1iH9JkhJVlvGkCWIfXmYfBn0l+RtXeLCnf/IfRD7WnafXRUQhuJbQOYG52zP
	 BLmeaAIykbjHHpq5OT70VXZ7bJdRCS2y240wgGno=
Date: Sun, 10 Dec 2023 17:23:42 -0800
To: mm-commits@vger.kernel.org,tsbogend@alpha.franken.de,sfr@rothwell.id.au,arnd@arndb.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] mips-fix-tlb_init-prototype.patch removed from -mm tree
Message-Id: <20231211012343.4970EC433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mips: fix tlb_init() prototype
has been removed from the -mm tree.  Its filename was
     mips-fix-tlb_init-prototype.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Arnd Bergmann <arnd@arndb.de>
Subject: mips: fix tlb_init() prototype
Date: Mon, 4 Dec 2023 12:57:01 +0100

There are two definitions for tlb_init(), but no global declaration:

arch/mips/mm/tlb-r4k.c:552:6: error: no previous prototype for 'tlb_init' [-Werror=missing-prototypes]
arch/mips/mm/tlb-r3k.c:244:6: error: no previous prototype for 'tlb_init' [-Werror=missing-prototypes]

Move the declaration to asm/setup.h and included it as needed.

Link: https://lkml.kernel.org/r/20231204115710.2247097-12-arnd@kernel.org
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Stephen Rothwell <sfr@rothwell.id.au>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/mips/include/asm/setup.h |    1 +
 arch/mips/kernel/traps.c      |    2 --
 arch/mips/mm/tlb-r3k.c        |    1 +
 arch/mips/mm/tlb-r4k.c        |    1 +
 4 files changed, 3 insertions(+), 2 deletions(-)

--- a/arch/mips/include/asm/setup.h~mips-fix-tlb_init-prototype
+++ a/arch/mips/include/asm/setup.h
@@ -27,5 +27,6 @@ extern unsigned long ebase;
 extern unsigned int hwrena;
 extern void per_cpu_trap_init(bool);
 extern void cpu_cache_init(void);
+extern void tlb_init(void);
 
 #endif /* __SETUP_H */
--- a/arch/mips/kernel/traps.c~mips-fix-tlb_init-prototype
+++ a/arch/mips/kernel/traps.c
@@ -2157,8 +2157,6 @@ void *set_vi_handler(int n, vi_handler_t
 	return set_vi_srs_handler(n, addr, 0);
 }
 
-extern void tlb_init(void);
-
 /*
  * Timer interrupt
  */
--- a/arch/mips/mm/tlb-r3k.c~mips-fix-tlb_init-prototype
+++ a/arch/mips/mm/tlb-r3k.c
@@ -23,6 +23,7 @@
 #include <asm/io.h>
 #include <asm/bootinfo.h>
 #include <asm/cpu.h>
+#include <asm/setup.h>
 #include <asm/tlbex.h>
 
 #undef DEBUG_TLB
--- a/arch/mips/mm/tlb-r4k.c~mips-fix-tlb_init-prototype
+++ a/arch/mips/mm/tlb-r4k.c
@@ -24,6 +24,7 @@
 #include <asm/tlb.h>
 #include <asm/tlbex.h>
 #include <asm/tlbmisc.h>
+#include <asm/setup.h>
 
 /*
  * LOONGSON-2 has a 4 entry itlb which is a subset of jtlb, LOONGSON-3 has
_

Patches currently in -mm which might be from arnd@arndb.de are

kexec-fix-kexec_file-dependencies.patch
kexec-fix-kexec_file-dependencies-fix.patch
kexec-select-crypto-from-kexec_file-instead-of-depending-on-it.patch
makefileextrawarn-turn-on-missing-prototypes-globally.patch

