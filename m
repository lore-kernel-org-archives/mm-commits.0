From: akpm@linux-foundation.org
Subject: + mtd-remove-redundant-dead-code-from-physmap_ofc.patch added to -mm tree
Date: Sat, 28 Jul 2007 23:56:55 -0700
Message-ID: <200707290656.l6T6utMB012565@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55886 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759700AbXG2G5K (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 29 Jul 2007 02:57:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: m.kozlowski@tuxland.pl, dwmw2@infradead.org


The patch titled
     mtd: remove redundant/dead code from physmap_of.c
has been added to the -mm tree.  Its filename is
     mtd-remove-redundant-dead-code-from-physmap_ofc.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: mtd: remove redundant/dead code from physmap_of.c
From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>

Remove redundant memset() and dead return line from of_physmap_probe().  No
functional change.

Signed-off-by: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
Cc: David Woodhouse <dwmw2@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mtd/maps/physmap_of.c |    5 -----
 1 file changed, 5 deletions(-)

diff -puN drivers/mtd/maps/physmap_of.c~mtd-remove-redundant-dead-code-from-physmap_ofc drivers/mtd/maps/physmap_of.c
--- a/drivers/mtd/maps/physmap_of.c~mtd-remove-redundant-dead-code-from-physmap_ofc
+++ a/drivers/mtd/maps/physmap_of.c
@@ -141,7 +141,6 @@ static int __devinit of_physmap_probe(st
 		err = -ENOMEM;
 		goto err_out;
 	}
-	memset(info, 0, sizeof(*info));
 
 	dev_set_drvdata(&dev->dev, info);
 
@@ -213,10 +212,6 @@ static int __devinit of_physmap_probe(st
 err_out:
 	of_physmap_remove(dev);
 	return err;
-
-	return 0;
-
-
 }
 
 static struct of_device_id of_physmap_match[] = {
_

Patches currently in -mm which might be from m.kozlowski@tuxland.pl are

mtd-add-module-license-to-mtdbdi.patch
mtd-remove-redundant-dead-code-from-physmap_ofc.patch
dont-optimise-away-baud-rate-changes-when-bother-is-used.patch
fs-9p-convc-error-path-fix.patch
