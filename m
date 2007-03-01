From: akpm@linux-foundation.org
Subject: + git-leds-make-it-compile.patch added to -mm tree
Date: Wed, 28 Feb 2007 18:25:53 -0800
Message-ID: <200703010227.l212RQPn001807@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:52191 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932503AbXCAC1i (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 28 Feb 2007 21:27:38 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, raph@8d.com, rpurdie@rpsys.net


The patch titled
     git-leds: make it compile
has been added to the -mm tree.  Its filename is
     git-leds-make-it-compile.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: git-leds: make it compile
From: Andrew Morton <akpm@linux-foundation.org>

x86_64 allmodconfig:

drivers/leds/leds-gpio.c:16:22: error: asm/gpio.h: No such file or directory
drivers/leds/leds-gpio.c: In function 'gpio_led_set':
drivers/leds/leds-gpio.c:40: warning: implicit declaration of function 'gpio_set_value'
drivers/leds/leds-gpio.c: In function 'gpio_led_probe':
drivers/leds/leds-gpio.c:68: warning: implicit declaration of function 'gpio_request'
drivers/leds/leds-gpio.c:72: warning: implicit declaration of function 'gpio_direction_output'
drivers/leds/leds-gpio.c:74: warning: implicit declaration of function 'gpio_get_value'
drivers/leds/leds-gpio.c:82: warning: implicit declaration of function 'gpio_free'

Cc: Raphael Assenat <raph@8d.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/leds/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/leds/Kconfig~git-leds-make-it-compile drivers/leds/Kconfig
--- a/drivers/leds/Kconfig~git-leds-make-it-compile
+++ a/drivers/leds/Kconfig
@@ -96,7 +96,7 @@ config LEDS_COBALT
 
 config LEDS_GPIO
 	tristate "LED Support for GPIO connected LEDs"
-	depends on LEDS_CLASS 
+	depends on LEDS_CLASS && BROKEN
 	help
 	  This option enables support for the LEDs connected to GPIO
 	  outputs. To be useful the particular board must have LEDs 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

make-aout-executables-work-again-fix.patch
sony-laptop-fix-uninitialised-variable.patch
git-drm.patch
git-dvb.patch
pvrusb-warning-fix.patch
git-input.patch
setstream-param-for-psmouse-tweak.patch
git-leds-fixup.patch
git-leds-make-it-compile.patch
git-md-accel-vs-md.patch
nommu-present-backing-device-capabilities-for-mtd-fix.patch
git-ubi.patch
git-netdev-all.patch
revert-drivers-net-tulip-dmfe-support-basic-carrier-detection.patch
dmfe-add-support-for-suspend-resume-fix.patch
sis900-warning-fixes.patch
rm9000-serial-driver-tidy.patch
git-pciseg.patch
revert-md-avoid-possible-bug_on-in-md-bitmap-handling-for-git-block.patch
git-block-fixup.patch
git-block-another-md-fix.patch
git-unionfs.patch
usbatm-create-sysfs-link-device-from-atm-class-device-tidy.patch
after-before-x86_64-mm-mmconfig-share.patch
throttle_vm_writeout-dont-loop-on-gfp_nofs-and-gfp_noio-allocations.patch
ext-ea-block-reference-count-racing-fix-fix.patch
smaps-add-clear_refs-file-to-clear-reference-fix.patch
kvm-add-internal-filesystem-for-generating-inodes-tweak.patch
fix-rmmod-read-write-races-in-proc-entries-fix.patch
reduce-size-of-task_struct-on-64-bit-machines.patch
mm-shrink-parent-dentries-when-shrinking-slab.patch
call-cpu_chain-with-cpu_down_failed-if-cpu_down_prepare-failed-vs-reduce-size-of-task_struct-on-64-bit-machines.patch
lutimesat-compat-syscall-and-wire-up-on-x86_64-tidy.patch
utrace-prep.patch
utrace-vs-reduce-size-of-task_struct-on-64-bit-machines.patch
local_t-mips-extension-shrink-duplicated-mips-32-64-bits-functions-from-localh-fix.patch
linux-kernel-markers-kconfig-menus-fix-4.patch
