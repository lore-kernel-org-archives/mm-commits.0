From: akpm@linux-foundation.org
Subject: +
 mm-hugetlb-unmap-pages-to-remove-if-page-fault-raced-with-hole-punch-fix.patch added to -mm tree
Date: Thu, 22 Oct 2015 13:13:15 -0700
Message-ID: <5629435b.p31/tBCFe4Sz91qv%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40454 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757964AbbJVUNQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 22 Oct 2015 16:13:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mike.kravetz@oracle.com, dave.hansen@linux.intel.com, dave@stgolabs.net, hughd@google.com, n-horiguchi@ah.jp.nec.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/hugetlb: i_mmap_lock_write before unmapping in remove_inode_hugepages
has been added to the -mm tree.  Its filename is
     mm-hugetlb-unmap-pages-to-remove-if-page-fault-raced-with-hole-punch-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-hugetlb-unmap-pages-to-remove-if-page-fault-raced-with-hole-punch-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-hugetlb-unmap-pages-to-remove-if-page-fault-raced-with-hole-punch-fix.patch

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
Subject: mm/hugetlb: i_mmap_lock_write before unmapping in remove_inode_hugepages

Code was added to remove_inode_hugepages that will unmap a page if it is
mapped.  i_mmap_lock_write() must be taken during the call to
hugetlb_vmdelete_list().  This is to prevent mappings(vmas) from being
added or deleted while the list of vmas is being examined.

Signed-off-by: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hugetlbfs/inode.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN fs/hugetlbfs/inode.c~mm-hugetlb-unmap-pages-to-remove-if-page-fault-raced-with-hole-punch-fix fs/hugetlbfs/inode.c
--- a/fs/hugetlbfs/inode.c~mm-hugetlb-unmap-pages-to-remove-if-page-fault-raced-with-hole-punch-fix
+++ a/fs/hugetlbfs/inode.c
@@ -428,9 +428,11 @@ static void remove_inode_hugepages(struc
 			 * until we finish removing the page.
 			 */
 			if (page_mapped(page)) {
+				i_mmap_lock_write(mapping);
 				hugetlb_vmdelete_list(&mapping->i_mmap,
 					next * pages_per_huge_page(h),
 					(next + 1) * pages_per_huge_page(h));
+				i_mmap_unlock_write(mapping);
 			}
 
 			lock_page(page);
_

Patches currently in -mm which might be from mike.kravetz@oracle.com are

mm-hugetlb-define-hugetlb_falloc-structure-for-hole-punch-race.patch
mm-hugetlb-setup-hugetlb_falloc-during-fallocate-hole-punch.patch
mm-hugetlb-page-faults-check-for-fallocate-hole-punch-in-progress-and-wait.patch
mm-hugetlb-unmap-pages-to-remove-if-page-fault-raced-with-hole-punch.patch
mm-hugetlb-unmap-pages-to-remove-if-page-fault-raced-with-hole-punch-fix.patch

