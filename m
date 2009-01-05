From: akpm@linux-foundation.org
Subject: + leds-add-a-dac124s085-spi-led-driver-fix.patch added to -mm tree
Date: Mon, 05 Jan 2009 14:31:39 -0800
Message-ID: <200901052231.n05MVeHJ029484@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60141 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751235AbZAEWdI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 5 Jan 2009 17:33:08 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com, ben-linux@fluff.org, hmh@hmh.eng.br, lg@denx.de, rpurdie@rpsys.net


The patch titled
     leds-dac124s085: use header files for interfaces
has been added to the -mm tree.  Its filename is
     leds-add-a-dac124s085-spi-led-driver-fix.patch

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
leds-add-a-dac124s085-spi-led-driver-fix.patch
mtd-fix-nettel-printk-formats.patch
e1000e-make-e1000e-default-to-the-same-kconfig-setting-as-e1000.patch
proc-move-inode-comment-text-file-to-source-file.patch
esp-fix-section-mismatch-warning.patch
fs-use-menuconfig-to-control-the-misc-filesystems-menu.patch
documentation-when-to-bug-and-when-to-not-bug.patch
fs-ncpfs-getoptc-cleanup-keneldoc.patch
max3100-spi-uart-driver-select-serial_core.patch
i2o-remove-extraneous-kernel-doc.patch
drivers-xen-xenbus-xenbus_clientc-cleanup-kerneldoc.patch
fs-ecryptfs-inodec-cleanup-kerneldoc.patch
kmod-fix-varargs-kernel-doc.patch
docs-document-how-to-write-varargs-in-kernel-doc.patch
rapidio-remove-excess-kernel-doc-notation.patch
documentation-update-header-file-paths.patch
documentation-update-s390-header-file-paths.patch
documentation-how-to-use-doc-section-blocks.patch
docs-add-more-early-params-to-kernel-parameterstxt.patch
doc-reformat-some-long-lines-in-kernel-parameterstxt.patch
w1-add-list-masters-w1-command.patch
linuxpps-core-support.patch
pps-userland-header-file-for-pps-api.patch
pps-documentation-programs-and-examples.patch
pps-linuxpps-clients-support.patch
ldisc-new-dcd_change-method-for-line-disciplines.patch
pps-parallel-port-clients-support.patch
fix-similar-typos-to-successfull-v2.patch
kmemleak-add-documentation-on-the-memory-leak-detector.patch

