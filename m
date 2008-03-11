From: akpm@linux-foundation.org
Subject: - of_serial-fix-section-mismatch-warnings.patch removed from -mm tree
Date: Mon, 10 Mar 2008 20:21:34 -0700
Message-ID: <200803110321.m2B3LYht019730@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34982 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752135AbYCKDWb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 10 Mar 2008 23:22:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jwboyer@linux.vnet.ibm.com, arnd@arndb.de, benh@kernel.crashing.org, paulus@samba.org, mm-commits@vger.kernel.org


The patch titled
     of_serial: fix section mismatch warnings
has been removed from the -mm tree.  Its filename was
     of_serial-fix-section-mismatch-warnings.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

