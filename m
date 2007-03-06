From: akpm@linux-foundation.org
Subject: - lguest-trivial-guest-network-driver-fix.patch removed from -mm tree
Date: Tue, 06 Mar 2007 02:54:15 -0800
Message-ID: <200703061054.l26AsF3w020357@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:35366 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965819AbXCFKzQ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 6 Mar 2007 05:55:16 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rusty@rustcorp.com.au, ak@suse.de, herbert@gondor.apana.org.au, mm-commits@vger.kernel.org


The patch titled
     lguest: trivial guest network driver (fix)
has been removed from the -mm tree.  Its filename was
     lguest-trivial-guest-network-driver-fix.patch

This patch was dropped because it was folded into lguest-trivial-guest-network-driver.patch

------------------------------------------------------
Subject: lguest: trivial guest network driver (fix)
From: Rusty Russell <rusty@rustcorp.com.au>

Thanks to Herbert Xu for noticing the bug: "len" here is skb_headlen(),
not skb->len.  Renamed the function to clarify, too.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/lguest_net.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN drivers/net/lguest_net.c~lguest-trivial-guest-network-driver-fix drivers/net/lguest_net.c
--- a/drivers/net/lguest_net.c~lguest-trivial-guest-network-driver-fix
+++ a/drivers/net/lguest_net.c
@@ -59,14 +59,14 @@ static unsigned long peer_addr(struct lg
 	return info->peer_phys + 4 * peernum;
 }
 
-static void skb_to_dma(const struct sk_buff *skb, unsigned int len,
+static void skb_to_dma(const struct sk_buff *skb, unsigned int headlen,
 		       struct lguest_dma *dma)
 {
 	unsigned int i, seg;
 
-	for (i = seg = 0; i < len; seg++, i += rest_of_page(skb->data + i)) {
+	for (i = seg = 0; i < headlen; seg++, i += rest_of_page(skb->data+i)) {
 		dma->addr[seg] = virt_to_phys(skb->data + i);
-		dma->len[seg] = min((unsigned)(len - i),
+		dma->len[seg] = min((unsigned)(headlen - i),
 				    rest_of_page(skb->data + i));
 	}
 	for (i = 0; i < skb_shinfo(skb)->nr_frags; i++, seg++) {
@@ -90,7 +90,7 @@ static void transfer_packet(struct net_d
 	struct lguestnet_info *info = dev->priv;
 	struct lguest_dma dma;
 
-	skb_to_dma(skb, skb->len, &dma);
+	skb_to_dma(skb, skb_headlen(skb), &dma);
 	pr_debug("xfer length %04x (%u)\n", htons(skb->len), skb->len);
 
 	hcall(LHCALL_SEND_DMA, peer_addr(info,peernum), __pa(&dma),0);
_

Patches currently in -mm which might be from rusty@rustcorp.com.au are

i386-vdso_prelink-warning-fix.patch
cleanup-initialize-esp0-properly-all-the-time.patch
lguest-preparation-export_symbol_gpl-5-functions.patch
lguest-preparation-expose-futex-infrastructure.patch
lguest-kconfig-and-headers.patch
lguest-the-host-code-lgko.patch
lguest-guest-code.patch
lguest-makefile.patch
lguest-trivial-guest-network-driver.patch
lguest-trivial-guest-network-driver-fix.patch
lguest-trivial-guest-console-driver.patch
lguest-trivial-guest-block-driver.patch
lguest-documentatation-and-example-launcher.patch
module-use-krealloc.patch
extend-print_symbol-capability.patch
____call_usermodehelper-dont-flush_signals.patch
