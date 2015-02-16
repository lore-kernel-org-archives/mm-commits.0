From: akpm@linux-foundation.org
Subject: [merged]
 wireless-use-%pb-to-print-bitmaps-including-cpumasks-and-nodemasks.patch
 removed from -mm tree
Date: Mon, 16 Feb 2015 12:16:37 -0800
Message-ID: <54e25025.Bfld3ZfVKsPL1+YE%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50986 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751511AbbBPURN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 16 Feb 2015 15:17:13 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tj@kernel.org, linville@tuxdriver.com, mm-commits@vger.kernel.org


The patch titled
     Subject: wireless: use %*pb[l] to print bitmaps including cpumasks and nodemasks
has been removed from the -mm tree.  Its filename was
     wireless-use-%pb-to-print-bitmaps-including-cpumasks-and-nodemasks.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Tejun Heo <tj@kernel.org>
Subject: wireless: use %*pb[l] to print bitmaps including cpumasks and nodemasks

printk and friends can now formap bitmaps using '%*pb[l]'.  cpumask
and nodemask also provide cpumask_pr_args() and nodemask_pr_args()
respectively which can be used to generate the two printf arguments
necessary to format the specified cpu/nodemask.

This patch is dependent on the following two patches.

 lib/vsprintf: implement bitmap printing through '%*pb[l]'
 cpumask, nodemask: implement cpumask/nodemask_pr_args()

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: "John W. Linville" <linville@tuxdriver.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/wireless/ath/ath9k/htc_drv_debug.c |   23 +++-----------
 drivers/net/wireless/ath/carl9170/debug.c      |   24 +++------------
 2 files changed, 12 insertions(+), 35 deletions(-)

diff -puN drivers/net/wireless/ath/ath9k/htc_drv_debug.c~wireless-use-%pb-to-print-bitmaps-including-cpumasks-and-nodemasks drivers/net/wireless/ath/ath9k/htc_drv_debug.c
--- a/drivers/net/wireless/ath/ath9k/htc_drv_debug.c~wireless-use-%pb-to-print-bitmaps-including-cpumasks-and-nodemasks
+++ a/drivers/net/wireless/ath/ath9k/htc_drv_debug.c
@@ -291,26 +291,15 @@ static ssize_t read_file_slot(struct fil
 {
 	struct ath9k_htc_priv *priv = file->private_data;
 	char buf[512];
-	unsigned int len = 0;
+	unsigned int len;
 
 	spin_lock_bh(&priv->tx.tx_lock);
-
-	len += scnprintf(buf + len, sizeof(buf) - len, "TX slot bitmap : ");
-
-	len += bitmap_scnprintf(buf + len, sizeof(buf) - len,
-			       priv->tx.tx_slot, MAX_TX_BUF_NUM);
-
-	len += scnprintf(buf + len, sizeof(buf) - len, "\n");
-
-	len += scnprintf(buf + len, sizeof(buf) - len,
-			 "Used slots     : %d\n",
-			 bitmap_weight(priv->tx.tx_slot, MAX_TX_BUF_NUM));
-
+	len = scnprintf(buf, sizeof(buf),
+			"TX slot bitmap : %*pb\n"
+			"Used slots     : %d\n",
+			MAX_TX_BUF_NUM, priv->tx.tx_slot,
+			bitmap_weight(priv->tx.tx_slot, MAX_TX_BUF_NUM));
 	spin_unlock_bh(&priv->tx.tx_lock);
-
-	if (len > sizeof(buf))
-		len = sizeof(buf);
-
 	return simple_read_from_buffer(user_buf, count, ppos, buf, len);
 }
 
diff -puN drivers/net/wireless/ath/carl9170/debug.c~wireless-use-%pb-to-print-bitmaps-including-cpumasks-and-nodemasks drivers/net/wireless/ath/carl9170/debug.c
--- a/drivers/net/wireless/ath/carl9170/debug.c~wireless-use-%pb-to-print-bitmaps-including-cpumasks-and-nodemasks
+++ a/drivers/net/wireless/ath/carl9170/debug.c
@@ -214,14 +214,10 @@ DEBUGFS_DECLARE_RO_FILE(name, _read_bufs
 static char *carl9170_debugfs_mem_usage_read(struct ar9170 *ar, char *buf,
 					     size_t bufsize, ssize_t *len)
 {
-	ADD(buf, *len, bufsize, "jar: [");
-
 	spin_lock_bh(&ar->mem_lock);
 
-	*len += bitmap_scnprintf(&buf[*len], bufsize - *len,
-				  ar->mem_bitmap, ar->fw.mem_blocks);
-
-	ADD(buf, *len, bufsize, "]\n");
+	ADD(buf, *len, bufsize, "jar: [%*pb]\n",
+	    ar->fw.mem_blocks, ar->mem_bitmap);
 
 	ADD(buf, *len, bufsize, "cookies: used:%3d / total:%3d, allocs:%d\n",
 	    bitmap_weight(ar->mem_bitmap, ar->fw.mem_blocks),
@@ -316,17 +312,13 @@ static char *carl9170_debugfs_ampdu_stat
 		    cnt, iter->tid, iter->bsn, iter->snx, iter->hsn,
 		    iter->max, iter->state, iter->counter);
 
-		ADD(buf, *len, bufsize, "\tWindow:  [");
-
-		*len += bitmap_scnprintf(&buf[*len], bufsize - *len,
-			iter->bitmap, CARL9170_BAW_BITS);
+		ADD(buf, *len, bufsize, "\tWindow:  [%*pb,W]\n",
+		    CARL9170_BAW_BITS, iter->bitmap);
 
 #define BM_STR_OFF(offset)					\
 	((CARL9170_BAW_BITS - (offset) - 1) / 4 +		\
 	 (CARL9170_BAW_BITS - (offset) - 1) / 32 + 1)
 
-		ADD(buf, *len, bufsize, ",W]\n");
-
 		offset = BM_STR_OFF(0);
 		ADD(buf, *len, bufsize, "\tBase Seq: %*s\n", offset, "T");
 
@@ -448,12 +440,8 @@ static char *carl9170_debugfs_vif_dump_r
 	ADD(buf, *len, bufsize, "registered VIFs:%d \\ %d\n",
 	    ar->vifs, ar->fw.vif_num);
 
-	ADD(buf, *len, bufsize, "VIF bitmap: [");
-
-	*len += bitmap_scnprintf(&buf[*len], bufsize - *len,
-				 &ar->vif_bitmap, ar->fw.vif_num);
