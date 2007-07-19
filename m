From: akpm@linux-foundation.org
Subject: + serial-mpsc-stop-rx-engine-when-cread-cleared.patch added to -mm tree
Date: Thu, 19 Jul 2007 14:41:22 -0700
Message-ID: <200707192141.l6JLfMBO024468@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35799 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757247AbXGSVmb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Jul 2007 17:42:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: stephane@artesyncp.com, mgreer@mvista.com


The patch titled
     serial: MPSC: Stop rx engine when CREAD cleared
has been added to the -mm tree.  Its filename is
     serial-mpsc-stop-rx-engine-when-cread-cleared.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: serial: MPSC: Stop rx engine when CREAD cleared
From: Stephane Chazelas <stephane@artesyncp.com>

Currently, the MPSC driver doesn't stop recieving characters when the CREAD
flag in termios->c_cflag is cleared.  It should.  Also, only start receiving
if its not already started.

Signed-off-by: Stephane Chazelas <stephane@artesyncp.com>
Signed-off-by: Mark A. Greer <mgreer@mvista.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/serial/mpsc.c |   13 ++++++++-----
 1 files changed, 8 insertions(+), 5 deletions(-)

diff -puN drivers/serial/mpsc.c~serial-mpsc-stop-rx-engine-when-cread-cleared drivers/serial/mpsc.c
--- a/drivers/serial/mpsc.c~serial-mpsc-stop-rx-engine-when-cread-cleared
+++ a/drivers/serial/mpsc.c
@@ -1520,7 +1520,6 @@ mpsc_set_termios(struct uart_port *port,
 	mpsc_set_baudrate(pi, baud);
 
 	/* Characters/events to read */
-	pi->rcv_data = 1;
 	pi->port.read_status_mask = SDMA_DESC_CMDSTAT_OR;
 
 	if (termios->c_iflag & INPCK)
@@ -1544,11 +1543,15 @@ mpsc_set_termios(struct uart_port *port,
 			pi->port.ignore_status_mask |= SDMA_DESC_CMDSTAT_OR;
 	}
 
-	/* Ignore all chars if CREAD not set */
-	if (!(termios->c_cflag & CREAD))
+	if ((termios->c_cflag & CREAD)) {
+		if (!pi->rcv_data) {
+			pi->rcv_data = 1;
+			mpsc_start_rx(pi);
+		}
+	} else if (pi->rcv_data) {
+		mpsc_stop_rx(port);
 		pi->rcv_data = 0;
-	else
-		mpsc_start_rx(pi);
+	}
 
 	spin_unlock_irqrestore(&pi->port.lock, flags);
 	return;
_

Patches currently in -mm which might be from stephane@artesyncp.com are

serial-mpsc-stop-rx-engine-when-cread-cleared.patch
