From: akpm@linux-foundation.org
Subject: + fix-config_mtd_sharp_sl-if-config_mtd=m-try2.patch added to -mm tree
Date: Mon, 26 Nov 2007 15:11:27 -0800
Message-ID: <200711262311.lAQNBRbY027882@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41120 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753783AbXKZXL4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 26 Nov 2007 18:11:56 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: utx@penguin.cz, dwmw2@infradead.org, pavel@ucw.cz


The patch titled
     fix CONFIG_MTD_SHARP_SL if CONFIG_MTD=m
has been added to the -mm tree.  Its filename is
     fix-config_mtd_sharp_sl-if-config_mtd=m-try2.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
fix-config_mtd_sharp_sl-if-config_mtd=m-try2.patch
