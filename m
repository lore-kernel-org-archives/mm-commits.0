From: akpm@linux-foundation.org
Subject: + ibmasm-must-depend-on-config_input.patch added to -mm tree
Date: Mon, 14 May 2007 22:06:16 -0700
Message-ID: <200705150506.l4F56F0M001964@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:49455 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755836AbXEOFGv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 15 May 2007 01:06:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dtor@insightbb.com, dtor@mail.ru, masbock@us.ibm.com, vernux@us.ibm.com


The patch titled
     IBMASM: must depend on CONFIG_INPUT
has been added to the -mm tree.  Its filename is
     ibmasm-must-depend-on-config_input.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: IBMASM: must depend on CONFIG_INPUT
From: Dmitry Torokhov <dtor@insightbb.com>

IBMASM: must depend on CONFIG_INPUT

The driver registers couple of input devices and therefore must depend
on CONFIG_INPUT.

Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
Cc: Vernon Mauery <vernux@us.ibm.com>
Cc: Max Asbock <masbock@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/misc/Kconfig~ibmasm-must-depend-on-config_input drivers/misc/Kconfig
--- a/drivers/misc/Kconfig~ibmasm-must-depend-on-config_input
+++ a/drivers/misc/Kconfig
@@ -10,7 +10,7 @@ if MISC_STRANGE_DEV
 
 config IBM_ASM
 	tristate "Device driver for IBM RSA service processor"
-	depends on X86 && PCI && EXPERIMENTAL
+	depends on X86 && PCI && INPUT && EXPERIMENTAL
 	---help---
 	  This option enables device driver support for in-band access to the
 	  IBM RSA (Condor) service processor in eServer xSeries systems.
_

Patches currently in -mm which might be from dtor@insightbb.com are

git-input.patch
revert-input-alps-handle-errors-from-input_register_device.patch
ibmasm-whitespace-cleanup.patch
ibmasm-dont-use-extern-in-function-declarations.patch
ibmasm-miscellaneous-fixes.patch
ibmasm-must-depend-on-config_input.patch
