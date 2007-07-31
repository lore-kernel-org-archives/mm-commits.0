From: akpm@linux-foundation.org
Subject: - sb1250-duart-__maybe_unused-etc-fixes.patch removed from -mm tree
Date: Tue, 31 Jul 2007 16:58:51 -0700
Message-ID: <200707312358.l6VNwpsm029597@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39212 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760258AbXHAAQn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 31 Jul 2007 20:16:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: macro@linux-mips.org, ralf@linux-mips.org, mm-commits@vger.kernel.org


The patch titled
     sb1250-duart: __maybe_unused, etc. fixes
has been removed from the -mm tree.  Its filename was
     sb1250-duart-__maybe_unused-etc-fixes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: sb1250-duart: __maybe_unused, etc. fixes
From: "Maciej W. Rozycki" <macro@linux-mips.org>

This is a set of small fixes addressing points raised with the original
driver submission.  In particular, __maybe_unused is used rather than a
local hack and sbd_ops is made const.  Additionally I have made two local
string variables automatic as rodata space was wasted for pointers
unnecessarily.

Signed-off-by: Maciej W. Rozycki <macro@linux-mips.org>
Cc: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/serial/sb1250-duart.c |   14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff -puN drivers/serial/sb1250-duart.c~sb1250-duart-__maybe_unused-etc-fixes drivers/serial/sb1250-duart.c
--- a/drivers/serial/sb1250-duart.c~sb1250-duart-__maybe_unused-etc-fixes
+++ a/drivers/serial/sb1250-duart.c
@@ -25,6 +25,7 @@
 #define SUPPORT_SYSRQ
 #endif
 
+#include <linux/compiler.h>
 #include <linux/console.h>
 #include <linux/delay.h>
 #include <linux/errno.h>
@@ -103,8 +104,6 @@ struct sbd_duart {
 
 static struct sbd_duart sbd_duarts[DUART_MAX_CHIP];
 
-#define __unused __attribute__((__unused__))
-
 
 /*
  * Reading and writing SB1250 DUART registers.
@@ -204,12 +203,12 @@ static int sbd_receive_drain(struct sbd_
 	return loops;
 }
 
-static int __unused sbd_transmit_ready(struct sbd_port *sport)
+static int __maybe_unused sbd_transmit_ready(struct sbd_port *sport)
 {
 	return read_sbdchn(sport, R_DUART_STATUS) & M_DUART_TX_RDY;
 }
 
-static int __unused sbd_transmit_drain(struct sbd_port *sport)
+static int __maybe_unused sbd_transmit_drain(struct sbd_port *sport)
 {
 	int loops = 10000;
 
@@ -664,7 +663,7 @@ static void sbd_release_port(struct uart
 
 static int sbd_map_port(struct uart_port *uport)
 {
-	static const char *err = KERN_ERR "sbd: Cannot map MMIO\n";
+	const char *err = KERN_ERR "sbd: Cannot map MMIO\n";
 	struct sbd_port *sport = to_sport(uport);
 	struct sbd_duart *duart = sport->duart;
 
@@ -691,8 +690,7 @@ static int sbd_map_port(struct uart_port
 
 static int sbd_request_port(struct uart_port *uport)
 {
-	static const char *err = KERN_ERR
-				 "sbd: Unable to reserve MMIO resource\n";
+	const char *err = KERN_ERR "sbd: Unable to reserve MMIO resource\n";
 	struct sbd_duart *duart = to_sport(uport)->duart;
 	int map_guard;
 	int ret = 0;
@@ -755,7 +753,7 @@ static int sbd_verify_port(struct uart_p
 }
 
 
-static struct uart_ops sbd_ops = {
+static const struct uart_ops sbd_ops = {
 	.tx_empty	= sbd_tx_empty,
 	.set_mctrl	= sbd_set_mctrl,
 	.get_mctrl	= sbd_get_mctrl,
_

Patches currently in -mm which might be from macro@linux-mips.org are

origin.patch
