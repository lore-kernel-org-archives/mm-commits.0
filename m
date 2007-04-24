From: akpm@linux-foundation.org
Subject: + netdrv-perform-missing-csum_offset-conversions.patch added to -mm tree
Date: Mon, 23 Apr 2007 17:11:21 -0700
Message-ID: <200704240011.l3O0BLXH028779@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:48766 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1030891AbXDXAMJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 23 Apr 2007 20:12:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: herbert@gondor.apana.org.au


The patch titled
     NETDRV: perform missing csum_offset conversions
has been added to the -mm tree.  Its filename is
     netdrv-perform-missing-csum_offset-conversions.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: NETDRV: perform missing csum_offset conversions
From: Herbert Xu <herbert@gondor.apana.org.au>

When csum_offset was introduced we did a conversion from csum to
csum_offset where applicable.  A couple of drivers were missed in this
process.

It was harmless to begin with since the two fields coincided.  Now that
we've made them different with the addition of csum_start, the missed
drivers must be converted or they can't send packets out at all that
require checksum offload.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/atl1/atl1_main.c   |    2 +-
 drivers/net/e1000/e1000_main.c |    3 ++-
 2 files changed, 3 insertions(+), 2 deletions(-)

diff -puN drivers/net/atl1/atl1_main.c~netdrv-perform-missing-csum_offset-conversions drivers/net/atl1/atl1_main.c
--- a/drivers/net/atl1/atl1_main.c~netdrv-perform-missing-csum_offset-conversions
+++ a/drivers/net/atl1/atl1_main.c
@@ -1328,7 +1328,7 @@ static int atl1_tx_csum(struct atl1_adap
 
 	if (likely(skb->ip_summed == CHECKSUM_PARTIAL)) {
 		cso = skb_transport_offset(skb);
-		css = cso + skb->csum;
+		css = cso + skb->csum_offset;
 		if (unlikely(cso & 0x1)) {
 			printk(KERN_DEBUG "%s: payload offset != even number\n",
 				atl1_driver_name);
diff -puN drivers/net/e1000/e1000_main.c~netdrv-perform-missing-csum_offset-conversions drivers/net/e1000/e1000_main.c
--- a/drivers/net/e1000/e1000_main.c~netdrv-perform-missing-csum_offset-conversions
+++ a/drivers/net/e1000/e1000_main.c
@@ -3040,7 +3040,8 @@ e1000_tx_csum(struct e1000_adapter *adap
 
 		context_desc->lower_setup.ip_config = 0;
 		context_desc->upper_setup.tcp_fields.tucss = css;
-		context_desc->upper_setup.tcp_fields.tucso = css + skb->csum;
+		context_desc->upper_setup.tcp_fields.tucso =
+			css + skb->csum_offset;
 		context_desc->upper_setup.tcp_fields.tucse = 0;
 		context_desc->tcp_seg_setup.data = 0;
 		context_desc->cmd_and_length = cpu_to_le32(E1000_TXD_CMD_DEXT);
_

Patches currently in -mm which might be from herbert@gondor.apana.org.au are

origin.patch
git-net.patch
netdrv-perform-missing-csum_offset-conversions.patch
revert-7f8be19f5a5737ce6ad670756183235c71b560bb.patch
git-wireless.patch
git-cryptodev.patch
use-menuconfig-objects-crypto.patch
