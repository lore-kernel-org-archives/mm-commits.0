From: akpm@linux-foundation.org
Subject: + powerpc-mm-use-hugetlb_bad_size.patch added to -mm tree
Date: Mon, 28 Mar 2016 16:05:56 -0700
Message-ID: <56f9b8d4.8mK2ohhISFcTjlxy%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58213 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752562AbcC1XF5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 28 Mar 2016 19:05:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vaishali.thakkar@oracle.com, baiyaowei@cmss.chinamobile.com, benh@kernel.crashing.org, dave.hansen@linux.intel.com, dingel@linux.vnet.ibm.com, hillf.zj@alibaba-inc.com, kirill.shutemov@linux.intel.com, mhocko@suse.com, mike.kravetz@oracle.com, n-horiguchi@ah.jp.nec.com, paul.gortmaker@windriver.com, mm-commits@vger.kernel.org


The patch titled
     Subject: powerpc: mm: use hugetlb_bad_size()
has been added to the -mm tree.  Its filename is
     powerpc-mm-use-hugetlb_bad_size.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/powerpc-mm-use-hugetlb_bad_size.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/powerpc-mm-use-hugetlb_bad_size.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Vaishali Thakkar <vaishali.thakkar@oracle.com>
Subject: powerpc: mm: use hugetlb_bad_size()

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
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/mm/hugetlbpage.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff -puN arch/powerpc/mm/hugetlbpage.c~powerpc-mm-use-hugetlb_bad_size arch/powerpc/mm/hugetlbpage.c
--- a/arch/powerpc/mm/hugetlbpage.c~powerpc-mm-use-hugetlb_bad_size
+++ a/arch/powerpc/mm/hugetlbpage.c
@@ -772,8 +772,10 @@ static int __init hugepage_setup_sz(char
 
 	size = memparse(str, &str);
 
-	if (add_huge_page_size(size) != 0)
-		printk(KERN_WARNING "Invalid huge page size specified(%llu)\n", size);
+	if (add_huge_page_size(size) != 0) {
+		hugetlb_bad_size();
+		pr_err("Invalid huge page size specified(%llu)\n", size);
+	}
 
 	return 1;
 }
_

Patches currently in -mm which might be from vaishali.thakkar@oracle.com are

mm-hugetlb-introduce-hugetlb_bad_size.patch
arm64-mm-use-hugetlb_bad_size.patch
metag-mm-use-hugetlb_bad_size.patch
powerpc-mm-use-hugetlb_bad_size.patch
tile-mm-use-hugetlb_bad_size.patch
x86-mm-use-hugetlb_bad_size.patch

