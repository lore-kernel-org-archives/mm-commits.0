From: akpm@linux-foundation.org
Subject: + mtd-maps-blackfin-async-flash-maps-fix-up-memory-leak.patch added to -mm tree
Date: Thu, 05 Feb 2009 14:03:59 -0800
Message-ID: <200902052203.n15M3xGP013354@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41634 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753148AbZBEWEj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Feb 2009 17:04:39 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: vapier.adi@gmail.com, cooloney@kernel.org, dwmw2@infradead.org


The patch titled
     mtd/maps: blackfin async flash maps: fix up memory leak
has been added to the -mm tree.  Its filename is
     mtd-maps-blackfin-async-flash-maps-fix-up-memory-leak.patch

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
Subject: mtd/maps: blackfin async flash maps: fix up memory leak
From: Mike Frysinger <vapier.adi@gmail.com>

Signed-off-by: Mike Frysinger <vapier.adi@gmail.com>
Signed-off-by: Bryan Wu <cooloney@kernel.org>
Cc: David Woodhouse <dwmw2@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mtd/maps/bfin-async-flash.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/mtd/maps/bfin-async-flash.c~mtd-maps-blackfin-async-flash-maps-fix-up-memory-leak drivers/mtd/maps/bfin-async-flash.c
--- a/drivers/mtd/maps/bfin-async-flash.c~mtd-maps-blackfin-async-flash-maps-fix-up-memory-leak
+++ a/drivers/mtd/maps/bfin-async-flash.c
@@ -170,6 +170,7 @@ static int __devinit bfin_flash_probe(st
 	if (ret > 0) {
 		pr_devinit(KERN_NOTICE DRIVER_NAME ": Using commandline partition definition\n");
 		add_mtd_partitions(state->mtd, pdata->parts, ret);
+		kfree(pdata->parts);
 
 	} else if (pdata->nr_parts) {
 		pr_devinit(KERN_NOTICE DRIVER_NAME ": Using board partition definition\n");
_

Patches currently in -mm which might be from vapier.adi@gmail.com are

origin.patch
video-framebuffer-move-the-probe-func-into-devinittext-in-blackfin-lcd-driver.patch
linux-next.patch
blackfin-nfc-driver-do-not-clobber-dmac1_perimux.patch
blackfin-nfc-driver-mark-bf5xx_nand_add_partition-as-__devinit.patch
blackfin-nfc-driver-drop-pointless-casts-with-set_dma_callback.patch
mtd-maps-blackfin-async-flash-maps-fix-bug-dont-leak-resources-when-initializing-in-case-of-errors.patch
mtd-maps-blackfin-async-flash-maps-bfin-async-mtd-driver-needs-complex-mappings.patch
mtd-maps-blackfin-async-flash-maps-fix-up-memory-leak.patch
bin_elf_fdpic-check-the-return-value-of-clear_user.patch

