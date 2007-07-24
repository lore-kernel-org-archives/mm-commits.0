From: akpm@linux-foundation.org
Subject: - netdev-i82596-ethernet-needs-asm-cacheflushh.patch removed from -mm tree
Date: Tue, 24 Jul 2007 16:25:10 -0700
Message-ID: <200707242325.l6ONPACH006340@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49877 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757817AbXGXXg1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 24 Jul 2007 19:36:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: geert@linux-m68k.org, jeff@garzik.org, mm-commits@vger.kernel.org


The patch titled
     ] netdev: i82596 Ethernet needs <asm/cacheflush.h>
has been removed from the -mm tree.  Its filename was
     netdev-i82596-ethernet-needs-asm-cacheflushh.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: ] netdev: i82596 Ethernet needs <asm/cacheflush.h>
From: Geert Uytterhoeven <geert@linux-m68k.org>

netdev: i82596 Ethernet needs <asm/cacheflush.h> on m68k

drivers/net/82596.c: In function 'init_rx_bufs':
drivers/net/82596.c:552: error: implicit declaration of function 'cache_clear'
drivers/net/82596.c: In function 'i596_start_xmit':
drivers/net/82596.c:1104: error: implicit declaration of function 'cache_push'

The driver still compiles on ia32 (CONFIG_APRICOT=y)

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Jeff Garzik <jeff@garzik.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/82596.c |    1 +
 1 files changed, 1 insertion(+)

diff -puN drivers/net/82596.c~netdev-i82596-ethernet-needs-asm-cacheflushh drivers/net/82596.c
--- a/drivers/net/82596.c~netdev-i82596-ethernet-needs-asm-cacheflushh
+++ a/drivers/net/82596.c
@@ -57,6 +57,7 @@
 #include <asm/io.h>
 #include <asm/dma.h>
 #include <asm/pgtable.h>
+#include <asm/cacheflush.h>
 
 static char version[] __initdata =
 	"82596.c $Revision: 1.5 $\n";
_

Patches currently in -mm which might be from geert@linux-m68k.org are

m68k-mac-make-mac_hid_mouse_emulate_buttons.patch
git-netdev-all.patch
during-vm-oom-condition-kill-all-threads-in-process-group.patch
