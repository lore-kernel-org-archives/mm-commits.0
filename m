From: akpm@linux-foundation.org
Subject: - char-rocket-dont-re-set-statics-to-0.patch removed from -mm tree
Date: Thu, 18 Oct 2007 20:44:37 -0700
Message-ID: <200710190344.l9J3ibQW013158@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41231 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S966071AbXJSDzb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Oct 2007 23:55:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jirislaby@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Char: rocket, don't re-set statics to 0
has been removed from the -mm tree.  Its filename was
     char-rocket-dont-re-set-statics-to-0.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
git-dvb.patch
v4l-stk11xx-add-a-new-webcam-driver.patch
v4l-stk11xx-use-array_size-in-another-2-cases.patch
v4l-stk11xx-use-retval-from-stk11xx_check_device.patch
v4l-stk11xx-add-static-to-tables.patch
git-wireless.patch
misc-phantom-synchronize_irq-on-suspend.patch
misc-phantom-add-comment-about-openhaptics.patch
misc-phantom-improved-data-passing.patch
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
