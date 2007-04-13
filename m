From: akpm@linux-foundation.org
Subject: + add-keyboard-blink-driver.patch added to -mm tree
Date: Fri, 13 Apr 2007 12:24:25 -0700
Message-ID: <200704131924.l3DJOPc7007515@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:47319 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932189AbXDMTYe (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 13 Apr 2007 15:24:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ak@novell.com, ak@suse.de


The patch titled
     Add keyboard blink driver
has been added to the -mm tree.  Its filename is
     add-keyboard-blink-driver.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
@@ -175,4 +175,13 @@ config EEPROM_93CX6
 
 	  When compiled as a module, this driver will be called "eeprom_93c6.ko".
 
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
@@ -14,3 +14,4 @@ obj-$(CONFIG_TIFM_7XX1)       	+= tifm_7
 obj-$(CONFIG_SGI_IOC4)		+= ioc4.o
 obj-$(CONFIG_SONY_LAPTOP)	+= sony-laptop.o
 obj-$(CONFIG_THINKPAD_ACPI)	+= thinkpad_acpi.o
+obj-$(CONFIG_BLINK)		+= blink.o
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

add-keyboard-blink-driver.patch
