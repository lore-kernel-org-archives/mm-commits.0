From: akpm@linux-foundation.org
Subject: +
 ksm-fix-conflict-between-mmput-and-scan_get_next_rmap_item-v4.patch added
 to -mm tree
Date: Mon, 09 May 2016 14:43:51 -0700
Message-ID: <57310497.xnrKskBWDYlwD4Nh%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55702 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752987AbcEIVnw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 May 2016 17:43:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: zhouchengming1@huawei.com, aarcange@redhat.com, dingtianhong@huawei.com, geliangtang@163.com, guohanjun@huawei.com, huawei.libin@huawei.com, hughd@google.com, kirill.shutemov@linux.intel.com, minchan@kernel.org, qiuxishi@huawei.com, thunder.leizhen@huawei.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: ksm: fix conflict between mmput and scan_get_next_rmap_item
has been added to the -mm tree.  Its filename is
     ksm-fix-conflict-between-mmput-and-scan_get_next_rmap_item-v4.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ksm-fix-conflict-between-mmput-and-scan_get_next_rmap_item-v4.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ksm-fix-conflict-between-mmput-and-scan_get_next_rmap_item-v4.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Zhou Chengming <zhouchengming1@huawei.com>
Subject: ksm: fix conflict between mmput and scan_get_next_rmap_item

A concurrency issue about KSM in the function scan_get_next_rmap_item.

task A (ksmd):				|task B (the mm's task):
					|
mm = slot->mm;				|
down_read(&mm->mmap_sem);		|
					|
...					|
					|
spin_lock(&ksm_mmlist_lock);		|
					|
ksm_scan.mm_slot go to the next slot;	|
					|
spin_unlock(&ksm_mmlist_lock);		|
					|mmput() ->
					|	ksm_exit():
					|
					|spin_lock(&ksm_mmlist_lock);
					|if (mm_slot && ksm_scan.mm_slot != mm_slot) {
					|	if (!mm_slot->rmap_list) {
					|		easy_to_free = 1;
					|		...
					|
					|if (easy_to_free) {
					|	mmdrop(mm);
					|	...
					|
					|So this mm_struct may be freed in the mmput().
					|
up_read(&mm->mmap_sem);			|

As we can see above, the ksmd thread may access a mm_struct that already
been freed to the kmem_cache.  Suppose a fork will get this mm_struct from
the kmem_cache, the ksmd thread then call up_read(&mm->mmap_sem), will
cause mmap_sem.count to become -1.

As suggested by Andrea Arcangeli, unmerge_and_remove_all_rmap_items has
the same SMP race condition, so fix it too.  My prev fix in function
scan_get_next_rmap_item will introduce a different SMP race condition, so
just invert the up_read/spin_unlock order as Andrea Arcangeli said.

Link: http://lkml.kernel.org/r/1462708815-31301-1-git-send-email-zhouchengming1@huawei.com
Signed-off-by: Zhou Chengming <zhouchengming1@huawei.com>
Suggested-by: Andrea Arcangeli <aarcange@redhat.com>
Reviewed-by: Andrea Arcangeli <aarcange@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Geliang Tang <geliangtang@163.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Hanjun Guo <guohanjun@huawei.com>
Cc: Ding Tianhong <dingtianhong@huawei.com>
Cc: Li Bin <huawei.libin@huawei.com>
Cc: Zhen Lei <thunder.leizhen@huawei.com>
Cc: Xishi Qiu <qiuxishi@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/ksm.c |   15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff -puN mm/ksm.c~ksm-fix-conflict-between-mmput-and-scan_get_next_rmap_item-v4 mm/ksm.c
--- a/mm/ksm.c~ksm-fix-conflict-between-mmput-and-scan_get_next_rmap_item-v4
+++ a/mm/ksm.c
@@ -783,6 +783,7 @@ static int unmerge_and_remove_all_rmap_i
 		}
 
 		remove_trailing_rmap_items(mm_slot, &mm_slot->rmap_list);
+		up_read(&mm->mmap_sem);
 
 		spin_lock(&ksm_mmlist_lock);
 		ksm_scan.mm_slot = list_entry(mm_slot->mm_list.next,
@@ -794,12 +795,9 @@ static int unmerge_and_remove_all_rmap_i
 
 			free_mm_slot(mm_slot);
 			clear_bit(MMF_VM_MERGEABLE, &mm->flags);
-			up_read(&mm->mmap_sem);
 			mmdrop(mm);
-		} else {
+		} else
 			spin_unlock(&ksm_mmlist_lock);
-			up_read(&mm->mmap_sem);
-		}
 	}
 
 	/* Clean up stable nodes, but don't worry if some are still busy */
@@ -1663,8 +1661,15 @@ next_mm:
 		up_read(&mm->mmap_sem);
 		mmdrop(mm);
 	} else {
-		spin_unlock(&ksm_mmlist_lock);
 		up_read(&mm->mmap_sem);
+		/*
+		 * up_read(&mm->mmap_sem) first because after
+		 * spin_unlock(&ksm_mmlist_lock) run, the "mm" may
+		 * already have been freed under us by __ksm_exit()
+		 * because the "mm_slot" is still hashed and
+		 * ksm_scan.mm_slot doesn't point to it anymore.
+		 */
+		spin_unlock(&ksm_mmlist_lock);
 	}
 
 	/* Repeat until we've completed scanning the whole list */
_

Patches currently in -mm which might be from zhouchengming1@huawei.com are

ksm-fix-conflict-between-mmput-and-scan_get_next_rmap_item-v4.patch

