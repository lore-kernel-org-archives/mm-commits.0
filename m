From: akpm@linux-foundation.org
Subject: - mxser-remove-useless-fields.patch removed from -mm tree
Date: Sun, 11 Feb 2007 14:55:13 -0800
Message-ID: <200702112255.l1BMtD4l016302@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:60585 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932872AbXBKWzU (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 11 Feb 2007 17:55:20 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: clg@fr.ibm.com, jirislaby@gmail.com, mm-commits@vger.kernel.org


The patch titled
     mxser: remove useless fields
has been removed from the -mm tree.  Its filename was
     mxser-remove-useless-fields.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: mxser: remove useless fields
From: Cedric Le Goater <clg@fr.ibm.com>

the session and pgrp fields in mxser_struct are unused.

Signed-off-by: Cedric Le Goater <clg@fr.ibm.com>
Cc: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/mxser.c |    7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff -puN drivers/char/mxser.c~mxser-remove-useless-fields drivers/char/mxser.c
--- a/drivers/char/mxser.c~mxser-remove-useless-fields
+++ a/drivers/char/mxser.c
@@ -321,8 +321,6 @@ struct mxser_struct {
 	unsigned long event;
 	int count;		/* # of fd on device */
 	int blocked_open;	/* # of blocked opens */
-	long session;		/* Session of opening process */
-	long pgrp;		/* pgrp of opening process */
 	unsigned char *xmit_buf;
 	int xmit_head;
 	int xmit_tail;
@@ -1001,15 +999,12 @@ static int mxser_open(struct tty_struct 
 		mxser_change_speed(info, NULL);
 	}
 
-	info->session = process_session(current);
-	info->pgrp = process_group(current);
-
 	/*
 	status = mxser_get_msr(info->base, 0, info->port);
 	mxser_check_modem_status(info, status);
 	*/
 
-/* unmark here for very high baud rate (ex. 921600 bps) used */
+	/* unmark here for very high baud rate (ex. 921600 bps) used */
 	tty->low_latency = 1;
 	return 0;
 }
_

Patches currently in -mm which might be from clg@fr.ibm.com are

origin.patch
statistics-replace-inode-ugeneric_ip-with-i_private.patch
