From: akpm@linux-foundation.org
Subject: - mtd-fix-startup-lock-when-using-multiple-nor-flash-chips.patch removed from -mm tree
Date: Fri, 08 Feb 2008 00:10:53 -0800
Message-ID: <200802080810.m188AYkB014951@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51975 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757147AbYBHITA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Feb 2008 03:19:00 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: davide@elpa.it, dwmw2@infradead.org, mm-commits@vger.kernel.org


The patch titled
     MTD: fix startup lock when using multiple nor flash chips
has been removed from the -mm tree.  Its filename was
     mtd-fix-startup-lock-when-using-multiple-nor-flash-chips.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: MTD: fix startup lock when using multiple nor flash chips
From: Rizzo Davide <davide@elpa.it>

Taken from http://bugzilla.kernel.org/show_bug.cgi?id=9829

I found and solved the problem, at line 115 of drivers/mtd/chips/gen_probe.c
(kernel 2.6.24): mapsize value must be calculated in bytes, not in long.

Cc: David Woodhouse <dwmw2@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mtd/chips/gen_probe.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/mtd/chips/gen_probe.c~mtd-fix-startup-lock-when-using-multiple-nor-flash-chips drivers/mtd/chips/gen_probe.c
--- a/drivers/mtd/chips/gen_probe.c~mtd-fix-startup-lock-when-using-multiple-nor-flash-chips
+++ a/drivers/mtd/chips/gen_probe.c
@@ -112,7 +112,7 @@ static struct cfi_private *genprobe_iden
 		max_chips = 1;
 	}
 
-	mapsize = (max_chips + BITS_PER_LONG-1) / BITS_PER_LONG;
+	mapsize = sizeof(long) * ( (max_chips + BITS_PER_LONG-1) / BITS_PER_LONG );
 	chip_map = kzalloc(mapsize, GFP_KERNEL);
 	if (!chip_map) {
 		printk(KERN_WARNING "%s: kmalloc failed for CFI chip map\n", map->name);
_

Patches currently in -mm which might be from davide@elpa.it are

origin.patch
