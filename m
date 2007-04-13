From: akpm@linux-foundation.org
Subject: + spidernet-fix-problem-sending-ip-fragments.patch added to -mm tree
Date: Fri, 13 Apr 2007 12:41:15 -0700
Message-ID: <200704131941.l3DJfGKW007846@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:47848 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753286AbXDMTlb (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 13 Apr 2007 15:41:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: linas@austin.ibm.com, n.eicker@fz-juelich.de


The patch titled
     spidernet: Fix problem sending IP fragments
has been added to the -mm tree.  Its filename is
     spidernet-fix-problem-sending-ip-fragments.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: spidernet: Fix problem sending IP fragments
From: Linas Vepstas <linas@austin.ibm.com>

The basic structure of "normal" UDP/IP/Ethernet
frames (that actually work):
 - It starts with the Ethernet header (dest MAC, src MAC, etc.)
 - The next part is occupied by the IP header (version info, length of
packet, id=0, fragment offset=0, checksum, from / to address, etc.)
 - Then comes the UDP header (src / dest port, length, checksum)
 - Actual payload
 - Ethernet checksum

Now what's different for IP fragment:
 - The IP header has id set to some value (same for all fragments),
offset is set appropriately (i.e. 0 for first fragment, following
according to size of other fragments), size is the length of the frame.
 - UDP header is unchanged. I.e. length is according to full UDP
datagram, not just the part within the actual frame! But this is only
true within the first frame: all following frames don't have a valid
UDP-header at all.

The spidernet silicon seems to be quite intelligent: It's able to
compute (IP / UDP / Ethernet) checksums on the fly and tests if frames
are conforming to RFC -- at least conforming to RFC on complete frames.

But IP fragments are different as explained above:
I.e. for IP fragments containing part of a UDP datagram it sees
incompatible length in the headers for IP and UDP in the first frame
and, thus, skips this frame. But the content *is* correct for IP
fragments. For all following frames it finds (most probably) no valid
UDP header at all. But this *is* also correct for IP fragments.

The Linux IP-stack seems to be clever in this point. It expects the
spidernet to calculate the checksum (since the module claims to be able
to do so) and marks the skb's for "normal" frames accordingly
(ip_summed set to CHECKSUM_HW).
But for the IP fragments it does not expect the driver to be capable to
handle the frames appropriately. Thus all checksums are allready
computed. This is also flaged within the skb (ip_summed set to
CHECKSUM_NONE).

Unfortunately the spidernet driver ignores that hints. It tries to send
the IP fragments of UDP datagrams as normal UDP/IP frames. Since they
have different structure the silicon detects them the be not
"well-formed" and skips them.

The following one-liner against 2.6.21-rc2 changes this behavior. If the
IP-stack claims to have done the checksumming, the driver should not
try to checksum (and analyze) the frame but send it as is.

Signed-off-by: Norbert Eicker <n.eicker@fz-juelich.de>
Signed-off-by: Linas Vepstas <linas@austin.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/spider_net.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/net/spider_net.c~spidernet-fix-problem-sending-ip-fragments drivers/net/spider_net.c
--- a/drivers/net/spider_net.c~spidernet-fix-problem-sending-ip-fragments
+++ a/drivers/net/spider_net.c
@@ -719,7 +719,7 @@ spider_net_prepare_tx_descr(struct spide
 			SPIDER_NET_DESCR_CARDOWNED | SPIDER_NET_DMAC_NOCS;
 	spin_unlock_irqrestore(&chain->lock, flags);
 
-	if (skb->protocol == htons(ETH_P_IP))
+	if (skb->protocol == htons(ETH_P_IP) && skb->ip_summed == CHECKSUM_PARTIAL)
 		switch (skb->nh.iph->protocol) {
 		case IPPROTO_TCP:
 			hwdescr->dmac_cmd_status |= SPIDER_NET_DMAC_TCP;
_

Patches currently in -mm which might be from linas@austin.ibm.com are

spidernet-fix-problem-sending-ip-fragments.patch
git-powerpc.patch
