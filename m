From: akpm@linux-foundation.org
Subject: - leds-add-a-dac124s085-spi-led-driver-fix.patch removed from -mm tree
Date: Fri, 09 Jan 2009 12:20:25 -0800
Message-ID: <200901092020.n09KKP4A017766@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46129 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754441AbZAIUWD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 9 Jan 2009 15:22:03 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, ben-linux@fluff.org, hmh@hmh.eng.br, lg@denx.de, rpurdie@rpsys.net, mm-commits@vger.kernel.org


The patch titled
     leds-dac124s085: use header files for interfaces
has been removed from the -mm tree.  Its filename was
     leds-add-a-dac124s085-spi-led-driver-fix.patch

This patch was dropped because it was folded into leds-add-a-dac124s085-spi-led-driver.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: leds-dac124s085: use header files for interfaces
From: Randy Dunlap <randy.dunlap@oracle.com>

Fix build errors caused by not using #includes for interfaces that are used:

drivers/leds/leds-dac124s085.c: In function 'dac124s085_probe':
drivers/leds/leds-dac124s085.c:70: error: 'GFP_KERNEL' undeclared (first use in this function)
drivers/leds/leds-dac124s085.c:70: warning: assignment makes pointer from integer without a cast
drivers/leds/leds-dac124s085.c: At top level:
drivers/leds/leds-dac124s085.c:127: error: field name not in record or union initializer
drivers/leds/leds-dac124s085.c:127: error: (near initialization for 'dac124s085_driver.driver')
drivers/leds/leds-dac124s085.c:128: error: field name not in record or union initializer
drivers/leds/leds-dac124s085.c:128: error: (near initialization for 'dac124s085_driver.driver')
drivers/leds/leds-dac124s085.c:128: error: 'THIS_MODULE' undeclared here (not in a function)
drivers/leds/leds-dac124s085.c:145: error: expected declaration specifiers or '...' before string constant
drivers/leds/leds-dac124s085.c:145: warning: data definition has no type or storage class
drivers/leds/leds-dac124s085.c:145: warning: type defaults to 'int' in declaration of 'MODULE_AUTHOR'
drivers/leds/leds-dac124s085.c:145: warning: function declaration isn't a prototype
drivers/leds/leds-dac124s085.c:146: error: expected declaration specifiers or '...' before string constant
drivers/leds/leds-dac124s085.c:146: warning: data definition has no type or storage class
drivers/leds/leds-dac124s085.c:146: warning: type defaults to 'int' in declaration of 'MODULE_DESCRIPTION'
drivers/leds/leds-dac124s085.c:146: warning: function declaration isn't a prototype
drivers/leds/leds-dac124s085.c:147: error: expected declaration specifiers or '...' before string constant
drivers/leds/leds-dac124s085.c:147: warning: data definition has no type or storage class
drivers/leds/leds-dac124s085.c:147: warning: type defaults to 'int' in declaration of 'MODULE_LICENSE'
drivers/leds/leds-dac124s085.c:147: warning: function declaration isn't a prototype

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Guennadi Liakhovetski <lg@denx.de>
Cc: Ben Dooks <ben-linux@fluff.org>
Cc: Richard Purdie <rpurdie@rpsys.net>
Cc: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/leds/leds-dac124s085.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN drivers/leds/leds-dac124s085.c~leds-add-a-dac124s085-spi-led-driver-fix drivers/leds/leds-dac124s085.c
--- a/drivers/leds/leds-dac124s085.c~leds-add-a-dac124s085-spi-led-driver-fix
+++ a/drivers/leds/leds-dac124s085.c
@@ -9,8 +9,11 @@
  * LED driver for the DAC124S085 SPI DAC
  */
 
+#include <linux/gfp.h>
 #include <linux/leds.h>
+#include <linux/module.h>
 #include <linux/mutex.h>
+#include <linux/slab.h>
 #include <linux/spinlock.h>
 #include <linux/workqueue.h>
 #include <linux/spi/spi.h>
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
linux-next.patch
kgdb-fix-kernel-doc-error.patch
es-input-allow-certain-ev_abs-events-to-bypass-all-filtering-fix.patch
leds-add-a-dac124s085-spi-led-driver.patch
leds-add-a-dac124s085-spi-led-driver-fix.patch
mtd-fix-nettel-printk-formats.patch
e1000e-make-e1000e-default-to-the-same-kconfig-setting-as-e1000.patch
sunrpc-fix-rdma-dependency.patch
proc-move-inode-comment-text-file-to-source-file.patch
esp-fix-section-mismatch-warning.patch
max3100-spi-uart-driver-select-serial_core.patch
linuxpps-core-support.patch
pps-userland-header-file-for-pps-api.patch
pps-documentation-programs-and-examples.patch
pps-linuxpps-clients-support.patch
ldisc-new-dcd_change-method-for-line-disciplines.patch
pps-parallel-port-clients-support.patch

