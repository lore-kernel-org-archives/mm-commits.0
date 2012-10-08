From: akpm@linux-foundation.org
Subject: [folded-dropped] mm-mmu_notifier-init-notifier-if-necessary-v2.patch removed from -mm tree
Date: Mon, 08 Oct 2012 16:04:03 -0700
Message-ID: <20121008230404.0180A1E0043@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gh0-f202.google.com ([209.85.160.202]:62403 "EHLO
	mail-gh0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754126Ab2JHXEE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Oct 2012 19:04:04 -0400
Received: by mail-gh0-f202.google.com with SMTP id z15so537199ghb.1
        for <mm-commits@vger.kernel.org>; Mon, 08 Oct 2012 16:04:04 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: shangw@linux.vnet.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/mmu_notifier: init notifier if necessary
has been removed from the -mm tree.  Its filename was
     mm-mmu_notifier-init-notifier-if-necessary-v2.patch

This patch was dropped because it was folded into mm-mmu_notifier-init-notifier-if-necessary.patch

------------------------------------------------------
From: Gavin Shan <shangw@linux.vnet.ibm.com>
Subject: mm/mmu_notifier: init notifier if necessary

v2: Use GFP_KERNEL instead of GFP_ATOMIC when allocating the MMU
    notifier_mm as Andrew suggested.

Signed-off-by: Gavin Shan <shangw@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmu_notifier.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/mmu_notifier.c~mm-mmu_notifier-init-notifier-if-necessary-v2 mm/mmu_notifier.c
--- a/mm/mmu_notifier.c~mm-mmu_notifier-init-notifier-if-necessary-v2
+++ a/mm/mmu_notifier.c
@@ -215,7 +215,7 @@ static int do_mmu_notifier_register(stru
 
 	if (!mm_has_notifiers(mm)) {
 		mmu_notifier_mm = kmalloc(sizeof(struct mmu_notifier_mm),
-					GFP_ATOMIC);
+					GFP_KERNEL);
 		if (unlikely(!mmu_notifier_mm)) {
 			ret = -ENOMEM;
 			goto out_of_mem;
_

Patches currently in -mm which might be from shangw@linux.vnet.ibm.com are

origin.patch
mm-mmu_notifier-init-notifier-if-necessary.patch
mm-vmscan-fix-error-number-for-failed-kthread.patch
mm-memblock-use-existing-interface-to-set-nid.patch
mm-memblock-cleanup-early_node_map-related-comments.patch

