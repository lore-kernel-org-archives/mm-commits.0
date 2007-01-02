From: akpm@osdl.org
Subject: + char-mxser_new-less-loops-in-isr.patch added to -mm tree
Date: Tue, 02 Jan 2007 13:11:22 -0800
Message-ID: <200701022111.l02LBMUT029787@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:60849 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754922AbXABVLa (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 2 Jan 2007 16:11:30 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jirislaby@gmail.com


The patch titled
     Char: mxser_new, less loops in isr
has been added to the -mm tree.  Its filename is
     char-mxser_new-less-loops-in-isr.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Char: mxser_new, less loops in isr
From: Jiri Slaby <jirislaby@gmail.com>

Loop only 100^2 times, not 99999^2 times in isr (at most).

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/char/mxser_new.c |    9 +++------
 1 files changed, 3 insertions(+), 6 deletions(-)

diff -puN drivers/char/mxser_new.c~char-mxser_new-less-loops-in-isr drivers/char/mxser_new.c
--- a/drivers/char/mxser_new.c~char-mxser_new-less-loops-in-isr
+++ a/drivers/char/mxser_new.c
@@ -56,7 +56,7 @@
 #define MXSER_BOARDS		4	/* Max. boards */
 #define MXSER_PORTS_PER_BOARD	8	/* Max. ports per board */
 #define MXSER_PORTS		(MXSER_BOARDS * MXSER_PORTS_PER_BOARD)
-#define MXSER_ISR_PASS_LIMIT	99999L
+#define MXSER_ISR_PASS_LIMIT	100
 
 #define	MXSER_ERR_IOADDR	-1
 #define	MXSER_ERR_IRQ		-2
@@ -2222,8 +2222,7 @@ static irqreturn_t mxser_interrupt(int i
 	struct mxser_board *brd = NULL;
 	struct mxser_port *port;
 	int max, irqbits, bits, msr;
-	int pass_counter = 0;
-	unsigned int int_cnt;
+	unsigned int int_cnt, pass_counter = 0;
 	int handled = IRQ_NONE;
 
 	for (i = 0; i < MXSER_BOARDS; i++)
@@ -2237,7 +2236,7 @@ static irqreturn_t mxser_interrupt(int i
 	if (brd == NULL)
 		goto irq_stop;
 	max = brd->info->nports;
-	while (1) {
+	while (pass_counter++ < MXSER_ISR_PASS_LIMIT) {
 		irqbits = inb(brd->vector) & brd->vector_mask;
 		if (irqbits == brd->vector_mask)
 			break;
@@ -2308,8 +2307,6 @@ static irqreturn_t mxser_interrupt(int i
 			} while (int_cnt++ < MXSER_ISR_PASS_LIMIT);
 			spin_unlock(&port->slock);
 		}
-		if (pass_counter++ > MXSER_ISR_PASS_LIMIT)
-			break;	/* Prevent infinite loops */
 	}
 
 irq_stop:
_

Patches currently in -mm which might be from jirislaby@gmail.com are

git-input.patch
char-tty-delete-wake_up_interruptible-after-tty_wakeup.patch
char-isicom-remove-tty_hangwakeup-bottomhalves.patch
mxser-remove-ambiguous-redefinition-of-init_work.patch
make-drivers-char-mxser_newcmxser_hangup-static.patch
char-isicom-fix-locking-in-isr.patch
char-isicom-augment-card_reset.patch
char-isicom-check-card-state-in-isr.patch
char-isicom-support-higher-rates.patch
char-isicom-correct-probing-removing.patch
char-tty_wakeup-cleanup.patch
char-mxser_new-mark-init-functions.patch
char-mxser_new-remove-useless-spinlock.patch
char-serial167-cleanup.patch
char-n_r3964-cleanup.patch
char-mxser_new-remove-unused-stuff.patch
char-mxser-obsolete-old-nonexperimental-new.patch
char-mxser_new-remove-tty_wakeup-bottomhalf.patch
char-mxser_new-clean-request_irq-call.patch
doc-isicom-remove-reserved-ioctl-number.patch
char-mxser_new-alter-locking-in-isr.patch
char-mxser_new-header-file-cleanup.patch
char-mxser_new-less-loops-in-isr.patch
char-mxser_new-fix-twice-resource-releasing.patch
shrink_slab-handle-bad-shrinkers.patch
