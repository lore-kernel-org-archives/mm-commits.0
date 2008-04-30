From: akpm@linux-foundation.org
Subject: - ipwireless-remove-dead-code.patch removed from -mm tree
Date: Tue, 29 Apr 2008 22:39:48 -0700
Message-ID: <200804300539.m3U5dm0b028881@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39528 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753901AbYD3FkJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Apr 2008 01:40:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jkosina@suse.cz, bunk@kernel.org, mm-commits@vger.kernel.org


The patch titled
     ipwireless: remove dead code
has been removed from the -mm tree.  Its filename was
     ipwireless-remove-dead-code.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ipwireless: remove dead code
From: Jiri Kosina <jkosina@suse.cz>

Remove unused leftovers of debugging functions. 2.6.25 material.

Reported-by: Adrian Bunk <bunk@kernel.org>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/pcmcia/ipwireless/hardware.c |   26 --------------------
 drivers/char/pcmcia/ipwireless/hardware.h |    2 -
 drivers/char/pcmcia/ipwireless/network.c  |   15 -----------
 drivers/char/pcmcia/ipwireless/network.h  |    3 --
 4 files changed, 46 deletions(-)

diff -puN drivers/char/pcmcia/ipwireless/hardware.c~ipwireless-remove-dead-code drivers/char/pcmcia/ipwireless/hardware.c
--- a/drivers/char/pcmcia/ipwireless/hardware.c~ipwireless-remove-dead-code
+++ a/drivers/char/pcmcia/ipwireless/hardware.c
@@ -354,32 +354,6 @@ struct ipw_rx_packet {
 	unsigned int channel_idx;
 };
 
-#ifdef IPWIRELESS_STATE_DEBUG
-int ipwireless_dump_hardware_state(char *p, size_t limit,
-				   struct ipw_hardware *hw)
-{
-	return snprintf(p, limit,
-			"debug: initializing=%d\n"
-			"debug: tx_ready=%d\n"
-			"debug: tx_queued=%d\n"
-			"debug: rx_ready=%d\n"
-			"debug: rx_bytes_queued=%d\n"
-			"debug: blocking_rx=%d\n"
-			"debug: removed=%d\n"
-			"debug: hardware.shutting_down=%d\n"
-			"debug: to_setup=%d\n",
-			hw->initializing,
-			hw->tx_ready,
-			hw->tx_queued,
-			hw->rx_ready,
-			hw->rx_bytes_queued,
-			hw->blocking_rx,
-			hw->removed,
-			hw->shutting_down,
-			hw->to_setup);
-}
-#endif
-
 static char *data_type(const unsigned char *buf, unsigned length)
 {
 	struct nl_packet_header *hdr = (struct nl_packet_header *) buf;
diff -puN drivers/char/pcmcia/ipwireless/hardware.h~ipwireless-remove-dead-code drivers/char/pcmcia/ipwireless/hardware.h
--- a/drivers/char/pcmcia/ipwireless/hardware.h~ipwireless-remove-dead-code
+++ a/drivers/char/pcmcia/ipwireless/hardware.h
@@ -58,7 +58,5 @@ void ipwireless_init_hardware_v1(struct 
 				 void *reboot_cb_data);
 void ipwireless_init_hardware_v2_v3(struct ipw_hardware *hw);
 void ipwireless_sleep(unsigned int tenths);
-int ipwireless_dump_hardware_state(char *p, size_t limit,
-				   struct ipw_hardware *hw);
 
 #endif
diff -puN drivers/char/pcmcia/ipwireless/network.c~ipwireless-remove-dead-code drivers/char/pcmcia/ipwireless/network.c
--- a/drivers/char/pcmcia/ipwireless/network.c~ipwireless-remove-dead-code
+++ a/drivers/char/pcmcia/ipwireless/network.c
@@ -63,21 +63,6 @@ struct ipw_network {
 	struct work_struct work_go_offline;
 };
 
-
-#ifdef IPWIRELESS_STATE_DEBUG
-int ipwireless_dump_network_state(char *p, size_t limit,
-				  struct ipw_network *network)
-{
-	return snprintf(p, limit,
-			"debug: ppp_blocked=%d\n"
-			"debug: outgoing_packets_queued=%d\n"
-			"debug: network.shutting_down=%d\n",
-			network->ppp_blocked,
-			network->outgoing_packets_queued,
-			network->shutting_down);
-}
-#endif
-
 static void notify_packet_sent(void *callback_data, unsigned int packet_length)
 {
 	struct ipw_network *network = callback_data;
diff -puN drivers/char/pcmcia/ipwireless/network.h~ipwireless-remove-dead-code drivers/char/pcmcia/ipwireless/network.h
--- a/drivers/char/pcmcia/ipwireless/network.h~ipwireless-remove-dead-code
+++ a/drivers/char/pcmcia/ipwireless/network.h
@@ -49,7 +49,4 @@ void ipwireless_ppp_close(struct ipw_net
 int ipwireless_ppp_channel_index(struct ipw_network *net);
 int ipwireless_ppp_unit_number(struct ipw_network *net);
 
-int ipwireless_dump_network_state(char *p, size_t limit,
-				  struct ipw_network *net);
