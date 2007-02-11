From: akpm@linux-foundation.org
Subject: - uml-sigio-formatting-fixes.patch removed from -mm tree
Date: Sun, 11 Feb 2007 14:49:35 -0800
Message-ID: <200702112249.l1BMnZPX015766@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:59886 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932712AbXBKWth (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 11 Feb 2007 17:49:37 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jdike@addtoit.com, blaisorblade@yahoo.it, mm-commits@vger.kernel.org


The patch titled
     uml: SIGIO formatting fixes
has been removed from the -mm tree.  Its filename was
     uml-sigio-formatting-fixes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: uml: SIGIO formatting fixes
From: Jeff Dike <jdike@addtoit.com>

Fix formatting in the sigio code.

Signed-off-by: Jeff Dike <jdike@addtoit.com>
Cc: Paolo 'Blaisorblade' Giarrusso <blaisorblade@yahoo.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/include/sigio.h |   11 -----------
 arch/um/kernel/sigio.c  |    6 +++---
 2 files changed, 3 insertions(+), 14 deletions(-)

diff -puN arch/um/include/sigio.h~uml-sigio-formatting-fixes arch/um/include/sigio.h
--- a/arch/um/include/sigio.h~uml-sigio-formatting-fixes
+++ a/arch/um/include/sigio.h
@@ -12,14 +12,3 @@ extern void sigio_lock(void);
 extern void sigio_unlock(void);
 
 #endif
-
-/*
- * Overrides for Emacs so that we follow Linus's tabbing style.
- * Emacs will notice this stuff at the end of the file and automatically
- * adjust the settings for this buffer only.  This must remain at the end
- * of the file.
- * ---------------------------------------------------------------------------
- * Local variables:
- * c-file-style: "linux"
- * End:
- */
diff -puN arch/um/kernel/sigio.c~uml-sigio-formatting-fixes arch/um/kernel/sigio.c
--- a/arch/um/kernel/sigio.c~uml-sigio-formatting-fixes
+++ a/arch/um/kernel/sigio.c
@@ -23,7 +23,7 @@ static irqreturn_t sigio_interrupt(int i
 
 	os_read_file(sigio_irq_fd, &c, sizeof(c));
 	reactivate_fd(sigio_irq_fd, SIGIO_WRITE_IRQ);
-	return(IRQ_HANDLED);
+	return IRQ_HANDLED;
 }
 
 int write_sigio_irq(int fd)
@@ -36,10 +36,10 @@ int write_sigio_irq(int fd)
 	if(err){
 		printk("write_sigio_irq : um_request_irq failed, err = %d\n",
 		       err);
-		return(-1);
+		return -1;
 	}
 	sigio_irq_fd = fd;
-	return(0);
+	return 0;
 }
 
 /* These are called from os-Linux/sigio.c to protect its pollfds arrays. */
_

Patches currently in -mm which might be from jdike@addtoit.com are

origin.patch
uml-fix-prototypes.patch
dynamic-kernel-command-line-common.patch
dynamic-kernel-command-line-um.patch
