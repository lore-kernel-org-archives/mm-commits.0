From: akpm@linux-foundation.org
Subject: - uml-sigio-locking-comment.patch removed from -mm tree
Date: Sun, 11 Feb 2007 14:49:33 -0800
Message-ID: <200702112249.l1BMnX1Y015763@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:59881 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932710AbXBKWtf (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 11 Feb 2007 17:49:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jdike@addtoit.com, blaisorblade@yahoo.it, mm-commits@vger.kernel.org


The patch titled
     uml: SIGIO locking comment
has been removed from the -mm tree.  Its filename was
     uml-sigio-locking-comment.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: uml: SIGIO locking comment
From: Jeff Dike <jdike@addtoit.com>

Comment the use of a mysterious-looking lock.

Signed-off-by: Jeff Dike <jdike@addtoit.com>
Cc: Paolo 'Blaisorblade' Giarrusso <blaisorblade@yahoo.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/kernel/sigio.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN arch/um/kernel/sigio.c~uml-sigio-locking-comment arch/um/kernel/sigio.c
--- a/arch/um/kernel/sigio.c~uml-sigio-locking-comment
+++ a/arch/um/kernel/sigio.c
@@ -42,6 +42,7 @@ int write_sigio_irq(int fd)
 	return(0);
 }
 
+/* These are called from os-Linux/sigio.c to protect its pollfds arrays. */
 static DEFINE_SPINLOCK(sigio_spinlock);
 
 void sigio_lock(void)
_

Patches currently in -mm which might be from jdike@addtoit.com are

origin.patch
uml-fix-prototypes.patch
dynamic-kernel-command-line-common.patch
dynamic-kernel-command-line-um.patch
