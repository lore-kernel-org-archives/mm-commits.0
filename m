From: akpm@linux-foundation.org
Subject: - serial-8250-tighten-test-for-using-backup-timer.patch removed from -mm tree
Date: Wed, 03 Sep 2008 09:11:15 -0700
Message-ID: <200809031611.m83GBFMd023756@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56959 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751773AbYICQLf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Sep 2008 12:11:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: will.newton@gmail.com, alan@lxorguk.ukuu.org.uk, alex.williamson@hp.com, david-b@pacbell.net, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     8250: improve workaround for UARTs that don't re-assert THRE correctly
has been removed from the -mm tree.  Its filename was
     serial-8250-tighten-test-for-using-backup-timer.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: 8250: improve workaround for UARTs that don't re-assert THRE correctly
From: "Will Newton" <will.newton@gmail.com>

Recent changes to tighten the check for UARTs that don't correctly
re-assert THRE (01c194d9278efc15d4785ff205643e9c0bdcef53: "serial 8250:
tighten test for using backup timer") caused problems when such a UART was
opened for the second time - the bug could only successfully be detected
at first initialization.  For users of this version of this particular
UART IP it is fatal.

This patch stores the information about the bug in the bugs field of the
port structure when the port is first started up so subsequent opens can
check this bit even if the test for the bug fails.

David Brownell: "My own exposure to this is that the UART on DaVinci
hardware, which TI allegedly derived from its original 16550 logic, has
periodically gone from working to unusable with the mainline 8250.c ... 
and back and forth a bunch.  Currently it's "unusable", a regression from
some previous versions.  With this patch from Will, it's usable."

Signed-off-by: Will Newton <will.newton@gmail.com>
Acked-by: Alex Williamson <alex.williamson@hp.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: David Brownell <david-b@pacbell.net>
Cc: <stable@kernel.org>		[2.6.26.x]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/serial/8250.c |   16 ++++++++++++----
 drivers/serial/8250.h |    1 +
 2 files changed, 13 insertions(+), 4 deletions(-)

diff -puN drivers/serial/8250.c~serial-8250-tighten-test-for-using-backup-timer drivers/serial/8250.c
--- a/drivers/serial/8250.c~serial-8250-tighten-test-for-using-backup-timer
+++ a/drivers/serial/8250.c
@@ -1908,15 +1908,23 @@ static int serial8250_startup(struct uar
 		 * kick the UART on a regular basis.
 		 */
 		if (!(iir1 & UART_IIR_NO_INT) && (iir & UART_IIR_NO_INT)) {
+			up->bugs |= UART_BUG_THRE;
 			pr_debug("ttyS%d - using backup timer\n", port->line);
-			up->timer.function = serial8250_backup_timeout;
-			up->timer.data = (unsigned long)up;
-			mod_timer(&up->timer, jiffies +
-				poll_timeout(up->port.timeout) + HZ / 5);
 		}
 	}
 
 	/*
+	 * The above check will only give an accurate result the first time
+	 * the port is opened so this value needs to be preserved.
+	 */
+	if (up->bugs & UART_BUG_THRE) {
+		up->timer.function = serial8250_backup_timeout;
+		up->timer.data = (unsigned long)up;
+		mod_timer(&up->timer, jiffies +
+			  poll_timeout(up->port.timeout) + HZ / 5);
+	}
+
+	/*
 	 * If the "interrupt" for this port doesn't correspond with any
 	 * hardware interrupt, we use a timer-based system.  The original
 	 * driver used to do this with IRQ0.
diff -puN drivers/serial/8250.h~serial-8250-tighten-test-for-using-backup-timer drivers/serial/8250.h
--- a/drivers/serial/8250.h~serial-8250-tighten-test-for-using-backup-timer
+++ a/drivers/serial/8250.h
@@ -47,6 +47,7 @@ struct serial8250_config {
 #define UART_BUG_QUOT	(1 << 0)	/* UART has buggy quot LSB */
 #define UART_BUG_TXEN	(1 << 1)	/* UART has buggy TX IIR status */
 #define UART_BUG_NOMSR	(1 << 2)	/* UART has buggy MSR status bits (Au1x00) */
+#define UART_BUG_THRE	(1 << 3)	/* UART has buggy THRE reassertion */
 
 #define PROBE_RSA	(1 << 0)
 #define PROBE_ANY	(~0)
_

Patches currently in -mm which might be from will.newton@gmail.com are

origin.patch
linux-next.patch

