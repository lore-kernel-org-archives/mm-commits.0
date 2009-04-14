From: akpm@linux-foundation.org
Subject: [merged] input-introduce-a-tougher-i8042reset.patch removed from -mm tree
Date: Tue, 14 Apr 2009 12:50:54 -0700
Message-ID: <200904141950.n3EJosaa020399@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51616 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753861AbZDNTx2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 14 Apr 2009 15:53:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: arjan@linux.intel.com, dtor@mail.ru, mm-commits@vger.kernel.org


The patch titled
     input: introduce a tougher i8042.reset
has been removed from the -mm tree.  Its filename was
     input-introduce-a-tougher-i8042reset.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: input: introduce a tougher i8042.reset
From: Arjan van de Ven <arjan@linux.intel.com>

Some touchpads don't reset right the first time (MSI Wind U-100 for
example).  This patch will retry the reset up to 5 times.

In addition, this patch also adds a module parameter to not treat reset
failures as fatal to the usage of the device.  This prevents a touchpad
failure from also disabling the keyboard.

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
Cc: Dmitry Torokhov <dtor@mail.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/kernel-parameters.txt |    2 +
 drivers/input/serio/i8042.c         |   33 ++++++++++++++++++--------
 2 files changed, 26 insertions(+), 9 deletions(-)

diff -puN Documentation/kernel-parameters.txt~input-introduce-a-tougher-i8042reset Documentation/kernel-parameters.txt
--- a/Documentation/kernel-parameters.txt~input-introduce-a-tougher-i8042reset
+++ a/Documentation/kernel-parameters.txt
@@ -889,6 +889,8 @@ and is between 256 and 4096 characters. 
 			[HW] Frequency with which keyboard LEDs should blink
 			     when kernel panics (default is 0.5 sec)
 	i8042.reset	[HW] Reset the controller during init and cleanup
+	i8042.nonfatal  [HW] Don't treat i8042.reset failures as fatal for the
+			     device initialization.
 	i8042.unlock	[HW] Unlock (ignore) the keylock
 
 	i810=		[HW,DRM]
diff -puN drivers/input/serio/i8042.c~input-introduce-a-tougher-i8042reset drivers/input/serio/i8042.c
--- a/drivers/input/serio/i8042.c~input-introduce-a-tougher-i8042reset
+++ a/drivers/input/serio/i8042.c
@@ -47,6 +47,10 @@ static unsigned int i8042_reset;
 module_param_named(reset, i8042_reset, bool, 0);
 MODULE_PARM_DESC(reset, "Reset controller during init and cleanup.");
 
+static unsigned int i8042_nonfatal;
+module_param_named(nonfatal, i8042_nonfatal, bool, 0);
+MODULE_PARM_DESC(reset, "Treat controller test failures as non-fatal.");
+
 static unsigned int i8042_direct;
 module_param_named(direct, i8042_direct, bool, 0);
 MODULE_PARM_DESC(direct, "Put keyboard port into non-translated mode.");
@@ -712,22 +716,33 @@ static int i8042_controller_check(void)
 static int i8042_controller_selftest(void)
 {
 	unsigned char param;
+	int i = 0;
 
 	if (!i8042_reset)
 		return 0;
 
-	if (i8042_command(&param, I8042_CMD_CTL_TEST)) {
-		printk(KERN_ERR "i8042.c: i8042 controller self test timeout.\n");
-		return -ENODEV;
-	}
+	/*
+	 * We try this 5 times; on some really fragile systems this does not
+	 * take the first time...
+	 */
+	do {
+
+		if (i8042_command(&param, I8042_CMD_CTL_TEST)) {
+			printk(KERN_ERR "i8042.c: i8042 controller self test timeout.\n");
+			return -ENODEV;
+		}
+
+		if (param == I8042_RET_CTL_TEST)
+			return 0;
 
-	if (param != I8042_RET_CTL_TEST) {
 		printk(KERN_ERR "i8042.c: i8042 controller selftest failed. (%#x != %#x)\n",
-			 param, I8042_RET_CTL_TEST);
-		return -EIO;
-	}
+			param, I8042_RET_CTL_TEST);
+		msleep(50);
+	} while (i++ < 5);
 
-	return 0;
+	if (i8042_nonfatal)
+		return 0;
+	return -EIO;
 }
 
 /*
_

Patches currently in -mm which might be from arjan@linux.intel.com are

origin.patch
linux-next.patch
input-add-a-dmi-table-for-the-i8042reset-option-make-msi-wind-u-100-work.patch
pci-use-pci_ioremap_bar-in-drivers-serial.patch

