From: akpm@linux-foundation.org
Subject: [obsolete]
 drivers-tty-serial-sh-scic-suppress-uninitialized-var-warning.patch removed
 from -mm tree
Date: Thu, 25 Jun 2020 16:17:17 -0700
Message-ID: <20200625231717.RMMx7%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:38160 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2406523AbgFYXRS (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 25 Jun 2020 19:17:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, jslaby@suse.com, gregkh@linuxfoundation.org, akpm@linux-foundation.org


The patch titled
     Subject: drivers/tty/serial/sh-sci.c: suppress uninitialized var warning
has been removed from the -mm tree.  Its filename was
     drivers-tty-serial-sh-scic-suppress-uninitialized-var-warning.patch

This patch was dropped because it is obsolete

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: drivers/tty/serial/sh-sci.c: suppress uninitialized var warning

drivers/tty/serial/sh-sci.c: In function sci_dma_rx_submit:
./include/linux/spinlock.h:288:3: warning: flags may be used uninitialized in this function [-Wmaybe-uninitialized]
   _raw_spin_unlock_irqrestore(lock, flags); \
   ^~~~~~~~~~~~~~~~~~~~~~~~~~~
drivers/tty/serial/sh-sci.c:1348:16: note: flags was declared here
  unsigned long flags;

Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jiri Slaby <jslaby@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/tty/serial/sh-sci.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/tty/serial/sh-sci.c~drivers-tty-serial-sh-scic-suppress-uninitialized-var-warning
+++ a/drivers/tty/serial/sh-sci.c
@@ -1352,7 +1352,7 @@ static int sci_dma_rx_submit(struct sci_
 {
 	struct dma_chan *chan = s->chan_rx;
 	struct uart_port *port = &s->port;
-	unsigned long flags;
+	unsigned long uninitialized_var(flags);
 	int i;
 
 	for (i = 0; i < 2; i++) {
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm.patch
mm-memcg-percpu-account-percpu-memory-to-memory-cgroups-fix.patch
mm-memcg-percpu-account-percpu-memory-to-memory-cgroups-fix-fix.patch
mm-madvise-introduce-process_madvise-syscall-an-external-memory-hinting-api-fix.patch
mm-madvise-introduce-process_madvise-syscall-an-external-memory-hinting-api-fix-2.patch
kernel-forkc-export-kernel_thread-to-modules.patch
