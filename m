From: akpm@osdl.org
Subject: + mxser-remove-useless-fields.patch added to -mm tree
Date: Fri, 26 Jan 2007 11:55:53 -0800
Message-ID: <200701261955.l0QJtrRH025034@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:52349 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161252AbXAZTz7 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 26 Jan 2007 14:55:59 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: clg@fr.ibm.com, jirislaby@gmail.com


The patch titled
     mxser: remove useless fields
has been added to the -mm tree.  Its filename is
     mxser-remove-useless-fields.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: mxser: remove useless fields
From: Cedric Le Goater <clg@fr.ibm.com>

the session and pgrp fields in mxser_struct are unused.

Signed-off-by: Cedric Le Goater <clg@fr.ibm.com>
Cc: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/char/mxser.c |    7 +------
 1 files changed, 1 insertion(+), 6 deletions(-)

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

namespaces-fix-exit-race-by-splitting-exit.patch
kthread-api-conversion-for-dvb_frontend-and-av7110.patch
mxser-remove-useless-fields.patch
nsproxy-externalizes-exit_task_namespaces.patch
user-namespace-add-the-framework.patch
user_ns-handle-file-sigio-fix.patch
rename-attach_pid-to-find_attach_pid.patch
attach_pid-with-struct-pid-parameter.patch
remove-find_attach_pid.patch
statically-initialize-struct-pid-for-swapper.patch
explicitly-set-pgid-sid-of-init.patch
uts-namespace-remove-config_uts_ns.patch
ipc-namespace-remove-config_ipc_ns.patch
statistics-replace-inode-ugeneric_ip-with-i_private.patch
