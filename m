From: akpm@linux-foundation.org
Subject: + char-rocket-dont-re-set-statics-to-0.patch added to -mm tree
Date: Mon, 15 Oct 2007 16:20:50 -0700
Message-ID: <200710152320.l9FNKouS030521@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38020 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751385AbXJOXUx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 15 Oct 2007 19:20:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jirislaby@gmail.com


The patch titled
     Char: rocket, don't re-set statics to 0
has been added to the -mm tree.  Its filename is
     char-rocket-dont-re-set-statics-to-0.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Char: rocket, don't re-set statics to 0
From: Jiri Slaby <jirislaby@gmail.com>

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/rocket.c |   12 ------------
 1 file changed, 12 deletions(-)

diff -puN drivers/char/rocket.c~char-rocket-dont-re-set-statics-to-0 drivers/char/rocket.c
--- a/drivers/char/rocket.c~char-rocket-dont-re-set-statics-to-0
+++ a/drivers/char/rocket.c
@@ -2376,18 +2376,6 @@ static int __init rp_init(void)
 		return -ENOMEM;
 
 	/*
-	 * Initialize the array of pointers to our own internal state
-	 * structures.
-	 */
-	memset(rp_table, 0, sizeof (rp_table));
-	memset(xmit_flags, 0, sizeof (xmit_flags));
-
-	for (i = 0; i < MAX_RP_PORTS; i++)
-		lineNumbers[i] = 0;
-	nextLineNumber = 0;
-	memset(rocketModel, 0, sizeof (rocketModel));
-
-	/*
 	 *  If board 1 is non-zero, there is at least one ISA configured.  If controller is 
 	 *  zero, use the default controller IO address of board1 + 0x40.
 	 */
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
