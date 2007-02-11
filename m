From: akpm@linux-foundation.org
Subject: - arch-cris-user-array_size-macro-when-appropriate.patch removed from -mm tree
Date: Sun, 11 Feb 2007 14:48:09 -0800
Message-ID: <200702112248.l1BMm91p015602@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:59693 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932663AbXBKWsR (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 11 Feb 2007 17:48:17 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: darwish.07@gmail.com, starvik@axis.com, mm-commits@vger.kernel.org


The patch titled
     CRIS: user ARRAY_SIZE macro when appropriate
has been removed from the -mm tree.  Its filename was
     arch-cris-user-array_size-macro-when-appropriate.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
git-acpi.patch
git-agpgart.patch
arch-arm-use-array_size-macro-when-appropriate.patch
git-avr32.patch
git-drm.patch
git-dvb.patch
git-infiniband.patch
git-mips.patch
atm-use-array_size-macro-when-appropriate.patch
s390-kmalloc-kzalloc-casting-cleanups.patch
s390-drivers-use-array_size-macro-when-appropriate.patch
w1-use-array_size-macro-when-appropriate.patch
oss-use-array_size-macro-when-appropriate.patch
oss-use-array_size-macro-when-appropriate-2.patch
reiserfs-use-array_size-macro-when-appropriate.patch
isdn-capi-use-array_size-when-appropriate.patch
isdn-eicon-use-array_size-macro-when-appropriate.patch
rcutorture-use-array_size-macro-when-appropriate.patch
drivers-mdc-use-array_size-macro-when-appropriate.patch
