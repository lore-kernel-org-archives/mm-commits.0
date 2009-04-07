From: akpm@linux-foundation.org
Subject: [merged] jsm-cleanup.patch removed from -mm tree
Date: Tue, 07 Apr 2009 12:10:20 -0700
Message-ID: <200904071910.n37JAKrn012784@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52937 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760858AbZDGTN2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 Apr 2009 15:13:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: leitao@linux.vnet.ibm.com, Scott.Kilau@digi.com, alan@lxorguk.ukuu.org.uk, mm-commits@vger.kernel.org


The patch titled
     jsm: cleanup
has been removed from the -mm tree.  Its filename was
     jsm-cleanup.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: jsm: cleanup
From: Breno Leitao <leitao@linux.vnet.ibm.com>

Here are some cleanups, mainly removing unused variables and silly
declarations.

Signed-off-by: Breno Leitao <leitao@linux.vnet.ibm.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Scott Kilau <Scott.Kilau@digi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/serial/jsm/jsm_neo.c |   14 ++++----------
 drivers/serial/jsm/jsm_tty.c |   19 ++++++++-----------
 2 files changed, 12 insertions(+), 21 deletions(-)

diff -puN drivers/serial/jsm/jsm_neo.c~jsm-cleanup drivers/serial/jsm/jsm_neo.c
--- a/drivers/serial/jsm/jsm_neo.c~jsm-cleanup
+++ a/drivers/serial/jsm/jsm_neo.c
@@ -533,7 +533,6 @@ static void neo_copy_data_from_queue_to_
 	if (!(ch->ch_flags & (CH_TX_FIFO_EMPTY | CH_TX_FIFO_LWM)))
 		return;
 
-	len_written = 0;
 	n = UART_17158_TX_FIFOSIZE - ch->ch_t_tlevel;
 
 	/* cache head and tail of queue */
@@ -619,14 +618,10 @@ static void neo_parse_modem(struct jsm_c
 /* Make the UART raise any of the output signals we want up */
 static void neo_assert_modem_signals(struct jsm_channel *ch)
 {
-	u8 out;
-
 	if (!ch)
 		return;
 
-	out = ch->ch_mostat;
-
-	writeb(out, &ch->ch_neo_uart->mcr);
+	writeb(ch->ch_mostat, &ch->ch_neo_uart->mcr);
 
 	/* flush write operation */
 	neo_pci_posting_flush(ch->ch_bd);
@@ -936,10 +931,9 @@ static inline void neo_parse_lsr(struct 
 static void neo_param(struct jsm_channel *ch)
 {
 	u8 lcr = 0;
-	u8 uart_lcr = 0;
-	u8 ier = 0;
-	u32 baud = 9600;
-	int quot = 0;
+	u8 uart_lcr, ier;
+	u32 baud;
+	int quot;
 	struct jsm_board *bd;
 
 	bd = ch->ch_bd;
diff -puN drivers/serial/jsm/jsm_tty.c~jsm-cleanup drivers/serial/jsm/jsm_tty.c
--- a/drivers/serial/jsm/jsm_tty.c~jsm-cleanup
+++ a/drivers/serial/jsm/jsm_tty.c
@@ -183,7 +183,6 @@ static void jsm_tty_break(struct uart_po
 static int jsm_tty_open(struct uart_port *port)
 {
 	struct jsm_board *brd;
-	int rc = 0;
 	struct jsm_channel *channel = (struct jsm_channel *)port;
 	struct ktermios *termios;
 
@@ -265,7 +264,7 @@ static int jsm_tty_open(struct uart_port
 	channel->ch_open_count++;
 
 	jsm_printk(OPEN, INFO, &channel->ch_bd->pci_dev, "finish\n");
-	return rc;
+	return 0;
 }
 
 static void jsm_tty_close(struct uart_port *port)
@@ -748,7 +747,7 @@ static void jsm_carrier(struct jsm_chann
 void jsm_check_queue_flow_control(struct jsm_channel *ch)
 {
 	struct board_ops *bd_ops = ch->ch_bd->bd_ops;
-	int qleft = 0;
+	int qleft;
 
 	/* Store how much space we have left in the queue */
 	if ((qleft = ch->ch_r_tail - ch->ch_r_head - 1) < 0)
@@ -834,7 +833,7 @@ void jsm_check_queue_flow_control(struct
  */
 int jsm_tty_write(struct uart_port *port)
 {
-	int bufcount = 0, n = 0;
+	int bufcount;
 	int data_count = 0,data_count1 =0;
 	u16 head;
 	u16 tail;
@@ -850,14 +849,12 @@ int jsm_tty_write(struct uart_port *port
 	if ((bufcount = tail - head - 1) < 0)
 		bufcount += WQUEUESIZE;
 
-	n = bufcount;
-
-	n = min(n, 56);
+	bufcount = min(bufcount, 56);
 	remain = WQUEUESIZE - head;
 
 	data_count = 0;
-	if (n >= remain) {
-		n -= remain;
+	if (bufcount >= remain) {
+		bufcount -= remain;
 		while ((port->info->xmit.head != temp_tail) &&
 		(data_count < remain)) {
 			channel->ch_wqueue[head++] =
@@ -871,8 +868,8 @@ int jsm_tty_write(struct uart_port *port
 	}
 
 	data_count1 = 0;
-	if (n > 0) {
-		remain = n;
+	if (bufcount > 0) {
+		remain = bufcount;
 		while ((port->info->xmit.head != temp_tail) &&
 			(data_count1 < remain)) {
 			channel->ch_wqueue[head++] =
_

Patches currently in -mm which might be from leitao@linux.vnet.ibm.com are

origin.patch
linux-next.patch
icom-converting-space-to-tabs.patch

