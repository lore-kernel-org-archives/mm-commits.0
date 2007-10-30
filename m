From: akpm@linux-foundation.org
Subject: - serial-fix-serial_txx9-console-initialization.patch removed from -mm tree
Date: Tue, 30 Oct 2007 11:06:36 -0700
Message-ID: <200710301806.l9UI6aKH020536@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51574 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752222AbXJ3SRj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 30 Oct 2007 14:17:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: anemo@mba.ocn.ne.jp, mm-commits@vger.kernel.org


The patch titled
     serial: fix serial_txx9 console initialization
has been removed from the -mm tree.  Its filename was
     serial-fix-serial_txx9-console-initialization.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: serial: fix serial_txx9 console initialization
From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>

Since commit 97d97224ff361e08777fb33e0fd193ca877dac28, serial_core
calls ->pm() on initialization even if the port was used for console.
This behaviour breaks serial_txx9 console since The serial_txx9 driver
initialize its port entirely on its ->pm() method if new state was 0.
This patch adds checking for oldstate value to fix this probelm.

Signed-off-by: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/serial/serial_txx9.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff -puN drivers/serial/serial_txx9.c~serial-fix-serial_txx9-console-initialization drivers/serial/serial_txx9.c
--- a/drivers/serial/serial_txx9.c~serial-fix-serial_txx9-console-initialization
+++ a/drivers/serial/serial_txx9.c
@@ -657,7 +657,15 @@ static void
 serial_txx9_pm(struct uart_port *port, unsigned int state,
 	      unsigned int oldstate)
 {
-	if (state == 0)
+	/*
+	 * If oldstate was -1 this is called from
+	 * uart_configure_port().  In this case do not initialize the
+	 * port now, because the port was already initialized (for
+	 * non-console port) or should not be initialized here (for
+	 * console port).  If we initialized the port here we lose
+	 * serial console settings.
+	 */
+	if (state == 0 && oldstate != -1)
 		serial_txx9_initialize(port);
 }
 
_

Patches currently in -mm which might be from anemo@mba.ocn.ne.jp are

origin.patch
clocksource-make-clocksource_mask-bullet-proof.patch
