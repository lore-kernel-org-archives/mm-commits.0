From: akpm@linux-foundation.org
Subject: - max3100-spi-uart-driver-select-serial_core.patch removed from -mm tree
Date: Fri, 09 Jan 2009 14:18:01 -0800
Message-ID: <200901092218.n09MI1jR021428@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54716 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759172AbZAIWSh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 9 Jan 2009 17:18:37 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, chripell@evolware.org, mm-commits@vger.kernel.org


The patch titled
     max3100: select SERIAL_CORE
has been removed from the -mm tree.  Its filename was
     max3100-spi-uart-driver-select-serial_core.patch

This patch was dropped because it was folded into max3100-spi-uart-driver.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: max3100: select SERIAL_CORE
From: Randy Dunlap <randy.dunlap@oracle.com>

max3100 driver need to select SERIAL_CORE like most other serial drivers do.

max3100.c:(.text+0x524c5): undefined reference to `uart_write_wakeup'
max3100.c:(.text+0x526eb): undefined reference to `uart_write_wakeup'
max3100.c:(.text+0x529f7): undefined reference to `uart_update_timeout'
max3100.c:(.text+0x52cfa): undefined reference to `uart_resume_port'
max3100.c:(.text+0x52d6a): undefined reference to `uart_suspend_port'
max3100.c:(.devinit.text+0x23e3): undefined reference to `uart_register_driver'
max3100.c:(.devinit.text+0x265a): undefined reference to `uart_add_one_port'
max3100.c:(.devexit.text+0x1aa): undefined reference to `uart_remove_one_port'
max3100.c:(.devexit.text+0x1e5): undefined reference to `uart_unregister_driver'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Christian Pellegrin <chripell@evolware.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/serial/Kconfig |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/serial/Kconfig~max3100-spi-uart-driver-select-serial_core drivers/serial/Kconfig
--- a/drivers/serial/Kconfig~max3100-spi-uart-driver-select-serial_core
+++ a/drivers/serial/Kconfig
@@ -536,6 +536,7 @@ config SERIAL_S3C6400
 config SERIAL_MAX3100
 	tristate "MAX3100 support"
 	depends on SPI
+	select SERIAL_CORE
 	help
 	  MAX3100 chip support
 
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
max3100-spi-uart-driver.patch
max3100-spi-uart-driver-select-serial_core.patch
linuxpps-core-support.patch
pps-userland-header-file-for-pps-api.patch
pps-documentation-programs-and-examples.patch
pps-linuxpps-clients-support.patch
ldisc-new-dcd_change-method-for-line-disciplines.patch
pps-parallel-port-clients-support.patch

