From: akpm@linux-foundation.org
Subject: + char-rocket-switch-sleep_on-to-completion.patch added to -mm tree
Date: Mon, 15 Oct 2007 16:05:27 -0700
Message-ID: <200710152305.l9FN5RFL029915@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39727 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758780AbXJOXFa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 15 Oct 2007 19:05:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jirislaby@gmail.com


The patch titled
     Char: rocket, switch sleep_on to completion
has been added to the -mm tree.  Its filename is
     char-rocket-switch-sleep_on-to-completion.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Char: rocket, switch sleep_on to completion
From: Jiri Slaby <jirislaby@gmail.com>

rocket, switch sleep_on to completion

- sleep_on is deprecated and racy, use completion instead
- also check retval of interruptible function and return ERESTARTSYS
  eventually

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/rocket.c     |   12 ++++++++----
 drivers/char/rocket_int.h |    7 +------
 2 files changed, 9 insertions(+), 10 deletions(-)

diff -puN drivers/char/rocket.c~char-rocket-switch-sleep_on-to-completion drivers/char/rocket.c
--- a/drivers/char/rocket.c~char-rocket-switch-sleep_on-to-completion
+++ a/drivers/char/rocket.c
@@ -84,6 +84,7 @@
 #include <linux/mutex.h>
 #include <linux/ioport.h>
 #include <linux/delay.h>
+#include <linux/completion.h>
 #include <linux/wait.h>
 #include <linux/pci.h>
 #include <asm/uaccess.h>
@@ -650,7 +651,7 @@ static void init_r_port(int board, int a
 	info->closing_wait = 3000;
 	info->close_delay = 50;
 	init_waitqueue_head(&info->open_wait);
-	init_waitqueue_head(&info->close_wait);
+	init_completion(&info->close_wait);
 	info->flags &= ~ROCKET_MODE_MASK;
 	switch (pc104[board][line]) {
 	case 422:
@@ -878,7 +879,8 @@ static int block_til_ready(struct tty_st
 	if (tty_hung_up_p(filp))
 		return ((info->flags & ROCKET_HUP_NOTIFY) ? -EAGAIN : -ERESTARTSYS);
 	if (info->flags & ROCKET_CLOSING) {
-		interruptible_sleep_on(&info->close_wait);
+		if (wait_for_completion_interruptible(&info->close_wait))
+			return -ERESTARTSYS;
 		return ((info->flags & ROCKET_HUP_NOTIFY) ? -EAGAIN : -ERESTARTSYS);
 	}
 
@@ -983,8 +985,10 @@ static int rp_open(struct tty_struct *tt
 		return -ENOMEM;
 
 	if (info->flags & ROCKET_CLOSING) {
-		interruptible_sleep_on(&info->close_wait);
+		retval = wait_for_completion_interruptible(&info->close_wait);
 		free_page(page);
+		if (retval)
+			return retval;
 		return ((info->flags & ROCKET_HUP_NOTIFY) ? -EAGAIN : -ERESTARTSYS);
 	}
 
@@ -1176,7 +1180,7 @@ static void rp_close(struct tty_struct *
 	}
 	info->flags &= ~(ROCKET_INITIALIZED | ROCKET_CLOSING | ROCKET_NORMAL_ACTIVE);
 	tty->closing = 0;
-	wake_up_interruptible(&info->close_wait);
+	complete_all(&info->close_wait);
 	atomic_dec(&rp_num_ports_open);
 
 #ifdef ROCKET_DEBUG_OPEN
diff -puN drivers/char/rocket_int.h~char-rocket-switch-sleep_on-to-completion drivers/char/rocket_int.h
--- a/drivers/char/rocket_int.h~char-rocket-switch-sleep_on-to-completion
+++ a/drivers/char/rocket_int.h
@@ -1163,13 +1163,8 @@ struct r_port {
 	int read_status_mask;
 	int cps;
 
-#ifdef DECLARE_WAITQUEUE
 	wait_queue_head_t open_wait;
-	wait_queue_head_t close_wait;
-#else
-	struct wait_queue *open_wait;
-	struct wait_queue *close_wait;
-#endif
+	struct completion close_wait;
 	spinlock_t slock;
 	struct mutex write_mtx;
 };
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
