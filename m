From: akpm@osdl.org
Subject: + enable-mouse-button-23-emulation-for-x86-macs.patch added to -mm tree
Date: Mon, 29 Jan 2007 17:09:59 -0800
Message-ID: <200701300109.l0U19xkm005091@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:36219 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752604AbXA3BKH (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 29 Jan 2007 20:10:07 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kernel@nn7.de, benh@kernel.crashing.org, dtor@mail.ru, paulus@samba.org


The patch titled
     enable mouse button 2+3 emulation for x86 macs
has been added to the -mm tree.  Its filename is
     enable-mouse-button-23-emulation-for-x86-macs.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: enable mouse button 2+3 emulation for x86 macs
From: Soeren Sonnenburg <kernel@nn7.de>

As macbook/macbook pro's also have to live with a single mouse button the
following patch just enables the Macintosh device drivers menu in Kconfig +
adds the macintosh dir to the obj-* to make macbook* users happy (who use
exactly that since months....

Signed-off-by: Soeren Sonnenburg <kernel@nn7.de>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Dmitry Torokhov <dtor@mail.ru>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/Makefile          |    2 +-
 drivers/macintosh/Kconfig |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/Makefile~enable-mouse-button-23-emulation-for-x86-macs drivers/Makefile
--- a/drivers/Makefile~enable-mouse-button-23-emulation-for-x86-macs
+++ a/drivers/Makefile
@@ -30,7 +30,7 @@ obj-$(CONFIG_PARPORT)		+= parport/
 obj-y				+= base/ block/ misc/ mfd/ net/ media/
 obj-$(CONFIG_NUBUS)		+= nubus/
 obj-$(CONFIG_ATM)		+= atm/
-obj-$(CONFIG_PPC_PMAC)		+= macintosh/
+obj-y				+= macintosh/
 obj-$(CONFIG_IDE)		+= ide/
 obj-$(CONFIG_FC4)		+= fc4/
 obj-$(CONFIG_SCSI)		+= scsi/
diff -puN drivers/macintosh/Kconfig~enable-mouse-button-23-emulation-for-x86-macs drivers/macintosh/Kconfig
--- a/drivers/macintosh/Kconfig~enable-mouse-button-23-emulation-for-x86-macs
+++ a/drivers/macintosh/Kconfig
@@ -1,6 +1,6 @@
 
 menu "Macintosh device drivers"
-	depends on PPC || MAC
+	depends on PPC || MAC || X86
 
 config ADB
 	bool "Apple Desktop Bus (ADB) support"
_

Patches currently in -mm which might be from kernel@nn7.de are

enable-mouse-button-23-emulation-for-x86-macs.patch
