From: akpm@linux-foundation.org
Subject: - x86-early_print-kernel-console-should-send-crlf-not-lfcr.patch removed from -mm tree
Date: Mon, 21 May 2007 13:09:44 -0700
Message-ID: <200705212009.l4LK9h99018783@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59871 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756591AbXEUUNV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 21 May 2007 16:13:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Yinghai.Lu@Sun.COM, ak@suse.de, rmk@arm.linux.org.uk, rmk@dyn-67.arm.linux.org.uk, yinghai.lu@Sun.COM, mm-commits@vger.kernel.org


The patch titled
     x86: early_print kernel console should send CRLF not LFCR
has been removed from the -mm tree.  Its filename was
     x86-early_print-kernel-console-should-send-crlf-not-lfcr.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: x86: early_print kernel console should send CRLF not LFCR
From: Yinghai Lu <Yinghai.Lu@Sun.COM>

In
	commit d358788f3f30113e49882187d794832905e42592
	Author: Russell King <rmk@dyn-67.arm.linux.org.uk>
	Date:   Mon Mar 20 20:00:09 2006 +0000

        Glen Turner reported that writing LFCR rather than the more
        traditional CRLF causes issues with some terminals.

        Since this aflicts many serial drivers, extract the common
        code to a library function (uart_console_write) and arrange for each
        driver to supply a "putchar" function.

but early_printk is left out.

Signed-off-by: Yinghai Lu <yinghai.lu@sun.com>
Cc: Andi Kleen <ak@suse.de>
Cc: Russell King <rmk@arm.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86_64/kernel/early_printk.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/x86_64/kernel/early_printk.c~x86-early_print-kernel-console-should-send-crlf-not-lfcr arch/x86_64/kernel/early_printk.c
--- a/arch/x86_64/kernel/early_printk.c~x86-early_print-kernel-console-should-send-crlf-not-lfcr
+++ a/arch/x86_64/kernel/early_printk.c
@@ -91,9 +91,9 @@ static int early_serial_putc(unsigned ch
 static void early_serial_write(struct console *con, const char *s, unsigned n)
 {
 	while (*s && n-- > 0) {
-		early_serial_putc(*s);
 		if (*s == '\n')
 			early_serial_putc('\r');
+		early_serial_putc(*s);
 		s++;
 	}
 }
_

Patches currently in -mm which might be from Yinghai.Lu@Sun.COM are

origin.patch
serial-set-dtr-in-uart-for-kernel-serial-console.patch
