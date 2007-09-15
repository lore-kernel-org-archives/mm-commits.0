From: akpm@linux-foundation.org
Subject: + add-support-for-pcmcia-card-sierra-wireless-ac850.patch added to -mm tree
Date: Sat, 15 Sep 2007 00:33:57 -0700
Message-ID: <200709150733.l8F7XvaZ022476@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51090 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750917AbXIOHew (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 15 Sep 2007 03:34:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: eric@inl.fr, linux@dominikbrodowski.net, rmk@arm.linux.org.uk


The patch titled
     Add support for PCMCIA card Sierra WIreless AC850
has been added to the -mm tree.  Its filename is
     add-support-for-pcmcia-card-sierra-wireless-ac850.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Add support for PCMCIA card Sierra WIreless AC850
From: Eric Leblond <eric@inl.fr>

Add support for Sierra Wireless AC850 which has the same Ids as the
AC710/750 but has a different firmware.

Cc: Dominik Brodowski <linux@dominikbrodowski.net>
Cc: Russell King <rmk@arm.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/serial/serial_cs.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/serial/serial_cs.c~add-support-for-pcmcia-card-sierra-wireless-ac850 drivers/serial/serial_cs.c
--- a/drivers/serial/serial_cs.c~add-support-for-pcmcia-card-sierra-wireless-ac850
+++ a/drivers/serial/serial_cs.c
@@ -911,6 +911,7 @@ static struct pcmcia_device_id serial_id
 	PCMCIA_MFC_DEVICE_CIS_MANF_CARD(1, 0x0175, 0x0000, "DP83903.cis"),
 	PCMCIA_MFC_DEVICE_CIS_MANF_CARD(1, 0x0101, 0x0035, "3CXEM556.cis"),
 	PCMCIA_MFC_DEVICE_CIS_MANF_CARD(1, 0x0101, 0x003d, "3CXEM556.cis"),
+	PCMCIA_DEVICE_CIS_PROD_ID12("Sierra Wireless", "AC850", 0xd85f6206, 0x42a2c018, "SW_8xx_SER.cis"),  /* Sierra Wireless AC850 3G Network Adapter R1 */
 	PCMCIA_DEVICE_CIS_MANF_CARD(0x0192, 0x0710, "SW_7xx_SER.cis"),	/* Sierra Wireless AC710/AC750 GPRS Network Adapter R1 */
 	PCMCIA_DEVICE_CIS_MANF_CARD(0x0192, 0xa555, "SW_555_SER.cis"),  /* Sierra Aircard 555 CDMA 1xrtt Modem -- pre update */
 	PCMCIA_DEVICE_CIS_MANF_CARD(0x013f, 0xa555, "SW_555_SER.cis"),  /* Sierra Aircard 555 CDMA 1xrtt Modem -- post update */
_

Patches currently in -mm which might be from eric@inl.fr are

add-support-for-pcmcia-card-sierra-wireless-ac850.patch
