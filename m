From: akpm@osdl.org
Subject: + char-moxa-macros-cleanup.patch added to -mm tree
Date: Fri, 05 Jan 2007 12:09:48 -0800
Message-ID: <200701052009.l05K9mZl030990@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:56843 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750696AbXAEUJv (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 5 Jan 2007 15:09:51 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jirislaby@gmail.com


The patch titled
     Char: moxa, macros cleanup
has been added to the -mm tree.  Its filename is
     char-moxa-macros-cleanup.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Char: moxa, macros cleanup
From: Jiri Slaby <jirislaby@gmail.com>

Remove yet defined or unused macros and whitespace cleanup around the rest.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/char/moxa.c |   37 +++++++++++++------------------------
 1 files changed, 13 insertions(+), 24 deletions(-)

diff -puN drivers/char/moxa.c~char-moxa-macros-cleanup drivers/char/moxa.c
--- a/drivers/char/moxa.c~char-moxa-macros-cleanup
+++ a/drivers/char/moxa.c
@@ -46,23 +46,20 @@
 #include <asm/io.h>
 #include <asm/uaccess.h>
 
-#define		MOXA_VERSION		"5.1k"
+#define MOXA_VERSION		"5.1k"
 
-#define MOXAMAJOR       172
-#define MOXACUMAJOR     173
+#define MOXAMAJOR		172
+#define MOXACUMAJOR		173
 
-#define put_to_user(arg1, arg2) put_user(arg1, (unsigned long *)arg2)
-#define get_from_user(arg1, arg2) get_user(arg1, (unsigned int *)arg2)
-
-#define MAX_BOARDS 		4	/* Don't change this value */
+#define MAX_BOARDS		4	/* Don't change this value */
 #define MAX_PORTS_PER_BOARD	32	/* Don't change this value */
-#define MAX_PORTS 		128	/* Don't change this value */
+#define MAX_PORTS		(MAX_BOARDS * MAX_PORTS_PER_BOARD)
 
 /*
  *    Define the Moxa PCI vendor and device IDs.
  */
-#define MOXA_BUS_TYPE_ISA		0
-#define MOXA_BUS_TYPE_PCI		1
+#define MOXA_BUS_TYPE_ISA	0
+#define MOXA_BUS_TYPE_PCI	1
 
 enum {
 	MOXA_BOARD_C218_PCI = 1,
@@ -157,13 +154,8 @@ static struct mxser_mstatus GMStatus[MAX
 
 #define SERIAL_DO_RESTART
 
-
-#define SERIAL_TYPE_NORMAL	1
-
 #define WAKEUP_CHARS		256
 
-#define PORTNO(x)		((x)->index)
-
 static int verbose = 0;
 static int ttymajor = MOXAMAJOR;
 /* Variables for insmod */
@@ -461,7 +453,7 @@ static int moxa_open(struct tty_struct *
 	int port;
 	int retval;
 
-	port = PORTNO(tty);
+	port = tty->index;
 	if (port == MAX_PORTS) {
 		return (0);
 	}
@@ -499,7 +491,7 @@ static void moxa_close(struct tty_struct
 	struct moxa_str *ch;
 	int port;
 
-	port = PORTNO(tty);
+	port = tty->index;
 	if (port == MAX_PORTS) {
 		return;
 	}
@@ -663,7 +655,7 @@ static int moxa_tiocmget(struct tty_stru
 	int port;
 	int flag = 0, dtr, rts;
 
-	port = PORTNO(tty);
+	port = tty->index;
 	if ((port != MAX_PORTS) && (!ch))
 		return (-EINVAL);
 
@@ -689,7 +681,7 @@ static int moxa_tiocmset(struct tty_stru
 	int port;
 	int dtr, rts;
 
-	port = PORTNO(tty);
+	port = tty->index;
 	if ((port != MAX_PORTS) && (!ch))
 		return (-EINVAL);
 
@@ -714,7 +706,7 @@ static int moxa_ioctl(struct tty_struct 
 	void __user *argp = (void __user *)arg;
 	int retval;
 
-	port = PORTNO(tty);
+	port = tty->index;
 	if ((port != MAX_PORTS) && (!ch))
 		return (-EINVAL);
 
@@ -1361,9 +1353,6 @@ static void receive_data(struct moxa_str
 /*
  *    Query
  */
-#define QueryPort	MAX_PORTS
-
-
 
 struct mon_str {
 	int tick;
@@ -1475,7 +1464,7 @@ int MoxaDriverIoctl(unsigned int cmd, un
 	int MoxaPortTxQueue(int), MoxaPortRxQueue(int);
 	void __user *argp = (void __user *)arg;
 
-	if (port == QueryPort) {
+	if (port == MAX_PORTS) {
 		if ((cmd != MOXA_GET_CONF) && (cmd != MOXA_INIT_DRIVER) &&
 		    (cmd != MOXA_LOAD_BIOS) && (cmd != MOXA_FIND_BOARD) && (cmd != MOXA_LOAD_C320B) &&
 		 (cmd != MOXA_LOAD_CODE) && (cmd != MOXA_GETDATACOUNT) &&
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
