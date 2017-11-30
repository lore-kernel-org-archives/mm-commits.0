From: akpm@linux-foundation.org
Subject: [patch 28/28] fs/hugetlbfs/inode.c: change put_page/unlock_page
 order in hugetlbfs_fallocate()
Date: Wed, 29 Nov 2017 16:11:33 -0800
Message-ID: <5a1f4cb5.wTXWqxdXrw55oZ7x%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60850 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753474AbdK3ALg (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 29 Nov 2017 19:11:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, namit@vmware.com, ebiggers3@gmail.com, mhocko@suse.com, mike.kravetz@oracle.com

From: Nadav Amit <namit@vmware.com>
Subject: fs/hugetlbfs/inode.c: change put_page/unlock_page order in hugetlbfs_fallocate()

hugetlfs_fallocate() currently performs put_page() before unlock_page(). 
This scenario opens a small time window, from the time the page is added
to the page cache, until it is unlocked, in which the page might be
removed from the page-cache by another core.  If the page is removed
during this time windows, it might cause a memory corruption, as the wrong
page will be unlocked.

It is arguable whether this scenario can happen in a real system, and
there are several mitigating factors.  The issue was found by code
inspection (actually grep), and not by actually triggering the flow.  Yet,
since putting the page before unlocking is incorrect it should be fixed,
if only to prevent future breakage or someone copy-pasting this code.

Mike said:

I am of the opinion that this does not need to be sent to stable. 
Although the ordering is current code is incorrect, there is no way for
this to be a problem with current locking.  In addition, I verified that
the perhaps bigger issue with sys_fadvise64(POSIX_FADV_DONTNEED) for
hugetlbfs and other filesystems is addressed in 3a77d214807c ("mm:
fadvise: avoid fadvise for fs without backing device").

Link: http://lkml.kernel.org/r/20170826191124.51642-1-namit@vmware.com
Fixes: 70c3547e36f5c ("hugetlbfs: add hugetlbfs_fallocate()")
Signed-off-by: Nadav Amit <namit@vmware.com>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Eric Biggers <ebiggers3@gmail.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hugetlbfs/inode.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN fs/hugetlbfs/inode.c~hugetlbfs-change-put_page-unlock_page-order-in-hugetlbfs_fallocate fs/hugetlbfs/inode.c
--- a/fs/hugetlbfs/inode.c~hugetlbfs-change-put_page-unlock_page-order-in-hugetlbfs_fallocate
+++ a/fs/hugetlbfs/inode.c
@@ -639,11 +639,11 @@ static long hugetlbfs_fallocate(struct f
 		mutex_unlock(&hugetlb_fault_mutex_table[hash]);
 
 		/*
-		 * page_put due to reference from alloc_huge_page()
 		 * unlock_page because locked by add_to_page_cache()
+		 * page_put due to reference from alloc_huge_page()
 		 */
-		put_page(page);
 		unlock_page(page);
+		put_page(page);
 	}
 
 	if (!(mode & FALLOC_FL_KEEP_SIZE) && offset + len > inode->i_size)
_
