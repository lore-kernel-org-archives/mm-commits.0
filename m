From: akpm@linux-foundation.org
Subject: + lguest-trivial-guest-network-driver-fix.patch added to -mm tree
Date: Mon, 12 Feb 2007 23:03:32 -0800
Message-ID: <200702130703.l1D73WUa024557@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:57030 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751140AbXBMHDs (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 13 Feb 2007 02:03:48 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rusty@rustcorp.com.au, ak@suse.de, herbert@gondor.apana.org.au


The patch titled
     lguest: trivial guest network driver (fix)
has been added to the -mm tree.  Its filename is
     lguest-trivial-guest-network-driver-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

origin.patch
cleanup-paravirt-unhandled-fallthrough.patch
cleanup-initialize-esp0-properly-all-the-time.patch
cleanup-make-hvc_consolec-compile-on-non-powerpc.patch
cleanup-move-mce_disabled-to-asm-mceh.patch
cleanup-rename-cpu_gdt_descr-and-remove-extern.patch
cleanup-remove-extern-declaration-from.patch
cleanup-make-disable_acpi-valid-w-o-config_acpi.patch
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
vmi-versus-hrtimers.patch
