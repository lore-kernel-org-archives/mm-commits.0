From: akpm@linux-foundation.org
Subject: + hlist-drop-the-node-parameter-from-iterators-mlx4-fix-fix-fix.patch added to -mm tree
Date: Wed, 27 Feb 2013 15:28:52 -0800
Message-ID: <20130228002105.D5A3C31C0A0@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ve0-f201.google.com ([209.85.128.201]:52233 "EHLO
	mail-ve0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750838Ab3B1AVI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 27 Feb 2013 19:21:08 -0500
Received: by mail-ve0-f201.google.com with SMTP id 14so136918vea.4
        for <mm-commits@vger.kernel.org>; Wed, 27 Feb 2013 16:21:07 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, sasha.levin@oracle.com


The patch titled
     Subject: hlist-drop-the-node-parameter-from-iterators-mlx4-fix-fix-fix
has been added to the -mm tree.  Its filename is
     hlist-drop-the-node-parameter-from-iterators-mlx4-fix-fix-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
mm-use-vm_unmapped_area-on-parisc-architecture-fix.patch
backlight-add-new-lp8788-backlight-driver-checkpatch-fixes.patch
hfsplus-add-osx-prefix-for-handling-namespace-of-mac-os-x-extended-attributes.patch
signal-allow-to-send-any-siginfo-to-itself-fix.patch
fs-proc-clean-up-printks.patch
fs-proc-clean-up-printks-fix.patch
fs-proc-clean-up-printks-fix-fix.patch
fs-proc-vmcorec-put-if-tests-in-the-top-of-the-while-loop-to-reduce-duplication-fix.patch
fs-proc-vmcorec-put-if-tests-in-the-top-of-the-while-loop-to-reduce-duplication-fix-fix.patch
lockdep-check-that-no-locks-held-at-freeze-time-fix.patch
fs-seq_filec-seq_lseek-fix-switch-statement-indenting.patch
fs-seq_filec-seq_lseek-fix-switch-statement-indenting-checkpatch-fixes.patch
idr-remove-length-restriction-from-idr_layer-bitmap-checkpatch-fixes.patch
drivers-char-miscc-misc_register-do-not-loop-on-misc_list-unconditionally-fix.patch
ensure-that-the-gpt-header-is-at-least-the-size-of-the-structure-fix.patch
dma-debug-new-interfaces-to-debug-dma-mapping-errors-fix-fix.patch
selftests-add-tests-for-efivarfs-fix.patch
selftests-add-tests-for-efivarfs-fix-fix.patch
tools-testing-selftests-makefile-rearrange-targets.patch
selftests-add-a-simple-doc-fix.patch
hlist-drop-the-node-parameter-from-iterators-fix-fix-fix-fix.patch
hlist-drop-the-node-parameter-from-iterators-fix-fix-fix-fix-fix.patch
hlist-drop-the-node-parameter-from-iterators-checkpatch-fixes.patch
hlist-drop-the-node-parameter-from-iterators-fix.patch
hlist-drop-the-node-parameter-from-iterators-fix-fix.patch
hlist-drop-the-node-parameter-from-iterators-fix-fix-fix.patch
hlist-drop-the-node-parameter-from-iterators-fix-fix-fix-fix-fix-fix.patch
hlist-drop-the-node-parameter-from-iterators-mlx4-fix.patch
hlist-drop-the-node-parameter-from-iterators-mlx4-fix-fix.patch
hlist-drop-the-node-parameter-from-iterators-mlx4-fix-fix-fix.patch

