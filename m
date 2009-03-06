From: akpm@linux-foundation.org
Subject: + mtd-plat_nand-allow-platform-to-set-partitions.patch added to -mm tree
Date: Fri, 06 Mar 2009 13:25:52 -0800
Message-ID: <200903062125.n26LPqmH000639@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49336 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750744AbZCFV1U (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 6 Mar 2009 16:27:20 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hsweeten@visionengravers.com, dwmw2@infradead.org


The patch titled
     mtd: plat_nand: allow platform to set partitions
has been added to the -mm tree.  Its filename is
     mtd-plat_nand-allow-platform-to-set-partitions.patch

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
Subject: mtd: plat_nand: allow platform to set partitions
From: H Hartley Sweeten <hsweeten@visionengravers.com>

Add optional callback to allow platform to initialize partitions.

Static partitions on a nand device could vary depending on the size of the
device.  This patch allows an optional platform callback to be used to
setup this partition information at runtime.

Scan order is:
	1) chip.part_probe_types
	2) chip.set_parts
	3) chip.partitions
	4) full mtd device (fallback for no partitions)

Some of the existing nand drivers could possibly be replaced by the
plat_nand driver by using this patch.  These include autcpu12.c and
ts7250.c drivers.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mtd/nand/plat_nand.c |    2 ++
 include/linux/mtd/nand.h     |    3 +++
 2 files changed, 5 insertions(+)

diff -puN drivers/mtd/nand/plat_nand.c~mtd-plat_nand-allow-platform-to-set-partitions drivers/mtd/nand/plat_nand.c
--- a/drivers/mtd/nand/plat_nand.c~mtd-plat_nand-allow-platform-to-set-partitions
+++ a/drivers/mtd/nand/plat_nand.c
@@ -93,6 +93,8 @@ static int __init plat_nand_probe(struct
 			return 0;
 		}
 	}
+	if (pdata->chip.set_parts)
+		pdata->chip.set_parts(data->mtd.size, &pdata->chip);
 	if (pdata->chip.partitions) {
 		data->parts = pdata->chip.partitions;
 		res = add_mtd_partitions(&data->mtd, data->parts,
diff -puN include/linux/mtd/nand.h~mtd-plat_nand-allow-platform-to-set-partitions include/linux/mtd/nand.h
--- a/include/linux/mtd/nand.h~mtd-plat_nand-allow-platform-to-set-partitions
+++ a/include/linux/mtd/nand.h
@@ -563,6 +563,7 @@ extern int nand_do_read(struct mtd_info 
  * @options:		Option flags, e.g. 16bit buswidth
  * @ecclayout:		ecc layout info structure
  * @part_probe_types:	NULL-terminated array of probe types
+ * @set_parts:		platform specific function to set partitions
  * @priv:		hardware controller specific settings
  */
 struct platform_nand_chip {
@@ -574,6 +575,8 @@ struct platform_nand_chip {
 	int			chip_delay;
 	unsigned int		options;
 	const char		**part_probe_types;
+	void			(*set_parts)(uint64_t size,
+					struct platform_nand_chip *chip);
 	void			*priv;
 };
 
_

Patches currently in -mm which might be from hsweeten@visionengravers.com are

linux-next.patch
mtd-plat_nand-add-platform-probe-remove-callbacks.patch
mtd-plat_nand-allow-platform-to-set-partitions.patch
auxdisplay-remove-parport-dependency.patch

