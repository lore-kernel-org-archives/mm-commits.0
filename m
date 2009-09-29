From: akpm@linux-foundation.org
Subject: + uartlite-allow-building-for-timberdale-mfd.patch added to -mm tree
Date: Tue, 29 Sep 2009 16:21:38 -0700
Message-ID: <200909292321.n8TNLcxT010132@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36215 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752793AbZI2XVo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 Sep 2009 19:21:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: richard.rojfors@mocean-labs.com, alan@lxorguk.ukuu.org.uk


The patch titled
     uartlite: allow building for timberdale MFD
has been added to the -mm tree.  Its filename is
     uartlite-allow-building-for-timberdale-mfd.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your cod=
e ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mm=
otm/

------------------------------------------------------
Subject: uartlite: allow building for timberdale MFD
=46rom: Richard R=F6jfors <richard.rojfors@mocean-labs.com>

Some configurations of the Timberdale FPGA has the uartlite
included.

Signed-off-by: Richard R=F6jfors <richard.rojfors@mocean-labs.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/serial/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/serial/Kconfig~uartlite-allow-building-for-timberdale=
-mfd drivers/serial/Kconfig
--- a/drivers/serial/Kconfig~uartlite-allow-building-for-timberdale-mfd
+++ a/drivers/serial/Kconfig
@@ -862,7 +862,7 @@ config SERIAL_IMX_CONSOLE
=20
 config SERIAL_UARTLITE
 	tristate "Xilinx uartlite serial port support"
-	depends on PPC32 || MICROBLAZE
+	depends on PPC32 || MICROBLAZE || MFD_TIMBERDALE
 	select SERIAL_CORE
 	help
 	  Say Y here if you want to use the Xilinx uartlite serial controller=
=2E
_

Patches currently in -mm which might be from richard.rojfors@mocean-lab=
s.com are

uartlite-allow-building-for-timberdale-mfd.patch
xilinx_spi-split-into-generic-of-and-platform-driver-add-support-for-ds=
570.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
