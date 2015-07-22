From: akpm@linux-foundation.org
Subject: + mm-madvise-allow-remove-operation-for-hugetlbfs.patch added to
 -mm tree
Date: Wed, 22 Jul 2015 15:07:40 -0700
Message-ID: <55b0142c.bjcq8w6DKHOTEz//%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50941 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752921AbbGVWHl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 22 Jul 2015 18:07:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mike.kravetz@oracle.com, aneesh.kumar@linux.vnet.ibm.com, dave.hansen@linux.intel.com, dave@stgolabs.net, hch@infradead.org, hillf.zj@alibaba-inc.com, hughd@google.com, mhocko@suse.cz, n-horiguchi@ah.jp.nec.com, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: madvise allow remove operation for hugetlbfs
has been added to the -mm tree.  Its filename is
     mm-madvise-allow-remove-operation-for-hugetlbfs.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-madvise-allow-remove-operation-for-hugetlbfs.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-madvise-allow-remove-operation-for-hugetlbfs.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
 
-	if (vma->vm_flags & (VM_LOCKED | VM_LOCKONFAULT | VM_HUGETLB))
+	if (vma->vm_flags & (VM_LOCKED | VM_LOCKONFAULT))
 		return -EINVAL;
 
 	f = vma->vm_file;
_

Patches currently in -mm which might be from mike.kravetz@oracle.com are

hugetlb-make-the-function-vma_shareable-bool.patch
mm-hugetlb-add-cache-of-descriptors-to-resv_map-for-region_add.patch
mm-hugetlb-add-cache-of-descriptors-to-resv_map-for-region_add-fix.patch
mm-hugetlb-add-region_del-to-delete-a-specific-range-of-entries.patch
mm-hugetlb-expose-hugetlb-fault-mutex-for-use-by-fallocate.patch
hugetlbfs-hugetlb_vmtruncate_list-needs-to-take-a-range-to-delete.patch
hugetlbfs-truncate_hugepages-takes-a-range-of-pages.patch
mm-hugetlb-vma_has_reserves-needs-to-handle-fallocate-hole-punch.patch
mm-hugetlb-alloc_huge_page-handle-areas-hole-punched-by-fallocate.patch
hugetlbfs-new-huge_add_to_page_cache-helper-routine.patch
hugetlbfs-add-hugetlbfs_fallocate.patch
mm-madvise-allow-remove-operation-for-hugetlbfs.patch

