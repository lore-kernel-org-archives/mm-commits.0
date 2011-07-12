From: akpm@linux-foundation.org
Subject: + misc-eeprom-add-driver-for-microwire-93xx46-eeprom-fix.patch added to -mm tree
Date: Tue, 12 Jul 2011 16:49:57 -0700
Message-ID: <201107122349.p6CNnvsP011763@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59796 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753740Ab1GLXuF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 12 Jul 2011 19:50:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com, agust@denx.de


The patch titled
     misc-eeprom-add-driver-for-microwire-93xx46-eeprom-fix
has been added to the -mm tree.  Its filename is
     misc-eeprom-add-driver-for-microwire-93xx46-eeprom-fix.patch

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
Subject: misc-eeprom-add-driver-for-microwire-93xx46-eeprom-fix
From: Randy Dunlap <randy.dunlap@oracle.com>

fix printk format

drivers/misc/eeprom/eeprom_93xx46.c:95: warning: format '%d' expects type 'int', but argument 3 has type 'size_t'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Anatolij Gustschin <agust@denx.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/eeprom/eeprom_93xx46.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/misc/eeprom/eeprom_93xx46.c~misc-eeprom-add-driver-for-microwire-93xx46-eeprom-fix drivers/misc/eeprom/eeprom_93xx46.c
--- a/drivers/misc/eeprom/eeprom_93xx46.c~misc-eeprom-add-driver-for-microwire-93xx46-eeprom-fix
+++ a/drivers/misc/eeprom/eeprom_93xx46.c
@@ -91,7 +91,7 @@ eeprom_93xx46_bin_read(struct file *filp
 	/* have to wait at least Tcsl ns */
 	ndelay(250);
 	if (ret) {
-		dev_err(&edev->spi->dev, "read %d bytes at %d: err. %d\n",
+		dev_err(&edev->spi->dev, "read %zu bytes at %d: err. %d\n",
 			count, (int)off, ret);
 	}
 
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

linux-next.patch
drivers-scsi-megaraidc-fix-sparse-warnings.patch
um-clean-up-vm-flagsh.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch
misc-eeprom-add-driver-for-microwire-93xx46-eeprom-fix.patch
mutex-subsystem-synchro-test-module.patch
mutex-subsystem-synchro-test-module-fix.patch

