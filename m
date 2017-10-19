From: akpm@linux-foundation.org
Subject: + mm-hugetlbfs-fix-hwpoison-reserve-accounting.patch added to -mm tree
Date: Thu, 19 Oct 2017 16:07:16 -0700
Message-ID: <59e93024.Gss+lvjoXSieC/B/%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58078 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750968AbdJSXHS (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 19 Oct 2017 19:07:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mike.kravetz@oracle.com, aneesh.kumar@linux.vnet.ibm.com, khandual@linux.vnet.ibm.com, mhocko@kernel.org, n-horiguchi@ah.jp.nec.com, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/hugetlbfs/inode.c: fix hwpoison reserve accounting
has been added to the -mm tree.  Its filename is
     mm-hugetlbfs-fix-hwpoison-reserve-accounting.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-hugetlbfs-fix-hwpoison-reserve-accounting.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-hugetlbfs-fix-hwpoison-reserve-accounting.patch

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
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
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
@@ -841,9 +841,12 @@ static int hugetlbfs_error_remove_page(s
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

Patches currently in -mm which might be from mike.kravetz@oracle.com are

mm-hugetlbfs-fix-hwpoison-reserve-accounting.patch

