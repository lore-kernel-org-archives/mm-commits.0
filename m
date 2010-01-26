From: akpm@linux-foundation.org
Subject: + serial-bfin_5xx-kgdboc-should-accept-gdb-break-only-when-it-is-active.patch added to -mm tree
Date: Mon, 25 Jan 2010 16:11:32 -0800
Message-ID: <201001260011.o0Q0BWbK019463@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44549 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751466Ab0AZALm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 25 Jan 2010 19:11:42 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sonic.zhang@analog.com, alan@lxorguk.ukuu.org.uk, vapier@gentoo.org


The patch titled
     serial: bfin_5xx: kgdboc should accept gdb break only when it is active
has been added to the -mm tree.  Its filename is
     serial-bfin_5xx-kgdboc-should-accept-gdb-break-only-when-it-is-active.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: serial: bfin_5xx: kgdboc should accept gdb break only when it is active
From: Sonic Zhang <sonic.zhang@analog.com>

If we always check for gdb breaks even when it isn't active, we get false
positives on normal code and the system panics.

URL: http://blackfin.uclinux.org/gf/tracker/5277

Signed-off-by: Sonic Zhang <sonic.zhang@analog.com>
Signed-off-by: Mike Frysinger <vapier@gentoo.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/serial/bfin_5xx.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN drivers/serial/bfin_5xx.c~serial-bfin_5xx-kgdboc-should-accept-gdb-break-only-when-it-is-active drivers/serial/bfin_5xx.c
--- a/drivers/serial/bfin_5xx.c~serial-bfin_5xx-kgdboc-should-accept-gdb-break-only-when-it-is-active
+++ a/drivers/serial/bfin_5xx.c
@@ -237,7 +237,8 @@ static void bfin_serial_rx_chars(struct 
 
 #if defined(CONFIG_KGDB_SERIAL_CONSOLE) || \
 	defined(CONFIG_KGDB_SERIAL_CONSOLE_MODULE)
-	if (kgdb_connected && kgdboc_port_line == uart->port.line)
+	if (kgdb_connected && kgdboc_port_line == uart->port.line
+		&& kgdboc_break_enabled)
 		if (ch == 0x3) {/* Ctrl + C */
 			kgdb_breakpoint();
 			return;
_

Patches currently in -mm which might be from sonic.zhang@analog.com are

linux-next.patch
serial-bfin_5xx-remove-useless-gpio-handling-with-hard-flow-control.patch
serial-bfin_5xx-kgdboc-should-accept-gdb-break-only-when-it-is-active.patch
serial-bfin_5xx-pull-in-linux-ioh-for-ioremap-prototypes.patch

