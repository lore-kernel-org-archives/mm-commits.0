From: akpm@linux-foundation.org
Subject: [merged] hugetlb-fix-race-condition-in-hugetlb_fault.patch removed from -mm tree
Date: Mon, 16 Apr 2012 13:15:38 -0700
Message-ID: <20120416201538.91D9FA0308@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-we0-f202.google.com ([74.125.82.202]:53968 "EHLO
	mail-we0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752381Ab2DPUPl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 16 Apr 2012 16:15:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: cmetcalf@tilera.com, dhillf@gmail.com, hughd@google.com, kamezawa.hiroyu@jp.fujitsu.com, mhocko@suse.cz, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: hugetlb: fix race condition in hugetlb_fault()
has been removed from the -mm tree.  Its filename was
     hugetlb-fix-race-condition-in-hugetlb_fault.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Chris Metcalf <cmetcalf@tilera.com>
Subject: hugetlb: fix race condition in hugetlb_fault()

The race is as follows.

Suppose a multi-threaded task forks a new process (on cpu A), thus bumping
up the ref count on all the pages.  While the fork is occurring (and thus
we have marked all the PTEs as read-only), another thread in the original
process (on cpu B) tries to write to a huge page, taking an access
violation from the write-protect and calling hugetlb_cow().  Now, suppose
the fork() fails.  It will undo the COW and decrement the ref count on the
pages, so the ref count on the huge page drops back to 1.  Meanwhile
hugetlb_cow() also decrements the ref count by one on the original page,
since the original address space doesn't need it any more, having copied a
new page to replace the original page.  This leaves the ref count at zero,
and when we call unlock_page(), we panic.

	fork on CPU A				fault on CPU B
	=============				==============
	...
	down_write(&parent->mmap_sem);
	down_write_nested(&child->mmap_sem);
	...
	while duplicating vmas
		if error
			break;
	...
	up_write(&child->mmap_sem);
	up_write(&parent->mmap_sem);		...
						down_read(&parent->mmap_sem);
						...
						lock_page(page);
						handle COW
						page_mapcount(old_page) == 2
						alloc and prepare new_page
	...
	handle error
	page_remove_rmap(page);
	put_page(page);
	...
						fold new_page into pte
						page_remove_rmap(page);
						put_page(page);
						...
				oops ==>	unlock_page(page);
						up_read(&parent->mmap_sem);

The solution is to take an extra reference to the page while we are
holding the lock on it.

Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
Cc: Hillf Danton <dhillf@gmail.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN mm/hugetlb.c~hugetlb-fix-race-condition-in-hugetlb_fault mm/hugetlb.c
--- a/mm/hugetlb.c~hugetlb-fix-race-condition-in-hugetlb_fault
+++ a/mm/hugetlb.c
@@ -2791,6 +2791,7 @@ int hugetlb_fault(struct mm_struct *mm, 
 	 * so no worry about deadlock.
 	 */
 	page = pte_page(entry);
+	get_page(page);
 	if (page != pagecache_page)
 		lock_page(page);
 
@@ -2822,6 +2823,7 @@ out_page_table_lock:
 	}
 	if (page != pagecache_page)
 		unlock_page(page);
+	put_page(page);
 
 out_mutex:
 	mutex_unlock(&hugetlb_instantiation_mutex);
_

Patches currently in -mm which might be from cmetcalf@tilera.com are

linux-next.patch
list_debug-warn-for-adding-something-already-in-the-list.patch
c-r-ipc-message-queue-receive-cleanup.patch
c-r-ipc-message-queue-stealing-feature-introduced.patch

