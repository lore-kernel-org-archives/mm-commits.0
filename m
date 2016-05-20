From: akpm@linux-foundation.org
Subject: [merged] metag-mm-use-hugetlb_bad_size.patch removed from -mm
 tree
Date: Fri, 20 May 2016 14:04:13 -0700
Message-ID: <573f7bcd.rvWfqJLcjM+ApCNz%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46956 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751065AbcETVEO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 20 May 2016 17:04:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vaishali.thakkar@oracle.com, baiyaowei@cmss.chinamobile.com, dave.hansen@linux.intel.com, dingel@linux.vnet.ibm.com, hillf.zj@alibaba-inc.com, kirill.shutemov@linux.intel.com, mhocko@suse.com, mike.kravetz@oracle.com, n-horiguchi@ah.jp.nec.com, paul.gortmaker@windriver.com, mm-commits@vger.kernel.org


The patch titled
     Subject: metag: mm: use hugetlb_bad_size()
has been removed from the -mm tree.  Its filename was
     metag-mm-use-hugetlb_bad_size.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Vaishali Thakkar <vaishali.thakkar@oracle.com>
Subject: metag: mm: use hugetlb_bad_size()

Update setup_hugepagesz() to call hugetlb_bad_size() when unsupported
hugepage size is found.

Signed-off-by: Vaishali Thakkar <vaishali.thakkar@oracle.com>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Reviewed-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Hillf Danton <hillf.zj@alibaba-inc.com>
Cc: Yaowei Bai <baiyaowei@cmss.chinamobile.com>
Cc: Dominik Dingel <dingel@linux.vnet.ibm.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/metag/mm/hugetlbpage.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN arch/metag/mm/hugetlbpage.c~metag-mm-use-hugetlb_bad_size arch/metag/mm/hugetlbpage.c
--- a/arch/metag/mm/hugetlbpage.c~metag-mm-use-hugetlb_bad_size
+++ a/arch/metag/mm/hugetlbpage.c
@@ -239,6 +239,7 @@ static __init int setup_hugepagesz(char
 	if (ps == (1 << HPAGE_SHIFT)) {
 		hugetlb_add_hstate(HPAGE_SHIFT - PAGE_SHIFT);
 	} else {
+		hugetlb_bad_size();
 		pr_err("hugepagesz: Unsupported page size %lu M\n",
 		       ps >> 20);
 		return 0;
_

Patches currently in -mm which might be from vaishali.thakkar@oracle.com are


