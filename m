From: akpm@linux-foundation.org
Subject: + mm-mmu_notifier-init-notifier-if-necessary.patch added to -mm tree
Date: Fri, 24 Aug 2012 14:52:08 -0700
Message-ID: <20120824215208.BEC38100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f202.google.com ([209.85.161.202]:37686 "EHLO
	mail-gg0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932388Ab2HXVwK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 24 Aug 2012 17:52:10 -0400
Received: by ggnu1 with SMTP id u1so336655ggn.1
        for <mm-commits@vger.kernel.org>; Fri, 24 Aug 2012 14:52:09 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: shangw@linux.vnet.ibm.com, aarcange@redhat.com, avi@redhat.com, haggaie@mellanox.com, hughd@google.com, liwanp@linux.vnet.ibm.com, mtosatti@redhat.com, sagig@mellanox.co.il, xiaoguangrong@linux.vnet.ibm.com


The patch titled
     Subject: mm/mmu_notifier: init notifier if necessary
has been added to the -mm tree.  Its filename is
     mm-mmu_notifier-init-notifier-if-necessary.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
+					GFP_ATOMIC);
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

mm-slab-remove-duplicate-check.patch
mm-mmu_notifier-init-notifier-if-necessary.patch
mm-memblock-truncate-memblock-if-necessary.patch
mm-memblock-rename-get_allocated_memblock_reserved_regions_info.patch
mm-memblock-reduce-overhead-in-binary-search.patch
mm-memblock-use-existing-interface-to-set-nid.patch
mm-memblock-cleanup-early_node_map-related-comments.patch
mm-vmscan-fix-error-number-for-failed-kthread.patch

