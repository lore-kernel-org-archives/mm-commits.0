From: akpm@linux-foundation.org
Subject: [folded-merged] hlist-drop-the-node-parameter-from-iterators-mlx4-fix-fix-fix.patch removed from -mm tree
Date: Wed, 27 Feb 2013 16:50:02 -0800
Message-ID: <20130228005003.23A575A408F@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f73.google.com ([209.85.212.73]:56436 "EHLO
	mail-vb0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753366Ab3B1AuF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 27 Feb 2013 19:50:05 -0500
Received: by mail-vb0-f73.google.com with SMTP id fj18so18757vbb.4
        for <mm-commits@vger.kernel.org>; Wed, 27 Feb 2013 16:50:03 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, sasha.levin@oracle.com, mm-commits@vger.kernel.org


The patch titled
     Subject: hlist-drop-the-node-parameter-from-iterators-mlx4-fix-fix-fix
has been removed from the -mm tree.  Its filename was
     hlist-drop-the-node-parameter-from-iterators-mlx4-fix-fix-fix.patch

This patch was dropped because it was folded into hlist-drop-the-node-parameter-from-iterators.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: hlist-drop-the-node-parameter-from-iterators-mlx4-fix-fix-fix

Cc: Sasha Levin <sasha.levin@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/ethernet/qlogic/qlcnic/qlcnic_io.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN drivers/net/ethernet/mellanox/mlx4/en_rx.c~hlist-drop-the-node-parameter-from-iterators-mlx4-fix-fix-fix drivers/net/ethernet/mellanox/mlx4/en_rx.c
diff -puN net/core/net-procfs.c~hlist-drop-the-node-parameter-from-iterators-mlx4-fix-fix-fix net/core/net-procfs.c
diff -puN drivers/net/ethernet/qlogic/qlcnic/qlcnic_io.c~hlist-drop-the-node-parameter-from-iterators-mlx4-fix-fix-fix drivers/net/ethernet/qlogic/qlcnic/qlcnic_io.c
--- a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_io.c~hlist-drop-the-node-parameter-from-iterators-mlx4-fix-fix-fix
+++ a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_io.c
@@ -162,7 +162,7 @@ void qlcnic_add_lb_filter(struct qlcnic_
 {
 	struct ethhdr *phdr = (struct ethhdr *)(skb->data);
 	struct qlcnic_filter *fil, *tmp_fil;
-	struct hlist_node *tmp_hnode, *n;
+	struct hlist_node *n;
 	struct hlist_head *head;
 	unsigned long time;
 	u64 src_addr = 0;
@@ -179,7 +179,7 @@ void qlcnic_add_lb_filter(struct qlcnic_
 			 (adapter->fhash.fbucket_size - 1);
 		head = &(adapter->rx_fhash.fhead[hindex]);
 
-		hlist_for_each_entry_safe(tmp_fil, tmp_hnode, n, head, fnode) {
+		hlist_for_each_entry_safe(tmp_fil, n, head, fnode) {
 			if (!memcmp(tmp_fil->faddr, &src_addr, ETH_ALEN) &&
 			    tmp_fil->vlan_id == vlan_id) {
 				time = tmp_fil->ftime;
@@ -205,7 +205,7 @@ void qlcnic_add_lb_filter(struct qlcnic_
 			 (adapter->fhash.fbucket_size - 1);
 		head = &(adapter->rx_fhash.fhead[hindex]);
 		spin_lock(&adapter->rx_mac_learn_lock);
-		hlist_for_each_entry_safe(tmp_fil, tmp_hnode, n, head, fnode) {
+		hlist_for_each_entry_safe(tmp_fil, n, head, fnode) {
 			if (!memcmp(tmp_fil->faddr, &src_addr, ETH_ALEN) &&
 			    tmp_fil->vlan_id == vlan_id) {
 				found = 1;
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

