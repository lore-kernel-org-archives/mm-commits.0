From: akpm@linux-foundation.org
Subject: - atari_pamsnetc-old-declaration-ritchie-style-fix.patch removed from -mm tree
Date: Tue, 10 Jul 2007 12:48:55 -0700
Message-ID: <200707101948.l6AJmtWr026038@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46246 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758552AbXGJTtC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 10 Jul 2007 15:49:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: padator@wanadoo.fr, mm-commits@vger.kernel.org


The patch titled
     atari_pamsnet.c: old declaration ritchie style fix
has been removed from the -mm tree.  Its filename was
     atari_pamsnetc-old-declaration-ritchie-style-fix.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: atari_pamsnet.c: old declaration ritchie style fix
From: Yoann Padioleau <padator@wanadoo.fr>

Use consistent function declaration style.


Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/atari_pamsnet.c |   62 ++++++++++++----------------------
 1 files changed, 22 insertions(+), 40 deletions(-)

diff -puN drivers/net/atari_pamsnet.c~atari_pamsnetc-old-declaration-ritchie-style-fix drivers/net/atari_pamsnet.c
--- a/drivers/net/atari_pamsnet.c~atari_pamsnetc-old-declaration-ritchie-style-fix
+++ a/drivers/net/atari_pamsnet.c
@@ -295,10 +295,7 @@ int if_up = 0;
 /* Setup the DMA counter */
 
 static void
-setup_dma (address, rw_flag, num_blocks)
-	void *address;
-	unsigned rw_flag;
-	int num_blocks;
+setup_dma (void *address, unsigned rw_flag, int num_blocks)
 {
 	WRITEMODE((unsigned) rw_flag          | DMA_FDC | SEC_COUNT | REG_ACSI |
 		  A1);
@@ -317,9 +314,7 @@ setup_dma (address, rw_flag, num_blocks)
 /* Send the first byte of an command block */
 
 static int
-send_first (target, byte)
-	int target;
-	unsigned char byte;
+send_first (int target, unsigned char byte)
 {
 	rw = READ;
 	acsi_delay_end(COMMAND_DELAY);
@@ -338,10 +333,7 @@ send_first (target, byte)
 /* Send the rest of an command block */
 
 static int
-send_1_5 (lun, command, dma)
-	int lun;
-	unsigned char *command;
-	int dma;
+send_1_5 (int lun, unsigned char *command, int dma)
 {
 	int i, j;
 
@@ -371,8 +363,7 @@ get_status (void)
 /* Calculate the number of received bytes */
 
 static int
-calc_received (start_address)
-	void *start_address;
+calc_received (void *start_address)
 {
 	return (int)(
 		(((unsigned long)DMAHIGH << 16) | ((unsigned)DMAMID << 8) | DMALOW)
@@ -384,8 +375,7 @@ calc_received (start_address)
 /* start() starts the PAM's DMA adaptor */
 
 static void
-start (target)
-	int target;
+start (int target)
 {
 	send_first(target, START);
 }
@@ -393,8 +383,7 @@ start (target)
 /* stop() stops the PAM's DMA adaptor and returns a value of zero in case of success */
 
 static int
-stop (target)
-	int target;
+stop (int target)
 {
 	int ret = -1;
 	unsigned char cmd_buffer[5];
@@ -415,8 +404,7 @@ bad:
 /* testpkt() returns the number of received packets waiting in the queue */
 
 static int
-testpkt(target)
-	int target;
+testpkt(int target)
 {
 	int ret = -1;
 
@@ -431,9 +419,7 @@ bad:
 /* Please note: The buffer is for internal use only but must be defined!   */
 
 static int
-inquiry (target, buffer)
-	int target;
-	unsigned char *buffer;
+inquiry (int target, unsigned char *buffer)
 {
 	int ret = -1;
 	unsigned char *vbuffer = phys_to_virt((unsigned long)buffer);
@@ -468,9 +454,7 @@ bad:
  */
 
 static HADDR
-*read_hw_addr(target, buffer)
-	int target;
-	unsigned char *buffer;
+*read_hw_addr(int target, unsigned char *buffer)
 {
 	HADDR *ret = 0;
 	unsigned char cmd_buffer[5];
@@ -491,9 +475,7 @@ bad:
 }
 
 static irqreturn_t
-pamsnet_intr(irq, data, fp)
-	int irq;
-	void *data;
+pamsnet_intr(int irq, void *data)
 {
 	return IRQ_HANDLED;
 }
@@ -501,9 +483,7 @@ pamsnet_intr(irq, data, fp)
 /* receivepkt() loads a packet to a given buffer and returns its length */
 
 static int
-receivepkt (target, buffer)
-	int target;
-	unsigned char *buffer;
+receivepkt (int target, unsigned char *buffer)
 {
 	int ret = -1;
 	unsigned char cmd_buffer[5];
@@ -526,10 +506,7 @@ bad:
              successfully */
 
 static int
-sendpkt (target, buffer, length)
-	int target;
-	unsigned char *buffer;
-	int length;
+sendpkt (int target, unsigned char *buffer, int length)
 {
 	int ret = -1;
 	unsigned char cmd_buffer[5];
@@ -665,7 +642,8 @@ struct net_device * __init pamsnet_probe
    there is non-reboot way to recover if something goes wrong.
  */
 static int
-pamsnet_open(struct net_device *dev) {
+pamsnet_open(struct net_device *dev)
+{
 	struct net_local *lp = netdev_priv(dev);
 
 	if (pamsnet_debug > 0)
@@ -694,7 +672,8 @@ pamsnet_open(struct net_device *dev) {
 }
 
 static int
-pamsnet_send_packet(struct sk_buff *skb, struct net_device *dev) {
+pamsnet_send_packet(struct sk_buff *skb, struct net_device *dev)
+{
 	struct net_local *lp = netdev_priv(dev);
 	unsigned long flags;
 
@@ -741,7 +720,8 @@ pamsnet_send_packet(struct sk_buff *skb,
 /* We have a good packet(s), get it/them out of the buffers.
  */
 static void
-pamsnet_poll_rx(struct net_device *dev) {
+pamsnet_poll_rx(struct net_device *dev)
+{
 	struct net_local *lp = netdev_priv(dev);
 	int boguscount;
 	int pkt_len;
@@ -816,7 +796,8 @@ pamsnet_poll_rx(struct net_device *dev) 
  * passes them to the higher layers and restarts the timer.
  */
 static void
-pamsnet_tick(unsigned long data) {
+pamsnet_tick(unsigned long data)
+{
 	struct net_device	 *dev = (struct net_device *)data;
 	struct net_local *lp = netdev_priv(dev);
 
@@ -832,7 +813,8 @@ pamsnet_tick(unsigned long data) {
 /* The inverse routine to pamsnet_open().
  */
 static int
-pamsnet_close(struct net_device *dev) {
+pamsnet_close(struct net_device *dev)
+{
 	struct net_local *lp = netdev_priv(dev);
 
 	if (pamsnet_debug > 0)
_

Patches currently in -mm which might be from padator@wanadoo.fr are

git-netdev-all.patch
some-kmalloc-memset-kzalloc-tree-wide.patch
