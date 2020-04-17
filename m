From: akpm@linux-foundation.org
Subject: +
 =?US-ASCII?Q?mm-shmem-disable-interrupt-when-acquiring-info-lock-in-use?=
 =?US-ASCII?Q?rfaultfd=5Fcopy-path.patch?= added to -mm tree
Date: Thu, 16 Apr 2020 21:03:09 -0700
Message-ID: <20200417040309.k8cA36LHe%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:54086 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725900AbgDQEDK (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 17 Apr 2020 00:03:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aarcange@redhat.com, hughd@google.com, mm-commits@vger.kernel.org, yang.shi@linux.alibaba.com


The patch titled
     Subject: mm: shmem: disable interrupt when acquiring info->lock in userfaultfd_copy path
has been added to the -mm tree.  Its filename is
     mm-shmem-disable-interrupt-when-acquiring-info-lock-in-userfaultfd_copy-path.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-shmem-disable-interrupt-when-acquiring-info-lock-in-userfaultfd_copy-path.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-shmem-disable-interrupt-when-acquiring-info-lock-in-userfaultfd_copy-path.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Yang Shi <yang.shi@linux.alibaba.com>
Subject: mm: shmem: disable interrupt when acquiring info->lock in userfaultfd_copy path

Syzbot reported the below lockdep splat:

WARNING: possible irq lock inversion dependency detected
5.6.0-rc7-syzkaller #0 Not tainted
--------------------------------------------------------
syz-executor.0/10317 just changed the state of lock:
ffff888021d16568 (&(&info->lock)->rlock){+.+.}, at: spin_lock
include/linux/spinlock.h:338 [inline]
ffff888021d16568 (&(&info->lock)->rlock){+.+.}, at:
shmem_mfill_atomic_pte+0x1012/0x21c0 mm/shmem.c:2407
but this lock was taken by another, SOFTIRQ-safe lock in the past:
 (&(&xa->xa_lock)->rlock#5){..-.}

and interrupts could create inverse lock ordering between them.

other info that might help us debug this:
 Possible interrupt unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  lock(&(&info->lock)->rlock);
                               local_irq_disable();
                               lock(&(&xa->xa_lock)->rlock#5);
                               lock(&(&info->lock)->rlock);
  <Interrupt>
    lock(&(&xa->xa_lock)->rlock#5);

 *** DEADLOCK ***

The full report is quite lengthy, please see:
https://lore.kernel.org/linux-mm/alpine.LSU.2.11.2004152007370.13597@eggly.anvils/T/#m813b412c5f78e25ca8c6c7734886ed4de43f241d

It is because CPU 0 held info->lock with IRQ enabled in userfaultfd_copy
path, then CPU 1 is splitting a THP which held xa_lock and info->lock in
IRQ disabled context at the same time.  If softirq comes in to acquire
xa_lock, the deadlock would be triggered.

The fix is to acquire/release info->lock with *_irq version instead of
plain spin_{lock,unlock} to make it softirq safe.

Link: http://lkml.kernel.org/r/1587061357-122619-1-git-send-email-yang.shi@linux.alibaba.com
Fixes: 4c27fe4c4c84 ("userfaultfd: shmem: add shmem_mcopy_atomic_pte for userfaultfd support")
Signed-off-by: Yang Shi <yang.shi@linux.alibaba.com>
Reported-by: syzbot+e27980339d305f2dbfd9@syzkaller.appspotmail.com
Tested-by: syzbot+e27980339d305f2dbfd9@syzkaller.appspotmail.com
Acked-by: Hugh Dickins <hughd@google.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/shmem.c~mm-shmem-disable-interrupt-when-acquiring-info-lock-in-userfaultfd_copy-path
+++ a/mm/shmem.c
@@ -2402,11 +2402,11 @@ static int shmem_mfill_atomic_pte(struct
 
 	lru_cache_add_anon(page);
 
-	spin_lock(&info->lock);
+	spin_lock_irq(&info->lock);
 	info->alloced++;
 	inode->i_blocks += BLOCKS_PER_PAGE;
 	shmem_recalc_inode(inode);
-	spin_unlock(&info->lock);
+	spin_unlock_irq(&info->lock);
 
 	inc_mm_counter(dst_mm, mm_counter_file(page));
 	page_add_file_rmap(page, false);
_

Patches currently in -mm which might be from yang.shi@linux.alibaba.com are

mm-shmem-disable-interrupt-when-acquiring-info-lock-in-userfaultfd_copy-path.patch
mm-thp-dont-need-drain-lru-cache-when-splitting-and-mlocking-thp.patch
