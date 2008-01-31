From: akpm@linux-foundation.org
Subject: + mtd-fix-startup-lock-when-using-multiple-nor-flash-chips.patch added to -mm tree
Date: Thu, 31 Jan 2008 15:01:05 -0800
Message-ID: <200801312301.m0VN1E7b015805@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50820 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754083AbYAaXBb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 31 Jan 2008 18:01:31 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: davide@elpa.it, dwmw2@infradead.org


The patch titled
     MTD: fix startup lock when using multiple nor flash chips
has been added to the -mm tree.  Its filename is
     mtd-fix-startup-lock-when-using-multiple-nor-flash-chips.patch

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

mtd-fix-startup-lock-when-using-multiple-nor-flash-chips.patch
