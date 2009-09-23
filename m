From: akpm@linux-foundation.org
Subject: [merged] blackfin-override-text-data-checking-functions.patch removed from -mm tree
Date: Wed, 23 Sep 2009 12:53:51 -0700
Message-ID: <200909231953.n8NJrpkV031948@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35407 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753354AbZIWTzX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Sep 2009 15:55:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vapier@gentoo.org, a.p.zijlstra@chello.nl, arnd@arndb.de, mingo@elte.hu, rgetz@blackfin.uclinux.org, sam@ravnborg.org, mm-commits@vger.kernel.org


The patch titled
     Blackfin: override text/data checking functions
has been removed from the -mm tree.  Its filename was
     blackfin-override-text-data-checking-functions.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Blackfin: override text/data checking functions
From: Mike Frysinger <vapier@gentoo.org>

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Robin Getz <rgetz@blackfin.uclinux.org>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/blackfin/include/asm/sections.h |   38 +++++++++++++++++++++++--
 1 file changed, 35 insertions(+), 3 deletions(-)

diff -puN arch/blackfin/include/asm/sections.h~blackfin-override-text-data-checking-functions arch/blackfin/include/asm/sections.h
--- a/arch/blackfin/include/asm/sections.h~blackfin-override-text-data-checking-functions
+++ a/arch/blackfin/include/asm/sections.h
@@ -1,9 +1,6 @@
 #ifndef _BLACKFIN_SECTIONS_H
 #define _BLACKFIN_SECTIONS_H
 
-/* nothing to see, move along */
-#include <asm-generic/sections.h>
-
 /* only used when MTD_UCLINUX */
 extern unsigned long memory_mtd_start, memory_mtd_end, mtd_size;
 
@@ -15,4 +12,39 @@ extern char _stext_l1[], _etext_l1[], _s
 	_stext_l2[], _etext_l2[], _sdata_l2[], _edata_l2[], _sbss_l2[],
 	_ebss_l2[], _l2_lma_start[];
 
+#include <asm/mem_map.h>
+
+/* Blackfin systems have discontinuous memory map and no virtualized memory */
+static inline int arch_is_kernel_text(unsigned long addr)
+{
+	return
+		(L1_CODE_LENGTH &&
+		 addr >= (unsigned long)_stext_l1 &&
+		 addr <  (unsigned long)_etext_l1)
+		||
+		(L2_LENGTH &&
+		 addr >= (unsigned long)_stext_l2 &&
+		 addr <  (unsigned long)_etext_l2);
+}
+#define arch_is_kernel_text(addr) arch_is_kernel_text(addr)
+
+static inline int arch_is_kernel_data(unsigned long addr)
+{
+	return
+		(L1_DATA_A_LENGTH &&
+		 addr >= (unsigned long)_sdata_l1 &&
+		 addr <  (unsigned long)_ebss_l1)
+		||
+		(L1_DATA_B_LENGTH &&
+		 addr >= (unsigned long)_sdata_b_l1 &&
+		 addr <  (unsigned long)_ebss_b_l1)
+		||
+		(L2_LENGTH &&
+		 addr >= (unsigned long)_sdata_l2 &&
+		 addr <  (unsigned long)_ebss_l2);
+}
+#define arch_is_kernel_data(addr) arch_is_kernel_data(addr)
+
+#include <asm-generic/sections.h>
+
 #endif
_

Patches currently in -mm which might be from vapier@gentoo.org are

origin.patch
linux-next.patch
md-dm-log-fix-cn_ulog_callback-declaration.patch
fdpic-ignore-the-loaders-pt_gnu_stack-when-calculating-the-stack-size.patch
flat-use-is_err_value-helper-macro.patch
linux-futexh-place-kernel-types-behind-__kernel__.patch

