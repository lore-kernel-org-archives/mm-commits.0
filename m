From: akpm@linux-foundation.org
Subject: - netconsole-use-netif_running-in-write_msg.patch removed from -mm tree
Date: Tue, 14 Aug 2007 12:13:06 -0700
Message-ID: <200708141913.l7EJD6oP016473@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48393 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932775AbXHNTU7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 14 Aug 2007 15:20:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: satyam@infradead.org, k-keiichi@bx.jp.nec.com, mpm@selenic.com, mm-commits@vger.kernel.org


The patch titled
     netconsole: Use netif_running() in write_msg()
has been removed from the -mm tree.  Its filename was
     netconsole-use-netif_running-in-write_msg.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: netconsole: Use netif_running() in write_msg()
From: Satyam Sharma <satyam@infradead.org>

Based upon initial work by Keiichi Kii <k-keiichi@bx.jp.nec.com>.

Avoid unnecessarily disabling interrupts and calling netpoll_send_udp() if the
corresponding local interface is not up.

Signed-off-by: Satyam Sharma <satyam@infradead.org>
Acked-by: Keiichi Kii <k-keiichi@bx.jp.nec.com>
Cc: Matt Mackall <mpm@selenic.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/netconsole.c |   18 +++++++++---------
 1 files changed, 9 insertions(+), 9 deletions(-)

diff -puN drivers/net/netconsole.c~netconsole-use-netif_running-in-write_msg drivers/net/netconsole.c
--- a/drivers/net/netconsole.c~netconsole-use-netif_running-in-write_msg
+++ a/drivers/net/netconsole.c
@@ -75,16 +75,16 @@ static void write_msg(struct console *co
 	int frag, left;
 	unsigned long flags;
 
-	local_irq_save(flags);
-
-	for (left = len; left;) {
-		frag = min(left, MAX_PRINT_CHUNK);
-		netpoll_send_udp(&np, msg, frag);
-		msg += frag;
-		left -= frag;
+	if (netif_running(np.dev)) {
+		local_irq_save(flags);
+		for (left = len; left;) {
+			frag = min(left, MAX_PRINT_CHUNK);
+			netpoll_send_udp(&np, msg, frag);
+			msg += frag;
+			left -= frag;
+		}
+		local_irq_restore(flags);
 	}
-
-	local_irq_restore(flags);
 }
 
 static struct console netconsole = {
_

Patches currently in -mm which might be from satyam@infradead.org are

git-netdev-all.patch
git-net.patch
introduce-u16_max-and-u32_max.patch
introduce-strtol_check_range.patch
use-mutex-instead-of-semaphore-in-the-onstream-scsi-tape-driver.patch
argv_split-allow-argv_split-to-handle-null-pointer-in-argcp-parameter-gracefully.patch
