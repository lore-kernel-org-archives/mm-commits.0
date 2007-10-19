From: akpm@linux-foundation.org
Subject: + dz-add-and-reorder-inclusions-remove-unneeded-ones.patch added to -mm tree
Date: Fri, 19 Oct 2007 14:25:59 -0700
Message-ID: <200710192125.l9JLPxHF020934@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39057 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934007AbXJSV0r (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 19 Oct 2007 17:26:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: macro@linux-mips.org, jirislaby@gmail.com


The patch titled
     dz: add and reorder inclusions, remove unneeded ones
has been added to the -mm tree.  Its filename is
     dz-add-and-reorder-inclusions-remove-unneeded-ones.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
kernel-printkc-concerns-about-the-console-handover.patch
dzh-remove-useless-unused-module-junk.patch
dz-always-check-if-it-is-safe-to-console_putchar.patch
dz-dont-panic-when-request_irq-fails.patch
dz-add-and-reorder-inclusions-remove-unneeded-ones.patch
dz-update-kconfig-description.patch
dz-rename-the-serial-console-structure.patch
dz-fix-locking-issues.patch
dz-handle-special-conditions-on-reception-correctly.patch
maintainers-add-self-for-the-dz-serial-driver.patch
