From: akpm@linux-foundation.org
Subject: - dz-add-and-reorder-inclusions-remove-unneeded-ones.patch removed from -mm tree
Date: Fri, 08 Feb 2008 00:06:19 -0800
Message-ID: <200802080806.m18860Uj014390@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51575 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761506AbYBHITm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Feb 2008 03:19:42 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: macro@linux-mips.org, jirislaby@gmail.com, mm-commits@vger.kernel.org


The patch titled
     dz: add and reorder inclusions, remove unneeded ones
has been removed from the -mm tree.  Its filename was
     dz-add-and-reorder-inclusions-remove-unneeded-ones.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: dz: add and reorder inclusions, remove unneeded ones
From: "Maciej W. Rozycki" <macro@linux-mips.org>

Sort the header inclusions, add a few that are needed but pulled indirectly
only and remove ones that are not really used.

Signed-off-by: Maciej W. Rozycki <macro@linux-mips.org>
Cc: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/serial/dz.c |   23 +++++++++++++----------
 1 file changed, 13 insertions(+), 10 deletions(-)

diff -puN drivers/serial/dz.c~dz-add-and-reorder-inclusions-remove-unneeded-ones drivers/serial/dz.c
--- a/drivers/serial/dz.c~dz-add-and-reorder-inclusions-remove-unneeded-ones
+++ a/drivers/serial/dz.c
@@ -6,7 +6,7 @@
  *
  * Email: olivier.lebaillif@ifrsys.com
  *
- * Copyright (C) 2004, 2006  Maciej W. Rozycki
+ * Copyright (C) 2004, 2006, 2007  Maciej W. Rozycki
  *
  * [31-AUG-98] triemer
  * Changed IRQ to use Harald's dec internals interrupts.h
@@ -32,26 +32,29 @@
 #define SUPPORT_SYSRQ
 #endif
 
+#include <linux/bitops.h>
+#include <linux/compiler.h>
+#include <linux/console.h>
 #include <linux/delay.h>
-#include <linux/module.h>
-#include <linux/interrupt.h>
+#include <linux/errno.h>
 #include <linux/init.h>
-#include <linux/console.h>
+#include <linux/interrupt.h>
+#include <linux/kernel.h>
+#include <linux/major.h>
+#include <linux/module.h>
+#include <linux/serial.h>
+#include <linux/serial_core.h>
 #include <linux/sysrq.h>
 #include <linux/tty.h>
-#include <linux/tty_flip.h>
-#include <linux/serial_core.h>
-#include <linux/serial.h>
 
 #include <asm/bootinfo.h>
+#include <asm/system.h>
+
 #include <asm/dec/interrupts.h>
 #include <asm/dec/kn01.h>
 #include <asm/dec/kn02.h>
 #include <asm/dec/machtype.h>
 #include <asm/dec/prom.h>
-#include <asm/irq.h>
-#include <asm/system.h>
-#include <asm/uaccess.h>
 
 #include "dz.h"
 
_

Patches currently in -mm which might be from macro@linux-mips.org are

origin.patch
