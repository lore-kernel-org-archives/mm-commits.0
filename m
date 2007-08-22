From: akpm@linux-foundation.org
Subject: + char-moxa-remove-sleep_on.patch added to -mm tree
Date: Wed, 22 Aug 2007 16:10:50 -0700
Message-ID: <200708222310.l7MNAoDG009688@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37107 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933003AbXHVXL1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 22 Aug 2007 19:11:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jirislaby@gmail.com


The patch titled
     Char: moxa, remove sleep_on
has been added to the -mm tree.  Its filename is
     char-moxa-remove-sleep_on.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Char: moxa, remove sleep_on
From: Jiri Slaby <jirislaby@gmail.com>

interruptible_sleep_on is deprecated, use completion instead

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/moxa.c |    9 +++++----
 1 files changed, 5 insertions(+), 4 deletions(-)

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

net-add-ath5k-wireless-driver.patch
net-add-ath5k-wireless-driver-fix.patch
ath5k-printk-fix.patch
ath5k-kconfig-fix.patch
ath5k-needs-pci.patch
epcac-reformat-comments-and-coding-style-improvements.patch
char-mxser_new-upgrade-to-110.patch
char-mxser_new-move-to-pci_vdevice.patch
char-mxser_new-remove-useless-comments-in-mxser_cards.patch
char-moxa-fix-and-optimise-empty-timer.patch
char-cyclades-remove-bottom-half-processing.patch
char-cyclades-make-the-isr-code-readable.patch
char-cyclades-move-spin_lock-to-one-place.patch
char-cyclades-fix-some-w-warnings.patch
char-moxa-cleanup-prints.patch
char-moxa-function-names-cleanup.patch
char-moxa-remove-sleep_on.patch
fs-select-remove-unused-macros.patch
cyber2000fb-rename-bit-macro.patch
i2c-pxa-rename-bit-macro-to-pxa_bit.patch
s2io-rename-bit-macro.patch
amba-pl011-rename-bit-macro.patch
define-first-set-of-bit-macros.patch
get-rid-of-input-bit-duplicate-defines.patch
define-global-bit-macro.patch
flashpoint-use-bit-instead-of-bitw.patch
shrink_slab-handle-bad-shrinkers.patch
