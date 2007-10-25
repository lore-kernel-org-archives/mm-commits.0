From: akpm@linux-foundation.org
Subject: + remove-inclusions-of-linux-autoconfh.patch added to -mm tree
Date: Wed, 24 Oct 2007 20:58:17 -0700
Message-ID: <200710250358.l9P3wHgf030617@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47146 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758530AbXJYD6d (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 24 Oct 2007 23:58:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ralf@linux-mips.org, vapier.adi@gmail.com


The patch titled
     Remove inclusions of <linux/autoconf.h>
has been added to the -mm tree.  Its filename is
     remove-inclusions-of-linux-autoconfh.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Remove inclusions of <linux/autoconf.h>
From: Ralf Baechle <ralf@linux-mips.org>

Nothing should ever include this file.

Signed-off-by: Ralf Baechle <ralf@linux-mips.org>
Acked-by: "Mike Frysinger" <vapier.adi@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/blackfin/mach-common/interrupt.S |    1 -
 arch/blackfin/mm/blackfin_sram.c      |    1 -
 arch/m68knommu/lib/memcpy.c           |    1 -
 arch/mips/au1000/common/gpio.c        |    1 -
 drivers/char/mxser.c                  |    1 -
 drivers/char/mxser_new.c              |    1 -
 drivers/firmware/dmi-id.c             |    1 -
 drivers/ide/pci/delkin_cb.c           |    1 -
 drivers/misc/asus-laptop.c            |    1 -
 drivers/misc/fujitsu-laptop.c         |    1 -
 drivers/misc/msi-laptop.c             |    1 -
 drivers/spi/spi.c                     |    1 -
 12 files changed, 12 deletions(-)

diff -puN arch/blackfin/mach-common/interrupt.S~remove-inclusions-of-linux-autoconfh arch/blackfin/mach-common/interrupt.S
--- a/arch/blackfin/mach-common/interrupt.S~remove-inclusions-of-linux-autoconfh
+++ a/arch/blackfin/mach-common/interrupt.S
@@ -30,7 +30,6 @@
 
 #include <asm/blackfin.h>
 #include <asm/mach/irq.h>
-#include <linux/autoconf.h>
 #include <linux/linkage.h>
 #include <asm/entry.h>
 #include <asm/asm-offsets.h>
diff -puN arch/blackfin/mm/blackfin_sram.c~remove-inclusions-of-linux-autoconfh arch/blackfin/mm/blackfin_sram.c
--- a/arch/blackfin/mm/blackfin_sram.c~remove-inclusions-of-linux-autoconfh
+++ a/arch/blackfin/mm/blackfin_sram.c
@@ -27,7 +27,6 @@
  * 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
-#include <linux/autoconf.h>
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/types.h>
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
diff -puN drivers/ide/pci/delkin_cb.c~remove-inclusions-of-linux-autoconfh drivers/ide/pci/delkin_cb.c
--- a/drivers/ide/pci/delkin_cb.c~remove-inclusions-of-linux-autoconfh
+++ a/drivers/ide/pci/delkin_cb.c
@@ -18,7 +18,6 @@
  *  License.  See the file COPYING in the main directory of this archive for
  *  more details.
  */
-#include <linux/autoconf.h>
 #include <linux/types.h>
 #include <linux/module.h>
 #include <linux/mm.h>
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

rtc-release-correct-region-in-error-path.patch
rtc-fallback-to-requesting-only-the-ports-we-actually-use.patch
drivers-pmc-msp71xx-gpio-char-driver.patch
remove-inclusions-of-linux-autoconfh.patch
dz-clean-up-and-improve-the-setup-of-termios-settings.patch
embed-a-struct-path-into-struct-nameidata-instead-of-nd-dentrymnt.patch
embed-a-struct-path-into-struct-nameidata-instead-of-nd-dentrymnt-checkpatch-fixes.patch
