From: akpm@linux-foundation.org
Subject: + metag-mm-use-hugetlb_bad_size.patch added to -mm tree
Date: Mon, 28 Mar 2016 16:05:54 -0700
Message-ID: <56f9b8d2.iRmFHC/8aviQbFNG%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58207 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752562AbcC1XF4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 28 Mar 2016 19:05:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vaishali.thakkar@oracle.com, baiyaowei@cmss.chinamobile.com, dave.hansen@linux.intel.com, dingel@linux.vnet.ibm.com, hillf.zj@alibaba-inc.com, kirill.shutemov@linux.intel.com, mhocko@suse.com, mike.kravetz@oracle.com, n-horiguchi@ah.jp.nec.com, paul.gortmaker@windriver.com, mm-commits@vger.kernel.org


The patch titled
     Subject: metag: mm: use hugetlb_bad_size()
has been added to the -mm tree.  Its filename is
     metag-mm-use-hugetlb_bad_size.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/metag-mm-use-hugetlb_bad_size.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/metag-mm-use-hugetlb_bad_size.patch

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

mm-hugetlb-introduce-hugetlb_bad_size.patch
arm64-mm-use-hugetlb_bad_size.patch
metag-mm-use-hugetlb_bad_size.patch
powerpc-mm-use-hugetlb_bad_size.patch
tile-mm-use-hugetlb_bad_size.patch
x86-mm-use-hugetlb_bad_size.patch

