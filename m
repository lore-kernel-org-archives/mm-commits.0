From: akpm@linux-foundation.org
Subject: - ibmasm-must-depend-on-config_input.patch removed from -mm tree
Date: Tue, 17 Jul 2007 16:02:50 -0700
Message-ID: <200707172302.l6HN2ou0011628@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60277 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935806AbXGQXQj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 17 Jul 2007 19:16:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dtor@insightbb.com, dtor@mail.ru, masbock@us.ibm.com, vernux@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     IBMASM: must depend on CONFIG_INPUT
has been removed from the -mm tree.  Its filename was
     ibmasm-must-depend-on-config_input.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -10,7 +10,7 @@ if MISC_DEVICES
 
 config IBM_ASM
 	tristate "Device driver for IBM RSA service processor"
-	depends on X86 && PCI && EXPERIMENTAL
+	depends on X86 && PCI && INPUT && EXPERIMENTAL
 	---help---
 	  This option enables device driver support for in-band access to the
 	  IBM RSA (Condor) service processor in eServer xSeries systems.
_

Patches currently in -mm which might be from dtor@insightbb.com are

origin.patch
git-dvb.patch
git-input.patch
hdaps-switch-to-using-input-polldev.patch
applesmc-switch-to-using-input-polldev.patch
ams-switch-to-using-input-polldev.patch
