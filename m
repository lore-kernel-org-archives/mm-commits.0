From: akpm@linux-foundation.org
Subject: + sfc-remove-redundant-casts-to-and-from-void.patch added to -mm tree
Date: Mon, 19 May 2008 20:27:43 -0700
Message-ID: <200805200327.m4K3Rh5q002714@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47200 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757308AbYETD1v (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 19 May 2008 23:27:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bhutchings@solarflare.com, jeff@garzik.org


The patch titled
     sfc: remove redundant casts to and from void *
has been added to the -mm tree.  Its filename is
     sfc-remove-redundant-casts-to-and-from-void.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: sfc: remove redundant casts to and from void *
From: Ben Hutchings <bhutchings@solarflare.com>

Signed-off-by: Ben Hutchings <bhutchings@solarflare.com>
Cc: Jeff Garzik <jeff@garzik.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/sfc/efx.c      |    2 +-
 drivers/net/sfc/falcon.c   |   18 +++++++++---------
 drivers/net/sfc/rx.c       |    8 ++++----
 drivers/net/sfc/selftest.c |    4 ++--
 drivers/net/sfc/xfp_phy.c  |    2 +-
 5 files changed, 17 insertions(+), 17 deletions(-)

diff -puN drivers/net/sfc/efx.c~sfc-remove-redundant-casts-to-and-from-void drivers/net/sfc/efx.c
--- a/drivers/net/sfc/efx.c~sfc-remove-redundant-casts-to-and-from-void
+++ a/drivers/net/sfc/efx.c
@@ -1490,7 +1490,7 @@ static void efx_set_multicast_list(struc
 static int efx_netdev_event(struct notifier_block *this,
 			    unsigned long event, void *ptr)
 {
-	struct net_device *net_dev = (struct net_device *)ptr;
+	struct net_device *net_dev = ptr;
 
 	if (net_dev->open == efx_net_open && event == NETDEV_CHANGENAME) {
 		struct efx_nic *efx = net_dev->priv;
diff -puN drivers/net/sfc/falcon.c~sfc-remove-redundant-casts-to-and-from-void drivers/net/sfc/falcon.c
--- a/drivers/net/sfc/falcon.c~sfc-remove-redundant-casts-to-and-from-void
+++ a/drivers/net/sfc/falcon.c
@@ -1405,7 +1405,7 @@ static inline void falcon_irq_ack_a1(str
 static irqreturn_t falcon_fatal_interrupt(struct efx_nic *efx)
 {
 	struct falcon_nic_data *nic_data = efx->nic_data;
-	efx_oword_t *int_ker = (efx_oword_t *) efx->irq_status.addr;
+	efx_oword_t *int_ker = efx->irq_status.addr;
 	efx_oword_t fatal_intr;
 	int error, mem_perr;
 	static int n_int_errors;
@@ -1451,8 +1451,8 @@ out:
  */
 static irqreturn_t falcon_legacy_interrupt_b0(int irq, void *dev_id)
 {
-	struct efx_nic *efx = (struct efx_nic *)dev_id;
-	efx_oword_t *int_ker = (efx_oword_t *) efx->irq_status.addr;
+	struct efx_nic *efx = dev_id;
+	efx_oword_t *int_ker = efx->irq_status.addr;
 	struct efx_channel *channel;
 	efx_dword_t reg;
 	u32 queues;
@@ -1489,8 +1489,8 @@ static irqreturn_t falcon_legacy_interru
 
 static irqreturn_t falcon_legacy_interrupt_a1(int irq, void *dev_id)
 {
-	struct efx_nic *efx = (struct efx_nic *)dev_id;
-	efx_oword_t *int_ker = (efx_oword_t *) efx->irq_status.addr;
+	struct efx_nic *efx = dev_id;
+	efx_oword_t *int_ker = efx->irq_status.addr;
 	struct efx_channel *channel;
 	int syserr;
 	int queues;
@@ -1542,9 +1542,9 @@ static irqreturn_t falcon_legacy_interru
  */
 static irqreturn_t falcon_msi_interrupt(int irq, void *dev_id)
 {
-	struct efx_channel *channel = (struct efx_channel *)dev_id;
+	struct efx_channel *channel = dev_id;
 	struct efx_nic *efx = channel->efx;
-	efx_oword_t *int_ker = (efx_oword_t *) efx->irq_status.addr;
+	efx_oword_t *int_ker = efx->irq_status.addr;
 	int syserr;
 
 	efx->last_irq_cpu = raw_smp_processor_id();
@@ -1941,7 +1941,7 @@ static int falcon_gmii_wait(struct efx_n
 static void falcon_mdio_write(struct net_device *net_dev, int phy_id,
 			      int addr, int value)
 {
-	struct efx_nic *efx = (struct efx_nic *)net_dev->priv;
+	struct efx_nic *efx = net_dev->priv;
 	unsigned int phy_id2 = phy_id & FALCON_PHY_ID_ID_MASK;
 	efx_oword_t reg;
 
@@ -2009,7 +2009,7 @@ static void falcon_mdio_write(struct net
  * could be read, -1 will be returned. */
 static int falcon_mdio_read(struct net_device *net_dev, int phy_id, int addr)
 {
-	struct efx_nic *efx = (struct efx_nic *)net_dev->priv;
+	struct efx_nic *efx = net_dev->priv;
 	unsigned int phy_addr = phy_id & FALCON_PHY_ID_ID_MASK;
 	efx_oword_t reg;
 	int value = -1;
diff -puN drivers/net/sfc/rx.c~sfc-remove-redundant-casts-to-and-from-void drivers/net/sfc/rx.c
--- a/drivers/net/sfc/rx.c~sfc-remove-redundant-casts-to-and-from-void
+++ a/drivers/net/sfc/rx.c
@@ -109,7 +109,7 @@ static inline unsigned int efx_rx_buf_si
 static int efx_lro_get_skb_hdr(struct sk_buff *skb, void **ip_hdr,
 			       void **tcpudp_hdr, u64 *hdr_flags, void *priv)
 {
-	struct efx_channel *channel = (struct efx_channel *)priv;
+	struct efx_channel *channel = priv;
 	struct iphdr *iph;
 	struct tcphdr *th;
 
@@ -134,12 +134,12 @@ static int efx_get_frag_hdr(struct skb_f
 			    void **ip_hdr, void **tcpudp_hdr, u64 *hdr_flags,
 			    void *priv)
 {
-	struct efx_channel *channel = (struct efx_channel *)priv;
+	struct efx_channel *channel = priv;
 	struct ethhdr *eh;
 	struct iphdr *iph;
 
 	/* We support EtherII and VLAN encapsulated IPv4 */
-	eh = (struct ethhdr *)(page_address(frag->page) + frag->page_offset);
+	eh = page_address(frag->page) + frag->page_offset;
 	*mac_hdr = eh;
 
 	if (eh->h_proto == htons(ETH_P_IP)) {
@@ -283,7 +283,7 @@ static inline int efx_init_rx_buffer_pag
 
 		rx_queue->buf_page = rx_buf->page;
 		rx_queue->buf_dma_addr = dma_addr;
-		rx_queue->buf_data = ((char *) page_address(rx_buf->page) +
+		rx_queue->buf_data = (page_address(rx_buf->page) +
 				      EFX_PAGE_IP_ALIGN);
 	}
 
diff -puN drivers/net/sfc/selftest.c~sfc-remove-redundant-casts-to-and-from-void drivers/net/sfc/selftest.c
--- a/drivers/net/sfc/selftest.c~sfc-remove-redundant-casts-to-and-from-void
+++ a/drivers/net/sfc/selftest.c
@@ -290,7 +290,7 @@ void efx_loopback_rx_packet(struct efx_n
 
 	payload = &state->payload;
 	
-	received = (struct efx_loopback_payload *)(char *) buf_ptr;
+	received = (struct efx_loopback_payload *) buf_ptr;
 	received->ip.saddr = payload->ip.saddr;
 	received->ip.check = payload->ip.check;
 	
@@ -700,7 +700,7 @@ int efx_offline_test(struct efx_nic *efx
 	 * "flushing" so all inflight packets are dropped */
 	BUG_ON(efx->loopback_selftest);
 	state->flush = 1;
-	efx->loopback_selftest = (void *)state;
+	efx->loopback_selftest = state;
 
 	rc = efx_test_loopbacks(efx, tests, loopback_modes);
 
diff -puN drivers/net/sfc/xfp_phy.c~sfc-remove-redundant-casts-to-and-from-void drivers/net/sfc/xfp_phy.c
--- a/drivers/net/sfc/xfp_phy.c~sfc-remove-redundant-casts-to-and-from-void
+++ a/drivers/net/sfc/xfp_phy.c
@@ -85,7 +85,7 @@ static int xfp_phy_init(struct efx_nic *
 	int rc;
 
 	phy_data = kzalloc(sizeof(struct xfp_phy_data), GFP_KERNEL);
-	efx->phy_data = (void *) phy_data;
+	efx->phy_data = phy_data;
 
 	EFX_INFO(efx, "XFP: PHY ID reg %x (OUI %x model %x revision"
 		 " %x)\n", devid, MDIO_ID_OUI(devid), MDIO_ID_MODEL(devid),
_

Patches currently in -mm which might be from bhutchings@solarflare.com are

sfc-use-mod_timer-to-set-expiry-and-add_timer-together.patch
sfc-remove-casts-to-void.patch
sfc-simplify-efx_rx_calc_buffer_size-using-get_order.patch
sfc-remove-unncesssary-ul-suffixes-on-0-literals.patch
sfc-add-and-remove-braces-to-comply-with-kernel-style.patch
sfc-replace-various-macros-with-inline-functions.patch
sfc-merge-efx_page_offset-into-efx_rx_buf_offset.patch
sfc-use-resource_size_t-for-pci-bus-address.patch
sfc-correct-and-expand-some-comments.patch
sfc-do-not-define-inline-macro.patch
sfc-remove-redundant-casts-to-and-from-void.patch
sfc-add-checks-for-heap-allocation-failure.patch
sfc-remove-sub-minor-component-from-driver-version.patch

