From: akpm@linux-foundation.org
Subject: [merged] printk-remove-used-once-early_vprintk.patch removed from -mm tree
Date: Thu, 11 Dec 2014 10:58:42 -0800
Message-ID: <5489e962.qGNO02152OZqYo7e%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45545 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758526AbaLKS6n (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 11 Dec 2014 13:58:43 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, cmetcalf@tilera.com, mm-commits@vger.kernel.org


The patch titled
     Subject: printk: remove used-once early_vprintk
has been removed from the -mm tree.  Its filename was
     printk-remove-used-once-early_vprintk.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: printk: remove used-once early_vprintk

Eliminate the unlikely possibility of message interleaving for
early_printk/early_vprintk use.

early_vprintk can be done via the %pV extension so remove this unnecessary
function and change early_printk to have the equivalent vprintk code.

All uses of early_printk already end with a newline so also remove the
unnecessary newline from the early_printk function.

Signed-off-by: Joe Perches <joe@perches.com>
Acked-by: Chris Metcalf <cmetcalf@tilera.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/tile/kernel/early_printk.c |   19 +++++++++++++------
 include/linux/printk.h          |    1 -
 kernel/printk/printk.c          |   19 ++++++++-----------
 3 files changed, 21 insertions(+), 18 deletions(-)

diff -puN arch/tile/kernel/early_printk.c~printk-remove-used-once-early_vprintk arch/tile/kernel/early_printk.c
--- a/arch/tile/kernel/early_printk.c~printk-remove-used-once-early_vprintk
+++ a/arch/tile/kernel/early_printk.c
@@ -43,13 +43,20 @@ static struct console early_hv_console =
 
 void early_panic(const char *fmt, ...)
 {
-	va_list ap;
+	struct va_format vaf;
+	va_list args;
+
 	arch_local_irq_disable_all();
-	va_start(ap, fmt);
-	early_printk("Kernel panic - not syncing: ");
-	early_vprintk(fmt, ap);
-	early_printk("\n");
-	va_end(ap);
+
+	va_start(args, fmt);
+
+	vaf.fmt = fmt;
+	vaf.va = &args;
+
+	early_printk("Kernel panic - not syncing: %pV", &vaf);
+
+	va_end(args);
+
 	dump_stack();
 	hv_halt();
 }
diff -puN include/linux/printk.h~printk-remove-used-once-early_vprintk include/linux/printk.h
--- a/include/linux/printk.h~printk-remove-used-once-early_vprintk
+++ a/include/linux/printk.h
@@ -118,7 +118,6 @@ int no_printk(const char *fmt, ...)
 #ifdef CONFIG_EARLY_PRINTK
 extern asmlinkage __printf(1, 2)
 void early_printk(const char *fmt, ...);
-void early_vprintk(const char *fmt, va_list ap);
 #else
 static inline __printf(1, 2) __cold
 void early_printk(const char *s, ...) { }
diff -puN kernel/printk/printk.c~printk-remove-used-once-early_vprintk kernel/printk/printk.c
--- a/kernel/printk/printk.c~printk-remove-used-once-early_vprintk
+++ a/kernel/printk/printk.c
@@ -1881,23 +1881,20 @@ static size_t cont_print_text(char *text
 #ifdef CONFIG_EARLY_PRINTK
 struct console *early_console;
 
-void early_vprintk(const char *fmt, va_list ap)
-{
-	if (early_console) {
-		char buf[512];
-		int n = vscnprintf(buf, sizeof(buf), fmt, ap);
-
-		early_console->write(early_console, buf, n);
-	}
-}
-
 asmlinkage __visible void early_printk(const char *fmt, ...)
 {
 	va_list ap;
+	char buf[512];
+	int n;
+
+	if (!early_console)
+		return;
 
 	va_start(ap, fmt);
-	early_vprintk(fmt, ap);
+	n = vscnprintf(buf, sizeof(buf), fmt, ap);
 	va_end(ap);
+
+	early_console->write(early_console, buf, n);
 }
 #endif
 
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
mm-utilc-add-kstrimdup.patch
fs-affs-amigaffsc-use-va_format-instead-of-buffer-vnsprintf.patch
linux-next.patch

