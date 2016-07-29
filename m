From: akpm@linux-foundation.org
Subject: + mm-hugetlb-avoid-soft-lockup-in-set_max_huge_pages.patch added
 to -mm tree
Date: Fri, 29 Jul 2016 16:15:16 -0700
Message-ID: <579be384.mToMrTRy2xwxCdEh%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41288 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752032AbcG2XPR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 29 Jul 2016 19:15:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hejianet@gmail.com, dave.hansen@linux.intel.com, kirill.shutemov@linux.intel.com, mhocko@suse.com, mike.kravetz@oracle.com, n-horiguchi@ah.jp.nec.com, paul.gortmaker@windriver.com, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/hugetlb: avoid soft lockup in set_max_huge_pages()
has been added to the -mm tree.  Its filename is
     mm-hugetlb-avoid-soft-lockup-in-set_max_huge_pages.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-hugetlb-avoid-soft-lockup-in-set_max_huge_pages.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-hugetlb-avoid-soft-lockup-in-set_max_huge_pages.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Jia He <hejianet@gmail.com>
Subject: mm/hugetlb: avoid soft lockup in set_max_huge_pages()

In powerpc servers with large memory(32TB), we watched several soft
lockups for hugepage under stress tests.

The call traces are as follows:
1.
get_page_from_freelist+0x2d8/0xd50
__alloc_pages_nodemask+0x180/0xc20
alloc_fresh_huge_page+0xb0/0x190
set_max_huge_pages+0x164/0x3b0

2.
prep_new_huge_page+0x5c/0x100
alloc_fresh_huge_page+0xc8/0x190
set_max_huge_pages+0x164/0x3b0

This patch fixes such soft lockups.  It is safe to call cond_resched()
there because it is out of spin_lock/unlock section.

Link: http://lkml.kernel.org/r/1469674442-14848-1-git-send-email-hejianet@gmail.com
Signed-off-by: Jia He <hejianet@gmail.com>
Reviewed-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Acked-by: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN mm/hugetlb.c~mm-hugetlb-avoid-soft-lockup-in-set_max_huge_pages mm/hugetlb.c
--- a/mm/hugetlb.c~mm-hugetlb-avoid-soft-lockup-in-set_max_huge_pages
+++ a/mm/hugetlb.c
@@ -2216,6 +2216,10 @@ static unsigned long set_max_huge_pages(
 		 * and reducing the surplus.
 		 */
 		spin_unlock(&hugetlb_lock);
+
+		/* yield cpu to avoid soft lockup */
+		cond_resched();
+
 		if (hstate_is_gigantic(h))
 			ret = alloc_fresh_gigantic_page(h, nodes_allowed);
 		else
_

Patches currently in -mm which might be from hejianet@gmail.com are

mm-hugetlb-avoid-soft-lockup-in-set_max_huge_pages.patch

