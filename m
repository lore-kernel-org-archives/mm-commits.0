From: akpm@linux-foundation.org
Subject: - char-mxser_new-less-loops-in-isr.patch removed from -mm tree
Date: Sun, 11 Feb 2007 14:52:02 -0800
Message-ID: <200702112252.l1BMq2qQ015981@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:60204 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932773AbXBKWwE (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 11 Feb 2007 17:52:04 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jirislaby@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Char: mxser_new, less loops in isr
has been removed from the -mm tree.  Its filename was
     char-mxser_new-less-loops-in-isr.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Char: mxser_new, less loops in isr
From: Jiri Slaby <jirislaby@gmail.com>

Loop only 100^2 times, not 99999^2 times in isr (at most).

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/mxser_new.c |    9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

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

origin.patch
char-use-more-pci_device-macro.patch
char-cyclades-use-pci_device_id.patch
maintainers-remove-two-dead-e-mail.patch
char-specialix-isr-have-2-params.patch
char-timers-cleanup.patch
fbdev-driver-for-s3-trio-virge-update-2-fix.patch
video-fb-add-true-ref_count-atomicity.patch
video-fb-kzalloc-changes.patch
shrink_slab-handle-bad-shrinkers.patch
