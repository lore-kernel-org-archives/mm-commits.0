From: akpm@linux-foundation.org
Subject: [to-be-updated]
 ksm-fix-conflict-between-mmput-and-scan_get_next_rmap_item.patch removed
 from -mm tree
Date: Mon, 09 May 2016 14:43:09 -0700
Message-ID: <5731046d.VLLVs+TSb+yeUI2B%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55689 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752341AbcEIVnL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 May 2016 17:43:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: zhouchengming1@huawei.com, aarcange@redhat.com, dingtianhong@huawei.com, geliangtang@163.com, guohanjun@huawei.com, huawei.libin@huawei.com, hughd@google.com, kirill.shutemov@linux.intel.com, minchan@kernel.org, qiuxishi@huawei.com, thunder.leizhen@huawei.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: ksm: fix conflict between mmput and scan_get_next_rmap_item
has been removed from the -mm tree.  Its filename was
     ksm-fix-conflict-between-mmput-and-scan_get_next_rmap_item.patch

This patch was dropped because an updated version will be merged

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
|So this mm_struct will be freed successfully.
|
up_read(&mm->mmap_sem);			|

As we can see above, the ksmd thread may access a mm_struct that has already
been freed to the kmem_cache.  Suppose a fork will get this mm_struct from
the kmem_cache, the ksmd thread then calls up_read(&mm->mmap_sem) and will
cause mmap_sem.count to become -1.

Link: http://lkml.kernel.org/r/1462452176-33462-1-git-send-email-zhouchengming1@huawei.com
Signed-off-by: Zhou Chengming <zhouchengming1@huawei.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
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

 mm/ksm.c |    7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff -puN mm/ksm.c~ksm-fix-conflict-between-mmput-and-scan_get_next_rmap_item mm/ksm.c
--- a/mm/ksm.c~ksm-fix-conflict-between-mmput-and-scan_get_next_rmap_item
+++ a/mm/ksm.c
@@ -1640,6 +1640,7 @@ next_mm:
 	 * because there were no VM_MERGEABLE vmas with such addresses.
 	 */
 	remove_trailing_rmap_items(slot, ksm_scan.rmap_list);
+	up_read(&mm->mmap_sem);
 
 	spin_lock(&ksm_mmlist_lock);
 	ksm_scan.mm_slot = list_entry(slot->mm_list.next,
@@ -1656,16 +1657,12 @@ next_mm:
 		 */
 		hash_del(&slot->link);
 		list_del(&slot->mm_list);
-		spin_unlock(&ksm_mmlist_lock);
 
 		free_mm_slot(slot);
 		clear_bit(MMF_VM_MERGEABLE, &mm->flags);
-		up_read(&mm->mmap_sem);
 		mmdrop(mm);
-	} else {
-		spin_unlock(&ksm_mmlist_lock);
-		up_read(&mm->mmap_sem);
 	}
+	spin_unlock(&ksm_mmlist_lock);
 
 	/* Repeat until we've completed scanning the whole list */
 	slot = ksm_scan.mm_slot;
_

Patches currently in -mm which might be from zhouchengming1@huawei.com are

ksm-fix-conflict-between-mmput-and-scan_get_next_rmap_item-v4.patch

