From: akpm@linux-foundation.org
Subject: - powerpc-tlb_32c-build-fix.patch removed from -mm tree
Date: Mon, 23 Jul 2007 02:34:26 -0700
Message-ID: <200707230934.l6N9YQc2016399@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38676 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757986AbXGWJpY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 23 Jul 2007 05:45:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: m.kozlowski@tuxland.pl, benh@kernel.crashing.org, paulus@samba.org, mm-commits@vger.kernel.org


The patch titled
     powerpc: tlb_32.c build fix
has been removed from the -mm tree.  Its filename was
     powerpc-tlb_32c-build-fix.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: powerpc: tlb_32.c build fix
From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>

allnoconfig results in this:

 CC      arch/powerpc/mm/tlb_32.o
In file included from include/asm/tlb.h:60,
                 from arch/powerpc/mm/tlb_32.c:30:
include/asm-generic/tlb.h: In function 'tlb_flush_mmu':
include/asm-generic/tlb.h:76: error: implicit declaration of function 'release_pages'
include/asm-generic/tlb.h: In function 'tlb_remove_page':
include/asm-generic/tlb.h:105: error: implicit declaration of function 'page_cache_release'

Signed-off-by: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/mm/tlb_32.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN arch/powerpc/mm/tlb_32.c~powerpc-tlb_32c-build-fix arch/powerpc/mm/tlb_32.c
--- a/arch/powerpc/mm/tlb_32.c~powerpc-tlb_32c-build-fix
+++ a/arch/powerpc/mm/tlb_32.c
@@ -26,6 +26,8 @@
 #include <linux/mm.h>
 #include <linux/init.h>
 #include <linux/highmem.h>
+#include <linux/pagemap.h>
+
 #include <asm/tlbflush.h>
 #include <asm/tlb.h>
 
_

Patches currently in -mm which might be from m.kozlowski@tuxland.pl are

mtd-add-module-license-to-mtdbdi.patch
dont-optimise-away-baud-rate-changes-when-bother-is-used.patch
fs-9p-convc-error-path-fix.patch
