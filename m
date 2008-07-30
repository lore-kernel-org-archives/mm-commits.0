From: akpm@linux-foundation.org
Subject: - initrd-cast-initrd_start-to-void.patch removed from -mm tree
Date: Wed, 30 Jul 2008 12:14:57 -0700
Message-ID: <200807301914.m6UJEv6T010943@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33835 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752593AbYG3TPw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Jul 2008 15:15:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: geert@linux-m68k.org, anemo@mba.ocn.ne.jp, ralf@linux-mips.org, mm-commits@vger.kernel.org


The patch titled
     initrd: cast `initrd_start' to `void *'
has been removed from the -mm tree.  Its filename was
     initrd-cast-initrd_start-to-void.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: initrd: cast `initrd_start' to `void *'
From: Geert Uytterhoeven <geert@linux-m68k.org>

commit fb6624ebd912e3d6907ca6490248e73368223da9 (initrd: Fix virtual/physical
mix-up in overwrite test) introduced the compiler warning below on mips,
as its virt_to_page() doesn't cast the passed address to unsigned long
internally, unlike on most other architectures:

init/main.c: In function `start_kernel':
init/main.c:633: warning: passing argument 1 of `virt_to_phys' makes pointer from integer without a cast
init/main.c:636: warning: passing argument 1 of `virt_to_phys' makes pointer from integer without a cast

For now, kill the warning by explicitly casting initrd_start to `void *', as
that's the type it should really be.

Reported-by: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/main.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN init/main.c~initrd-cast-initrd_start-to-void init/main.c
--- a/init/main.c~initrd-cast-initrd_start-to-void
+++ a/init/main.c
@@ -635,10 +635,11 @@ asmlinkage void __init start_kernel(void
 
 #ifdef CONFIG_BLK_DEV_INITRD
 	if (initrd_start && !initrd_below_start_ok &&
-	    page_to_pfn(virt_to_page(initrd_start)) < min_low_pfn) {
+	    page_to_pfn(virt_to_page((void *)initrd_start)) < min_low_pfn) {
 		printk(KERN_CRIT "initrd overwritten (0x%08lx < 0x%08lx) - "
 		    "disabling it.\n",
-		    page_to_pfn(virt_to_page(initrd_start)), min_low_pfn);
+		    page_to_pfn(virt_to_page((void *)initrd_start)),
+		    min_low_pfn);
 		initrd_start = 0;
 	}
 #endif
_

Patches currently in -mm which might be from geert@linux-m68k.org are

origin.patch
linux-next.patch
arch-m68k-bvme6000-rtcc-remove-duplicated-include.patch

