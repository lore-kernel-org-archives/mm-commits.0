From: akpm@linux-foundation.org
Subject: [folded-merged] hlist-drop-the-node-parameter-from-iterators-mlx4-fix.patch removed from -mm tree
Date: Wed, 27 Feb 2013 16:49:56 -0800
Message-ID: <20130228004956.CB0FD5A408F@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ve0-f202.google.com ([209.85.128.202]:34500 "EHLO
	mail-ve0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753405Ab3B1At6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 27 Feb 2013 19:49:58 -0500
Received: by mail-ve0-f202.google.com with SMTP id m1so139748ves.3
        for <mm-commits@vger.kernel.org>; Wed, 27 Feb 2013 16:49:57 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, sasha.levin@oracle.com, mm-commits@vger.kernel.org


The patch titled
     Subject: hlist-drop-the-node-parameter-from-iterators-mlx4-fix
has been removed from the -mm tree.  Its filename was
     hlist-drop-the-node-parameter-from-iterators-mlx4-fix.patch

This patch was dropped because it was folded into hlist-drop-the-node-parameter-from-iterators.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: hlist-drop-the-node-parameter-from-iterators-mlx4-fix

Cc: Sasha Levin <sasha.levin@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/ethernet/mellanox/mlx4/en_rx.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/net/ethernet/mellanox/mlx4/en_rx.c~hlist-drop-the-node-parameter-from-iterators-mlx4-fix drivers/net/ethernet/mellanox/mlx4/en_rx.c
--- a/drivers/net/ethernet/mellanox/mlx4/en_rx.c~hlist-drop-the-node-parameter-from-iterators-mlx4-fix
+++ a/drivers/net/ethernet/mellanox/mlx4/en_rx.c
@@ -35,6 +35,7 @@
 #include <linux/slab.h>
 #include <linux/mlx4/qp.h>
 #include <linux/skbuff.h>
+#include <linux/rculist.h>
 #include <linux/if_ether.h>
 #include <linux/if_vlan.h>
 #include <linux/vmalloc.h>
@@ -617,7 +618,6 @@ int mlx4_en_process_rx_cq(struct net_dev
 
 			if (is_multicast_ether_addr(ethh->h_dest)) {
 				struct mlx4_mac_entry *entry;
-				struct hlist_node *n;
 				struct hlist_head *bucket;
 				unsigned int mac_hash;
 
@@ -625,7 +625,7 @@ int mlx4_en_process_rx_cq(struct net_dev
 				mac_hash = ethh->h_source[MLX4_EN_MAC_HASH_IDX];
 				bucket = &priv->mac_hash[mac_hash];
 				rcu_read_lock();
-				hlist_for_each_entry_rcu(entry, n, bucket, hlist) {
+				hlist_for_each_entry_rcu(entry, bucket, hlist) {
 					if (ether_addr_equal_64bits(entry->mac,
 								    ethh->h_source)) {
 						rcu_read_unlock();
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
hlist-drop-the-node-parameter-from-iterators-mlx4-fix-fix.patch
hlist-drop-the-node-parameter-from-iterators-mlx4-fix-fix-fix.patch

