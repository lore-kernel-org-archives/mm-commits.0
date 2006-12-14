From: akpm@osdl.org
Subject: - tty-export-get_current_tty.patch removed from -mm tree
Date: Wed, 13 Dec 2006 21:59:50 -0800
Message-ID: <200612140559.kBE5xoIG001621@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:51362 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751820AbWLNGAu (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 14 Dec 2006 01:00:50 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: heiko.carstens@de.ibm.com, a.p.zijlstra@chello.nl, schwidefsky@de.ibm.com, mm-commits@vger.kernel.org


The patch titled
     tty: export get_current_tty
has been removed from the -mm tree.  Its filename was
     tty-export-get_current_tty.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

scsi-fix-uaccess-handling.patch

