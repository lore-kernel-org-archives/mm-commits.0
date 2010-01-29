From: akpm@linux-foundation.org
Subject: [merged] serial-bfin_5xx-kgdboc-should-accept-gdb-break-only-when-it-is-active.patch removed from -mm tree
Date: Fri, 29 Jan 2010 12:16:53 -0800
Message-ID: <201001292016.o0TKGrm2003267@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36095 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754864Ab0A2USH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 29 Jan 2010 15:18:07 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sonic.zhang@analog.com, alan@lxorguk.ukuu.org.uk, stable@kernel.org, vapier@gentoo.org, mm-commits@vger.kernel.org


The patch titled
     serial: bfin_5xx: kgdboc should accept gdb break only when it is active
has been removed from the -mm tree.  Its filename was
     serial-bfin_5xx-kgdboc-should-accept-gdb-break-only-when-it-is-active.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

