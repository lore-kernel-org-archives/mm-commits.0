From: akpm@linux-foundation.org
Subject: + serial-jsm-correctly-support-4-8-port-boards-update.patch added to -mm tree
Date: Fri, 29 May 2009 12:55:24 -0700
Message-ID: <200905291955.n4TJtObp030060@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35468 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755728AbZE2Tzh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 29 May 2009 15:55:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: git.user@gmail.com, Scott_Kilau@digi.com, adam@os.inf.tu-dresden.de, alan@lxorguk.ukuu.org.ukgit.user@gmail.co, wendyx@us.ibm.com


The patch titled
     serial-jsm-correctly-support-4-8-port-boards-update
has been added to the -mm tree.  Its filename is
     serial-jsm-correctly-support-4-8-port-boards-update.patch

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
Subject: serial-jsm-correctly-support-4-8-port-boards-update
From: "Alexander Y. Fomichev" <git.user@gmail.com>

Signed-off-by: Alexander Y. Fomichev <git.user@gmail.co
Cc: Adam Lackorzynski <adam@os.inf.tu-dresden.de>
Cc: Scott H Kilau <Scott_Kilau@digi.com>
Cc: Wendy Xiong <wendyx@us.ibm.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>m>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/serial/jsm/jsm_tty.c |   14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff -puN drivers/serial/jsm/jsm_tty.c~serial-jsm-correctly-support-4-8-port-boards-update drivers/serial/jsm/jsm_tty.c
--- a/drivers/serial/jsm/jsm_tty.c~serial-jsm-correctly-support-4-8-port-boards-update
+++ a/drivers/serial/jsm/jsm_tty.c
@@ -34,6 +34,7 @@
 #include "jsm.h"
 
 static DECLARE_BITMAP(linemap, MAXLINES);
+static DEFINE_MUTEX(linemap_mutex);
 
 static void jsm_carrier(struct jsm_channel *ch);
 
@@ -449,6 +450,9 @@ int __devinit jsm_uart_port_init(struct 
 
 	brd->nasync = brd->maxports;
 
+	/* protect linemap for whole range of line numbers*/
+	mutex_lock(&linemap_mutex);
+
 	/* Set up channel variables */
 	for (i = 0; i < brd->nasync; i++, ch = brd->channels[i]) {
 
@@ -467,13 +471,14 @@ int __devinit jsm_uart_port_init(struct 
 			printk(KERN_INFO "linemap is full, added device failed\n");
 			continue;
 		} else
-			__set_bit((int)line, linemap);
+			set_bit((int)line, linemap);
 		brd->channels[i]->uart_port.line = line;
 		if (uart_add_one_port (&jsm_uart_driver, &brd->channels[i]->uart_port))
 			printk(KERN_INFO "Added device failed\n");
 		else
 			printk(KERN_INFO "Added device \n");
 	}
+	mutex_unlock(&linemap_mutex);
 
 	jsm_printk(INIT, INFO, &brd->pci_dev, "finish\n");
 	return 0;
@@ -495,6 +500,8 @@ int jsm_remove_uart_port(struct jsm_boar
 
 	brd->nasync = brd->maxports;
 
+	mutex_lock(&linemap_mutex);
+
 	/* Set up channel variables */
 	for (i = 0; i < brd->nasync; i++) {
 
@@ -502,11 +509,12 @@ int jsm_remove_uart_port(struct jsm_boar
 			continue;
 
 		ch = brd->channels[i];
