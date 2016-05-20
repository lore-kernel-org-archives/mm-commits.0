From: akpm@linux-foundation.org
Subject: [merged] arm64-mm-use-hugetlb_bad_size.patch removed from -mm
 tree
Date: Fri, 20 May 2016 14:04:10 -0700
Message-ID: <573f7bca.+qUj+r5XPce7dPzt%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46947 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751065AbcETVEL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 20 May 2016 17:04:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vaishali.thakkar@oracle.com, baiyaowei@cmss.chinamobile.com, dave.hansen@linux.intel.com, dingel@linux.vnet.ibm.com, hillf.zj@alibaba-inc.com, kirill.shutemov@linux.intel.com, mhocko@suse.com, mike.kravetz@oracle.com, n-horiguchi@ah.jp.nec.com, paul.gortmaker@windriver.com, mm-commits@vger.kernel.org


The patch titled
     Subject: arm64: mm: use hugetlb_bad_size()
has been removed from the -mm tree.  Its filename was
     arm64-mm-use-hugetlb_bad_size.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Vaishali Thakkar <vaishali.thakkar@oracle.com>
Subject: arm64: mm: use hugetlb_bad_size()

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

 arch/arm64/mm/hugetlbpage.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN arch/arm64/mm/hugetlbpage.c~arm64-mm-use-hugetlb_bad_size arch/arm64/mm/hugetlbpage.c
--- a/arch/arm64/mm/hugetlbpage.c~arm64-mm-use-hugetlb_bad_size
+++ a/arch/arm64/mm/hugetlbpage.c
@@ -307,6 +307,7 @@ static __init int setup_hugepagesz(char
 	} else if (ps == PUD_SIZE) {
 		hugetlb_add_hstate(PUD_SHIFT - PAGE_SHIFT);
 	} else {
+		hugetlb_bad_size();
 		pr_err("hugepagesz: Unsupported page size %lu K\n", ps >> 10);
 		return 0;
 	}
_

Patches currently in -mm which might be from vaishali.thakkar@oracle.com are


