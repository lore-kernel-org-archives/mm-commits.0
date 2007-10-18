From: akpm@linux-foundation.org
Subject: + ucc_geth-fix-module-removal.patch added to -mm tree
Date: Wed, 17 Oct 2007 21:02:21 -0700
Message-ID: <200710180402.l9I42LQr024335@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34267 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750782AbXJRECa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Oct 2007 00:02:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: avorontsov@ru.mvista.com


The patch titled
     ucc_geth: fix module removal
has been added to the -mm tree.  Its filename is
     ucc_geth-fix-module-removal.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: ucc_geth: fix module removal
From: Anton Vorontsov <avorontsov@ru.mvista.com>

- uccf should be set to NULL to not double-free memory on
  subsequent calls;
- ind_hash_q and group_hash_q lists should be initialized in the
  probe() function, instead of struct_init() (called by open()),
  otherwise there will be an oops if ucc_geth_driver removed
  prior 'ifconfig ethX up';
- add unregister_netdev();
- reorder geth_remove() steps.

Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/ucc_geth.c |   17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

diff -puN drivers/net/ucc_geth.c~ucc_geth-fix-module-removal drivers/net/ucc_geth.c
--- a/drivers/net/ucc_geth.c~ucc_geth-fix-module-removal
+++ a/drivers/net/ucc_geth.c
@@ -2080,8 +2080,10 @@ static void ucc_geth_memclean(struct ucc
 	if (!ugeth)
 		return;
 
-	if (ugeth->uccf)
+	if (ugeth->uccf) {
 		ucc_fast_free(ugeth->uccf);
+		ugeth->uccf = NULL;
+	}
 
 	if (ugeth->p_thread_data_tx) {
 		qe_muram_free(ugeth->thread_dat_tx_offset);
@@ -2312,10 +2314,6 @@ static int ucc_struct_init(struct ucc_ge
 	ug_info = ugeth->ug_info;
 	uf_info = &ug_info->uf_info;
 
-	/* Create CQs for hash tables */
-	INIT_LIST_HEAD(&ugeth->group_hash_q);
-	INIT_LIST_HEAD(&ugeth->ind_hash_q);
-
 	if (!((uf_info->bd_mem_part == MEM_PART_SYSTEM) ||
 	      (uf_info->bd_mem_part == MEM_PART_MURAM))) {
 		if (netif_msg_probe(ugeth))
@@ -3947,6 +3945,10 @@ static int ucc_geth_probe(struct of_devi
 	ugeth = netdev_priv(dev);
 	spin_lock_init(&ugeth->lock);
 
+	/* Create CQs for hash tables */
+	INIT_LIST_HEAD(&ugeth->group_hash_q);
+	INIT_LIST_HEAD(&ugeth->ind_hash_q);
+
 	dev_set_drvdata(device, dev);
 
 	/* Set the dev->base_addr to the gfar reg region */
@@ -3997,9 +3999,10 @@ static int ucc_geth_remove(struct of_dev
 	struct net_device *dev = dev_get_drvdata(device);
 	struct ucc_geth_private *ugeth = netdev_priv(dev);
 
-	dev_set_drvdata(device, NULL);
-	ucc_geth_memclean(ugeth);
+	unregister_netdev(dev);
 	free_netdev(dev);
+	ucc_geth_memclean(ugeth);
+	dev_set_drvdata(device, NULL);
 
 	return 0;
 }
_

Patches currently in -mm which might be from avorontsov@ru.mvista.com are

origin.patch
ucc_geth-fix-module-removal.patch
ucc_geth-add-support-for-netpoll.patch
phy-implement-release-function.patch
