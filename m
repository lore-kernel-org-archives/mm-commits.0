From: akpm@linux-foundation.org
Subject: + char-rocket-remove-potential-leak-in-module_init.patch added to -mm tree
Date: Mon, 15 Oct 2007 16:20:55 -0700
Message-ID: <200710152320.l9FNKtek030527@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56553 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752868AbXJOXVJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 15 Oct 2007 19:21:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jirislaby@gmail.com


The patch titled
     Char: rocket, remove potential leak in module_init
has been added to the -mm tree.  Its filename is
     char-rocket-remove-potential-leak-in-module_init.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Char: rocket, remove potential leak in module_init
From: Jiri Slaby <jirislaby@gmail.com>

if (controller && !request_region) then we leaked a tty driver struct, fix it
by adding function deinit tail with goto-ing into it (and from other fail
paths too)

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/rocket.c |   34 ++++++++++++++++++++--------------
 1 file changed, 20 insertions(+), 14 deletions(-)

diff -puN drivers/char/rocket.c~char-rocket-remove-potential-leak-in-module_init drivers/char/rocket.c
--- a/drivers/char/rocket.c~char-rocket-remove-potential-leak-in-module_init
+++ a/drivers/char/rocket.c
@@ -2359,14 +2359,14 @@ static const struct tty_operations rocke
  */
 static int __init rp_init(void)
 {
-	int retval, pci_boards_found, isa_boards_found, i;
+	int ret = -ENOMEM, pci_boards_found, isa_boards_found, i;
 
 	printk(KERN_INFO "RocketPort device driver module, version %s, %s\n",
 	       ROCKET_VERSION, ROCKET_DATE);
 
 	rocket_driver = alloc_tty_driver(MAX_RP_PORTS);
 	if (!rocket_driver)
-		return -ENOMEM;
+		goto err;
 
 	/*
 	 *  If board 1 is non-zero, there is at least one ISA configured.  If controller is 
@@ -2381,8 +2381,11 @@ static int __init rp_init(void)
 
 	/*  If an ISA card is configured, reserve the 4 byte IO space for the Mudbac controller */
 	if (controller && (!request_region(controller, 4, "Comtrol RocketPort"))) {
-		printk(KERN_INFO "Unable to reserve IO region for first configured ISA RocketPort controller 0x%lx.  Driver exiting \n", controller);
-		return -EBUSY;
+		printk(KERN_ERR "Unable to reserve IO region for first "
+			"configured ISA RocketPort controller 0x%lx.  "
+			"Driver exiting\n", controller);
+		ret = -EBUSY;
+		goto err_tty;
 	}
 
 	/*  Store ISA variable retrieved from command line or .conf file. */
@@ -2423,11 +2426,10 @@ static int __init rp_init(void)
 #endif
 	tty_set_operations(rocket_driver, &rocket_ops);
 
-	retval = tty_register_driver(rocket_driver);
-	if (retval < 0) {
-		printk(KERN_INFO "Couldn't install tty RocketPort driver (error %d)\n", -retval);
-		put_tty_driver(rocket_driver);
-		return -1;
+	ret = tty_register_driver(rocket_driver);
+	if (ret < 0) {
+		printk(KERN_ERR "Couldn't install tty RocketPort driver\n");
+		goto err_tty;
 	}
 
 #ifdef ROCKET_DEBUG_OPEN
@@ -2454,14 +2456,18 @@ static int __init rp_init(void)
 	max_board = pci_boards_found + isa_boards_found;
 
 	if (max_board == 0) {
-		printk(KERN_INFO "No rocketport ports found; unloading driver.\n");
-		del_timer_sync(&rocket_timer);
-		tty_unregister_driver(rocket_driver);
-		put_tty_driver(rocket_driver);
-		return -ENXIO;
+		printk(KERN_ERR "No rocketport ports found; unloading driver\n");
+		ret = -ENXIO;
+		goto err_ttyu;
 	}
 
 	return 0;
+err_ttyu:
+	tty_unregister_driver(rocket_driver);
+err_tty:
+	put_tty_driver(rocket_driver);
+err:
+	return ret;
 }
 
 
_

Patches currently in -mm which might be from jirislaby@gmail.com are

origin.patch
v4l-stk11xx-add-a-new-webcam-driver.patch
v4l-stk11xx-use-array_size-in-another-2-cases.patch
v4l-stk11xx-use-retval-from-stk11xx_check_device.patch
v4l-stk11xx-add-static-to-tables.patch
git-wireless.patch
git-wireless-ath5k-broke.patch
epcac-reformat-comments-and-coding-style-improvements.patch
char-mxser_new-upgrade-to-110.patch
char-mxser_new-move-to-pci_vdevice.patch
char-mxser_new-remove-useless-comments-in-mxser_cards.patch
mxser-remove-commented-crap.patch
mxser-fix-compiler-warning-when-building-withoug-config_pci.patch
mxser-fix-compiler-warning-when-building-withoug-config_pci-fix.patch
char-moxa-fix-and-optimise-empty-timer.patch
char-cyclades-remove-bottom-half-processing.patch
char-cyclades-make-the-isr-code-readable.patch
char-cyclades-move-spin_lock-to-one-place.patch
char-cyclades-fix-some-w-warnings.patch
cyclades-avoid-label-defined-but-not-used-warning.patch
char-moxa-cleanup-prints.patch
char-moxa-function-names-cleanup.patch
char-moxa-remove-sleep_on.patch
char-rocket-switch-sleep_on-to-completion.patch
char-rocket-fix-dynamic_dev-tty.patch
char-rocket-dont-re-set-statics-to-0.patch
char-rocket-remove-pci_read_config_dwordclass_revision.patch
char-rocket-remove-potential-leak-in-module_init.patch
char-rocket-fix-signed-unsigned-warning.patch
fs-select-remove-unused-macros.patch
remove-asm-bitopsh-includes.patch
forbid-asm-bitopsh-direct-inclusion.patch
cyber2000fb-rename-bit-macro.patch
i2c-pxa-rename-bit-macro-to-pxa_bit.patch
s2io-rename-bit-macro.patch
amba-pl011-rename-bit-macro.patch
define-first-set-of-bit-macros.patch
get-rid-of-input-bit-duplicate-defines.patch
define-global-bit-macro.patch
flashpoint-use-bit-instead-of-bitw.patch
remove-bits_to_type-macro.patch
remove-bits_to_type-macro-fix.patch
remove-asm-bitopsh-includes-reiser4.patch
shrink_slab-handle-bad-shrinkers.patch
