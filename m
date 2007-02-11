From: akpm@linux-foundation.org
Subject: - char-moxa-macros-cleanup.patch removed from -mm tree
Date: Sun, 11 Feb 2007 14:52:35 -0800
Message-ID: <200702112252.l1BMqZae016029@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:60275 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932820AbXBKWwh (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 11 Feb 2007 17:52:37 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jirislaby@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Char: moxa, macros cleanup
has been removed from the -mm tree.  Its filename was
     char-moxa-macros-cleanup.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Char: moxa, macros cleanup
From: Jiri Slaby <jirislaby@gmail.com>

Remove yet defined or unused macros and whitespace cleanup around the rest.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/moxa.c |   37 +++++++++++++------------------------
 1 file changed, 13 insertions(+), 24 deletions(-)

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
