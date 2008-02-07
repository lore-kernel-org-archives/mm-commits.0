From: akpm@linux-foundation.org
Subject: - remove-inclusions-of-linux-autoconfh.patch removed from -mm tree
Date: Wed, 06 Feb 2008 16:20:41 -0800
Message-ID: <200802070020.m170KMaf006123@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40521 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933864AbYBGAUh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Feb 2008 19:20:37 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ralf@linux-mips.org, cooloney.lkml@gmail.com, vapier.adi@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Remove inclusions of <linux/autoconf.h>
has been removed from the -mm tree.  Its filename was
     remove-inclusions-of-linux-autoconfh.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Remove inclusions of <linux/autoconf.h>
From: Ralf Baechle <ralf@linux-mips.org>

Nothing should ever include this file.

Signed-off-by: Ralf Baechle <ralf@linux-mips.org>
Acked-by: "Mike Frysinger" <vapier.adi@gmail.com>
Acked-by: "Bryan Wu" <cooloney.lkml@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/m68knommu/lib/memcpy.c    |    1 -
 arch/mips/au1000/common/gpio.c |    1 -
 drivers/char/mxser.c           |    1 -
 drivers/char/mxser_new.c       |    1 -
 drivers/firmware/dmi-id.c      |    1 -
 drivers/misc/asus-laptop.c     |    1 -
 drivers/misc/fujitsu-laptop.c  |    1 -
 drivers/misc/msi-laptop.c      |    1 -
 drivers/spi/spi.c              |    1 -
 9 files changed, 9 deletions(-)

diff -puN arch/m68knommu/lib/memcpy.c~remove-inclusions-of-linux-autoconfh arch/m68knommu/lib/memcpy.c
--- a/arch/m68knommu/lib/memcpy.c~remove-inclusions-of-linux-autoconfh
+++ a/arch/m68knommu/lib/memcpy.c
@@ -1,6 +1,5 @@
 
 #include <linux/types.h>
-#include <linux/autoconf.h>
 
 void * memcpy(void * to, const void * from, size_t n)
 {
diff -puN arch/mips/au1000/common/gpio.c~remove-inclusions-of-linux-autoconfh arch/mips/au1000/common/gpio.c
--- a/arch/mips/au1000/common/gpio.c~remove-inclusions-of-linux-autoconfh
+++ a/arch/mips/au1000/common/gpio.c
@@ -27,7 +27,6 @@
  * 	others have a second one : GPIO2
  */
 
-#include <linux/autoconf.h>
 #include <linux/init.h>
 #include <linux/io.h>
 #include <linux/types.h>
diff -puN drivers/char/mxser.c~remove-inclusions-of-linux-autoconfh drivers/char/mxser.c
--- a/drivers/char/mxser.c~remove-inclusions-of-linux-autoconfh
+++ a/drivers/char/mxser.c
@@ -37,7 +37,6 @@
 
 
 #include <linux/module.h>
-#include <linux/autoconf.h>
 #include <linux/errno.h>
 #include <linux/signal.h>
 #include <linux/sched.h>
diff -puN drivers/char/mxser_new.c~remove-inclusions-of-linux-autoconfh drivers/char/mxser_new.c
--- a/drivers/char/mxser_new.c~remove-inclusions-of-linux-autoconfh
+++ a/drivers/char/mxser_new.c
@@ -20,7 +20,6 @@
  */
 
 #include <linux/module.h>
-#include <linux/autoconf.h>
 #include <linux/errno.h>
 #include <linux/signal.h>
 #include <linux/sched.h>
diff -puN drivers/firmware/dmi-id.c~remove-inclusions-of-linux-autoconfh drivers/firmware/dmi-id.c
--- a/drivers/firmware/dmi-id.c~remove-inclusions-of-linux-autoconfh
+++ a/drivers/firmware/dmi-id.c
@@ -11,7 +11,6 @@
 #include <linux/init.h>
 #include <linux/dmi.h>
 #include <linux/device.h>
-#include <linux/autoconf.h>
 
 struct dmi_device_attribute{
 	struct device_attribute dev_attr;
diff -puN drivers/misc/asus-laptop.c~remove-inclusions-of-linux-autoconfh drivers/misc/asus-laptop.c
--- a/drivers/misc/asus-laptop.c~remove-inclusions-of-linux-autoconfh
+++ a/drivers/misc/asus-laptop.c
@@ -33,7 +33,6 @@
  *  Sam Lin        - GPS support
  */
 
-#include <linux/autoconf.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/init.h>
diff -puN drivers/misc/fujitsu-laptop.c~remove-inclusions-of-linux-autoconfh drivers/misc/fujitsu-laptop.c
--- a/drivers/misc/fujitsu-laptop.c~remove-inclusions-of-linux-autoconfh
+++ a/drivers/misc/fujitsu-laptop.c
@@ -50,7 +50,6 @@
 #include <linux/dmi.h>
 #include <linux/backlight.h>
 #include <linux/platform_device.h>
-#include <linux/autoconf.h>
 
 #define FUJITSU_DRIVER_VERSION "0.3"
 
diff -puN drivers/misc/msi-laptop.c~remove-inclusions-of-linux-autoconfh drivers/misc/msi-laptop.c
--- a/drivers/misc/msi-laptop.c~remove-inclusions-of-linux-autoconfh
+++ a/drivers/misc/msi-laptop.c
@@ -58,7 +58,6 @@
 #include <linux/dmi.h>
 #include <linux/backlight.h>
 #include <linux/platform_device.h>
-#include <linux/autoconf.h>
 
 #define MSI_DRIVER_VERSION "0.5"
 
diff -puN drivers/spi/spi.c~remove-inclusions-of-linux-autoconfh drivers/spi/spi.c
--- a/drivers/spi/spi.c~remove-inclusions-of-linux-autoconfh
+++ a/drivers/spi/spi.c
@@ -18,7 +18,6 @@
  * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
  */
 
-#include <linux/autoconf.h>
 #include <linux/kernel.h>
 #include <linux/device.h>
 #include <linux/init.h>
_

Patches currently in -mm which might be from ralf@linux-mips.org are

origin.patch
mips-use-find_task_by_vpid-in-system-calls.patch
git-watchdog.patch
dz-clean-up-and-improve-the-setup-of-termios-settings.patch
dzc-use-a-helper-to-cast-from-struct-uart_port.patch
dzc-resource-management.patch
sanitize-the-type-of-struct-useru_ar0.patch
add-cmpxchg64-and-cmpxchg64_local-to-mips.patch
pid-fix-mips-irix-emulation-pid-usage.patch
pid-fix-mips-irix-emulation-pid-usage-fix.patch
avoid-overflows-in-kernel-timec.patch
irq_noprobe-helper-functions.patch
mips-mark-all-but-i8259-interrupts-as-no-probe.patch
