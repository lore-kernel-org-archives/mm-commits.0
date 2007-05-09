From: akpm@linux-foundation.org
Subject: - add-keyboard-blink-driver.patch removed from -mm tree
Date: Tue, 08 May 2007 19:50:02 -0700
Message-ID: <200705090250.l492o2pX009302@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:37868 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S969816AbXEICuH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 22:50:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ak@novell.com, ak@suse.de, mm-commits@vger.kernel.org


The patch titled
     Add keyboard blink driver
has been removed from the -mm tree.  Its filename was
     add-keyboard-blink-driver.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Add keyboard blink driver
From: Andi Kleen <ak@novell.com>

Simple driver that blinks the keyboard LEDs when loaded.  Useful for
checking that the kernel is still alive or for crashdumping

Signed-off-by: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/Kconfig  |    9 +++++++++
 drivers/misc/Makefile |    1 +
 drivers/misc/blink.c  |   27 +++++++++++++++++++++++++++
 3 files changed, 37 insertions(+)

diff -puN drivers/misc/Kconfig~add-keyboard-blink-driver drivers/misc/Kconfig
--- a/drivers/misc/Kconfig~add-keyboard-blink-driver
+++ a/drivers/misc/Kconfig
@@ -178,4 +178,13 @@ config THINKPAD_ACPI_BAY
 
 	  If you are not sure, say Y here.
 
+config BLINK
+	tristate "Keyboard blink driver"
+	help
+	  Driver that when loaded will blink the keyboard LEDs continuously.
+	  This is useful for debugging and for kernels that cannot necessarily
+	  output something to the screen like kexec kernels to give the user
+	  a visual indication that the kernel is doing something.
+
+
 endmenu
diff -puN drivers/misc/Makefile~add-keyboard-blink-driver drivers/misc/Makefile
--- a/drivers/misc/Makefile~add-keyboard-blink-driver
+++ a/drivers/misc/Makefile
@@ -7,6 +7,7 @@ obj-$(CONFIG_IBM_ASM)		+= ibmasm/
 obj-$(CONFIG_HDPU_FEATURES)	+= hdpuftrs/
 obj-$(CONFIG_MSI_LAPTOP)     += msi-laptop.o
 obj-$(CONFIG_ASUS_LAPTOP)     += asus-laptop.o
+obj-$(CONFIG_BLINK)		+= blink.o
 obj-$(CONFIG_LKDTM)		+= lkdtm.o
 obj-$(CONFIG_TIFM_CORE)       	+= tifm_core.o
 obj-$(CONFIG_TIFM_7XX1)       	+= tifm_7xx1.o
diff -puN /dev/null drivers/misc/blink.c
--- /dev/null
+++ a/drivers/misc/blink.c
@@ -0,0 +1,27 @@
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/timer.h>
+#include <linux/jiffies.h>
+
+static void do_blink(unsigned long data);
+
+static DEFINE_TIMER(blink_timer, do_blink, 0 ,0);
+
+static void do_blink(unsigned long data)
+{
+	static long count;
+	if (panic_blink)
+		panic_blink(count++);
+	blink_timer.expires = jiffies + msecs_to_jiffies(1);
+	add_timer(&blink_timer);
+}
+
+static int blink_init(void)
+{
+	printk(KERN_INFO "Enabling keyboard blinking\n");
+	do_blink(0);
+	return 0;
+}
+
+module_init(blink_init);
+
_

Patches currently in -mm which might be from ak@novell.com are

origin.patch
