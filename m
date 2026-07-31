Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0EF440F729
	for <mm-commits@vger.kernel.org>; Fri, 31 Jul 2026 18:06:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785521206; cv=none; b=UcZGCio8Hji/zKyV1qGfpMc0L1suL4tY8PBBmvejg0jmjcyWc4SXPUfhIx+yxsBd7qgROlzMIr2IvVWNcR71Q+Puo7RngUNqVSBZPSKtiU9O1kF3qOeGm6aLm95Qq2SYwW7LAcVWN/pxeGKu+9qc8NOOKIGEAsUQ87w6rfVAqig=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785521206; c=relaxed/simple;
	bh=L0K2ZiKg/a9il73aZHy0NpYRkkOnAhlIBSR/ezSOwU0=;
	h=Date:To:From:Subject:Message-Id; b=r7NMk71xB1dwF4BJfU/KJPvUpT0cjAHxFgoLW09oE6MUp5/uuL+zilOAuKovfb1iAa+PQwFmFtvK2Y/0jcQNC4W8iUeKEIBwuyasmOfUpjTHGFtDFEpaXwdjKDT9v1Z49+8UP58U8Cc8cbgwOlo+FpcW9NwJsLmL3KIMkWwC9zE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=cp3rEy89; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="cp3rEy89"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59F401F00AC4;
	Fri, 31 Jul 2026 18:06:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785521204;
	bh=fWbrW5C/jiagMAf1ITg03Tn2DIgOaZBgAUHY2Xu2inU=;
	h=Date:To:From:Subject;
	b=cp3rEy89ZZijbDgGfM/5Oa3JpHbB2+yjBZuIusURiRfNI430R2nMb/G2KOk5Ns2VP
	 B6v0IDcdmJz//405priOcmmUMDCrHhYXyXFdRFMahwyaGWRpuyIMaPXD2q37U8K1VZ
	 qvtCgiMOhbQ+5Z/iHTEQBbs1dI5dviJ5SwO6mwpQ=
Date: Fri, 31 Jul 2026 11:06:43 -0700
To: mm-commits@vger.kernel.org,ysato@users.sourceforge.jp,glaubitz@physik.fu-berlin.de,dalias@libc.org,arnd@arndb.de,rppt@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + sh-drop-include-asm-sparsememh.patch added to mm-new branch
Message-Id: <20260731180644.59F401F00AC4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: sh: drop include/asm/sparsemem.h
has been added to the -mm mm-new branch.  Its filename is
     sh-drop-include-asm-sparsememh.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/sh-drop-include-asm-sparsememh.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Subject: sh: drop include/asm/sparsemem.h
Date: Sun, 10 May 2026 16:55:46 +0300

Move MAX_PHYSMEM_BITS declaration to include/asm/mmu.h and drop now
unneeded include/asm/sparsemem.h

Link: https://lore.kernel.org/20260510135546.13554-11-rppt@kernel.org
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Reviewed-by: Arnd Bergmann <arnd@arndb.de>
Cc: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Cc: Rich Felker <dalias@libc.org>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sh/include/asm/mmu.h       |    2 ++
 arch/sh/include/asm/sparsemem.h |   12 ------------
 arch/sh/kernel/setup.c          |    1 -
 3 files changed, 2 insertions(+), 13 deletions(-)

--- a/arch/sh/include/asm/mmu.h~sh-drop-include-asm-sparsememh
+++ a/arch/sh/include/asm/mmu.h
@@ -2,6 +2,8 @@
 #ifndef __MMU_H
 #define __MMU_H
 
+#define MAX_PHYSMEM_BITS	32
+
 /*
  * Privileged Space Mapping Buffer (PMB) definitions
  */
diff --git a/arch/sh/include/asm/sparsemem.h a/arch/sh/include/asm/sparsemem.h
deleted file mode 100644
--- a/arch/sh/include/asm/sparsemem.h
+++ /dev/null
@@ -1,12 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0 */
-#ifndef __ASM_SH_SPARSEMEM_H
-#define __ASM_SH_SPARSEMEM_H
-
-/*
- * SECTION_SIZE_BITS		2^N: how big each section will be
- * MAX_PHYSMEM_BITS		2^N: how much physical address space we have
- */
-#define SECTION_SIZE_BITS	26
-#define MAX_PHYSMEM_BITS	32
-
-#endif /* __ASM_SH_SPARSEMEM_H */
--- a/arch/sh/kernel/setup.c~sh-drop-include-asm-sparsememh
+++ a/arch/sh/kernel/setup.c
@@ -41,7 +41,6 @@
 #include <asm/smp.h>
 #include <asm/mmu_context.h>
 #include <asm/processor.h>
-#include <asm/sparsemem.h>
 #include <asm/platform_early.h>
 
 /*
_

Patches currently in -mm which might be from rppt@kernel.org are

mm-split-out-mm_init-and-memblock-declarations-from-internalh.patch
mm-split-out-mm_init-and-memblock-declarations-from-internalh-fix.patch
mm-split-out-sparse-declarations-from-internalh.patch
mm-split-out-vmalloc-declarations-from-internalh.patch
sh-remove-config_numa-and-realted-configuration-options.patch
sh-mm-remove-numac.patch
sh-mm-drop-allocate_pgdat.patch
sh-remove-setup_bootmem_node-and-plat_mem_setup.patch
sh-drop-dead-code-guarded-by-ifdef-config_numa.patch
sh-drop-include-asm-mmzoneh.patch
init-kconfig-drop-arch_want_numa_variable_locality.patch
sh-init-remove-call-the-memblock_set_node.patch
sh-remove-sparsemem-related-entries-from-kconfig.patch
sh-drop-include-asm-sparsememh.patch

