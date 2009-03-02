From: akpm@linux-foundation.org
Subject: + iwlwifi-reduce-stack-size.patch added to -mm tree
Date: Mon, 02 Mar 2009 14:08:16 -0800
Message-ID: <200903022208.n22M8Ga7027433@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41852 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754192AbZCBWJV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 2 Mar 2009 17:09:21 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: frank@f-seidel.de, linville@tuxdriver.com, reinette.chatre@intel.com


The patch titled
     iwlwifi: reduce stack size
has been added to the -mm tree.  Its filename is
     iwlwifi-reduce-stack-size.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: iwlwifi: reduce stack size
From: Frank Seidel <frank@f-seidel.de>

Reduce stack memory footprint of iwlwifi.  (From >1000 bytes for each
*_table_read on i386 down to 32)

Signed-off-by: Frank Seidel <frank@f-seidel.de>
Acked-by: Reinette Chatre <reinette.chatre@intel.com>
Cc: "John W. Linville" <linville@tuxdriver.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/wireless/iwlwifi/iwl-3945-rs.c |   11 +++++++--
 drivers/net/wireless/iwlwifi/iwl-agn-rs.c  |   23 +++++++++++++++----
 2 files changed, 28 insertions(+), 6 deletions(-)

diff -puN drivers/net/wireless/iwlwifi/iwl-3945-rs.c~iwlwifi-reduce-stack-size drivers/net/wireless/iwlwifi/iwl-3945-rs.c
--- a/drivers/net/wireless/iwlwifi/iwl-3945-rs.c~iwlwifi-reduce-stack-size
+++ a/drivers/net/wireless/iwlwifi/iwl-3945-rs.c
@@ -846,11 +846,16 @@ static ssize_t iwl3945_sta_dbgfs_stats_t
 						  char __user *user_buf,
 						  size_t count, loff_t *ppos)
 {
-	char buff[1024];
+	char *buff;
 	int desc = 0;
 	int j;
+	ssize_t ret;
 	struct iwl3945_rs_sta *lq_sta = file->private_data;
 
+	buff = kmalloc(1024, GFP_KERNEL);
+	if (!buff)
+		return -ENOMEM;
+
 	desc += sprintf(buff + desc, "tx packets=%d last rate index=%d\n"
 			"rate=0x%X flush time %d\n",
 			lq_sta->tx_packets,
@@ -863,7 +868,9 @@ static ssize_t iwl3945_sta_dbgfs_stats_t
 				lq_sta->win[j].success_counter,
 				lq_sta->win[j].success_ratio);
 	}
-	return simple_read_from_buffer(user_buf, count, ppos, buff, desc);
+	ret = simple_read_from_buffer(user_buf, count, ppos, buff, desc);
+	kfree(buff);
+	return ret;
 }
 
 static const struct file_operations rs_sta_dbgfs_stats_table_ops = {
diff -puN drivers/net/wireless/iwlwifi/iwl-agn-rs.c~iwlwifi-reduce-stack-size drivers/net/wireless/iwlwifi/iwl-agn-rs.c
--- a/drivers/net/wireless/iwlwifi/iwl-agn-rs.c~iwlwifi-reduce-stack-size
+++ a/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
@@ -2520,12 +2520,17 @@ static ssize_t rs_sta_dbgfs_scale_table_
 static ssize_t rs_sta_dbgfs_scale_table_read(struct file *file,
 			char __user *user_buf, size_t count, loff_t *ppos)
 {
-	char buff[1024];
+	char *buff;
 	int desc = 0;
 	int i = 0;
+	ssize_t ret;
 
 	struct iwl_lq_sta *lq_sta = file->private_data;
 
+	buff = kmalloc(1024, GFP_KERNEL);
+	if (!buff)
+		return -ENOMEM;
+
 	desc += sprintf(buff+desc, "sta_id %d\n", lq_sta->lq.sta_id);
 	desc += sprintf(buff+desc, "failed=%d success=%d rate=0%X\n",
 			lq_sta->total_failed, lq_sta->total_success,
@@ -2557,7 +2562,9 @@ static ssize_t rs_sta_dbgfs_scale_table_
 		desc += sprintf(buff+desc, " rate[%d] 0x%X\n",
 			i, le32_to_cpu(lq_sta->lq.rs_table[i].rate_n_flags));
 
-	return simple_read_from_buffer(user_buf, count, ppos, buff, desc);
+	ret = simple_read_from_buffer(user_buf, count, ppos, buff, desc);
+	kfree(buff);
+	return ret;
 }
 
 static const struct file_operations rs_sta_dbgfs_scale_table_ops = {
@@ -2568,11 +2575,17 @@ static const struct file_operations rs_s
 static ssize_t rs_sta_dbgfs_stats_table_read(struct file *file,
 			char __user *user_buf, size_t count, loff_t *ppos)
 {
-	char buff[1024];
+	char *buff;
 	int desc = 0;
 	int i, j;
+	ssize_t ret;
 
 	struct iwl_lq_sta *lq_sta = file->private_data;
+
+	buff = kmalloc(1024, GFP_KERNEL);
+	if (!buff)
+		return -ENOMEM;
+
 	for (i = 0; i < LQ_SIZE; i++) {
 		desc += sprintf(buff+desc, "%s type=%d SGI=%d FAT=%d DUP=%d\n"
 				"rate=0x%X\n",
@@ -2590,7 +2603,9 @@ static ssize_t rs_sta_dbgfs_stats_table_
 				lq_sta->lq_info[i].win[j].success_ratio);
 		}
 	}
-	return simple_read_from_buffer(user_buf, count, ppos, buff, desc);
+	ret = simple_read_from_buffer(user_buf, count, ppos, buff, desc);
+	kfree(buff);
+	return ret;
 }
 
 static const struct file_operations rs_sta_dbgfs_stats_table_ops = {
_

Patches currently in -mm which might be from frank@f-seidel.de are

linux-next.patch
misdn-l1oip-reduce-stack-memory-footprint.patch
misdn-l1oip-reduce-stack-memory-footprint-cleanup.patch
airo-reduce-stack-memory-footprint.patch
iwlwifi-reduce-stack-size.patch

