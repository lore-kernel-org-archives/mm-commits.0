From: akpm@linux-foundation.org
Subject: [patch 4/7] fs/hugetlbfs/inode.c: fix hwpoison reserve accounting
Date: Thu, 02 Nov 2017 15:59:41 -0700
Message-ID: <59fba35d.yRAXI41eWpHYiiqH%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48404 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934614AbdKBW7m (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 2 Nov 2017 18:59:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, mike.kravetz@oracle.com, aneesh.kumar@linux.vnet.ibm.com, khandual@linux.vnet.ibm.com, mhocko@kernel.org, n-horiguchi@ah.jp.nec.com, stable@vger.kernel.org

From: Mike Kravetz <mike.kravetz@oracle.com>
Subject: fs/hugetlbfs/inode.c: fix hwpoison reserve accounting

Calling madvise(MADV_HWPOISON) on a hugetlbfs page will result in bad
(negative) reserved huge page counts.  This may not happen immediately,
but may happen later when the underlying file is removed or filesystem
unmounted.  For example:

AnonHugePages:         0 kB
ShmemHugePages:        0 kB
HugePages_Total:       1
HugePages_Free:        0
HugePages_Rsvd:    18446744073709551615
HugePages_Surp:        0
Hugepagesize:       2048 kB

In routine hugetlbfs_error_remove_page(), hugetlb_fix_reserve_counts is
called after remove_huge_page.  hugetlb_fix_reserve_counts is designed to
only be called/used only if a failure is returned from
hugetlb_unreserve_pages.  Therefore, call hugetlb_unreserve_pages as
required and only call hugetlb_fix_reserve_counts in the unlikely event
that hugetlb_unreserve_pages returns an error.

Link: http://lkml.kernel.org/r/20171019230007.17043-2-mike.kravetz@oracle.com
Fixes: 78bb920344b8 ("mm: hwpoison: dissolve in-use hugepage in unrecoverable memory error")
Signed-off-by: Mike Kravetz <mike.kravetz@oracle.com>
Acked-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Aneesh Kumar <aneesh.kumar@linux.vnet.ibm.com>
Cc: Anshuman Khandual <khandual@linux.vnet.ibm.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hugetlbfs/inode.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff -puN fs/hugetlbfs/inode.c~mm-hugetlbfs-fix-hwpoison-reserve-accounting fs/hugetlbfs/inode.c
--- a/fs/hugetlbfs/inode.c~mm-hugetlbfs-fix-hwpoison-reserve-accounting
+++ a/fs/hugetlbfs/inode.c
@@ -842,9 +842,12 @@ static int hugetlbfs_error_remove_page(s
 				struct page *page)
 {
 	struct inode *inode = mapping->host;
+	pgoff_t index = page->index;
 
 	remove_huge_page(page);
-	hugetlb_fix_reserve_counts(inode);
+	if (unlikely(hugetlb_unreserve_pages(inode, index, index + 1, 1)))
+		hugetlb_fix_reserve_counts(inode);
+
 	return 0;
 }
 
_
