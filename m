From: akpm@linux-foundation.org
Subject: [merged] xtensa-dont-make-bootmem-bitmap-larger-than-required.patch removed from -mm tree
Date: Mon, 06 Apr 2009 12:39:52 -0700
Message-ID: <200904061939.n36Jdqdl014060@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59280 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752270AbZDFUN2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 6 Apr 2009 16:13:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jw@emlix.com, chris@zankel.net, os@emlix.com, mm-commits@vger.kernel.org


The patch titled
     xtensa: dont make bootmem bitmap larger than required
has been removed from the -mm tree.  Its filename was
     xtensa-dont-make-bootmem-bitmap-larger-than-required.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

