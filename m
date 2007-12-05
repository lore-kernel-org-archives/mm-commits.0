From: akpm@linux-foundation.org
Subject: + powerpc-invalid-size-for-swapper_pg_dir-with-config_pte_64bit=y.patch added to -mm tree
Date: Wed, 05 Dec 2007 15:03:52 -0800
Message-ID: <200712052303.lB5N3q7W029563@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60525 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752246AbXLEXEA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 5 Dec 2007 18:04:00 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: chombourger@gmail.com, benh@kernel.crashing.org, galak@gate.crashing.org, paulus@samba.org


The patch titled
     powerpc: invalid size for swapper_pg_dir with CONFIG_PTE_64BIT=y
has been added to the -mm tree.  Its filename is
     powerpc-invalid-size-for-swapper_pg_dir-with-config_pte_64bit=y.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: powerpc: invalid size for swapper_pg_dir with CONFIG_PTE_64BIT=y
From: Cedric Hombourger <chombourger@gmail.com>

The size of swapper_pg_dir depends on the size of the basic type of a PTE. 
Added a #define for the size of pte_basic_t as a power of two which is now
used to define PTE_SHIFT unconditionally as well as swapper_pg_dir in the
assembly head file.  Before this change, a kernel configured with
CONFIG_PTE_64BIT=y would very likely crash on a MPC8548CDS as the global
variable swapper_pg_dir (=init_mm.pgd) was 4k instead of 8k.

Signed-off-by: Cedric Hombourger <chombourger@gmail.com>
Cc: Kumar Gala <galak@gate.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/kernel/head_fsl_booke.S |    2 +-
 include/asm-powerpc/page_32.h        |   18 +++++++++++++++---
 2 files changed, 16 insertions(+), 4 deletions(-)

diff -puN arch/powerpc/kernel/head_fsl_booke.S~powerpc-invalid-size-for-swapper_pg_dir-with-config_pte_64bit=y arch/powerpc/kernel/head_fsl_booke.S
--- a/arch/powerpc/kernel/head_fsl_booke.S~powerpc-invalid-size-for-swapper_pg_dir-with-config_pte_64bit=y
+++ a/arch/powerpc/kernel/head_fsl_booke.S
@@ -1035,7 +1035,7 @@ empty_zero_page:
 	.space	4096
 	.globl	swapper_pg_dir
 swapper_pg_dir:
-	.space	4096
+	.space	(1024 << PTE_BASIC_SIZE)
 
 /* Reserved 4k for the critical exception stack & 4k for the machine
  * check stack per CPU for kernel mode exceptions */
diff -puN include/asm-powerpc/page_32.h~powerpc-invalid-size-for-swapper_pg_dir-with-config_pte_64bit=y include/asm-powerpc/page_32.h
--- a/include/asm-powerpc/page_32.h~powerpc-invalid-size-for-swapper_pg_dir-with-config_pte_64bit=y
+++ a/include/asm-powerpc/page_32.h
@@ -10,17 +10,29 @@
 #define ARCH_KMALLOC_MINALIGN	L1_CACHE_BYTES
 #endif
 
+/*
+ * The size, as a power of two, of the basic type of a PTE.
+ * Used in the assembly head file to get the size of the
+ * swapper_pg_dir table right.
+ */
+#ifdef CONFIG_PTE_64BIT
+#define PTE_BASIC_SIZE	3
+#else
+#define PTE_BASIC_SIZE	2
+#endif
+
+#define PTE_SHIFT	(PAGE_SHIFT - PTE_BASIC_SIZE)
+
 #ifndef __ASSEMBLY__
 /*
  * The basic type of a PTE - 64 bits for those CPUs with > 32 bit
- * physical addressing.  For now this just the IBM PPC440.
+ * physical addressing.  This feature is available on the IBM PPC440
+ * as well as Freescale boards with an e500v2 core.
  */
 #ifdef CONFIG_PTE_64BIT
 typedef unsigned long long pte_basic_t;
-#define PTE_SHIFT	(PAGE_SHIFT - 3)	/* 512 ptes per page */
 #else
 typedef unsigned long pte_basic_t;
-#define PTE_SHIFT	(PAGE_SHIFT - 2)	/* 1024 ptes per page */
 #endif
 
 struct page;
_

Patches currently in -mm which might be from chombourger@gmail.com are

powerpc-invalid-size-for-swapper_pg_dir-with-config_pte_64bit=y.patch
