From: akpm@osdl.org
Subject: + spidernet-rx-debugging-printout.patch added to -mm tree
Date: Wed, 13 Dec 2006 16:26:22 -0800
Message-ID: <200612140026.kBE0QMYr026162@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:33364 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751804AbWLNA0w (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 13 Dec 2006 19:26:52 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: linas@austin.ibm.com, arnd@arndb.de, jklewis@us.ibm.com


The patch titled
     Spidernet: RX Debugging printout
has been added to the -mm tree.  Its filename is
     spidernet-rx-debugging-printout.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Spidernet: RX Debugging printout
From: Linas Vepstas <linas@austin.ibm.com>

Add some debugging and error printing.

The show_rx_chain() prints out the status of the rx chain, which shows that
the status of the descriptors gets messed up after the second & subsequent RX
ramfulls.

Print out contents of bad packets if error occurs.

Signed-off-by: Linas Vepstas <linas@austin.ibm.com>
Cc: James K Lewis <jklewis@us.ibm.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/net/spider_net.c |   46 +++++++++++++++++++++++++++++++++++++
 1 files changed, 46 insertions(+)

diff -puN drivers/net/spider_net.c~spidernet-rx-debugging-printout drivers/net/spider_net.c
--- a/drivers/net/spider_net.c~spidernet-rx-debugging-printout
+++ a/drivers/net/spider_net.c
@@ -961,6 +961,34 @@ spider_net_pass_skb_up(struct spider_net
 	card->netdev_stats.rx_bytes += skb->len;
 }
 
+#ifdef DEBUG
+static void show_rx_chain(struct spider_net_card *card)
+{
+	struct spider_net_descr_chain *chain = &card->rx_chain;
+	struct spider_net_descr *start= chain->tail;
+	struct spider_net_descr *descr= start;
+	int status;
+
+	int cnt = 0;
+	int cstat = spider_net_get_descr_status(descr);
+	printk(KERN_INFO "RX chain tail at descr=%ld\n",
+	     (start - card->descr) - card->tx_chain.num_desc);
+	status = cstat;
+	do
+	{
+		status = spider_net_get_descr_status(descr);
+		if (cstat != status) {
+			printk(KERN_INFO "Have %d descrs with stat=x%08x\n", cnt, cstat);
+			cstat = status;
+			cnt = 0;
+		}
+		cnt ++;
+		descr = descr->next;
+	} while (descr != start);
+	printk(KERN_INFO "Last %d descrs with stat=x%08x\n", cnt, cstat);
+}
+#endif
+
 /**
  * spider_net_decode_one_descr - processes an rx descriptor
  * @card: card structure
@@ -1021,6 +1049,24 @@ spider_net_decode_one_descr(struct spide
 		goto bad_desc;
 	}
 
+	if (descr->dmac_cmd_status & 0xfefe) {
+		pr_err("%s: bad status, cmd_status=x%08x\n",
+			       card->netdev->name,
+			       descr->dmac_cmd_status);
+		pr_err("buf_addr=x%08x\n", descr->buf_addr);
+		pr_err("buf_size=x%08x\n", descr->buf_size);
+		pr_err("next_descr_addr=x%08x\n", descr->next_descr_addr);
+		pr_err("result_size=x%08x\n", descr->result_size);
+		pr_err("valid_size=x%08x\n", descr->valid_size);
+		pr_err("data_status=x%08x\n", descr->data_status);
+		pr_err("data_error=x%08x\n", descr->data_error);
+		pr_err("bus_addr=x%08x\n", descr->bus_addr);
+		pr_err("which=%ld\n", descr - card->rx_chain.ring);
+
+		card->spider_stats.rx_desc_error++;
+		goto bad_desc;
+	}
+
 	/* Ok, we've got a packet in descr */
 	spider_net_pass_skb_up(descr, card);
 	descr->dmac_cmd_status = SPIDER_NET_DESCR_NOT_IN_USE;
_

Patches currently in -mm which might be from linas@austin.ibm.com are

origin.patch
spidernet-dma-coalescing.patch
spidernet-add-net_ratelimit-to-suppress-long-output.patch
spidernet-remove-rxramfull-tasklet.patch
spidernet-cleanup-un-needed-api.patch
spidernet-rx-skb-mem-leak.patch
spidernet-another-skb-mem-leak.patch
spidernet-cleanup-return-codes.patch
spidernet-rx-refill.patch
spidernet-remove-unused-variable.patch
spidernet-rx-chain-tail.patch
spidernet-memory-barrier.patch
spidernet-avoid-possible-rx-chain-corruption.patch
spidernet-rx-debugging-printout.patch
spidernet-rework-rx-linked-list.patch

