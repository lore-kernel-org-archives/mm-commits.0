From: akpm@linux-foundation.org
Subject: + blackfin-override-text-data-checking-functions.patch added to -mm tree
Date: Tue, 23 Jun 2009 15:40:39 -0700
Message-ID: <200906232240.n5NMedFN008339@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55998 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758414AbZFWWm1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 23 Jun 2009 18:42:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: vapier@gentoo.org, a.p.zijlstra@chello.nl, arnd@arndb.de, mingo@elte.hu, rgetz@blackfin.uclinux.org, sam@ravnborg.org


The patch titled
     Blackfin: override text/data checking functions
has been added to the -mm tree.  Its filename is
     blackfin-override-text-data-checking-functions.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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
rmap-fixup-page_referenced-for-nommu-systems.patch
linux-next.patch
pcmcia-yenta-add-missing-__devexit-marking.patch
serial-bfin_5xx-fix-building-as-module-when-early-printk-is-enabled.patch
asm-sections-add-text-data-checking-functions-for-arches-to-override.patch
kallsyms-use-new-arch_is_kernel_text.patch
lockdep-use-new-arch_is_kernel_data.patch
blackfin-override-text-data-checking-functions.patch

