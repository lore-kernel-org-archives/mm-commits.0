From: akpm@linux-foundation.org
Subject: + of_serial-fix-section-mismatch-warnings.patch added to -mm tree
Date: Wed, 05 Mar 2008 00:21:38 -0500
Message-ID: <200803050522.m255MLSW016306@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58862 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751034AbYCEFWp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 5 Mar 2008 00:22:45 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jwboyer@linux.vnet.ibm.com, arnd@arndb.de, benh@kernel.crashing.org, paulus@samba.org


The patch titled
     of_serial: fix section mismatch warnings
has been added to the -mm tree.  Its filename is
     of_serial-fix-section-mismatch-warnings.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: of_serial: fix section mismatch warnings
From: Josh Boyer <jwboyer@linux.vnet.ibm.com>

Fix the following section mismatches:

WARNING: drivers/built-in.o(.exit.text+0x5a): Section mismatch in reference from the function of_platform_serial_exit() to the variable .devinit.data:of_platform_serial_driver
The function __exit of_platform_serial_exit() references
a variable __devinitdata of_platform_serial_driver.

Signed-off-by: Josh Boyer <jwboyer@linux.vnet.ibm.com>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/serial/of_serial.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/serial/of_serial.c~of_serial-fix-section-mismatch-warnings drivers/serial/of_serial.c
--- a/drivers/serial/of_serial.c~of_serial-fix-section-mismatch-warnings
+++ a/drivers/serial/of_serial.c
@@ -138,7 +138,7 @@ static struct of_device_id __devinitdata
 	{ /* end of list */ },
 };
 
-static struct of_platform_driver __devinitdata of_platform_serial_driver = {
+static struct of_platform_driver of_platform_serial_driver = {
 	.owner = THIS_MODULE,
 	.name = "of_serial",
 	.probe = of_platform_serial_probe,
_

Patches currently in -mm which might be from jwboyer@linux.vnet.ibm.com are

origin.patch
of_serial-fix-section-mismatch-warnings.patch

