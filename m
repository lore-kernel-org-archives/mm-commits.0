From: akpm@linux-foundation.org
Subject: [folded-merged] hlist-drop-the-node-parameter-from-iterators-fix-fix.patch removed from -mm tree
Date: Wed, 27 Feb 2013 16:49:44 -0800
Message-ID: <20130228004945.192485A4215@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qe0-f74.google.com ([209.85.128.74]:54308 "EHLO
	mail-qe0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752549Ab3B1Atq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 27 Feb 2013 19:49:46 -0500
Received: by mail-qe0-f74.google.com with SMTP id 9so140032qea.5
        for <mm-commits@vger.kernel.org>; Wed, 27 Feb 2013 16:49:45 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, sasha.levin@oracle.com, mm-commits@vger.kernel.org


The patch titled
     Subject: hlist-drop-the-node-parameter-from-iterators-fix-fix
has been removed from the -mm tree.  Its filename was
     hlist-drop-the-node-parameter-from-iterators-fix-fix.patch

This patch was dropped because it was folded into hlist-drop-the-node-parameter-from-iterators.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: hlist-drop-the-node-parameter-from-iterators-fix-fix

Cc: Sasha Levin <sasha.levin@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 virt/kvm/irq_comm.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN virt/kvm/irq_comm.c~hlist-drop-the-node-parameter-from-iterators-fix-fix virt/kvm/irq_comm.c
--- a/virt/kvm/irq_comm.c~hlist-drop-the-node-parameter-from-iterators-fix-fix
+++ a/virt/kvm/irq_comm.c
@@ -239,13 +239,12 @@ int kvm_set_irq_inatomic(struct kvm *kvm
 bool kvm_irq_has_notifier(struct kvm *kvm, unsigned irqchip, unsigned pin)
 {
 	struct kvm_irq_ack_notifier *kian;
-	struct hlist_node *n;
 	int gsi;
 
 	rcu_read_lock();
 	gsi = rcu_dereference(kvm->irq_routing)->chip[irqchip][pin];
 	if (gsi != -1)
-		hlist_for_each_entry_rcu(kian, n, &kvm->irq_ack_notifier_list,
+		hlist_for_each_entry_rcu(kian, &kvm->irq_ack_notifier_list,
 					 link)
 			if (kian->gsi == gsi) {
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
hlist-drop-the-node-parameter-from-iterators-fix-fix-fix.patch
hlist-drop-the-node-parameter-from-iterators-fix-fix-fix-fix-fix-fix.patch
hlist-drop-the-node-parameter-from-iterators-mlx4-fix.patch
hlist-drop-the-node-parameter-from-iterators-mlx4-fix-fix.patch
hlist-drop-the-node-parameter-from-iterators-mlx4-fix-fix-fix.patch

