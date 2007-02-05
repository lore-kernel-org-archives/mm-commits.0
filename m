From: akpm@linux-foundation.org
Subject: + arch-cris-user-array_size-macro-when-appropriate.patch added to -mm tree
Date: Mon, 05 Feb 2007 14:09:21 -0800
Message-ID: <200702052209.l15M9LfT000373@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:35933 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964854AbXBEWJ2 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 5 Feb 2007 17:09:28 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: darwish.07@gmail.com, starvik@axis.com


The patch titled
     CRIS: user ARRAY_SIZE macro when appropriate
has been added to the -mm tree.  Its filename is
     arch-cris-user-array_size-macro-when-appropriate.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: CRIS: user ARRAY_SIZE macro when appropriate
From: "Ahmed S. Darwish" <darwish.07@gmail.com>

Use ARRAY_SIZE macro already defined in linux/kernel.h

Signed-off-by: Ahmed S. Darwish <darwish.07@gmail.com>
Cc: Mikael Starvik <starvik@axis.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/cris/arch-v10/drivers/axisflashmap.c |    3 +--
 arch/cris/mm/tlb.c                        |    3 ++-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff -puN arch/cris/arch-v10/drivers/axisflashmap.c~arch-cris-user-array_size-macro-when-appropriate arch/cris/arch-v10/drivers/axisflashmap.c
--- a/arch/cris/arch-v10/drivers/axisflashmap.c~arch-cris-user-array_size-macro-when-appropriate
+++ a/arch/cris/arch-v10/drivers/axisflashmap.c
@@ -359,8 +359,7 @@ static struct mtd_info *flash_probe(void
 		 * So we use the MTD concatenation layer instead of further
 		 * complicating the probing procedure.
 		 */
-		mtd_cse = mtd_concat_create(mtds,
-					    sizeof(mtds) / sizeof(mtds[0]),
+		mtd_cse = mtd_concat_create(mtds, ARRAY_SIZE(mtds),
 					    "cse0+cse1");
 #else
 		printk(KERN_ERR "%s and %s: Cannot concatenate due to kernel "
diff -puN arch/cris/mm/tlb.c~arch-cris-user-array_size-macro-when-appropriate arch/cris/mm/tlb.c
--- a/arch/cris/mm/tlb.c~arch-cris-user-array_size-macro-when-appropriate
+++ a/arch/cris/mm/tlb.c
@@ -8,6 +8,7 @@
  */
 
 #include <linux/init.h>
+#include <linux/kernel.h>
 #include <asm/tlb.h>
 
 #define D(x)
@@ -100,7 +101,7 @@ tlb_init(void)
 
 	/* clear the page_id map */
 
-	for (i = 1; i < sizeof (page_id_map) / sizeof (page_id_map[0]); i++)
+	for (i = 1; i < ARRAY_SIZE(page_id_map); i++)
 		page_id_map[i] = NULL;
 	
 	/* invalidate the entire TLB */
_

Patches currently in -mm which might be from darwish.07@gmail.com are

git-dvb.patch
git-netdev-all.patch
s390-kmalloc-kzalloc-casting-cleanups.patch
dac960-kmalloc-kzalloc-casting-cleanups.patch
isdn-capi-use-array_size-when-appropriate.patch
arch-cris-user-array_size-macro-when-appropriate.patch
arch-avr32-use-array_size-macro-when-appropriate.patch
arch-m68knommu-user-array_size-macro-when-appropriate.patch
arch-v850-user-array_size-macro-when-appropriate.patch
arch-powerpc-user-array_size-macro-when-appropriate.patch
arch-ppc-user-array_size-macro-when-appropriate.patch
arch-mips-user-array_size-macro-when-appropriate.patch
arch-m68k-user-array_size-macro-when-appropriate.patch
arch-arm-use-array_size-macro-when-appropriate.patch
arch-arm26-use-array_size-macro-when-appropriate.patch
