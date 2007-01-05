From: akpm@osdl.org
Subject: + char-moxa-remove-useless-vairables.patch added to -mm tree
Date: Fri, 05 Jan 2007 12:09:56 -0800
Message-ID: <200701052009.l05K9uF4031005@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:56862 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750718AbXAEUJ7 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 5 Jan 2007 15:09:59 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jirislaby@gmail.com


The patch titled
     Char: moxa, remove useless variables
has been added to the -mm tree.  Its filename is
     char-moxa-remove-useless-vairables.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Char: moxa, remove useless variables
From: Jiri Slaby <jirislaby@gmail.com>

Remove temporary or once used variables, that can be defined locally to
save some bytes.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/char/moxa.c |   35 ++++++++++++++---------------------
 1 files changed, 14 insertions(+), 21 deletions(-)

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

git-input.patch
char-tty-delete-wake_up_interruptible-after-tty_wakeup.patch
char-isicom-remove-tty_hangwakeup-bottomhalves.patch
mxser-remove-ambiguous-redefinition-of-init_work.patch
make-drivers-char-mxser_newcmxser_hangup-static.patch
char-isicom-fix-locking-in-isr.patch
char-isicom-augment-card_reset.patch
char-isicom-check-card-state-in-isr.patch
char-isicom-support-higher-rates.patch
char-isicom-correct-probing-removing.patch
char-tty_wakeup-cleanup.patch
char-mxser_new-mark-init-functions.patch
char-mxser_new-remove-useless-spinlock.patch
char-serial167-cleanup.patch
char-n_r3964-cleanup.patch
char-mxser_new-remove-unused-stuff.patch
char-mxser-obsolete-old-nonexperimental-new.patch
char-mxser_new-remove-tty_wakeup-bottomhalf.patch
char-mxser_new-clean-request_irq-call.patch
doc-isicom-remove-reserved-ioctl-number.patch
char-mxser_new-alter-locking-in-isr.patch
char-mxser_new-header-file-cleanup.patch
char-mxser_new-less-loops-in-isr.patch
char-mxser_new-fix-twice-resource-releasing.patch
char-mxser_new-do-not-put-pdev.patch
char-mxser_new-upgrade-to-1915.patch
char-moxa-remove-unused-allocated-page.patch
char-moxa-do-not-initialize-global-static.patch
char-moxa-timers-cleanup.patch
char-moxa-remove-hangup-bottomhalf.patch
char-moxa-remove-unused-functions.patch
char-moxa-devids-cleanup.patch
char-moxa-use-pci_device.patch
char-moxa-eliminate-typedefs.patch
char-moxa-macros-cleanup.patch
char-moxa-use-del_timer_sync.patch
char-moxa-remove-moxa_pci_devinfo.patch
char-moxa-variables-cleanup.patch
char-moxa-remove-useless-vairables.patch
char-moxa-pci_probing-prepare.patch
char-moxa-pci-probing.patch
shrink_slab-handle-bad-shrinkers.patch
