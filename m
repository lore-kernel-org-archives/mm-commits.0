From: akpm@linux-foundation.org
Subject: - ucc_geth-fix-module-removal.patch removed from -mm tree
Date: Sun, 03 Feb 2008 12:22:27 -0800
Message-ID: <200802032022.m13KM8cP029988@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47172 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752162AbYBCUWQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sun, 3 Feb 2008 15:22:16 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: avorontsov@ru.mvista.com, mm-commits@vger.kernel.org


The patch titled
     ucc_geth: fix module removal
has been removed from the -mm tree.  Its filename was
     ucc_geth-fix-module-removal.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

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
@@ -2084,8 +2084,10 @@ static void ucc_geth_memclean(struct ucc
 	if (!ugeth)
 		return;
 
-	if (ugeth->uccf)
+	if (ugeth->uccf) {
 		ucc_fast_free(ugeth->uccf);
+		ugeth->uccf = NULL;
+	}
 
 	if (ugeth->p_thread_data_tx) {
 		qe_muram_free(ugeth->thread_dat_tx_offset);
@@ -2305,10 +2307,6 @@ static int ucc_struct_init(struct ucc_ge
 	ug_info = ugeth->ug_info;
 	uf_info = &ug_info->uf_info;
 
-	/* Create CQs for hash tables */
-	INIT_LIST_HEAD(&ugeth->group_hash_q);
-	INIT_LIST_HEAD(&ugeth->ind_hash_q);
-
 	if (!((uf_info->bd_mem_part == MEM_PART_SYSTEM) ||
 	      (uf_info->bd_mem_part == MEM_PART_MURAM))) {
 		if (netif_msg_probe(ugeth))
@@ -3990,6 +3988,10 @@ static int ucc_geth_probe(struct of_devi
 	ugeth = netdev_priv(dev);
 	spin_lock_init(&ugeth->lock);
 
+	/* Create CQs for hash tables */
+	INIT_LIST_HEAD(&ugeth->group_hash_q);
+	INIT_LIST_HEAD(&ugeth->ind_hash_q);
+
 	dev_set_drvdata(device, dev);
 
 	/* Set the dev->base_addr to the gfar reg region */
@@ -4040,9 +4042,10 @@ static int ucc_geth_remove(struct of_dev
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
git-net.patch
