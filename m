From: akpm@linux-foundation.org
Subject: [patch 047/117] tile: mm: use hugetlb_bad_size()
Date: Thu, 19 May 2016 17:11:17 -0700
Message-ID: <573e5625.JT7XErOh83XNB/s5%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46157 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755498AbcETALX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 19 May 2016 20:11:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, vaishali.thakkar@oracle.com, baiyaowei@cmss.chinamobile.com, dave.hansen@linux.intel.com, dingel@linux.vnet.ibm.com, hillf.zj@alibaba-inc.com, james.hogan@imgtec.com, kirill.shutemov@linux.intel.com, mhocko@suse.com, mike.kravetz@oracle.com, n-horiguchi@ah.jp.nec.com, paul.gortmaker@windriver.com

From: Vaishali Thakkar <vaishali.thakkar@oracle.com>
Subject: tile: mm: use hugetlb_bad_size()

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
Cc: James Hogan <james.hogan@imgtec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/tile/mm/hugetlbpage.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff -puN arch/tile/mm/hugetlbpage.c~tile-mm-use-hugetlb_bad_size arch/tile/mm/hugetlbpage.c
--- a/arch/tile/mm/hugetlbpage.c~tile-mm-use-hugetlb_bad_size
+++ a/arch/tile/mm/hugetlbpage.c
@@ -308,11 +308,16 @@ static bool saw_hugepagesz;
 
 static __init int setup_hugepagesz(char *opt)
 {
+	int rc;
+
 	if (!saw_hugepagesz) {
 		saw_hugepagesz = true;
 		memset(huge_shift, 0, sizeof(huge_shift));
 	}
-	return __setup_hugepagesz(memparse(opt, NULL));
+	rc = __setup_hugepagesz(memparse(opt, NULL));
+	if (rc)
+		hugetlb_bad_size();
+	return rc;
 }
 __setup("hugepagesz=", setup_hugepagesz);
 
_
