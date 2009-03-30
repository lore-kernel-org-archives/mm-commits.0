From: akpm@linux-foundation.org
Subject: [merged] mtd-nand-drop-usage-of-cpu_is_-macro.patch removed from -mm tree
Date: Mon, 30 Mar 2009 12:05:59 -0700
Message-ID: <200903301905.n2UJ5xMI018916@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44089 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759352AbZC3TJl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 30 Mar 2009 15:09:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: khilman@deeprootsystems.com, david-b@pacbell.net, dwmw2@infradead.org, mm-commits@vger.kernel.org


The patch titled
     mtd: nand: drop usage of cpu_is_* macro
has been removed from the -mm tree.  Its filename was
     mtd-nand-drop-usage-of-cpu_is_-macro.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
linux-next.patch

