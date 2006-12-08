From: akpm@osdl.org
Subject: - char-cyclades-fix-warnings.patch removed from -mm tree
Date: Fri, 08 Dec 2006 12:10:39 -0800
Message-ID: <200612082010.kB8KAdgK002832@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:58899 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946532AbWLHUKn (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 15:10:43 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jirislaby@gmail.com, alan@lxorguk.ukuu.org.uk, mm-commits@vger.kernel.org


The patch titled
     Char: cyclades, fix warnings
has been removed from the -mm tree.  Its filename was
     char-cyclades-fix-warnings.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Char: cyclades, fix warnings
From: Jiri Slaby <jirislaby@gmail.com>

fix gcc signed/unsigned warnings

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/char/cyclades.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN drivers/char/cyclades.c~char-cyclades-fix-warnings drivers/char/cyclades.c
--- a/drivers/char/cyclades.c~char-cyclades-fix-warnings
+++ a/drivers/char/cyclades.c
@@ -1644,7 +1644,8 @@ cyz_handle_rx(struct cyclades_port *info
 				char_count = rx_put - rx_get;
 			else
 				char_count = rx_put - rx_get + rx_bufsize;
-			if (char_count >= cy_readl(&buf_ctrl->rx_threshold)) {
+			if (char_count >= (int)cy_readl(&buf_ctrl->
+					rx_threshold)) {
 				cy_sched_event(info, Cy_EVENT_Z_RX_FULL);
 			}
 #endif
@@ -2941,7 +2942,7 @@ static void cy_put_char(struct tty_struc
 		return;
 
 	CY_LOCK(info, flags);
-	if (info->xmit_cnt >= SERIAL_XMIT_SIZE - 1) {
+	if (info->xmit_cnt >= (int)(SERIAL_XMIT_SIZE - 1)) {
 		CY_UNLOCK(info, flags);
 		return;
 	}
_

Patches currently in -mm which might be from jirislaby@gmail.com are

char-cyclades-fix-warnings.patch

