From: akpm@linux-foundation.org
Subject: [merged] mm-mmu_notifier-init-notifier-if-necessary.patch removed from -mm tree
Date: Tue, 09 Oct 2012 11:07:12 -0700
Message-ID: <20121009180712.C20BA1E0043@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f202.google.com ([209.85.161.202]:43491 "EHLO
	mail-gg0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752730Ab2JISHN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Oct 2012 14:07:13 -0400
Received: by mail-gg0-f202.google.com with SMTP id i4so660327ggm.1
        for <mm-commits@vger.kernel.org>; Tue, 09 Oct 2012 11:07:13 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: shangw@linux.vnet.ibm.com, aarcange@redhat.com, avi@redhat.com, haggaie@mellanox.com, hughd@google.com, liwanp@linux.vnet.ibm.com, mtosatti@redhat.com, sagig@mellanox.co.il, xiaoguangrong@linux.vnet.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/mmu_notifier: init notifier if necessary
has been removed from the -mm tree.  Its filename was
     mm-mmu_notifier-init-notifier-if-necessary.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Gavin Shan <shangw@linux.vnet.ibm.com>
Subject: mm/mmu_notifier: init notifier if necessary

While registering MMU notifier, new instance of MMU notifier_mm will be
allocated and later free'd if currrent mm_struct's MMU notifier_mm has
been initialized.  That causes some overhead.  The patch tries to
elominate that.

Signed-off-by: Gavin Shan <shangw@linux.vnet.ibm.com>
Signed-off-by: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Avi Kivity <avi@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>
Cc: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Cc: Sagi Grimberg <sagig@mellanox.co.il>
Cc: Haggai Eran <haggaie@mellanox.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmu_notifier.c |   22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff -puN mm/mmu_notifier.c~mm-mmu_notifier-init-notifier-if-necessary mm/mmu_notifier.c
--- a/mm/mmu_notifier.c~mm-mmu_notifier-init-notifier-if-necessary
+++ a/mm/mmu_notifier.c
@@ -207,22 +207,23 @@ static int do_mmu_notifier_register(stru
 	*/
 	BUG_ON(!srcu.per_cpu_ref);
 
-	ret = -ENOMEM;
-	mmu_notifier_mm = kmalloc(sizeof(struct mmu_notifier_mm), GFP_KERNEL);
-	if (unlikely(!mmu_notifier_mm))
-		goto out;
-
 	if (take_mmap_sem)
 		down_write(&mm->mmap_sem);
 	ret = mm_take_all_locks(mm);
 	if (unlikely(ret))
-		goto out_cleanup;
+		goto out;
 
 	if (!mm_has_notifiers(mm)) {
+		mmu_notifier_mm = kmalloc(sizeof(struct mmu_notifier_mm),
+					GFP_KERNEL);
+		if (unlikely(!mmu_notifier_mm)) {
+			ret = -ENOMEM;
+			goto out_of_mem;
+		}
 		INIT_HLIST_HEAD(&mmu_notifier_mm->list);
 		spin_lock_init(&mmu_notifier_mm->lock);
+
 		mm->mmu_notifier_mm = mmu_notifier_mm;
-		mmu_notifier_mm = NULL;
 	}
 	atomic_inc(&mm->mm_count);
 
@@ -238,13 +239,12 @@ static int do_mmu_notifier_register(stru
 	hlist_add_head(&mn->hlist, &mm->mmu_notifier_mm->list);
 	spin_unlock(&mm->mmu_notifier_mm->lock);
 
+out_of_mem:
 	mm_drop_all_locks(mm);
-out_cleanup:
+out:
 	if (take_mmap_sem)
 		up_write(&mm->mmap_sem);
-	/* kfree() does nothing if mmu_notifier_mm is NULL */
-	kfree(mmu_notifier_mm);
-out:
+
 	BUG_ON(atomic_read(&mm->mm_users) <= 0);
 	return ret;
 }
_

Patches currently in -mm which might be from shangw@linux.vnet.ibm.com are

origin.patch
mm-slab-remove-duplicate-check.patch
mm-memblock-reduce-overhead-in-binary-search.patch

