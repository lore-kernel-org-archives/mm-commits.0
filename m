From: akpm@linux-foundation.org
Subject: + char-cyclades-allow-debug_shirq.patch added to -mm tree
Date: Thu, 19 Apr 2007 21:54:11 -0700
Message-ID: <200704200454.l3K4sBuL007173@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:35237 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1422856AbXDTEyO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 20 Apr 2007 00:54:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jirislaby@gmail.com


The patch titled
     Char: cyclades, allow DEBUG_SHIRQ
has been added to the -mm tree.  Its filename is
     char-cyclades-allow-debug_shirq.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Char: cyclades, allow DEBUG_SHIRQ
From: Jiri Slaby <jirislaby@gmail.com>

Test if base addr is non-null in ISR to prove the card has been correctly
initialized.  This is needed for DEBUG_SHIRQ for example.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/cyclades.c |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN drivers/char/cyclades.c~char-cyclades-allow-debug_shirq drivers/char/cyclades.c
--- a/drivers/char/cyclades.c~char-cyclades-allow-debug_shirq
+++ a/drivers/char/cyclades.c
@@ -1444,6 +1444,10 @@ static irqreturn_t cyy_interrupt(int irq
 	card_base_addr = cinfo->base_addr;
 	index = cinfo->bus_index;
 
+	/* card was not initialized yet (e.g. DEBUG_SHIRQ) */
+	if (unlikely(card_base_addr == NULL))
+		return IRQ_HANDLED;
+
 	/* This loop checks all chips in the card.  Make a note whenever
 	   _any_ chip had some work to do, as this is considered an
 	   indication that there will be more to do.  Only when no chip
_

Patches currently in -mm which might be from jirislaby@gmail.com are

acpi-asus_acpi-support-f2je-model.patch
char-rocket-add-module_device_table.patch
char-cs5535_gpio-add-module_device_table.patch
unify-queue_delayed_work-and-queue_delayed_work_on.patch
char-cyclades-remove-pause.patch
char-cyclades-cy_readx-writex-cleanup.patch
char-cyclades-timer-cleanup.patch
char-cyclades-remove-volatiles.patch
char-cyclades-remove-useless-casts.patch
char-cyclades-create-cy_init_ze.patch
char-cyclades-use-pci_iomap-unmap.patch
char-cyclades-init-ze-immediately.patch
char-cyclades-create-cy_pci_probe.patch
char-cyclades-move-card-entries-init-into-function.patch
char-cyclades-init-card-struct-immediately.patch
char-cyclades-remove-some-global-vars.patch
char-cyclades-cy_init-error-handling.patch
char-cyclades-tty_register_device-separately-for-each-device.patch
char-cyclades-clear-interrupts-before-releasing.patch
char-cyclades-allow-debug_shirq.patch
shrink_slab-handle-bad-shrinkers.patch
