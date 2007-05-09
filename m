From: akpm@linux-foundation.org
Subject: - 8250-remove-commented-out-irq-cruft.patch removed from -mm tree
Date: Tue, 08 May 2007 19:52:55 -0700
Message-ID: <200705090252.l492qt7l009628@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:48116 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1032220AbXEICw7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 22:52:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jwboyer@gmail.com, mm-commits@vger.kernel.org


The patch titled
     8250: Remove commented out irq cruft
has been removed from the -mm tree.  Its filename was
     8250-remove-commented-out-irq-cruft.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: 8250: Remove commented out irq cruft
From: "Josh Boyer" <jwboyer@gmail.com>

Remove some obviously old interrupt disable/enable code that has been
commented out.

Signed-off-by: Josh Boyer <jwboyer@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/serial/8250.c |    2 --
 1 file changed, 2 deletions(-)

diff -puN drivers/serial/8250.c~8250-remove-commented-out-irq-cruft drivers/serial/8250.c
--- a/drivers/serial/8250.c~8250-remove-commented-out-irq-cruft
+++ a/drivers/serial/8250.c
@@ -994,7 +994,6 @@ static void autoconfig(struct uart_8250_
 	 * be frobbing the chips IRQ enable register to see if it exists.
 	 */
 	spin_lock_irqsave(&up->port.lock, flags);
-//	save_flags(flags); cli();
 
 	up->capabilities = 0;
 	up->bugs = 0;
@@ -1151,7 +1150,6 @@ static void autoconfig(struct uart_8250_
 
  out:
 	spin_unlock_irqrestore(&up->port.lock, flags);
-//	restore_flags(flags);
 	DEBUG_AUTOCONF("type=%s\n", uart_config[up->port.type].name);
 }
 
_

Patches currently in -mm which might be from jwboyer@gmail.com are

origin.patch
