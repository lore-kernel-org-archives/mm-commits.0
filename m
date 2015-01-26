From: akpm@linux-foundation.org
Subject: +
 wireless-use-%pb-to-print-bitmaps-including-cpumasks-and-nodemasks.patch
 added to -mm tree
Date: Mon, 26 Jan 2015 15:07:20 -0800
Message-ID: <54c6c8a8.hBWcmODuXL8iAxGa%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46161 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755950AbbAZXHV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 26 Jan 2015 18:07:21 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tj@kernel.org, linville@tuxdriver.com, mm-commits@vger.kernel.org


The patch titled
     Subject: wireless: use %*pb[l] to print bitmaps including cpumasks and nodemasks
has been added to the -mm tree.  Its filename is
     wireless-use-%pb-to-print-bitmaps-including-cpumasks-and-nodemasks.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/wireless-use-%25pb-to-print-bitmaps-including-cpumasks-and-nodemasks.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/wireless-use-%25pb-to-print-bitmaps-including-cpumasks-and-nodemasks.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
-
-	ADD(buf, *len, bufsize, "]\n");
+	ADD(buf, *len, bufsize, "VIF bitmap: [%*pb]\n",
+	    ar->fw.vif_num, &ar->vif_bitmap);
 
 	rcu_read_lock();
 	list_for_each_entry_rcu(iter, &ar->vif_list, list) {
_

Patches currently in -mm which might be from tj@kernel.org are

block-restore-proc-partitions-to-not-display-non-partitionable-removable-devices.patch
list_lru-introduce-list_lru_shrink_countwalk.patch
fs-consolidate-nrfree_cached_objects-args-in-shrink_control.patch
vmscan-per-memory-cgroup-slab-shrinkers.patch
memcg-rename-some-cache-id-related-variables.patch
memcg-add-rwsem-to-synchronize-against-memcg_caches-arrays-relocation.patch
list_lru-get-rid-of-active_nodes.patch
list_lru-organize-all-list_lrus-to-list.patch
list_lru-introduce-per-memcg-lists.patch
fs-make-shrinker-memcg-aware.patch
vmscan-force-scan-offline-memory-cgroups.patch
vmscan-force-scan-offline-memory-cgroups-fix.patch
oom-add-helpers-for-setting-and-clearing-tif_memdie.patch
oom-thaw-the-oom-victim-if-it-is-frozen.patch
pm-convert-printk-to-pr_-equivalent.patch
sysrq-convert-printk-to-pr_-equivalent.patch
oom-pm-make-oom-detection-in-the-freezer-path-raceless.patch
slab-embed-memcg_cache_params-to-kmem_cache.patch
slab-link-memcg-caches-of-the-same-kind-into-a-list.patch
cgroup-release-css-id-after-css_free.patch
slab-use-css-id-for-naming-per-memcg-caches.patch
memcg-free-memcg_caches-slot-on-css-offline.patch
list_lru-add-helpers-to-isolate-items.patch
memcg-reparent-list_lrus-and-free-kmemcg_id-on-css-offline.patch
fs-mpagec-forgotten-write_sync-in-case-of-data-integrity-write.patch
mm-util-add-kstrdup_const.patch
kernfs-convert-node-name-allocation-to-kstrdup_const.patch
kernfs-remove-kernfs_static_name.patch
clk-convert-clock-name-allocations-to-kstrdup_const.patch
mm-slab-convert-cache-name-allocations-to-kstrdup_const.patch
mm-slab-convert-cache-name-allocations-to-kstrdup_const-fix.patch
fs-namespace-convert-devname-allocation-to-kstrdup_const.patch
cpumask-always-use-nr_cpu_ids-in-formatting-and-parsing-functions.patch
lib-vsprintf-implement-bitmap-printing-through-%pb.patch
cpumask-nodemask-implement-cpumask-nodemask_pr_args.patch
bitmap-use-%pb-to-print-bitmaps-including-cpumasks-and-nodemasks.patch
mips-use-%pb-to-print-bitmaps-including-cpumasks-and-nodemasks.patch
powerpc-use-%pb-to-print-bitmaps-including-cpumasks-and-nodemasks.patch
tile-use-%pb-to-print-bitmaps-including-cpumasks-and-nodemasks.patch
x86-use-%pb-to-print-bitmaps-including-cpumasks-and-nodemasks.patch
ia64-use-%pb-to-print-bitmaps-including-cpumasks-and-nodemasks.patch
xtensa-use-%pb-to-print-bitmaps-including-cpumasks-and-nodemasks.patch
arm-use-%pb-to-print-bitmaps-including-cpumasks-and-nodemasks.patch
cpuset-use-%pb-to-print-bitmaps-including-cpumasks-and-nodemasks.patch
rcu-use-%pb-to-print-bitmaps-including-cpumasks-and-nodemasks.patch
sched-use-%pb-to-print-bitmaps-including-cpumasks-and-nodemasks.patch
time-use-%pb-to-print-bitmaps-including-cpumasks-and-nodemasks.patch
percpu-use-%pb-to-print-bitmaps-including-cpumasks-and-nodemasks.patch
workqueue-use-%pb-to-format-bitmaps-including-cpumasks-and-nodemasks.patch
tracing-use-%pb-to-print-bitmaps-including-cpumasks-and-nodemasks.patch
net-use-%pb-to-print-bitmaps-including-cpumasks-and-nodemasks.patch
wireless-use-%pb-to-print-bitmaps-including-cpumasks-and-nodemasks.patch
input-use-%pb-to-print-bitmaps-including-cpumasks-and-nodemasks.patch
scsi-use-%pb-to-print-bitmaps-including-cpumasks-and-nodemasks.patch
usb-use-%pb-to-print-bitmaps-including-cpumasks-and-nodemasks.patch
drivers-base-use-%pb-to-print-bitmaps-including-cpumasks-and-nodemasks.patch
slub-use-%pb-to-print-bitmaps-including-cpumasks-and-nodemasks.patch
mm-use-%pb-to-print-bitmaps-including-cpumasks-and-nodemasks.patch
padata-use-%pb-to-print-bitmaps-including-cpumasks-and-nodemasks.patch
proc-use-%pb-to-print-bitmaps-including-cpumasks-and-nodemasks.patch
irq-use-%pb-to-print-bitmaps-including-cpumasks-and-nodemasks.patch
profile-use-%pb-to-print-bitmaps-including-cpumasks-and-nodemasks.patch
bitmap-cpumask-nodemask-remove-dedicated-formatting-functions.patch
linux-next.patch

