From: akpm@osdl.org
Subject: - missing-includes-in-hilkbd.patch removed from -mm tree
Date: Wed, 13 Dec 2006 22:11:42 -0800
Message-ID: <200612140611.kBE6BfDP002046@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:52237 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751804AbWLNGMA (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 14 Dec 2006 01:12:00 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: viro@ftp.linux.org.uk, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     missing includes in hilkbd
has been removed from the -mm tree.  Its filename was
     missing-includes-in-hilkbd.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: missing includes in hilkbd
From: Al Viro <viro@ftp.linux.org.uk>

Now that it's built on m68k too...

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/input/keyboard/hilkbd.c |    5 +++++
 1 file changed, 5 insertions(+)

diff -puN drivers/input/keyboard/hilkbd.c~missing-includes-in-hilkbd drivers/input/keyboard/hilkbd.c
--- a/drivers/input/keyboard/hilkbd.c~missing-includes-in-hilkbd
+++ a/drivers/input/keyboard/hilkbd.c
@@ -23,7 +23,12 @@
 #include <linux/init.h>
 #include <linux/interrupt.h>
 #include <linux/hil.h>
+#include <linux/io.h>
 #include <linux/spinlock.h>
+#include <asm/irq.h>
+#ifdef CONFIG_HP300
+#include <asm/hwtest.h>
+#endif
 
 
 MODULE_AUTHOR("Philip Blundell, Matthew Wilcox, Helge Deller");
_

Patches currently in -mm which might be from viro@ftp.linux.org.uk are

m68k-work-around-binutils-tokenizer-change.patch
slab-leaks3-default-y.patch

