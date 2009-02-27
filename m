From: akpm@linux-foundation.org
Subject: + mtd-nand-drop-usage-of-cpu_is_-macro.patch added to -mm tree
Date: Fri, 27 Feb 2009 14:36:41 -0800
Message-ID: <200902272236.n1RMafWI009437@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45937 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758934AbZB0WhW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 27 Feb 2009 17:37:22 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: khilman@deeprootsystems.com, david-b@pacbell.net, dwmw2@infradead.org


The patch titled
     mtd: nand: drop usage of cpu_is_* macro
has been added to the -mm tree.  Its filename is
     mtd-nand-drop-usage-of-cpu_is_-macro.patch

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
Subject: mtd: nand: drop usage of cpu_is_* macro
From: Kevin Hilman <khilman@deeprootsystems.com>

Usage of davinci-specific cpu_is macros is not allowed in drivers. 
These options should be passed in through platform_data.

Signed-off-by: Kevin Hilman <khilman@deeprootsystems.com>
Cc: David Brownell <david-b@pacbell.net>
Cc: David Woodhouse <dwmw2@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mtd/nand/davinci_nand.c |    3 ---
 1 file changed, 3 deletions(-)

diff -puN drivers/mtd/nand/davinci_nand.c~mtd-nand-drop-usage-of-cpu_is_-macro drivers/mtd/nand/davinci_nand.c
--- a/drivers/mtd/nand/davinci_nand.c~mtd-nand-drop-usage-of-cpu_is_-macro
+++ a/drivers/mtd/nand/davinci_nand.c
@@ -33,7 +33,6 @@
 #include <linux/mtd/nand.h>
 #include <linux/mtd/partitions.h>
 
-#include <mach/cpu.h>
 #include <mach/nand.h>
 
 #include <asm/mach-types.h>
@@ -392,8 +391,6 @@ static int __init nand_davinci_probe(str
 	/* use board-specific ECC config; else, the best available */
 	if (pdata)
 		ecc_mode = pdata->ecc_mode;
-	else if (cpu_is_davinci_dm355())
-		ecc_mode = NAND_ECC_HW_SYNDROME;
 	else
 		ecc_mode = NAND_ECC_HW;
 
_

Patches currently in -mm which might be from khilman@deeprootsystems.com are

linux-next.patch
mtd-nand-drop-usage-of-cpu_is_-macro.patch

