From: akpm@linux-foundation.org
Subject: + mb862xxfb-restrict-compliation-of-platform-driver-to-ppc.patch added to -mm tree
Date: Wed, 13 May 2009 12:37:50 -0700
Message-ID: <200905131937.n4DJbo7K030585@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39014 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753350AbZEMTmc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 13 May 2009 15:42:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: julian.calaby@gmail.com, agust@denx.de, arnd@arndb.de, benh@kernel.crashing.org, davem@davemloft.net, monstr@monstr.eu


The patch titled
     mb862xxfb: restrict compliation of platform driver to PPC
has been added to the -mm tree.  Its filename is
     mb862xxfb-restrict-compliation-of-platform-driver-to-ppc.patch

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
Subject: mb862xxfb: restrict compliation of platform driver to PPC
From: Julian Calaby <julian.calaby@gmail.com>

The OpenFirmware part of this driver is uncompilable on SPARC due to it's
dependance on several PPC specific functions.

Restricting this to PPC to prevent these build errors:
  CC      drivers/video/mb862xx/mb862xxfb.o
drivers/video/mb862xx/mb862xxfb.c: In function 'of_platform_mb862xx_probe':
drivers/video/mb862xx/mb862xxfb.c:559: error: implicit declaration of function 'of_address_to_resource'
drivers/video/mb862xx/mb862xxfb.c:575: error: 'NO_IRQ' undeclared (first use in this function)
drivers/video/mb862xx/mb862xxfb.c:575: error: (Each undeclared identifier is reported only once
drivers/video/mb862xx/mb862xxfb.c:575: error: for each function it appears in.)

This was found using randconfig builds.

Signed-off-by: Julian Calaby <julian.calaby@gmail.com>
Signed-off-by: Anatolij Gustschin <agust@denx.de>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Anatolij Gustschin <agust@denx.de>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Michal Simek <monstr@monstr.eu>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/Kconfig |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/video/Kconfig~mb862xxfb-restrict-compliation-of-platform-driver-to-ppc drivers/video/Kconfig
--- a/drivers/video/Kconfig~mb862xxfb-restrict-compliation-of-platform-driver-to-ppc
+++ a/drivers/video/Kconfig
@@ -2094,6 +2094,7 @@ config FB_MB862XX_LIME
 	bool "Lime GDC"
 	depends on FB_MB862XX
 	depends on OF && !FB_MB862XX_PCI_GDC
+	depends on PPC
 	select FB_FOREIGN_ENDIAN
 	select FB_LITTLE_ENDIAN
 	---help---
_

Patches currently in -mm which might be from julian.calaby@gmail.com are

mb862xxfb-restrict-compliation-of-platform-driver-to-ppc.patch

