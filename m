From: akpm@linux-foundation.org
Subject: + misc-ibmasm-fix-build-errors.patch added to -mm tree
Date: Tue, 19 Jan 2016 15:36:08 -0800
Message-ID: <569ec868.CEuOb3Xi7oZn7jsO%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55499 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757492AbcASXgJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 19 Jan 2016 18:36:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rdunlap@infradead.org, masbock@us.ibm.com, vernux@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: misc: ibmasm: fix build errors
has been added to the -mm tree.  Its filename is
     misc-ibmasm-fix-build-errors.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/misc-ibmasm-fix-build-errors.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/misc-ibmasm-fix-build-errors.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

misc-ibmasm-fix-build-errors.patch

