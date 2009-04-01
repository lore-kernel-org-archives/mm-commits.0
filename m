From: akpm@linux-foundation.org
Subject: + xtensa-dont-make-bootmem-bitmap-larger-than-required.patch added to -mm tree
Date: Wed, 01 Apr 2009 13:14:42 -0700
Message-ID: <200904012014.n31KEgTY004119@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59151 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763522AbZDAURW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Apr 2009 16:17:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jw@emlix.com, chris@zankel.net, os@emlix.com


The patch titled
     xtensa: dont make bootmem bitmap larger than required
has been added to the -mm tree.  Its filename is
     xtensa-dont-make-bootmem-bitmap-larger-than-required.patch

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
Subject: xtensa: dont make bootmem bitmap larger than required
From: Johannes Weiner <jw@emlix.com>

If min_low_pfn is non-zero, the bitmap reserved for bootmem is bigger
than needed.  The number of pages bootmem has to maintain is the range
from min_low_pfn to max_low_pfn.

For now it has only been a theoretical mistake, min_low_pfn was always
zero.

Signed-off-by: Johannes Weiner <jw@emlix.com>
Cc: Oskar Schirmer <os@emlix.com>
Cc: Christian Zankel <chris@zankel.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/xtensa/mm/init.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN arch/xtensa/mm/init.c~xtensa-dont-make-bootmem-bitmap-larger-than-required arch/xtensa/mm/init.c
--- a/arch/xtensa/mm/init.c~xtensa-dont-make-bootmem-bitmap-larger-than-required
+++ a/arch/xtensa/mm/init.c
@@ -123,7 +123,8 @@ void __init bootmem_init(void)
 
 	/* Find an area to use for the bootmem bitmap. */
 
-	bootmap_size = bootmem_bootmap_pages(max_low_pfn) << PAGE_SHIFT;
+	bootmap_size = bootmem_bootmap_pages(max_low_pfn - min_low_pfn);
+	bootmap_size <<= PAGE_SHIFT;
 	bootmap_start = ~0;
 
 	for (i=0; i<sysmem.nr_banks; i++)
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

