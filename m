From: akpm@linux-foundation.org
Subject: + sc26xx-new-serial-driver-for-sc2681-uarts-update.patch added to -mm tree
Date: Tue, 04 Dec 2007 19:27:52 -0800
Message-ID: <200712050327.lB53RqKc019094@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47955 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752791AbXLED2X (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 Dec 2007 22:28:23 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tsbogend@alpha.franken.de, alan@lxorguk.ukuu.org.uk, device@lanana.org, ralf@linux-mips.org


The patch titled
     SC26XX: New serial driver for SC2681 uarts (update)
has been added to the -mm tree.  Its filename is
     sc26xx-new-serial-driver-for-sc2681-uarts-update.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: SC26XX: New serial driver for SC2681 uarts (update)
From: tsbogend@alpha.franken.de (Thomas Bogendoerfer)

   - use container_of
   - remove not needed locking
   - remove inlines
   - fix macros with double argument reference

Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Torben Mathiasen <device@lanana.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/serial/sc26xx.c |   48 ++++++++++++++++++--------------------
 1 file changed, 23 insertions(+), 25 deletions(-)

diff -puN drivers/serial/sc26xx.c~sc26xx-new-serial-driver-for-sc2681-uarts-update drivers/serial/sc26xx.c
--- a/drivers/serial/sc26xx.c~sc26xx-new-serial-driver-for-sc2681-uarts-update
+++ a/drivers/serial/sc26xx.c
@@ -53,8 +53,8 @@ struct uart_sc26xx_port {
 #define WR_OPR_CLR  0x3C
 
 /* access common register */
-#define READ_SC(p, r)        readb ((p)->membase + RD_##r)
-#define WRITE_SC(p, r, v)    writeb ((v), (p)->membase + WR_##r)
+#define READ_SC(p, r)        readb((p)->membase + RD_##r)
+#define WRITE_SC(p, r, v)    writeb((v), (p)->membase + WR_##r)
 
 /* register per port */
 #define RD_PORT_MRx 0x00
@@ -66,12 +66,6 @@ struct uart_sc26xx_port {
 #define WR_PORT_CR  0x08
 #define WR_PORT_THR 0x0c
 
-/* access port register */
-#define READ_SC_PORT(p, r)     \
-		readb((p)->membase + (p)->line * 0x20 + RD_PORT_##r)
-#define WRITE_SC_PORT(p, r, v) \
-		writeb((v), (p)->membase + (p)->line * 0x20 + WR_PORT_##r)
-
 /* SR bits */
 #define SR_BREAK    (1 << 7)
 #define SR_FRAME    (1 << 6)
@@ -100,13 +94,27 @@ struct uart_sc26xx_port {
 #define IMR_RXRDY   (1 << 1)
 #define IMR_TXRDY   (1 << 0)
 
+/* access port register */
+static inline u8 read_sc_port(struct uart_port *p, u8 reg)
+{
+	return readb(p->membase + p->line * 0x20 + reg);
+}
+
+static inline void write_sc_port(struct uart_port *p, u8 reg, u8 val)
+{
+	writeb(val, p->membase + p->line * 0x20 + reg);
+}
+
+#define READ_SC_PORT(p, r)     read_sc_port(p, RD_PORT_##r)
+#define WRITE_SC_PORT(p, r, v) write_sc_port(p, WR_PORT_##r, v)
+
 static void sc26xx_enable_irq(struct uart_port *port, int mask)
 {
 	struct uart_sc26xx_port *up;
 	int line = port->line;
 
 	port -= line;
-	up = (struct uart_sc26xx_port *)port;
+	up = container_of(port, struct uart_sc26xx_port, port[0]);
 
 	up->imr |= mask << (line * 4);
 	WRITE_SC(port, IMR, up->imr);
@@ -118,7 +126,7 @@ static void sc26xx_disable_irq(struct ua
 	int line = port->line;
 
 	port -= line;
-	up = (struct uart_sc26xx_port *)port;
+	up = container_of(port, struct uart_sc26xx_port, port[0]);
 
 	up->imr &= ~(mask << (line * 4));
 	WRITE_SC(port, IMR, up->imr);
@@ -242,13 +250,7 @@ static irqreturn_t sc26xx_interrupt(int 
 /* port->lock is not held.  */
 static unsigned int sc26xx_tx_empty(struct uart_port *port)
 {
-	unsigned long flags;
-	unsigned int ret;
-
-	spin_lock_irqsave(&port->lock, flags);
-	ret = (READ_SC_PORT(port, SR) & SR_TXRDY) ? TIOCSER_TEMT : 0;
-	spin_unlock_irqrestore(&port->lock, flags);
-	return ret;
+	return (READ_SC_PORT(port, SR) & SR_TXRDY) ? TIOCSER_TEMT : 0;
 }
 
 /* port->lock held by caller.  */
@@ -258,7 +260,7 @@ static void sc26xx_set_mctrl(struct uart
 	int line = port->line;
 
 	port -= line;
-	up = (struct uart_sc26xx_port *)port;
+	up = container_of(port, struct uart_sc26xx_port, port[0]);
 
 	if (up->dtr_mask[line]) {
 		if (mctrl & TIOCM_DTR)
@@ -283,7 +285,7 @@ static unsigned int sc26xx_get_mctrl(str
 	u8 ipr;
 
 	port -= line;
-	up = (struct uart_sc26xx_port *)port;
+	up = container_of(port, struct uart_sc26xx_port, port[0]);
 	ipr = READ_SC(port, IPR) ^ 0xff;
 
 	if (up->dsr_mask[line]) {
@@ -340,14 +342,10 @@ static void sc26xx_enable_ms(struct uart
 /* port->lock is not held.  */
 static void sc26xx_break_ctl(struct uart_port *port, int break_state)
 {
-	unsigned long flags;
-
-	spin_lock_irqsave(&port->lock, flags);
 	if (break_state == -1)
 		WRITE_SC_PORT(port, CR, CR_STRT_BRK);
 	else
 		WRITE_SC_PORT(port, CR, CR_STOP_BRK);
-	spin_unlock_irqrestore(&port->lock, flags);
 }
 
 /* port->lock is not held.  */
@@ -539,7 +537,7 @@ static struct uart_ops sc26xx_ops = {
 static struct uart_port *sc26xx_port;
 
 #ifdef CONFIG_SERIAL_SC26XX_CONSOLE
-static inline void sc26xx_console_putchar(struct uart_port *port, char c)
+static void sc26xx_console_putchar(struct uart_port *port, char c)
 {
 	unsigned long flags;
 	int limit = 1000000;
@@ -612,7 +610,7 @@ static struct uart_driver sc26xx_reg = {
 	.cons                   = SC26XX_CONSOLE,
 };
 
-static inline u8 sc26xx_flags2mask(unsigned int flags, unsigned int bitpos)
+static u8 sc26xx_flags2mask(unsigned int flags, unsigned int bitpos)
 {
 	unsigned int bit = (flags >> bitpos) & 15;
 
_

Patches currently in -mm which might be from tsbogend@alpha.franken.de are

git-mips.patch
git-netdev-all.patch
serial-use-sgi_has_zilog-for-ip22_zilog-depends.patch
char-use-sgi_has_ds1286-for-sgi_ds1286-depends.patch
sc26xx-new-serial-driver-for-sc2681-uarts.patch
sc26xx-new-serial-driver-for-sc2681-uarts-update.patch
