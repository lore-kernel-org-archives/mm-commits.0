From: akpm@linux-foundation.org
Subject: - fix-config_mtd_sharp_sl-if-config_mtd=m-try2.patch removed from -mm tree
Date: Wed, 28 Nov 2007 15:12:40 -0800
Message-ID: <200711282312.lASNCeJw023864@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60886 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756145AbXK1XN1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 28 Nov 2007 18:13:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: utx@penguin.cz, dwmw2@infradead.org, pavel@ucw.cz, mm-commits@vger.kernel.org


The patch titled
     fix CONFIG_MTD_SHARP_SL if CONFIG_MTD=m
has been removed from the -mm tree.  Its filename was
     fix-config_mtd_sharp_sl-if-config_mtd=m-try2.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: fix CONFIG_MTD_SHARP_SL if CONFIG_MTD=m
From: Stanislav Brabec <utx@penguin.cz>

Sharp Zaurus SL-C3200 with CONFIG_MTD=m and CONFIG_MTD_SHARP_SL=y (as it is
bool) lost support for the ROM flash.  With CONFIG_MTD=y it has no
problems.

It is caused by losing of compiled code of
drivers/mtd/maps/sharpsl-flash.o.  It was linked to
drivers/mtd/maps/built-in.o and drivers/mtd/built-in.o, but lost and not
linked to drivers/built-in.o (because CONFIG_MTD!=y).

Patch below fixes this problem by creating sharpsl-flash.ko (and the code
works correctly as a module).

Signed-off-by: Stanislav Brabec <utx@penguin.cz>
Cc: Pavel Machek <pavel@ucw.cz>
Cc: David Woodhouse <dwmw2@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mtd/maps/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/mtd/maps/Kconfig~fix-config_mtd_sharp_sl-if-config_mtd=m-try2 drivers/mtd/maps/Kconfig
--- a/drivers/mtd/maps/Kconfig~fix-config_mtd_sharp_sl-if-config_mtd=m-try2
+++ a/drivers/mtd/maps/Kconfig
@@ -576,7 +576,7 @@ config MTD_BAST_MAXSIZE
 	default "4"
 
 config MTD_SHARP_SL
-	bool "ROM mapped on Sharp SL Series"
+	tristate "ROM mapped on Sharp SL Series"
 	depends on ARCH_PXA
 	help
 	  This enables access to the flash chip on the Sharp SL Series of PDAs.
_

Patches currently in -mm which might be from utx@penguin.cz are

git-alsa.patch
git-mtd.patch
