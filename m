From: akpm@linux-foundation.org
Subject: [merged] misc-ibmasm-fix-build-errors.patch removed from -mm tree
Date: Thu, 21 Jan 2016 14:58:34 -0800
Message-ID: <56a1629a.0Mvb2KQ3hXMeEPW9%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33780 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751736AbcAUW6f (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 21 Jan 2016 17:58:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rdunlap@infradead.org, masbock@us.ibm.com, vernux@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: misc: ibmasm: fix build errors
has been removed from the -mm tree.  Its filename was
     misc-ibmasm-fix-build-errors.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Randy Dunlap <rdunlap@infradead.org>
Subject: misc: ibmasm: fix build errors

Fix build when CONFIG_SERIAL_8250=m and CONFIG_IBM_ASM=y.

Fixes these build errors:

drivers/built-in.o: In function `ibmasm_remove_one':
module.c:(.text+0xf6874): undefined reference to `ibmasm_unregister_uart'
drivers/built-in.o: In function `ibmasm_init_one':
module.c:(.text+0xf6c37): undefined reference to `ibmasm_register_uart'

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Max Asbock <masbock@us.ibm.com>
Cc: Vernon Mauery <vernux@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/Kconfig |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/misc/Kconfig~misc-ibmasm-fix-build-errors drivers/misc/Kconfig
--- a/drivers/misc/Kconfig~misc-ibmasm-fix-build-errors
+++ a/drivers/misc/Kconfig
@@ -95,6 +95,7 @@ config DUMMY_IRQ
 config IBM_ASM
 	tristate "Device driver for IBM RSA service processor"
 	depends on X86 && PCI && INPUT
+	depends on SERIAL_8250 || SERIAL_8250=n
 	---help---
 	  This option enables device driver support for in-band access to the
 	  IBM RSA (Condor) service processor in eServer xSeries systems.
_

Patches currently in -mm which might be from rdunlap@infradead.org are


