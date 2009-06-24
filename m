From: akpm@linux-foundation.org
Subject: + spi-bitbang-bugfix-in-message-setup.patch added to -mm tree
Date: Wed, 24 Jun 2009 15:59:09 -0700
Message-ID: <200906242259.n5OMx9rY028078@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35910 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752075AbZFXW70 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 24 Jun 2009 18:59:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dbrownell@users.sourceforge.net, sfalco@harris.com


The patch titled
     spi: bitbang bugfix in message setup
has been added to the -mm tree.  Its filename is
     spi-bitbang-bugfix-in-message-setup.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: spi: bitbang bugfix in message setup
From: David Brownell <dbrownell@users.sourceforge.net>

Bugfix to spi_bitbang infrastructure: make sure to always set transfer
parameters on the first pass through the message's per-transfer loop. 
This can matter with drivers that replace the per-word or per-buffer
transfer primitives, on busses with multiple SPI devices.

Previously, this could have started messages using the settings left after
previous messages.  The problem was observed when a high speed chip
(m25p80 type flash) was running very slowly because a low speed device
(avr8 microcontroller) had previously used the bus.  Similar faults could
have driven the low speed device too fast, or used an unexpected word
size.

Acked-by: Steven A. Falco <sfalco@harris.com>
Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/spi/spi_bitbang.c |   24 ++++++++++++++----------
 1 file changed, 14 insertions(+), 10 deletions(-)

diff -puN drivers/spi/spi_bitbang.c~spi-bitbang-bugfix-in-message-setup drivers/spi/spi_bitbang.c
--- a/drivers/spi/spi_bitbang.c~spi-bitbang-bugfix-in-message-setup
+++ a/drivers/spi/spi_bitbang.c
@@ -258,6 +258,11 @@ static void bitbang_work(struct work_str
 	struct spi_bitbang	*bitbang =
 		container_of(work, struct spi_bitbang, work);
 	unsigned long		flags;
+	int			do_setup = -1;
+	int			(*setup_transfer)(struct spi_device *,
+					struct spi_transfer *);
+
+	setup_transfer = bitbang->setup_transfer;
 
 	spin_lock_irqsave(&bitbang->lock, flags);
 	bitbang->busy = 1;
@@ -269,8 +274,6 @@ static void bitbang_work(struct work_str
 		unsigned		tmp;
 		unsigned		cs_change;
 		int			status;
-		int			(*setup_transfer)(struct spi_device *,
-						struct spi_transfer *);
 
 		m = container_of(bitbang->queue.next, struct spi_message,
 				queue);
@@ -287,19 +290,19 @@ static void bitbang_work(struct work_str
 		tmp = 0;
 		cs_change = 1;
 		status = 0;
-		setup_transfer = NULL;
 
 		list_for_each_entry (t, &m->transfers, transfer_list) {
 
-			/* override or restore speed and wordsize */
-			if (t->speed_hz || t->bits_per_word) {
-				setup_transfer = bitbang->setup_transfer;
+			/* override speed or wordsize? */
+			if (t->speed_hz || t->bits_per_word)
+				do_setup = 1;
+
+			/* init (-1) or override (1) transfer params */
+			if (do_setup != 0) {
 				if (!setup_transfer) {
 					status = -ENOPROTOOPT;
 					break;
 				}
-			}
-			if (setup_transfer) {
 				status = setup_transfer(spi, t);
 				if (status < 0)
 					break;
@@ -363,9 +366,10 @@ static void bitbang_work(struct work_str
 		m->status = status;
 		m->complete(m->context);
 
-		/* restore speed and wordsize */
-		if (setup_transfer)
+		/* restore speed and wordsize if it was overridden */
+		if (do_setup == 1)
 			setup_transfer(spi, NULL);
+		do_setup = 0;
 
 		/* normally deactivate chipselect ... unless no error and
 		 * cs_change has hinted that the next message will probably
_

Patches currently in -mm which might be from dbrownell@users.sourceforge.net are

origin.patch
spi-new-spi-mode-bits.patch
spi-add-spi_master-flag-word.patch
spi-bitbang-bugfix-in-message-setup.patch

