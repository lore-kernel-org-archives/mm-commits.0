From: akpm@linux-foundation.org
Subject: + initrd-cast-initrd_start-to-void.patch added to -mm tree
Date: Tue, 29 Jul 2008 00:06:21 -0700
Message-ID: <200807290706.m6T76L93020184@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54385 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752384AbYG2HGq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 Jul 2008 03:06:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: geert@linux-m68k.org, anemo@mba.ocn.ne.jp, ralf@linux-mips.org


The patch titled
     initrd: cast `initrd_start' to `void *'
has been added to the -mm tree.  Its filename is
     initrd-cast-initrd_start-to-void.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
initrd-cast-initrd_start-to-void.patch
linux-next.patch
arch-m68k-bvme6000-rtcc-remove-duplicated-include.patch

