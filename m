From: akpm@linux-foundation.org
Subject: + dz-always-check-if-it-is-safe-to-console_putchar.patch added to -mm tree
Date: Fri, 19 Oct 2007 14:25:54 -0700
Message-ID: <200710192125.l9JLPsuS020928@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:32903 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932864AbXJSV0l (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 19 Oct 2007 17:26:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: macro@linux-mips.org, jirislaby@gmail.com


The patch titled
     dz: always check if it is safe to console_putchar()
has been added to the -mm tree.  Its filename is
     dz-always-check-if-it-is-safe-to-console_putchar.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: dz: always check if it is safe to console_putchar()
From: "Maciej W. Rozycki" <macro@linux-mips.org>

Polled transmission is tricky enough with the DZ11 design.  While "loop" is
set to a high value, conceptually you are not allowed to transmit without
checking whether the device offers the right transmission line (yes, it is the
device that selects the line -- the driver has no control over it other than
disabling the transmitter offered if it is the wrong one), so the loop has to
be run at least once.

Well, the '1977 or PDP11 view of how serial lines should be handled...  Except
that the serial interface used to be quite an impressive board back then
rather than chip.

Signed-off-by: Maciej W. Rozycki <macro@linux-mips.org>
Cc: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/serial/dz.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/serial/dz.c~dz-always-check-if-it-is-safe-to-console_putchar drivers/serial/dz.c
--- a/drivers/serial/dz.c~dz-always-check-if-it-is-safe-to-console_putchar
+++ a/drivers/serial/dz.c
@@ -685,7 +685,7 @@ static void dz_console_putchar(struct ua
 	iob();
 	spin_unlock_irqrestore(&dport->port.lock, flags);
 
-	while (loops--) {
+	do {
 		trdy = dz_in(dport, DZ_CSR);
 		if (!(trdy & DZ_TRDY))
 			continue;
@@ -696,7 +696,7 @@ static void dz_console_putchar(struct ua
 		dz_out(dport, DZ_TCR, mask);
 		iob();
 		udelay(2);
-	}
+	} while (loops--);
 
 	if (loops)				/* Cannot send otherwise. */
 		dz_out(dport, DZ_TDR, ch);
_

Patches currently in -mm which might be from macro@linux-mips.org are

origin.patch
kernel-printkc-concerns-about-the-console-handover.patch
dzh-remove-useless-unused-module-junk.patch
dz-always-check-if-it-is-safe-to-console_putchar.patch
dz-dont-panic-when-request_irq-fails.patch
dz-add-and-reorder-inclusions-remove-unneeded-ones.patch
dz-update-kconfig-description.patch
dz-rename-the-serial-console-structure.patch
dz-fix-locking-issues.patch
dz-handle-special-conditions-on-reception-correctly.patch
maintainers-add-self-for-the-dz-serial-driver.patch
