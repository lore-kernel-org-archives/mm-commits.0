From: akpm@linux-foundation.org
Subject: + request_irq-always-returns-einval-with-a-null-handler.patch added to -mm tree
Date: Wed, 23 Jan 2008 13:42:24 -0800
Message-ID: <200801232142.m0NLgGq3027790@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52122 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751473AbYAWVmg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Jan 2008 16:42:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rusty@rustcorp.com.au, jeff@garzik.org


The patch titled
     request_irq() always returns -EINVAL with a NULL handler
has been added to the -mm tree.  Its filename is
     request_irq-always-returns-einval-with-a-null-handler.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: request_irq() always returns -EINVAL with a NULL handler
From: Rusty Russell <rusty@rustcorp.com.au>

I assume that these ancient network drivers were trying to find out if
an irq is available.  eepro.c expecting +EBUSY was doubly wrong.

I'm not sure that can_request_irq() is the right thing, but these drivers
are definitely wrong.

request_irq should BUG() on bad input, and these would have been found
earlier.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Cc: Jeff Garzik <jeff@garzik.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/3c503.c |    2 +-
 drivers/net/e2100.c |    2 +-
 drivers/net/eepro.c |    2 +-
 drivers/net/hp.c    |    2 +-
 kernel/irq/manage.c |    1 +
 5 files changed, 5 insertions(+), 4 deletions(-)

diff -puN drivers/net/3c503.c~request_irq-always-returns-einval-with-a-null-handler drivers/net/3c503.c
--- a/drivers/net/3c503.c~request_irq-always-returns-einval-with-a-null-handler
+++ a/drivers/net/3c503.c
@@ -379,7 +379,7 @@ el2_open(struct net_device *dev)
 
 	outb(EGACFR_NORM, E33G_GACFR);	/* Enable RAM and interrupts. */
 	do {
-	    if (request_irq (*irqp, NULL, 0, "bogus", dev) != -EBUSY) {
+	    if (can_request_irq(*irqp, 0)) {
 		/* Twinkle the interrupt, and check if it's seen. */
 		unsigned long cookie = probe_irq_on();
 		outb_p(0x04 << ((*irqp == 9) ? 2 : *irqp), E33G_IDCFR);
diff -puN drivers/net/e2100.c~request_irq-always-returns-einval-with-a-null-handler drivers/net/e2100.c
--- a/drivers/net/e2100.c~request_irq-always-returns-einval-with-a-null-handler
+++ a/drivers/net/e2100.c
@@ -202,7 +202,7 @@ static int __init e21_probe1(struct net_
 	if (dev->irq < 2) {
 		int irqlist[] = {15,11,10,12,5,9,3,4}, i;
 		for (i = 0; i < 8; i++)
-			if (request_irq (irqlist[i], NULL, 0, "bogus", NULL) != -EBUSY) {
+			if (can_request_irq(irqlist[i], 0)) {
 				dev->irq = irqlist[i];
 				break;
 			}
diff -puN drivers/net/eepro.c~request_irq-always-returns-einval-with-a-null-handler drivers/net/eepro.c
--- a/drivers/net/eepro.c~request_irq-always-returns-einval-with-a-null-handler
+++ a/drivers/net/eepro.c
@@ -914,7 +914,7 @@ static int	eepro_grab_irq(struct net_dev
 
 		eepro_sw2bank0(ioaddr); /* Switch back to Bank 0 */
 
-		if (request_irq (*irqp, NULL, IRQF_SHARED, "bogus", dev) != EBUSY) {
+		if (can_request_irq(*irqp, IRQF_SHARED)) {
 			unsigned long irq_mask;
 			/* Twinkle the interrupt, and check if it's seen */
 			irq_mask = probe_irq_on();
diff -puN drivers/net/hp.c~request_irq-always-returns-einval-with-a-null-handler drivers/net/hp.c
--- a/drivers/net/hp.c~request_irq-always-returns-einval-with-a-null-handler
+++ a/drivers/net/hp.c
@@ -170,7 +170,7 @@ static int __init hp_probe1(struct net_d
 		int *irqp = wordmode ? irq_16list : irq_8list;
 		do {
 			int irq = *irqp;
-			if (request_irq (irq, NULL, 0, "bogus", NULL) != -EBUSY) {
+			if (can_request_irq(irq, 0)) {
 				unsigned long cookie = probe_irq_on();
 				/* Twinkle the interrupt, and check if it's seen. */
 				outb_p(irqmap[irq] | HP_RUN, ioaddr + HP_CONFIGURE);
diff -puN kernel/irq/manage.c~request_irq-always-returns-einval-with-a-null-handler kernel/irq/manage.c
--- a/kernel/irq/manage.c~request_irq-always-returns-einval-with-a-null-handler
+++ a/kernel/irq/manage.c
@@ -252,6 +252,7 @@ int can_request_irq(unsigned int irq, un
 
 	return !action;
 }
+EXPORT_SYMBOL(can_request_irq);
 
 void compat_irq_chip_set_default_handler(struct irq_desc *desc)
 {
_

Patches currently in -mm which might be from rusty@rustcorp.com.au are

origin.patch
fix-drivers-lguest-makefile-entry.patch
git-kbuild.patch
git-kvm.patch
git-libata-all.patch
request_irq-always-returns-einval-with-a-null-handler.patch
git-sched.patch
git-scsi-misc.patch
git-x86.patch
kallsyms-should-prefer-non-weak-symbols.patch
virtio_net-remove-double-ether_setup.patch
modules-handle-symbols-that-have-a-zero-value.patch
modules-include-sectionsh-to-avoid-defining-linker-variables.patch
modules-make-module_address_lookup-safe.patch
modules-make-module_address_lookup-safe-fix.patch
fixup-container_of-usage.patch
aio-partial-write-should-not-return-error-code.patch
aio-negative-offset-should-return-einval.patch
reiser4.patch
