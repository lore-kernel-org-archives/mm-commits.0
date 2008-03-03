From: akpm@linux-foundation.org
Subject: + input-add-i2c-to-config-since-the-driver-makes-several-i2c-calls.patch added to -mm tree
Date: Mon, 03 Mar 2008 14:03:31 -0800
Message-ID: <200803032203.m23M3V6L008943@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39534 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751635AbYCCWFC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 3 Mar 2008 17:05:02 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com


The patch titled
     input: add I2C to config since the driver makes several i2c*() calls
has been added to the -mm tree.  Its filename is
     input-add-i2c-to-config-since-the-driver-makes-several-i2c-calls.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: input: add I2C to config since the driver makes several i2c*() calls
From: Randy Dunlap <randy.dunlap@oracle.com>

Add to help text that the Intel I2C ICH (i801) driver is also needed
for this kernel.

Add LEDS_CLASS to config since the driver makes les_classdev_*() calls:
ERROR: "led_classdev_register" [drivers/input/misc/apanel.ko] undefined!
ERROR: "__led_classdev_unregister" [drivers/input/misc/apanel.ko]
undefined!

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/input/misc/Kconfig |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN drivers/input/misc/Kconfig~input-add-i2c-to-config-since-the-driver-makes-several-i2c-calls drivers/input/misc/Kconfig
--- a/drivers/input/misc/Kconfig~input-add-i2c-to-config-since-the-driver-makes-several-i2c-calls
+++ a/drivers/input/misc/Kconfig
@@ -42,14 +42,14 @@ config INPUT_M68K_BEEP
 
 config INPUT_APANEL
 	tristate "Fujitsu Lifebook Application Panel buttons"
-	depends on X86
-	select I2C_I801
+	depends on X86 && I2C && LEDS_CLASS
 	select INPUT_POLLDEV
 	select CHECK_SIGNATURE
 	help
 	 Say Y here for support of the Application Panel buttons, used on
 	 Fujitsu Lifebook. These are attached to the mainboard through
-	 an SMBus interface managed by the I2C Intel ICH (i801) driver.
+	 an SMBus interface managed by the I2C Intel ICH (i801) driver,
+	 which you should also build for this kernel.
 
 	 To compile this driver as a module, choose M here: the module will
 	 be called apanel.
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
git-acpi.patch
input-add-i2c-to-config-since-the-driver-makes-several-i2c-calls.patch
e1000e-make-e1000e-default-to-the-same-kconfig-setting-as-e1000.patch
git-unionfs.patch
wireless-rt2x00-fix-driver-menu-indenting.patch
kprobes-move-kprobe-examples-to-samples.patch
x86-visws-fix-printk-format-warnings.patch
apanel-fix-kconfig-dependencies.patch
let-log_buf_shift-default-to-17.patch
documentation-move-spidev_fdx-example-to-its-own-source-file.patch
profile-likely-unlikely-macros.patch

