From: akpm@linux-foundation.org
Subject: - char-moxa-remove-useless-vairables.patch removed from -mm tree
Date: Sun, 11 Feb 2007 14:52:43 -0800
Message-ID: <200702112252.l1BMqhc3016047@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:60290 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932825AbXBKWwp (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 11 Feb 2007 17:52:45 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jirislaby@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Char: moxa, remove useless variables
has been removed from the -mm tree.  Its filename was
     char-moxa-remove-useless-vairables.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Char: moxa, remove useless variables
From: Jiri Slaby <jirislaby@gmail.com>

Remove temporary or once used variables, that can be defined locally to
save some bytes.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/moxa.c |   35 ++++++++++++++---------------------
 1 file changed, 14 insertions(+), 21 deletions(-)

diff -puN drivers/char/moxa.c~char-moxa-remove-useless-vairables drivers/char/moxa.c
--- a/drivers/char/moxa.c~char-moxa-remove-useless-vairables
+++ a/drivers/char/moxa.c
@@ -146,8 +146,6 @@ struct moxa_port {
 	wait_queue_head_t close_wait;
 
 	struct timer_list emptyTimer;
-	struct mxser_mstatus GMStatus;
-	struct moxaq_str temp_queue;
 
 	char chkPort;
 	char lineCtrl;
@@ -1487,17 +1485,15 @@ int MoxaDriverIoctl(unsigned int cmd, un
 		return (0);
 	case MOXA_GET_IOQUEUE: {
 		struct moxaq_str __user *argm = argp;
-		struct moxa_port *p;
+		struct moxaq_str tmp;
 
 		for (i = 0; i < MAX_PORTS; i++, argm++) {
-			p = &moxa_ports[i];
-			memset(&p->temp_queue, 0, sizeof(p->temp_queue));
-			if (p->chkPort) {
-				p->temp_queue.inq = MoxaPortRxQueue(i);
-				p->temp_queue.outq = MoxaPortTxQueue(i);
+			memset(&tmp, 0, sizeof(tmp));
+			if (moxa_ports[i].chkPort) {
+				tmp.inq = MoxaPortRxQueue(i);
+				tmp.outq = MoxaPortTxQueue(i);
 			}
-			if (copy_to_user(argm, &p->temp_queue,
-						sizeof(p->temp_queue)))
+			if (copy_to_user(argm, &tmp, sizeof(tmp)))
 				return -EFAULT;
 		}
 		return (0);
@@ -1518,33 +1514,30 @@ int MoxaDriverIoctl(unsigned int cmd, un
 		return 0;
 	case MOXA_GETMSTATUS: {
 		struct mxser_mstatus __user *argm = argp;
+		struct mxser_mstatus tmp;
 		struct moxa_port *p;
 
 		for (i = 0; i < MAX_PORTS; i++, argm++) {
 			p = &moxa_ports[i];
-			p->GMStatus.ri = 0;
-			p->GMStatus.dcd = 0;
-			p->GMStatus.dsr = 0;
-			p->GMStatus.cts = 0;
+			memset(&tmp, 0, sizeof(tmp));
 			if (!p->chkPort) {
 				goto copy;
 			} else {
 				status = MoxaPortLineStatus(p->port);
 				if (status & 1)
-					p->GMStatus.cts = 1;
+					tmp.cts = 1;
 				if (status & 2)
-					p->GMStatus.dsr = 1;
+					tmp.dsr = 1;
 				if (status & 4)
-					p->GMStatus.dcd = 1;
+					tmp.dcd = 1;
 			}
 
 			if (!p->tty || !p->tty->termios)
-				p->GMStatus.cflag = p->cflag;
+				tmp.cflag = p->cflag;
 			else
-				p->GMStatus.cflag = p->tty->termios->c_cflag;
+				tmp.cflag = p->tty->termios->c_cflag;
 copy:
-			if (copy_to_user(argm, &p->GMStatus,
-						sizeof(p->GMStatus)))
+			if (copy_to_user(argm, &tmp, sizeof(tmp)))
 				return -EFAULT;
 		}
 		return 0;
_

Patches currently in -mm which might be from jirislaby@gmail.com are

origin.patch
char-use-more-pci_device-macro.patch
char-cyclades-use-pci_device_id.patch
maintainers-remove-two-dead-e-mail.patch
char-specialix-isr-have-2-params.patch
char-timers-cleanup.patch
fbdev-driver-for-s3-trio-virge-update-2-fix.patch
video-fb-add-true-ref_count-atomicity.patch
video-fb-kzalloc-changes.patch
shrink_slab-handle-bad-shrinkers.patch
