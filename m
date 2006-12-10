From: akpm@osdl.org
Subject: + tty-export-get_current_tty.patch added to -mm tree
Date: Sun, 10 Dec 2006 10:04:16 -0800
Message-ID: <200612101804.kBAI4G8G030963@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:44851 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762292AbWLJSE1 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 10 Dec 2006 13:04:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: heiko.carstens@de.ibm.com, a.p.zijlstra@chello.nl, schwidefsky@de.ibm.com


The patch titled
     tty: export get_current_tty
has been added to the -mm tree.  Its filename is
     tty-export-get_current_tty.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: tty: export get_current_tty
From: Heiko Carstens <heiko.carstens@de.ibm.com>

24ec839c431eb79bb8f6abc00c4e1eb3b8c4d517 causes this:

WARNING: "get_current_tty" [drivers/s390/char/fs3270.ko] undefined!

Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/char/tty_io.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/char/tty_io.c~tty-export-get_current_tty drivers/char/tty_io.c
--- a/drivers/char/tty_io.c~tty-export-get_current_tty
+++ a/drivers/char/tty_io.c
@@ -3821,6 +3821,7 @@ struct tty_struct *get_current_tty(void)
 	barrier();
 	return tty;
 }
+EXPORT_SYMBOL_GPL(get_current_tty);
 
 /*
  * Initialize the console device. This is called *early*, so
_

Patches currently in -mm which might be from heiko.carstens@de.ibm.com are

origin.patch
tty-export-get_current_tty.patch
scsi-fix-uaccess-handling.patch

