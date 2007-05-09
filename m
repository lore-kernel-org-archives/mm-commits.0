From: akpm@linux-foundation.org
Subject: - char-cyclades-fix-blockmove.patch removed from -mm tree
Date: Tue, 08 May 2007 19:58:21 -0700
Message-ID: <200705090258.l492wLqf010282@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:36280 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S970133AbXEIC6Y (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 22:58:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jirislaby@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Char: cyclades, fix blockmove
has been removed from the -mm tree.  Its filename was
     char-cyclades-fix-blockmove.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Char: cyclades, fix blockmove
From: Jiri Slaby <jirislaby@gmail.com>

tty has no longer flip buffers accessible externally. Fix it by moving the
code to the tty_*flip* helpers.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/cyclades.c |   34 ++++++++++++++++------------------
 1 file changed, 16 insertions(+), 18 deletions(-)

diff -puN drivers/char/cyclades.c~char-cyclades-fix-blockmove drivers/char/cyclades.c
--- a/drivers/char/cyclades.c~char-cyclades-fix-blockmove
+++ a/drivers/char/cyclades.c
@@ -1560,7 +1560,7 @@ cyz_handle_rx(struct cyclades_port *info
 	int char_count;
 	int len;
 #ifdef BLOCKMOVE
-	int small_count;
+	unsigned char *buf;
 #else
 	char data;
 #endif
@@ -1596,25 +1596,23 @@ cyz_handle_rx(struct cyclades_port *info
 		/* we'd like to use memcpy(t, f, n) and memset(s, c, count)
 		   for performance, but because of buffer boundaries, there
 		   may be several steps to the operation */
-			while (0 < (small_count = min_t(unsigned int,
-					rx_bufsize - new_rx_get,
-					min_t(unsigned int, TTY_FLIPBUF_SIZE -
-						tty->flip.count, char_count)))){
-				memcpy_fromio(tty->flip.char_buf_ptr,
-					(char *)(cinfo->base_addr + rx_bufaddr +
-						new_rx_get),
-					small_count);
+			while (1) {
+				len = tty_prepare_flip_string(tty, &buf,
+						char_count);
+				if (!len)
+					break;
 
-				tty->flip.char_buf_ptr += small_count;
-				memset(tty->flip.flag_buf_ptr, TTY_NORMAL,
-					small_count);
-				tty->flip.flag_buf_ptr += small_count;
-				new_rx_get = (new_rx_get + small_count) &
+				len = min_t(unsigned int, min(len, char_count),
+						rx_bufsize - new_rx_get);
+
+				memcpy_fromio(buf, cinfo->base_addr +
+						rx_bufaddr + new_rx_get, len);
+
+				new_rx_get = (new_rx_get + len) &
 						(rx_bufsize - 1);
-				char_count -= small_count;
-				info->icount.rx += small_count;
-				info->idle_stats.recv_bytes += small_count;
-				tty->flip.count += small_count;
+				char_count -= len;
+				info->icount.rx += len;
+				info->idle_stats.recv_bytes += len;
 			}
 #else
 			len = tty_buffer_request_room(tty, char_count);
_

Patches currently in -mm which might be from jirislaby@gmail.com are

origin.patch
git-dvb.patch
cinergyt2-fix-file-release-handler.patch
auerswald-fix-file-release-handler.patch
unify-queue_delayed_work-and-queue_delayed_work_on.patch
vmstat-use-our-own-timer-events-fix.patch
shrink_slab-handle-bad-shrinkers.patch
