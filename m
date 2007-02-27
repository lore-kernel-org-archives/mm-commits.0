From: akpm@linux-foundation.org
Subject: + make-hvc_consolec-compile-on-non-powerpc-remove-no_irq.patch added to -mm tree
Date: Tue, 27 Feb 2007 12:33:52 -0800
Message-ID: <200702272033.l1RKXt7r027522@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:50658 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752539AbXB0UeJ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 27 Feb 2007 15:34:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rusty@rustcorp.com.au, jeremy@goop.org, kraxel@suse.de, paulus@samba.org


The patch titled
     Subject: [PATCH] Make hvc_console.c compile on non-powerpc: Remove NO_IRQ
has been added to the -mm tree.  Its filename is
     make-hvc_consolec-compile-on-non-powerpc-remove-no_irq.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Subject: [PATCH] Make hvc_console.c compile on non-powerpc: Remove NO_IRQ
From: Rusty Russell <rusty@rustcorp.com.au>

Linus, please apply.  Andrew, please drop the other hvc_console patch
you have.

Paulus preferred this over #defining NO_IRQ in the file, since that's
0 for powerpc anyway.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Acked-by: Paul Mackerras <paulus@samba.org>
Cc: Gerd Hoffmann <kraxel@suse.de>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/hvc_console.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff -puN drivers/char/hvc_console.c~make-hvc_consolec-compile-on-non-powerpc-remove-no_irq drivers/char/hvc_console.c
--- a/drivers/char/hvc_console.c~make-hvc_consolec-compile-on-non-powerpc-remove-no_irq
+++ a/drivers/char/hvc_console.c
@@ -316,7 +316,7 @@ static int hvc_open(struct tty_struct *t
 {
 	struct hvc_struct *hp;
 	unsigned long flags;
-	int irq = NO_IRQ;
+	int irq = 0;
 	int rc = 0;
 	struct kobject *kobjp;
 
@@ -338,14 +338,14 @@ static int hvc_open(struct tty_struct *t
 	hp->tty = tty;
 	/* Save for request_irq outside of spin_lock. */
 	irq = hp->irq;
-	if (irq != NO_IRQ)
+	if (irq)
 		hp->irq_requested = 1;
 
 	kobjp = &hp->kobj;
 
 	spin_unlock_irqrestore(&hp->lock, flags);
 	/* check error, fallback to non-irq */
-	if (irq != NO_IRQ)
+	if (irq)
 		rc = request_irq(irq, hvc_handle_interrupt, IRQF_DISABLED, "hvc_console", hp);
 
 	/*
@@ -373,7 +373,7 @@ static void hvc_close(struct tty_struct 
 {
 	struct hvc_struct *hp;
 	struct kobject *kobjp;
-	int irq = NO_IRQ;
+	int irq = 0;
 	unsigned long flags;
 
 	if (tty_hung_up_p(filp))
@@ -407,7 +407,7 @@ static void hvc_close(struct tty_struct 
 		 */
 		tty_wait_until_sent(tty, HVC_CLOSE_WAIT);
 
-		if (irq != NO_IRQ)
+		if (irq)
 			free_irq(irq, hp);
 
 	} else {
@@ -424,7 +424,7 @@ static void hvc_hangup(struct tty_struct
 {
 	struct hvc_struct *hp = tty->driver_data;
 	unsigned long flags;
-	int irq = NO_IRQ;
+	int irq = 0;
 	int temp_open_count;
 	struct kobject *kobjp;
 
@@ -453,7 +453,7 @@ static void hvc_hangup(struct tty_struct
 		irq = hp->irq;
 	hp->irq_requested = 0;
 	spin_unlock_irqrestore(&hp->lock, flags);
-	if (irq != NO_IRQ)
+	if (irq)
 		free_irq(irq, hp);
 	while(temp_open_count) {
 		--temp_open_count;
@@ -583,7 +583,7 @@ static int hvc_poll(struct hvc_struct *h
 	/* If we aren't interrupt driven and aren't throttled, we always
 	 * request a reschedule
 	 */
-	if (hp->irq == NO_IRQ)
+	if (hp->irq == 0)
 		poll_mask |= HVC_POLL_READ;
 
 	/* Read data if any */
_

Patches currently in -mm which might be from rusty@rustcorp.com.au are

make-hvc_consolec-compile-on-non-powerpc-remove-no_irq.patch
cleanup-initialize-esp0-properly-all-the-time.patch
lguest-preparation-export_symbol_gpl-5-functions.patch
lguest-preparation-expose-futex-infrastructure.patch
lguest-kconfig-and-headers.patch
lguest-kconfig-and-headers-fix.patch
lguest-the-host-code-lgko.patch
lguest-guest-code.patch
lguest-makefile.patch
lguest-trivial-guest-network-driver.patch
lguest-trivial-guest-network-driver-fix.patch
lguest-trivial-guest-console-driver.patch
lguest-trivial-guest-block-driver.patch
lguest-documentatation-and-example-launcher.patch
module-use-krealloc.patch
dont-assume-arguments-to-init-have-no-period-in-them.patch
____call_usermodehelper-dont-flush_signals.patch
