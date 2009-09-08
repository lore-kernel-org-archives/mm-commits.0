From: akpm@linux-foundation.org
Subject: [merged] mtd-make-onenand-genericc-more-generic-fix.patch removed from -mm tree
Date: Tue, 08 Sep 2009 14:26:31 -0700
Message-ID: <200909082126.n88LQVxU007172@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42408 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752200AbZIHV0s (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Sep 2009 17:26:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lethal@linux-sh.org, damm@igel.co.jp, dwmw2@infradead.org, kmpark@infradead.org, randy.dunlap@oracle.com, tony@atomide.com, mm-commits@vger.kernel.org


The patch titled
     mtd: onenand: select MTD_PARTITIONS
has been removed from the -mm tree.  Its filename was
     mtd-make-onenand-genericc-more-generic-fix.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mtd: onenand: select MTD_PARTITIONS
From: Paul Mundt <lethal@linux-sh.org>

All of the onenand drivers depend on mtd partition support being compiled
in, so just select it.  Fixes up build breakage:

drivers/built-in.o: In function `generic_onenand_remove':
generic.c:(.devexit.text+0x80): undefined reference to `del_mtd_partitions'

Reported-by: Randy Dunlap <randy.dunlap@oracle.com>
Acked-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Paul Mundt <lethal@linux-sh.org>
Cc: Magnus Damm <damm@igel.co.jp>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Tony Lindgren <tony@atomide.com>
Cc: Kyungmin Park <kmpark@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mtd/onenand/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/mtd/onenand/Kconfig~mtd-make-onenand-genericc-more-generic-fix drivers/mtd/onenand/Kconfig
--- a/drivers/mtd/onenand/Kconfig~mtd-make-onenand-genericc-more-generic-fix
+++ a/drivers/mtd/onenand/Kconfig
@@ -5,6 +5,7 @@
 menuconfig MTD_ONENAND
 	tristate "OneNAND Device Support"
 	depends on MTD
+	select MTD_PARTITIONS
 	help
 	  This enables support for accessing all type of OneNAND flash
 	  devices. For further information see
@@ -65,7 +66,6 @@ config MTD_ONENAND_2X_PROGRAM
 
 config MTD_ONENAND_SIM
 	tristate "OneNAND simulator support"
-	depends on MTD_PARTITIONS
 	help
 	  The simulator may simulate various OneNAND flash chips for the
 	  OneNAND MTD layer.
_

Patches currently in -mm which might be from lethal@linux-sh.org are

linux-next.patch
mtd-make-onenand-genericc-more-generic.patch
arches-drop-superfluous-casts-in-nr_free_pages-callers.patch
mmc-make-the-configuration-memory-resource-optional.patch
tmio_mmc-optionally-support-using-platform-clock.patch
sh-switch-migo-r-to-use-the-tmio-mmc-driver-instead-of-spi.patch
fdpic-ignore-the-loaders-pt_gnu_stack-when-calculating-the-stack-size.patch
flat-use-is_err_value-helper-macro.patch

