From: akpm@linux-foundation.org
Subject: - 8250-enable-rate-reporting-via-termios.patch removed from -mm tree
Date: Fri, 08 Feb 2008 12:13:04 -0800
Message-ID: <200802082012.m18KCjhb010233@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39889 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763398AbYBHUrc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Feb 2008 15:47:32 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alan@lxorguk.ukuu.org.uk, alan@redhat.com, mm-commits@vger.kernel.org


The patch titled
     8250: enable rate reporting via termios
has been removed from the -mm tree.  Its filename was
     8250-enable-rate-reporting-via-termios.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: 8250: enable rate reporting via termios
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

Signed-off-by: Alan Cox <alan@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/serial/8250.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/serial/8250.c~8250-enable-rate-reporting-via-termios drivers/serial/8250.c
--- a/drivers/serial/8250.c~8250-enable-rate-reporting-via-termios
+++ a/drivers/serial/8250.c
@@ -2174,6 +2174,7 @@ serial8250_set_termios(struct uart_port 
 	}
 	serial8250_set_mctrl(&up->port, up->port.mctrl);
 	spin_unlock_irqrestore(&up->port.lock, flags);
+	tty_termios_encode_baud_rate(termios, baud, baud);
 }
 
 static void
_

Patches currently in -mm which might be from alan@lxorguk.ukuu.org.uk are

origin.patch
8390-split-8390-support-into-a-pausing-and-a-non-pausing-driver-core.patch
hci_ldisc-fix-null-pointer-deref.patch
parisc-new-termios-definitions.patch
git-sh.patch
git-watchdog.patch
