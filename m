From: akpm@linux-foundation.org
Subject: + serial-jsm-correctly-support-4-8-port-boards.patch added to -mm tree
Date: Wed, 27 May 2009 23:09:26 -0700
Message-ID: <200905280609.n4S69QwI023251@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53169 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752978AbZE1GJk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 28 May 2009 02:09:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: git.user@gmail.com, Scott_Kilau@digi.com, adam@os.inf.tu-dresden.de, alan@lxorguk.ukuu.org.uk, wendyx@us.ibm.com


The patch titled
     serial: jsm: correctly support 4/8 port boards
has been added to the -mm tree.  Its filename is
     serial-jsm-correctly-support-4-8-port-boards.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: serial: jsm: correctly support 4/8 port boards
From: Alexander Y. Fomichev <git.user@gmail.com>

Addresses http://bugzilla.kernel.org/show_bug.cgi?id=13336

The jsm driver was written for 2-port boards but now supports 4/8-ports
via commit ffa7525c13eb3db0fd19a3e1cffe2ce6f561f5f3 ("jsm: additional
device support")

However a part of the code doesn't aware about hardware like this:

drivers/serial/jsm/jsm_tty.c +462
brd->channels[i]->uart_port.line = brd->channels[i]->ch_portnum + brd->boardnum
* 2

Here jsm_uart_port_init just increments uart_port.line by 2 for any
further board so uart_port.line assigned for the second board overlaps
range of the first one (i.g.  with digi neo 8).  

The patch fixes this.

[akpm@linux-foundation.org: turned the bugzilla patch into a usable one]
Cc: Adam Lackorzynski <adam@os.inf.tu-dresden.de>
Cc: Scott H Kilau <Scott_Kilau@digi.com>
Cc: Wendy Xiong <wendyx@us.ibm.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/serial/jsm/jsm.h     |    1 +
 drivers/serial/jsm/jsm_tty.c |   12 +++++++++++-
 2 files changed, 12 insertions(+), 1 deletion(-)

diff -puN drivers/serial/jsm/jsm.h~serial-jsm-correctly-support-4-8-port-boards drivers/serial/jsm/jsm.h
--- a/drivers/serial/jsm/jsm.h~serial-jsm-correctly-support-4-8-port-boards
+++ a/drivers/serial/jsm/jsm.h
@@ -61,6 +61,7 @@ enum {
 	if ((DBG_##nlevel & jsm_debug))			\
 	dev_printk(KERN_##klevel, pdev->dev, fmt, ## args)
 
+#define	MAXLINES	256
 #define MAXPORTS	8
 #define MAX_STOPS_SENT	5
 
diff -puN drivers/serial/jsm/jsm_tty.c~serial-jsm-correctly-support-4-8-port-boards drivers/serial/jsm/jsm_tty.c
--- a/drivers/serial/jsm/jsm_tty.c~serial-jsm-correctly-support-4-8-port-boards
+++ a/drivers/serial/jsm/jsm_tty.c
@@ -33,6 +33,8 @@
 
 #include "jsm.h"
 
+static DECLARE_BITMAP(linemap,MAXLINES);
+
 static void jsm_carrier(struct jsm_channel *ch);
 
 static inline int jsm_get_mstat(struct jsm_channel *ch)
@@ -433,6 +435,7 @@ int __devinit jsm_tty_init(struct jsm_bo
 int __devinit jsm_uart_port_init(struct jsm_board *brd)
 {
 	int i;
+	unsigned int line;
 	struct jsm_channel *ch;
 
 	if (!brd)
@@ -459,7 +462,13 @@ int __devinit jsm_uart_port_init(struct 
 		brd->channels[i]->uart_port.membase = brd->re_map_membase;
 		brd->channels[i]->uart_port.fifosize = 16;
 		brd->channels[i]->uart_port.ops = &jsm_ops;
-		brd->channels[i]->uart_port.line = brd->channels[i]->ch_portnum + brd->boardnum * 2;
+		line = find_first_zero_bit(linemap,MAXLINES);
+		if (line >= MAXLINES) {
+			printk(KERN_INFO "linemap is full, added device failed\n");
+			continue;
+		} else
+			__set_bit((int)line, linemap);
+		brd->channels[i]->uart_port.line = line;
 		if (uart_add_one_port (&jsm_uart_driver, &brd->channels[i]->uart_port))
 			printk(KERN_INFO "Added device failed\n");
 		else
@@ -494,6 +503,7 @@ int jsm_remove_uart_port(struct jsm_boar
 
 		ch = brd->channels[i];
 
+		__clear_bit((int)(ch->uart_port.line), linemap);
 		uart_remove_one_port(&jsm_uart_driver, &brd->channels[i]->uart_port);
 	}
 
_

Patches currently in -mm which might be from git.user@gmail.com are

serial-jsm-correctly-support-4-8-port-boards.patch

