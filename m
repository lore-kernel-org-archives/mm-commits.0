From: akpm@linux-foundation.org
Subject: + shmem-fix-possible-deadlocks-on-shmlock_user_lock.patch
 added to -mm tree
Date: Thu, 16 Apr 2020 20:55:57 -0700
Message-ID: <20200417035557.hgbVU-p3H%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:53088 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725294AbgDQDz6 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 16 Apr 2020 23:55:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hughd@google.com, mm-commits@vger.kernel.org, yang.shi@linux.alibaba.com


The patch titled
     Subject: shmem: fix possible deadlocks on shmlock_user_lock
has been added to the -mm tree.  Its filename is
     shmem-fix-possible-deadlocks-on-shmlock_user_lock.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/shmem-fix-possible-deadlocks-on-shmlock_user_lock.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/shmem-fix-possible-deadlocks-on-shmlock_user_lock.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: shmem: fix possible deadlocks on shmlock_user_lock

Recent commit 71725ed10c40 ("mm: huge tmpfs: try to split_huge_page() when
punching hole") has allowed syzkaller to probe deeper, uncovering a
long-standing lockdep issue between the irq-unsafe shmlock_user_lock, the
irq-safe xa_lock on mapping->i_pages, and shmem inode's info->lock which
nests inside xa_lock (or tree_lock) since 4.8's shmem_uncharge().

user_shm_lock(), servicing SysV shmctl(SHM_LOCK), wants shmlock_user_lock
while its caller shmem_lock() holds info->lock with interrupts disabled;
but hugetlbfs_file_setup() calls user_shm_lock() with interrupts enabled,
and might be interrupted by a writeback endio wanting xa_lock on i_pages. 
This may not risk an actual deadlock, since shmem inodes do not take part
in writeback accounting, but there are several easy ways to avoid it.

Requiring interrupts disabled for shmlock_user_lock would be easy, but
it's a high-level global lock for which that seems inappropriate. 
Instead, recall that the use of info->lock to guard info->flags in
shmem_lock() dates from pre-3.1 days, when races with SHMEM_PAGEIN and
SHMEM_TRUNCATE could occur: nowadays it serves no purpose, the only flag
added or removed is VM_LOCKED itself, and calls to shmem_lock() an inode
are already serialized by the caller.  Take info->lock out of the chain
and the possibility of deadlock or lockdep warning goes away.

Link: http://lkml.kernel.org/r/alpine.LSU.2.11.2004161707410.16322@eggly.anvils
Reported-by: syzbot+c8a8197c8852f566b9d9@syzkaller.appspotmail.com
Link: https://lore.kernel.org/lkml/000000000000e5838c05a3152f53@google.com/
Reported-by: syzbot+40b71e145e73f78f81ad@syzkaller.appspotmail.com
Link: https://lore.kernel.org/lkml/0000000000003712b305a331d3b1@google.com/
Fixes: 4595ef88d136 ("shmem: make shmem_inode_info::lock irq-safe")
Signed-off-by: Hugh Dickins <hughd@google.com>
Cc: Yang Shi <yang.shi@linux.alibaba.com>
Acked-by: Yang Shi <yang.shi@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/mm/shmem.c~shmem-fix-possible-deadlocks-on-shmlock_user_lock
+++ a/mm/shmem.c
@@ -2179,7 +2179,11 @@ int shmem_lock(struct file *file, int lo
 	struct shmem_inode_info *info = SHMEM_I(inode);
 	int retval = -ENOMEM;
 
-	spin_lock_irq(&info->lock);
+	/*
+	 * What serializes the accesses to info->flags?
+	 * ipc_lock_object() when called from shmctl_do_lock(),
+	 * no serialization needed when called from shm_destroy().
+	 */
 	if (lock && !(info->flags & VM_LOCKED)) {
 		if (!user_shm_lock(inode->i_size, user))
 			goto out_nomem;
@@ -2194,7 +2198,6 @@ int shmem_lock(struct file *file, int lo
 	retval = 0;
 
 out_nomem:
-	spin_unlock_irq(&info->lock);
 	return retval;
 }
 
_

Patches currently in -mm which might be from hughd@google.com are

mm-shmem-fix-build-without-thp.patch
shmem-fix-possible-deadlocks-on-shmlock_user_lock.patch
