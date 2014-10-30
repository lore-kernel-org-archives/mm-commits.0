From: akpm@linux-foundation.org
Subject: + printk-remove-used-once-early_vprintk.patch added to -mm tree
Date: Thu, 30 Oct 2014 14:55:29 -0700
Message-ID: <5452b3d1.oDfO1VdX5JP8bo2x%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41123 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161234AbaJ3Vz3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 30 Oct 2014 17:55:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, cmetcalf@tilera.com, mm-commits@vger.kernel.org


The patch titled
     Subject: printk: remove used-once early_vprintk
has been added to the -mm tree.  Its filename is
     printk-remove-used-once-early_vprintk.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/printk-remove-used-once-early_vprintk.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/printk-remove-used-once-early_vprintk.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Cc: Chris Metcalf <cmetcalf@tilera.com>
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
printk-remove-used-once-early_vprintk.patch
tile-neaten-early_printk-uses.patch
tile-use-pr_warn-instead-of-pr_warning.patch
maintainers-update-ivtv-mailing-lists-as-subscriber-only.patch
mm-utilc-add-kstrimdup.patch
checkpatch-add-an-error-test-for-no-space-before-comma.patch
checkpatch-add-error-on-use-of-attributeweak-or-__weak-declarations.patch
checkpatch-improve-test-for-no-space-after-cast.patch
checkpatch-improve-warning-message-for-needless-if-case.patch
checkpatch-fix-use-via-symlink-make-missing-spelling-file-non-fatal.patch
checkpatch-try-to-avoid-mask-and-shift-errors.patch
checkpatch-reduce-maintainers-update-message-frequency.patch
binfmt_misc-add-comments-debug-logs.patch
binfmt_misc-clean-up-code-style-a-bit.patch
fs-binfmt_miscc-use-gfp_kernel-instead-of-gfp_user.patch
fs-affs-amigaffsc-use-va_format-instead-of-buffer-vnsprintf.patch
linux-next.patch

