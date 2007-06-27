From: akpm@linux-foundation.org
Subject: + dont-optimise-away-baud-rate-changes-when-bother-is-used-fix.patch added to -mm tree
Date: Wed, 27 Jun 2007 13:37:25 -0700
Message-ID: <200706272037.l5RKbPjs006581@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56214 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754706AbXF0Uhz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 27 Jun 2007 16:37:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: m.kozlowski@tuxland.pl, alan@redhat.com, dwmw2@infradead.org, rmk@arm.linux.org.uk


The patch titled
     balance parenthesis in serial core
has been added to the -mm tree.  Its filename is
     dont-optimise-away-baud-rate-changes-when-bother-is-used-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: balance parenthesis in serial core
From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>

Signed-off-by: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Alan Cox <alan@redhat.com>
Cc: Russell King <rmk@arm.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/serial/serial_core.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/serial/serial_core.c~dont-optimise-away-baud-rate-changes-when-bother-is-used-fix drivers/serial/serial_core.c
--- a/drivers/serial/serial_core.c~dont-optimise-away-baud-rate-changes-when-bother-is-used-fix
+++ a/drivers/serial/serial_core.c
@@ -1151,9 +1151,9 @@ static void uart_set_termios(struct tty_
 	 * appropriately by set_termios() in tty_ioctl.c
 	 */
 #ifdef CIBAUD
-#define RELEVANT_CFLAG(cflag)	((cflag) & ~(CIBAUD|CBAUD)
+#define RELEVANT_CFLAG(cflag)	((cflag) & ~(CIBAUD|CBAUD))
 #else
-#define RELEVANT_CFLAG(cflag)	((cflag) & ~(CIBAUD|CBAUD)
+#define RELEVANT_CFLAG(cflag)	((cflag) & ~(CIBAUD|CBAUD))
 #endif
 #define RELEVANT_IFLAG(iflag)	((iflag) & (IGNBRK|BRKINT|IGNPAR|PARMRK|INPCK))
 	if ((cflag ^ old_termios->c_cflag) == 0 &&
_

Patches currently in -mm which might be from m.kozlowski@tuxland.pl are

dont-optimise-away-baud-rate-changes-when-bother-is-used-fix.patch
arm26-remove-broken-and-unused-macro.patch
drivers-edac-new-intel-5000-mc-driver-fix.patch
driver-edac-i5000-define-typo.patch
