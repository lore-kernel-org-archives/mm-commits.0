From: akpm@linux-foundation.org
Subject: - char-moxa-remove-sleep_on.patch removed from -mm tree
Date: Thu, 18 Oct 2007 20:44:30 -0700
Message-ID: <200710190344.l9J3iUTp013149@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45078 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934301AbXJSDze (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Oct 2007 23:55:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jirislaby@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Char: moxa, remove sleep_on
has been removed from the -mm tree.  Its filename was
     char-moxa-remove-sleep_on.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Char: moxa, remove sleep_on
From: Jiri Slaby <jirislaby@gmail.com>

interruptible_sleep_on is deprecated, use completion instead

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/moxa.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff -puN drivers/char/moxa.c~char-moxa-remove-sleep_on drivers/char/moxa.c
--- a/drivers/char/moxa.c~char-moxa-remove-sleep_on
+++ a/drivers/char/moxa.c
@@ -41,6 +41,7 @@
 #include <linux/pci.h>
 #include <linux/init.h>
 #include <linux/bitops.h>
+#include <linux/completion.h>
 
 #include <asm/system.h>
 #include <asm/io.h>
@@ -142,7 +143,7 @@ struct moxa_port {
 	struct tty_struct *tty;
 	int cflag;
 	wait_queue_head_t open_wait;
-	wait_queue_head_t close_wait;
+	struct completion close_wait;
 
 	struct timer_list emptyTimer;
 
@@ -374,7 +375,7 @@ static int __init moxa_init(void)
 		ch->closing_wait = 30 * HZ;
 		ch->cflag = B9600 | CS8 | CREAD | CLOCAL | HUPCL;
 		init_waitqueue_head(&ch->open_wait);
-		init_waitqueue_head(&ch->close_wait);
+		init_completion(&ch->close_wait);
 
 		setup_timer(&ch->emptyTimer, moxa_check_xmit_empty,
 				(unsigned long)ch);
@@ -577,7 +578,7 @@ static void moxa_close(struct tty_struct
 		wake_up_interruptible(&ch->open_wait);
 	}
 	ch->asyncflags &= ~(ASYNC_NORMAL_ACTIVE | ASYNC_CLOSING);
-	wake_up_interruptible(&ch->close_wait);
+	complete_all(&ch->close_wait);
 }
 
 static int moxa_write(struct tty_struct *tty,
@@ -941,7 +942,7 @@ static int moxa_block_till_ready(struct 
 	 */
 	if (tty_hung_up_p(filp) || (ch->asyncflags & ASYNC_CLOSING)) {
 		if (ch->asyncflags & ASYNC_CLOSING)
-			interruptible_sleep_on(&ch->close_wait);
+			wait_for_completion_interruptible(&ch->close_wait);
 #ifdef SERIAL_DO_RESTART
 		if (ch->asyncflags & ASYNC_HUP_NOTIFY)
 			return (-EAGAIN);
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
