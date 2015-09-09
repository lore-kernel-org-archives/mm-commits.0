From: akpm@linux-foundation.org
Subject: [merged] mm-madvise-allow-remove-operation-for-hugetlbfs.patch
 removed from -mm tree
Date: Wed, 09 Sep 2015 12:46:32 -0700
Message-ID: <55f08c98.AGjkcOjM+UemvS0j%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39208 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751390AbbIITqd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 Sep 2015 15:46:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mike.kravetz@oracle.com, aneesh.kumar@linux.vnet.ibm.com, dave.hansen@linux.intel.com, dave@stgolabs.net, hch@infradead.org, hillf.zj@alibaba-inc.com, hughd@google.com, mhocko@suse.cz, n-horiguchi@ah.jp.nec.com, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: madvise allow remove operation for hugetlbfs
has been removed from the -mm tree.  Its filename was
     mm-madvise-allow-remove-operation-for-hugetlbfs.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Mike Kravetz <mike.kravetz@oracle.com>
Subject: mm: madvise allow remove operation for hugetlbfs

Now that we have hole punching support for hugetlbfs, we can
also support the MADV_REMOVE interface to it.

Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Signed-off-by: Mike Kravetz <mike.kravetz@oracle.com>
Reviewed-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Acked-by: Hillf Danton <hillf.zj@alibaba-inc.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: Aneesh Kumar <aneesh.kumar@linux.vnet.ibm.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Michal Hocko <mhocko@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/madvise.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/madvise.c~mm-madvise-allow-remove-operation-for-hugetlbfs mm/madvise.c
--- a/mm/madvise.c~mm-madvise-allow-remove-operation-for-hugetlbfs
+++ a/mm/madvise.c
@@ -301,7 +301,7 @@ static long madvise_remove(struct vm_are
 
 	*prev = NULL;	/* tell sys_madvise we drop mmap_sem */
 
-	if (vma->vm_flags & (VM_LOCKED | VM_HUGETLB))
+	if (vma->vm_flags & VM_LOCKED)
 		return -EINVAL;
 
 	f = vma->vm_file;
_

Patches currently in -mm which might be from mike.kravetz@oracle.com are


