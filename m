From: akpm@linux-foundation.org
Subject: - blackfin-serial-driver-fix-building-when-debug-is-enabled-but-serial-console-is-disabled.patch removed from -mm tree
Date: Tue, 07 Apr 2009 12:05:01 -0700
Message-ID: <200904071905.n37J514E010192@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41805 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753335AbZDGTIr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 Apr 2009 15:08:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vapier.adi@gmail.com, alan@lxorguk.ukuu.org.uk, cooloney@kernel.org, mm-commits@vger.kernel.org


The patch titled
     blackfin serial driver: fix building when debug is enabled but serial console is disabled
has been removed from the -mm tree.  Its filename was
     blackfin-serial-driver-fix-building-when-debug-is-enabled-but-serial-console-is-disabled.patch

This patch was dropped because someone merged some of these and fiddled with them - I lost the plot

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: blackfin serial driver: fix building when debug is enabled but serial console is disabled
From: Mike Frysinger <vapier.adi@gmail.com>

Signed-off-by: Mike Frysinger <vapier.adi@gmail.com>
Signed-off-by: Bryan Wu <cooloney@kernel.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/serial/bfin_5xx.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN drivers/serial/bfin_5xx.c~blackfin-serial-driver-fix-building-when-debug-is-enabled-but-serial-console-is-disabled drivers/serial/bfin_5xx.c
--- a/drivers/serial/bfin_5xx.c~blackfin-serial-driver-fix-building-when-debug-is-enabled-but-serial-console-is-disabled
+++ a/drivers/serial/bfin_5xx.c
@@ -1256,8 +1256,10 @@ void bfin_serial_debug(const char *fmt, 
 	char buf[128];
 	va_list ap;
 
+#ifdef CONFIG_SERIAL_BFIN_CONSOLE
 	if (bfin_serial_console.index < 0)
 		return;		/* Too early. */
+#endif
 
 	va_start(ap, fmt);
 	vsprintf(buf, fmt, ap);
_

Patches currently in -mm which might be from vapier.adi@gmail.com are

origin.patch
linux-next.patch
blackfin-serial-driver-fix-building-when-debug-is-enabled-but-serial-console-is-disabled.patch
blackfin-serial-driver-use-the-dlab-macro-to-hide-variant-differences.patch

