Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792832334;
	b=C2e3diUnx6epyP0PG1ldhGq0BosOnV0HskAexVZJWiAZmYTIPDFonsryIl2QXa9i0MW0
	 0S44z6GQhoUNzJQmbuojZqCIj4ntmfzHiB5boi56gx1btCsJUpDI2lb3tD+t5nCwFboS5
	 aUKn9WBgkfwL9i0Zj9oSv30/18fdQ1Ija5PVzZCDY9n7F5Due7TxSsyR2QvCmIg29VW1A
	 74t1PV/rCFdBLIe1SdBKd1RA/6FrWy8A+WcXDGL8wtuhqoR2S//cFGhF/8df+villIKE0
	 Az5Wmy4cGJ2Z2Lmi6Ubc9MGlDlz5dnSi9o/It7gr0mke2IlHpXAEygEt6BXYs+mfeBg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792832334;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=2/4HAfQ6gy8MtZgThjTNH62TXP8FfRWLQxCopP467fQ=;
	b=fdVAC/+yyqGZKMg02stofS/v1s74fyVMNAJMIMDkJsoAqi/7v2Kz97mAUs/t/VwQjLvS
	 gOLvSuT559mi5mBsnaVH8YT/V4UB/KvReCzDbwktD1+4wtRJP6br2Q1T7mFTfYua1f8cc
	 71BUezV92a0D5vrGLgkuJ3S1azi3UpM9b5pcDcTDtvdU4XN0IgHxWck3T73khbft5JZsb
	 MuikoQB6UTu8N3gUR/oQSGkgffgNU8dMy1b3WeeE7tyi3OptX/0CIpr2NczzHV6iU+QOC
	 Rp/ltVM+bk0ASt5idzH0RH043h6Jl7fUsZQMQ6rQuBL/8uAbpzj/dEsN3jeDgW7OZ+Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=wbVWhFSD;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48302606A31A
	for <mm-commits@vger.kernel.org>; Sat, 24 Oct 2026 08:58:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=wbVWhFSD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 124041F01828;
	Sat, 24 Oct 2026 08:58:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1792832334;
	bh=2/4HAfQ6gy8MtZgThjTNH62TXP8FfRWLQxCopP467fQ=;
	h=Date:To:From:Subject;
	b=wbVWhFSDmnR5XYHTar+3B98h29acMXiKyebiCWy/svEqWKMAais2p5Z6ZkeC9ujic
	 Rxl1KrfGMRXX1t9O/GMjkCAk7maayTAUuntUg9aIePUBF0XNXI7lntWnYFfxrqwITx
	 ov4Wgb/o9PvSft4+a1c12SlnLjxrVvluSDZeiA4M=
Date: Sat, 24 Oct 2026 01:58:53 -0700
To: mm-commits@vger.kernel.org,ysato@users.sourceforge.jp,glaubitz@physik.fu-berlin.de,dalias@libc.org,arnd@arndb.de,rppt@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] sh-drop-include-asm-sparsememh.patch removed from -mm tree
Message-Id: <20261024085854.124041F01828@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: sh: drop include/asm/sparsemem.h
has been removed from the -mm tree.  Its filename was
     sh-drop-include-asm-sparsememh.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Subject: sh: drop include/asm/sparsemem.h
Date: Sun, 10 May 2026 16:55:46 +0300

Move MAX_PHYSMEM_BITS declaration to include/asm/mmu.h and drop now
unneeded include/asm/sparsemem.h

Link: https://lore.kernel.org/20260510135546.13554-11-rppt@kernel.org
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Arnd Bergmann <arnd@arndb.de>
Cc: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Cc: Rich Felker <dalias@libc.org>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
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


