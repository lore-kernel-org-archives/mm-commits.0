From: akpm@linux-foundation.org
Subject: [merged] xtensa-fix-init_bootmem_node-argument-order.patch removed from -mm tree
Date: Mon, 06 Apr 2009 12:39:50 -0700
Message-ID: <200904061939.n36JdoTw014057@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44574 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754382AbZDFUOK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 6 Apr 2009 16:14:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jw@emlix.com, chris@zankel.net, os@emlix.com, mm-commits@vger.kernel.org


The patch titled
     xtensa: fix init_bootmem_node() argument order
has been removed from the -mm tree.  Its filename was
     xtensa-fix-init_bootmem_node-argument-order.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: xtensa: fix init_bootmem_node() argument order
From: Johannes Weiner <jw@emlix.com>

The second argument to init_bootmem_node() is the PFN to place the
bootmem bitmap at and the third argument is the first PFN on the node.

This is currently backwards but never made any problems as both values
were always zero.

Signed-off-by: Johannes Weiner <jw@emlix.com>
Cc: Oskar Schirmer <os@emlix.com>
Cc: Christian Zankel <chris@zankel.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/xtensa/mm/init.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN arch/xtensa/mm/init.c~xtensa-fix-init_bootmem_node-argument-order arch/xtensa/mm/init.c
--- a/arch/xtensa/mm/init.c~xtensa-fix-init_bootmem_node-argument-order
+++ a/arch/xtensa/mm/init.c
@@ -138,8 +138,9 @@ void __init bootmem_init(void)
 	/* Reserve the bootmem bitmap area */
 
 	mem_reserve(bootmap_start, bootmap_start + bootmap_size, 1);
-	bootmap_size = init_bootmem_node(NODE_DATA(0), min_low_pfn,
+	bootmap_size = init_bootmem_node(NODE_DATA(0),
 					 bootmap_start >> PAGE_SHIFT,
+					 min_low_pfn,
 					 max_low_pfn);
 
 	/* Add all remaining memory pieces into the bootmem map */
_

Patches currently in -mm which might be from jw@emlix.com are

origin.patch
xtensa-add-flat-support-checkpatch-fixes.patch
xtensa-variant-specific-code.patch
xtensa-cache-inquiry-and-unaligned-cache-handling-functions.patch
xtensa-allow-platform-and-variant-to-initialize-own-irq-chips.patch
xtensa-support-s6000-gpio-irqs-and-alternate-function-selection.patch
s6gmac-xtensa-s6000-on-chip-ethernet-driver.patch
xtensa-s6105-specific-configuration-for-s6gmac.patch
xtensa-enable-s6gmac-in-s6105_defconfig.patch
flat-fix-data-sections-alignment.patch

