From: akpm@linux-foundation.org
Subject: + mtd-maps-blackfin-async-flash-maps-fix-bug-dont-leak-resources-when-initializing-in-case-of-errors.patch added to -mm tree
Date: Thu, 05 Feb 2009 14:03:55 -0800
Message-ID: <200902052203.n15M3taJ013145@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47255 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752880AbZBEWEg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Feb 2009 17:04:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: vapier.adi@gmail.com, cooloney@kernel.org, dwmw2@infradead.org


The patch titled
     mtd/maps: blackfin async flash maps - fix bug: dont leak resources when initializing in case of errors
has been added to the -mm tree.  Its filename is
     mtd-maps-blackfin-async-flash-maps-fix-bug-dont-leak-resources-when-initializing-in-case-of-errors.patch

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
Subject: mtd/maps: blackfin async flash maps - fix bug: dont leak resources when initializing in case of errors
From: Mike Frysinger <vapier.adi@gmail.com>

Signed-off-by: Mike Frysinger <vapier.adi@gmail.com>
Signed-off-by: Bryan Wu <cooloney@kernel.org>
Cc: David Woodhouse <dwmw2@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mtd/maps/bfin-async-flash.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff -puN drivers/mtd/maps/bfin-async-flash.c~mtd-maps-blackfin-async-flash-maps-fix-bug-dont-leak-resources-when-initializing-in-case-of-errors drivers/mtd/maps/bfin-async-flash.c
--- a/drivers/mtd/maps/bfin-async-flash.c~mtd-maps-blackfin-async-flash-maps-fix-bug-dont-leak-resources-when-initializing-in-case-of-errors
+++ a/drivers/mtd/maps/bfin-async-flash.c
@@ -152,14 +152,18 @@ static int __devinit bfin_flash_probe(st
 
 	if (gpio_request(state->enet_flash_pin, DRIVER_NAME)) {
 		pr_devinit(KERN_ERR DRIVER_NAME ": Failed to request gpio %d\n", state->enet_flash_pin);
+		kfree(state);
 		return -EBUSY;
 	}
 	gpio_direction_output(state->enet_flash_pin, 1);
 
 	pr_devinit(KERN_NOTICE DRIVER_NAME ": probing %d-bit flash bus\n", state->map.bankwidth * 8);
 	state->mtd = do_map_probe(memory->name, &state->map);
-	if (!state->mtd)
+	if (!state->mtd) {
+		gpio_free(state->enet_flash_pin);
+		kfree(state);
 		return -ENXIO;
+	}
 
 #ifdef CONFIG_MTD_PARTITIONS
 	ret = parse_mtd_partitions(state->mtd, part_probe_types, &pdata->parts, 0);
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

