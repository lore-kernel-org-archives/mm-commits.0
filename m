From: akpm@linux-foundation.org
Subject: + mtd-bfin-async-flash-use-parse_mtd.patch added to -mm tree
Date: Fri, 14 Nov 2008 13:41:31 -0800
Message-ID: <200811142141.mAELfVKJ002374@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54340 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756916AbYKNVlh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 14 Nov 2008 16:41:37 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: vapier@gentoo.org, anemo@mba.ocn.ne.jp, dwmw2@infradead.org


The patch titled
     mtd/bfin-async-flash: use parse_mtd()
has been added to the -mm tree.  Its filename is
     mtd-bfin-async-flash-use-parse_mtd.patch

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
Subject: mtd/bfin-async-flash: use parse_mtd()
From: Mike Frysinger <vapier@gentoo.org>

Call parse_mtd() to handle partition/device registration rather than doing
it all ourself.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
Cc: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
Cc: David Woodhouse <dwmw2@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mtd/maps/bfin-async-flash.c |   28 ++------------------------
 1 file changed, 3 insertions(+), 25 deletions(-)

diff -puN drivers/mtd/maps/bfin-async-flash.c~mtd-bfin-async-flash-use-parse_mtd drivers/mtd/maps/bfin-async-flash.c
--- a/drivers/mtd/maps/bfin-async-flash.c~mtd-bfin-async-flash-use-parse_mtd
+++ a/drivers/mtd/maps/bfin-async-flash.c
@@ -120,13 +120,8 @@ static void bfin_copy_to(struct map_info
 	switch_back(state);
 }
 
-#ifdef CONFIG_MTD_PARTITIONS
-static const char *part_probe_types[] = { "cmdlinepart", "RedBoot", NULL };
-#endif
-
 static int __devinit bfin_flash_probe(struct platform_device *pdev)
 {
-	int ret;
 	struct physmap_flash_data *pdata = pdev->dev.platform_data;
 	struct resource *memory = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	struct resource *flash_ambctl = platform_get_resource(pdev, IORESOURCE_MEM, 1);
@@ -150,6 +145,8 @@ static int __devinit bfin_flash_probe(st
 	state->flash_ambctl0  = flash_ambctl->start;
 	state->flash_ambctl1  = flash_ambctl->end;
 
+	platform_set_drvdata(pdev, state);
+
 	if (gpio_request(state->enet_flash_pin, DRIVER_NAME)) {
 		pr_devinit(KERN_ERR DRIVER_NAME ": Failed to request gpio %d\n", state->enet_flash_pin);
 		return -EBUSY;
@@ -161,26 +158,7 @@ static int __devinit bfin_flash_probe(st
 	if (!state->mtd)
 		return -ENXIO;
 
-#ifdef CONFIG_MTD_PARTITIONS
-	ret = parse_mtd_partitions(state->mtd, part_probe_types, &pdata->parts, 0);
-	if (ret > 0) {
-		pr_devinit(KERN_NOTICE DRIVER_NAME ": Using commandline partition definition\n");
-		add_mtd_partitions(state->mtd, pdata->parts, ret);
-
-	} else if (pdata->nr_parts) {
-		pr_devinit(KERN_NOTICE DRIVER_NAME ": Using board partition definition\n");
-		add_mtd_partitions(state->mtd, pdata->parts, pdata->nr_parts);
-
-	} else
-#endif
-	{
-		pr_devinit(KERN_NOTICE DRIVER_NAME ": no partition info available, registering whole flash at once\n");
-		add_mtd_device(state->mtd);
-	}
-
-	platform_set_drvdata(pdev, state);
