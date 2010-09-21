From: akpm@linux-foundation.org
Subject: + viafb-reduce-i2c-timeout-and-delay.patch added to -mm tree
Date: Tue, 21 Sep 2010 15:37:15 -0700
Message-ID: <201009212237.o8LMbFI7006801@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56289 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752257Ab0IUWht (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 21 Sep 2010 18:37:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: FlorianSchandinat@gmx.de, JosephChan@via.com.tw, corbet@lwn.net


The patch titled
     viafb: reduce I2C timeout and delay
has been added to the -mm tree.  Its filename is
     viafb-reduce-i2c-timeout-and-delay.patch

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
Subject: viafb: reduce I2C timeout and delay
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>

Reduce the value for I2C timeout and udelay.

The udelay was reduced to 10 (old: 40) which is still very high as for
standard-mode I2C even 5 should work.  This gives a speedup of factor 4
when talking to I2C devices.

The timeout was reduced to 2 (old: 20) which is taken from the radeon
driver so it should work as well.  This gives a speedup of factor 10 when
detecting that there is no I2C device we want to talk to.  This causes a
huge improvement of device initialization time.

Signed-off-by: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Cc: Joseph Chan <JosephChan@via.com.tw>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/via/via_i2c.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/video/via/via_i2c.c~viafb-reduce-i2c-timeout-and-delay drivers/video/via/via_i2c.c
--- a/drivers/video/via/via_i2c.c~viafb-reduce-i2c-timeout-and-delay
+++ a/drivers/video/via/via_i2c.c
@@ -202,8 +202,8 @@ static int create_i2c_bus(struct i2c_ada
 	algo->setscl = via_i2c_setscl;
 	algo->getsda = via_i2c_getsda;
 	algo->getscl = via_i2c_getscl;
-	algo->udelay = 40;
-	algo->timeout = 20;
+	algo->udelay = 10;
+	algo->timeout = 2;
 	algo->data = adap_cfg;
 
 	sprintf(adapter->name, "viafb i2c io_port idx 0x%02x",
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

