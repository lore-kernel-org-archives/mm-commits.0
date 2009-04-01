From: akpm@linux-foundation.org
Subject: + xtensa-fix-init_bootmem_node-argument-order.patch added to -mm tree
Date: Wed, 01 Apr 2009 13:14:40 -0700
Message-ID: <200904012014.n31KEeuG004116@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51595 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757425AbZDAURu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Apr 2009 16:17:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jw@emlix.com, chris@zankel.net, os@emlix.com


The patch titled
     xtensa: fix init_bootmem_node() argument order
has been added to the -mm tree.  Its filename is
     xtensa-fix-init_bootmem_node-argument-order.patch

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

xtensa-enforce-slab-alignment-to-maximum-register-width.patch
xtensa-add-flat-support.patch
xtensa-add-flat-support-checkpatch-fixes.patch
xtensa-nommu-support.patch
xtensa-variant-specific-code.patch
xtensa-variant-irq-set-callbacks.patch
xtensa-s6000-variant-core-definitions.patch
xtensa-s6000-variant.patch
xtensa-s6000-gpio-driver.patch
xtensa-let-platform-override-kerneloffset.patch
xtensa-platform-stretch-s6105-eval-board.patch
xtensa-cache-inquiry-and-unaligned-cache-handling-functions.patch
xtensa-allow-platform-and-variant-to-initialize-own-irq-chips.patch
xtensa-support-s6000-gpio-irqs-and-alternate-function-selection.patch
s6gmac-xtensa-s6000-on-chip-ethernet-driver.patch
xtensa-s6105-specific-configuration-for-s6gmac.patch
xtensa-enable-s6gmac-in-s6105_defconfig.patch
xtensa-remove-redefinition-of-xchal_mmu_asid_bits.patch
xtensa-use-correct-stack-pointer-for-stack-traces.patch
xtensa-fix-init_bootmem_node-argument-order.patch
xtensa-dont-make-bootmem-bitmap-larger-than-required.patch
xtensa-cope-with-ram-beginning-at-higher-addresses.patch
flat-fix-data-sections-alignment.patch
flat-fix-data-sections-alignment-update.patch

