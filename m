Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F2067493
	for <mm-commits@vger.kernel.org>; Mon, 11 Dec 2023 01:23:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="P4BADmnu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68137C433CA;
	Mon, 11 Dec 2023 01:23:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1702257818;
	bh=Fo0n3kLqIcAjdS8ET5nJ1YQqBxS63QY9vQPRnMuOxU0=;
	h=Date:To:From:Subject:From;
	b=P4BADmnu7cdmO7XuOdozBH5a/VFChHijYpE1ule1NsJ7OoxaJ8NxqYPoSSnO1aGPa
	 kmALi13po5a7HJ7HhhHiK5RmQh+ho+C2acL7Nt75ehx3zkdw2f3cTrbaCHYX60YR2a
	 armC+cZrcbnuZRW1oWmd1E+fG6WavBZloDo/GGcM=
Date: Sun, 10 Dec 2023 17:23:37 -0800
To: mm-commits@vger.kernel.org,tsbogend@alpha.franken.de,sfr@rothwell.id.au,arnd@arndb.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] mips-move-build_tlb_refill_handler-prototype.patch removed from -mm tree
Message-Id: <20231211012338.68137C433CA@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mips: move build_tlb_refill_handler() prototype
has been removed from the -mm tree.  Its filename was
     mips-move-build_tlb_refill_handler-prototype.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Arnd Bergmann <arnd@arndb.de>
Subject: mips: move build_tlb_refill_handler() prototype
Date: Mon, 4 Dec 2023 12:56:57 +0100

Instead of having a declaration for each caller, have one that is shared
with the function definition, which avoids a warning:

arch/mips/mm/tlbex.c:2547:6: error: no previous prototype for 'build_tlb_refill_handler' [-Werror=missing-prototypes]

Link: https://lkml.kernel.org/r/20231204115710.2247097-8-arnd@kernel.org
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Stephen Rothwell <sfr@rothwell.id.au>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/mips/include/asm/tlbex.h |    1 +
 arch/mips/mm/tlb-r3k.c        |    3 +--
 arch/mips/mm/tlb-r4k.c        |    3 +--
 3 files changed, 3 insertions(+), 4 deletions(-)

--- a/arch/mips/include/asm/tlbex.h~mips-move-build_tlb_refill_handler-prototype
+++ a/arch/mips/include/asm/tlbex.h
@@ -23,6 +23,7 @@ void build_update_entries(u32 **p, unsig
 void build_tlb_write_entry(u32 **p, struct uasm_label **l,
 			   struct uasm_reloc **r,
 			   enum tlb_write_entry wmode);
+void build_tlb_refill_handler(void);
 
 extern void handle_tlbl(void);
 extern char handle_tlbl_end[];
--- a/arch/mips/mm/tlb-r3k.c~mips-move-build_tlb_refill_handler-prototype
+++ a/arch/mips/mm/tlb-r3k.c
@@ -23,11 +23,10 @@
 #include <asm/io.h>
 #include <asm/bootinfo.h>
 #include <asm/cpu.h>
+#include <asm/tlbex.h>
 
 #undef DEBUG_TLB
 
-extern void build_tlb_refill_handler(void);
-
 /* CP0 hazard avoidance. */
 #define BARRIER				\
 	__asm__ __volatile__(		\
--- a/arch/mips/mm/tlb-r4k.c~mips-move-build_tlb_refill_handler-prototype
+++ a/arch/mips/mm/tlb-r4k.c
@@ -22,10 +22,9 @@
 #include <asm/hazards.h>
 #include <asm/mmu_context.h>
 #include <asm/tlb.h>
+#include <asm/tlbex.h>
 #include <asm/tlbmisc.h>
 
-extern void build_tlb_refill_handler(void);
-
 /*
  * LOONGSON-2 has a 4 entry itlb which is a subset of jtlb, LOONGSON-3 has
  * a 4 entry itlb and a 4 entry dtlb which are subsets of jtlb. Unfortunately,
_

Patches currently in -mm which might be from arnd@arndb.de are

kexec-fix-kexec_file-dependencies.patch
kexec-fix-kexec_file-dependencies-fix.patch
kexec-select-crypto-from-kexec_file-instead-of-depending-on-it.patch
makefileextrawarn-turn-on-missing-prototypes-globally.patch

