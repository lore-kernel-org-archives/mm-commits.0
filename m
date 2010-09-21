From: akpm@linux-foundation.org
Subject: + viafb-enable-i2c-for-crt.patch added to -mm tree
Date: Tue, 21 Sep 2010 15:37:13 -0700
Message-ID: <201009212237.o8LMbDg3006798@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42665 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752872Ab0IUWht (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 21 Sep 2010 18:37:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: FlorianSchandinat@gmx.de, JosephChan@via.com.tw, corbet@lwn.net


The patch titled
     viafb: enable I2C for CRT
has been added to the -mm tree.  Its filename is
     viafb-enable-i2c-for-crt.patch

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
Subject: viafb: enable I2C for CRT
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>

Enbale the I2C port to talk with the CRT.  This allows adding EDID reading
and parsing capability for CRTs.  Just a small preparation, no notable
changes in user experience yet.

Signed-off-by: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Cc: Joseph Chan <JosephChan@via.com.tw>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/via/via-core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/video/via/via-core.c~viafb-enable-i2c-for-crt drivers/video/via/via-core.c
--- a/drivers/video/via/via-core.c~viafb-enable-i2c-for-crt
+++ a/drivers/video/via/via-core.c
@@ -20,7 +20,7 @@
  * The default port config.
  */
 static struct via_port_cfg adap_configs[] = {
-	[VIA_PORT_26]	= { VIA_PORT_I2C,  VIA_MODE_OFF, VIASR, 0x26 },
+	[VIA_PORT_26]	= { VIA_PORT_I2C,  VIA_MODE_I2C, VIASR, 0x26 },
 	[VIA_PORT_31]	= { VIA_PORT_I2C,  VIA_MODE_I2C, VIASR, 0x31 },
 	[VIA_PORT_25]	= { VIA_PORT_GPIO, VIA_MODE_GPIO, VIASR, 0x25 },
 	[VIA_PORT_2C]	= { VIA_PORT_GPIO, VIA_MODE_I2C, VIASR, 0x2c },
_

Patches currently in -mm which might be from FlorianSchandinat@gmx.de are

linux-next.patch
viafb-add-interface-for-output-device-configuration.patch
viafb-limit-lcd-code-impact.patch
viafb-introduce-per-output-device-power-management.patch
viafb-vt1636-cleanup.patch
viafb-fix-i2c_transfer-error-handling.patch
viafb-enable-i2c-for-crt.patch
viafb-reduce-i2c-timeout-and-delay.patch
viafb-add-function-to-change-sync-polarity-per-device.patch
viafb-set-sync-polarity-for-all-output-devices.patch
viafb-add-a-mapping-of-supported-output-devices.patch
viafb-rename-output-devices.patch
viafb-add-documentation-for-proc-interface.patch

