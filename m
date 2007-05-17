From: akpm@linux-foundation.org
Subject: + x86-early_print-kernel-console-should-send-crlf-not-lfcr.patch added to -mm tree
Date: Thu, 17 May 2007 12:21:47 -0700
Message-ID: <200705171921.l4HJLlQe030976@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40952 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756745AbXEQTZg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 17 May 2007 15:25:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: Yinghai.Lu@Sun.COM, ak@suse.de, rmk@arm.linux.org.uk, rmk@dyn-67.arm.linux.org.uk, yinghai.lu@Sun.COM


The patch titled
     x86: early_print kernel console should send CRLF not LFCR
has been added to the -mm tree.  Its filename is
     x86-early_print-kernel-console-should-send-crlf-not-lfcr.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

serial-set-dtr-in-uart-for-kernel-serial-console.patch
x86-early_print-kernel-console-should-send-crlf-not-lfcr.patch
