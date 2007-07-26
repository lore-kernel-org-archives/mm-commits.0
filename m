From: akpm@linux-foundation.org
Subject: + char-cyclades-select-fw_loader.patch added to -mm tree
Date: Wed, 25 Jul 2007 23:29:11 -0700
Message-ID: <200707260629.l6Q6TBnk018077@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36107 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754419AbXGZG3W (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 26 Jul 2007 02:29:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jirislaby@gmail.com, toralf.foerster@gmx.de


The patch titled
     Char: cyclades, select FW_LOADER
has been added to the -mm tree.  Its filename is
     char-cyclades-select-fw_loader.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Char: cyclades, select FW_LOADER
From: Jiri Slaby <jirislaby@gmail.com>

Fix link errors below by selecting FW_LOADER
  LD      .tmp_vmlinux1
drivers/built-in.o: In function `cyz_load_fw':
drivers/char/cyclades.c:4908: undefined reference to `request_firmware'
drivers/char/cyclades.c:4979: undefined reference to `release_firmware'

Cc: <toralf.foerster@gmx.de>
Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/Kconfig |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/char/Kconfig~char-cyclades-select-fw_loader drivers/char/Kconfig
--- a/drivers/char/Kconfig~char-cyclades-select-fw_loader
+++ a/drivers/char/Kconfig
@@ -130,6 +130,7 @@ config ROCKETPORT
 config CYCLADES
 	tristate "Cyclades async mux support"
 	depends on SERIAL_NONSTANDARD && (PCI || ISA)
+	select FW_LOADER
 	---help---
 	  This driver supports Cyclades Z and Y multiserial boards.
 	  You would need something like this to connect more than two modems to
_

Patches currently in -mm which might be from jirislaby@gmail.com are

char-cyclades-select-fw_loader.patch
char-moxa-fix-and-optimise-empty-timer.patch
shrink_slab-handle-bad-shrinkers.patch
