From: akpm@linux-foundation.org
Subject: [folded-merged] hlist-drop-the-node-parameter-from-iterators-fix-fix-fix-fix-fix-fix.patch removed from -mm tree
Date: Wed, 27 Feb 2013 16:49:53 -0800
Message-ID: <20130228004953.DD5835A408F@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f73.google.com ([209.85.216.73]:42937 "EHLO
	mail-qa0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752549Ab3B1Atz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 27 Feb 2013 19:49:55 -0500
Received: by mail-qa0-f73.google.com with SMTP id g10so156260qah.2
        for <mm-commits@vger.kernel.org>; Wed, 27 Feb 2013 16:49:54 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, amirv@mellanox.com, fengguang.wu@intel.com, sasha.levin@oracle.com, mm-commits@vger.kernel.org


The patch titled
     Subject: hlist-drop-the-node-parameter-from-iterators-fix-fix-fix-fix-fix-fix
has been removed from the -mm tree.  Its filename was
     hlist-drop-the-node-parameter-from-iterators-fix-fix-fix-fix-fix-fix.patch

This patch was dropped because it was folded into hlist-drop-the-node-parameter-from-iterators.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: hlist-drop-the-node-parameter-from-iterators-fix-fix-fix-fix-fix-fix

Reported-by: Wu Fengguang <fengguang.wu@intel.com>
Cc: Sasha Levin <sasha.levin@oracle.com>
Cc: Amir Vadai <amirv@mellanox.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/ethernet/mellanox/mlx4/en_netdev.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff -puN drivers/net/ethernet/mellanox/mlx4/en_netdev.c~hlist-drop-the-node-parameter-from-iterators-fix-fix-fix-fix-fix-fix drivers/net/ethernet/mellanox/mlx4/en_netdev.c
--- a/drivers/net/ethernet/mellanox/mlx4/en_netdev.c~hlist-drop-the-node-parameter-from-iterators-fix-fix-fix-fix-fix-fix
+++ a/drivers/net/ethernet/mellanox/mlx4/en_netdev.c
@@ -573,13 +573,13 @@ static void mlx4_en_put_qp(struct mlx4_e
 
 	if (dev->caps.steering_mode != MLX4_STEERING_MODE_A0) {
 		struct mlx4_mac_entry *entry;
-		struct hlist_node *n, *tmp;
+		struct hlist_node *tmp;
 		struct hlist_head *bucket;
 		unsigned int mac_hash;
 
 		mac_hash = priv->dev->dev_addr[MLX4_EN_MAC_HASH_IDX];
 		bucket = &priv->mac_hash[mac_hash];
-		hlist_for_each_entry_safe(entry, n, tmp, bucket, hlist) {
+		hlist_for_each_entry_safe(entry, tmp, bucket, hlist) {
 			if (ether_addr_equal_64bits(entry->mac,
 						    priv->dev->dev_addr)) {
 				en_dbg(DRV, priv, "Releasing qp: port %d, MAC %pM, qpn %d\n",
@@ -608,11 +608,11 @@ static int mlx4_en_replace_mac(struct ml
 		struct hlist_head *bucket;
 		unsigned int mac_hash;
 		struct mlx4_mac_entry *entry;
-		struct hlist_node *n, *tmp;
+		struct hlist_node *tmp;
 		u64 prev_mac_u64 = mlx4_en_mac_to_u64(prev_mac);
 
 		bucket = &priv->mac_hash[prev_mac[MLX4_EN_MAC_HASH_IDX]];
-		hlist_for_each_entry_safe(entry, n, tmp, bucket, hlist) {
+		hlist_for_each_entry_safe(entry, tmp, bucket, hlist) {
 			if (ether_addr_equal_64bits(entry->mac, prev_mac)) {
 				mlx4_en_uc_steer_release(priv, entry->mac,
 							 qpn, entry->reg_id);
@@ -1018,7 +1018,7 @@ static void mlx4_en_do_uc_filter(struct 
 {
 	struct netdev_hw_addr *ha;
 	struct mlx4_mac_entry *entry;
-	struct hlist_node *n, *tmp;
+	struct hlist_node *tmp;
 	bool found;
 	u64 mac;
 	int err = 0;
@@ -1034,7 +1034,7 @@ static void mlx4_en_do_uc_filter(struct 
 	/* find what to remove */
 	for (i = 0; i < MLX4_EN_MAC_HASH_SIZE; ++i) {
 		bucket = &priv->mac_hash[i];
-		hlist_for_each_entry_safe(entry, n, tmp, bucket, hlist) {
+		hlist_for_each_entry_safe(entry, tmp, bucket, hlist) {
 			found = false;
 			netdev_for_each_uc_addr(ha, dev) {
 				if (ether_addr_equal_64bits(entry->mac,
@@ -1077,7 +1077,7 @@ static void mlx4_en_do_uc_filter(struct 
 	netdev_for_each_uc_addr(ha, dev) {
 		found = false;
 		bucket = &priv->mac_hash[ha->addr[MLX4_EN_MAC_HASH_IDX]];
-		hlist_for_each_entry(entry, n, bucket, hlist) {
+		hlist_for_each_entry(entry, bucket, hlist) {
 			if (ether_addr_equal_64bits(entry->mac, ha->addr)) {
 				found = true;
 				break;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
mm-use-vm_unmapped_area-on-parisc-architecture.patch
backlight-add-new-lp8788-backlight-driver.patch
hfsplus-add-osx-prefix-for-handling-namespace-of-mac-os-x-extended-attributes.patch
fs-proc-clean-up-printks.patch
fs-proc-vmcorec-put-if-tests-in-the-top-of-the-while-loop-to-reduce-duplication.patch
lockdep-check-that-no-locks-held-at-freeze-time.patch
fs-seq_filec-seq_lseek-fix-switch-statement-indenting.patch
idr-remove-length-restriction-from-idr_layer-bitmap.patch
drivers-char-miscc-misc_register-do-not-loop-on-misc_list-unconditionally.patch
ensure-that-the-gpt-header-is-at-least-the-size-of-the-structure.patch
dma-debug-new-interfaces-to-debug-dma-mapping-errors-fix-fix.patch
tools-testing-selftests-makefile-rearrange-targets.patch
selftests-add-a-simple-doc.patch
hlist-drop-the-node-parameter-from-iterators.patch
hlist-drop-the-node-parameter-from-iterators-mlx4-fix.patch
hlist-drop-the-node-parameter-from-iterators-mlx4-fix-fix.patch
hlist-drop-the-node-parameter-from-iterators-mlx4-fix-fix-fix.patch

