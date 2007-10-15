From: akpm@linux-foundation.org
Subject: + char-rocket-fix-dynamic_dev-tty.patch added to -mm tree
Date: Mon, 15 Oct 2007 16:20:47 -0700
Message-ID: <200710152320.l9FNKlW0030518@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57418 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751865AbXJOXVF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 15 Oct 2007 19:21:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jirislaby@gmail.com, wferi@niif.hu


The patch titled
     Char: rocket, fix dynamic_dev tty
has been added to the -mm tree.  Its filename is
     char-rocket-fix-dynamic_dev-tty.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Char: rocket, fix dynamic_dev tty
From: Jiri Slaby <jirislaby@gmail.com>

- register_device unconditionally (non-pci dependent) to have also isa
  devices in /dev
- unregister devices on module removal
- don't set TTY_DRIVER_DYNAMIC_DEV twice (removed the one dependent on some
  macro)

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: Ferenc Wagner <wferi@niif.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/rocket.c |   14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff -puN drivers/char/rocket.c~char-rocket-fix-dynamic_dev-tty drivers/char/rocket.c
--- a/drivers/char/rocket.c~char-rocket-fix-dynamic_dev-tty
+++ a/drivers/char/rocket.c
@@ -700,8 +700,8 @@ static void init_r_port(int board, int a
 	spin_lock_init(&info->slock);
 	mutex_init(&info->write_mtx);
 	rp_table[line] = info;
-	if (pci_dev)
-		tty_register_device(rocket_driver, line, &pci_dev->dev);
+	tty_register_device(rocket_driver, line, pci_dev ? &pci_dev->dev :
+			NULL);
 }
 
 /*
@@ -2438,7 +2438,7 @@ static int __init rp_init(void)
 	rocket_driver->init_termios.c_ispeed = 9600;
 	rocket_driver->init_termios.c_ospeed = 9600;
 #ifdef ROCKET_SOFT_FLOW
-	rocket_driver->flags |= TTY_DRIVER_REAL_RAW | TTY_DRIVER_DYNAMIC_DEV;
+	rocket_driver->flags |= TTY_DRIVER_REAL_RAW;
 #endif
 	tty_set_operations(rocket_driver, &rocket_ops);
 
@@ -2495,10 +2495,14 @@ static void rp_cleanup_module(void)
 	if (retval)
 		printk(KERN_INFO "Error %d while trying to unregister "
 		       "rocketport driver\n", -retval);
-	put_tty_driver(rocket_driver);
 
 	for (i = 0; i < MAX_RP_PORTS; i++)
-		kfree(rp_table[i]);
+		if (rp_table[i]) {
+			tty_unregister_device(rocket_driver, i);
+			kfree(rp_table[i]);
+		}
+
+	put_tty_driver(rocket_driver);
 
 	for (i = 0; i < NUM_BOARDS; i++) {
 		if (rcktpt_io_addr[i] <= 0 || is_PCI[i])
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
